{ some helper functions/procedures
  written by Sebastian Kraft
  sebastian_kraft@gmx.de

  This software is free under the GNU Public License

  (c)2005-2007
}

unit functions;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Objects, Process, crt, mmx, math, settings;




//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   function crc32(path: string):longint;
   function crc32_mmx(path: string):int64;
   function crc32_math(path: string):int64;
   function DirectoryIsEmpty(Directory: string): Boolean;
   function EraseDirectory(Directory: string):Boolean; //delete directory and all subdirectories/files in it
   function UTF8toLatin1(utfstring: ansistring): ansistring;
   function Latin1toUTF8(latin1string: ansistring): ansistring;
   function rmZeroChar(s: ansistring): ansistring;
   function FileCopy(const FromFile, ToFile: string):boolean;
   function FreeSpaceOnDAP:int64;
   function ByteToFmtString(bytes: int64; d1, d2: byte): string; // converts i.e. 1024 to 1,0 KB
                                                                 // d1, d2 sets amount of digits before and after ','
   function SecondsToFmtStr(seconds: longint): string;       //converts integer to mm:ss time format
   function MSecondsToFmtStr(MSeconds: longint): string;
 //  function CompareString(const s1, s2: string):byte;   // compare s1, s2 for sorting.   s1>s2 result=1,  abc > axc -> 1
                                                                                    //   s1<s2 result=-1, xyz < abc -> -1
                                                                                    //   s1=s2 result=0,  bhj = bhj -> 0


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


implementation

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function crc32_mmx(path: string):int64;  //creates an very, very basic checksum to identify files
var fhandle: THandle;
    buf: array [0..31] of int64;
    z:byte;
    i, eofile: longint;
    l: int64;
begin
     fhandle:=sysutils.fileopen(path, fmOpenRead);
     l:=0;
     i:=0;
     z:=0;
     eofile:=0;
  {MMX+}
     while (eofile<>-1) and (i<1024) do
           begin
                eofile:=FileRead(fhandle, buf, high(buf));
                for z:=0 to high(buf) do L:=l+buf[z];
              //  if eofile<>-1 then eofile:=FileSeek(fhandle, fsFromCurrent, 1024 - high(buf));
                inc(i);
            end;
  {MMX-}
     if is_amd_3d_mmx_cpu then femms else emms;
     FileClose(fhandle);
     
     result:= l;

end;

function crc32(path: string):longint;  //creates an very, very basic checksum to identify files
var fhandle: THandle;
    buf: array [0..63] of longint;
    z:byte;
    i, eofile: longint;
    l: longint;
begin
 {$Q-}
     fhandle:=sysutils.fileopen(path, fmOpenRead);
     l:=0;
     i:=0;
     z:=0;
     eofile:=0;
     while (eofile<>-1) and (i<256) do
           begin
                eofile:=FileRead(fhandle, buf, sizeof(buf));
                if eofile <>-1 then for z:=0 to high(buf) do L:=l+buf[z];
                inc(i);
            end;
     FileClose(fhandle);
     result:= l;
 {$Q+}
end;

function crc32_math(path: string):int64;  //creates an very, very basic checksum to identify files
var fhandle: THandle;
    buf: array [0..63] of int64;
    z:byte;
    i, eofile: longint;
    l: int64;
begin
     fhandle:=sysutils.fileopen(path, fmOpenRead);
     l:=0;
     i:=0;
     z:=0;
     eofile:=0;
     while (eofile<>-1) and (i<256) do
           begin
                eofile:=FileRead(fhandle, buf, high(buf));
                l:=l+sumInt(buf);
                inc(i);
            end;
     FileClose(fhandle);
     result:= l;

end;


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function EraseDirectory(Directory: string): Boolean;
var Srec: TSearchRec;
begin
     result:=false;
     if DirectoryExists(Directory)then begin
        try
          FindFirst(IncludeTrailingPathDelimiter(Directory) + '*', faAnyFile, Srec);
          repeat begin
               if (Srec.Name <> '.') and (Srec.Name <> '..') then
                      DeleteFile(Directory+DirectorySeparator+Srec.Name);
             end;
          until FindNext(Srec)<>0;
          FindClose(Srec);
          result:=RemoveDir(Directory);
        except
          result:=false;
        end;
     end;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function UTF8toLatin1(utfstring: ansistring): ansistring;
var i:integer;
    tmps: string;
    utf16: boolean;
begin
  i:=0;
  tmps:='';
  utf16:=false;
  
  if length(utfstring)>0 then begin
     repeat begin
          inc(i);
          case byte(utfstring[i]) of
           $ff: if byte(utfstring[i+1])=$fe then utf16:=true;
           $c3:  begin
                       Delete(utfstring, i, 1);
                       utfstring[i]:=char(byte(utfstring[i])+64);
                     end;
           $c2: begin
                  Delete(utfstring, i, 1);
                  dec(i);
                end;
          end;
        end;
      until (i>=length(utfstring)-1) or utf16;
      //if utf16 detected
      if utf16 then begin
         i:=i+2;
         writeln('utf16');
         repeat begin
               inc(i);
               if byte(utfstring[i])<>0 then tmps:=tmps+utfstring[i];
            end;
         until (i>=length(utfstring));
        end;
   end;
   
   if not utf16 then result:=utfstring else Result:=tmps;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function rmZeroChar(s: ansistring): ansistring;
