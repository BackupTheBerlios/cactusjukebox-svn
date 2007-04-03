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
     artist, title, path: string;
     length, id:longint;
     collection: PMediaCollection;
     played: boolean;
   end;

type

{ TFModPlayerClass }

TFModPlayerClass = class
     constructor create;
     destructor destroy;
     function startplay(index:integer):byte;
     procedure pause;
     procedure stop;
     function next_track:byte;
     function get_random_item:integer;
     function play_random_item:byte;
     function prev_track:byte;
     procedure mute;
     function add_to_playlist(filepath:string):integer;
     function get_time:longint;
     function get_time_string:string;
     function get_playlist_index:integer;
     function get_file_position:longint;
     function get_file_length:longint;
     function get_mute:boolean;
     procedure set_time(ms: longint);
     procedure set_file_position(fpos:longint);
     procedure set_volume(vol:byte);
     procedure clear_playlist;
     procedure reset_random;
     procedure move_entry(dest, target:integer);
     procedure remove_from_playlist(index:integer);
     function load_playlist(path:string):byte;
     function save_playlist(path:string):byte;
     Soundhandle: PFSoundStream;
     volume:byte;
     Playlist: array[0..256] of TPlaylistitemClass;
     
   Private
     filehandle:text;
     playindex:integer;
     temps: string;
     fTotalLength: int64;
     FPlaying, FPaused: Boolean;
   Public
     maxlistindex:integer;
     oss:boolean;
     property playing: boolean read FPlaying;
     property paused: boolean read FPaused;
     ItemCount: integer;
     function TotalLenght:int64;
  end;


implementation

var i:integer;
    tmpp: PChar;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TFModPlayerClass.create;
begin
     fplaying:=false;
     playindex:=0;
     Playlist[0]:=TPlaylistitemclass.create;
     volume:=255;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

destructor TFModPlayerClass.destroy;
begin
     fplaying:=false;

     for i:= 1 to maxlistindex do begin
            Playlist[i].Free;
     end;
     maxlistindex:=0;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.startplay(index:integer):byte;
{startplay=0 -> succesful
 startplay=1 -> file not found
 startplay=2 -> soundcard init failed
 startplay=3 -> index out of bounds
 startplay=4 -> Last song in List}
var z: integer;
begin
 if (index<=maxlistindex) and (index>0) then begin
   if (fplaying=true) then begin
         FSOUND_Stream_Stop(Soundhandle);
         FSOUND_Stream_Close(Soundhandle);
         fplaying:=false;
         FSOUND_Close;
      end;
   if (fplaying=false) then begin

 {$ifdef linux}
    if oss then begin
           if FSOUND_SetOutput(FSOUND_OUTPUT_OSS) then writeln('Oss output openend') else writeln('failed opening oss output')
         end
         else begin
           if FSOUND_SetOutput(FSOUND_OUTPUT_ALSA) then writeln('alsa output openend') else writeln('failed opening alsa output')
         end;
  {$endif}
    if FSOUND_Init(44100, 32, 0)=true then begin
      writeln('playing '+playlist[index].path);
      if (FileExists(playlist[index].path)) then begin
         tmpp:=StrAlloc(length(playlist[index].path)+1);
         StrPCopy(tmpp,playlist[index].path);
         if soundhandle<>nil then FSOUND_Stream_Close(Soundhandle);
         Soundhandle:=FSOUND_Stream_Open(tmpp,{ FSOUND_MPEGACCURATE or FSOUND_NONBLOCKING }FSOUND_NORMAL, 0, 0);    //Fixes Bug when starting VBR files first, FSOUND_NORMAL is faster!!
         z:=0;
         repeat begin
                z:=FSOUND_Stream_GetOpenState(soundhandle);
              end;
          until (z=0) or (z=-3);
         writeln(z);
         if z = 0 then begin
            FSOUND_Stream_Play (0,Soundhandle);
            FSOUND_SetVolume(0, volume);
            fplaying:=true;
            Playlist[index].played:=true;
            startplay:=0;
            playindex:=index;
            writeln(playindex);
           end else begin
               write('error: can''t play file');writeln(z);
              end;
       end else startplay:=1;
     end else startplay:=2;
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
         playindex:=0;
       end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.prev_track: byte;
var r:byte;
begin
  r:=127;
  if fplaying then begin
    if (playindex<=maxlistindex) and (playindex>1) then begin
       dec(playindex);
       r:=startplay(playindex);
     end else
         if (playindex<=maxlistindex) and (playindex=1) then begin
             r:=startplay(playindex);
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
    if playindex<maxlistindex then begin
       inc(playindex);
       r:=startplay(playindex);
       writeln(playindex);
     end;
   end;
  result:=r;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.get_random_item: integer;
var rnd: integer;
begin
  {randomize;
  Result:=;}
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.play_random_item: byte;
var x:integer;
    s: boolean;
begin
  s := false;
  for i := 1 to maxlistindex do if Playlist[i].played=false then s:= true;
  randomize;
  if s then begin
     repeat x:=random(maxlistindex) until Playlist[x+1].played=false;
     x:=x+1;
     playindex:=x;
     stop;
     startplay(x);
     result:=0;
     Playlist[x].played:=true;
   end
     else begin
          stop;
          result:=1;
         end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TFModPlayerClass.mute;
