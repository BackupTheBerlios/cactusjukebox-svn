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
  {ExtCtrls,} Buttons, ComCtrls, lcltype, mp3file, ExtCtrls, skin, aws;

type

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
    Label20: TLabel;
    Label21: TLabel;
    idlabel: TLabel;
    indexlabel: TLabel;
    mtype: TLabel;
    bitrate: TLabel;
    fsize: TLabel;
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
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    metacontrol: TPageControl;
    pathedit1: TEdit;
    metatab: TTabSheet;
    id3v2tab: TTabSheet;
    titleedit1: TEdit;
    yearEdit2: TEdit;
    yearEdit3: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure EditID3Close(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormHide(Sender: TObject);
    procedure PicDownloadTimerStartTimer(Sender: TObject);
    procedure PicDownloadTimerTimer(Sender: TObject);
    procedure cancelbutClick(Sender: TObject);
    procedure cmbYearChange(Sender: TObject);
    procedure guessnameClick(Sender: TObject);
    procedure savebutClick(Sender: TObject);
    procedure yearEdit1Change(Sender: TObject);
  private
    { private declarations }
    timer_loop_count: integer;
    request_send: boolean;
    picrequest_send: boolean;
    awsclass: TAWSAccess;
  public
    { public declarations }
    fileid: integer;
    artist_only, album_only:boolean;
    Pcol: PMediaCollection;
    pfileobj:PMp3fileobj;
    procedure show_tags(pfobj:PMp3fileobj; col: PMediaCollection);
  end; 

var
  EditID3win: TEditID3;

implementation
uses mp3, lazjpeg, settings;
{ TEditID3 }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.savebutClick(Sender: TObject);
var curartist, newart, oldart, oldalbum, newalbum, strNewYear, strNewComment: string;
    i, z:integer;
begin
if (FileGetAttr(PFileObj^.path) and faReadOnly)=0 then begin
 if (artist_only=false) and (album_only=false) then begin
  PFileObj^.artist:=artistedit1.text;
   PFileObj^.title:=titleedit1.text;
   PFileObj^.album:=albumedit1.text;
   PFileObj^.year:=yearedit1.text;
   PFileObj^.comment:=commentedit1.text;
   pfileobj^.track:=trackedit1.text;

{   PFileObj^.artistv2:=artistedit1.text;
   PFileObj^.titlev2:=titleedit1.text;
   PFileObj^.albumv2:=albumedit1.text;
   PFileObj^.yearv2:=yearedit1.text;
   PFileObj^.commentv2:=commentedit1.text;
   pfileobj^.trackv2:=trackedit1.text; }

   PFileObj^.write_tag;
   
   RenameFile(PFileObj^.path, editid3win.pathedit1.text);
   PFileObj^.path:=editid3win.pathedit1.text;
  end;

 if artist_only=true then begin
   oldart:=lowercase(PFileObj^.artist);
   newart:=artistedit1.text;
   strNewYear := self.cmbYear.Caption;
   strNewComment := self.cmbComment.Caption;

   writeln('artist_mode');
   z:=pfileobj^.index;
   while (z<PCol^.max_index) and (oldart=lowercase(PCol^.lib[z].artist)) do begin
         PCol^.lib[z].artist:=newart;
         if Length(strNewYear) = 4 then
           PCol^.lib[z].year := strNewYear;
         PCol^.lib[z].comment:= strNewComment;
//         PCol^.lib[z].artistv2:=newart;
         writeln(newart);
         PCol^.lib[z].write_tag;
         writeln(z);
         inc(z);
      end;
    artist_only:=false;
   end;
 if album_only=true then begin
   curartist:=lowercase(PFileObj^.artist);
   oldalbum:=lowercase(PFileObj^.album);
   newalbum:=albumedit1.text;
   newart:=artistedit1.text;
   strNewYear := self.cmbYear.Caption;
   strNewComment := self.cmbComment.Caption;

   Z:=pfileobj^.index;
   while (z>0) and (lowercase(PCol^.lib[z].artist)=curartist) do dec(z);
   inc(z);
   while (z<PCol^.max_index) and (curartist=lowercase(PCol^.lib[z].artist)) do begin
      if oldalbum=lowercase(PCol^.lib[z].album) then begin
         PCol^.lib[z].album:=newalbum;
         PCol^.lib[z].artist:=newart;
         if Length(strNewYear) = 4 then
           PCol^.lib[z].year := strNewYear;
         PCol^.lib[z].comment:= strNewComment;
         PCol^.lib[z].write_tag;
       end;
       inc(z);
      end;
    album_only:=false;
  end;
  
   if main.player_connected then PlayerCol.save_lib(CactusConfig.DAPPath+'cactuslib');

   update_artist_view;
   update_title_view;
   main.update_playlist;
   
  end else  ShowMessage('Error: File is Read-Only');

  EditID3win.Hide;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.yearEdit1Change(Sender: TObject);
begin
  // ensure only YYYY (years of four digits) are entered (if anything is entered)
  if self.yearEdit1.Visible = true
  then
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
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.FormHide(Sender: TObject);
begin
  Main.enabled:=true;

  // reset form components
  self.artist_only:=false;
  self.album_only:=false;
  
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
             writeln(pfileobj^.CoverPath);
             AlbumCoverImg.Canvas.Clear;
             AlbumCoverImg.Picture.LoadFromFile(pfileobj^.CoverPath);
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

procedure TEditID3.show_tags(pfobj:PMp3fileobj; col: PMediaCollection);
var s, tmps:string;
  strYears: Array of String[4];
  strComments: Array of String;
  bExists: Boolean;
  i, j: Integer;
begin
  self.Pcol:=col;
  self.pfileobj:=pfobj;
  self.fileid:=0;

  // set up gui elements
  metacontrol.ActivePage:=metatab;
  id3v1tab.TabVisible:=false;
  id3v2tab.TabVisible:=false;

  self.artistedit1.Text := PFobj^.artist;

  // artist and album(-mode) specific actions
  if (artist_only = true) or (album_only = true)
  then
  begin
    self.guessname1.Enabled := false;
    self.Button1.Enabled := false;
    self.pathedit1.Enabled := false;
    self.titleedit1.Enabled := false;

    self.indexlabel.Caption := 'File-Index: ' + IntToStr(PFobj^.index);

    // collect all "years" set for files of the chosen artist/album
    // and display them
    SetLength(strYears, 0);
    for i := 1 to col^.max_index -1 do
      if col^.lib[i].artist = pfobj^.artist
      then
      begin
        if album_only = true then
          if col^.lib[i].album <> pfobj^.album then continue;
        // ensure "year" is added only once
        bExists := false;
        for j := 0 to Length(strYears) -1 do
          if strYears[j] = col^.lib[i].year
          then
          begin
            bExists := true;
            break;
          end;
        if bExists = true then continue;
        // add "year"
        SetLength(strYears, Length(strYears) +1);
        strYears[Length(strYears) -1] := col^.lib[i].year;
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
    for i := 1 to col^.max_index -1 do
      if col^.lib[i].artist = pfobj^.artist
      then
      begin
        if album_only = true then
          if col^.lib[i].album <> pfobj^.album then continue;
        // ensure "comment" is added only once
        bExists := false;
        for j := 0 to Length(strComments) -1 do
          if strComments[j] = col^.lib[i].comment
          then
          begin
            bExists := true;
            break;
          end;
        if bExists = true then continue;
        // add "comment"
        SetLength(strComments, Length(strComments) +1);
        strComments[Length(strComments) -1] := col^.lib[i].comment;
      end;
    // and display...
    self.commentedit1.Visible := false;
    self.cmbComment.Visible := true;
    self.cmbComment.Clear;
    for i := 0 to Length(strComments) -1 do
      self.cmbComment.Items.Add(strComments[i]);

    // artist(-mode) specific actions
    if artist_only = true
    then
    begin
      self.albumedit1.Enabled := false;
      // there will probably be more than one album published at different times
      // so ensure that not one "year" is set for all of them
      self.cmbYear.Caption := '';
      self.cmbComment.Caption := '';
    end;

    // album(-mode) specific actions
    if album_only = true
    then
    begin
      self.albumedit1.text := PFobj^.album;
      // select first entry from combobox as default for the album
      if self.cmbYear.Items.Count > 0 then self.cmbYear.ItemIndex := 0;
      if self.cmbComment.Items.Count > 0 then self.cmbComment.ItemIndex := 0;

      writeln('########AlbumCover');     // DEBUG-INFO
      AlbumCoverImg.Canvas.Clear;
      AlbumCoverImg.Picture.Clear;
      Application.ProcessMessages;
      if pfileobj^.album<>''
      then
      begin
        pfileobj^.CoverPath:=main.ConfigPrefix+DirectorySeparator+'covercache'+DirectorySeparator+pfileobj^.artist+'_'+pfileobj^.album+'.jpeg';
        if FileExists(pfileobj^.CoverPath) then AlbumCoverImg.Picture.LoadFromFile(pfileobj^.CoverPath)
        else
        begin
          if CactusConfig.CoverDownload
          then
          begin
            awsclass:=TAWSAccess.CreateRequest(pfileobj^.artist, pfileobj^.album);
            awsclass.AlbumCoverToFile(pfileobj^.CoverPath);
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

    editid3win.pathedit1.text:=pfobj^.path;
    editid3win.titleedit1.text:=PFobj^.title;
    editid3win.albumedit1.text:=PFobj^.album;
    editid3win.commentedit1.text:=PFobj^.comment;
    editid3win.yearedit1.text:=PFobj^.year;
    editid3win.trackedit1.text:=PFobj^.track;

    mtype.caption:='Mediatype:  '+PFobj^.filetype;
    if PFobj^.filetype='.mp3' then
      Filelogo.Picture.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'mp3_64.png');
    if PFobj^.filetype='.ogg' then
      Filelogo.Picture.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'ogg_64.png');
    if PFobj^.filetype='.wav' then
      Filelogo.Picture.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'wav_64.png');
    plength.caption:='Length:  '+PFobj^.playtime;

    i:=(PFobj^.size div 1024)*100;
    s:=' kB';
    if i>100000
    then
    begin
      s:=' MB';
      i:=(i div 1000);
    end;

    tmps := IntToStr(i);
    s:=copy(tmps, length(tmps)-1, 2)+s;
    delete(tmps, length(tmps)-1, 2);
    tmps:=tmps+','+s;

    fsize.caption:='Size:  '+tmps;
    srate.Caption := 'Samplerate:  ' + IntToStr(PFobj^.samplerate) + ' Hz';
    bitrate.Caption := 'Bitrate:  ' + IntToStr(PFobj^.bitrate) + ' kbps';
    idlabel.Caption := 'File-Id: ' + IntToStr(PFobj^.id);
    indexlabel.Caption := 'File-Index: ' + IntToStr(PFobj^.index);

    writeln('########AlbumCover');     // DEBUG-INFO
    AlbumCoverImg.Canvas.Clear;
    AlbumCoverImg.Picture.Clear;
    Application.ProcessMessages;
    if pfileobj^.album<>''
    then
    begin
      pfileobj^.CoverPath:=main.ConfigPrefix+DirectorySeparator+'covercache'+DirectorySeparator+pfileobj^.artist+'_'+pfileobj^.album+'.jpeg';
      if FileExists(pfileobj^.CoverPath)
      then
        AlbumCoverImg.Picture.LoadFromFile(pfileobj^.CoverPath)
      else
      begin
        if CactusConfig.CoverDownload
        then
        begin
          awsclass:=TAWSAccess.CreateRequest(pfileobj^.artist, pfileobj^.album);
          awsclass.AlbumCoverToFile(pfileobj^.CoverPath);
          picrequest_send:=true;
          AlbumCoverImg.Canvas.TextOut(10,10, 'Loading...');
          PicDownloadTimer.Enabled:=true;
          Application.ProcessMessages;
        end;
      end;
    end;
  end;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.Button1Click(Sender: TObject);
var s:string;
begin
  s:=extractfilepath(pfileobj^.path)+editid3win.artistedit1.text+' - '+editid3win.titleedit1.text+'.mp3';
  EditID3win.pathedit1.text:=s;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.cancelbutClick(Sender: TObject);
begin
  EditID3win.Hide;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.cmbYearChange(Sender: TObject);
begin
  // ensure only YYYY (years of four digits) are entered (if anything is entered)
  if self.cmbYear.Visible = true
  then
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
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.guessnameClick(Sender: TObject);
var z:integer;
    tmps: string;
begin
  tmps:=extractfilename(pfileobj^.path);
  if ((tmps[1]<#60) and (tmps[2]<#60) and (tmps[4]=#45)) then begin
                    trackedit2.text:=copy(tmps,1,2);
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

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

initialization
  {$I editid3.lrs}

end.