var i: integer;
begin
   i:=0;
   if s<>'' then begin
     repeat begin
            inc(i);
            if byte(s[i])=0 then begin
               Delete(s, i, 1);
               dec(i);
             end;
        end;
     until i>=length(s)-1;
    end;
   Result:=s;
end;


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function Latin1toUTF8(latin1string: ansistring): ansistring;
var i:integer;
    c: char;
    tmps: string;
    utf16: boolean;
begin
  i:=0;
  utf16:=false;
  if length(latin1string)>0 then begin
     repeat begin
          inc(i);
          case byte(latin1string[i]) of
           $ff: if byte(latin1string[i+1])=$fe then utf16:=true;
           $00..$1f: begin
                        Delete(latin1string, i, 1);
                        dec(i);
                     end;
           $c0..$fd: begin //c0..ff ist der gesamte wertebereich!!
                        if (byte(latin1string[i])=$c3) and (byte(latin1string[i+1])<$C0) then inc(i)
                          else begin
                               latin1string[i]:=char(byte(latin1string[i])-64);
                               insert(char($c3), latin1string, i);
                               inc(i);
                             end;
                      end;
      {     $a1..$bf:  begin
                        c:=latin1string[i];
                        insert(char($c2), latin1string, i);
//                        utfstring[i]:=char(byte(utfstring[i])+64);
                        inc(i);
                      end;}
          end;
        end;
      until (i>=length(latin1string)-1) or utf16;
      //if utf16 detected
      if utf16 then begin
         //latin1string:=AnsiToUtf8(latin1string); may also work instead of following own utf16->utf8 routine
         inc(i);
         repeat begin
               inc(i);
               if byte(latin1string[i])>$1f then
                    if byte(latin1string[i])<$c0 then
                           tmps:=tmps+char(byte(latin1string[i]))
                        else
                           tmps:=tmps+char($c3)+char(byte(latin1string[i])-64);
            end;
         until (i>=length(latin1string));
        end;
   end;
   if not utf16 then result:=latin1string else Result:=tmps;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

{   Function to copy a file FromFile -> ToFile    , mainly used while upload to player device}
function FileCopy(const FromFile, ToFile: string):boolean;
 var
  FromF, ToF: file;
  NumRead, NumWritten: Word;
  Buf: array[1..4096] of byte;
begin
 try
  AssignFile(FromF, FromFile);
  Reset(FromF, 1);              { Record size = 1 }
  AssignFile(ToF, ToFile);      { Open output file }
  Rewrite(ToF, 1);              { Record size = 1 }
  repeat
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);
  CloseFile(FromF);
  CloseFile(ToF);
  result:=true;
 except result:=false;
 end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function FreeSpaceOnDAP: int64;
var tmps: string;
begin
      tmps:=GetCurrentDir;                             // get free memory on player, format string
      SetCurrentDir(CactusConfig.DAPPath);
      result:=DiskFree(0);
      SetCurrentDir(tmps);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function ByteToFmtString(bytes: int64; d1, d2: byte): string;
var r: real;
    count: byte;
    comma, prefix, s1, s2: string;
begin
     count:=0;
     r:=bytes;
     while (r>=power(10, d1)) do
           begin
               r:=r / 1024;
               inc(count);
           end;

     case count of
        0: prefix:='Byte';
        1: prefix:='KB';
        2: prefix:='MB';
        3: prefix:='GB';
        4: prefix:='TB';
        5: prefix:='PB';
      end;

     str(round (r*power(10, d2)) , s2);

     if r >= 1 then begin
          s1:=copy(s2, 0, length(s2)-d2);
          s2:=copy(s2, length(s2)-d2+1, d2);
        end else s1:='0';

     if d2<>0 then comma:=',' else
        begin
          comma:='';
          s2:='';
         end;
     result:=s1+comma+s2+' '+prefix;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function SecondsToFmtStr(seconds: longint): string;
var min, sec: longint;
    s, s2: string;
begin
     min:=seconds div 60;
     sec:=seconds mod 60;
     str(min, s);
     str(sec, s2);
     if min<10 then s:='0'+s;
     if sec<10 then s2:='0'+s2;
     result:= s+':'+s2;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function MSecondsToFmtStr(MSeconds: longint): string;
begin
  result:=SecondsToFmtStr(MSeconds div 1000);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

{function CompareString(s1, s2: string): byte;
var i:integer;
begin
   s1:=LowerCase(s1);
   s2:=LowerCase(s2);
   if s1=s2 then begin  //if both strings are equal, exit here
       result:=0;
       exit;
     end;
   i:=0;
   repeat begin
       if byte(s1[i])>byte(s2[i]) then begin
               result:=-1;
               exit;
             end else begin
               result:=1;
               exit;
          end;
       inc(i);
    end;
    until (i=length(s1)) or (i=length(s2));

    if length(s1)<length(s2) then
          result:=1
        else
          result:=-1;
end;
 }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function DirectoryIsEmpty(Directory: string): Boolean;
var
  SeR: TSearchRec;
  i: Integer;
begin
  Result := False;
  FindFirst(IncludeTrailingPathDelimiter(Directory) + '*', faAnyFile, SeR);
  for i := 1 to 2 do
    if (SeR.Name = '.') or (SeR.Name = '..') then
      Result := FindNext(SeR) <> 0;
  FindClose(SeR);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end.

