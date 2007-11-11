unit mediacol;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, settings;



type
  // PMediaCollectionClass = ^TMediaCollectionClass;
  TSrchType = ( FTrackSrch_Artist, FTrackSrch_ArtistAlbum, FAlbumSrch, FArtistSrch, FAllArtist );
  TPathFmt = ( FRelative, FDirect );
  
  TMediaCollectionClass = class;
  
  
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TMediaFileClass }

  TMediaFileClass = class
   private
     procedure read_tag_ogg;
     procedure read_tag_wave;
     procedure read_tag_mp3;
     procedure SetArtist(aValue: string);
     procedure SetAlbum(aValue: string);
     procedure SetTitle(aValue: string);
     FTitle, FAlbum, FArtist: string;


   public
     constructor create(filepath:string; ParentCollection: TMediaCollectionClass);
     constructor create(ParentCollection: TMediaCollectionClass);
     destructor destroy;
     procedure Write_Tag;
     procedure Read_Tag;
     procedure assign(SourceObject: TMediaFileClass);
     Path: String;
     CoverPath: ansistring;
     Collection: TMediaCollectionClass;
     property Artist: string read FArtist write SetArtist;
     property Album: string read FAlbum write SetAlbum;
     property Title: string read FTitle write SetTitle;
     Comment: ansistring;
     Year, Track, Filetype:string[4];
     Size: int64;
     ID, Bitrate, Samplerate, Playlength, Action: longint;
     Playtime: string;
     index: integer;
  end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TMediaCollectionClass }

  TMediaCollectionClass = class(Tlist)
   private
     function GetItems(index: integer):TMediaFileClass;
     procedure Recursive_AddDir(dir: string);
     procedure SetAutoEnum(const AValue: boolean);
     procedure SetSorted(const AValue: boolean);
     FSorted, FEnumerated, FAutoEnum: Boolean;
     FSrchAscending: Boolean;
     FSrchPos: Integer;
     FSrchArtist, FSrchAlbum: String;
     FSrchType: TSrchType;
   public
     constructor create;
     destructor destroy;
     procedure Assign(SourceCol:TMediaCollectionClass);
     function  LoadFromFile(path: string):boolean;
     function SaveToFile(path: string):boolean;
     function SaveToFile:boolean;
     procedure clear;
     procedure insert(path: string; atInd: integer);
     function add(path: string): integer;
     function add(MedFileObj: TMediaFileClass): integer;
     procedure add_directory(dir: string);
     procedure remove(ind: integer);
     procedure move(dest, target: integer);
     function ItemCount: integer;
     procedure enumerate;
     procedure enumerate(StartFrom: integer);
     
     function getTracks(artist: string):integer;
     function getTracks(artist: string; StartFrom: integer):integer;
     
     function getTracks(artist, album: string):integer;
     function getTracks(artist, album: string; StartFrom: integer):integer;

     function getAlbums(artist: string):TStringList;
     function getAlbums(artist: string; StartFrom: integer):TStringList;

     function getNext: integer;
     
     function getArtists:integer;
     function getNextArtist: integer;

     function getIndexByPath(path: string):integer;

     syncronize: procedure (dir: string) of object;

     property Items[index: integer]: TMediaFileClass read GetItems;
     property sorted: boolean read FSorted write SetSorted;         // when Sorted is set true, add/insert always adds at right position
                                                                    // on changing state from false to true whole collection is getting sorted once
     property AutoEnum: boolean read FAutoEnum write SetAutoEnum;
     property enumerated: boolean read FEnumerated;
     Savepath: string;
     DirList: TStringList;
     PathFmt: TPathFmt;
  end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

var MediaCollection, PlayerCol :TMediaCollectionClass;

implementation
uses functions;

{$i cactus_const.inc}
const bitrates: array[0..15] of integer = (0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 999);
      samplerates: array[0..3] of integer = (44100, 48000, 32100, 0);




{ TMediaCollectionClass }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMediaCollectionClass.GetItems(index: integer): TMediaFileClass;
begin
{  if (index>=0) and (index < Count) then }Result := (TMediaFileClass(Inherited Items [Index]));
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediaCollectionClass.Recursive_AddDir(dir: string);
var mp3search,dirsearch:TSearchrec;
    tmps:string;
