
Unit mediacol;

{$mode objfpc}{$H+}

Interface

Uses 
Classes, SysUtils;



Type 
  // PMediaCollectionClass = ^TMediaCollectionClass;
  TSrchType = ( FTrackSrch_Artist, FTrackSrch_ArtistAlbum, FAlbumSrch, FArtistSrch, FAllArtist );
  TMediaType = (MTAudioFile, MTStream, MTCDAudio);
  TPathFmt = ( FRelative, FDirect );

  TMediaCollectionClass = Class;


    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TMediaFileClass }

    TMediaFileClass = Class
      Private 
      Procedure read_tag_ogg;
      Procedure read_tag_wave;
      Procedure read_tag_mp3;
      Procedure SetArtist(aValue: String);
      Procedure SetAlbum(aValue: String);
      Procedure SetTitle(aValue: String);
      Procedure setStreamUrl(aValue: String);
      FTitle, FAlbum, FArtist: string;
      FStreamUrl: string;
      FMediaType: TMediaType;

      Public 
      constructor create(filepath:String; ParentCollection: TMediaCollectionClass);
      constructor create(ParentCollection: TMediaCollectionClass);
      destructor destroy;
      Procedure Write_Tag;
      Procedure Read_Tag;
      Procedure assign(SourceObject: TMediaFileClass);
      Function PathNameFromTag(var strFormat: string): Boolean;
      Function PathNameFromTag_dryrun(var strFormat: string): string;
      Function FullPathNameFromTag_dryrun(var strFormat: string): string;
      Function move2path(strFilePath: string): Boolean;
      Function LibraryPath(): string;
      Path: String;
      CoverPath: ansistring;
      Collection: TMediaCollectionClass;
      property Artist: string read FArtist write SetArtist;
      property Album: string read FAlbum write SetAlbum;
      property Title: string read FTitle write SetTitle;
      property StreamUrl: string read FStreamUrl write SetStreamUrl;
      Comment: ansistring;
      Year, Track, Filetype: string[4];
      Size: int64;
      ID, Bitrate, Samplerate, Playlength, Action: longint;
      Playtime: string;
      index: integer;
      property MediaType: TMediaType read FMEdiaType;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TMediaCollectionClass }

    TMediaCollectionClass = Class(Tlist)
     Private
      Function GetItems(index: integer): TMediaFileClass;
      Procedure Recursive_AddDir(dir: String);
      Procedure SetAutoEnum(Const AValue: boolean);
      Procedure SetSorted(Const AValue: boolean);
      FSorted, FEnumerated, FAutoEnum: Boolean;
      FSrchAscending: Boolean;
      FSrchPos: Integer;
      FSrchArtist, FSrchAlbum: String;
      FSrchType: TSrchType;
     Public
      constructor create;
      destructor destroy;
      Procedure Assign(SourceCol:TMediaCollectionClass);
      Function  LoadFromFile(path: String): boolean;
      Function SaveToFile(path: String): boolean;
      Function SaveToFile: boolean;
      Procedure clear;
      Procedure insert(path: String; atInd: integer);
      Function add(path: String): integer;
      Function add(MedFileObj: TMediaFileClass): integer;
      Procedure add_directory(dir: String);
      Procedure remove(ind: integer);
      Procedure move(dest, target: integer);
      Function ItemCount: integer;
      Procedure enumerate;
      Procedure enumerate(StartFrom: integer);

      Function getTracks(artist: String): integer;
      Function getTracks(artist: String; StartFrom: integer): integer;

      Function getTracks(artist, album: String): integer;
      Function getTracks(artist, album: String; StartFrom: integer): integer;

      Function getAlbums(artist: String): TStringList;
      Function getAlbums(artist: String; StartFrom: integer): TStringList;

      Function getNext: integer;

      Function getArtists: integer;
      Function getNextArtist: integer;

      Function getIndexByPath(path: String): integer;

      syncronize: Procedure (dir: String) Of object;

      property Items[index: integer]: TMediaFileClass read GetItems;
      property sorted: boolean read FSorted write SetSorted;
      // when Sorted is set true, add/insert always adds at right position
      // on changing state from false to true whole collection is getting sorted once
      property AutoEnum: boolean read FAutoEnum write SetAutoEnum;
      property enumerated: boolean read FEnumerated;
      Savepath: string;
      DirList: TStringList;
      PathFmt: TPathFmt;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Var MediaCollection, PlayerCol : TMediaCollectionClass;

      Implementation

      Uses functions, config;

{$i cactus_const.inc}

    Const bitrates: array[0..15] Of integer = (0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192,
                                               224, 256, 320, 999);
      samplerates: array[0..3] Of integer = (44100, 48000, 32100, 0);




