{
Indexing media files, read/write Meta-Tags for Cactus Jukebox

written by Sebastian Kraft, <c> 2006

Contact the author at: sebastian_kraft@gmx.de

This Software is published under the GPL


}


unit mp3file;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, Objects, Process, Forms, crt;

var i,z, delpos:integer;
    tmps:string;

  type
      TPathFmt = ( FRelative, FDirect );
  
  type
      PMediaCollection = ^TMediacollection;
      PMp3fileobj = ^TMp3fileobj;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      { TMp3fileobj }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      TMp3fileobj=class
      private
       id3v1str: string[31];
       procedure read_tag_ogg;
       procedure read_tag_wave;
       procedure read_tag_mp3;
       function getPath: String;
       mp3filehandle:longint;
       id3v2, id3v1, read_only:boolean;
       tagpos:byte;
       
       FPath, FRelativePath: string;
      public
       
       constructor index_file(filepath:string);
       constructor create;
       destructor destroy;
       procedure write_tag;
       procedure read_tag;
       artist, album, title, comment: ansistring;
       year, track, filetype:string[4];
       size: int64;
       bitrate, samplerate, playlength, id: longint;
       index, action: integer;
       CoverPath: ansistring;
       collection: PMediaCollection;
       playtime: string;
       Property path: String read getPath write FPath;
      end;
      
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      { TMediaCollection }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      TMediacollection=class
       private
       procedure create_artist_order;
       procedure create_title_order;
       procedure scan_directory(dir:string); //scans directory and adds new(!) files to collection

       public
       constructor create;
       destructor destroy;
       lib:Array of TMp3FileObj;
       max_index:integer;
       dirlist: ansistring;
       guess_tag, saved, CollectionChanged:boolean;
       rootpath, savepath:string;
       PathFmt: TPathFmt;
       function  load_lib(path:string):byte;
       procedure save_lib(path:string);
       procedure add_directory(dir:string);
       procedure add_file(path:string); //scans directory and adds all(!) files to collection
       procedure sort;

       procedure remove_entry(ind:integer);
       function  ScanForNew:byte;   //search all folders for new or changed files
  end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

var MediaCollection, PlayerCol :TMediaCollection;
var mp3buf, mp3buf2: TMp3fileObj;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
implementation
uses status, fmod, mp3, functions;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

var s, s2: string[8];
    t, min, sec:integer;
    
const bitrates: array[0..15] of integer = (0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 999);
      samplerates: array[0..3] of integer = (44100, 48000, 32100, 0);

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediacollection.save_lib(path:string);
var lfile: textfile;
begin
       try
           assign(lfile,path);
           savepath:=path;
           saved:=true;
             rewrite(lfile);
             writeln(lfile,'#####This config file is created by Cactus Jukebox. NEVER(!!) edit by hand!!!####');
             writeln(lfile,'++++Config++++');
             writeln(lfile,max_index);
             writeln(lfile,guess_tag);
             writeln(lfile,rootpath);
             writeln(lfile,dirlist);
             writeln(lfile,'++++Files++++');
             for i:= 1 to max_index-1 do begin
                 if PathFmt = FDirect then
                            tmps:= lib[i].path
                     else begin
                            tmps:=copy(lib[i].path, length(rootpath), length(lib[i].path) - length(rootpath)+1);
                            if tmps[1]='/' then Delete(tmps, 1, 1);
{                            if tmps[1]='/' then Delete(tmps, 1, 1);
                            if tmps[1]='/' then Delete(tmps, 1, 1);  }
                          //  writeln(tmps);
                          end;
                 //writeln(tmps);
                 writeln(lfile,tmps);
                 writeln(lfile,lib[i].mp3filehandle);
                 writeln(lfile,lib[i].id);
                 writeln(lfile,lib[i].artist); writeln(lfile, lib[i].album); writeln(lfile, lib[i].title);writeln(lfile, lib[i].year);writeln(lfile, lib[i].comment);writeln(lfile, lib[i].track);
                 writeln(lfile,lib[i].id3v2); writeln(lfile, lib[i].id3v1); writeln(lfile, lib[i].read_only);
                 writeln(lfile,lib[i].size);
                 writeln(lfile,lib[i].filetype);
                 writeln(lfile,lib[i].bitrate);
                 writeln(lfile,lib[i].samplerate);
                 writeln(lfile,lib[i].playlength);
                 writeln(lfile,lib[i].playtime);
                end;
             close(lfile);
             write('written ');write(i);write(' of ');writeln(max_index);
         except
              writeln('error writing library to disk: check permissions!');
              write('written ');write(i);write(' of ');writeln(max_index);
           end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


