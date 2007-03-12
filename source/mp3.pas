{
Main unit for Cactus Jukebox

written by Sebastian Kraft, <c> 2006

Contact the author at: sebastian_kraft@gmx.de

This Software is published under the GPL






}


unit mp3;

{$mode objfpc}{$H+}

interface


uses

  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  ExtCtrls, ComCtrls, StdCtrls, Menus, xmlcfg, fmod, fmodtypes, fmodplayer,
  ActnList, mp3file, dos, SimpleIPC, functions, EditBtn;
  
resourcestring
  rsQuit = 'Quit';
  rsFile = 'File';
  rsOpenFile = 'Open File...';
  rsPlayerOnly = 'Player only';
  rsChooseSkin = 'Choose Skin...';
  rsSettings = 'Settings...';
  rsLibrary = 'Library';
  rsNewLibrary = 'New library';
  rsLoadLibrary = 'Load library';
  rsSaveLibrary = 'Save library';
  rsLibraryInfo = 'Library info';
  rsManageLibrar = 'Manage library...';
  rsRescanDirect = 'Rescan directories';
  rsPlaylist = 'Playlist';
  rsPlay = 'Play';
  rsNext = 'Next';
  rsPrevious = 'Previous';
  rsMute = 'Mute';
  rsLoadPlaylist = 'Load playlist';
  rsSavePlaylist = 'Save playlist';
  rsMobilePlayer = 'Mobile player';
  rsDeviceInfo = 'Device info';
  rsScanPlayer = 'Scan player';
  rsSync = 'Sync';
  rsClearPlayer = 'Clear player';
  rsUndoSelectio = 'Undo selection';
  rsAudioCD = 'Audio CD';
  rsRipEncode = 'Rip / Encode...';
  rsHelp = 'Help';
  rsAbout = 'About...';
  rsManual = 'Manual...';
  rsClear = 'Clear';
  rsSearch = 'Search';
  rsAlbum = 'Album';
  rsFilename = 'Filename';
  rsArtist = 'Artist';
  rsTitle = 'Title';
  rsRandom = 'Random';
  rsNotConnected = 'Device not Connected';
  rsOK = 'OK';
  
type

  { TMain }

  TMain = class(TForm)
    ArtistTree: TTreeView;
    Button1: TButton;
    clear_list: TBitBtn;
    current_title_edit: TEdit;
    current_title_edit1: TEdit;
    artistsearch: TEdit;
    filetypebox: TComboBox;
    MenuItem6: TMenuItem;
    PlayButtonImg: TImage;
    PauseButtonImg: TImage;
    PreviousButtonImg: TImage;
    StopButtonImg: TImage;
    NextButtonImg: TImage;
    Label2: TLabel;
    MenuItem2: TMenuItem;
    Panel4: TPanel;
    ArtistSrchField: TPanel;
    SimpleIPCServer1: TSimpleIPCServer;
    SpeedButton1: TSpeedButton;
    TitleTree: TListView;
    MenuItem11: TMenuItem;
    spacer15: TMenuItem;
    mute: TSpeedButton;
    Panel1: TPanel;
    SearchPanel: TPanel;
    PlayerControlsPanel: TPanel;
    playlist: TListView;
    playtime: TEdit;
    randomcheck: TCheckBox;
    searchstr: TEdit;
    SettingsItem: TMenuItem;
    Menuitem26: TMenuItem;
    MIload_list: TMenuItem;
    MenuItem3: TMenuItem;
    Splitter1: TSplitter;
    srch_album: TCheckBox;
    srch_artist: TCheckBox;
    srch_button: TButton;
    srch_file: TCheckBox;
    srch_title: TCheckBox;
    StatusBar1: TStatusBar;
    toplaylistitem: TMenuItem;
    MIaudiocd: TMenuItem;
    MIrip: TMenuItem;
    MImute: TMenuItem;
    skinmenu: TMenuItem;
    ImageList1: TImageList;
    MIManagLib: TMenuItem;
    MenuItem12: TMenuItem;
    MImobile: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MImobile_info: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem30: TMenuItem;
    MIclear_mobile: TMenuItem;
    MIplay: TMenuItem;
    MInext: TMenuItem;
    MIprevious: TMenuItem;
    spacer41: TMenuItem;
    MenuItem42: TMenuItem;
    MImanual: TMenuItem;
    MIundosync: TMenuItem;
    rm_artist_playeritem: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MIscan_mobile: TMenuItem;
    MenuItem31: TMenuItem;
    MIsync: TMenuItem;
    openfile: TMenuItem;
    player_lib: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem33: TMenuItem;
    MIrescanlib: TMenuItem;
    space3: TMenuItem;
    MIlibinfo: TMenuItem;
    SaveDialog1: TSaveDialog;
    checkmobile: TTimer;
    space11: TMenuItem;
    MIabout: TMenuItem;
    Menuitem27a: TMenuItem;
    MIsave_list: TMenuItem;
    spacer29: TMenuItem;
    space1: TMenuItem;
    menuclear_list: TMenuItem;
    FileItem: TMenuItem;
    OpenDialog1: TOpenDialog;
    artisttreemenu: TPopupMenu;
    QuitItem: TMenuItem;
    TEditID3item: TMenuItem;
    Mainmenu1: TMAINMENU;
    Menuitem1: TMENUITEM;
    MInewlib: TMENUITEM;
    MIsavelib: TMENUITEM;
    MIloadlib: TMENUITEM;
    Menuitem21: TMENUITEM;
    removselectItem: TMENUITEM;
    RemoveItem: TMENUITEM;
    Menuitem24: TMENUITEM;
    Menuitem4: TMENUITEM;
    Menuitem5: TMENUITEM;
    MIlibrary: TMENUITEM;
    MIhelp: TMENUITEM;
    Menuitem8: TMENUITEM;
    MIPlaylist: TMENUITEM;
    playlistmenu: TPOPUPMENU;
    titlelistmenu: TPOPUPMENU;
    Selectdirectorydialog1: TSELECTDIRECTORYDIALOG;
    playtimer: TTimer;
    seldirdialog: TSelectDirectoryDialog;
    trackbar: TTrackBar;
    TrackInfo: TBitBtn;
    volumebar: TTrackBar;
    procedure ArtistTreeClick(Sender: TObject);
    procedure ArtistTreeDblClick(Sender: TObject);
    procedure ArtistTreeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure ArtistTreeSelectionChanged(Sender: TObject);
    procedure FormMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure NextButtonImgClick(Sender: TObject);
    procedure NextButtonImgMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NextButtonImgMouseEnter(Sender: TObject);
    procedure NextButtonImgMouseLeave(Sender: TObject);
    procedure NextButtonImgMouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SearchPanelClick(Sender: TObject);
    procedure PlayerControlsPanelClick(Sender: TObject);
    procedure PauseButtonImgClick(Sender: TObject);
    procedure PauseButtonImgMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PauseButtonImgMouseEnter(Sender: TObject);
    procedure PauseButtonImgMouseLeave(Sender: TObject);
    procedure PauseButtonImgMouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlayButtonImgClick(Sender: TObject);
    procedure PlayButtonImgMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlayButtonImgMouseEnter(Sender: TObject);
    procedure PlayButtonImgMouseLeave(Sender: TObject);
    procedure PlayButtonImgMouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure MainCreate(Sender: TObject);
    procedure MainKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem27Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem37Click(Sender: TObject);
    procedure MenuItem43Click(Sender: TObject);
    procedure MenuItem46Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure ArtistSrchFieldClick(Sender: TObject);
    procedure PreviousButtonImgClick(Sender: TObject);
    procedure PreviousButtonImgMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PreviousButtonImgMouseEnter(Sender: TObject);
    procedure PreviousButtonImgMouseLeave(Sender: TObject);
    procedure PreviousButtonImgMouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SimpleIPCServer1Message(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);

    procedure Splitter1Moved(Sender: TObject);
    procedure StopButtonImgClick(Sender: TObject);
    procedure StopButtonImgMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StopButtonImgMouseEnter(Sender: TObject);
    procedure StopButtonImgMouseLeave(Sender: TObject);
    procedure StopButtonImgMouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TitleTreeClick(Sender: TObject);
    procedure TitleTreeColumnClick(Sender: TObject; Column: TListColumn);
    procedure TitleTreeCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure TitleTreeCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure TitleTreeCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure TitleTreeMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TitleTreeMouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrackInfoClick(Sender: TObject);
    procedure artisttreemenuPopup(Sender: TObject);
    procedure checkmobileTimer(Sender: TObject);
    procedure clearPlayerItemClick(Sender: TObject);
    procedure clear_listClick(Sender: TObject);
    procedure filetypeboxChange(Sender: TObject);
    procedure libinfoClick(Sender: TObject);
    procedure muteClick(Sender: TObject);
    procedure openfileClick(Sender: TObject);
    procedure pauseClick(Sender: TObject);
    procedure player_libClick(Sender: TObject);
    procedure playlistClick(Sender: TObject);
    procedure playlistDblClick(Sender: TObject);
    procedure playlistDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure playlistDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure playlistEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure playlistKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure playlistKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure playlistMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure playlistStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure prevClick(Sender: TObject);
    procedure EditID3itemClick(Sender: TObject);
    procedure MenuItem30Click(Sender: TObject);
    procedure MenuItem33Click(Sender: TObject);
    procedure rm_artist_playeritemClick(Sender: TObject);
    procedure searchstrClick(Sender: TObject);
    procedure skinmenuClick(Sender: TObject);
    procedure syncplayeritem(Sender: TObject);
    procedure MenuItem36Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure Menuitem22Click(Sender: TObject);
    procedure Menuitem10Click(Sender: TObject);
    procedure RemoveClick(Sender: TObject);
    procedure QuitItemClick(Sender: TObject);
    procedure TitleTreeDblClick(Sender: TObject);
    procedure addFileItemClick(Sender: TObject);
    procedure loadlibClick(Sender: TObject);
    procedure newlibClick(Sender: TObject);
    procedure nextClick(Sender: TObject);
    procedure playClick(Sender: TObject);
    procedure playtimerTimer(Sender: TObject);
    procedure removeselectClick(Sender: TObject);
    procedure rescanlibClick(Sender: TObject);
    procedure save_listClick(Sender: TObject);
    procedure savelibClick(Sender: TObject);
    procedure scanplayeritemClick(Sender: TObject);
    procedure searchstrKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure srch_buttonClick(Sender: TObject);
    procedure stopClick(Sender: TObject);
    procedure startplay;
    procedure titlelistmenuPopup(Sender: TObject);
    procedure toggle_playpause(Sender: TObject);
    procedure trackbarMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure trackbarMouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure undoSyncItemClick(Sender: TObject);
    procedure volumebarChange(Sender: TObject);
    
    procedure fileopen(path:string);
    procedure loadskin(Sender: TObject);
    procedure update_player_hdd_relations;
  private
    { private declarations }
    Procedure MoveNode(TargetNode, SourceNode : TTreeNode);
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
    changetree, ctrl_pressed, SplitterResize:boolean;
    tsnode:TTreeNode;
    oldSplitterWidth: integer;
    sourceitem: TListItem;
    LastRightClick: TPoint;
  public
    playing, player_connected, mobile_subfolders, background_scan, playermode: boolean;
    playpos: integer;
    playnode: TTreeNode;
    playitem:TListitem;
    selected: array of longint;
    mpg123, lame:string;
    playerpath, curlib:string;
    cfgfile:TXMLConfig;
    player: TFModPlayerclass;
    tempbitmap, timetmpbmp:TBitmap;
    player_freespace, player_totalspace:longint;
    id3v2_prio, oss:boolean;
    skinmenuitems:array[1..16] of TMenuItem;
    HomeDir: string;
    current_skin, DataPrefix, ConfigPrefix, LibraryPrefix: string;

    { public declarations }
  end; 
  
  
 Type

   { TScanThread }

   TScanThread = class(TThread)
   private
     procedure ShowStatus;
   protected
     procedure Execute; override;
   public
     Constructor Create(Suspd : boolean);
     fStatus : byte;
     tmpcollection: TMediacollection;
     PCollection: PMediaCollection;
   end;

 { TScanThread }


var
  Main: TMain;
    const AUPLOAD = 3;
    const ANOTHING = -1;
    const AREMOVE = 2;
    const AONPLAYER = 1;
  
//procedure update_title_view_album;
procedure update_artist_view;
procedure update_title_view;
procedure update_playlist;
procedure artist_to_playlist;
procedure title_to_playlist;

//procedure album_to_playlist;



implementation
uses editid3, status, settings, player, directories, skin, cdrip, translations;

{$i cactus_const.inc}

var    // ext: boolean;
      //  err:integer;
        sizediff: int64;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

