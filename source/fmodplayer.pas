
{

  classes that implement the player functions for FMOD library
  written by Sebastian Kraft
  sebastian_kraft@gmx.de

  This software is free under the GNU Public License

  (c)2005
}

unit fmodplayer;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils,
  {$ifdef win32} fmoddyn, {$endif}
  {$ifdef unix} fmod, {$endif}
  fmodtypes, mediacol;




type
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TPlaylistitemClass }

TPlaylistitemClass = class
     constructor create;
     destructor destroy;
     Artist, Title, Path, Album: string;
     LengthMS, id:longint;
     Played: boolean;
     procedure update(MedFileObj: TMediaFileClass);
   end;
  PPlaylistItemClass = ^TPlaylistitemClass;

type

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TPlaylistClass }

  TPlaylistClass = class(Tlist)
   private
     function GetItems(index: integer):TPlaylistitemClass;
   public
     constructor create;
     destructor destroy;
     function TotalPlayTime: int64;
     function TotalPlayTimeStr: string;
     procedure move(dest, target:integer);
     procedure remove(index: integer);
     procedure clear; override;
     function add(filepath:string):integer;       //Read track info out of file at path
     function add(MedFileObj: TMediaFileClass):integer; //Get track info from FileObj
     procedure insert(index:integer; MedFileObj: TMediaFileClass);

     function update(index: integer; filepath:string):integer;       //update track info out of file at path
     function update(index: integer; MedFileObj: TMediaFileClass):integer; //update track info from FileObj
     function RandomIndex:integer;
     procedure reset_random;
     function ItemCount:integer;
     function LoadFromFile(path:string):byte;
     function SaveToFile(path:string):byte;
     CurrentTrack: integer;
     property Items[index: integer]: TPlaylistitemClass read GetItems;
   end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TFModPlayerClass }

TFModPlayerClass = class
   Private
     temps: string;
     fTotalLength: int64;
     FPlaying, FPaused: Boolean;
     Soundhandle: PFSoundStream;
     FVolume: Byte;
     function GetCurrentTrack: integer;
     procedure SetCurrentTrack(index: integer);
     property FCurrentTrack: Integer read GetCurrentTrack write SetCurrentTrack;
   Public
     constructor create;
     destructor destroy;

     function play(index:integer):byte;
     procedure pause;
     procedure stop;
     function next_track:byte;
     function prev_track:byte;

     function Get_Time:longint;
     function Get_TimeStr:string;

     function Get_FilePosition:longint;
     function get_FileLength:longint;

     procedure Set_Time(ms: longint);
     procedure Set_FilePosition(fpos:longint);
     procedure Set_Volume(vol:byte);
     
     procedure Mute;
     function Muted:boolean;


     oss:boolean;
     Playlist: TPlaylistClass;
     property CurrentTrack: Integer read GetCurrentTrack;
     property playing: boolean read FPlaying;
     property paused: boolean read FPaused;
     property volume:byte read FVolume write Set_Volume;
  end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

var player: TFModPlayerclass;

implementation
uses functions;
var tmpp: PChar;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.GetCurrentTrack: integer;
begin
  result:=Playlist.CurrentTrack;
end;

procedure TFModPlayerClass.SetCurrentTrack(index: integer);
begin
  Playlist.CurrentTrack:=index;
end;

constructor TFModPlayerClass.create;
begin
     Playlist:=TPlaylistclass.create;
     fplaying:=false;
     FCurrentTrack:=-1;
     FVolume:=255;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

destructor TFModPlayerClass.destroy;
var i:integer;
begin
     fplaying:=false;

     Playlist.Free;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.play(index:integer):byte;
{startplay=0 -> succesful
 startplay=1 -> file not found
 startplay=2 -> soundcard init failed
 startplay=3 -> index out of bounds
 startplay=4 -> Last song in List}
var z: integer;
   pPlaylistItem: pPlaylistItemClass;
begin
 if (index<Playlist.ItemCount) and (index>=0) then begin
   if (fplaying=true) then begin
         if FSOUND_Stream_Stop(Soundhandle)=false then writeln('ERROR stop stream');
         if FSOUND_Stream_Close(Soundhandle)=false then writeln('ERROR on closing stream');
         fplaying:=false;
      end;
   if (fplaying=false) then begin
   //FSOUND_Close;
 {$ifdef linux}
  {  if oss then begin
           if FSOUND_SetOutput(FSOUND_OUTPUT_OSS) then writeln('Oss output openend') else writeln('failed opening oss output')
         end
         else begin
           if FSOUND_SetOutput(FSOUND_OUTPUT_ALSA) then writeln('alsa output openend') else writeln('failed opening alsa output')
         end;}
  {$endif}
    if FSOUND_Init(44100, 32, 0)=true then begin

      writeln('playing  -> '+playlist.items[index].path);
      if (FileExists(playlist.items[index].path)) then begin
         tmpp:=StrAlloc(length(playlist.items[index].path)+1);
         StrPCopy(tmpp,playlist.items[index].path);

       // Open the stream
         write(' openingstream... ');
         Soundhandle:=FSOUND_Stream_Open(tmpp, FSOUND_MPEGACCURATE or FSOUND_NONBLOCKING {FSOUND_NORMAL}, 0, 0);    //Fixes Bug when starting VBR files first, FSOUND_NORMAL is faster!!
         z:=0;
         repeat begin   //Wait until it is loaded and ready
                z:=FSOUND_Stream_GetOpenState(soundhandle);
              end;
          until (z=0) or (z=-3);
         write(' ready... ');
         if z = 0 then begin //If loading was succesful
            write(' start playing... ');
            FSOUND_Stream_Play (FSOUND_FREE,Soundhandle);      //   Start playing
            writeln(' ready... ');
            FSOUND_SetVolume(0, volume);
            playlist.items[index].played:=true;
            fplaying:=true;
            result:=0;
            FCurrentTrack:=index;
           end else begin
               write('error: can''t play file');writeln(z);
              end;
       end else play:=1;
     end else play:=2;
   end;
  end
  else begin
         writeln('INTERNAL error: playlistindex out of bound');
         Result:=3;
       end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TFModPlayerClass.pause;
