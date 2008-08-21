unit mplayer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, playerclass, process, debug, functions;

type

  { TMPlayerClass }

  TMPlayerClass = class(TPlayerClass)
   Private
     FMPlayerPath: string;
     MPlayerProcess: TProcess;
     FLastGet_Pos: integer;
     procedure SendCommand(cmd:string);
     function GetProcessOutput:string;
     function GetMPlayerPlaying: boolean;
   Public
     constructor create; override;
     destructor destroy;

     function play(index:integer):byte;override;
     function play(url: string):byte;override;
     procedure pause;override;
     procedure stop;override;
     function next_track:byte;override;
     function prev_track:byte;override;

     function Get_Stream_Status:TStreamStatus;override;

     function Get_TrackLength:longint;override;
     function Get_Time:longint;override;
     function Get_TimeStr:string;override;
     function Get_TimeRemainingStr: string; override;

     function Get_FilePosition:longint;override;
     function get_FileLength:longint;override;

     procedure Set_Time(ms: longint);override;
     procedure Set_FilePosition(fpos:longint);override;
     procedure Set_Volume(vol:byte);override;

     procedure Mute;override;
     function Muted:boolean;override;
     
     property playing: boolean read GetMPlayerPlaying;

  end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

var mplayerobj: TMPlayerClass;

implementation

{$ifdef linux}
const MPLAYER_BINARY='mplayer';
{$endif}
{$ifdef windows}
const MPLAYER_BINARY='mplayer.exe';
{$endif}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TMPlayerClass }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TMPlayerClass.SendCommand(cmd: string);
begin
 //  writeln('sendcommand');
   cmd:=cmd+LineEnding;
   try
  // writeln('sendcommand2');
     if GetMPlayerPlaying then MPlayerProcess.Input.write(cmd[1], length(cmd));
  // writeln('sendcommand3');
   except writeln('EXCEPTION sending command to mplayer');
   end;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function TMPlayerClass.GetProcessOutput: string;
var AStringList: TStringList;
begin
     // writeln('getoutput');
   AStringList:=TStringList.Create;
   try
      if GetMPlayerPlaying then AStringList.LoadFromStream(MPlayerProcess.Output);
      Result:=AStringList.Strings[0];
     // writeln(Result);
   except
      writeln('EXCEPTION reading mplayer output');result:='';
   end;
   //writeln('endget');
   AStringList.Free;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMPlayerClass.GetMPlayerPlaying: boolean;
begin
  if assigned(MPlayerProcess)=false or (MPlayerProcess.Running=false) then result:=false else result:=true;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TMPlayerClass.create;
var tmps, tmppath: string;
    i: integer;
begin
   inherited;

   // Find mplayer executable
   FMplayerPath:='';
   tmps:=GetEnvironmentVariable('PATH');
   repeat
     begin
        i:=pos(':', tmps);
        if i=0 then i:=Length(tmps);
        tmppath:=IncludeTrailingPathDelimiter(copy(tmps,0,i-1))+MPLAYER_BINARY;
        if FileExists(tmppath) then FMplayerPath:=tmppath
                  else Delete(tmps, 1, i);
     end;
   until (length(tmps)<=1) or (FMplayerPath<>'');
   if FMplayerPath='' then begin
      writeln('FATAL: Mplayer executable not found. Make sure it is properly installed in binary path');
      halt;
     end else DebugOutLn('Mplayer executable found in '+FMplayerPath, 2);
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
destructor TMPlayerClass.destroy;
begin

