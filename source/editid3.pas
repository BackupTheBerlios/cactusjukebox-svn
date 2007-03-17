{

Edit/show file info dialog for Cactus Jukebox

written by Sebastian Kraft, <c> 2006

Contact the author at: sebastian_kraft@gmx.de

This Software is published under the GPL






}



unit editid3; 

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
    Button2: TButton;
    cancelbut1: TButton;
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
    procedure EditID3Destroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PicDownloadTimerStartTimer(Sender: TObject);
    procedure PicDownloadTimerTimer(Sender: TObject);
    procedure cancelbutClick(Sender: TObject);
    procedure guessnameClick(Sender: TObject);
    procedure savebutClick(Sender: TObject);
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
uses mp3, lazjpeg;
{ TEditID3 }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.savebutClick(Sender: TObject);
var curartist, newart, oldart, oldalbum, newalbum: string;
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

   writeln('artist_mode');
   z:=pfileobj^.index;
   while (z<PCol^.max_index) and (oldart=lowercase(PCol^.lib[z].artist)) do begin
         PCol^.lib[z].artist:=newart;
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
   Z:=pfileobj^.index;
   while (z>0) and (lowercase(PCol^.lib[z].artist)=curartist) do dec(z);
   inc(z);
   while (z<PCol^.max_index) and (curartist=lowercase(PCol^.lib[z].artist)) do begin
      if oldalbum=lowercase(PCol^.lib[z].album) then begin
         PCol^.lib[z].album:=newalbum;
         PCol^.lib[z].artist:=newart;
//         PCol^.lib[z].albumv2:=newalbum;
//         PCol^.lib[z].artistv2:=newart;
         PCol^.lib[z].write_tag;
       end;
       inc(z);
      end;
    album_only:=false;
  end;
  
   if main.player_connected then PlayerCol.save_lib(main.playerpath+'/cactuslib');

   update_artist_view;
   update_title_view;
   main.update_playlist;
   
  end else  ShowMessage('Error: File is Read-Only');
Main.enabled:=true;
close;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.EditID3Destroy(Sender: TObject);
begin
   Main.enabled:=true;
end;

procedure TEditID3.FormCreate(Sender: TObject);
begin
end;

procedure TEditID3.PicDownloadTimerStartTimer(Sender: TObject);
begin
  timer_loop_count:=0;
end;

procedure TEditID3.PicDownloadTimerTimer(Sender: TObject);

begin
  inc(timer_loop_count);
  if (timer_loop_count mod 8)=0 then AlbumCoverImg.Canvas.Clear else AlbumCoverImg.Canvas.TextOut(10,10, 'Loading...');
  if timer_loop_count>20 then begin
     writeln('TIMEOUT while loading album cover mage from Internet');
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
      Main.enabled:=true;
      Filelogo.free;
      AlbumCoverImg.free;
      PicDownloadTimer.Enabled:=false;
      PicDownloadTimer.Free;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.show_tags(pfobj:PMp3fileobj; col: PMediaCollection);