begin
  dir:=IncludeTrailingPathDelimiter(dir);
  writeln('scanning through:  '+dir);
  syncronize(dir);
   if FindFirst(dir+'*.*',faAnyFile,mp3search)=0 then
        begin
          repeat
              begin
                  tmps:=lowercase(ExtractFileExt(mp3search.name));
                 syncronize(dir);
                 if (tmps='.mp3') or (tmps='.wav') or (tmps='.ogg') then begin
                    add(dir+mp3search.name);
                  end;
               end;
          until FindNext(mp3search)<>0;
         end;
   Findclose(mp3search);
   if Findfirst(dir+'*',faanyfile,dirsearch)=0 then
         begin
             syncronize(dir);
             repeat
                begin
                   if (dirsearch.attr and FaDirectory)=FaDirectory then begin
                      if (dirsearch.name<>'..') and (dirsearch.name<>'.') then Recursive_AddDir(IncludeTrailingPathDelimiter(dir+dirsearch.name));
                   end;
                 end;
             until FindNext(dirsearch)<>0;
       end;
     Findclose(dirsearch);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediaCollectionClass.SetAutoEnum(const AValue: boolean);
begin
  FAutoEnum:=AValue;
  enumerate;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediaCollectionClass.SetSorted(const AValue: boolean);
begin
  Fsorted:=AValue;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TMediaCollectionClass.create;
begin
  Inherited create;
  FSorted:=true;
  
  DirList:=TStringList.Create;
  PathFmt:=FDirect;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

destructor TMediaCollectionClass.destroy;
begin

end;

procedure TMediaCollectionClass.Assign(SourceCol: TMediaCollectionClass);
begin

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMediaCollectionClass.LoadFromFile(path: string): boolean;
var i:integer;
    lfile: textfile;
    RPath, tmps: String;
    NumEntries: Integer;
    MedFileObj: TMediaFileClass;
    sortState: boolean;
begin
       savepath:=path;
       sortState:=FSorted;
       try
             system.assign(lfile,path);
             reset(lfile);

             readln(lfile, tmps);
             readln(lfile, tmps);

             readln(lfile, tmps);
             NumEntries:=StrToInt(tmps);
             writeln(NumEntries);
             readln(lfile, tmps);
             if tmps[length(tmps)]=';' then System.Delete(tmps, length(tmps), 1);
             i:= pos(';', tmps);
             while i<>0 do begin
                  DirList.Add(IncludeTrailingPathDelimiter(copy(tmps, 1, i-1)));
                  system.delete(tmps, 1, i);
                  i:= pos(';', tmps);
             end;
             DirList.Add(tmps);
             if PathFmt = FRelative then RPath:=IncludeTrailingPathDelimiter(DirList[0]) else RPath:='';
             readln(lfile);
             fsorted:=false;
             for i:= 0 to  NumEntries-1 do begin
                 MedFileObj:=TMediaFileClass.create(self);
                 MedFileObj.action:=ANOTHING;
                 readln(lfile, MedFileObj.path);
                 if PathFmt = FRelative then MedFileObj.Path:=RPath+MedFileObj.Path;
                 readln(lfile, MedFileObj.id);
                 readln(lfile, MedFileObj.artist);
                 readln(lfile, MedFileObj.album);
                 readln(lfile, MedFileObj.title);
                 readln(lfile, MedFileObj.year);
                 readln(lfile, MedFileObj.comment);
                 readln(lfile, MedFileObj.track);
                 readln(lfile, MedFileObj.size);
                 readln(lfile, MedFileObj.filetype);
                 readln(lfile, MedFileObj.bitrate);
                 readln(lfile, MedFileObj.samplerate);
                 readln(lfile, MedFileObj.playlength);
                 readln(lfile, MedFileObj.playtime);
                 add(MedFileObj);
               end;
             fsorted:=sortState;
             AutoEnum:=true;
             close(lfile);
             writeln('library sucessfully loaded');
             result:=true;
         except
              fsorted:=sortState;
              writeln('lib seems corupted');
              write('exception at entry ');writeln(i);
              result:=false;
     end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMediaCollectionClass.SaveToFile(path: string): boolean;
var lfile: textfile;
    i:integer;
    tmps: string;