{ TMediaCollectionClass }

      //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Function TMediaCollectionClass.GetItems(index: integer): TMediaFileClass;
    Begin
    if (index>=0) and (index < Count) then
      Result := (TMediaFileClass(Inherited Items [Index]));
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaCollectionClass.Recursive_AddDir(dir: String);

    Var mp3search,dirsearch: TSearchrec;
      tmps: string;
      fHandle: file Of byte;
    Begin
      dir := IncludeTrailingPathDelimiter(dir);
      writeln('scanning through:  '+dir);
      syncronize(dir);
      If FindFirst(dir+'*.*',faAnyFile,mp3search)=0 Then
        Begin
          Repeat
            Begin
              tmps := lowercase(ExtractFileExt(mp3search.name));
              syncronize(dir);
              If (tmps='.mp3') Or (tmps='.wav') Or (tmps='.ogg') Then
                Begin
                  // Files with bad filenames may suddenly vanish from samba
                  // mounts when accessed. This will fiter them out.
                  system.assign(fHandle, dir+mp3search.name);
                  {$I-}
                  reset(fHandle);
                  close(fHandle);
                  {$I+}
                  if IOResult = 0
                  then
                    add(dir+mp3search.name);
                End;
            End;
          Until FindNext(mp3search)<>0;
        End;
      Findclose(mp3search);
      If Findfirst(dir+'*',faanyfile,dirsearch)=0 Then
        Begin
          syncronize(dir);
          Repeat
            Begin
              If (dirsearch.attr And FaDirectory)=FaDirectory Then
                Begin
                  If (dirsearch.name<>'..') And (dirsearch.name<>'.') Then
                        Recursive_AddDir(IncludeTrailingPathDelimiter(dir+dirsearch.name));
                End;
            End;
          Until FindNext(dirsearch)<>0;
        End;
      Findclose(dirsearch);
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaCollectionClass.SetAutoEnum(Const AValue: boolean);
    Begin
      FAutoEnum := AValue;
      enumerate;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaCollectionClass.SetSorted(Const AValue: boolean);
    Begin
      Fsorted := AValue;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    constructor TMediaCollectionClass.create;
    Begin
      Inherited create;
      FSorted := true;

      DirList := TStringList.Create;
      PathFmt := FDirect;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    destructor TMediaCollectionClass.destroy;
    Begin

    End;

    Procedure TMediaCollectionClass.Assign(SourceCol: TMediaCollectionClass);
    Begin

    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Function TMediaCollectionClass.LoadFromFile(path: String): boolean;

    Var i: integer;
      lfile: textfile;
      RPath, tmps: String;
      NumEntries: Integer;
      MedFileObj: TMediaFileClass;
      sortState: boolean;
    Begin
      savepath := path;
      sortState := FSorted;
      Try
        system.assign(lfile,path);
        reset(lfile);

        readln(lfile, tmps);
        readln(lfile, tmps);

        readln(lfile, tmps);
        NumEntries := StrToInt(tmps);
        writeln(NumEntries);
        readln(lfile, tmps);
        If tmps[length(tmps)]=';' Then System.Delete(tmps, length(tmps), 1);
        i := pos(';', tmps);
        While i<>0 Do
          Begin
            DirList.Add(IncludeTrailingPathDelimiter(copy(tmps, 1, i-1)));
            system.delete(tmps, 1, i);
            i := pos(';', tmps);
          End;
        DirList.Add(tmps);
        If PathFmt = FRelative Then RPath := IncludeTrailingPathDelimiter(DirList[0])
        Else RPath := '';
        readln(lfile);
        fsorted := false;
        For i:= 0 To  NumEntries-1 Do
          Begin
            MedFileObj := TMediaFileClass.create(self);
            MedFileObj.action := ANOTHING;
            readln(lfile, MedFileObj.path);
            If PathFmt = FRelative Then MedFileObj.Path := RPath+MedFileObj.Path;
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
          End;
        fsorted := sortState;
        AutoEnum := true;
        close(lfile);
        writeln('library sucessfully loaded');
        result := true;
      Except
        fsorted := sortState;
        writeln('lib seems corupted');
        write('exception at entry ');
        writeln(i);
        result := false;
      End;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Function TMediaCollectionClass.SaveToFile(path: String): boolean;

    Var lfile: textfile;
      i: integer;
      tmps: string;
    Begin
      savepath := path;
      writeln('saving library to -> '+path);
      Try
        system.assign(lfile,path);
        rewrite(lfile);
        writeln(lfile,
                '#####This config file is created by Cactus Jukebox. NEVER(!!) edit by hand!!!####')
        ;
        writeln(lfile,'++++Config++++');
        writeln(lfile, ItemCount);
        For i:= 0 To DirList.Count-1 Do
          tmps := tmps+DirList.Strings[i]+';';
        writeln(lfile, tmps);
        writeln(lfile,'++++Files++++');
        tmps := '';
        For i:= 0 To ItemCount-1 Do
          Begin
            If PathFmt = FDirect Then
              tmps := items[i].Path
            Else
              Begin
                tmps := copy(items[i].path, length(DirList[0]), length(items[i].path) - length(
                        DirList[0])+1);
                If tmps[1]=DirectorySeparator Then system.Delete(tmps, 1, 1);
              End;
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
          End;
        close(lfile);
        write('written ');
        write(i);
        write(' of ');
        writeln(ItemCount);
      Except
        writeln('error writing library to disk: check permissions!');
        write('written ');
        write(i);
        write(' of ');
        writeln(ItemCount);
      End;
    End;

    Function TMediaCollectionClass.SaveToFile: boolean;
    Begin
      result := SaveToFile(Savepath);
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaCollectionClass.clear;
    Begin
      While count>0 Do
        remove(0);
      // remove(0);
      DirList.Clear;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaCollectionClass.insert(path: String; atInd: integer);

    Var i: integer;
    Begin
      inherited Insert(atInd, TMediaFileClass.create(path, self));
      items[atInd].index := atInd;
      items[atInd].Collection := self;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Function TMediaCollectionClass.add(path: String): integer;

    Var i,z: integer;
      MedFileObj: TMediaFileClass;
      SortedState: boolean;
    Begin
      i := 0;
      SortedState := FSorted;
      FSorted := false;
      MedFileObj := TMediaFileClass.create(path, self);
      If (SortedState) Then
        Begin
          If (MedFileObj.Artist<>'') and (ItemCount>0) Then
            Begin
              While (i<ItemCount) And (CompareText(items[i].Artist, MedFileObj.Artist)<0) 
                Do
                inc(i);
              While (i<=ItemCount-1) And (CompareText(items[i].Artist, MedFileObj.Artist)=0) And
                    (CompareText(items[i].Title, MedFileObj.Title)<0) 
                Do
                inc(i);
            End
          Else i := 0;
          inherited Insert(i, MedFileObj);
          If AutoEnum Then enumerate(i)
          Else FEnumerated := false;
        End
      Else
        Begin
          i := Inherited Add(MedFileObj);
          items[i].index := i;
        End;
      items[i].Collection := self;
      result := i;
      FSorted := SortedState;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Function TMediaCollectionClass.add(MedFileObj: TMediaFileClass): integer;

    Var i: integer;
      SortedState: boolean;
    Begin
      SortedState := FSorted;
      FSorted := false;
      i := 0;
      If SortedState Then
        Begin
          If MedFileObj.Artist<>'' Then
            Begin
              While (i<ItemCount) And (CompareText(items[i].Artist, MedFileObj.Artist)<0) 
                Do
                inc(i);

              While (i<=ItemCount-1) And (CompareText(items[i].Artist, MedFileObj.Artist)=0) And
                    (CompareText(items[i].Title, MedFileObj.Title)<0) 
                Do
                inc(i);
            End;
          inherited Insert(i, MedFileObj);
          If AutoEnum Then enumerate(i)
          Else FEnumerated := false;
        End
      Else
        Begin
          i := Inherited Add(MedFileObj);
          items[i].index := i;
        End;
      items[i].Collection := self;
      result := i;
      FSorted := SortedState;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaCollectionClass.add_directory(dir: String);
    Begin
      DirList.Add(dir);
      Recursive_AddDir(dir);
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaCollectionClass.remove(ind: integer);

    Var i: integer;
    Begin
      If (ind>=0) And (ind < Count) Then
        Begin
          Items[ind].free;
          inherited Delete(ind);
          dec(FSrchPos);
{          If (FSrchPos<=ind) Then dec(FSrchPos);
          If (FSrchPos>ind) And (FSrchAscending) Then dec(FSrchPos);}
          If AutoEnum Then enumerate(ind)
          Else FEnumerated := false;
        End;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaCollectionClass.move(dest, target: integer);
    Begin
      //TODO: Test move operation for all FsrchPos cases
      inherited move(dest, target);
      //  if (FSrchPos>=dest) and (FSrchPos>target) then inc(FSrchPos);
      If (FSrchPos>=dest) And (FSrchPos<target) Then dec(FSrchPos);


      //  if (FSrchPos>ind) and (FSrchAscending) then dec(FSrchPos);

    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Function TMediaCollectionClass.ItemCount: integer;
    Begin
      Result := Inherited Count;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaCollectionClass.enumerate;
    Begin
      enumerate(0);
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaCollectionClass.enumerate(StartFrom: integer);

    Var i: integer;
    Begin
      For i:=StartFrom To ItemCount-1 Do
        items[i].index := i;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Function TMediaCollectionClass.GetTracks(artist: String): integer;
    Begin
      result := getTracks(artist, 0);
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Function TMediaCollectionClass.getTracks(artist, album: String): integer;
    Begin
      result := getTracks(artist, album, 0);
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Function TMediaCollectionClass.GetTracks(artist: String; StartFrom: integer): integer;

    Var i: integer;
    Begin
      FSrchType := FTrackSrch_Artist;

      artist := lowercase(artist);
      FSrchArtist := artist;
      If StartFrom<>0 Then
        Begin
          If (sorted=false) Then
            StartFrom := 0
          Else
            Begin
              i := AnsiCompareText(Items[StartFrom].Artist, artist);
              If (i=0) Or (i>0) Then FSrchAscending := true
              Else FSrchAscending := false;
            End;
        End;

      i := StartFrom;
      If (i<>0) And (FSrchAscending) Then
        Begin
          While (lowercase(Items[i].Artist)<>artist) And (i>=0) Do
            dec(i);
          While (lowercase(Items[i].Artist)=artist) And (i>0) Do
            dec(i);
          inc(i);
          FSrchPos := i;
        End
      Else
        Begin
          While (i<Count) And (lowercase(Items[i].Artist)<>artist)  Do
            inc(i);
          If i<>Count Then FSrchPos := i
          Else FSrchPos := -1;
        End;

      Result := FSrchPos;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Function TMediaCollectionClass.getTracks(artist, album: String;
                                             StartFrom: integer): integer;

    Var i: integer;
    Begin
      album:=LowerCase(album);
      artist:=LowerCase(artist);
      FSrchArtist := artist;
      FSrchAlbum := album;
      i := getTracks(artist, StartFrom);
      FSrchType := FTrackSrch_ArtistAlbum;
      While lowercase(items[i].Album)<>album Do
        inc(i);

      FSrchPos := i;
      Result := i;

    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Function TMediaCollectionClass.getAlbums(artist: String): TStringList;
    Begin

    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Function TMediaCollectionClass.getAlbums(artist: String; StartFrom: integer
    ): TStringList;

    Var tmplist : TStringList;
      i: integer;
    Begin
      artist := lowercase(artist);
      If StartFrom<>0 Then
        Begin
          If (sorted=false) Then
            StartFrom := 0
          Else
            Begin
              i := AnsiCompareText(Items[StartFrom].Artist, artist);
              If (i=0) Or (i>0) Then FSrchAscending := true
              Else FSrchAscending := false;
            End;
        End;

      i := StartFrom;
      If (i<>0) And (FSrchAscending) Then
        Begin
          While (lowercase(Items[i].Artist)<>artist) And (i>=0) Do
            dec(i);
          While (lowercase(Items[i].Artist)=artist) And (i>0) Do
            dec(i);
          inc(i);
        End
      Else
        Begin
          While (i<count) And (lowercase(Items[i].Artist)<>artist) Do
            inc(i);
          If i=Count Then i := -1;
        End;
      tmplist := TStringList.Create;
      tmplist.Sorted := true;
      tmplist.CaseSensitive := false;
      tmplist.Duplicates := dupIgnore;
      If (i>=0) And (i<Count) Then
        Begin

          While (i<Count) And (lowercase(Items[i].Artist)=artist) Do
            Begin
              If Items[i].Album<>'' Then tmplist.AddObject(items[i].Album, Items[i])
              Else tmplist.AddObject('Unknown', Items[i]);
              inc(i);
            End;
          Result := tmplist;
        End;

    End;


    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Function TMediaCollectionClass.getArtists: integer;
    Begin
      FSrchPos := 0;
      FSrchArtist := lowercase(Items[0].Artist);
      result := FSrchPos;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Function TMediaCollectionClass.getNextArtist: integer;

    Var i: integer;
    Begin
      i := FSrchPos;
      Repeat
        inc(i)
      Until (i>=Count) Or (lowercase(items[i].Artist)<>FSrchArtist);
      If i<Count Then
        Begin
          FSrchArtist := lowercase(Items[i].Artist);
          FSrchPos := i;
          Result := i;
        End
      Else result := -1;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Function TMediaCollectionClass.GetNext: integer;

    Var i: integer;
    Begin
      Case FSrchType Of 
        FTrackSrch_Artist:
                           Begin
                             Repeat
                               inc(FSrchPos)
                             Until (FSrchPos>=ItemCount) Or (lowercase(Items[FSrchPos].Artist)=
                                   FSrchArtist);
                             If (FSrchPos<>ItemCount) And (lowercase(Items[FSrchPos].Artist)=
                                FSrchArtist)Then
                               result := FSrchPos
                             Else
                               result := -1;
                             exit;
                           End;
        FTrackSrch_ArtistAlbum:
                                Begin
                                  Repeat
                                    inc(FSrchPos)
                                  Until (FSrchPos>=ItemCount) Or ((lowercase(Items[FSrchPos].Album)=
                                        FSrchAlbum) And (lowercase(Items[FSrchPos].Artist)=
                                        FSrchArtist));
                                  If (FSrchPos<>ItemCount) And ((lowercase(Items[FSrchPos].Album)=
                                     FSrchAlbum) And (lowercase(Items[FSrchPos].Artist)=FSrchArtist)
                                     ) Then
                                    result := FSrchPos
                                  Else
                                    result := -1;
                                  exit;
                                End;
      End;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Function TMediaCollectionClass.GetIndexByPath(path: String): integer;

    Var i: integer;
    Begin
      i := ItemCount;
      Repeat
        dec(i)
      Until (i<0) Or (items[i].Path=path);
      result := i;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TMediaFileClass }
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    Procedure TMediaFileClass.read_tag_ogg;

    Var z: integer;
      tmps: String;
    Begin
      tmps := extractFileName(path);
      z := pos(' - ', tmps)+3;
      If z<>3 Then
        Begin
          title := copy(tmps,z,length(tmps)-z-3);
          artist := copy(tmps,1,z-3);
          album := '';
        End
      Else
        Begin
          artist := '';
          title := '';
          album := '';
        End;
      artist := TrimRight(artist);
      title := TrimRight(title);
      album := TrimRight(Album);
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaFileClass.read_tag_wave;

    Var li: cardinal;
      b: byte;
      z: integer;
      mp3filehandle: longint;
      tmps: string;
    Begin
      Try
        mp3filehandle := fileopen(path, fmOpenRead);
        fileseek(mp3filehandle,8,fsfrombeginning);
        b := 0;
        Repeat
          Begin
            inc(b);
            fileread(mp3filehandle,li,4);
          End;
        Until (li=$20746D66) Or (b=15);
        fileread(mp3filehandle,li,4);
        fileread(mp3filehandle,li,4);
        fileread(mp3filehandle,li,4);
        samplerate := li;
        fileread(mp3filehandle,li,4);
        bitrate := (li Div 1024)*8;
        playlength := size Div li;

        playtime := SecondsToFmtStr(Playlength);

        tmps := extractFileName(path);
        z := pos(' - ', tmps)+3;
        If z<>3 Then
          Begin
            title := copy(tmps,z,length(tmps)-z-3);
            artist := copy(tmps,1,z-3);
            album := '';
          End
        Else
          Begin
            artist := '';
            title := '';
            album := '';
          End;
        artist := TrimRight(artist);
        title := TrimRight(title);
        album := TrimRight(Album);
      Except
        writeln('**EXCEPTION reading wave file '+path+'**');
      End;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaFileClass.read_tag_mp3;

    Var b: byte;
      i, z, tagpos: integer;
      buf: array[1..1024] Of byte;
      artistv2, albumv2, titlev2, commentv2, yearv2, trackv2: string;
      bufstr: string;
      mp3filehandle: longint;
    Begin
      Try
        mp3filehandle := fileopen(path, fmOpenRead);