function Tmediacollection.load_lib(path:string):byte;
var i:integer;
    lfile: textfile;
    RPath: String;
begin
           assign(lfile,path);
           reset(lfile);
       try
             readln(lfile);
             readln(lfile);
             readln(lfile,max_index);
             SetLength(lib, max_index+16);
             writeln(high(lib));
             readln(lfile, tmps);
             if tmps='FALSE' then guess_tag:=false else guess_tag:=true;
             readln(lfile, tmps);
            // readln(lfile, rootpath);
             if PathFmt = FRelative then RPath:=rootpath else RPath:='';
             readln(lfile, dirlist);
             writeln( dirlist);
             readln(lfile);
             for i:= 1 to  max_index-1 do begin
                 lib[i]:=TMp3fileobj.create;
                 lib[i].action:=ANOTHING;
                 readln(lfile, lib[i].fpath);
                 lib[i].FRelativePath:=RPath;
                 //writeln(lib[i].path);
                 readln(lfile, lib[i].mp3filehandle);
                 readln(lfile, lib[i].id);
                 readln(lfile, lib[i].artist); readln(lfile, lib[i].album); readln(lfile, lib[i].title);readln(lfile, lib[i].year);readln(lfile, lib[i].comment);readln(lfile, lib[i].track);
                 readln(lfile,tmps);
                 if tmps='FALSE' then  lib[i].id3v2:=false else  lib[i].id3v2:=true;
                 readln(lfile,tmps);
                 if tmps='FALSE' then  lib[i].id3v1:=false else  lib[i].id3v1:=true;
                 readln(lfile,tmps);
                 if tmps='FALSE' then  lib[i].read_only:=false else  lib[i].read_only:=true;
                 readln(lfile, lib[i].size);
                 readln(lfile, lib[i].filetype);
                 readln(lfile, lib[i].bitrate);
                 readln(lfile, lib[i].samplerate);
                 readln(lfile, lib[i].playlength);
                 readln(lfile, lib[i].playtime);

               end;
             close(lfile);
             writeln('library sucessfully loaded');
             update_artist_view;
             update_title_view;
             Main.curlib:=path;
             load_lib:=0;
         except
              writeln('lib seems corupted');
              write('exception at entry ');writeln(i);
              writeln(lib[i-1].fpath);
              load_lib:=1;
      end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


function TMediacollection.ScanForNew:byte;
var tmps, tmppath: string;
     k: integer;
     tmpfile: file OF BYTE;
begin
     CollectionChanged:=false;
     k:=0;
     repeat
       begin
         inc(k);
         if FileExists(lib[k].path) then begin
            try
              assign(tmpfile, lib[k].path);
              reset(tmpfile);
              if filesize(tmpfile)<>lib[k].size then begin
                                                       writeln(lib[k].path+'changed');
                                                       remove_entry(k);
                                                       dec(k);
                                                       CollectionChanged:=true;
                                                  end;
              close(tmpfile);
            except writeln(' error reading file '+lib[k].path);
            end;
           end else begin
            writeln(lib[k].path+'changed');
            remove_entry(k);
            dec(k);
            CollectionChanged:=true;
          end
      end;
     until K>=max_index-1;
     tmps:=dirlist;

     repeat begin
            tmppath:=copy(tmps, 1, pos(';', tmps)-1);
            delete(tmps, 1, pos(';', tmps));
            scan_directory(tmppath);

        end;
     until length(tmps)<=1;
     
   if CollectionChanged then result:=0 else result:=128;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

destructor TMediaCollection.destroy;
begin
     for i:= 1 to max_index-1 do lib[i].destroy;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

destructor TMp3fileobj.destroy;
begin
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TMediaCollection.create;
begin
     max_index:=1;
     saved:=false;
     savepath:='';
     Setlength(lib,512);
     PathFmt:= FDirect;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMp3fileobj.write_tag;
var
       buf: array[1..1024] of byte;
       bufstr, tmptag:string;
       artistv2, albumv2, titlev2, commentv2, yearv2, trackv2: string;
