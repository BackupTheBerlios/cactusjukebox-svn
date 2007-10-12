unit editid3;

{

Edit/show file info dialog for Cactus Jukebox

written by Sebastian Kraft, <c> 2006
Contact the author at: sebastian_kraft@gmx.de
This Software is published under the GPL

}





{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  {ExtCtrls,} Buttons, ComCtrls, lcltype, mediacol, ExtCtrls, skin, aws;


  const ALBUM_MODE = 1;
  const ARTIST_MODE = 2;

type
  PLabel = ^TLabel;
  PEdit = ^TEdit;

  { TEditID3 }

  TEditID3 = class(TForm)
    albumedit1: TEdit;
    albumedit2: TEdit;
    albumedit3: TEdit;
    artistedit1: TEdit;
    artistedit2: TEdit;
    artistedit3: TEdit;
    Button1: TButton;
    cancelbut1: TButton;
    cmbYear: TComboBox;
    cmbComment: TComboBox;
    Edit1: TEdit;
    commentedit1: TEdit;
    Edit3: TEdit;
    guessname1: TButton;
    Filelogo: TImage;
    AlbumCoverImg: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    lblTrack: TLabel;
    Label21: TLabel;
    idlabel: TLabel;
    indexlabel: TLabel;
    mtype: TLabel;
    bitrate: TLabel;
    fsize: TLabel;
    btnReset: TButton;
    srate: TLabel;
    plength: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    savebut1: TButton;
    id3v1tab: TTabSheet;
    fileinfo: TTabSheet;
    PicDownloadTimer: TTimer;
    titleedit2: TEdit;
    titleedit3: TEdit;
    trackedit1: TEdit;
    trackedit2: TEdit;
    yearEdit1: TEdit;
    Edit2: TEdit;
    lblArtist: TLabel;
    lblTitle: TLabel;
    lblAlbum: TLabel;
    lblYear: TLabel;
    lblGenre: TLabel;
    lblComment: TLabel;
    lblPath: TLabel;
    metacontrol: TPageControl;
    pathedit1: TEdit;
    metatab: TTabSheet;
    id3v2tab: TTabSheet;
    titleedit1: TEdit;
    yearEdit2: TEdit;
    yearEdit3: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure EditID3Close(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure PicDownloadTimerStartTimer(Sender: TObject);
    procedure PicDownloadTimerTimer(Sender: TObject);
    procedure cancelbutClick(Sender: TObject);
    procedure guessnameClick(Sender: TObject);
    procedure pathedit1Change(Sender: TObject);
    procedure savebutClick(Sender: TObject);
    procedure yearEdit1Change(Sender: TObject);
    procedure cmbYearChange(Sender: TObject);
    procedure activateEMode(Sender: TObject);
  private
    { private declarations }
    artist_only, album_only: Boolean;
    timer_loop_count: integer;
    request_send: boolean;
    picrequest_send: boolean;
    awsclass: TAWSAccess;
    bEModeActive: boolean;                        // Edit-mode specific variable
    ptrControls: array of array of ^TControl;     // ..
    procedure show_tags();
    MedFileObj:TMediaFileClass;
    MedColObj: TMediaCollectionClass;
  public
    { public declarations }
    fileid: integer;
    procedure display_window(MedFile:TMediaFileClass; intMode: Integer = 0);
  end; 

var
  EditID3win: TEditID3;

implementation
uses mainform, lazjpeg, settings, functions;
{ TEditID3 }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.savebutClick(Sender: TObject);
var curartist, newart, oldart, oldalbum, newalbum, strNewYear, strNewComment: string;
    z,n:integer;
    bYearLongEnough: Boolean;
    ptr: ^TLabel;
    ptrLabels: Array of ^TLabel;
    strChangedTo: Array of String;
begin
  // only save if s.th. has been changed
  if bEModeActive = false
  then
  begin
    EditID3win.Hide;
    exit;
  end;

  // check if the file exists and is writable
  if (FileGetAttr(MedFileObj.path)<>faReadOnly)
  then
  begin
    // write changes (artist-mode)
    if artist_only=true
    then
    begin
      oldart:=lowercase(MedFileObj.artist);
      newart:=artistedit1.text;
      strNewComment := self.cmbComment.Caption;

      strNewYear := self.cmbYear.Caption;
      if Length(strNewYear) = 4 then
        bYearLongEnough := true;

      z:=MedColObj.getTracks(oldart, MedFileObj.index);
      repeat begin
          writeln('artist_mode: '+ artistedit1.Text +' #'+ IntToStr(z));    // DEBUG-INFO
          MedColObj.items[z].artist:=newart;
          if bYearLongEnough then MedColObj.items[z].year := self.cmbYear.Caption;
          MedColObj.items[z].comment:= strNewComment;
          MedColObj.items[z].write_tag;
          z:=MedColObj.getNext;
      end;
      until z<0;

    end
    // write changes (album-mode)
    else if album_only=true
    then
    begin
      curartist:=lowercase(MedFileObj.artist);
      oldalbum:=lowercase(MedFileObj.album);
      newalbum:=albumedit1.text;
      newart:=artistedit1.text;
      strNewComment := self.cmbComment.Caption;

      strNewYear := self.cmbYear.Caption;
      if Length(strNewYear) = 4 then
        bYearLongEnough := true;

      z:=MedColObj.getTracks(curartist, oldalbum, MedFileObj.index);
       
      repeat begin
            MedColObj.items[z].album:=newalbum;
            MedColObj.items[z].artist:=newart;
            if bYearLongEnough then MedColObj.items[z].year := self.cmbYear.Caption;
            MedColObj.items[z].comment:= strNewComment;
            MedColObj.items[z].write_tag;
            z:=MedColObj.getNext;
      end;
      until z<0;

    end
    // write changes (title-mode)
    else
    begin
      MedFileObj.artist:=artistedit1.text;
      MedFileObj.title:=titleedit1.text;
      MedFileObj.album:=albumedit1.text;
      MedFileObj.year:=yearedit1.text;
      MedFileObj.comment:=commentedit1.text;
      MedFileObj.track:=trackedit1.text;

      MedFileObj.write_tag;

      RenameFile(MedFileObj.path, editid3win.pathedit1.text);
      MedFileObj.path:=editid3win.pathedit1.text;
    end;


    if main.player_connected then PlayerCol.SaveToFile(CactusConfig.DAPPath+'cactuslib');

    update_artist_view;
    update_title_view;
    main.update_playlist;
  end
  else
    ShowMessage('Error: File(s) is/are read-only');

  EditID3win.Hide;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.cancelbutClick(Sender: TObject);
begin
  EditID3win.Hide;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.yearEdit1Change(Sender: TObject);
begin
  // ensure only YYYY (years of four digits) are entered (if anything is entered)
  if self.yearEdit1.Visible = true
  then
  begin
    case Length(self.yearEdit1.Caption) of
      0: self.savebut1.Enabled:= true;
      4:
      try
        self.savebut1.Enabled:= true;
        StrToInt(self.yearEdit1.Caption);
      except
        self.savebut1.Enabled:= false;
      end;
      otherwise self.savebut1.Enabled := false;
    end;
    activateEMode(Sender);
  end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.cmbYearChange(Sender: TObject);
begin
  // ensure only YYYY (years of four digits) are entered (if anything is entered)
  if self.cmbYear.Visible = true
  then
  begin
    case Length(self.cmbYear.Caption) of
      0: self.savebut1.Enabled:= true;
      4:
      try
        self.savebut1.Enabled:= true;
        StrToInt(self.cmbYear.Caption);
      except
        self.savebut1.Enabled:= false;
      end;
      otherwise self.savebut1.Enabled := false;
    end;
    activateEMode(Sender);
  end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.activateEMode(Sender: TObject);
var
  i, j: Integer;
  ptrLabel: ^TLabel;
  ptrEdit: ^TEdit;
begin
  // disable all labels
  if self.bEModeActive = false
  then
  begin
    for i := 0 to Length(ptrControls) -1 do
    begin
      ptrLabel := PLabel(ptrControls[i,0]);
      ptrLabel^.Enabled := false;
    end;
    self.bEModeActive := true;
    self.btnReset.Enabled := true;
  end;

  // enable label if sender (a text-box) belongs to it
  for i := 0 to Length(ptrControls) -1 do
  begin
    ptrLabel := PLabel(ptrControls[i,0]);
    for j := 1 to Length(ptrControls[i]) -1 do
    begin
      ptrEdit := PEdit(ptrControls[i,j]);
      if ptrEdit^ = Sender then ptrLabel^.Enabled := true;
    end
  end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.FormHide(Sender: TObject);
begin
  Main.enabled:=true;

  // reset form components
  self.guessname1.Enabled := true;
  self.Button1.Enabled := true;
  
  self.pathedit1.Caption := '';
  self.pathedit1.Enabled := true;
  self.artistedit1.Caption := '';
  self.artistedit1.Enabled := true;
  self.titleedit1.Caption := '';
  self.titleedit1.Enabled := true;
  self.albumedit1.Caption := '';
  self.albumedit1.Enabled := true;
  self.trackedit1.Caption := '';
  self.trackedit1.Enabled := true;
  self.yearEdit1.Caption := '';
  self.yearEdit1.Enabled := true;
  self.Edit2.Caption := '';
  self.Edit2.Enabled := true;
  self.commentedit1.Caption := '';
  self.commentedit1.Enabled := true;

  self.AlbumCoverImg.Canvas.Clear;
  self.AlbumCoverImg.Picture.Clear;
  self.PicDownloadTimer.Enabled := false;
  
  self.cmbYear.Visible := false;
  self.yearEdit1.Visible := true;
  self.cmbComment.Visible:= false;
  self.commentedit1.Visible:= true;
  
  self.ShowInTaskBar:=stNever;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.PicDownloadTimerStartTimer(Sender: TObject);
begin
  timer_loop_count:=0;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.PicDownloadTimerTimer(Sender: TObject);

begin
  inc(timer_loop_count);
  if (timer_loop_count mod 8)=0 then AlbumCoverImg.Canvas.Clear else AlbumCoverImg.Canvas.TextOut(10,10, 'Loading...');
  if timer_loop_count>20 then begin
     writeln('TIMEOUT while loading album cover image from Internet');
     PicDownloadTimer.Enabled:=false;
     AlbumCoverImg.Canvas.Clear;
     AlbumCoverImg.Canvas.TextOut(10,10, 'No cover found :(')
    end;
    
   if (picrequest_send) and awsclass.data_ready then begin
             writeln(MedFileObj.CoverPath);
             AlbumCoverImg.Canvas.Clear;
             AlbumCoverImg.Picture.LoadFromFile(MedFileObj.CoverPath);
             awsclass.free;
             picrequest_send:=false;
             PicDownloadTimer.Enabled:=false;
         end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.EditID3Close(Sender: TObject; var CloseAction: TCloseAction);
begin
  //    Filelogo.free;
  //    AlbumCoverImg.free;
   //   PicDownloadTimer.Enabled:=false;
  //    PicDownloadTimer.Free;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.FormCreate(Sender: TObject);
var
  i: integer;
begin
  // initialize index of labels and text boxes on form - used for edit-mode
  SetLength(ptrControls, 8);
  for i := 0 to Length(ptrControls) -1 do
    SetLength(ptrControls[i], 2);

  ptrControls[0,0] := @self.lblPath;
  ptrControls[0,1] := @self.pathedit1;
  
  ptrControls[1,0] := @self.lblArtist;
  ptrControls[1,1] := @self.artistedit1;
  
  ptrControls[2,0] := @self.lblTitle;
  ptrControls[2,1] := @self.titleedit1;
  
  ptrControls[3,0] := @self.lblAlbum;
  ptrControls[3,1] := @self.albumedit1;
  
  ptrControls[4,0] := @self.lblTrack;
  ptrControls[4,1] := @self.trackedit1;
  
  ptrControls[5,0] := @self.lblGenre;
  ptrControls[5,1] := @self.Edit2;
  
  SetLength(ptrControls[6], 3);
  ptrControls[6,0] := @self.lblComment;
  ptrControls[6,1] := @self.commentedit1;
  ptrControls[6,2] := @self.cmbComment;
  
  SetLength(ptrControls[7], 3);
  ptrControls[7,0] := @self.lblYear;
  ptrControls[7,1] := @self.yearEdit1;
  ptrControls[7,2] := @self.cmbYear;

  // (FIXME) ressourcestring translations need to be added here

  Icon.LoadFromFile(CactusConfig.DataPrefix+'icon'+DirectorySeparator+'cactus-icon.ico');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.show_tags();
var
  strYears: Array of String[4];
  strComments: Array of String;
  bExists: Boolean;
  i, j: Integer;
  ptrLabel: ^TLabel;
begin
  // reset all labels indicating edit-mode and changes
  for i := 0 to Length(ptrControls) -1 do
  begin
    ptrLabel := PLabel(ptrControls[i,0]);
    ptrLabel^.Enabled := true;
  end;

  // display tags...
  self.artistedit1.Text := self.MedFileObj.artist;

  // artist and album(-mode) specific actions
  if (artist_only = true) or (album_only = true)
  then
  begin
    // collect all "years" set for files of the chosen artist/album
    // and display them
    SetLength(strYears, 0);
    for i := 0 to self.MedColObj.ItemCount -1 do
      if self.MedColObj.items[i].artist = self.MedFileObj.artist
      then
      begin
        if album_only = true then
          if self.MedColObj.items[i].album <> self.MedFileObj.album then continue;
        // ensure "year" is added only once
        bExists := false;
        for j := 0 to Length(strYears) -1 do
          if strYears[j] = self.MedColObj.items[i].year
          then
          begin
            bExists := true;
            break;
          end;
        if bExists = true then continue;
        // add "year"
        SetLength(strYears, Length(strYears) +1);
        strYears[Length(strYears) -1] := self.MedColObj.items[i].year;
      end;
    // and display...
    self.yearEdit1.Visible := false;
    self.cmbYear.Visible := true;
    self.cmbYear.Clear;
    for i := 0 to Length(strYears) -1 do
      self.cmbYear.Items.Add(strYears[i]);

    // collect all "comments" set for files of the chosen artist/album
    // and display them
    SetLength(strComments, 0);
    for i := 1 to self.MedColObj.ItemCount-1 do
      if self.MedColObj.items[i].artist = self.MedFileObj.artist
      then
      begin
        if album_only = true then
          if self.MedColObj.items[i].album <> self.MedFileObj.album then continue;
        // ensure "comment" is added only once
        bExists := false;
        for j := 0 to Length(strComments) -1 do
          if strComments[j] = self.MedColObj.items[i].comment
          then
          begin
            bExists := true;
            break;
          end;
        if bExists = true then continue;
        // add "comment"
        SetLength(strComments, Length(strComments) +1);
        strComments[Length(strComments) -1] := self.MedColObj.items[i].comment;
      end;
    // and display...
    self.commentedit1.Visible := false;
    self.cmbComment.Visible := true;
    self.cmbComment.Clear;
    for i := 0 to Length(strComments) -1 do
      self.cmbComment.Items.Add(strComments[i]);

    // album(-mode) specific actions
    if album_only = true
    then
    begin
      self.albumedit1.text := self.MedFileObj.album;
      // select first entry from combobox as default for the album
      if self.cmbYear.Items.Count > 0 then self.cmbYear.ItemIndex := 0;
      if self.cmbComment.Items.Count > 0 then self.cmbComment.ItemIndex := 0;
    end;
  end
  // title(-mode) specific actions
  else
  begin
    self.pathedit1.text:=self.MedFileObj.path;
    self.titleedit1.text:=self.MedFileObj.title;
    self.albumedit1.text:=self.MedFileObj.album;
    self.commentedit1.text:=self.MedFileObj.comment;
    self.yearedit1.text:=self.MedFileObj.year;
    self.trackedit1.text:=self.MedFileObj.track;
  end;
  
  self.btnReset.Enabled := false;
  self.bEModeActive := false;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.display_window(MedFile:TMediaFileClass; intMode: Integer = 0);
var s, tmps:string;
  i: Integer;
begin
  self.MedFileObj:=MedFile;
  self.MedColObj:=MedFileObj.Collection;
  self.fileid:=0;

  self.artist_only := false;
  self.album_only := false;
  case intMode of
    ALBUM_MODE: self.album_only := true;
    ARTIST_MODE: self.artist_only := true;
  end;

  // set up gui elements
  metacontrol.ActivePage:=metatab;
  id3v1tab.TabVisible:=false;
  id3v2tab.TabVisible:=false;

  //show in taskbar so you don't loose the windows. showmodal doesn't work here
  self.ShowInTaskBar:=stAlways;

  // artist and album(-mode) specific actions
  if (artist_only = true) or (album_only = true)
  then
  begin
    self.guessname1.Enabled := false;
    self.Button1.Enabled := false;
    self.pathedit1.Enabled := false;
    self.titleedit1.Enabled := false;

    self.indexlabel.Caption := 'File-Index: ' + IntToStr(MedFileObj.index);

    // artist(-mode) specific actions
    if artist_only = true
    then
      self.albumedit1.Enabled := false;

    // album(-mode) specific actions
    if album_only = true
    then
    begin
      writeln('########AlbumCover');     // DEBUG-INFO
      AlbumCoverImg.Canvas.Clear;
      AlbumCoverImg.Picture.Clear;
      Application.ProcessMessages;
      if MedFileObj.album<>''
      then
      begin
        MedFileObj.CoverPath:=CactusConfig.ConfigPrefix+DirectorySeparator+'covercache'+DirectorySeparator+MedFileObj.artist+'_'+MedFileObj.album+'.jpeg';
        if FileExists(MedFileObj.CoverPath) then AlbumCoverImg.Picture.LoadFromFile(MedFileObj.CoverPath)
        else
        begin
          if CactusConfig.CoverDownload
          then
          begin
            awsclass:=TAWSAccess.CreateRequest(MedFileObj.artist, MedFileObj.album);
            awsclass.AlbumCoverToFile(MedFileObj.CoverPath);
            picrequest_send:=true;
            AlbumCoverImg.Canvas.TextOut(10,10, 'Loading...');
            Application.ProcessMessages;
            PicDownloadTimer.Enabled:=true;
          end;
        end;
      end;
    end;
  end
  // title(-mode) specific actions
  else
  begin
    self.guessname1.Enabled:=true;
    self.Button1.Enabled:=true;

    mtype.caption:='Mediatype:  '+MedFileObj.filetype;
    if MedFileObj.filetype='.mp3' then
      Filelogo.Picture.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'mp3_64.png');
    if MedFileObj.filetype='.ogg' then
      Filelogo.Picture.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'ogg_64.png');
    if MedFileObj.filetype='.wav' then
      Filelogo.Picture.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'wav_64.png');
    plength.caption:='Length:  '+MedFileObj.playtime;



    fsize.caption:='Size:  '+ByteToFmtString(MedFileObj.size, 2, 2);
    srate.Caption := 'Samplerate:  ' + IntToStr(MedFileObj.samplerate) + ' Hz';
    bitrate.Caption := 'Bitrate:  ' + IntToStr(MedFileObj.bitrate) + ' kbps';
    idlabel.Caption := 'File-Id: ' + IntToStr(MedFileObj.id);
    indexlabel.Caption := 'File-Index: ' + IntToStr(MedFileObj.index);

    writeln('########AlbumCover');     // DEBUG-INFO
    AlbumCoverImg.Canvas.Clear;
    AlbumCoverImg.Picture.Clear;
    Application.ProcessMessages;
    if MedFileObj.album<>''
    then
    begin
      MedFileObj.CoverPath:=CactusConfig.ConfigPrefix+DirectorySeparator+'covercache'+DirectorySeparator+MedFileObj.artist+'_'+MedFileObj.album+'.jpeg';
      if FileExists(MedFileObj.CoverPath)
      then
        AlbumCoverImg.Picture.LoadFromFile(MedFileObj.CoverPath)
      else
      begin
        if CactusConfig.CoverDownload
        then
        begin
          awsclass:=TAWSAccess.CreateRequest(MedFileObj.artist, MedFileObj.album);
          awsclass.AlbumCoverToFile(MedFileObj.CoverPath);
          picrequest_send:=true;
          AlbumCoverImg.Canvas.TextOut(10,10, 'Loading...');
          PicDownloadTimer.Enabled:=true;
          Application.ProcessMessages;
        end;
      end;
    end;
  end;
  
  show_tags();
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.Button1Click(Sender: TObject);
var s:string;
begin
  s:=extractfilepath(MedFileObj.path)+editid3win.artistedit1.text+' - '+editid3win.titleedit1.text+'.mp3';
  EditID3win.pathedit1.text:=s;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.btnResetClick(Sender: TObject);
begin
  show_tags();
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.guessnameClick(Sender: TObject);
var z:integer;
    tmps: string;
begin
  tmps:=extractfilename(pathedit1.Text);
  if ((tmps[1]<#60) and (tmps[2]<#60) and (tmps[4]=#45)) then begin
                    trackedit1.text:=copy(tmps,1,2);
                    delete(tmps, 1, 5);
              end;
  
   z:=pos(' - ', tmps)+3;
   if z<>3 then begin
        titleedit1.text:=TrimRight(copy(tmps,z,length(tmps)-z-3));
        artistedit1.text:=TrimRight(copy(tmps,1,z-3));
      end else begin
        artistedit1.text:='';
        titleedit1.text:='';
      end;
    
end;

procedure TEditID3.pathedit1Change(Sender: TObject);
begin

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

initialization
  {$I editid3.lrs}

end.