begin
  if FSOUND_GetMute(0)=false then FSOUND_SetMute(FSOUND_ALL, true) else FSOUND_SetMute(FSOUND_ALL, false);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.add_to_playlist(filepath: string): integer;
{add an item to end of playlist}
var n: integer;
begin
     inc(maxlistindex);
     playlist[maxlistindex]:=TPlaylistitemClass.create;
     playlist[maxlistindex].path:=filepath;
     
     ItemCount:=maxlistindex;
     add_to_playlist:=maxlistindex;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.TotalLenght: int64;
var n:integer;
begin
     fTotalLength:=0;
     for n:=1 to maxlistindex do fTotalLength:=fTotalLength+Playlist[n].length;
     TotalLenght:=fTotalLength;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.get_time: longint;
begin
     get_time:=FSOUND_Stream_GetTime(Soundhandle);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.get_time_string:string;
{current playing time in format mm:ss as a 5 byte string}
var
  t: LongInt;
  min: Integer;
  sec: Integer;
  s, s2: string;
begin
  if (Soundhandle<>nil) and (FSOUND_Stream_GetOpenState(soundhandle)=0) then begin
     t:=FSOUND_Stream_GetTime(Soundhandle);
     t:=t div 1000;
     min:=t div 60;
     sec:=t mod 60;
     str(min, s);
     str(sec, s2);
     if min<10 then s:='0'+s;
     if sec<10 then s2:='0'+s2;
     get_time_string:=s+':'+s2;
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.get_playlist_index: integer;
begin
  get_playlist_index:=playindex;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.get_file_position: longint;
begin
  get_file_position:=FSOUND_Stream_GetPosition(Soundhandle);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.get_file_length: longint;
begin
  get_file_length:=FSOUND_Stream_GetLength(soundhandle);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.get_mute: boolean;
begin
  if FSOUND_GetMute(0)=true then result:=true else result:=false;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TFModPlayerClass.set_time(ms: longint);
begin
  if fplaying then FSOUND_Stream_SetTime(Soundhandle,ms);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TFModPlayerClass.set_file_position(fpos: longint);
begin
  if fplaying then FSOUND_Stream_SetPosition(Soundhandle,fpos);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TFModPlayerClass.set_volume(vol: byte);
{set volume from 0 to 100}
begin
  i:=((vol*255) div 100);
  writeln(i);
  writeln(vol);
  volume:=i;
  FSOUND_SetVolume(0, volume);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TFModPlayerClass.clear_playlist;
{clears the playlist}
begin
  for i:= 1 to maxlistindex do playlist[i].Destroy;
  maxlistindex:=0;
  playindex:=0;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TFModPlayerClass.reset_random;
begin
   for i:= 1 to maxlistindex do Playlist[i].played:=false;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TFModPlayerClass.move_entry(dest, target: integer);
var tempitem: TPlaylistitemClass;
begin
     if dest=playindex then playindex:=target else if target=playindex then playindex:=dest;

     tempitem:=TPlaylistitemClass.create;
     if dest<target then begin
     for i:= dest to target-1 do begin
          tempitem:=playlist[i];
          playlist[i]:=playlist[i+1];
          playlist[i+1]:=tempitem;
        end;
      end else begin
     for i:= dest downto target+2 do begin
          tempitem:=playlist[i];
          playlist[i]:=playlist[i-1];
          playlist[i-1]:=tempitem;
        end;
      end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TFModPlayerClass.remove_from_playlist(index: integer);
{remove item "index" and shorten array to new size}
begin
  for i:=index to maxlistindex-1 do begin
               Playlist[i]:=playlist[i+1];
      end;
  dec(maxlistindex);
  ItemCount:=maxlistindex;
  if (playindex>index) then dec(playindex);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.load_playlist(path: string): byte;
var s:string;
var pos1,pos2:integer;
begin
  maxlistindex:=0;
  playindex:=0;
  assign(Filehandle,path);
  Reset(filehandle);
  readln(filehandle, temps);
  if pos('#EXTM3U',temps)<>0 then begin
      repeat begin
        repeat readln(filehandle, temps) until ((pos('#EXTINF', temps)<>0) or eof(filehandle));
        pos1:=pos(':', temps)+1;
        pos2:=pos(',', temps);
        s:=copy(temps,pos1,pos2-pos1);
        writeln(s);
        val(s,i);
        inc(maxlistindex);
        playlist[maxlistindex]:=TPlaylistitemClass.create;
        Playlist[maxlistindex].length:=i*1000;
        writeln('ll');
        pos1:=pos2+1;
        pos2:=pos(' - ',temps);

        Playlist[maxlistindex].artist:=copy(temps,pos1,pos2-pos1);
        pos2:=pos2+3;
        Playlist[maxlistindex].title:=copy(temps,pos2,length(temps)-pos2+1);
        writeln(Playlist[maxlistindex].artist);
        writeln(Playlist[maxlistindex].title);
        readln(filehandle, temps);
        Playlist[maxlistindex].path:=temps;
        writeln(Playlist[maxlistindex].path);
      end;
     until eof(filehandle);
    end else writeln(path+' is not a valid m3u playlist');
    close(filehandle);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TFModPlayerClass.save_playlist(path: string): byte;
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

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

{ TPlaylistitemClass }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TPlaylistitemClass.create;
begin
    played:=false;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end.