begin
       savepath:=path;
       writeln('saving library to -> '+path);
       try
             system.assign(lfile,path);
             rewrite(lfile);
             writeln(lfile,'#####This config file is created by Cactus Jukebox. NEVER(!!) edit by hand!!!####');
             writeln(lfile,'++++Config++++');
             writeln(lfile, ItemCount);
             for i:= 0 to DirList.Count-1 do tmps:=tmps+DirList.Strings[i]+';';
             writeln(lfile, tmps);
             writeln(lfile,'++++Files++++');
             tmps:='';
             for i:= 0 to ItemCount-1 do begin
                 if PathFmt = FDirect then
                            tmps:= items[i].Path
                     else begin
                            tmps:=copy(items[i].path, length(DirList[0]), length(items[i].path) - length(DirList[0])+1);
                            if tmps[1]=DirectorySeparator then system.Delete(tmps, 1, 1);
                          end;
                 //writeln(tmps);
                 writeln(lfile,tmps);
                 writeln(lfile,items[i].id);
                 writeln(lfile,items[i].artist);
                 writeln(lfile, items[i].album);
                 writeln(lfile, items[i].title);
                 writeln(lfile, items[i].year);
                 writeln(lfile, items[i].comment);
                 writeln(lfile, items[i].track);
                 writeln(lfile,items[i].size);
                 writeln(lfile,items[i].filetype);
                 writeln(lfile,items[i].bitrate);
                 writeln(lfile,items[i].samplerate);
                 writeln(lfile,items[i].playlength);
                 writeln(lfile,items[i].playtime);
                end;
             close(lfile);
             write('written ');write(i);write(' of ');writeln(ItemCount);
         except
              writeln('error writing library to disk: check permissions!');
              write('written ');write(i);write(' of ');writeln(ItemCount);
           end;
end;

function TMediaCollectionClass.SaveToFile: boolean;
begin
  result:=SaveToFile(Savepath);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediaCollectionClass.clear;
begin
   while count>0 do remove(0);
  // remove(0);
   DirList.Clear;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediaCollectionClass.insert(path: string; atInd: integer);
var i: integer;
begin
 inherited Insert(atInd, TMediaFileClass.create(path, self));
 items[atInd].index:=atInd;
 items[atInd].Collection:=self;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMediaCollectionClass.add(path: string):integer;
var i,z: integer;
    MedFileObj: TMediaFileClass;
    SortedState: boolean;
begin
 i:=0;
 SortedState:=FSorted;
 FSorted:=false;
 MedFileObj:=TMediaFileClass.create(path, self);
 if (SortedState) then begin
     if MedFileObj.Artist<>'' then begin
       while (i<ItemCount) and (CompareText(items[i].Artist, MedFileObj.Artist)<0)
             do inc(i);
             
       while (i<=ItemCount-1) and (CompareText(items[i].Artist, MedFileObj.Artist)=0) and
             (CompareText(items[i].Title, MedFileObj.Title)<0)
           do inc(i);
     end else i:=0;
     inherited Insert(i, MedFileObj);
     if AutoEnum then enumerate(i) else FEnumerated:=false;
   end else begin
      i:=inherited Add(MedFileObj);
      items[i].index:=i;
  end;
  items[i].Collection:=self;
  result:=i;
  FSorted:=SortedState;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMediaCollectionClass.add(MedFileObj: TMediaFileClass): integer;
var i: integer;
    SortedState: boolean;
begin
 SortedState:=FSorted;
 FSorted:=false;
 i:=0;
 if SortedState then begin
     if MedFileObj.Artist<>'' then begin
       while (i<ItemCount) and (CompareText(items[i].Artist, MedFileObj.Artist)<0)
             do inc(i);

       while (i<=ItemCount-1) and (CompareText(items[i].Artist, MedFileObj.Artist)=0) and
             (CompareText(items[i].Title, MedFileObj.Title)<0)
           do inc(i);
     end;
     inherited Insert(i, MedFileObj);
     if AutoEnum then enumerate(i) else FEnumerated:=false;
   end else begin
      i:=inherited Add(MedFileObj);
      items[i].index:=i;
  end;
  items[i].Collection:=self;
  result:=i;
  FSorted:=SortedState;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediaCollectionClass.add_directory(dir: string);