end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function TMPlayerClass.play(index: integer): byte;
var MPOptions: String;
begin
if (index<Playlist.ItemCount) and (index>=0) and (FileExists(playlist.items[index].path)) then begin
  if FPlaying then stop;
  MPlayerProcess:=TProcess.Create(nil);
  MPOptions:='-slave -quiet';
  if OutputMode=ALSAOUT then MPOptions:=MPOptions+' -ao alsa';
  if OutputMode=OSSOUT then MPOptions:=MPOptions+' -ao oss';
  
  FPlaybackMode:=FILE_MODE;
  DebugOutLn('playing  -> '+playlist.items[index].path, 1);
  writeln(StringReplace(playlist.items[index].path, '''', '''''', [rfReplaceAll]));
  MPlayerProcess.CommandLine:=FMplayerPath+' '+MPOptions+' "'+playlist.items[index].path+'"';

  DebugOutLn(MPlayerProcess.CommandLine,5);
  FLastGet_Pos:=0;
  MPlayerProcess.Options:= MPlayerProcess.Options + [poUsePipes];
  MPlayerProcess.Execute;

  if MPlayerProcess.Running then begin
    FCurrentTrack:=index;
    FPlaying:=true;
    Playlist.Items[index].Played:=true;
    Set_Volume(FVolume);
  end;
end else DebugOutLn('File not found ->'+playlist.items[index].path,0);
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function TMPlayerClass.play(url: string): byte;
var MPOptions: String;
begin
  if FPlaying then stop;
  MPlayerProcess:=TProcess.Create(nil);
  MPOptions:='-slave -quiet';
  if OutputMode=ALSAOUT then MPOptions:=MPOptions+' -ao alsa';
  if OutputMode=OSSOUT then MPOptions:=MPOptions+' -ao oss';

  FPlaybackMode:=STREAMING_MODE;
  DebugOutLn('playing  -> '+url, 1);
  MPlayerProcess.CommandLine:=FMplayerPath+' '+MPOptions+' "'+url+'"';

  DebugOutLn(MPlayerProcess.CommandLine,5);

  MPlayerProcess.Options:= MPlayerProcess.Options + [poUsePipes];
  MPlayerProcess.Execute;

  if MPlayerProcess.Running then begin
    FPlaying:=true;
    Set_Volume(FVolume);
  end;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TMPlayerClass.pause;
begin
 if FPlaying and Assigned(MPlayerProcess) then begin
   SendCommand('pause');
   sleep(10);
   writeln('pauseee');
   FPaused:=not FPaused;
 end;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TMPlayerClass.stop;
begin
 //writeln('stop');
 if FPlaying and Assigned(MPlayerProcess) then begin
 //writeln('stop2');
   SendCommand('quit');
   sleep(15);
   if MPlayerProcess.Running then begin
      sleep(50);
      if MPlayerProcess.Running then
         if MPlayerProcess.Terminate(0) then DebugOutLn('Mplayer stopped', 5)
               else DebugOutLn('FATAL Mplayer process zombified',0);
      end;
// writeln('stop3');
   MPlayerProcess.Free;
 end;
// writeln('stop4');
 FCurrentTrack:=-1;
 FPlaying:=false;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function TMPlayerClass.next_track: byte;
var r:byte;
begin
  r:=127;
  if fplaying then begin
    writeln('mnexttrack');
    if FCurrentTrack<Playlist.ItemCount-1 then begin
       r:=play(FCurrentTrack+1);
     end;
   end;
  result:=r;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function TMPlayerClass.prev_track: byte;
var r:byte;
begin
  r:=127;
  if fplaying then begin
    if (FCurrentTrack<Playlist.ItemCount) and (FCurrentTrack>0) then begin
       r:=play(FCurrentTrack-1);
     end else
         if (FCurrentTrack<Playlist.ItemCount) and (FCurrentTrack=0) then begin
             r:=play(FCurrentTrack);
           end;
   end;
  result:=r;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function TMPlayerClass.Get_Stream_Status: TStreamStatus;
begin
  Result:=STREAM_READY;  //Impossible to get stream status from mplayer :(
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMPlayerClass.Get_TrackLength:longint;
var tmps: string;
    i:integer;
    time: real;
begin
 if FPlaying and Assigned(MPlayerProcess) and MPlayerProcess.Running then begin
  repeat begin
    SendCommand('get_time_length');
    sleep(5);
    tmps:=GetProcessOutput;
   end;
   until pos('LENGTH', tmps)>0;
   i:=LastDelimiter('=', tmps);
   if i > 0 then begin
      time:= StrToFloat(Copy(tmps, i+1, Length(tmps)));
      time:=time*1000;
      result:=round(time);
   end;
 end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function TMPlayerClass.Get_Time: longint;
var tmps: string;
    i:integer;
    time: real;
begin
 if GetMPlayerPlaying then begin
  i:=0;
  repeat begin
 // writeln('bf');
    SendCommand('get_property time_pos');
    sleep(8);
  //  writeln(i);
    tmps:=GetProcessOutput;
  //  writeln('k');
    inc(i);
   end;
   until (pos('time_pos', tmps)>0) or (i>=3);
  // writeln('gettime');
   i:=LastDelimiter('=', tmps);
   if i > 0 then begin
        time:= StrToFloat(Copy(tmps, i+1, Length(tmps)));
        time:=time*1000;
        result:=round(time);
   end else result:=-1;
 end else result:=-1;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function TMPlayerClass.Get_TimeStr: string;
begin
  result:=MSecondsToFmtStr(Get_Time);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMPlayerClass.Get_TimeRemainingStr: string;
begin
  result:= '-' + MSecondsToFmtStr(Get_TrackLength - Get_Time);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function TMPlayerClass.Get_FilePosition: longint;
var tmps: string;
    i:integer;
begin
 if GetMPlayerPlaying then begin
  i:=0;
  repeat begin
    SendCommand('get_property percent_pos');
    sleep(8);
    tmps:=GetProcessOutput;
    inc(i);
   // writeln('jj');
   end;
   until (pos('percent_pos', tmps)>0) or (i>=5);
  // writeln('getpos');
   i:=LastDelimiter('=', tmps);
   if i > 0 then begin
           FLastGet_Pos:=round(StrToFloat(Copy(tmps, i+1, Length(tmps)-i)));
           result:=FLastGet_Pos;
       end else result:=-1;
 end else result:=-1;
 if (result=-1) and (FLastGet_Pos>0) then Result:=100;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function TMPlayerClass.get_FileLength: longint;
var tmps: string;
    i:integer;
begin
 if FPlaying and Assigned(MPlayerProcess) and MPlayerProcess.Running then begin
   SendCommand('get_property stream_length');
   sleep(10);
   tmps:=GetProcessOutput;
   i:=LastDelimiter('=', tmps);
   if i > 0 then begin
      result:= Trunc(StrToFloat(Copy(tmps, i+1, Length(tmps)-i)));
   end;
 end;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TMPlayerClass.Set_Time(ms: longint);
begin

end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TMPlayerClass.Set_FilePosition(fpos: longint);
begin
 if FPlaying and Assigned(MPlayerProcess) and MPlayerProcess.Running then begin
   SendCommand('set_property percent_pos '+IntToStr(fpos));
   sleep(20);
 end;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TMPlayerClass.Set_Volume(vol: byte);
var commandstr: string;
begin
 FVolume:=vol;
 if FPlaying and Assigned(MPlayerProcess) and MPlayerProcess.Running then begin
   if vol<0 then vol:=0;
   if vol>100 then vol:=100;
   commandstr:='set_property volume '+IntToStr(vol)+LineEnding;
   MPlayerProcess.Input.write(commandstr[1], length(commandstr));
 end;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TMPlayerClass.Mute;
var commandstr: string;
begin
 if FPlaying and Assigned(MPlayerProcess) and MPlayerProcess.Running then begin
   SendCommand('mute');
 end;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function TMPlayerClass.Muted: boolean;
var tmps, s: string;
    i:integer;
begin
 if FPlaying and Assigned(MPlayerProcess) and MPlayerProcess.Running then begin
  repeat begin
    SendCommand('get_property mute');
    sleep(5);
    tmps:=GetProcessOutput;
   end;
   until pos('mute', tmps)>0;
   i:=LastDelimiter('=', tmps);
   if i > 0 then begin
        s:=Copy(tmps, i+1, Length(tmps)-i);
        if s='yes' then Result:=true else Result:=false;
   end;
 end;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
end.

