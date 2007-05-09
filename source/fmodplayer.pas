{ classes that implement the player functions for FMOD library
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
  fmod, fmodtypes,
  mp3file;




type

{ TPlaylistitemClass }

TPlaylistitemClass = class
     constructor create;
     Artist, Title, Path, Album: string;
     LengthMS, id:longint;
     Collection: PMediaCollection;
     Played: boolean;
     procedure update(Pfileobj: PMp3fileobj);
   end;
  PPlaylistItemClass = ^TPlaylistitemClass;

type


{ TPlaylistClass }

TPlaylistClass = class(Tlist)
   private
     function GetItems(index: integer):TPlaylistitemClass;

   public
     constructor create;
     function TotalPlayTime: int64;
     function TotalPlayTimeStr: string;
     procedure move(dest, target:integer);
     procedure remove(index: integer);
     procedure clear; override;
     function add(filepath:string):integer;       //Read track info out of file at path
     function add(PFileObj: PMp3fileobj):integer; //Get track info from FileObj
     function update(index: integer; filepath:string):integer;       //update track info out of file at path
     function update(index: integer; PFileObj: PMp3fileobj):integer; //update track info from FileObj
     function RandomIndex:integer;
     procedure reset_random;
     function ItemCount:integer;
     function LoadFromFile(path:string):byte;
     function SaveToFile(path:string):byte;
     property Items[index: integer]: TPlaylistitemClass read GetItems;
   end;

{ TFModPlayerClass }

TFModPlayerClass = class
   Private
     FCurrentTrack:integer;
     temps: string;
     fTotalLength: int64;
     FPlaying, FPaused: Boolean;
     Soundhandle: PFSoundStream;
     FVolume: Byte;
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
     property CurrentTrack: Integer read FCurrentTrack;
     property playing: boolean read FPlaying;
     property paused: boolean read FPaused;
     property volume:byte read FVolume write Set_Volume;
  end;


implementation
uses functions;
var tmpp: PChar;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TFModPlayerClass.create;
begin
     fplaying:=false;
     FCurrentTrack:=-1;
     Playlist:=TPlaylistclass.create;
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
         FSOUND_Stream_Stop(Soundhandle);
         FSOUND_Stream_Close(Soundhandle);
         fplaying:=false;
      end;
   if (fplaying=false) then begin
    FSOUND_Close;
 {$ifdef linux}
    if oss then begin
           if FSOUND_SetOutput(FSOUND_OUTPUT_OSS) then writeln('Oss output openend') else writeln('failed opening oss output')
         end
         else begin
           if FSOUND_SetOutput(FSOUND_OUTPUT_ALSA) then writeln('alsa output openend') else writeln('failed opening alsa output')
         end;
  {$endif}
    if FSOUND_Init(44100, 32, 0)=true then begin

      writeln('playing  -> '+playlist.items[index].path);
      if (FileExists(playlist.items[index].path)) then begin
         tmpp:=StrAlloc(length(playlist.items[index].path)+1);
         StrPCopy(tmpp,playlist.items[index].path);

       // Open the stream
         Soundhandle:=FSOUND_Stream_Open(tmpp,{ FSOUND_MPEGACCURATE or FSOUND_NONBLOCKING }FSOUND_NORMAL, 0, 0);    //Fixes Bug when starting VBR files first, FSOUND_NORMAL is faster!!
         z:=0;
         repeat begin   //Wait until it is loaded and ready
                z:=FSOUND_Stream_GetOpenState(soundhandle);
              end;
          until (z=0) or (z=-3);

         if z = 0 then begin //If loading was succesful
            FSOUND_Stream_Play (0,Soundhandle);      //   Start playing
            FSOUND_SetVolume(0, volume);
            fplaying:=true;
            playlist.items[index].played:=true;
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
    if (CurrentTrack<=Playlist.ItemCount) and (CurrentTrack>1) then begin
       r:=play(CurrentTrack-1);
     end else
         if (CurrentTrack<=Playlist.ItemCount) and (CurrentTrack=0) then begin
             r:=play(CurrentTrack);
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
    if CurrentTrack<Playlist.ItemCount then begin
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

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

{function TFModPlayerClass.save_playlist(path: string): byte;
var i:integer;
begin
  assign(Filehandle,path);
  Rewrite(filehandle);
  writeln(Filehandle,'#EXTM3U');
  for i:= 1 to maxlistindex do begin
          str(Playlist[i].length div 1000, temps);
          writeln(filehandle,'#EXTINF:'+temps+','+Playlist[i].artist+' - '+Playlist[i].title);
          writeln(filehandle, Playlist[i].path);
      end;
  close(filehandle);
end;
 }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

{ TPlaylistitemClass }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TPlaylistitemClass.create;
begin
    played:=false;
end;

procedure TPlaylistitemClass.update(Pfileobj: PMp3fileobj);
begin
     Artist:=PFileObj^.Artist;
     Title:=PFileObj^.Title;
     Album:=PFileObj^.Album;
     Collection:=PFileObj^.Collection;
     ID:=PFileObj^.ID;
     LengthMS:=PFileObj^.Playlength;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

{ TPlaylistClass }

function TPlaylistClass.GetItems(index: integer): TPlaylistitemClass;
begin
  if index < Count then Result := (TPlaylistitemClass(Inherited Items [Index]))
     else raise Exception.CreateFmt ('Index (%d) outside range 1..%d', [Index, Count -1 ]) ;
end;

constructor TPlaylistClass.create;
begin
  Inherited create;
end;

function TPlaylistClass.TotalPlayTime: int64; // returns total playtime of playlist in milliseconds
var i: integer;
    PPlaylistItem: PPlaylistItemClass;
begin
  result:=0;
  for i:= 0 to Count-1 do begin
          result:=result + Items[i].LengthMS;
      end;
end;


function TPlaylistClass.TotalPlayTimeStr: string;  // returns total playtime of playlist in string
                                                   // format. i.e. '2h 20min'
var s1,s2: string;
    i: int64;
begin
  i:=TotalPlayTime;
  s1:=IntToStr((i div 60) mod 60 );
  s2:=IntToStr((i div 60) div 60 );
  result:=s1+'h '+s2+'min';
end;

procedure TPlaylistClass.move(dest, target: integer);
begin
  inherited Move(dest, target);
end;

procedure TPlaylistClass.remove(index: integer);
begin
  Items[index].free;
  inherited Delete(index);
end;

procedure TPlaylistClass.clear;
var i:integer;
begin
   repeat remove(0) until ItemCount=0;
end;

function TPlaylistClass.add(filepath: string): integer;
begin

end;

function TPlaylistClass.add(PFileObj: PMp3fileobj): integer;
var Playlistitem: TPlaylistitemClass;
    index: integer;
begin

     index:=(inherited Add(TPlaylistitemClass.create));


     Items[index].Path:=PFileObj^.path;
     Items[index].Artist:=PFileObj^.Artist;
     Items[index].Title:=PFileObj^.Title;
     Items[index].Album:=PFileObj^.Album;
     Items[index].Collection:=PFileObj^.Collection;
     Items[index].ID:=PFileObj^.ID;
     Items[index].LengthMS:=PFileObj^.Playlength;

end;

function TPlaylistClass.update(index: integer; filepath: string): integer;
begin

end;

function TPlaylistClass.update(index: integer; PFileObj: PMp3fileobj): integer;
begin
  if (index>=0) and (index<Count) then begin

     Items[index].update(PFileObj);
  end;
end;

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
     repeat x:=random(Count) until Items[i].played=false;
     result:=x;
   end
     else begin
          result:=-1;
         end;
end;

procedure TPlaylistClass.reset_random;
var i: integer;
begin
   for i:= 0 to Count-1 do Items[i].played:=false;
end;


function TPlaylistClass.ItemCount: integer;
begin
  result:=inherited Count;
end;

function TPlaylistClass.LoadFromFile(path: string): byte;       //Load .m3u Playlist
var s, tmps:string;
    pos1,pos2, i:integer;
    PlaylistItem: TPlaylistItemClass;
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
        writeln(s);
        val(s,i);

        PlaylistItem:=TPlaylistitemClass.create;
        PlaylistItem.LengthMS:=i*1000;
        
        pos1:=pos2+1;
        pos2:=pos(' - ',tmps);

        PlaylistItem.artist:=copy(tmps,pos1,pos2-pos1);
        pos2:=pos2+3;
        PlaylistItem.title:=copy(tmps,pos2,length(tmps)-pos2+1);
        readln(filehandle, tmps);
        PlaylistItem.path:=tmps;
        inherited Add(PlaylistItem);
{        writeln('###'                DEBUG
        writeln(PFileObj^.artist);
        writeln(PFileObj^.title);
        writeln(PFileObj^.path);}
      end;
     until eof(filehandle);
    end else writeln(path+' is not a valid m3u playlist');
    close(filehandle);
end;

function TPlaylistClass.SaveToFile(path: string): byte;
begin

end;

end.