begin
  DirList.Add(dir);
  Recursive_AddDir(dir);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediaCollectionClass.remove(ind: integer);
var i: integer;
begin
  if (ind>=0) and (ind < Count) then begin
     Items[ind].free;
     inherited Delete(ind);
     if (FSrchPos<=ind) and (FSrchAscending=False) then dec(FSrchPos);
     if (FSrchPos>ind) and (FSrchAscending) then dec(FSrchPos);
     if AutoEnum then enumerate(ind) else FEnumerated:=false;
  end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediaCollectionClass.move(dest, target: integer);
begin
//TODO: Test move operation for all FsrchPos cases
  inherited move(dest, target);
//  if (FSrchPos>=dest) and (FSrchPos>target) then inc(FSrchPos);
  if (FSrchPos>=dest) and (FSrchPos<target) then dec(FSrchPos);
  
  
//  if (FSrchPos>ind) and (FSrchAscending) then dec(FSrchPos);

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMediaCollectionClass.ItemCount: integer;
begin
  Result:= Inherited Count;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediaCollectionClass.enumerate;
begin
  enumerate(0);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediaCollectionClass.enumerate(StartFrom: integer);
var i:integer;
begin
  for i:=StartFrom to ItemCount-1 do items[i].index:=i;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMediaCollectionClass.GetTracks(artist: string): integer;
begin
   result:=getTracks(artist, 0);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMediaCollectionClass.getTracks(artist, album: string): integer;
begin
 result:=getTracks(artist, album, 0);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMediaCollectionClass.GetTracks(artist: string; StartFrom: integer): integer;
var i: integer;
begin
   FSrchType:=FTrackSrch_Artist;
   
   artist:=lowercase(artist);
   FSrchArtist:=artist;
   if StartFrom<>0 then begin
      if (sorted=false) then
         StartFrom:=0
       else begin
         i:= AnsiCompareText(Items[StartFrom].Artist, artist);
         if (i=0) or (i>0) then FSrchAscending:=true else FSrchAscending:=false;
        end;
   end;

   i:=StartFrom;
   if (i<>0) and (FSrchAscending) then begin
        while (lowercase(Items[i].Artist)<>artist) and (i>=0) do dec(i);
        while (lowercase(Items[i].Artist)=artist) and (i>0) do dec(i);
        inc(i);
        FSrchPos:=i;
     end else begin
        while (lowercase(Items[i].Artist)<>artist) and (i<Count) do inc(i);
        if i<>Count then FSrchPos:=i else FSrchPos:=-1;
    end;

   Result:=FSrchPos;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMediaCollectionClass.getTracks(artist, album: string;
  StartFrom: integer): integer;
var i:integer;
begin
  i:=getTracks(artist, StartFrom);
  FSrchType:=FTrackSrch_ArtistAlbum;
  while lowercase(items[i].Album)<>album do inc(i);
  FSrchArtist:=artist;
  FSrchAlbum:=album;
  FSrchPos:=i;
  Result:=i;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMediaCollectionClass.getAlbums(artist: string): TStringList;
begin

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMediaCollectionClass.getAlbums(artist: string; StartFrom: integer
  ): TStringList;
var tmplist : TStringList;
    i: integer;
begin
   artist:=lowercase(artist);
   if StartFrom<>0 then begin
      if (sorted=false) then
         StartFrom:=0
       else begin
         i:= AnsiCompareText(Items[StartFrom].Artist, artist);
         if (i=0) or (i>0) then FSrchAscending:=true else FSrchAscending:=false;
        end;
   end;

   i:=StartFrom;
   if (i<>0) and (FSrchAscending) then begin
        while (lowercase(Items[i].Artist)<>artist) and (i>=0) do dec(i);
        while (lowercase(Items[i].Artist)=artist) and (i>0) do dec(i);
        inc(i);
     end else begin
        while (i<count) and (lowercase(Items[i].Artist)<>artist) do inc(i);
        if i=Count then i:=-1;
    end;
   tmplist:=TStringList.Create;
   tmplist.Sorted:=true;
   tmplist.CaseSensitive:=false;
   tmplist.Duplicates:=dupIgnore;
   if (i>=0) and (i<Count) then begin
   
       while (i<Count) and (lowercase(Items[i].Artist)=artist) do begin
             if Items[i].Album<>'' then tmplist.AddObject(items[i].Album, Items[i])
                    else tmplist.AddObject('Unknown', Items[i]);
             inc(i);
           end;
       Result:=tmplist;
   end;