begin
   if FSOUND_Getpaused(0)=false then
        FSOUND_Setpaused(0, true)
     else   FSOUND_Setpaused(0, false);
   fpaused:=FSOUND_Getpaused(0);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TFModPlayerClass.stop;
begin
     if fplaying=true then begin
         FSOUND_Stream_Stop(Soundhandle);
         FSOUND_Stream_Close(Soundhandle);
         fplaying:=false;
         FSOUND_Close;
      //   reset_random;
         FCurrentTrack:=-1;
       end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.prev_track: byte;
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

function TFModPlayerClass.next_track: byte;
var r:byte;
begin
  r:=127;
  if fplaying then begin
    if FCurrentTrack<Playlist.ItemCount-1 then begin
       r:=play(CurrentTrack+1);
     end;
   end;
  result:=r;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TFModPlayerClass.mute;
begin
  if FSOUND_GetMute(0)=false then FSOUND_SetMute(FSOUND_ALL, true) else FSOUND_SetMute(FSOUND_ALL, false);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.get_time: longint;
begin
  if (Soundhandle<>nil) and (FSOUND_Stream_GetOpenState(soundhandle)=0) then begin
     get_time:=FSOUND_Stream_GetTime(Soundhandle);
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.get_timestr:string;
begin
  if (Soundhandle<>nil) and (FSOUND_Stream_GetOpenState(soundhandle)=0) then begin
     result:=MSecondsToFmtStr(FSOUND_Stream_GetTime(Soundhandle));
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.get_fileposition: longint;
begin
  get_fileposition:=FSOUND_Stream_GetPosition(Soundhandle);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.get_filelength: longint;
begin
  get_filelength:=FSOUND_Stream_GetLength(soundhandle);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.muted: boolean;
begin
  if FSOUND_GetMute(0)=true then result:=true else result:=false;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TFModPlayerClass.set_time(ms: longint);
begin
  if fplaying then FSOUND_Stream_SetTime(Soundhandle,ms);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TFModPlayerClass.set_fileposition(fpos: longint);
begin
  if fplaying then FSOUND_Stream_SetPosition(Soundhandle,fpos);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TFModPlayerClass.set_volume(vol: byte);
{set volume from 0 to 100}
var i:integer;
begin
  i:=((vol*255) div 100);
  FVolume:=i;
  FSOUND_SetVolume(0, volume);
end;


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TPlaylistitemClass }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TPlaylistitemClass.create;
begin
    played:=false;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

destructor TPlaylistitemClass.destroy;
begin
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TPlaylistitemClass.update(MedFileObj: TMediaFileClass);
begin

     Artist:=MedFileObj.Artist;
     Title:=MedFileObj.Title;
     Album:=MedFileObj.Album;

     ID:=MedFileObj.ID;
     LengthMS:=MedFileObj.Playlength;
end;


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TPlaylistClass }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPlaylistClass.GetItems(index: integer): TPlaylistitemClass;
begin
  if (index>=0) and (index < Count) then Result := (TPlaylistitemClass(Inherited Items [Index]));
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TPlaylistClass.create;
begin
  Inherited create;
end;

destructor TPlaylistClass.destroy;
begin
  clear;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPlaylistClass.TotalPlayTime: int64; // returns total playtime of playlist in milliseconds
var i: integer;
    PPlaylistItem: PPlaylistItemClass;
begin
  result:=0;
  for i:= 0 to Count-1 do begin
          result:=result + Items[i].LengthMS;
      end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPlaylistClass.TotalPlayTimeStr: string;  // returns total playtime of playlist in string
                                                   // format. i.e. '2h 20min'
var s1,s2: string;
    i: int64;
begin
  i:=TotalPlayTime;
  s2:=IntToStr((i div 60) mod 60 );
  s1:=IntToStr((i div 60) div 60 );
  result:=s1+'h '+s2+'min';
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TPlaylistClass.move(dest, target: integer);
begin
  if (dest < ItemCount) and (target < ItemCount) and (dest >= 0) and (target >= 0 ) then
    begin
       inherited Move(dest, target);



       if CurrentTrack=dest then begin
           CurrentTrack:=target;
         end
        else if CurrentTrack=target then begin
           CurrentTrack:=dest;
         end;
       if (CurrentTrack>dest) and (CurrentTrack<target) then dec(CurrentTrack);
       if (CurrentTrack<dest) and (CurrentTrack>target) then inc(CurrentTrack);
    end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TPlaylistClass.remove(index: integer);