{calculating playtime}
        fileseek(mp3filehandle,0,fsfrombeginning);
        fileread(mp3filehandle,buf,high(buf));

        i := 0;
        z := 1;
        Repeat
          Begin
            // iterate buf to finde mpeg header start sequenz
            // start sequenz is 1111 1111 1111 10xx = $FF $Fx
            inc(i);
            If i=high(buf)-2 Then
              Begin
                // if reached end of buf, read next part of file to buf
                fileseek(mp3filehandle, (i*z)-8, fsFromBeginning);
                fileread(mp3filehandle,buf,high(buf));
                inc(z);
                i := 1;
              End;
          End;
        Until ((buf[i]=$FF) And ((buf[i+1] Or $3)=$FB)) Or (z>256);
        // until mpgeg header start seuqenz found


        If (buf[i]=$FF) And ((buf[i+1] Or $3)=$FB) Then
          Begin
            //if header found then do
            b := buf[i+2] shr 4;
            //shift the byte containing the bitrate right by 4 positions
            // bbbb xxxx -> 0000 bbbb
            // b : bitrate bits, x: any other bits
            If b > 15 Then b := 0;
            bitrate := bitrates[b];
            // select bitrate at index b from table bitrates

            b := buf[i+2] And $0F;
            // the same with samplerate byte
            b := b shr 2;
            If b > 3 Then b := 3;
            samplerate := samplerates[b];
            // select samplerate at index b from table samplerates
            If bitrate>0 Then
              Begin
                playlength := round(size / (bitrate*125));
                //calculate playlength from bitrate and samplerate
                playtime := SecondsToFmtStr(Playlength);
                // doesn't work with VBR files !
              End;
          End
        Else writeln(path+' -> no valid mpeg header found');
      try
{reading ID3-tags}
        fileseek(mp3filehandle,0,fsfrombeginning);
        fileread(mp3filehandle,buf,high(buf));
        bufstr := '';
        For i:= 1 To high(buf) Do
          If {(buf[i]<>0) and }(buf[i]<>10) Then bufstr := bufstr+char(buf[i])
          Else bufstr := bufstr+' ';
        // filter #10 and 0, replace by ' '
  {id3v2}
        albumv2 := '';
        artistv2 := '';
        titlev2 := '';
        trackv2 := '';
        yearv2 := '';
        If pos('ID3',bufstr)<> 0 Then
          Begin

            i := pos('TPE1',bufstr);
            If i<> 0 Then artistv2 := copy(bufstr,i+11,buf[i+7]-1);
            i := pos('TP1',bufstr);
            If i<> 0 Then artistv2 := copy(bufstr,i+7,buf[i+5]-1);

            i := pos('TIT2',bufstr);
            If i<> 0 Then titlev2 := copy(bufstr,i+11,buf[i+7]-1);

            i := pos('TT2',bufstr);
            If i<> 0 Then titlev2 := copy(bufstr,i+7,buf[i+5]-1);

            i := pos('TRCK',bufstr);
            If i<> 0 Then trackv2 := copy(bufstr,i+11,buf[i+7]-1);

            i := pos('TRK',bufstr);
            If i<> 0 Then trackv2 := copy(bufstr,i+7,buf[i+5]-1);

            If length(trackv2)>3 Then trackv2 := '';

            i := pos('TAL',bufstr);
            If i<> 0 Then albumv2 := copy(bufstr,i+7,buf[i+5]-1);

            i := pos('TALB',bufstr);
            If i<> 0 Then albumv2 := copy(bufstr,i+11,buf[i+7]-1);

            i := pos('TYE',bufstr);
            If i<> 0 Then yearv2 := copy(bufstr,i+7,buf[i+5]-1);

            i := pos('TYER',bufstr);
            If i<> 0 Then yearv2 := copy(bufstr,i+11,buf[i+7]-1);