end;


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMediaCollectionClass.getArtists: integer;
begin
   FSrchPos:=0;
   FSrchArtist:=lowercase(Items[0].Artist);
   result:=FSrchPos;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMediaCollectionClass.getNextArtist: integer;
var i: integer;
begin
    i:=FSrchPos;
    repeat inc(i) until (i>=Count) or (lowercase(items[i].Artist)<>FSrchArtist);
    if i<Count then begin
         FSrchArtist:=lowercase(Items[i].Artist);
         FSrchPos:=i;
         Result:=i;
      end else result:=-1;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMediaCollectionClass.GetNext: integer;
var i: integer;
begin
  Case FSrchType of
    FTrackSrch_Artist:  begin
            repeat inc(FSrchPos)
            until (FSrchPos>=ItemCount) or (lowercase(Items[FSrchPos].Artist)=FSrchArtist);
            if (FSrchPos<>ItemCount) and (lowercase(Items[FSrchPos].Artist)=FSrchArtist)then
                    result:=FSrchPos
                  else
                    result:=-1;
            exit;
       end;
    FTrackSrch_ArtistAlbum: begin
            repeat inc(FSrchPos)
            until (FSrchPos>=ItemCount) or ((lowercase(Items[FSrchPos].Album)=FSrchAlbum) and (lowercase(Items[FSrchPos].Artist)=FSrchArtist));
            if (FSrchPos<>ItemCount) and ((lowercase(Items[FSrchPos].Album)=FSrchAlbum) and (lowercase(Items[FSrchPos].Artist)=FSrchArtist)) then
                    result:=FSrchPos
                 else
                     result:=-1;
            exit;
       end;
  end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMediaCollectionClass.GetIndexByPath(path: string): integer;
var i: integer;
begin
   i:=ItemCount;
   repeat dec(i) until (i<0) or (items[i].Path=path);
   result:=i;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TMediaFileClass }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure TMediaFileClass.read_tag_ogg;
var z:integer;
    tmps: String;
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

procedure TMediaFileClass.read_tag_wave;
var li: cardinal;
    b: byte;
    z: integer;
    mp3filehandle:longint;
    tmps: string;
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

   playtime:=SecondsToFmtStr(Playlength);

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

procedure TMediaFileClass.read_tag_mp3;
var b:byte;
    i, z, tagpos:integer;
    buf: array[1..1024] of byte;
    artistv2, albumv2, titlev2, commentv2, yearv2, trackv2: string;
    bufstr:string;
    mp3filehandle:longint;
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
                 playtime:=SecondsToFmtStr(Playlength);
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
        end;
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
         end;

     if ((artistv2<>'')) and (CactusConfig.id3v2_prio or (artist='')) then artist:=TrimRight(artistv2);
     if ((titlev2<>'')) and (CactusConfig.id3v2_prio or (title=''))  then title:=TrimRight(titlev2);
     if ((albumv2<>'')) and (CactusConfig.id3v2_prio or (album='')) then album:=TrimRight(albumv2);
     if ((commentv2<>'')) and (CactusConfig.id3v2_prio or (comment='')) then comment:=TrimRight(commentv2);
     if ((yearv2<>'')) and (CactusConfig.id3v2_prio or (year='')) then year:=TrimRight(yearv2);
     if ((trackv2<>'')) and (CactusConfig.id3v2_prio or (track='')) then track:=TrimRight(trackv2);

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