begin
 if (index>=0) and (index < Count) then begin
  Items[index].free;
  inherited Delete(index);
  if CurrentTrack>index then dec(CurrentTrack);
 end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TPlaylistClass.clear;
begin
   while count>0 do remove(0);
   CurrentTrack:=-1;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPlaylistClass.add(filepath: string): integer;
begin
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPlaylistClass.add(MedFileObj: TMediaFileClass): integer;
var Playlistitem: TPlaylistitemClass;
    index: integer;
begin

     index:=(inherited Add(TPlaylistitemClass.create));


     Items[index].Path:=MedFileObj.path;
     Items[index].Artist:=MedFileObj.Artist;
     Items[index].Title:=MedFileObj.Title;
     Items[index].Album:=MedFileObj.Album;

     Items[index].ID:=MedFileObj.ID;
     Items[index].LengthMS:=MedFileObj.Playlength;
     result:=index;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TPlaylistClass.insert(index: integer; MedFileObj: TMediaFileClass);
begin
     inherited insert(index, TPlaylistitemClass.create);

     Items[index].Path:=MedFileObj.path;
     Items[index].Artist:=MedFileObj.Artist;
     Items[index].Title:=MedFileObj.Title;
     Items[index].Album:=MedFileObj.Album;

     Items[index].ID:=MedFileObj.ID;
     Items[index].LengthMS:=MedFileObj.Playlength;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPlaylistClass.update(index: integer; filepath: string): integer;
begin

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPlaylistClass.update(index: integer; MedFileObj: TMediaFileClass): integer;
begin
  if (index>=0) and (index<Count) then begin

     Items[index].update(MedFileObj);
  end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPlaylistClass.RandomIndex: integer;
// Returns a random index of playlist entry that has not been played yet. -1 if all has been played.
// reset_random resets it
var x, i:integer;
    s: boolean;
begin
  s := false;
  for i := 0 to Count-1 do if Items[i].played=false then s:= true;
  randomize;
  if s then begin
     i:=0;
     repeat begin
         x:=random(Count-1);
         inc(i);
       end;
     until (Items[x].played=false) or (i > 4096);  // i is for timeout to prevent an endless loop

     if i>4096 then begin
           x:=-1;
           repeat inc(x) until Items[x].played=false;
         end;

     result:=x;
  end
  else begin
          result:=-1;
         end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TPlaylistClass.reset_random;
var i: integer;
begin
   for i:= 0 to Count-1 do Items[i].played:=false;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPlaylistClass.ItemCount: integer;
begin
  result:=inherited Count;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPlaylistClass.LoadFromFile(path: string): byte;       //Load .m3u Playlist
var s, tmps, fpath, fartist, ftitle:string;
    pos1,pos2, i, lengthS:integer;
    PlaylistItem: TPlaylistItemClass;
    fileobj: TMediaFileClass;
    filehandle:text;
begin

  system.assign(Filehandle,path);
  Reset(filehandle);
  readln(filehandle, tmps);
  if pos('#EXTM3U',tmps)<>0 then begin
      repeat begin
        repeat readln(filehandle, tmps) until ((pos('#EXTINF', tmps)<>0) or eof(filehandle));
        pos1:=pos(':', tmps)+1;
        pos2:=pos(',', tmps);
        s:=copy(tmps,pos1,pos2-pos1);

        val(s,LengthS);



        
        pos1:=pos2+1;
        pos2:=pos(' - ',tmps);

        fartist:=copy(tmps,pos1,pos2-pos1);
        pos2:=pos2+3;
        ftitle:=copy(tmps,pos2,(length(tmps))-pos2+1);
        readln(filehandle, fpath);

        i:=(inherited Add(TPlaylistitemClass.create));
        Items[i].Title:=ftitle;
        Items[i].Artist:=fartist;
        Items[i].Path:=fpath;
        Items[i].LengthMS:=lengthS*1000;

{        writeln('###'                DEBUG
        writeln(PFileObj^.artist);
        writeln(PFileObj^.title);
        writeln(PFileObj^.path);}
      end;
     until eof(filehandle);
    end else writeln(path+' is not a valid m3u playlist');
    close(filehandle);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPlaylistClass.SaveToFile(path: string): byte;
var i:integer;
    temps: string;
    filehandle:text;
begin
  system.assign(Filehandle,path);
  Rewrite(filehandle);
  writeln(Filehandle,'#EXTM3U');
  for i:= 0 to Count-1 do begin
          str(Items[i].LengthMS div 1000, temps);
          writeln(filehandle,'#EXTINF:'+temps+','+Items[i].artist+' - '+Items[i].title);
          writeln(filehandle, Items[i].path);
      end;
  close(filehandle);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

initialization
  fmod_load('');
  
finalization
  FMOD_Unload;
  
end.