begin
{id3v2}
  if id3v2 or (length(artist)>30) or (length(title)>30) or (length(album)>30) or (length(comment)>30) then
    begin
     mp3filehandle:=fileopen(path,fmOpenRead);
     fileseek(mp3filehandle, 0, fsfrombeginning);
     fileread(mp3filehandle, buf, high(buf));
     fileclose(mp3filehandle);

     for i:= 1 to high(buf) do bufstr:=bufstr+char(buf[i]);

     if pos('ID3',bufstr) = 0 then
        begin                                               {create new ID3v2 Tag skeleton}
            bufstr:='';
            bufstr:='ID3'+char($03)+char(0)+char(0)+char(0)+char(0)+char(0)+char(0); {ID3 03 00 00 00 00 00 00}
            tmps:=char(0)+char(0)+char(0)+char(2)+char(0)+char(0)+char(0)+' ';
            bufstr:=bufstr+'TPE1'+tmps+'TIT2'+tmps+'TRCK'+tmps+'TYER'+tmps+'TALB'+tmps+char(0)+char(0);
            writeln('creating new ID3v2 tag!');
            writeln(bufstr);
            z:=length(bufstr)-1;
            for i:= z to high(buf) do bufstr:=bufstr+char(0);
          end;
          
          // Now lets write the tags
             i:=pos('TPE1',bufstr);
             if i<> 0 then
                begin
                     tmptag:=UTF8toLatin1(artistv2);
                     if length(tmptag)>0 then begin
                        Delete(bufstr, i+11, byte(bufstr[i+7])-1);
                        Insert(tmptag, bufstr, i+11);
                        bufstr[i+7]:=char(length(tmptag)+1);
                      end else Delete(bufstr, i, byte(bufstr[i+7])+10);
                end else begin
                     tmptag:=UTF8toLatin1(artistv2);
                     if length(tmptag)>0 then begin
                        tmps:=char(0)+char(0)+char(0)+char(length(tmptag)+1)+char(0)+char(0)+char(0);
                        Insert('TPE1'+tmps+(tmptag), bufstr, pos('ID3',bufstr)+10);
                      end;
                   end;

             i:=pos('TP1',bufstr);
             if i<> 0 then
                begin
                     tmptag:=UTF8toLatin1(artistv2);
                     Delete(bufstr, i, byte(bufstr[i+5])+6); //delete whole TP1 tag
                end;

             i:=pos('TIT2',bufstr);
             if i<> 0 then
                begin
                     tmptag:=UTF8toLatin1(titlev2);
                     if length(tmptag)>0 then begin
                        Delete(bufstr, i+11, byte(bufstr[i+7])-1);
                        Insert(tmptag, bufstr, i+11);
                        bufstr[i+7]:=char(length(tmptag)+1);
                      end else Delete(bufstr, i, byte(bufstr[i+7])+10);
                end else begin
                     tmptag:=UTF8toLatin1(titlev2);
                     if length(tmptag)>0 then begin
                         tmps:=char(0)+char(0)+char(0)+char(length(tmptag)+1)+char(0)+char(0)+char(0);
                         Insert('TIT2'+tmps+tmptag, bufstr, pos('ID3',bufstr)+10);
                       end;
                   end;

             i:=pos('TRCK',bufstr);
             if i<> 0 then
                begin
                     tmptag:=UTF8toLatin1(trackv2);
                     if length(tmptag)>0 then begin
                          Delete(bufstr, i+11, byte(bufstr[i+7])-1);
                          Insert(tmptag, bufstr, i+11);
                          bufstr[i+7]:=char(length(tmptag)+1);
                        end else Delete(bufstr, i, byte(bufstr[i+7])+10);
                end else begin
                     tmptag:=UTF8toLatin1(trackv2);
                     if length(tmptag)>0 then begin
                        tmps:=char(0)+char(0)+char(0)+char(length(tmptag)+1)+char(0)+char(0)+char(0);
                        Insert('TRCK'+tmps+tmptag, bufstr, pos('ID3',bufstr)+10);
                      end;
                   end;

             i:=pos('TYER',bufstr);
             if i<> 0 then
                begin
                     tmptag:=UTF8toLatin1(yearv2);
                     if length(tmptag)>0 then begin
                        Delete(bufstr, i+11, byte(bufstr[i+7])-1);
                        Insert(tmptag, bufstr, i+11);
                        bufstr[i+7]:=char(length(tmptag)+1);
                      end else Delete(bufstr, i, byte(bufstr[i+7])+10);
                end else begin
                     tmptag:=UTF8toLatin1(yearv2);
                     if length(tmptag)>0 then begin
                        tmps:=char(0)+char(0)+char(0)+char(length(tmptag)+1)+char(0)+char(0)+char(0);
                        Insert('TYER'+tmps+tmptag, bufstr, pos('ID3',bufstr)+10);
                      end;
                   end;

             i:=pos('TALB',bufstr);
             if i<> 0 then
                begin
                     tmptag:=UTF8toLatin1(albumv2);
                     if length(tmptag)>0 then begin
                        Delete(bufstr, i+11, byte(bufstr[i+7])-1);
                        Insert(tmptag, bufstr, i+11);
                        bufstr[i+7]:=char(length(tmptag)+1);
                      end else Delete(bufstr, i, byte(bufstr[i+7])+10);
                end else begin
                     tmptag:=UTF8toLatin1(albumv2);
                     if length(tmptag)>0 then begin
                        tmps:=char(0)+char(0)+char(0)+char(length(tmptag)+1)+char(0)+char(0)+char(0);
                        Insert('TALB'+tmps+tmptag, bufstr, pos('ID3',bufstr)+10);
                      end;
                   end;

        z:=length(bufstr)-1;
        for i:= 1 to high(buf) do if (i<z) then buf[i]:=byte(bufstr[i]) else buf[i]:=0;
        mp3filehandle:=fileopen(path,fmOpenWrite);
        if mp3filehandle<>-1 then
          begin
            fileseek(mp3filehandle,0,fsfrombeginning);
            filewrite(mp3filehandle,buf,high(buf));
            fileclose(mp3filehandle);
          end
          else writeln('ERROR: cant write tag. file not found');
   end;
{id3v1}
   writeln('#####ID3V1#######');
   for i:=1 to 128 do buf[i]:=0;
   buf[1]:=84;buf[2]:=65;buf[3]:=71; {TAG}
   
   FillChar(id3v1str, SizeOf(id3v1str), #0);
   id3v1str:=UTF8toLatin1(title);
   for i:= 4 to 33 do buf[i]:=byte(id3v1str[i-3]);
   
   FillChar(id3v1str, SizeOf(id3v1str), #0);
   id3v1str:=UTF8toLatin1(artist);
   for i:= 34 to 63 do buf[i]:=byte(id3v1str[i-33]);
   
   FillChar(id3v1str, SizeOf(id3v1str), #0);
   id3v1str:=UTF8toLatin1(album);
   for i:= 64 to 93 do buf[i]:=byte(id3v1str[i-63]);
   
   FillChar(id3v1str, SizeOf(id3v1str), #0);
   id3v1str:=UTF8toLatin1(year);
   for i:= 94 to 97 do buf[i]:=byte(id3v1str[i-93]);
   
   FillChar(id3v1str, SizeOf(id3v1str), #0);
   id3v1str:=UTF8toLatin1(comment);
   for i:= 98 to 127 do buf[i]:=byte(id3v1str[i-97]);
   
   if length(track)>0 then begin
                buf[126]:=0;
                buf[127]:=StrToInt(track);
      end;
   
   mp3filehandle:=fileopen(path,fmOpenWrite);
   if mp3filehandle<>-1 then begin
           if read_only=true then writeln('file is read only');
           fileseek(mp3filehandle,-128,fsfromend);
           writeln(title);
           filewrite(mp3filehandle,buf,128);
           fileclose(mp3filehandle);
     end else writeln('ERROR: cant write tag. file not found');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMp3fileobj.read_tag_wave;
var li: cardinal;
    b: byte;
begin
  Try
   mp3filehandle:=fileopen(path, fmOpenRead);
   fileseek(mp3filehandle,8,fsfrombeginning);
   b:=0;
   repeat begin
         inc(b);
         fileread(mp3filehandle,li,4);
       end;
   until (li=$20746D66) or (b=15);
   fileread(mp3filehandle,li,4);
   fileread(mp3filehandle,li,4);
   fileread(mp3filehandle,li,4);
   samplerate:=li;
   fileread(mp3filehandle,li,4);
   bitrate:=(li div 1024)*8;
   playlength:=size div li;
   t:=playlength;
   min:=t div 60;
   sec:=t mod 60;
   str(min, s);
   str(sec, s2);
   if min<10 then s:='0'+s;
   if sec<10 then s2:='0'+s2;
   playtime:=s+':'+s2;
   
   tmps:=extractFileName(path);
   z:=pos(' - ', tmps)+3;
   if z<>3 then begin
       title:=copy(tmps,z,length(tmps)-z-3);
       artist:=copy(tmps,1,z-3);
       album:='';
     end else begin
       artist:='';
       title:='';
       album:='';
    end;
     artist:=TrimRight(artist);
     title:=TrimRight(title);
     album:=TrimRight(Album);
  except writeln('**EXCEPTION reading wave file '+path+'**');
  end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMp3fileobj.read_tag_mp3;
var b, xx:byte;
    i:integer;
    buf: array[1..1024] of byte;
    artistv2, albumv2, titlev2, commentv2, yearv2, trackv2: string;
    bufstr:string;
begin
    Try
     mp3filehandle:=fileopen(path, fmOpenRead);
{calculating playtime}
     fileseek(mp3filehandle,0,fsfrombeginning);
     fileread(mp3filehandle,buf,high(buf));

     i:=0;
     z:=1;
     repeat begin
           inc(i);
           if i=high(buf) then begin
               fileseek(mp3filehandle, (i*z)-4, fsFromBeginning);
               fileread(mp3filehandle,buf,high(buf));
               inc(z);
               i:=1;
              end;
          end;
      until ((buf[i]=$FF) and ((buf[i+1] or $3)=$FB)) or (z>256);
     if (buf[i]=$FF) and (buf[i+1] or $3=$FB) then begin
              b:= buf[i+2] shr 4;
              if b > 15 then b:=0;
              bitrate:=bitrates[b];
              b:=buf[i+2] and $0F;
              b:= b shr 2;
              if b > 3 then b:=3;
              samplerate:=samplerates[b];
              if bitrate>0 then begin
                 playlength:=round(size / (bitrate*125));
                 t:=playlength;
                 min:=t div 60;
                 sec:=t mod 60;
                 str(min, s);
                 str(sec, s2);
                 if min<10 then s:='0'+s;
                 if sec<10 then s2:='0'+s2;
                 playtime:=s+':'+s2;
               end;
            end
        else writeln(path+' -> no valid mpeg header found');

{reading ID3-tags}
     fileseek(mp3filehandle,0,fsfrombeginning);
     fileread(mp3filehandle,buf,high(buf));
     bufstr:='';
     for i:= 1 to high(buf) do if {(buf[i]<>0) and }(buf[i]<>10) then bufstr:=bufstr+char(buf[i]) else bufstr:=bufstr+' '; // filter #10 and 0, replace by ' '
  {id3v2}
     albumv2:='';
     artistv2:='';
     titlev2:='';
     trackv2:='';
     yearv2:='';
     if pos('ID3',bufstr)<> 0 then
        begin
             id3v2:=true;

             i:=pos('TPE1',bufstr);
             if i<> 0 then artistv2:=copy(bufstr,i+11,buf[i+7]-1);
             i:=pos('TP1',bufstr);
             if i<> 0 then artistv2:=copy(bufstr,i+7,buf[i+5]-1);

             i:=pos('TIT2',bufstr);
             if i<> 0 then titlev2:=copy(bufstr,i+11,buf[i+7]-1);

             i:=pos('TT2',bufstr);
             if i<> 0 then titlev2:=copy(bufstr,i+7,buf[i+5]-1);

             i:=pos('TRCK',bufstr);
             if i<> 0 then trackv2:=copy(bufstr,i+11,buf[i+7]-1);

             i:=pos('TRK',bufstr);
             if i<> 0 then trackv2:=copy(bufstr,i+7,buf[i+5]-1);

             if length(trackv2)>3 then trackv2:='';

             i:=pos('TAL',bufstr);
             if i<> 0 then albumv2:=copy(bufstr,i+7,buf[i+5]-1);

             i:=pos('TALB',bufstr);
             if i<> 0 then albumv2:=copy(bufstr,i+11,buf[i+7]-1);

             i:=pos('TYE',bufstr);
             if i<> 0 then yearv2:=copy(bufstr,i+7,buf[i+5]-1);

             i:=pos('TYER',bufstr);
             if i<> 0 then yearv2:=copy(bufstr,i+11,buf[i+7]-1);
{             artistv2:=rmZeroChar(artistv2);
             titlev2:=rmZeroChar(titlev2);
             albumv2:=rmZeroChar(albumv2);     }

             artistv2:=Latin1toUTF8(artistv2);
             titlev2:=Latin1toUTF8(titlev2);
             albumv2:=Latin1toUTF8(albumv2);
             yearv2:=Latin1toUTF8(yearv2);
             trackv2:=Latin1toUTF8(trackv2)
             ;
          //   rmZeroChar(yearv2);
             if length(yearv2)>5 then yearv2:='';
        end else id3v2:=false;
          {id3v1}
         fileseek(mp3filehandle,-128, fsfromend);
         fileread(mp3filehandle,buf,128);
         bufstr:='';
         for i:= 1 to 128 do bufstr:=bufstr+char(buf[i]);
         for i:= 1 to 128 do begin
                b:=byte(bufstr[i]);
                if (b=0) then bufstr[i]:=#32;
            end;
         tagpos:=pos('TAG',bufstr)+3;
         id3v1:=false;
         if tagpos<>3 then begin
               title:=Latin1toUTF8(copy(bufstr,tagpos,30));
               artist:=Latin1toUTF8(copy(bufstr,tagpos+30,30));
               album:=Latin1toUTF8(copy(bufstr,tagpos+60,30));
               year:=copy(bufstr,tagpos+90,4);
               if buf[125]<>0 then                             {check for id3v1.1}
                         comment:=Latin1toUTF8(copy(bufstr,tagpos+94,30))
                    else begin
                         comment:=Latin1toUTF8(copy(bufstr,tagpos+94,28));
                         if (buf[tagpos+123])<>0 then track:=IntToStr(buf[tagpos+123]) else track:='';
                       end;
               id3v1:=TRUE;
            end else if MediaCollection.guess_tag then begin
                tmps:=extractFileName(path);
                z:=pos(' - ', tmps)+3;
                if z<>3 then begin
                      title:=copy(tmps,z,length(tmps)-z-3);
                      artist:=copy(tmps,1,z-3);
                      album:='';
                    end else begin
                       artist:='';
                       title:='';
                       album:='';
                  end;
         end;

     if ((artistv2<>'') and id3v2) and (main.id3v2_prio or (artist='')) then artist:=TrimRight(artistv2);
     if ((titlev2<>'') and id3v2) and (main.id3v2_prio or (title=''))  then title:=TrimRight(titlev2);
     if ((albumv2<>'') and id3v2) and (main.id3v2_prio or (album='')) then album:=TrimRight(albumv2);
     if ((commentv2<>'') and id3v2) and (main.id3v2_prio or (comment='')) then comment:=TrimRight(commentv2);
     if ((yearv2<>'')  and id3v2) and (main.id3v2_prio or (year='')) then year:=TrimRight(yearv2);
     if ((trackv2<>'') and id3v2) and (main.id3v2_prio or (track='')) then track:=TrimRight(trackv2);

     artist:=TrimRight(artist);
     title:=TrimRight(title);
     album:=TrimRight(Album);
     comment:=TrimRight(Comment);
     year:=TrimRight(Year);
     fileclose(mp3filehandle);
     except
        writeln(path+' ->error opening file... skipped!!');
     end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMp3fileobj.getPath: String;
begin
  result:= FRelativePath + FPath;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMp3fileobj.read_tag_ogg;
begin
   tmps:=extractFileName(path);
   z:=pos(' - ', tmps)+3;
   if z<>3 then begin
       title:=copy(tmps,z,length(tmps)-z-3);
       artist:=copy(tmps,1,z-3);
       album:='';
     end else begin
       artist:='';
       title:='';
       album:='';
    end;
     artist:=TrimRight(artist);
     title:=TrimRight(title);
     album:=TrimRight(Album);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMp3fileobj.read_tag;
begin
 if filetype='.wav' then read_tag_wave;
 if filetype='.ogg' then read_tag_ogg;

 if filetype='.mp3' then read_tag_mp3;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediaCollection.create_title_order;
var n:longint;
begin
     write(' create title order...');
     i:=1;
     z:=2;
     delpos:=1;
     if max_index>2 then repeat begin
       delpos:=i;
       while (lowercase(lib[i].artist)=lowercase(lib[z].artist)) and (z<=max_index-2) do
           begin
               n:=comparestr(lowercase(lib[delpos].title), lowercase(lib[z].title));
               if n>0 then begin
                     delpos:=z;
                    end;
               inc(z);
            end;
         if delpos<>i then begin
             mp3buf:=lib[delpos];
             mp3buf2:=lib[i];

             lib[i]:=mp3buf;
             lib[delpos]:=mp3buf2;
            end;
         inc(i);
         z:=i+1
       end;
      until z>=max_index;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

{procedure TMediaCollection.create_artist_order;
var sorted : boolean;
    n:byte;
begin
      z:=1;
      i:=1;
      delpos:=1;
      if max_index>2 then begin
      repeat begin
        i:=z+1;
        delpos:=z;
        repeat
         begin
           if lowercase(lib[i].artist[1])<lowercase(lib[delpos].artist[1]) then
              begin
                delpos:=i;
               end
             else
               begin
                 if lowercase(lib[i].artist[1])=lowercase(lib[delpos].artist[1]) then begin
                    n:=2;
                    ext:=false;
                    repeat
                      begin
                         if lowercase(lib[i].artist[n])<lowercase(lib[delpos].artist[n]) then
                            begin
                              delpos:=i;
                             end else
                              if lowercase(lib[i].artist[n])<>lowercase(lib[delpos].artist[n]) then ext:=true;
                         inc(n);
                       end;
                     until (n>63) or (ext=true);
                   end;
                end;
           inc(i);
          end;
        until i>max_index-1;
        mp3buf:=lib[delpos];
        mp3buf2:=lib[z];

        lib[z]:=mp3buf;
        lib[delpos]:=mp3buf2;
        inc(z);
       end;
       until z>max_index-2;
       end;
      create_title_order;
end;     }


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function charToLower(c : char):char;
begin
     if (c>=#65) and (c<=#90) then c:=char(byte(c)+32);
     charToLower:=c;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  {
procedure TMediaCollection.create_artist_order;
var n, l1, l2:integer;
    s1, s2: string;
    loopc, biggest: integer;
begin
    z:=1;
    i:=1;
    biggest:=1;
      
    if max_index>2 then begin
      repeat begin
      
        biggest:=z;
        i:=z+1;
        
        repeat
         begin
             s1:=(lib[biggest].artist);
             s2:=(lib[i].artist);
             l1:=length(s1)-1;
             l2:=length(s2)-1;
             if s1<>s2 then begin
                n:=1;
                while (n<=l1) and (n<=l2) and (charToLower(s1[n])=charToLower(s2[n])) do inc(n);
                   
                if (l1>0) and (l2>0) and (charToLower(s1[n])>charToLower(s2[n])) then biggest:=i
                      else if l2<1 then biggest:=i;
              end;
           inc(i);
          end;
        until (i>max_index-1);
        
        mp3buf:=lib[biggest];
        mp3buf2:=lib[z];
       
        lib[z]:=mp3buf;
        lib[biggest]:=mp3buf2;
        inc(z);

       end;
       
      until z>max_index-2;
    end;
    write(' sorting titles ');
    create_title_order;
end;   }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Bubblesort!!!!!!!

procedure TMediaCollection.create_artist_order;
var n, l1, l2:integer;
    s1, s2: string;
    ext: boolean;
begin
    write(' create artist order... ');
    z:=1;
    i:=1;
    ext:=true;
    if max_index>2 then begin
      repeat begin
         i:=1;
         ext:=true;
         repeat begin
             s1:=(lib[i].artist);
             s2:=(lib[i+1].artist);

             if s1<>s2 then begin

                l1:=length(s1);
                l2:=length(s2);
                n:=1;
                while (n<l1) and (n<l2) and (charToLower(s1[n])=charToLower(s2[n])) do inc(n);
                if ( (l1>0) and (l2>0) and ( (charToLower(s1[n])>charToLower(s2[n])) or  ((charToLower(s1[n])=charToLower(s2[n])) and (n=l2) and (l1<>l2)) )) or(l2<1) then begin
                                  mp3buf:=lib[i];
                                  mp3buf2:=lib[i+1];
                                  ext:=false;
                                  lib[i+1]:=mp3buf;
                                  lib[i]:=mp3buf2;
                     end;
              end;

             inc(i);
          end;
        until i>max_index-z-1;
        inc(z);
       end;
      until (z>max_index-1) or (ext=true);
    end;
    create_title_order;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TMp3fileobj.create;  //Dummy to create an empty object
begin
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediacollection.remove_entry(ind:integer);
var z: integer;
begin
     for z:=ind to max_index-2 do begin
         lib[z]:=lib[z+1]
       end;
     dec(max_index);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediacollection.add_file(path:string);
begin
  if FileExists(path) then begin
     lib[max_index]:=TMp3fileobj.index_file(path);
     inc(max_index);
     if high(lib)=max_index then
         begin {library erweitern um 512 eintraege}
           Setlength(lib, max_index+1+512);
         end;
     end
  else writeln('ERROR: File not found -> '+path);
     // create_artist_order;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TMp3fileobj.index_file(filepath:string);
var    Attr:longint;
       tmpfile: file of byte;
begin
     action:= ANOTHING;
     
     path:=filepath;
     Filemode:=0;
     assign(tmpfile, path);
     reset(tmpfile);
     size:=filesize(tmpfile); {get filesize}
    // writeln(path);
     id:= crc32(path) + size;
     filetype:=lowercase(ExtractFileExt(filepath));
     close(tmpfile);
     Filemode:=2;
     attr:=FileGetAttr(filepath);
     if (attr and faReadOnly)=0 then read_only:=false else read_only:=true;
     read_tag;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediacollection.add_directory(dir:string);
var mp3search,dirsearch:TSearchrec;
    tmps:string;
begin
  if (dir[length(dir)]<>DirectorySeparator)then dir:=dir+DirectorySeparator;
  writeln('scanning through:  '+dir);
  main.StatusBar1.Panels[0].Text :='scanning trough:  '+dir;
  Application.ProcessMessages;
   if FindFirst(dir+'*.*',faAnyFile,mp3search)=0 then
        begin
          repeat
              begin
                  tmps:=lowercase(ExtractFileExt(mp3search.name));
                  Application.ProcessMessages;
              //   if statuswin.Cancel=true then exit;
                 if (tmps='.mp3') or (tmps='.wav') or (tmps='.ogg') then begin
                    lib[max_index]:=TMp3fileobj.index_file(dir+mp3search.name);
                    inc(max_index);
                    if high(lib)=max_index then
                            begin {library erweitern um 512 eintraege}
                                Setlength(lib, max_index+1+512);
                             end;
                   end;
               end;
          until FindNext(mp3search)<>0;
         end;
   Findclose(mp3search);
   if Findfirst(dir+'*',faanyfile,dirsearch)=0 then
         begin
             Application.ProcessMessages;
            // if statuswin.Cancel=true then exit;
             repeat
                begin
                   if (dirsearch.attr and FaDirectory)=FaDirectory then begin
                      if pos('.', dirsearch.name)=0 then add_directory(dir+dirsearch.name+DirectorySeparator);
                   end;
                 end;
             until FindNext(dirsearch)<>0;
       end;
     Findclose(dirsearch);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediacollection.scan_directory(dir:string);
var mp3search,dirsearch:TSearchrec;
    tmps:string;
    i: integer;
begin
  if (dir[length(dir)]='\') or (dir[length(dir)]='/') then else dir:=dir+DirectorySeparator;
  doDirSeparators(dir);
  writeln(dir);
   if FindFirst(dir+'*.*',faAnyFile,mp3search)=0 then
        begin
          repeat
              begin
                 tmps:=lowercase(ExtractFileExt(mp3search.name));
                 if (tmps='.mp3') or (tmps='.wav') or (tmps='.ogg') then begin
                    i:=0;
                    repeat inc(i) until (i=max_index) or (lib[i].path=dir+mp3search.Name);
                    if i=max_index then begin
                       CollectionChanged:=true;
                       lib[max_index]:=TMp3fileobj.index_file(dir+mp3search.name);
                       writeln(lib[max_index].path+'added');
                       inc(max_index);

                       if high(lib)=max_index then
                            begin {library erweitern um 512 eintraege}
                                Setlength(lib, max_index+1+512);
                             end;
                      end;
                   end;
               end;
          until FindNext(mp3search)<>0;
         end;
   Findclose(mp3search);
   if Findfirst(dir+'*',faanyfile,dirsearch)=0 then
         begin
             repeat
                begin
                   if (dirsearch.attr and FaDirectory)=FaDirectory then begin
                      if pos('.', dirsearch.name)=0 then scan_directory(dir+dirsearch.name+DirectorySeparator);
                   end;
                 end;
             until FindNext(dirsearch)<>0;
       end;
     Findclose(dirsearch);
end;

procedure TMediacollection.sort;
begin
  create_artist_order;
  create_title_order;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



initialization
end.