procedure TMediaFileClass.SetArtist(aValue: string);
var i, start: integer;
begin
  i:=index;
  start:=index;
  FArtist:=aValue;
  if Collection.sorted then begin
         if (i<Collection.Count-1) and (CompareText(FArtist, Collection.Items[i+1].Artist)>0) then
             begin
               inc(i);
               while (i<=Collection.Count-1) and (compareText(FArtist, Collection.Items[i].Artist)>0) do
                 begin
                   inc(i);
                 end;
               while (i<=Collection.Count-1) and (compareText(FTitle, Collection.Items[i].Title)>0)
                       and (CompareText(FArtist, Collection.Items[i].Artist)=0) do
                 begin
                   inc(i);
                 end;
               Collection.Move(index, i-1);
               if Collection.AutoEnum then Collection.enumerate(start);
             end;
         if (i>0) and (CompareText(FArtist, Collection.Items[i-1].Artist)<0) then
             begin
               dec(i);
               while (i>=0) and (compareText(FArtist, Collection.Items[i].Artist)<0) do
                 begin
                   dec(i);
                 end;

               while ((i>=0) and (compareText(FTitle, Collection.Items[i].Title)<0))
                      and (CompareText(FArtist, Collection.Items[i].Artist)=0) do
                 begin
                   dec(i);
                 end;
               Collection.Move(index, i+1);
               if Collection.AutoEnum then Collection.enumerate;
             end;
       end;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediaFileClass.SetAlbum(aValue: string);
begin
   FAlbum:=aValue;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediaFileClass.SetTitle(aValue: string);
var i, start: integer;
begin
  FTitle:=aValue;
  i:=index;
  start:=index;
  if Collection.sorted then begin
      writeln(i);
      if (i<Collection.Count-1) and (CompareText(FTitle, Collection.Items[i+1].Title)>0)
            and (CompareText(FArtist, Collection.Items[i+1].Artist)=0) then begin
         inc(i);
         while ((i<=Collection.Count-1) and (compareText(FTitle, Collection.Items[i].Title)>0))
               and (CompareText(FArtist, Collection.Items[i].Artist)=0) do
             begin
                inc(i);
             end;
         Collection.Move(index, i-1);
         if Collection.AutoEnum then Collection.enumerate(start);
      end;

      if (i>0) and (CompareText(FTitle, Collection.Items[i-1].Title)<0)
            and (CompareText(FArtist, Collection.Items[i-1].Artist)=0) then begin
         dec(i);
         while ((i>=0) and (compareText(FTitle, Collection.Items[i].Title)<0))
                and (compareText(FArtist, Collection.Items[i].Artist)=0) do
             begin
                dec(i);
             end;
         Collection.Move(index, i+1);
         if Collection.AutoEnum then Collection.enumerate;
      end;
  end;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TMediaFileClass.create(filepath: string; ParentCollection: TMediaCollectionClass);
var tmpfile: file of byte;
begin
   Collection:=ParentCollection;
   path:=filepath;
   action:= ANOTHING;

   Filemode:=0;
//   try
     system.assign(tmpfile, path); //Open file temporaly to get some information about it
     reset(tmpfile);
     size:=filesize(tmpfile); //get filesize
     ID:= crc32(path);        // calc unique file ID
     filetype:=lowercase(ExtractFileExt(filepath));
     close(tmpfile);
//   except writeln('ERROR reading file '+filepath);end;
   Filemode:=2;

   read_tag; //finally read tag information
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TMediaFileClass.create(ParentCollection: TMediaCollectionClass);
begin

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

destructor TMediaFileClass.destroy;
begin
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediaFileClass.Write_Tag;
var
       buf: array[1..1024] of byte;
       bufstr, tmptag, tmps:string;
//       artistv2, albumv2, titlev2, commentv2, yearv2, trackv2: string;
       i, z:integer;
       id3v1str: string[31];
       mp3filehandle:longint;