{             artistv2:=rmZeroChar(artistv2);
             titlev2:=rmZeroChar(titlev2);
             albumv2:=rmZeroChar(albumv2);     }

            artistv2 := Latin1toUTF8(artistv2);
            titlev2 := Latin1toUTF8(titlev2);
            albumv2 := Latin1toUTF8(albumv2);
            yearv2 := Latin1toUTF8(yearv2);
            trackv2 := Latin1toUTF8(trackv2)
            ;
            //   rmZeroChar(yearv2);
            If length(yearv2)>5 Then yearv2 := '';
          End;
       except WriteLn(path+' -> exception while reading id3v2 tag... skipped!!'); end;
          {id3v1}
       try
        fileseek(mp3filehandle,-128, fsfromend);
        fileread(mp3filehandle,buf,128);
        bufstr := '';
        For i:= 1 To 128 Do
          bufstr := bufstr+char(buf[i]);
        For i:= 1 To 128 Do
          Begin
            b := byte(bufstr[i]);
            If (b=0) Then bufstr[i] := #32;
          End;
        tagpos := pos('TAG',bufstr)+3;
        If tagpos<>3 Then
          Begin
            title := Latin1toUTF8(copy(bufstr,tagpos,30));
            artist := Latin1toUTF8(copy(bufstr,tagpos+30,30));
            album := Latin1toUTF8(copy(bufstr,tagpos+60,30));
            year := copy(bufstr,tagpos+90,4);
            If buf[125]<>0 Then                             {check for id3v1.1}
              comment := Latin1toUTF8(copy(bufstr,tagpos+94,30))
            Else
              Begin
                comment := Latin1toUTF8(copy(bufstr,tagpos+94,28));
                If (buf[tagpos+123])<>0 Then track := IntToStr(buf[tagpos+123])
                Else track := '';
              End;
          End;
      except WriteLn(path+' -> exception while reading id3v2 tag... skipped!!');  end;
        If ((artistv2<>'')) And (CactusConfig.id3v2_prio Or (artist='')) Then artist := TrimRight(
                                                                                        artistv2);
        If ((titlev2<>'')) And (CactusConfig.id3v2_prio Or (title=''))  Then title := TrimRight(
                                                                                      titlev2);
        If ((albumv2<>'')) And (CactusConfig.id3v2_prio Or (album='')) Then album := TrimRight(
                                                                                     albumv2);
        If ((commentv2<>'')) And (CactusConfig.id3v2_prio Or (comment='')) Then comment := TrimRight
                                                                                           (
                                                                                           commentv2
                                                                                           );
        If ((yearv2<>'')) And (CactusConfig.id3v2_prio Or (year='')) Then year := TrimRight(yearv2);
        If ((trackv2<>'')) And (CactusConfig.id3v2_prio Or (track='')) Then track := TrimRight(
                                                                                     trackv2);

        artist := TrimRight(artist);
        title := TrimRight(title);
        album := TrimRight(Album);
        comment := TrimRight(Comment);
        year := TrimRight(Year);
        fileclose(mp3filehandle);
      Except
        writeln(path+' ->error reading tag... skipped!!');
      End;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaFileClass.SetArtist(aValue: String);

    Var i, start: integer;
    Begin
      i := index;
      start := index;
      FArtist := aValue;
      If Collection.sorted Then
        Begin
          If (i<Collection.Count-1) And (CompareText(FArtist, Collection.Items[i+1].Artist)>0) Then
            Begin
              inc(i);
              While (i<=Collection.Count-1) And (compareText(FArtist, Collection.Items[i].Artist)>0)
                Do
                Begin
                  inc(i);
                End;
              While (i<=Collection.Count-1) And (compareText(FTitle, Collection.Items[i].Title)>0)
                    And (CompareText(FArtist, Collection.Items[i].Artist)=0) Do
                Begin
                  inc(i);
                End;
              Collection.Move(index, i-1);
              If Collection.AutoEnum Then Collection.enumerate(start);
            End;
          If (i>0) And (CompareText(FArtist, Collection.Items[i-1].Artist)<0) Then
            Begin
              dec(i);
              While (i>=0) And (compareText(FArtist, Collection.Items[i].Artist)<0) Do
                Begin
                  dec(i);
                End;

              While ((i>=0) And (compareText(FTitle, Collection.Items[i].Title)<0))
                    And (CompareText(FArtist, Collection.Items[i].Artist)=0) Do
                Begin
                  dec(i);
                End;
              Collection.Move(index, i+1);
              If Collection.AutoEnum Then Collection.enumerate;
            End;
        End;

    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaFileClass.SetAlbum(aValue: String);
    Begin
      FAlbum := aValue;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaFileClass.SetTitle(aValue: String);

    Var i, start: integer;
    Begin
      FTitle := aValue;
      i := index;
      start := index;
      If Collection.sorted Then
        Begin
          writeln(i);
          If (i<Collection.Count-1) And (CompareText(FTitle, Collection.Items[i+1].Title)>0)
             And (CompareText(FArtist, Collection.Items[i+1].Artist)=0) Then
            Begin
              inc(i);
              While ((i<=Collection.Count-1) And (compareText(FTitle, Collection.Items[i].Title)>0))
                    And (CompareText(FArtist, Collection.Items[i].Artist)=0) Do
                Begin
                  inc(i);
                End;
              Collection.Move(index, i-1);
              If Collection.AutoEnum Then Collection.enumerate(start);
            End;

          If (i>0) And (CompareText(FTitle, Collection.Items[i-1].Title)<0)
             And (CompareText(FArtist, Collection.Items[i-1].Artist)=0) Then
            Begin
              dec(i);
              While ((i>=0) And (compareText(FTitle, Collection.Items[i].Title)<0))
                    And (compareText(FArtist, Collection.Items[i].Artist)=0) Do
                Begin
                  dec(i);
                End;
              Collection.Move(index, i+1);
              If Collection.AutoEnum Then Collection.enumerate;
            End;
        End;

    End;

    Procedure TMediaFileClass.setStreamUrl(aValue: String);
    Begin

    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    constructor TMediaFileClass.create(filepath: String; ParentCollection: TMediaCollectionClass);

    Var tmpfile: file Of byte;
    Begin
      Collection := ParentCollection;
      path := filepath;
      action := ANOTHING;
      If pos(URLID, filepath)=0 Then FMediaType := MTStream
      Else FMediaType := MTAudioFile;

      Filemode := 0;
      //   try
      system.assign(tmpfile, path);
      //Open file temporaly to get some information about it
      reset(tmpfile);
      size := filesize(tmpfile);
      //get filesize
      ID := crc32(path);
      // calc unique file ID
      filetype := lowercase(ExtractFileExt(filepath));
      close(tmpfile);
      //   except writeln('ERROR reading file '+filepath);end;
      Filemode := 2;

      read_tag;
      //finally read tag information
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    constructor TMediaFileClass.create(ParentCollection: TMediaCollectionClass);
    Begin

    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    destructor TMediaFileClass.destroy;
    Begin
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaFileClass.Write_Tag;

    Var 
      buf: array[1..1024] Of byte;
      bufstr, tmptag, tmps: string;
      //       artistv2, albumv2, titlev2, commentv2, yearv2, trackv2: string;
      i, z: integer;
      id3v1str: string[31];
      mp3filehandle: longint;
    Begin
{id3v2}
      mp3filehandle := fileopen(path,fmOpenRead);
      fileseek(mp3filehandle, 0, fsfrombeginning);
      fileread(mp3filehandle, buf, high(buf));
      fileclose(mp3filehandle);
      For i:= 1 To high(buf) Do
        bufstr := bufstr+char(buf[i]);

      If (pos('ID3',bufstr) <> 0) Or (length(artist)>30) Or (length(title)>30) Or (length(album)>30)
        Then
        Begin
          If pos('ID3',bufstr) = 0 Then
            Begin                                               {create new ID3v2 Tag skeleton}
              bufstr := '';
              bufstr := 'ID3'+char($03)+char(0)+char(0)+char(0)+char(0)+char(0)+char(0);
              {ID3 03 00 00 00 00 00 00}
              tmps := char(0)+char(0)+char(0)+char(2)+char(0)+char(0)+char(0)+' ';
              bufstr := bufstr+'TPE1'+tmps+'TIT2'+tmps+'TRCK'+tmps+'TYER'+tmps+'TALB'+tmps+char(0)+
                        char(0);
              writeln('creating new ID3v2 tag!');
              writeln(bufstr);
              z := length(bufstr)-1;
              For i:= z To high(buf) Do
                bufstr := bufstr+char(0);
            End;

          // Now lets write the tags
          i := pos('TPE1',bufstr);
          If i<> 0 Then
            Begin
              tmptag := UTF8toLatin1(artist);
              If length(tmptag)>0 Then
                Begin
                  Delete(bufstr, i+11, byte(bufstr[i+7])-1);
                  Insert(tmptag, bufstr, i+11);
                  bufstr[i+7] := char(length(tmptag)+1);
                End
              Else Delete(bufstr, i, byte(bufstr[i+7])+10);
            End
          Else
            Begin
              tmptag := UTF8toLatin1(artist);
              If length(tmptag)>0 Then
                Begin
                  tmps := char(0)+char(0)+char(0)+char(length(tmptag)+1)+char(0)+char(0)+char(0);
                  Insert('TPE1'+tmps+(tmptag), bufstr, pos('ID3',bufstr)+10);
                End;
            End;

          i := pos('TP1',bufstr);
          If i<> 0 Then
            Begin
              tmptag := UTF8toLatin1(artist);
              Delete(bufstr, i, byte(bufstr[i+5])+6);
              //delete whole TP1 tag
            End;

          i := pos('TIT2',bufstr);
          If i<> 0 Then
            Begin
              tmptag := UTF8toLatin1(title);
              If length(tmptag)>0 Then
                Begin
                  Delete(bufstr, i+11, byte(bufstr[i+7])-1);
                  Insert(tmptag, bufstr, i+11);
                  bufstr[i+7] := char(length(tmptag)+1);
                End
              Else Delete(bufstr, i, byte(bufstr[i+7])+10);
            End
          Else
            Begin
              tmptag := UTF8toLatin1(title);
              If length(tmptag)>0 Then
                Begin
                  tmps := char(0)+char(0)+char(0)+char(length(tmptag)+1)+char(0)+char(0)+char(0);
                  Insert('TIT2'+tmps+tmptag, bufstr, pos('ID3',bufstr)+10);
                End;
            End;

          i := pos('TRCK',bufstr);
          If i<> 0 Then
            Begin
              tmptag := UTF8toLatin1(track);
              If length(tmptag)>0 Then
                Begin
                  Delete(bufstr, i+11, byte(bufstr[i+7])-1);
                  Insert(tmptag, bufstr, i+11);
                  bufstr[i+7] := char(length(tmptag)+1);
                End
              Else Delete(bufstr, i, byte(bufstr[i+7])+10);
            End
          Else
            Begin
              tmptag := UTF8toLatin1(track);
              If length(tmptag)>0 Then
                Begin
                  tmps := char(0)+char(0)+char(0)+char(length(tmptag)+1)+char(0)+char(0)+char(0);
                  Insert('TRCK'+tmps+tmptag, bufstr, pos('ID3',bufstr)+10);
                End;
            End;

          i := pos('TYER',bufstr);
          If i<> 0 Then
            Begin
              tmptag := UTF8toLatin1(year);
              If length(tmptag)>0 Then
                Begin
                  Delete(bufstr, i+11, byte(bufstr[i+7])-1);
                  Insert(tmptag, bufstr, i+11);
                  bufstr[i+7] := char(length(tmptag)+1);
                End
              Else Delete(bufstr, i, byte(bufstr[i+7])+10);
            End
          Else
            Begin
              tmptag := UTF8toLatin1(year);
              If length(tmptag)>0 Then
                Begin
                  tmps := char(0)+char(0)+char(0)+char(length(tmptag)+1)+char(0)+char(0)+char(0);
                  Insert('TYER'+tmps+tmptag, bufstr, pos('ID3',bufstr)+10);
                End;
            End;

          i := pos('TALB',bufstr);
          If i<> 0 Then
            Begin
              tmptag := UTF8toLatin1(album);
              If length(tmptag)>0 Then
                Begin
                  Delete(bufstr, i+11, byte(bufstr[i+7])-1);
                  Insert(tmptag, bufstr, i+11);
                  bufstr[i+7] := char(length(tmptag)+1);
                End
              Else Delete(bufstr, i, byte(bufstr[i+7])+10);
            End
          Else
            Begin
              tmptag := UTF8toLatin1(album);
              If length(tmptag)>0 Then
                Begin
                  tmps := char(0)+char(0)+char(0)+char(length(tmptag)+1)+char(0)+char(0)+char(0);
                  Insert('TALB'+tmps+tmptag, bufstr, pos('ID3',bufstr)+10);
                End;
            End;

          z := length(bufstr)-1;
          For i:= 1 To high(buf) Do
            If (i<z) Then buf[i] := byte(bufstr[i])
            Else buf[i] := 0;
          mp3filehandle := fileopen(path,fmOpenWrite);
          If mp3filehandle<>-1 Then
            Begin
              fileseek(mp3filehandle,0,fsfrombeginning);
              filewrite(mp3filehandle,buf,high(buf));
              fileclose(mp3filehandle);
            End
          Else writeln('ERROR: cant write tag. file not found');
        End;
{id3v1}
      writeln('#####ID3V1#######');
      For i:=1 To 128 Do
        buf[i] := 0;
      buf[1] := 84;
      buf[2] := 65;
      buf[3] := 71; {TAG}

      FillChar(id3v1str, SizeOf(id3v1str), #0);
      id3v1str := UTF8toLatin1(title);
      For i:= 4 To 33 Do
        buf[i] := byte(id3v1str[i-3]);

      FillChar(id3v1str, SizeOf(id3v1str), #0);
      id3v1str := UTF8toLatin1(artist);
      For i:= 34 To 63 Do
        buf[i] := byte(id3v1str[i-33]);

      FillChar(id3v1str, SizeOf(id3v1str), #0);
      id3v1str := UTF8toLatin1(album);
      For i:= 64 To 93 Do
        buf[i] := byte(id3v1str[i-63]);

      FillChar(id3v1str, SizeOf(id3v1str), #0);
      id3v1str := UTF8toLatin1(year);
      For i:= 94 To 97 Do
        buf[i] := byte(id3v1str[i-93]);

      FillChar(id3v1str, SizeOf(id3v1str), #0);
      id3v1str := UTF8toLatin1(comment);
      For i:= 98 To 127 Do
        buf[i] := byte(id3v1str[i-97]);

      If length(track)>0 Then
        Begin
          buf[126] := 0;
          buf[127] := StrToInt(track);
        End;

      mp3filehandle := fileopen(path,fmOpenWrite);
      If mp3filehandle<>-1 Then
        Begin
          If FileGetAttr(Path)=faReadOnly Then writeln('file is read only');
          fileseek(mp3filehandle,-128,fsfromend);
          writeln(title);
          writeln(artist);
          filewrite(mp3filehandle,buf,128);
          fileclose(mp3filehandle);
        End
      Else writeln('ERROR: cant write tag. file not found');

    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaFileClass.Read_Tag;
    Begin
      If filetype='.wav' Then read_tag_wave;
      If filetype='.ogg' Then read_tag_ogg;
      If filetype='.mp3' Then read_tag_mp3;
    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    Procedure TMediaFileClass.assign(SourceObject: TMediaFileClass);
    Begin

    End;

    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Function TMediaFileClass.move2path(strFilePath: string): Boolean;
var
  i: integer;
  strSrc, strDest, strTmp: string;
begin
  // did the filename change at all?
  strSrc := Path;
  strDest := strFilePath;
  if strSrc = strDest then
  begin
    Result := true;
    exit;
  end;

  // has the folder changed?
  strSrc := ExtractFilePath(Path);
  strDest := ExtractFilePath(strFilePath);
  if strSrc <> strDest then
    if NOT DirectoryExists(strDest) then
      ForceDirectories(strDest);

  // does the target file alredy existe?
  strDest := strFilePath;
  if FileExists(strDest) then
  begin
    while strDest[Length(strDest)-1] <> '.' do
      strDest := Copy(strDest, 1, Length(strDest)-1);
    strDest := Copy(strDest, 1, Length(strDest)-2);
    i := 2;
    repeat
    begin
      strTmp := '(' + IntToStr(i) + ')' + Filetype;
      i += 1;
    end
    until NOT FileExists(strDest + strTmp)
  end;
  strDest += strTmp;

  // move the file
  strSrc := Path;
  RenameFile(strSrc, strDest);

  // remove old folder and folders above if empty
  strSrc := ExtractFilePath(Path);
  while DirectoryIsEmpty(strSrc) do
  begin
    RemoveDir(strSrc);
    i := LastDelimiter(PathDelim,ExcludeTrailingPathDelimiter(strSrc));
    Delete(strSrc, i, Length(strSrc)-i+1);
  end;

  result := true; // FIXME write error detection needed

  if result then
    Path := strDest;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Function TMediaFileClass.PathNameFromTag_dryrun(var strFormat: string): string;
var
  strArtist, strAlbum, strTitle, strTrack, strYear: string;
  strLeft, strRight, strMid: string;
  chrLetter: char;
  intPos, intPos2: integer;
  bNonEmpty: Boolean;
begin
  // format string could be '%a/%a - %b - %n - %t'

  // if existant, replace unwanted chars in tags
  strArtist := MakeValidFilename(Artist);
  strAlbum := MakeValidFilename(Album);
  strTitle := MakeValidFilename(Title);
  strTrack := MakeValidFilename(Track);
  strYear := MakeValidFilename(Year);


  result := strFormat;
//  result := '%a/%a - %b%? - ?%n - %t%? in ?%y';

  while (Pos('%?', result) >0) and (Pos('?%', result) >0) do
  begin
    intPos := Pos('%?', result);
    intPos2 := Pos('?%', result);
    if length(result) < intPos2+2 then break;
    if intPos2 < intPos then break;  // FIXME  could be more elegant

    strLeft := Copy(result, 1, intPos -1);
    strRight := Copy(result, intPos2 +3, Length(result) - intPos2 +3);
    strMid := Copy (result, intPos +2, Length(result) - intPos -1 -(Length(result) - intPos2) -1);
    chrLetter := result[intPos2 +2];

    bNonEmpty := false;
    case chrLetter of
      'a': if strArtist <> '' then bNonEmpty := true;
      'b': if strAlbum <> '' then bNonEmpty := true;
      't': if strTitle <> '' then bNonEmpty := true;
      'n': if strTrack <> '' then bNonEmpty := true;
      'y': if strYear <> '' then bNonEmpty := true;
    end;

    if bNonEmpty then
      result := strLeft + strMid + '%' + chrLetter + strRight
    else
      result := strLeft + strRight;
  end;

  result := StringReplace(result, '%a', strArtist, [rfReplaceAll, rfIgnoreCase]);
  result := StringReplace(result, '%b', strAlbum, [rfReplaceAll, rfIgnoreCase]);
  result := StringReplace(result, '%t', strTitle, [rfReplaceAll, rfIgnoreCase]);
  result := StringReplace(result, '%n', strTrack, [rfReplaceAll, rfIgnoreCase]);
  result := StringReplace(result, '%y', strYear, [rfReplaceAll, rfIgnoreCase]);
  result += FileType;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Function TMediaFileClass.FullPathNameFromTag_dryrun(var strFormat: string): string;
begin
  result := LibraryPath() + PathNameFromTag_dryrun(strFormat);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Function TMediaFileClass.PathNameFromTag(var strFormat: string): Boolean;
begin
  result := move2path(FullPathNameFromTag_dryrun(strFormat));
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Function TMediaFileClass.LibraryPath(): string;
var
  i: integer;
begin
  result := '';
  For i:= 0 To MediaCollection.dirlist.Count-1 Do
    if Pos(Collection.dirlist[i], Path) > 0 then
    begin
      result := IncludeTrailingPathDelimiter(Collection.dirlist[i]);
      break;
    end;
end;


  End.