{       TScanThread : Thread to scan for new media files in background }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TScanThread.ShowStatus;
begin
    if fStatus=1 then Main.StatusBar1.Panels[0].Text:='Scanning folders in background...'+tmpcollection.rootpath;
    if fStatus=0 then begin
       if MessageDlg('Some files on your harddisk seem to have changed.'+#10+#13+'Adopt changes in Cactus library?', mtWarning, mbOKCancel, 0)= mrOK then begin
             fstatus:=255;
             PCollection^:=tmpcollection;

             //Main.clear_listClick(nil);
             writeln('WARNING: if excption occurs, playlist has to be cleared here!');
             Main.update_player_hdd_relations;
             update_artist_view;

             update_title_view;

             Main.StatusBar1.Panels[0].Text:=('Succesfully updated library...'+PCollection^.rootpath);
             //tmpcollection.free;
             // tmpcollection has to be made free... this keeps all tmpcollection instanxces in memory
             //

          end;

    end;
    if (fstatus=0) or (fstatus=128) then begin
        Main.StatusBar1.Panels[0].Text:='Ready';
        writeln('fstatus 0, 126');
        Main.StatusBar1.Panels[1].Alignment:=taRightJustify;
     end;
    writeln('showStatus');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TScanThread.Execute;
begin
   fStatus:=1;
   Synchronize(@ShowStatus);

   fstatus:=tmpcollection.ScanForNew;
  // Synchronize(@ShowStatus);
   tmpcollection.sort;
   Synchronize(@ShowStatus);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TScanThread.Create(Suspd: boolean);
 begin
  inherited Create(suspd);
  FreeOnTerminate := True;
  tmpcollection:=TMediacollection.create;
  fStatus:=255;
end;

{   // End TScanThread                   }



//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

{ TMain }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


procedure TMain.loadskin(Sender: TObject);
begin
     writeln('loading skin');
     with (sender as TMenuitem) do begin
          SkinData.load_skin(caption);
          current_skin:=caption;
       end;
     writeln('xxxxx');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.update_player_hdd_relations;
begin
              for i:= 1 to PlayerCol.max_index-1 do begin
                z:=1;

                PlayerCol.lib[i].action:=AONPLAYER;
                while z < MediaCollection.max_index-1 do begin
                        if MediaCollection.lib[z].id=PlayerCol.lib[i].id then begin
                             MediaCollection.lib[z].action:=1;
                             z:= MediaCollection.max_index-1;
                          end;
                        inc(z);
                    end;

              end;
Playercol.save_lib(playerpath+'/cactuslib');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.loadlibClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'Mp3lib Library|*.mlb';
  OpenDialog1.InitialDir:=HomeDir;
  OpenDialog1.FilterIndex := 1;
  if Opendialog1.execute=true then MediaCollection.load_lib(Main.Opendialog1.Filename);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.newlibClick(Sender: TObject);
begin
     Selectdirectorydialog1.initialdir:=HomeDir;
     Selectdirectorydialog1.title:='Add Directory...';
     if Selectdirectorydialog1.execute=true then begin
              MediaCollection.clear;
//              Statuswin:=TStatus.create(nil);
              Application.ProcessMessages;
              Enabled:=false;
              MediaCollection.add_directory(Selectdirectorydialog1.Filename);
              MediaCollection.rootpath:=Selectdirectorydialog1.Filename;
              MediaCollection.dirlist:=Selectdirectorydialog1.Filename+';';
//              Statuswin.destroy;
              Enabled:=false;
              Writeln('finished scan of '+MediaCollection.rootpath);
              if MediaCollection.max_index>1 then begin
                ArtistTree.Selected:=nil;
                update_artist_view;
                update_title_view;
              end;
           end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.nextClick(Sender: TObject);
var oldindex, err: integer;
begin
  playtimer.Enabled:=false;
  oldindex:=player.get_playlist_index;
  err:=-1;
  if randomcheck.Checked=false then err:=player.next_track else err:=player.play_random_item;
  if err=0 then begin
     i:=player.get_playlist_index;
     if i > 0 then begin
        if oldindex>0 then playlist.Items[oldindex-1].ImageIndex:=-1;
        playlist.Items[i-1].ImageIndex:=0;

        if player.playlist[i].artist<>'' then current_title_edit.text:=player.playlist[i].artist else current_title_edit.text:=ExtractFileName(player.playlist[i].path);
        current_title_edit1.text:=player.playlist[i].title;
        playwin.TitleImg.Picture.LoadFromFile(SkinData.Title.Img);
        playwin.titleimg.canvas.Font.Color:=Clnavy;
        if player.playlist[i].artist<>'' then playwin.titleimg.canvas.textout(5,5,player.playlist[i].artist) else playwin.titleimg.canvas.textout(5,5,ExtractFileName(player.playlist[i].path));
        playwin.titleimg.canvas.textout(5,25,player.playlist[i].title);
        playtimer.Enabled:=true;
     end;
    end
     else stopClick(nil);

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.playClick(Sender: TObject);
var err: byte;
begin
    playtimer.Enabled:=false;
    if (not player.paused) then  begin
         if (Playlist.items.count>0) and (Playlist.Selected=nil)then playitem:=Playlist.Items[0]
           else playitem:=playlist.selected;
         i:=0;
         err:=255;
         if playitem<>nil then begin
            if player.get_playlist_index>0 then playlist.Items[player.get_playlist_index-1].ImageIndex:=-1;
            i:=playitem.Index+1;
            err:=player.startplay(i);
          end else exit;
         if (err=0) and (i>0) then begin
                  if player.playlist[i].artist<>'' then current_title_edit.text:=player.playlist[i].artist else current_title_edit.text:=ExtractFileName(player.playlist[i].path);
                  current_title_edit1.text:=player.playlist[i].title;
                  playwin.TitleImg.Picture.LoadFromFile(SkinData.Title.Img);
                  playwin.TitleImg.canvas.Font.Color:=Clnavy;
                  if player.playlist[i].artist<>'' then playwin.TitleImg.canvas.textout(5,5,player.playlist[i].artist) else playwin.TitleImg.canvas.textout(5,5,ExtractFileName(player.playlist[i].path));
                  playwin.TitleImg.canvas.textout(5,25,player.playlist[i].title);
                  playtimer.enabled:=true;
                  playitem.ImageIndex:=0;
                end
             else begin
                  if (err=1) then Showmessage('File not Found! Goto Library/Rescan Directories for updating file links');
                  if (err=2) then Showmessage('Init of sound device failed.'+#10+#13+'Perhaps sound ressource is blocked by another application...');
                end;
       end
      else begin
           if (player.paused) then pauseClick(nil);
        end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.playtimerTimer(Sender: TObject);
var spos, slength: real;
    r: real;
    var x2:integer;
begin
   spos:=0;
   slength:=0;
   try
   if player.playing then begin
     playtime.text:=player.get_time_string;
     playwin.TimeImg.Picture.LoadFromFile(SkinData.Time.Img);
     playwin.TimeImg.Canvas.Font.Color:=ClNavy;
     playwin.TimeImg.Canvas.TextOut(5,3, playtime.text);
     spos:=player.get_file_position;
     slength:=player.get_file_length;
     r := ((spos*100) / slength);
     trackbar.position:= round(r);
     x2:=(trackbar.position*2)-3;
     if x2<3 then x2:=3;
     if spos=slength then nextclick(nil);
    end;
   except
     writeln('CAUGHT EXCEPTION IN PLAYTIMER!!!!');
   end;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.removeselectClick(Sender: TObject);
var curartist, curalbum: string;
    album_mode:boolean;
    pfobj: PMp3fileobj;
    PCol: PMediaCollection;
begin
tsnode:=Main.ArtistTree.Selected;
if (tsnode<>nil) and (tsnode.Level>0) then begin
if MessageDlg('The selected file(s) will permanently be'+#10+#13+'removed from harddisk!'+#10+#13+' Proceed?', mtWarning, mbOKCancel, 0)=mrOK then
 begin
     if tsnode.level<2 then album_mode:=false else album_mode:=true;
     PFobj:=tsnode.data;
     PCol:=pfobj^.collection;
     z:=0;
     repeat inc(z) until (PCol^.lib[z].path=pfobj^.path);
     curartist:=lowercase(PCol^.lib[z].artist);
     curalbum:=lowercase(PCol^.lib[z].album);
     repeat dec(z) until (z=0) or (lowercase(PCol^.lib[z].artist)<>curartist);
     inc(z);
     repeat begin
       if ((album_mode=false) and (lowercase(PCol^.lib[z].album)=curalbum)) or ((album_mode=true) and (lowercase(PCol^.lib[z].album)=curalbum)) then begin
          if DeleteFile(PCol^.lib[z].path) then writeln('deleted file from disk: '+PCol^.lib[z].path)
               else writeln('ERROR deleting file: '+PCol^.lib[z].path);
          PCol^.remove_entry(z);
          dec(z);
        end;
       inc(z);
       end;
     until (z>PCol^.max_index-1) or (curartist<>lowercase(PCol^.lib[z].artist));
   update_artist_view;
   update_title_view;
   PCol^.save_lib(PCol^.savepath);
  end;
end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.rescanlibClick(Sender: TObject);
var ScanThread: TscanThread;
begin

 if MessageDlg('Cactus will now look for new files...'+LineEnding+'If new files or changes to files are not detected'+LineEnding+'try Library/Manage Libray and click Rescan. ', mtWarning, mbOKCancel, 0)=mrOK then
   begin
    stopClick(nil);
    clear_listClick(nil);
    ScanThread:=TScanThread.Create(true);
    ScanThread.tmpcollection:=MediaCollection;
    ScanThread.PCollection:=@MediaCollection;
    writeln('scanning for new files...');
    ScanThread.Resume;
   end;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.save_listClick(Sender: TObject);
begin
  saveDialog1.Filter := 'M3U Playlist|*.m3u';
  saveDialog1.DefaultExt := 'm3u';
  saveDialog1.FilterIndex := 1;
  SaveDialog1.InitialDir:=HomeDir;
  if Savedialog1.execute=true then player.save_playlist(Savedialog1.Filename);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.savelibClick(Sender: TObject);
begin
  saveDialog1.Filter := 'Mp3lib Library|*.mlb';
  saveDialog1.DefaultExt := 'mlb';
  saveDialog1.FilterIndex := 1;
  SaveDialog1.InitialDir:=HomeDir;
   if Savedialog1.execute=true then MediaCollection.save_lib(Savedialog1.Filename);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.scanplayeritemClick(Sender: TObject);
var s:string;
begin
  if FileExists(playerpath)=false then begin ShowMessage(rsNotConnected);exit;end;
  checkmobile.Enabled:=false;
  If FileExists(playerpath) then begin
     Statuswin:=TStatus.create(nil);
     Application.ProcessMessages;

     PlayerCol.clear;
     playercol.rootpath:=playerpath;
     PlayerCol.PathFmt:=FRelative;
     PlayerCol.add_directory(playerpath);
     PlayerCol.dirlist:=playerpath+';';
     Statuswin.destroy;
     clear_listClick(nil);
     ArtistTree.Selected:=nil;
     writeln('player scanned');
     z:=1;
     for i:= 1 to PlayerCol.max_index-1 do begin
                z:=1;
                PlayerCol.lib[i].action:=AONPLAYER;
                while z < MediaCollection.max_index-1 do begin
                        if MediaCollection.lib[z].id=PlayerCol.lib[i].id then begin
                             MediaCollection.lib[z].action:=1;
                             z:= MediaCollection.max_index-1;
                          end;
                        inc(z);
                    end;

              end;
     update_artist_view;
     update_title_view;

     tmps:=GetCurrentDir;                             // get free memory on player, format string
     SetCurrentDir(playerpath);
     str(round((DiskFree(0) / 1024)/100), s);
     SetCurrentDir(tmps);
     tmps:=s;
     s:=copy(tmps, length(tmps), 1);
     delete(tmps, length(tmps), 1);
     tmps:=tmps+','+s;

    StatusBar1.Panels[1].Text:='Device connected     '+tmps+' MB Free';
     
     
//     if filesearch('.cactuslib',playerpath)='' then  mkdir('lib');

     PlayerCol.save_lib(playerpath+'/cactuslib');
     player_connected:=true;

   end
    else writeln(playerpath+' does not exist');
   checkmobile.Enabled:=true;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.searchstrKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    srch_buttonClick(nil);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.srch_buttonClick(Sender: TObject);
var searchstring, ft:string;
    found:boolean;
    Listitem:TListitem;
    PCol: PMediaCollection;
begin
     TitleTree.Items.Clear;
     TitleTree.BeginUpdate;
     changetree:=true;
     artisttree.selected:=nil;
     changetree:=false;
     searchstring:=searchstr.text;
     found:=false;
     for i:= 1 to MediaCollection.max_index-1 do begin
         if srch_title.checked then if  pos(lowercase(searchstring),lowercase(MediaCollection.lib[i].title))<>0 then found:=true;
         if srch_artist.checked then if  pos(lowercase(searchstring),lowercase(MediaCollection.lib[i].artist))<>0 then found:=true;
         if srch_album.checked then if  pos(lowercase(searchstring),lowercase(MediaCollection.lib[i].album))<>0 then found:=true;
         if srch_file.checked then if  pos(lowercase(searchstring),lowercase(extractfilename(MediaCollection.lib[i].path)))<>0 then found:=true;
         if found then begin
             found:=false;
             ft:='';
             case filetypebox.ItemIndex of
                  0: ft:='all';
                  1: ft:='.flac';
                  2: ft:='.mp3';
                  3: ft:='.ogg';
                  4: ft:='.wav';
                 end;
             if (ft='all') or (ft=MediaCollection.lib[i].filetype) then begin

              ListItem := Main.Titletree.Items.Add;

              Pcol:=@MediaCollection; //ACHTUNG!!!!! feste Collection!!!!
              PCol^.lib[i].index:=i;
              PCol^.lib[i].collection:=PCol;
              listitem.data:=@PCol^.lib[i];
              Listitem.ImageIndex:=PCol^.lib[i].action;
              Listitem.caption:='';

              if PCol^.lib[i].title<>'' then ListItem.SubItems.Add(PCol^.lib[i].artist) else ListItem.SubItems.Add(extractfilename(PCol^.lib[i].path));
              ListItem.SubItems.Add (PCol^.lib[i].title);
              ListItem.SubItems.Add (PCol^.lib[i].album);
              ListItem.SubItems.Add(PCol^.lib[i].playtime);
              end;
           end;
       end;
     TitleTree.EndUpdate;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.stopClick(Sender: TObject);
begin
    playtimer.enabled:=false;
    current_title_edit.text:='';
    current_title_edit1.text:='';
    playtime.text:='00:00';
    trackbar.position:=0;
    if (playlist.Items.Count>0) and (player.get_playlist_index>0) then playlist.Items[player.get_playlist_index-1].ImageIndex:=-1;
    player.stop;
    playwin.TitleImg.Picture.LoadFromFile(SkinData.Title.Img);
    playwin.TimeImg.Picture.LoadFromFile(SkinData.Time.Img);
    player.reset_random;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.EditID3itemClick(Sender: TObject);
var tsitem:TListitem;
    PFobj: PMp3fileobj;
begin
  tsitem:=TitleTree.Selected;

  if tsitem<>nil then begin
     Main.enabled:=false;
     editid3win:=TEditID3.create(nil);
     PFobj:=tsitem.data;
     editid3win.artist_only:=false;
     editid3win.album_only:=false;
     editid3win.show_tags(PFobj,PFobj^.collection);
     EditID3win.ShowModal;
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.ArtistTreeSelectionChanged(Sender: TObject);
begin
  if main.changetree=false then update_title_view;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.FormMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ArtistSrchField.hide; //unguenstig, wird bei jedem klick aufgerufen... :(
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.FormResize(Sender: TObject);
begin
     Panel4.Width:=oldSplitterWidth;
     Panel1.Width:=main.Width-oldSplitterWidth-8;
     writeln(oldSplitterWidth);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem6Click(Sender: TObject);
var PFobj: PMp3fileobj;
    pcol: PMediaCollection;
    tsitem: TListitem;
begin
if TitleTree.Selected<>nil then
if MessageDlg('The selected file(s) will permanently be'+#10+#13+'removed from harddisk!'+#10+#13+' Proceed?', mtWarning, mbOKCancel, 0)=mrOK then
 begin
  tsitem:=TitleTree.Selected;
  PFobj:=tsitem.data;
  pcol:=PFobj^.collection;
  
  i:=0;
  repeat inc(i) until (i>=PCol^.max_index-1) or (PFobj^.path=PCol^.lib[i].path);
  if i <= PCol^.max_index-1 then begin
     if DeleteFile(PFobj^.path) then writeln('deleted file from disk: '+PFobj^.path)
        else writeln('ERROR deleting file: '+PFobj^.path);
     PCol^.remove_entry(i);
   end;
  update_artist_view;
  update_title_view;
  PCol^.save_lib(PCol^.savepath);
 end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.NextButtonImgClick(Sender: TObject);
begin
    nextClick(nil);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.NextButtonImgMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  NextButtonImg.Picture.LoadFromFile(SkinData.next.Clicked);

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.NextButtonImgMouseEnter(Sender: TObject);
begin
  NextButtonImg.Picture.LoadFromFile(SkinData.next.MouseOver);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.NextButtonImgMouseLeave(Sender: TObject);
begin
  NextButtonImg.Picture.LoadFromFile(SkinData.next.Img);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.NextButtonImgMouseUp(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  NextButtonImg.Picture.LoadFromFile(SkinData.next.MouseOver);
end;

procedure TMain.SearchPanelClick(Sender: TObject);
begin
  ArtistSrchField.Hide;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.PlayerControlsPanelClick(Sender: TObject);
begin
  ArtistSrchField.hide;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.PauseButtonImgClick(Sender: TObject);
begin
   pauseClick(nil);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.PauseButtonImgMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   pauseButtonImg.Picture.LoadFromFile(SkinData.pause.Clicked);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.PauseButtonImgMouseEnter(Sender: TObject);
begin
     pauseButtonImg.Picture.LoadFromFile(SkinData.pause.MouseOver);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.PauseButtonImgMouseLeave(Sender: TObject);
begin
    pauseButtonImg.Picture.LoadFromFile(SkinData.pause.Img);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.PauseButtonImgMouseUp(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    pauseButtonImg.Picture.LoadFromFile(SkinData.pause.MouseOver);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.PlayButtonImgClick(Sender: TObject);
begin
  playclick(nil);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.PlayButtonImgMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PlayButtonImg.Picture.LoadFromFile(SkinData.play.Clicked);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.PlayButtonImgMouseEnter(Sender: TObject);
begin
  PlayButtonImg.Picture.LoadFromFile(SkinData.play.MouseOver);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.PlayButtonImgMouseLeave(Sender: TObject);
begin
   PlayButtonImg.Picture.LoadFromFile(SkinData.play.Img);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.PlayButtonImgMouseUp(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   PlayButtonImg.Picture.LoadFromFile(SkinData.play.MouseOver);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


procedure TMain.MainClose(Sender: TObject; var CloseAction: TCloseAction);
begin
     writeln('stop playing');
     player.stop;
     
     //Main.cfgfile.write_config('[playermount]', Main.playerpath);
     //Main.cfgfile.write_config('[mpg123]', Main.mpg123);
     //if MediaCollection.guess_tag then Main.cfgfile.write_config('[guess]','true') else Main.cfgfile.write_config('[guess]', 'false');
     if MediaCollection.saved then Main.cfgfile.SetValue('autoload', MediaCollection.savepath)
        else begin
                  if MediaCollection.max_index<>1 then begin
                     writeln('save lib');
                     MediaCollection.save_lib(ConfigPrefix+'lib'+DirectorySeparator+'last.mlb');
                     Main.cfgfile.SetValue('Library/autoload', ConfigPrefix+'lib'+DirectorySeparator+'last.mlb');
                   end;
              end;
     Main.cfgfile.SetValue('Skin/File', current_skin);

     if MediaCollection<>nil then MediaCollection.destroy;
     if PlayerCol<>nil then PlayerCol.destroy;
     checkmobile.Enabled:=false;
     playtimer.Enabled:=false;


     player.destroy;

{     skinmenuitems[1].free;
     PlayButtonImg.free;
     StopButtonImg.free;
     NextButtonImg.free;
     PreviousButtonImg.free;
     PauseButtonImg.free;

     timetmpbmp.free;
     tempbitmap.Free;
     
     ImageList1.Free;   }


     if playermode=false then begin
        playwin.close;
       // playwin.Free;
       end;
     cfgfile.Flush;
     cfgfile.free;
   try
     SimpleIPCServer1.StopServer;
     SimpleIPCServer1.free;
    except writeln('ERROR: Exception while shutting down IPC server');
    end;
  writeln('end.');
     Application.Terminate;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MainCreate(Sender: TObject);
begin
  cfgfile:=TXMLConfig.Create(nil);
  Caption:='Cactus Jukebox '+CACTUS_VERSION;

{$ifdef unix}
   HomeDir:=GetEnvironmentVariable('HOME');
{$endif}
{$ifdef CactusRPM}
   DataPrefix:='/usr/share/cactusjukebox/';
   ConfigPrefix:=main.HomeDir+'/.cactusjukebox/';
   writeln('This is Cactus RPM.');
  {$else}
   DataPrefix:=ExtractFilePath(ParamStr(0));
   ConfigPrefix:=ExtractFilePath(ParamStr(0));
   SetCurrentDir(ExtractFilePath(ParamStr(0)));
{$endif}

  
  TranslateUnitResourceStrings('mp3', DataPrefix+'languages/cactus.%s.po', 'de', '');
  // Load resourcestrings to Captions

  QuitItem.Caption:= Utf8ToAnsi(rsQuit);
  FileItem.Caption:= Utf8ToAnsi(rsFile);
  openfile.Caption:=  Utf8ToAnsi(rsOpenFile);
  player_lib.Caption:= Utf8ToAnsi(rsPlayerOnly);
  skinmenu.Caption:= Utf8ToAnsi(rsChooseSkin);
  SettingsItem.Caption:= Utf8ToAnsi(rsSettings);
  
  MIlibrary.Caption:= Utf8ToAnsi(rsLibrary);
  MInewlib.Caption:= Utf8ToAnsi(rsNewLibrary);
  MIloadlib.Caption:=  Utf8ToAnsi(rsLoadLibrary);
  MIsavelib.Caption:= Utf8ToAnsi(rsSaveLibrary);
  MIlibinfo.Caption:= Utf8ToAnsi(rsLibraryInfo);
  MIManagLib.Caption:= Utf8ToAnsi(rsManageLibrar);
  MIrescanlib.Caption:= Utf8ToAnsi(rsRescanDirect);
  
  MIPlaylist.Caption:= Utf8ToAnsi(rsPlaylist);
  MIplay.Caption:= Utf8ToAnsi(rsPlay);
  MInext.Caption:= Utf8ToAnsi(rsNext);
  MIprevious.Caption:= Utf8ToAnsi(rsPrevious);
  MImute.Caption:= Utf8ToAnsi(rsMute);
  MIload_list.Caption:= Utf8ToAnsi(rsLoadPlaylist);
  MIsave_list.Caption:= Utf8ToAnsi(rsSavePlaylist);
  
  MImobile.Caption:= Utf8ToAnsi(rsMobilePlayer);
  MImobile_info.Caption:= Utf8ToAnsi(rsDeviceInfo);
  MIscan_mobile.Caption:= Utf8ToAnsi(rsScanPlayer);
  MIsync.Caption:= Utf8ToAnsi(rsSync);
  MIclear_mobile.Caption:= Utf8ToAnsi(rsClearPlayer);
  MIundosync.Caption:= Utf8ToAnsi(rsUndoSelectio);

  MIaudiocd.Caption:= Utf8ToAnsi(rsAudioCD);
  MIrip.Caption:= Utf8ToAnsi(rsRipEncode);
  
  MIhelp.Caption:= Utf8ToAnsi(rsHelp);
  MIabout.Caption:= Utf8ToAnsi(rsAbout);
  MImanual.Caption:= Utf8ToAnsi(rsManual);
  
  clear_list.Caption:= Utf8ToAnsi(rsClear);
  srch_button.Caption:= Utf8ToAnsi(rsSearch);
  srch_album.Caption:= Utf8ToAnsi(rsAlbum);
  srch_artist.Caption:= Utf8ToAnsi(rsArtist);
  srch_file.Caption:= Utf8ToAnsi(rsFilename);
  srch_title.Caption:= Utf8ToAnsi(rsTitle);
  randomcheck.Caption:= Utf8ToAnsi(rsRandom);
  
  oldSplitterWidth:=Splitter1.Left;
  SplitterResize:=true;
  
  srch_title.checked:=true;
  srch_artist.checked:=true;
  playing:=false;

  player:=TFModPlayerClass.create;
  player_connected:=false;
  
  write('loading program icon...  ');
  Icon.LoadFromFile(DataPrefix+'icon'+DirectorySeparator+'cactus-icon.ico');
  writeln('... loaded');
{$ifdef win32}{workaround Listview autosize bug in win32}
  Main.Playlist.Columns[0].autosize:=false;
  Main.Playlist.Columns[0].width:=315;
  Main.Titletree.Columns[0].autosize:=false;
  Main.Titletree.Columns[1].autosize:=false;
  Main.Titletree.Columns[2].autosize:=false;
  Main.Titletree.Columns[3].autosize:=false;
  Main.Titletree.Columns[4].autosize:=false;
  Main.Titletree.Columns[4].width:=65;
  Main.Titletree.Columns[3].width:=140;
  Main.Titletree.Columns[2].width:=170;
  Main.Titletree.Columns[1].width:=140;
  Main.Titletree.Columns[0].width:=16;
  Main.homedir:='C:\';
{$endif win32}

{$ifdef LCLGtk2}
  Main.Titletree.Columns[0].width:=20;
{$endif LCLGtk2}


  SimpleIPCServer1.ServerID:='cactusjukeboxipc';

{$ifdef unix}
 Application.OnIdle:=@ApplicationIdle;
{$endif}
{$ifdef win32}
  SimpleIPCServer1.OnMessage:=@SimpleIPCServer1Message;
{$endif}
  SimpleIPCServer1.Global:=true;

  SimpleIPCServer1.StartServer;


end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.ApplicationIdle(Sender: TObject; var Done: Boolean);
var mp3obj: TMp3fileobj;
    templistitem: TListitem;
    fpath: string;
begin

if SimpleIPCServer1.PeekMessage(1,True) then begin
  fpath:=copy(SimpleIPCServer1.StringMessage, 4, length(SimpleIPCServer1.StringMessage));
  writeln(fpath);
  if (pos(inttostr(OPEN_FILE), SimpleIPCServer1.StringMessage)=1) and FileExists(fpath) then begin
        mp3obj:=TMp3FileObj.index_file(fpath);
        i:=player.add_to_playlist(mp3obj.path);
        player.playlist[i].artist:=Mp3obj.artist;
        player.playlist[i].title:=Mp3obj.title;
        tempListItem := Playlist.Items.Add;
        templistitem.data:=pointer(0);
        if Mp3obj.artist<>'' then tempListitem.caption:=Mp3obj.artist+' - '+Mp3obj.title else tempListitem.caption:=ExtractFileName(mp3obj.path);
        playlist.Selected:=templistitem;
        playClick(nil);
        mp3obj.destroy;

   end
    else writeln(' --> Invalid message/filename received via IPC');
  if (pos(inttostr(ENQUEU_FILE), SimpleIPCServer1.StringMessage)=1) and FileExists(fpath) then begin
        mp3obj:=TMp3FileObj.index_file(fpath);
        i:=player.add_to_playlist(mp3obj.path);
        player.playlist[i].artist:=Mp3obj.artist;
        player.playlist[i].title:=Mp3obj.title;
        tempListItem := Playlist.Items.Add;
        templistitem.data:=pointer(0);
        if Mp3obj.artist<>'' then tempListitem.caption:=Mp3obj.artist+' - '+Mp3obj.title else tempListitem.caption:=ExtractFileName(mp3obj.path);
        playlist.Selected:=templistitem;
        mp3obj.destroy;
   end
    else writeln(' --> Invalid message/filename received via IPC');
end;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MainKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key=113 then player_libClick(nil);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem11Click(Sender: TObject);
var Listitem:TListItem;
begin
   dirwin:=Tdirwin.Create(nil);
   tmps:='';
   for i:= 1 to length(MediaCollection.dirlist) do begin
       if MediaCollection.dirlist[i]<>';' then tmps:=tmps+MediaCollection.dirlist[i]
          else begin
               Listitem:=dirwin.dirlistview.items.add;
               Listitem.Caption:=tmps;
               tmps:='';
             end;
      end;
   dirwin.ShowModal;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem14Click(Sender: TObject);
var tsitem: TListItem;
    s : string;
    PFobj: PMp3fileobj;
begin
  tsitem:=TitleTree.Selected;
  if (tsitem<>nil) and player_connected then begin
     PFobj:=tsitem.data;
     for i:= 1 to MediaCollection.max_index-1 do
                  if PFobj^.id=MediaCollection.lib[i].id then MediaCollection.lib[i].action:=AREMOVE;

     for i:= 1 to PlayerCol.max_index-1 do
                  if PFobj^.id=PlayerCol.lib[i].id then PlayerCol.lib[i].action:=AREMOVE;
     update_artist_view;
     update_title_view;
     tmps:=GetCurrentDir;                             // get free memory on player, format string
     SetCurrentDir(playerpath);
     sizediff:= sizediff + PFobj^.size;
     str(round(((DiskFree(0) + sizediff) / 1024)/100), s);
     SetCurrentDir(tmps);
     tmps:=s;
     s:=copy(tmps, length(tmps), 1);
     delete(tmps, length(tmps), 1);
     tmps:=tmps+','+s;

     StatusBar1.Panels[1].Text:='Device connected     '+tmps+' MB Free';
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem16Click(Sender: TObject);
var tsitem: TListItem;
    s: string;
    pfobj: PMp3fileobj;
begin
  tsitem:=TitleTree.Selected;
  if (tsitem<>nil) and player_connected then begin
     PFobj:=tsitem.data;
     PFobj^.action:=AUPLOAD;

     update_artist_view;
     update_title_view;
     tmps:=GetCurrentDir;                             // get free memory on player, format string
     SetCurrentDir(playerpath);
     sizediff:=sizediff - PFobj^.size;
     str(round(((DiskFree(0) + sizediff) / 1024)/100), s);
     SetCurrentDir(tmps);
     tmps:=s;
     s:=copy(tmps, length(tmps), 1);
     delete(tmps, length(tmps), 1);
     tmps:=tmps+','+s;

     StatusBar1.Panels[1].Text:='Device connected     '+tmps+' MB Free';
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem19Click(Sender: TObject);
var z:real;
    s, used:string;
begin
  if player_connected then begin
     z:=0;
     for i:= 1 to PlayerCol.max_index-1 do z:=z+PlayerCol.lib[i].size;
     str(round((z / 1024)/100), tmps);

     s:=copy(tmps, length(tmps), 1);
     delete(tmps, length(tmps), 1);
     used:=tmps+','+s;

     tmps:=GetCurrentDir;
     SetCurrentDir(playerpath);
     str(round((DiskFree(0) / 1024)/100), s);
     SetCurrentDir(tmps);
     tmps:=s;
     s:=copy(tmps, length(tmps), 1);
     delete(tmps, length(tmps), 1);
     tmps:=tmps+','+s;
     str(PlayerCol.max_index-1, s);
     
     ShowMessage(s+' Files on mobile player    '+#10+'Totally '+used+' MB of music'+#10+'Free Disk Space: '+tmps+' MB');
   end else ShowMessage(rsNotConnected);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem20Click(Sender: TObject);
var tsitem: TListItem;
    pfobj: PMp3fileobj;
    s: string;
begin
  tsitem:=TitleTree.Selected;
  if tsitem<>nil then begin
     PFobj:=tsitem.data;
     if PFobj^.action=AREMOVE then begin
                  //PFobj^.action:=1;
                  sizediff:=sizediff-pfobj^.size;
                  for i:= 1 to MediaCollection.max_index-1 do
                        if PFobj^.id=MediaCollection.lib[i].id then MediaCollection.lib[i].action:=1;

                  for i:= 1 to PlayerCol.max_index-1 do
                        if PFobj^.id=PlayerCol.lib[i].id then PlayerCol.lib[i].action:=-1;
                end
                 else begin
                         PFobj^.action:=-1;
                         sizediff:=sizediff+pfobj^.size;
                       end;

      update_artist_view;
      update_title_view;
      tmps:=GetCurrentDir;                             // get free memory on player, format string

      SetCurrentDir(playerpath);
      str(round(((DiskFree(0) + sizediff) / 1024)/100), s);
      SetCurrentDir(tmps);
      tmps:=s;
      s:=copy(tmps, length(tmps), 1);
      delete(tmps, length(tmps), 1);
      tmps:=tmps+','+s;

      StatusBar1.Panels[1].Text:='Device connected     '+tmps+' MB Free';
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem26Click(Sender: TObject);
begin
{$ifdef win32}
  ShowMessage('Cactus Jukebox'+LineEnding+'version 0.3 unstable'+LineEnding+'This windows version is in alpha state and not fully functional   '+LineEnding+'written by Sebastian Kraft '+LineEnding+LineEnding+'(c) 2006'+LineEnding+'http://cactus.hey-you-freaks.de     ');
{$endif win32}
{$ifdef linux}
  ShowMessage('Cactus Jukebox'+LineEnding+'version'+CACTUS_VERSION+LineEnding+'written by Sebastian Kraft '+LineEnding+LineEnding+'(c) 2006'+LineEnding+'http://cactus.hey-you-freaks.de     ');
{$endif linux}
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem27Click(Sender: TObject);
var id:longint;
    listitem:TListitem;
begin
  OpenDialog1.Filter := 'M3U Playlist|*.m3u|All Files|*.*';
  OpenDialog1.InitialDir:=HomeDir;
 // DoDirSeparators(OpenDialog1.InitialDir);
  //OpenDialog1.DefaultExt := 'mlb';
  OpenDialog1.FilterIndex := 1;
  if Opendialog1.execute=true then begin
     player.load_playlist(Opendialog1.Filename);
     Playlist.Items.Clear;
     i:=player.maxlistindex;
     for id:= 1 to i do begin
            ListItem := Playlist.Items.Add;
            listitem.data:=pointer(0);
            ListItem.Caption:=player.Playlist[id].artist+' - '+player.Playlist[id].title;
         end;

   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem2Click(Sender: TObject);
var n:integer;
    Pcol: PMediaCollection;
    Listitem: TListItem;
    s1, s2: string;
    tempnode: TTreeNode;
    pfobj: PMp3fileobj;
begin
   tsnode:=Main.ArtistTree.Selected;

   if tsnode.Level>1 then tempnode:=tsnode.Parent else tempnode:=tsnode;
   if integer(tempnode.parent.data)=1 then PCol:=@MediaCollection else PCol:=@PlayerCol;

                                     {
   if (tsnode<>nil) and (tsnode.Level>0) then begin
     if tsnode.level<2 then album_mode:=false else album_mode:=true;
     PFobj:=tsnode.data;
     z:= PFobj^.index;
     curartist:=PCol^.lib[z].artist;
     curalbum:=PCol^.lib[z].album;
     repeat dec(z) until (z=0) or (PCol^.lib[z].artist<>curartist);
     inc(z);
     ext:=false;
                          }
     for n:= 0 to TitleTree.Items.Count-1 do begin
       PFobj:=titletree.Items[n].Data;
       z:=PFobj^.index;

       i:=Main.player.add_to_playlist(PCol^.lib[z].path);
       main.player.playlist[i].artist:=PCol^.lib[z].artist;
       main.player.playlist[i].title:=PCol^.lib[z].title;
       main.player.playlist[i].collection:=PCol;
       main.player.playlist[i].id:=PCol^.lib[z].id;
       main.player.Playlist[i].length:=PCol^.lib[z].playlength;
       ListItem := Main.Playlist.Items.Add;
       listitem.data:=@PCol^.lib[z];
       if PCol^.lib[z].title<>'' then ListItem.Caption:=PCol^.lib[z].artist+' - '+PCol^.lib[z].title else ListItem.Caption:=extractfilename(PCol^.lib[z].path);


     end;

{     repeat begin
       pfobj.PMp3fileobj;
       i:=Main.player.add_to_playlist(PCol^.lib[z].path);
       main.player.playlist[i].artist:=PCol^.lib[z].artist;
       main.player.playlist[i].title:=PCol^.lib[z].title;
       main.player.playlist[i].collection:=PCol;
       main.player.playlist[i].id:=PCol^.lib[z].id;
       main.player.Playlist[i].length:=PCol^.lib[z].playlength;
       ListItem := Main.Playlist.Items.Add;
       listitem.data:=@PCol^.lib[z];
       if PCol^.lib[z].title<>'' then ListItem.Caption:=PCol^.lib[z].artist+' - '+PCol^.lib[z].title else ListItem.Caption:=extractfilename(PCol^.lib[z].path);
      inc(z);
      if z<PCol^.max_index then if lowercase(curartist)=lowercase(PCol^.lib[z].artist) then else ext:=true;
      end;
      until (z>PCol^.max_index-1) or (ext=true);


     end;     }
   s1:=IntToStr((main.player.TotalLenght div 60) mod 60 );
   s2:=IntToStr((main.player.TotalLenght div 60) div 60 );
   main.playlist.Column[0].Caption:='Playlist            ('+IntToStr(main.player.ItemCount)+' Files/ '+s2+'h '+s1+'min )';
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem37Click(Sender: TObject);
var Pcol: PMediaCollection;
    curartist, curalbum, s: string;
    pfobj: PMp3fileobj;
begin
   tsnode:=ArtistTree.Selected;

   if (tsnode<>nil) and (tsnode.level>0) then begin
      PFobj:=tsnode.data;
      i:=PFobj^.index;
      Pcol:=PFobj^.collection;
      if tsnode.level=2 then
           begin
                curartist:=lowercase(pfobj^.artist);
                curalbum:=lowercase(pfobj^.album);
                repeat dec(i)
                    until lowercase(PCol^.lib[i].artist)<>curartist;
                inc(i);
                repeat begin
                      if (lowercase(PCol^.lib[i].album)=curalbum) and (PCol^.lib[i].action=AREMOVE) then begin
                         PCol^.lib[i].action:=AONPLAYER;
                         sizediff:=sizediff-Pcol^.lib[i].size;
                       end;
                      if (lowercase(PCol^.lib[i].album)=curalbum) and (PCol^.lib[i].action<>AONPLAYER) then begin
                         PCol^.lib[i].action:=ANOTHING;
                         sizediff:=sizediff+Pcol^.lib[i].size;
                       end;
                      inc(i);
                    end;
                  until (lowercase(PCol^.lib[i].artist)<>curartist) or (i> PCol^.max_index-1);

           end;
      if tsnode.level=1 then
           begin
                curartist:=lowercase(pfobj^.artist);
                repeat begin
                       if (PCol^.lib[i].action=AREMOVE) then begin
                          PCol^.lib[i].action:=AONPLAYER;
                          sizediff:=sizediff-Pcol^.lib[i].size;
                         end;
                       if (PCol^.lib[i].action<>AONPLAYER) then begin
                          PCol^.lib[i].action:=ANOTHING;
                          sizediff:=sizediff+Pcol^.lib[i].size;
                         end;
                       inc(i);
                     end;
                  until (lowercase(PCol^.lib[i].artist)<>curartist) or (i> PCol^.max_index-1);
           end;
      update_artist_view;
      update_title_view;
      tmps:=GetCurrentDir;                             // get free memory on player, format string
      SetCurrentDir(playerpath);
      str(round(((DiskFree(0) + sizediff) / 1024)/100), s);
      SetCurrentDir(tmps);
      tmps:=s;
      s:=copy(tmps, length(tmps), 1);
      delete(tmps, length(tmps), 1);
      tmps:=tmps+','+s;

      StatusBar1.Panels[1].Text:='Device connected     '+tmps+' MB Free';
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem43Click(Sender: TObject);
begin
  {$ifdef linux}
         exec('/usr/bin/firefox', 'http://cactus.hey-you-freaks.de');
         if Dosexitcode<>0 then exec('/usr/bin/mozilla-firefox', 'http://cactus.hey-you-freaks.de/index.php?page=manual');
         if Dosexitcode<>0 then exec('/usr/bin/konqueror', 'http://cactus.hey-you-freaks.de/index.php?page=manual');
         if Dosexitcode<>0 then Showmessage('The manual can be found at http://cactus.hey-you-freaks.de');
  {$endif}
  {$ifdef win32}
         Showmessage('The manual can be found at http://cactus.hey-you-freaks.de');
  {$endif}
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem46Click(Sender: TObject);
begin
  cdripwin:=Tcdrip.Create(nil);
  main.Enabled:=false;
  cdripwin.ShowModal;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.Panel1Click(Sender: TObject);
begin
  ArtistSrchField.hide;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.Panel1Resize(Sender: TObject);
begin
   Splitter1.Left:=oldSplitterWidth;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.Panel4Click(Sender: TObject);
begin
  ArtistSrchField.hide;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.ArtistSrchFieldClick(Sender: TObject);
begin
  ArtistSrchField.hide;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.PreviousButtonImgClick(Sender: TObject);
begin
    prevClick(nil);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.PreviousButtonImgMouseDown(Sender: TOBject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PreviousButtonImg.Picture.LoadFromFile(SkinData.previous.Clicked);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.PreviousButtonImgMouseEnter(Sender: TObject);
begin
  PreviousButtonImg.Picture.LoadFromFile(SkinData.previous.MouseOver);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.PreviousButtonImgMouseLeave(Sender: TObject);
begin
  PreviousButtonImg.Picture.LoadFromFile(SkinData.previous.Img);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.PreviousButtonImgMouseUp(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PreviousButtonImg.Picture.LoadFromFile(SkinData.previous.MouseOver);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.SimpleIPCServer1Message(Sender: TObject);
begin
  writeln('dddd');
  writeln(SimpleIPCServer1.StringMessage);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.SpeedButton1Click(Sender: TObject);
begin
  ArtistSrchField.hide;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.Splitter1Moved(Sender: TObject);
begin
  oldSplitterWidth:=Panel4.width;
  writeln('splittermoved');
  writeln(panel4.Width);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.StopButtonImgClick(Sender: TObject);
begin
     stopClick(nil);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.StopButtonImgMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   StopButtonImg.Picture.LoadFromFile(SkinData.stop.Clicked);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.StopButtonImgMouseEnter(Sender: TObject);
begin
  StopButtonImg.Picture.LoadFromFile(SkinData.stop.MouseOver);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.StopButtonImgMouseLeave(Sender: TObject);
begin
  StopButtonImg.Picture.LoadFromFile(SkinData.stop.Img);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.StopButtonImgMouseUp(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   StopButtonImg.Picture.LoadFromFile(SkinData.stop.MouseOver);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.TitleTreeClick(Sender: TObject);
begin
  ArtistSrchField.Hide;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function NumericCompare(List: TStringList; Index1, Index2: Integer):Integer;
var i1, i2: integer;
begin
 try
   i1:= StrToInt(List[Index2]);
   i2:= StrToInt(List[Index1]);
   Result := i2 - i1;
  except
    result:=0;
  end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.TitleTreeColumnClick(Sender: TObject; Column: TListColumn);
var sl:TstringList; //used for sorting
    counter, SubItemsColumnCount, IndexOfCurrentColumn:integer;
begin
    sl := TStringList.Create;
    try
       IndexOfCurrentColumn:= column.index;

       if IndexOfCurrentColumn = 0 then begin
          for counter := 0 to titletree.items.count -1 do begin
             sl. AddObject(titletree.Items[counter].Caption,titletree.items[counter]);
           end;
          sl.sort;
         end else begin
           for counter := 0 to titletree.items.count -1 do begin
              SubItemsColumnCount:= titletree.items[counter].subitems.Count;
              if (SubItemsColumnCount >= IndexOfCurrentColumn) then
                 sl.AddObject(titletree.items[counter].SubItems[IndexOfCurrentColumn-1],titletree.items[counter])
                 else
                 sl.AddObject('',titletree.items[counter]);
            end;
           sl.CustomSort(@NumericCompare);
        end;
     for counter := 0 to titletree.items.count -1 do begin
        titletree.items[counter] := TListItem(sl. Objects[counter]);
      end;
   finally
   sl.free;
end;
  
     writeln('sort tracks');
  //   TitleTree.BeginUpdate;
   //  TitleTree.SortColumn:=4;
//     TitleTree.so;
  //   TitleTree.EndUpdate;
//     ArtistTree.al;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.TitleTreeCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  n1, n2: integer;
begin
  n1 := StrToInt(Item1.SubItems[2]);
  n2 := StrToInt(Item2.SubItems[2]);
  if n1 > n2 then
    Compare := -1
  else if n1 < n2 then
    Compare := 1
  else
    Compare := 0;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.TitleTreeCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Odd(Item.Index)
    then Sender.Canvas.Font.Color := clMaroon
    else Sender.Canvas.Font.Color := clBlue;

end;

procedure TMain.TitleTreeCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin

end;

procedure TMain.TitleTreeMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     if Button=mbRight then begin
        LastRightClick.X:=X+TitleTree.left;
        LastRightClick.Y:=Y+TitleTree.Top;
        titlelistmenu.PopUp(x,y);
      end;
end;

procedure TMain.TitleTreeMouseUp(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     if Button=mbRight then begin
        LastRightClick.X:=X+TitleTree.left;
        LastRightClick.Y:=Y+TitleTree.Top;
        titlelistmenu.PopUp(x,y);
      end;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.TrackInfoClick(Sender: TObject);
begin
       if (player.get_playlist_index)>0 then begin
         playlist.selected:=main.playlist.Items[main.player.get_playlist_index-1];
         MenuItem10Click(nil);
       end;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


procedure TMain.artisttreemenuPopup(Sender: TObject);
var    pfobj: PMp3fileobj;
begin
  if ArtistTree.Selected.Level>0 then begin
    pfobj:=ArtistTree.Selected.Data;
    if PFobj^.collection=@PlayerCol then Menuitem30.enabled:=false else Menuitem30.enabled:=true;
    if ArtistTree.Selected.Level=1 then begin
      if ArtistTree.Selected.ImageIndex=1 then begin
            MenuItem37.Enabled:=false;
            rm_artist_playeritem.Enabled:=true;
            MenuItem30.Enabled:=true;
         end;
      if ArtistTree.Selected.ImageIndex=-1 then begin
            MenuItem37.Enabled:=false;
            rm_artist_playeritem.Enabled:=false;
            MenuItem30.Enabled:=true;
         end;
      if ArtistTree.Selected.ImageIndex=2 then begin
            MenuItem37.Enabled:=true;
            rm_artist_playeritem.Enabled:=false;
            MenuItem30.Enabled:=false;
         end;
      if ArtistTree.Selected.ImageIndex=3 then begin
            MenuItem37.Enabled:=true;
            rm_artist_playeritem.Enabled:=false;
            MenuItem30.Enabled:=false;
         end;
      end else begin
            MenuItem37.Enabled:=true;
            rm_artist_playeritem.Enabled:=true;
            MenuItem30.Enabled:=true;
          end;
    end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.checkmobileTimer(Sender: TObject);
var i,z:integer;
    PlayerScanThread: TScanThread;
    s: string;

begin
     if (player_connected=false) and FileExists(playerpath+'cactuslib') then begin
       PlayerCol.rootpath:=playerpath;
       if PlayerCol.load_lib(playerpath+'cactuslib')=0 then begin
              PlayerCol.dirlist:=playerpath+';';
              sizediff:=0;
              write('max_index');writeln(PlayerCol.max_index);
              for i:= 1 to PlayerCol.max_index-1 do begin
                z:=1;

                PlayerCol.lib[i].action:=AONPLAYER;
                while z < MediaCollection.max_index-1 do begin
                        if MediaCollection.lib[z].id=PlayerCol.lib[i].id then begin
                             MediaCollection.lib[z].action:=1;
                             z:= MediaCollection.max_index-1;
                          end;
                        inc(z);
                    end;

              end;
            update_artist_view;
            update_title_view;
            player_connected:=true;
            
            tmps:=GetCurrentDir;                             // get free memory on player, format string
            SetCurrentDir(playerpath);
            str(round((DiskFree(0) / 1024)/100), s);
            SetCurrentDir(tmps);
            tmps:=s;
            s:=copy(tmps, length(tmps), 1);
            delete(tmps, length(tmps), 1);
            tmps:=tmps+','+s;

            StatusBar1.Panels[1].Text:='Device connected     '+tmps+' MB Free';
            if background_scan then begin
               PlayerScanThread:=TScanThread.Create(true);
               PlayerScanThread.tmpcollection:=PlayerCol;
               PlayerScanThread.Resume;
            end;
         end else begin
             checkmobile.Enabled:=false;
             ShowMessage('Error while opening player device. '+#10+#13+'Try to scan player again...');
             player_connected:=true;
            end;
       end;
     if (player_connected=true) and (FileExists(playerpath+'cactuslib')=false) then begin
            // playlist.selected:=nil;
             i:=1;
             while i <= player.maxlistindex do begin
                  if player.playlist[i].collection=@PlayerCol then begin
                     Player.remove_from_playlist(i);
                     if player.maxlistindex<>0 then Playlist.Items[i-1].Delete;
                     if player.maxlistindex=0 then playlist.Clear;

                     dec(i);
                    end;
                  inc(i);
               end;
             PlayerCol.clear;

             for i:= 1 to MediaCollection.max_index-1 do MediaCollection.lib[i].action:=-1;
             ArtistTree.Selected:=nil;
             update_artist_view;
             update_title_view;
             player_connected:=false;
            StatusBar1.Panels[1].Text:='Device disconnected';
       end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.clearPlayerItemClick(Sender: TObject);
begin
  {if player_connected then begin
    res:=MessageDlg('All music files on the player will definitely be removed!!'+#10+#13+' Continue?', mtWarning, mbOKCancel, 0);
    if res=mrOK then begin
      err:=true
      i:= PlayerCol.max_index-1;
      repeat begin
             err:=DeleteFile(PlayerCol.lib[i].path);
             if err=true then dec(PlayerCol.max_index); {array length is not shorten here !!}
             dec(i);
           end;
        until i=0;
             
      if err=false then ShowMessage('Error while deleting one or more files.'+#10+#13+' Perhaps no write permission or file doesn''t exist')
    end;

  end else ShowMessage(rsNotConnected);}
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem10Click(Sender: TObject);
var Listitem:TListItem;
    mp3fileobj: TMp3fileobj;
    PFobj: PMp3fileobj;
begin
    Main.enabled:=false;
    editid3win:=TEditID3.create(nil);
    Listitem:=playlist.Selected;
    if listitem<>nil then begin
     if Listitem.Data<>nil then begin
       PFobj:=Listitem.Data;
       z:=PFobj^.id;
       if z>0 then begin
         editid3win.artist_only:=false;
         editid3win.album_only:=false;
         editid3win.show_tags(PFobj, PFobj^.collection);
        end;
     end
     else begin
        tmps:=player.Playlist[listitem.index+1].path;
        mp3fileobj:=TMp3fileobj.index_file(tmps);
        editid3win.artist_only:=false;
        editid3win.album_only:=false;
        editid3win.pathedit1.text:=mp3fileobj.path;
        editid3win.artistedit1.text:=mp3fileobj.artist;
        editid3win.titleedit1.text:=mp3fileobj.title;
        editid3win.albumedit1.text:=mp3fileobj.album;
        editid3win.commentedit1.text:=mp3fileobj.comment;
        editid3win.yearedit1.text:=mp3fileobj.year;

{        editid3win.artistedit2.text:=mp3fileobj.artistv2;
        editid3win.titleedit2.text:=mp3fileobj.titlev2;
        editid3win.albumedit2.text:=mp3fileobj.albumv2;
        editid3win.yearedit2.text:=mp3fileobj.yearv2;
        editid3win.trackedit2.text:=mp3fileobj.trackv2;}
        if mp3fileobj.filetype='.mp3' then editid3win.Filelogo.Picture.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'mp3_64.png');
        if mp3fileobj.filetype='.ogg' then editid3win.Filelogo.Picture.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'ogg_64.png');
        if mp3fileobj.filetype='.wav' then editid3win.Filelogo.Picture.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'wav_64.png');
        editid3win.metacontrol.ActivePage:=editid3win.metatab;
        editid3win.id3v1tab.TabVisible:=false;
        editid3win.id3v2tab.TabVisible:=false;
        EditID3win.pfileobj:=@mp3fileobj;
     end;
    end;
    EditID3win.ShowModal;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.clear_listClick(Sender: TObject);
begin
      Playlist.BeginUpdate;
      Playlist.Items.Clear;
      playlist.Column[0].Caption:= 'Playlist';
    //  current_title_edit.text:='';
    //  current_title_edit1.text:='';
    //  playwin.PlayButtonImg.Picture.LoadFromFile(SKIN_DIR+'back.bmp');
    //  playwin.PlayButtonImg.canvas.Font.Color:=CLRED;
      player.clear_playlist;
      Playlist.EndUpdate;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.filetypeboxChange(Sender: TObject);
begin
     srch_buttonClick(nil);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.libinfoClick(Sender: TObject);
var z:real;
    s, used :string;
begin
     z:=0;
     for i:= 1 to MediaCollection.max_index-1 do z:=z+MediaCollection.lib[i].size;
     str(round((z / 1024)/100), tmps);

     s:=copy(tmps, length(tmps), 1);
     delete(tmps, length(tmps), 1);
     used:=tmps+','+s;

     str(MediaCollection.max_index-1, s);

     ShowMessage(s+' Files in library '+#10+' '+used+' MB of music');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.muteClick(Sender: TObject);
begin
  player.mute;
  if player.get_mute then mute.Glyph.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'mute1.xpm') else mute.Glyph.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'mute2.xpm');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.openfileClick(Sender: TObject);
var mp3obj: TMp3fileobj;
    templistitem: TListItem;
begin
     OpenDialog1.Filter := 'All supported audio|*.wav;*.mp3;*.ogg|MP3|*.mp3|OGG|*.ogg|WAV|*.wav';
     OpenDialog1.InitialDir:=HomeDir;
     OpenDialog1.FilterIndex := 1;
     if Opendialog1.execute=true then begin
        mp3obj:=TMp3FileObj.index_file(Opendialog1.Filename);
        i:=player.add_to_playlist(mp3obj.path);
        player.playlist[i].artist:=Mp3obj.artist;
        player.playlist[i].title:=Mp3obj.title;
        tempListItem := Playlist.Items.Add;
        templistitem.data:=pointer(0);

        if Mp3obj.artist<>'' then tempListitem.caption:=Mp3obj.artist+' - '+Mp3obj.title else tempListitem.caption:=ExtractFileName(mp3obj.path);
        playlist.Selected:=templistitem;
        playClick(nil);
        mp3obj.destroy;
      end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.pauseClick(Sender: TObject);
begin
   player.pause;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.player_libClick(Sender: TObject);
begin
    if playwin.Active then begin
       playwin.hide;
       main.show;
       playermode:=false;
      end else begin
       playwin.show;
       main.hide;
       playermode:=true;
     end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.playlistClick(Sender: TObject);
begin
  ArtistSrchField.hide;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.playlistDblClick(Sender: TObject);
begin
 playclick(nil);
 writeln('playlistdblclciekd');
end;

procedure TMain.playlistDragDrop(Sender, Source: TObject; X, Y: Integer);
var   Targetitem, tmpitem : TListItem;
      ind:integer;
begin
{     writeln('ondragdrop');
     if playlist.GetItemAt(x,y)<>nil then Targetitem:=playlist.GetItemAt(x,y) else Targetitem := playlist.Selected;
     writeln(Sourceitem.Caption);
     writeln(sourceitem.Index);

     writeln(Targetitem.Caption);
     writeln(targetitem.index);
     
     if (Targetitem<>nil) and (Targetitem<>Sourceitem) then begin
        player.move_entry(sourceitem.Index+1, ind);
        writeln('insert');
        tmpitem:=playlist.Items.Insert(ind);
        tmpitem.Assign(sourceitem);

        sourceitem.Delete;


     end;    }
end;

procedure TMain.playlistDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  writeln('ondragover');
  Accept:=true;
end;

procedure TMain.playlistEndDrag(Sender, Target: TObject; X, Y: Integer);
var tmplitem: TListItem;
begin
  tmplitem:=TListItem(Target);
  writeln(tmplitem.Caption);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.playlistKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var tempitem:TListItem;
begin
  writeln(key);
  case key of
       17: ctrl_pressed:=true;
       38: if playlist.Selected.Index>0 then begin
              if ctrl_pressed then begin
                   i:=playlist.Selected.Index;
                   tempitem:=playlist.selected;
                   player.move_entry(i+1, i);
                   playlist.items[i]:=playlist.items[i-1];
                   playlist.items[i-1]:=tempitem;
                   playlist.BeginUpdate;
                   playlist.Selected:=playlist.items[i];
                   playlist.Selected:=playlist.items[i-1];
                   playlist.EndUpdate;
                 end
               else begin
                    playlist.selected:=playlist.items[playlist.Selected.Index];
                    playlist.selected:=playlist.items[playlist.Selected.Index-1];
                 end;
             end;
                
       40:  if playlist.Selected.Index<playlist.items.Count-1 then begin
              if ctrl_pressed then begin
                   i:=playlist.Selected.Index;
                   tempitem:=playlist.selected;
                   player.move_entry(i+1,i+2);
                   playlist.items[i]:=playlist.items[i+1];
                   playlist.items[i+1]:=tempitem;
                   playlist.BeginUpdate;
                   playlist.Selected:=playlist.items[i];
                   playlist.Selected:=playlist.items[i+1];
                   playlist.EndUpdate;
                 end
               else begin
                    playlist.selected:=playlist.items[playlist.Selected.Index];
                    playlist.selected:=playlist.items[playlist.Selected.Index+1];
                 end;
             end;
       46: MenuItem3Click(nil);
     end;
end;


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.playlistKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if key=17 then ctrl_pressed:=false;
end;

procedure TMain.playlistMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 {if playlist.Selected<>nil then begin
  sourceitem:=playlist.Selected;
  writeln(sourceitem.Caption);
  BeginDrag(false);
 end;
  }
end;

procedure TMain.playlistStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  sourceitem:=playlist.Selected;
  writeln(sourceitem.Caption);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.prevClick(Sender: TObject);
begin
     player.prev_track;
     i:=player.get_playlist_index;
     if i>0 then begin
          if playlist.Items.Count>1 then playlist.Items[i].ImageIndex:=-1;
          playlist.Items[i-1].ImageIndex:=0;
          if player.playlist[i].artist<>'' then current_title_edit.text:=player.playlist[i].artist else current_title_edit.text:=ExtractFileName(player.playlist[i].path);
          current_title_edit1.text:=player.playlist[i].title;
          playwin.TitleImg.Picture.LoadFromFile(SkinData.Title.Img);
          playwin.titleimg.canvas.Font.Color:=Clnavy;
          if player.playlist[i].artist<>'' then playwin.titleimg.canvas.textout(5,5,player.playlist[i].artist) else playwin.titleimg.canvas.textout(5,5,ExtractFileName(player.playlist[i].path));
          playwin.titleimg.canvas.textout(5,25,player.playlist[i].title);
{          playwin.PlayButtonImg.Picture.LoadFromFile(SKIN_DIR+'back.bmp');
          playwin.PlayButtonImg.canvas.Font.Color:=CLRED;
          playwin.PlayButtonImg.canvas.textout(10,10,player.playlist[i].artist+' - '+player.playlist[i].title);}
        end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.ArtistTreeDblClick(Sender: TObject);
begin
   if ArtistTree.Selected.Level>0 then artist_to_playlist;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.ArtistTreeClick(Sender: TObject);
begin
  ArtistSrchField.Hide;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.ArtistTreeKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var b: byte;
    c:char;
begin
  writeln(key);
  b:=key;
  c:=char(b);
  case key of
    45: for i:=0 to ArtistTree.Items.Count-1 do if ArtistTree.Items[i].Level=0 then ArtistTree.Items[i].Expanded:=false;
    43: for i:=0 to ArtistTree.Items.Count-1 do if ArtistTree.Items[i].Level=0 then ArtistTree.Items[i].Expanded:=true;
    27: ArtistSrchField.Hide;
    13: ArtistSrchField.Hide;
   else begin
             if not ArtistSrchField.visible then begin
                ArtistSrchField.Top:=main.Height-120;
                ArtistSrchField.Left:=Panel4.Width-155;
                ArtistSrchField.Show;
                artistsearch.Text:=c;
                artistsearch.SetFocus;
                artistsearch.SelLength:=0;
              end;
             i:=0;
             writeln(artistsearch.Text);
             repeat inc(i) until ((pos(lowercase(artistsearch.Text), lowercase(ArtistTree.Items[i].Text))=1) and (ArtistTree.Items[i].Level=1)) or (i>=ArtistTree.Items.Count-1);
             ArtistTree.Selected:=ArtistTree.Items[i];
          end;
  end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem30Click(Sender: TObject);
var PCol: PMediaCollection;
    curartist, curalbum, s: string;
    tmpsize: int64;
    pfobj: PMp3fileobj;
begin
   tsnode:=ArtistTree.Selected;
   tmpsize:=0;

   if (tsnode<>nil) and (tsnode.level>0) and player_connected then begin
      PFobj:=tsnode.data;
      i:=PFobj^.index;
      Pcol:=PFobj^.collection;
      if tsnode.level=2 then
           begin
                curartist:=lowercase(pfobj^.artist);
                curalbum:=lowercase(pfobj^.album);
                repeat dec(i)
                    until lowercase(PCol^.lib[i].artist)<>curartist;
                inc(i);
                repeat begin
                      if (lowercase(PCol^.lib[i].album)=curalbum) and (PCol^.lib[i].action=AREMOVE) then begin
                         PCol^.lib[i].action:=AONPLAYER;
                         sizediff:=sizediff - PCol^.lib[i].size;
                       end;
                      if (lowercase(PCol^.lib[i].album)=curalbum) and (PCol^.lib[i].action<>AONPLAYER) then begin
                          PCol^.lib[i].action:=AUPLOAD;
                          sizediff:=sizediff - PCol^.lib[i].size;
                        end;
                      inc(i);
                    end;
                  until (i> PCol^.max_index-1) or (lowercase(PCol^.lib[i].artist)<>curartist);

           end;
      if tsnode.level=1 then
           begin
                curartist:=lowercase(pfobj^.artist);
                repeat begin
                       if (PCol^.lib[i].action=AREMOVE) then begin
                          PCol^.lib[i].action:=AONPLAYER;
                          sizediff:=sizediff - PCol^.lib[i].size;
                         end;
                       if (PCol^.lib[i].action<>AONPLAYER) then begin
                           PCol^.lib[i].action:=AUPLOAD;
                           sizediff:=sizediff - PCol^.lib[i].size;
                         end;
                       inc(i);
                     end;
                  until (i> PCol^.max_index-1) or (lowercase(PCol^.lib[i].artist)<>curartist);
           end;
      update_artist_view;
      update_title_view;
      writeln(sizediff);
      tmps:=GetCurrentDir;                             // get free memory on player, format string
      SetCurrentDir(playerpath);
      str(round(((DiskFree(0) + sizediff) / 1024)/100), s);
      SetCurrentDir(tmps);
      tmps:=s;
      s:=copy(tmps, length(tmps), 1);
      delete(tmps, length(tmps), 1);
      tmps:=tmps+','+s;

      StatusBar1.Panels[1].Text:='Device connected     '+tmps+' MB Free';
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem33Click(Sender: TObject);
var PFobj: PMp3fileobj;
begin
     Main.enabled:=false;
     editid3win:=TEditID3.create(nil);
     tsnode:=ArtistTree.Selected;
     PFobj:=tsnode.data;
     if tsnode.level= 1 then begin
        editid3win.artist_only:=true;
        editid3win.show_tags(PFobj, PFobj^.collection);
       end;
     if tsnode.level= 2 then begin
        editid3win.album_only:=true;
        editid3win.show_tags(PFobj, PFobj^.collection);
       end;
   EditID3win.ShowModal;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.rm_artist_playeritemClick(Sender: TObject);
var PCol: PMediaCollection;
    curartist, curalbum, s: string;
    pfobj: PMp3fileobj;
begin
   tsnode:=ArtistTree.Selected;
   if (tsnode<>nil) and (tsnode.level>0) and player_connected then begin
      PFobj:=tsnode.data;
      i:=PFobj^.index;
      Pcol:=PFobj^.collection;
      if tsnode.level=2 then
           begin
                curartist:=lowercase(pfobj^.artist);
                curalbum:=lowercase(pfobj^.album);
                repeat dec(i)
                    until (lowercase(PCol^.lib[i].artist)<>curartist) or (i=0);
                inc(i);
                repeat begin
                      if (PCol^.lib[i].action=1) and (lowercase(PCol^.lib[i].album)=curalbum) then
                         begin
                              PCol^.lib[i].action:=AREMOVE;
                              for z:= 1 to MediaCollection.max_index-1 do
                                     if PCol^.lib[i].id=MediaCollection.lib[z].id then MediaCollection.lib[z].action:=AREMOVE;
                              for z:= 1 to PlayerCol.max_index-1 do
                                     if PCol^.lib[i].id=PlayerCol.lib[z].id then PlayerCol.lib[z].action:=AREMOVE;
                              sizediff:=sizediff + PCol^.lib[i].size;
                         end;
                      inc(i);
                    end;
                  until  (i> PCol^.max_index-1) or (lowercase(PCol^.lib[i].artist)<>curartist);
           end;
      if tsnode.level=1 then
           begin
                curartist:=lowercase(pfobj^.artist);
                repeat begin
                       if PCol^.lib[i].action=1 then
                          begin
                              PCol^.lib[i].action:=AREMOVE;
                              for z:= 1 to MediaCollection.max_index-1 do
                                     if PCol^.lib[i].id=MediaCollection.lib[z].id then MediaCollection.lib[z].action:=AREMOVE;
                              for z:= 1 to PlayerCol.max_index-1 do
                                     if PCol^.lib[i].id=PlayerCol.lib[z].id then PlayerCol.lib[z].action:=AREMOVE;
                              sizediff:=sizediff + PCol^.lib[i].size;
                         end;
                       inc(i);
                     end;
                  until (i> PCol^.max_index-1) or (lowercase(PCol^.lib[i].artist)<>curartist);
           end;
      update_artist_view;
      update_title_view;
      
      tmps:=GetCurrentDir;                             // get free memory on player, format string
      SetCurrentDir(playerpath);
      str(round(((DiskFree(0) + sizediff) / 1024)/100), s);
      SetCurrentDir(tmps);
      tmps:=s;
      s:=copy(tmps, length(tmps), 1);
      delete(tmps, length(tmps), 1);
      tmps:=tmps+','+s;

      StatusBar1.Panels[1].Text:='Device connected     '+tmps+' MB Free';
   end;
end;

procedure TMain.searchstrClick(Sender: TObject);
begin
  ArtistSrchField.Hide;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.skinmenuClick(Sender: TObject);
begin

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.syncplayeritem(Sender: TObject);
var res: boolean;
    newfile, s: string;
    n: integer;
    ucount, rcount, ucount2, rcount2: integer;
    bytesneeded: int64;
begin
    if player_connected=false then begin ShowMessage(rsNotConnected);exit;end;
    rcount:=1;
    ucount:=1;
    bytesneeded:=0;
    for n:= 1 to MediaCollection.max_index-1 do begin
            if MediaCollection.lib[n].action=2 then begin
                                                       inc(rcount);
                                                       bytesneeded:=bytesneeded - MediaCollection.lib[n].size;
                                                    end;
            if MediaCollection.lib[n].action=3 then begin
                                                       inc(ucount);
                                                       bytesneeded:=bytesneeded + MediaCollection.lib[n].size;
                                                    end;
        end;
    Application.ProcessMessages;
    writeln(bytesneeded);
    tmps:=GetCurrentDir;                             // get free memory on player, format string
    SetCurrentDir(playerpath);
    if DiskFree(0) < bytesneeded then begin ShowMessage('ERROR: Not enough free disk space on mobile device!');exit;end;
    SetCurrentDir(tmps);
    writeln(rcount);

    main.Enabled:=false;
    Statuswin:=TStatus.create(nil);
//    statuswin.ShowModal; show modal not working here, don't know why...
    statuswin.ShowOnTop;
    statuswin.Statuslabel.Caption:= 'Remove files from player';
    Application.ProcessMessages;
    n:=1;
    ucount2:=1;
    rcount2:=1;
    while n < PlayerCol.max_index do begin
            statuswin.ProgressBar1.Position:=(rcount2*100) div rcount;
            Application.ProcessMessages;
            if PlayerCol.lib[n].action = 2 then begin
               inc(rcount2);
               res:=DeleteFile(PlayerCol.lib[n].path);
               writeln('remove file '+PlayerCol.lib[n].path);
               if DirectoryIsEmpty(ExtractFileDir(PlayerCol.lib[n].path)) then
                  if RemoveDir(ExtractFileDir(PlayerCol.lib[n].path)) then writeln('Removed Directory '+ExtractFileDir(PlayerCol.lib[n].path))
                        else writeln('ERROR: couldn''t remove Directory '+ ExtractFileDir(PlayerCol.lib[n].path));


               if (res=true) or (FileExists(PlayerCol.lib[n].path)=false) then begin
                           PlayerCol.remove_entry(n);
                           dec(n);
                         end
                           else  writeln('Couldn''t delete file '+PlayerCol.lib[n].path);
              end;
            inc(n);
        end;
    Application.ProcessMessages;
    for n:= 1 to MediaCollection.max_index-1 do if MediaCollection.lib[n].action = 2 then MediaCollection.lib[n].action:=-1;
    statuswin.Statuslabel.caption:= 'Upload files to player';
    Application.ProcessMessages;
    for n:= 1 to MediaCollection.max_index-1 do begin
            statuswin.ProgressBar1.Position:=(ucount2*100) div ucount;
            Application.ProcessMessages;

            if MediaCollection.lib[n].action = 3 then begin
               inc(ucount2);
               if mobile_subfolders then begin
                  if FileExists(playerpath+lowercase(MediaCollection.lib[n].artist))=false then mkdir(playerpath+lowercase(MediaCollection.lib[n].artist));
                  newfile:=playerpath+lowercase(MediaCollection.lib[n].artist)+'/'+ExtractFileName(MediaCollection.lib[n].path);
                 end
                 else
                  newfile:=playerpath+ExtractFileName(MediaCollection.lib[n].path);
               DoDirSeparators(newfile);
               write('copy...   '+newfile);

               FileCopy(MediaCollection.lib[n].path, newfile);
               MediaCollection.lib[n].action:=1;
               writeln('  finished');
               PlayerCol.add_file(newfile);
               PlayerCol.lib[PlayerCol.max_index-1].action:=AONPLAYER;
              end;
        end;
    PlayerCol.save_lib(playerpath+'/cactuslib');
    Statuswin.destroy;
    Main.Enabled:=true;
    update_artist_view;
    update_title_view;
    
    tmps:=GetCurrentDir;                             // get free memory on player, format string
    SetCurrentDir(playerpath);
    str(round((DiskFree(0) / 1024)/100), s);
    SetCurrentDir(tmps);
    tmps:=s;
    s:=copy(tmps, length(tmps), 1);
    delete(tmps, length(tmps), 1);
    tmps:=tmps+','+s;

    StatusBar1.Panels[1].Text:='Device connected     '+tmps+' MB Free';
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem36Click(Sender: TObject);
var z:real;
    s:string;
begin
  z:=0;
  for i:= 1 to MediaCollection.max_index-1 do z:=z+MediaCollection.lib[i].size;
  str(round((z / 1024)/100), tmps);

  s:=copy(tmps, length(tmps), 1);
  delete(tmps, length(tmps), 1);
  tmps:=tmps+','+s;
  str(MediaCollection.max_index-1, s);
  ShowMessage(s+' Files in '+MediaCollection.rootpath+'   '+#10+'Totally '+tmps+' MB of mp3');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem3Click(Sender: TObject);
var s1, s2: string;
begin
    if playlist.selected<>nil then begin
      i:=playlist.selected.index;
      player.remove_from_playlist(i+1);
      Playlist.Selected.delete;
      s1:=IntToStr((main.player.TotalLenght div 60) mod 60 );
      s2:=IntToStr((main.player.TotalLenght div 60) div 60 );
      playlist.Column[0].Caption:='Playlist            ('+IntToStr(main.player.ItemCount)+' Files/ '+s2+'h '+s1+'min )';
      if (i>=1) and (i=playlist.items.count) then dec(i);
      playlist.selected:=playlist.items[i];
    end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.Menuitem22Click(Sender: TObject);
begin
    setupwin:=Tsettings.create(nil);
  //  setupwin.mpg123pathedit1.text:= Main.mpg123;
    setupwin.playerpathedit1.text:=Main.playerpath;
    if MediaCollection.guess_tag then setupwin.guesstag1.checked:=true else setupwin.unknown1.checked:=true;
    if Main.background_scan then setupwin.backscan.checked:=true else setupwin.backscan.checked:=false;
    if Main.mobile_subfolders then setupwin.subfolders.checked:=true else setupwin.subfolders.checked:=false;
    if main.id3v2_prio then setupwin.v2_prio.Checked:=true else setupwin.v1_prio.checked:=true;
    setupwin.ShowModal;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.RemoveClick(Sender: TObject);
begin
     main.changetree:=true;
     MediaCollection.clear;
     Main.TitleTree.Items.Clear;
     Main.ArtistTree.Items.Clear;
     Main.Playlist.Items.Clear;
     main.changetree:=false;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.QuitItemClick(Sender: TObject);
begin
  Main.close;
  Application.ProcessMessages;

  // halt;
    Application.Terminate;
 //  Application.Free;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Procedure TMain.MoveNode(TargetNode, SourceNode : TTreeNode);
var
  nodeTmp : TTreeNode;
  i : Integer;
begin
{  with Selecttree do
  begin
    nodeTmp := Items.AddChild(TargetNode,SourceNode.Text);
    for i := 0 to SourceNode.Count -1 do
    begin
      MoveNode(nodeTmp,SourceNode.items[i]);
    end;
  end;}
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.startplay;
var
  i:integer;
  tmpp: PChar;
begin
   if (playing=false) then begin
     i:=integer(playitem.data);
     if FileExists(MediaCollection.lib[i].path) then begin
        current_title_edit.text:=MediaCollection.lib[i].artist;
        current_title_edit1.text:=MediaCollection.lib[i].title;
        tmpp:=StrAlloc(length(MediaCollection.lib[i].path)+1);
        StrPCopy(tmpp,MediaCollection.lib[i].path);
      //  Soundhandle:=FSOUND_Stream_Open(tmpp,0, 0, 0);
      //  FSOUND_Stream_Play (0,Soundhandle);
        playing:=true;
        playtimer.enabled:=true;
      end else Showmessage('File not Found! Goto Library/Rescan Directories for updating file links');
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.titlelistmenuPopup(Sender: TObject);
var     pfobj: PMp3fileobj;
begin
  if TitleTree.Selected<>nil then begin
  PFobj:=TitleTree.Selected.Data;
 // Menuitem16.ImageIndex:=1;
  if PFobj^.collection=@PlayerCol then begin
      Menuitem16.enabled:=false;
      Menuitem14.enabled:=true;
     end
     else begin
      Menuitem16.enabled:=false; //upload
      Menuitem14.Enabled:=false; //remove

      if PFobj^.action=-1 then begin
          Menuitem16.enabled:=true;
         end;

      if PFobj^.action=1 then begin
          Menuitem14.enabled:=true;
         end;
    end;
{  MenuItem16.ImageIndex:=1;
  MenuItem14.ImageIndex:=1;
  TEditID3item.ImageIndex:=1;}
 end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.toggle_playpause(Sender: TObject);
begin
  if player.playing then pauseClick(nil) else playClick(nil);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.trackbarMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     playtimer.enabled:=false;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.trackbarMouseUp(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var k, spos, slength: real;
begin
  k:=trackbar.position;
  slength:=player.get_file_length;
  spos:=round((k*slength) / (100));
  i:=round(spos);
  player.set_file_position(i);
  if player.playing then playtimer.enabled:=true;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.undoSyncItemClick(Sender: TObject);
var s:string;
begin
  for i:= 1 to MediaCollection.max_index-1 do begin
      if MediaCollection.lib[i].action=AUPLOAD then MediaCollection.lib[i].action:=ANOTHING;
      if MediaCollection.lib[i].action=AREMOVE then MediaCollection.lib[i].action:=AONPLAYER;
    end;
    
  for i:= 1 to PlayerCol.max_index-1 do begin
      if PlayerCol.lib[i].action=AUPLOAD then PlayerCol.lib[i].action:=ANOTHING;
      if PlayerCol.lib[i].action=AREMOVE then PlayerCol.lib[i].action:=AONPLAYER;
    end;
  update_artist_view;
  update_title_view;
  sizediff:=0;
     tmps:=GetCurrentDir;                             // get free memory on player, format string
     SetCurrentDir(playerpath);
     str(round((DiskFree(0) / 1024)/100), s);
     SetCurrentDir(tmps);
     tmps:=s;
     s:=copy(tmps, length(tmps), 1);
     delete(tmps, length(tmps), 1);
     tmps:=tmps+','+s;

    StatusBar1.Panels[1].Text:='Device connected     '+tmps+' MB Free';
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.volumebarChange(Sender: TObject);
begin
  player.set_volume((50-volumebar.Position)*2);
  writeln('volume set');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.fileopen(path: string);
var mp3obj: TMp3fileobj;
    templistitem: TListItem;
begin
        mp3obj:=TMp3FileObj.index_file(path);
        writeln('file '+path+' indexed');
        i:=player.add_to_playlist(mp3obj.path);
        player.playlist[i].artist:=Mp3obj.artist;
        player.playlist[i].title:=Mp3obj.title;
        tempListItem := Playlist.Items.Add;
        templistitem.data:=nil;

        if Mp3obj.artist<>'' then tempListitem.caption:=Mp3obj.artist+' - '+Mp3obj.title else tempListitem.caption:=ExtractFileName(mp3obj.path);
        playClick(nil);
        mp3obj.destroy;
end;


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.TitleTreeDblClick(Sender: TObject);
begin
    title_to_playlist;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.addFileItemClick(Sender: TObject);
begin
     if Opendialog1.execute=true then MediaCollection.lib[MediaCollection.max_index]:=TMp3FileObj.index_file(Opendialog1.Filename);
     writeln(MediaCollection.lib[MediaCollection.max_index].artist);
     inc(MediaCollection.max_index);
     main.changetree:=true;
       update_artist_view;
       update_title_view;
     main.changetree:=false;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure title_to_playlist;
var tsnode:TListitem;
    PCol: PMediaCollection;
    listitem:TListitem;
    s1,s2:string;
    pfobj: PMp3fileobj;
begin
   tsnode:=main.TitleTree.Selected;

   if (tsnode<>nil) and (tsnode.ImageIndex<>4) then begin
     PFobj:=tsnode.data;
     PCol:=PFobj^.collection;
     z:= PFobj^.index;
     i:=Main.player.add_to_playlist(PCol^.lib[z].path);
     main.player.playlist[i].artist:=PCol^.lib[z].artist;
     main.player.playlist[i].title:=PCol^.lib[z].title;
     main.player.playlist[i].collection:=PCol;
     main.player.playlist[i].id:=PCol^.lib[z].id;
     main.player.playlist[i].length:=PCol^.lib[z].playlength;
     ListItem := Main.Playlist.Items.Add;
     listitem.data:=@PCol^.lib[z];

     if PCol^.lib[z].title<>'' then ListItem.Caption:=PCol^.lib[z].artist+' - '+PCol^.lib[z].title else ListItem.Caption:=extractfilename(PCol^.lib[z].path);
   end;
{   if (tsnode<>nil) and (tsnode.ImageIndex=4) then begin
     z:=integer(tsnode.Data);
     str(z, tmps);
     i:=Main.player.add_to_playlist('CD AUDIO '+tmps);
     main.player.playlist[i].artist:='CD Audio';
     main.player.playlist[i].title:='Track '+tmps
     ListItem := Main.Playlist.Items.Add;
//     listitem.data:=@PCol^.lib[z];
     ListItem.Caption:='CD Audio Track '+tmps;
                   }
                   
   s1:=IntToStr((main.player.TotalLenght div 60) mod 60 );
   s2:=IntToStr((main.player.TotalLenght div 60) div 60 );
   main.playlist.Column[0].Caption:='Playlist                       ('+IntToStr(main.player.ItemCount)+' Files/ '+s2+'h '+s1+'min )';
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure artist_to_playlist;
var tempnode, tsnode:TTreeNode;
    s1,s2,curartist, curalbum: string;
    Listitem:TListitem;
    album_mode:boolean;
    PCol: PMediaCollection;
    pfobj: PMp3fileobj;
    ext: boolean;
begin
   tsnode:=Main.ArtistTree.Selected;

   if tsnode.Level>1 then tempnode:=tsnode.Parent else tempnode:=tsnode;
   if integer(tempnode.parent.data)=1 then PCol:=@MediaCollection else PCol:=@PlayerCol;


   if (tsnode<>nil) and (tsnode.Level>0) then begin
     if tsnode.level<2 then album_mode:=false else album_mode:=true;
     PFobj:=tsnode.data;
     z:= PFobj^.index;
     curartist:=lowercase(PCol^.lib[z].artist);
     curalbum:=lowercase(PCol^.lib[z].album);
     repeat dec(z) until (z=0) or (lowercase(PCol^.lib[z].artist)<>curartist);
     inc(z);
     ext:=false;

     repeat begin
      if (album_mode=false) or ((album_mode=true) and (lowercase(PCol^.lib[z].album)=curalbum)) then begin
       i:=Main.player.add_to_playlist(PCol^.lib[z].path);
       main.player.playlist[i].artist:=PCol^.lib[z].artist;
       main.player.playlist[i].title:=PCol^.lib[z].title;
       main.player.playlist[i].collection:=PCol;
       main.player.playlist[i].id:=PCol^.lib[z].id;
       main.player.Playlist[i].length:=PCol^.lib[z].playlength;
       ListItem := Main.Playlist.Items.Add;
       listitem.data:=@PCol^.lib[z];
       if PCol^.lib[z].title<>'' then ListItem.Caption:=PCol^.lib[z].artist+' - '+PCol^.lib[z].title else ListItem.Caption:=extractfilename(PCol^.lib[z].path);
       end;
      inc(z);
      if z<PCol^.max_index then if curartist=lowercase(PCol^.lib[z].artist) then else ext:=true;
      end;
      until (z>PCol^.max_index-1) or (ext=true);
     end;
   s1:=IntToStr((main.player.TotalLenght div 60) mod 60 );
   s2:=IntToStr((main.player.TotalLenght div 60) div 60 );
   main.playlist.Column[0].Caption:='Playlist            ('+IntToStr(main.player.ItemCount)+' Files/ '+s2+'h '+s1+'min )';
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure update_title_view;
var tsnode, tempnode:TTreeNode;
    curartist, curalbum: string;
    Listitem:TListItem;
    album_mode:boolean;
    PCol: PMediaCollection;
    PFobj: PMp3fileobj;
    ext: boolean;
begin
     tsnode:=Main.ArtistTree.Selected;
     main.StatusBar1.Panels[0].Text:='Please wait... updating...';
    // Application.ProcessMessages;
    writeln;
    write('## update title view...');

    Main.TitleTree.Items.Clear;
    Main.TitleTree.BeginUpdate;
    write(' cleared items...');

     if (tsnode<>nil) and (tsnode.level>0) then begin

         if tsnode.Level>1 then tempnode:=tsnode.Parent else tempnode:=tsnode;
         if integer(tempnode.parent.data)=1 then PCol:=@MediaCollection else PCol:=@PlayerCol;
         
         if tsnode.level=2 then album_mode:=true else album_mode:=false;

         PFobj:=tsnode.data;
         z:=PFobj^.index;
         curartist:=lowercase(PCol^.lib[z].artist);
         write(curartist);
         if album_mode then begin
            curalbum:=lowercase(PCol^.lib[z].album);
            while (z>0) and (lowercase(PCol^.lib[z].artist)=curartist) do dec(z);
            inc(z);
          end;

         i:=z;
         ext:=false;

         repeat begin

            if ((album_mode=false) and (curartist=lowercase(PCol^.lib[i].artist))) or ((album_mode) and (curalbum=lowercase(PCol^.lib[i].album)) and (curartist=lowercase(PCol^.lib[i].artist))) then begin

              ListItem := Main.Titletree.Items.Add;
              PCol^.lib[i].index:=i;
              PCol^.lib[i].collection:=PCol;
              listitem.data:=@PCol^.lib[i];
              Listitem.ImageIndex:=PCol^.lib[i].action;
              Listitem.caption:='';

              if PCol^.lib[i].title<>'' then ListItem.SubItems.Add((PCol^.lib[i].artist)) else ListItem.SubItems.Add(extractfilename(PCol^.lib[i].path));
              ListItem.SubItems.Add ((PCol^.lib[i].title));
              ListItem.SubItems.Add ((PCol^.lib[i].album));
              ListItem.SubItems.Add (PCol^.lib[i].track);
              ListItem.SubItems.Add(PCol^.lib[i].playtime);
            end
            else if curartist<>lowercase(PCol^.lib[i].artist) then ext:=true;
            inc(i);
          end;
         until (i>PCol^.max_index-1) or (ext=true);
     end;
 {  if (tsnode.Level=0) and (tsnode.ImageIndex=4) then begin
         z:=integer(tsnode.Data);
         for i:= 1 to z do begin
              ListItem := Main.Titletree.Items.Add;
             // listitem.data:=@PCol^.lib[i];
              Listitem.ImageIndex:=4;
              Listitem.caption:='';
              str(i, tmps);
              ListItem.SubItems.Add('CD Audio Track '+tmps);
              ListItem.SubItems.Add ('');
              ListItem.SubItems.Add ('');
              t:=FSOUND_CD_GetTrackLength(0, i);
              t:=t div 1000;
              min:=t div 60;
              sec:=t mod 60;
              str(min, s);
              str(sec, s2);
              if min<10 then s:='0'+s;
              if sec<10 then s2:='0'+s2;
              ListItem.SubItems.Add(s+':'+s2);

             end;
      end;}
     writeln('finished title view ##');
     main.StatusBar1.Panels[0].Text:='Ready.';
     Main.TitleTree.EndUpdate;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure update_artist_view;
var existing, existing_album, curartist, tmps2:string;
    tsnode, artnode, localnode, playernode, cdnode:Ttreenode;
    PCol : PMediaCollection;
    PFobj2: PMp3fileobj;
    pfobj: PMp3fileobj;
begin
     main.changetree:=true;
     main.Enabled:=false;
     main.ArtistTree.Enabled:=false;
     main.StatusBar1.Panels[0].Text:='Please wait... updating...';
     Application.ProcessMessages;
     main.artisttree.beginupdate;
     writeln;
     write('## update artist view... ');
     tsnode:=Main.ArtistTree.Selected;
     if (tsnode<>nil) and (tsnode.level>0)  then begin
          PFobj:=tsnode.data;
          i:= PFobj^.index;
          PCol:=PFobj^.collection;
          curartist:=lowercase(Pcol^.lib[i].artist);
          if i>PCol^.max_index-1 then i:=1;
       end else begin
           i:=1;
           curartist:='';
         end;
     write(' clear trees...');
     Main.ArtistTree.Items.Clear;

{sorting database}
     write(' sorting...');

     existing:='';
     localnode:=Main.ArtistTree.Items.Add(nil, 'Local Harddisk');
     localnode.ImageIndex:=6;
     localnode.SelectedIndex:=6;
     localnode.data:=pointer(1);
     PCol:=@MediaCollection;
     Pcol^.sort;
     for i:=1 to (MediaCollection.max_index-1) do begin
        MediaCollection.lib[i].index:=i;
        if MediaCollection.lib[i].artist<>'' then tmps:=MediaCollection.lib[i].artist else tmps:='Unknown';
        if lowercase(existing)<>lowercase(tmps) then begin
           existing:=tmps;
           existing_album:='';
           artnode:=Main.ArtistTree.Items.AddChild(localnode, existing);

           with artnode do
             begin
               MakeVisible;
               ImageIndex:=-1;
               MediaCollection.lib[i].collection:=PCol;
               Data:=@MediaCollection.lib[i];
             end;
            artnode.expand(false);
          end;
        if (MediaCollection.lib[i].action=1) and (artnode.ImageIndex=-1) then artnode.ImageIndex:=1;
        if (MediaCollection.lib[i].action=2) then artnode.ImageIndex:=2;
        if (MediaCollection.lib[i].action=3) then artnode.ImageIndex:=3;
        artnode.SelectedIndex:=artnode.ImageIndex;
        
        if MediaCollection.lib[i].album<>'' then tmps2:=MediaCollection.lib[i].album else tmps2:='Unknown';
        if pos(lowercase(tmps2)+':',lowercase(existing_album)+':')=0 then begin
           existing_album:=existing_album+tmps2+':';
           with Main.ArtistTree.Items.Addchild(artnode,tmps2) do
             begin
               MakeVisible;
               ImageIndex:=-1;
               SelectedIndex:=-1;
               MediaCollection.lib[i].collection:=PCol;
               Data:=@MediaCollection.lib[i];
             end;
            artnode.expanded:=(false);
          end;
     end;
     existing:='';
     playernode:=Main.ArtistTree.Items.Add(nil, 'Mobile Player');
     write(' mobile collection...');
     playernode.SelectedIndex:=1;
     playernode.ImageIndex:=1;
     playernode.data:=pointer(0);
     PCol:=@PlayerCol;
     Pcol^.sort;
     for i:=1 to (PCol^.max_index-1) do begin
        PCol^.lib[i].index:=i;
        if PCol^.lib[i].artist<>'' then tmps:=PCol^.lib[i].artist else tmps:='Unknown';
        if lowercase(existing)<>lowercase(tmps) then begin
           existing:=tmps;
           existing_album:='';
           artnode:=Main.ArtistTree.Items.AddChild(playernode, existing);
           with artnode do
             begin
               MakeVisible;
               ImageIndex:=-1;
               SelectedIndex:=-1;
               PCol^.lib[i].collection:=PCol;
               Data:=@PCol^.lib[i];
             end;
            artnode.expand(false);
          end;

        if PCol^.lib[i].album<>'' then tmps2:=PCol^.lib[i].album else tmps2:='Unknown';
        if pos(lowercase(tmps2)+':',lowercase(existing_album)+':')=0 then begin
           existing_album:=existing_album+tmps2+':';
           with Main.ArtistTree.Items.Addchild(artnode,tmps2) do
             begin
               MakeVisible;
               ImageIndex:=-1;
               SelectedIndex:=-1;
               PlayerCol.lib[i].collection:=PCol;
               Data:=@PlayerCol.lib[i];
             end;
            artnode.expanded:=(false);
          end;
     end;
    { cdnode:=Main.ArtistTree.Items.Add(nil, 'Audio CD');
     cdnode.ImageIndex:=4;
     cdnode.SelectedIndex:=4;
     cdnode.data:=pointer(FSOUND_CD_GetNumTracks(0));
     }


     i:=1;
     if pfobj<>nil then begin
     repeat begin
            pfobj2:=main.ArtistTree.items[i].data;
            inc(i);
         end;
     until ((lowercase(main.artisttree.items[i].text)=curartist) and (main.artisttree.items[i].level=1) and (pfobj2^.collection=PFobj^.collection)) or (i=main.artisttree.items.count-1);
     end;
     if lowercase(main.artisttree.items[i].text)=curartist then begin
            main.artisttree.selected:=main.artisttree.items[i];
       end else if curartist='' then main.artisttree.selected:=main.artisttree.items[1];

     main.artisttree.endupdate;
     main.changetree:=false;
     writeln(' finished artistview##');
     main.StatusBar1.Panels[0].Text:='Ready.';
     main.Enabled:=true;
     main.ArtistTree.Enabled:=true;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure update_playlist;
var    PCol : PMediaCollection;
begin
     PCol:=@Mediacollection;
     if PCol^.max_index>1 then begin
        for i:= 1 to main.player.maxlistindex do begin
            z:=0;
            repeat
                  begin
                       inc(z);
                    end;
                until  (z>=PCol^.max_index-1) or (PCol^.lib[z].id=main.player.playlist[i].id);
            if (z>0) and (PCol^.lib[z].id=main.player.playlist[i].id) and (PCol=main.player.playlist[i].collection) then begin
               main.player.Playlist[i].artist:=PCol^.lib[z].artist;
               main.player.Playlist[i].title:=PCol^.lib[z].title;
               main.player.Playlist[i].path:=PCol^.lib[z].path;
               main.playlist.Items[i-1].data:=@PCol^.lib[z];
               if PCol^.lib[z].title<>'' then main.playlist.Items[i-1].caption:=PCol^.lib[z].artist+' - '+PCol^.lib[z].title else main.playlist.Items[i-1].caption:=extractfilename(PCol^.lib[z].path);
             end;
         end;
       end;

     i:=Main.player.get_playlist_index;
     if Main.player.playlist[i].artist<>'' then Main.current_title_edit.text:=Main.player.playlist[i].artist else Main.current_title_edit.text:=ExtractFileName(Main.player.playlist[i].path);
        Main.current_title_edit1.text:=Main.player.playlist[i].title;
{        playwin.titleimg1.Picture.LoadFromFile(SKIN_DIR+'title.bmp');
        playwin.titleimg2.Picture.LoadFromFile(SKIN_DIR+'title.bmp');
        playwin.titleimg1.canvas.Font.Color:=Clnavy;
        playwin.titleimg2.canvas.Font.Color:=Clnavy;
        if Main.player.playlist[i].artist<>'' then playwin.titleimg1.canvas.textout(5,5,Main.player.playlist[i].artist) else playwin.titleimg1.canvas.textout(5,5,ExtractFileName(Main.player.playlist[i].path));
        playwin.titleimg2.canvas.textout(5,5,Main.player.playlist[i].title);}
     PCol:=@PlayerCol;
     if PCol^.max_index>1 then begin
       for i:= 1 to main.player.maxlistindex do begin
            z:=0;
            repeat
                  begin
                       inc(z);
                    end;
                until  (z>=PCol^.max_index-1) or (PCol^.lib[z].id=main.player.playlist[i].id);
            if (z>0) and (PCol^.lib[z].id=main.player.playlist[i].id) and (PCol=main.player.playlist[i].collection) then begin
               main.player.Playlist[i].artist:=Pcol^.lib[z].artist;
               main.player.Playlist[i].title:=PCol^.lib[z].title;
               main.player.Playlist[i].path:=Pcol^.lib[z].path;
               main.playlist.Items[i-1].data:=@PCol^.lib[z];
               if PCol^.lib[z].title<>'' then main.playlist.Items[i-1].caption:=PCol^.lib[z].artist+' - '+Pcol^.lib[z].title else main.playlist.Items[i-1].caption:=extractfilename(PCol^.lib[z].path);
             end;
       end;
     end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

initialization
  {$I mp3.lrs}

end.