begin
{id3v2}
  mp3filehandle:=fileopen(path,fmOpenRead);
  fileseek(mp3filehandle, 0, fsfrombeginning);
  fileread(mp3filehandle, buf, high(buf));
  fileclose(mp3filehandle);
  for i:= 1 to high(buf) do bufstr:=bufstr+char(buf[i]);

  if (pos('ID3',bufstr) <> 0) or (length(artist)>30) or (length(title)>30) or (length(album)>30) then
    begin
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
                     tmptag:=UTF8toLatin1(artist);
                     if length(tmptag)>0 then begin
                        Delete(bufstr, i+11, byte(bufstr[i+7])-1);
                        Insert(tmptag, bufstr, i+11);
                        bufstr[i+7]:=char(length(tmptag)+1);
                      end else Delete(bufstr, i, byte(bufstr[i+7])+10);
                end else begin
                     tmptag:=UTF8toLatin1(artist);
                     if length(tmptag)>0 then begin
                        tmps:=char(0)+char(0)+char(0)+char(length(tmptag)+1)+char(0)+char(0)+char(0);
                        Insert('TPE1'+tmps+(tmptag), bufstr, pos('ID3',bufstr)+10);
                      end;
                   end;

             i:=pos('TP1',bufstr);
             if i<> 0 then
                begin
                     tmptag:=UTF8toLatin1(artist);
                     Delete(bufstr, i, byte(bufstr[i+5])+6); //delete whole TP1 tag
                end;

             i:=pos('TIT2',bufstr);
             if i<> 0 then
                begin
                     tmptag:=UTF8toLatin1(title);
                     if length(tmptag)>0 then begin
                        Delete(bufstr, i+11, byte(bufstr[i+7])-1);
                        Insert(tmptag, bufstr, i+11);
                        bufstr[i+7]:=char(length(tmptag)+1);
                      end else Delete(bufstr, i, byte(bufstr[i+7])+10);
                end else begin
                     tmptag:=UTF8toLatin1(title);
                     if length(tmptag)>0 then begin
                         tmps:=char(0)+char(0)+char(0)+char(length(tmptag)+1)+char(0)+char(0)+char(0);
                         Insert('TIT2'+tmps+tmptag, bufstr, pos('ID3',bufstr)+10);
                       end;
                   end;

             i:=pos('TRCK',bufstr);
             if i<> 0 then
                begin
                     tmptag:=UTF8toLatin1(track);
                     if length(tmptag)>0 then begin
                          Delete(bufstr, i+11, byte(bufstr[i+7])-1);
                          Insert(tmptag, bufstr, i+11);
                          bufstr[i+7]:=char(length(tmptag)+1);
                        end else Delete(bufstr, i, byte(bufstr[i+7])+10);
                end else begin
                     tmptag:=UTF8toLatin1(track);
                     if length(tmptag)>0 then begin
                        tmps:=char(0)+char(0)+char(0)+char(length(tmptag)+1)+char(0)+char(0)+char(0);
                        Insert('TRCK'+tmps+tmptag, bufstr, pos('ID3',bufstr)+10);
                      end;
                   end;

             i:=pos('TYER',bufstr);
             if i<> 0 then
                begin
                     tmptag:=UTF8toLatin1(year);
                     if length(tmptag)>0 then begin
                        Delete(bufstr, i+11, byte(bufstr[i+7])-1);
                        Insert(tmptag, bufstr, i+11);
                        bufstr[i+7]:=char(length(tmptag)+1);
                      end else Delete(bufstr, i, byte(bufstr[i+7])+10);
                end else begin
                     tmptag:=UTF8toLatin1(year);
                     if length(tmptag)>0 then begin
                        tmps:=char(0)+char(0)+char(0)+char(length(tmptag)+1)+char(0)+char(0)+char(0);
                        Insert('TYER'+tmps+tmptag, bufstr, pos('ID3',bufstr)+10);
                      end;
                   end;

             i:=pos('TALB',bufstr);
             if i<> 0 then
                begin
                     tmptag:=UTF8toLatin1(album);
                     if length(tmptag)>0 then begin
                        Delete(bufstr, i+11, byte(bufstr[i+7])-1);
                        Insert(tmptag, bufstr, i+11);
                        bufstr[i+7]:=char(length(tmptag)+1);
                      end else Delete(bufstr, i, byte(bufstr[i+7])+10);
                end else begin
                     tmptag:=UTF8toLatin1(album);
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
           if FileGetAttr(Path)=faReadOnly then writeln('file is read only');
           fileseek(mp3filehandle,-128,fsfromend);
           writeln(title);
           writeln(artist);
           filewrite(mp3filehandle,buf,128);
           fileclose(mp3filehandle);
     end else writeln('ERROR: cant write tag. file not found');

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediaFileClass.Read_Tag;
begin
 if filetype='.wav' then read_tag_wave;
 if filetype='.ogg' then read_tag_ogg;
 if filetype='.mp3' then read_tag_mp3;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMediaFileClass.assign(SourceObject: TMediaFileClass);
begin

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end.