var s, tmps:string;
begin
   Pcol:=col;
   pfileobj:=pfobj;
   fileid:=0;

   if ((artist_only=false) and (album_only=false)) then begin
     guessname1.Enabled:=true;
     Button1.Enabled:=true;
     editid3win.pathedit1.text:=pfobj^.path;
     editid3win.artistedit1.text:=PFobj^.artist;
     editid3win.titleedit1.text:=PFobj^.title;
     editid3win.albumedit1.text:=PFobj^.album;
     editid3win.commentedit1.text:=PFobj^.comment;
     editid3win.yearedit1.text:=PFobj^.year;
     editid3win.trackedit1.text:=PFobj^.track;
     mtype.caption:='Mediatype:  '+PFobj^.filetype;
     if PFobj^.filetype='.mp3' then Filelogo.Picture.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'mp3_64.png');
     if PFobj^.filetype='.ogg' then Filelogo.Picture.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'ogg_64.png');
     if PFobj^.filetype='.wav' then Filelogo.Picture.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'wav_64.png');
     plength.caption:='Length:  '+PFobj^.playtime;
     i:=(PFobj^.size div 1024)*100;
     s:=' kB';
     if i>100000 then begin
                s:=' MB';
                i:=(i div 1000);
              end;

     str(i, tmps);
     s:=copy(tmps, length(tmps)-1, 2)+s;
     delete(tmps, length(tmps)-1, 2);
     tmps:=tmps+','+s;
     fsize.caption:='Size:  '+tmps;
     str(PFobj^.samplerate, tmps);
     srate.Caption:='Samplerate:  '+tmps+' Hz';
     str(PFobj^.bitrate, tmps);
     bitrate.Caption:='Bitrate:  '+tmps+' kbps';
     str(PFobj^.id, tmps);
     idlabel.Caption:='File-Id: '+tmps;
     str(PFobj^.index, tmps);
     indexlabel.Caption:='File-Index: '+tmps;
     writeln('########AlbumCover');
     AlbumCoverImg.Canvas.Clear;
     AlbumCoverImg.Picture.Clear;
     if pfileobj^.album<>'' then begin
     pfileobj^.CoverPath:=main.ConfigPrefix+DirectorySeparator+'covercache'+DirectorySeparator+pfileobj^.artist+'_'+pfileobj^.album+'.jpeg';
     if FileExists(pfileobj^.CoverPath) then AlbumCoverImg.Picture.LoadFromFile(pfileobj^.CoverPath)
        else begin
             awsclass:=TAWSAccess.CreateRequest(pfileobj^.artist, pfileobj^.album);
             awsclass.AlbumCoverToFile(pfileobj^.CoverPath);
             picrequest_send:=true;
             AlbumCoverImg.Canvas.TextOut(10,10, 'Loading...');
             writeln('yyyyyyyyyyy');
             PicDownloadTimer.Enabled:=true;
//             picrequest_send:=false;
           end;
      end;
    end;
   if artist_only=true then begin
      guessname1.Enabled:=false;
      Button1.Enabled:=false;
      
      editid3win.pathedit1.enabled:=false;
      editid3win.artistedit1.text:=PFobj^.artist;
      editid3win.titleedit1.enabled:=false;
      editid3win.albumedit1.enabled:=false;
      str(PFobj^.index, tmps);
      indexlabel.Caption:='File-Index: '+tmps;
    end;
  if album_only=true then begin
      guessname1.Enabled:=false;
      Button1.Enabled:=false;
      editid3win.pathedit1.enabled:=false;
      editid3win.artistedit1.text:=PFobj^.artist;
      editid3win.titleedit1.enabled:=false;
      editid3win.albumedit1.text:=PFobj^.album;
      str(PFobj^.index, tmps);
      indexlabel.Caption:='File-Index: '+tmps;
     writeln('########AlbumCover');
     AlbumCoverImg.Canvas.Clear;
     AlbumCoverImg.Picture.Clear;
     if pfileobj^.album<>'' then begin
     pfileobj^.CoverPath:=main.ConfigPrefix+DirectorySeparator+'covercache'+DirectorySeparator+pfileobj^.artist+'_'+pfileobj^.album+'.jpeg';
     if FileExists(pfileobj^.CoverPath) then AlbumCoverImg.Picture.LoadFromFile(pfileobj^.CoverPath)
        else begin
             awsclass:=TAWSAccess.CreateRequest(pfileobj^.artist, pfileobj^.album);
             awsclass.SendRequest;
             request_send:=true;
             AlbumCoverImg.Canvas.TextOut(10,10, 'Loading...');
             writeln('yyyyyyyyyyy');
             PicDownloadTimer.Enabled:=true;
             picrequest_send:=false;
           end;
      end;
    end;
   metacontrol.ActivePage:=metatab;
   id3v1tab.TabVisible:=false;
   id3v2tab.TabVisible:=false;
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
     close;
     Main.enabled:=true;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TEditID3.guessnameClick(Sender: TObject);
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

