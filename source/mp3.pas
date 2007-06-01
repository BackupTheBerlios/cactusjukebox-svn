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
  ExtCtrls, ComCtrls, StdCtrls, Menus, fmodplayer,
  ActnList, mp3file, dos, SimpleIPC, functions, EditBtn, CheckLst, aws;
  
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
    CoverImage: TImage;
    Playlist: TListView;
    MenuItem6: TMenuItem;
    PlayButtonImg: TImage;
    PauseButtonImg: TImage;
    PreviousButtonImg: TImage;
    randomcheck: TCheckBox;
    Trackinfo: TSpeedButton;
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
    playtime: TEdit;
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
    volumebar: TTrackBar;
    procedure ArtistTreeClick(Sender: TObject);
    procedure ArtistTreeDblClick(Sender: TObject);
    procedure ArtistTreeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure ArtistTreeMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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
    procedure PlaylistCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
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
    procedure TitleTreeMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TitleTreeSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
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
    procedure playlistSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure playlistStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure playtimerStartTimer(Sender: TObject);
    procedure prevClick(Sender: TObject);
    procedure EditID3itemClick(Sender: TObject);
    procedure MenuItem30Click(Sender: TObject);
    procedure MenuItem33Click(Sender: TObject);
    procedure rm_artist_playeritemClick(Sender: TObject);
    procedure searchstrClick(Sender: TObject);
    procedure searchstrKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure skinmenuClick(Sender: TObject);
    procedure syncplayeritem(Sender: TObject);
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
    procedure titlelistmenuPopup(Sender: TObject);
    procedure toggle_playpause(Sender: TObject);
    procedure trackbarMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure trackbarMouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure undoSyncItemClick(Sender: TObject);
    procedure volumebarChange(Sender: TObject);
    
    //procedure fileopen(path:string);
    procedure loadskin(Sender: TObject);
    procedure update_player_hdd_relations;
  private
    { private declarations }
    Procedure MoveNode(TargetNode, SourceNode : TTreeNode);
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
    procedure update_player_display;
    function LoadFile(path: string):boolean;

    changetree, ctrl_pressed, SplitterResize:boolean;
    tsnode:TTreeNode;
    oldSplitterWidth, LoopCount: integer;
    sourceitem: TListItem;
    CoverFound: Boolean;
    awsclass: TAWSAccess;

  public
    procedure update_playlist;
    procedure disconnectDAP;
    function connectDAP:byte;
    playing, player_connected, playermode: boolean;
    playpos: integer;
    playnode: TTreeNode;
    playitem:TListitem;
    curlib:string;

    player: TFModPlayerclass;
    tempbitmap, timetmpbmp:TBitmap;
    player_freespace, player_totalspace:longint;

    skinmenuitems:array[1..16] of TMenuItem;
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
 
 Type

   { TSyncThread }

   TSyncAction = (SCopy, SDelete);

   TSyncThread = class(TThread)
   private
     procedure SyncStatus;
   protected
     procedure Execute; override;
     CopyList, TargetList, DeleteList: TStringList;
     DeletedCnt, DeleteTotal, CopyTotal, CopiedCnt: Integer;
     OpSuccess, finished: boolean;
     SAction: TSyncAction;
     TargetCollection: TMediaCollection;
   public
     Constructor Create(Suspd : boolean);
     destructor Destroy; override;
     procedure CopyFile( fromFile, toFile: string);
     procedure DeleteFile( path: string);
     Target: String;
   end;

 { TSyncThread }


var
  Main: TMain;
    const AUPLOAD = 3;
    const ANOTHING = -1;
    const AREMOVE = 2;
    const AONPLAYER = 1;
  
//procedure update_title_view_album;
procedure update_artist_view;
procedure update_title_view;
procedure artist_to_playlist;
procedure title_to_playlist;

//procedure album_to_playlist;



implementation
uses editid3, status, settings, player, directories, skin, cdrip, translations;

{$i cactus_const.inc}

var     sizediff: int64;
        SyncThread: TSyncThread;
        


{ TSyncThread }

procedure TSyncThread.SyncStatus;
begin
   if finished=false then begin
     if SAction=SCopy then Main.StatusBar1.Panels[1].Text:=IntToStr(CopiedCnt)+' of '+IntToStr(CopyTotal)+ ' copied. Don''t Disconnect...';
     if SAction=SDelete then Main.StatusBar1.Panels[1].Text:=IntToStr(DeletedCnt)+' of '+IntToStr(DeleteTotal)+' deleted. Don''t Disconnect...';
    end else begin
     writeln('finished');
    // TargetCollection.save_lib(TargetCollection.savepath);
     TargetCollection.Free;
     main.connectDAP;
     Main.StatusBar1.Panels[1].Text:='Synchronizing finished. Device Ready...';
   end;
end;

procedure TSyncThread.Execute;
var i: integer;
begin
    finished:=false;
    DeleteTotal:=DeleteList.Count;
    CopyTotal:=CopyList.Count;
    DeletedCnt:=0;
    CopiedCnt:=0;
    TargetCollection:=TMediacollection.create;
    TargetCollection.PathFmt:=FRelative;
    TargetCollection.rootpath:=CactusConfig.DAPPath;
    TargetCollection.load_lib(Target);
    while DeleteList.Count>0 do begin
           OpSuccess:=false;
         try

           sysutils.DeleteFile(self.DeleteList[0]);
           if not FileExists(self.DeleteList[0]) then TargetCollection.remove_entry(TargetCollection.get_index_by_path(self.DeleteList[0]));
           if DirectoryIsEmpty(ExtractFileDir(DeleteList[0])) then
                  RemoveDir(ExtractFileDir(DeleteList[0]))
          except end;
           inc(DeletedCnt);
           SAction:=SDelete;
           self.DeleteList.Delete(0);
           Synchronize(@SyncStatus);
    end;
    while CopyList.Count>0 do begin
            OpSuccess:=false;
            OpSuccess:=FileCopy(CopyList[0],TargetList[0]);
            inc(CopiedCnt);
            SAction:=SCopy;
            TargetCollection.add_file(TargetList[0]);
            CopyList.Delete(0);
            TargetList.Delete(0);
            Synchronize(@SyncStatus);
    end;

    Finished:=true;
    Synchronize(@SyncStatus);
end;

constructor TSyncThread.Create(Suspd: boolean);
begin
  inherited Create(suspd);
  FreeOnTerminate := True;
  CopyList:=TStringList.Create;
  TargetList:=TStringList.Create;
  DeleteList:=TStringList.Create;
  DeletedCnt:=0;
  CopiedCnt:=0;
end;

destructor TSyncThread.Destroy;
begin
  inherited Destroy;
  CopyList.Free;
  TargetList.Free;
  DeleteList.free;
end;

procedure TSyncThread.CopyFile(fromFile, toFile: string);
begin
  CopyList.Add(fromFile);
  TargetList.Add(toFile);

end;


procedure TSyncThread.DeleteFile(path: string);
begin
  DeleteList.Add(path);
end;
        

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
          CactusConfig.CurrentSkin:=caption;
       end;
     writeln('xxxxx');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.update_player_hdd_relations;
var i, z:integer;
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
Playercol.save_lib(CactusConfig.DAPPath+'cactuslib');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.loadlibClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'Mp3lib Library|*.mlb';
  OpenDialog1.InitialDir:=CactusConfig.HomeDir;
  OpenDialog1.FilterIndex := 1;
  if Opendialog1.execute=true then MediaCollection.load_lib(Main.Opendialog1.Filename);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.newlibClick(Sender: TObject);
begin
     Selectdirectorydialog1.initialdir:=CactusConfig.HomeDir;
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
var oldindex, err, i: integer;
begin
  playtimer.Enabled:=false;
  oldindex:=player.CurrentTrack;
  if randomcheck.Checked=false then err:=player.next_track else err:=player.play(player.Playlist.RandomIndex);
  if err=0 then begin
      i:=player.CurrentTrack;
      if i >= 0 then begin
          if oldindex>=0 then playlist.Items[oldindex].ImageIndex:=-1;
          playlist.Items[i].ImageIndex:=0;
          playtimer.Enabled:=true;
        end;
    end
     else stopClick(nil);
  update_player_display;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.prevClick(Sender: TObject);
var err:byte;
    i, OldTrack:integer;
begin
     playtimer.Enabled:=false;
     OldTrack:=player.CurrentTrack;
     err:=player.prev_track;
     if (err=0) then begin
          i:=player.CurrentTrack;
          if playlist.Items.Count>1 then begin
                     if OldTrack>=0 then playlist.Items[OldTrack].ImageIndex:=-1;
                     playlist.Items[i].ImageIndex:=0;
                 end;
          playtimer.Enabled:=true;
        end
          else stopClick(nil);
     update_player_display;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.playClick(Sender: TObject);
var err: byte;
    i: integer;
begin
    if (not player.paused) then  begin
         playtimer.Enabled:=false;
         if (Playlist.items.count>0) and (Playlist.Selected=nil)then playitem:=Playlist.Items[0]
           else playitem:=playlist.selected;
         if (player.playing) and (player.Playlist.Count>0) and (player.CurrentTrack<player.Playlist.Count) and (player.CurrentTrack>=0)
                 then playlist.Items[player.CurrentTrack].ImageIndex:=-1;;
         if playitem<>nil then begin
            err:=player.play(playitem.Index);
            if (err=0) then begin
                  playtimer.enabled:=true;
                  playitem.ImageIndex:=0;
                  update_player_display;
                end
             else begin
                  if (err=1) then Showmessage('File not Found! Goto Library/Rescan Directories for updating file links');
                  if (err=2) then Showmessage('Init of sound device failed.'+#10+#13+'Perhaps sound ressource is blocked by another application...');
                end;
            end;
       end
    else begin  //if player paused
           pauseClick(nil);
        end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.stopClick(Sender: TObject);
begin
    if (player.CurrentTrack>=0) and (player.CurrentTrack<player.Playlist.ItemCount) then playlist.Items[player.CurrentTrack].ImageIndex:=-1;
    player.stop;
    player.playlist.reset_random;
    update_player_display;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.playtimerTimer(Sender: TObject);
var spos, slength: real;
    r: real;
    x2:integer;
    fileobj: TMp3fileobj;
    PlaylistItem: TPlaylistItemClass;
    
begin
   spos:=0;
   slength:=0;
   try
   if player.playing then begin
     playtime.text:=player.get_timestr;
     playwin.TimeImg.Picture.LoadFromFile(SkinData.Time.Img);
     playwin.TimeImg.Canvas.Font.Color:=ClNavy;
     playwin.TimeImg.Canvas.TextOut(5,3, playtime.text);

     spos:=player.get_fileposition;
     slength:=player.get_filelength;
     r := ((spos*100) / slength);
     trackbar.position:= round(r);
     x2:=(trackbar.position*2)-3;
     if x2<3 then x2:=3;
     if (spos>=slength) {and (player.CurrentTrack<player.Playlist.ItemCount)} then nextclick(nil);
     if (CoverFound=false) and (LoopCount<20) then begin
                  inc(LoopCount);
                  if (assigned(awsclass)) and (awsclass.data_ready){  }then begin
                       fileobj:=TMp3fileobj(playlist.Items[player.CurrentTrack].Data);
                       if FileExists(fileobj.CoverPath) then begin
                          CoverImage.Picture.LoadFromFile(fileobj.CoverPath);
                          playwin.AlbumCoverImg.Picture.LoadFromFile(fileobj.CoverPath);
                         end;
                        CoverFound:=true;
                        FreeAndNil(awsclass);
                    end;
              end else if (LoopCount>=20) and (CoverFound=false) then CoverImage.Picture.Clear;
    end else playtimer.Enabled:=false;
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
    z : integer;
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
  SaveDialog1.Title:='Save Playlist...';
  saveDialog1.Filter := 'M3U Playlist|*.m3u';
  saveDialog1.DefaultExt := 'm3u';
  saveDialog1.FilterIndex := 1;
  SaveDialog1.InitialDir:=CactusConfig.HomeDir;
  if Savedialog1.execute=true then begin
         if FileExists(SaveDialog1.FileName) then
              if MessageDlg('File '+SaveDialog1.FileName+' alreday exists'+sLineBreak+sLineBreak+'Overwrite?', mtWarning, mbOKCancel, 0)=mrCancel then exit;
         player.playlist.SaveToFile(Savedialog1.Filename);
      end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.savelibClick(Sender: TObject);
begin
  SaveDialog1.Title:='Save Library...';
  saveDialog1.Filter := 'Mp3lib Library|*.mlb';
  saveDialog1.DefaultExt := 'mlb';
  saveDialog1.FilterIndex := 1;
  SaveDialog1.InitialDir:=CactusConfig.HomeDir;
   if Savedialog1.execute=true then MediaCollection.save_lib(Savedialog1.Filename);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.scanplayeritemClick(Sender: TObject);
var s, tmps:string;
    ScanCol: TMediacollection;
    z, i: integer;
begin
  if FileExists(CactusConfig.DAPPath)=false then begin ShowMessage(rsNotConnected);exit;end;

  If FileExists(CactusConfig.DAPPath) then begin
     checkmobile.Enabled:=false;
     disconnectDAP;
     ScanCol:=TMediacollection.create;
     Enabled:=false;
     ScanCol.add_directory(CactusConfig.DAPPath);
     ScanCol.rootpath:=CactusConfig.DAPPath;
     ScanCol.PathFmt:=FRelative;
     ScanCol.dirlist:=CactusConfig.DAPPath+';';
     ScanCol.savepath:=CactusConfig.DAPPath+'cactuslib';
     ScanCol.Free;
     Enabled:=true;
     connectDAP;
     checkmobile.Enabled:=true;
     tmps:=ByteToFmtString(FreeSpaceOnDAP, 3, 2);
     StatusBar1.Panels[1].Text:='Device connected     '+tmps+' Free';
   end
    else writeln(CactusConfig.DAPPath+' does not exist');
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
    i:integer;
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

procedure TMain.EditID3itemClick(Sender: TObject);
var tsitem:TListitem;
    PFobj: PMp3fileobj;
begin
  Main.enabled:=false;

  tsitem:=TitleTree.Selected;
  PFobj:=tsitem.data;
  editid3win.show_tags(PFobj,PFobj^.collection);
  EditID3win.Show;
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
     Panel1.Width:=Width-oldSplitterWidth-8;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem6Click(Sender: TObject);
var PFobj: PMp3fileobj;
    pcol: PMediaCollection;
    tsitem: TListitem;
    i:integer;
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

procedure TMain.PlaylistCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
// not working because font colors not implemented in Lazarus 0.9.23

  if (player.Playlist.Items[Item.Index].Played) and (player.CurrentTrack<>Item.Index) then
         Sender.Canvas.Font.Color:=clGrayText
       else
          Sender.Canvas.Font.Color:=clWindowText;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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

     if (MediaCollection.saved=false) and (MediaCollection.max_index<>1) then
          begin
             writeln('save lib');
             MediaCollection.save_lib(CactusConfig.ConfigPrefix+'lib'+DirectorySeparator+'last.mlb');
          end;
     MediaCollection.Free;
     PlayerCol.free;
     checkmobile.Enabled:=false;
     playtimer.Enabled:=false;


     player.free;

{     skinmenuitems[1].free;
     PlayButtonImg.free;
     StopButtonImg.free;
     NextButtonImg.free;
     PreviousButtonImg.free;
     PauseButtonImg.free;

     timetmpbmp.free;
     tempbitmap.Free;
     
     ImageList1.Free;   }
     CoverImage.Free;


     if playermode=false then begin
        playwin.close;
       // playwin.Free;
       end;
   try
     SimpleIPCServer1.StopServer;
     SimpleIPCServer1.free;
    except writeln('ERROR: Exception while shutting down IPC server');
    end;
  writeln('end.');
     if CactusConfig.FlushConfig then writeln('Config succesfully written to disk');
     CactusConfig.Free;
     Application.Terminate;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MainCreate(Sender: TObject);
var tmps1, tmps2: string;
begin

  Caption:='Cactus Jukebox '+CACTUS_VERSION;



  TranslateUnitResourceStrings('mp3', CactusConfig.DataPrefix+'languages'+DirectorySeparator+'cactus.%s.po', CactusConfig.language, '');
  if SystemCharSetIsUTF8 then writeln('##System charset is UTF8');
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
  player.oss:=not CactusConfig.OutputAlsa;

  player_connected:=false;
  try
  write('loading program icon...  ');
  Icon.LoadFromFile(CactusConfig.DataPrefix+'icon'+DirectorySeparator+'cactus-icon.ico');
//  CoverImage.Picture.LoadFromFile(DataPrefix+'tools'+DirectorySeparator+'cactus-logo-small.png');
  writeln('... loaded');
  except
        writeln('ERROR loading bitmaps, files not found');
  end;

  
  
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

  checkmobile.Enabled:=true;

  // unused ??
  main.tempbitmap:=TBitmap.Create;
  main.timetmpbmp:=TBitmap.Create;
  main.tempbitmap.width:=300;
  main.tempbitmap.Height:=150;
  // ------

  if FileExists(CactusConfig.LastLib) then begin
     main.StatusBar1.Panels[0].Text:='Loading last library...';
     if Mediacollection.load_lib(CactusConfig.LastLib)<>0 then begin
           MediaCollection.clear;
           ShowMessage('ERROR while reading last library. You need to create a new one.'+LineEnding+'Please choose a directory to scan for mediafiles...');
           newlibClick(nil);
        end;
   end;

  // Load file specified on commandline
  if CactusConfig.LoadOnStart<>'' then begin
       LoadFile(CactusConfig.LoadOnStart);
    end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.ApplicationIdle(Sender: TObject; var Done: Boolean);
var pmp3obj: pMp3fileobj;
    templistitem: TListitem;
    fpath: string;
    i:integer;
begin

if SimpleIPCServer1.PeekMessage(1,True) then begin
  fpath:=copy(SimpleIPCServer1.StringMessage, 4, length(SimpleIPCServer1.StringMessage));
  writeln(fpath);
  if (pos(inttostr(OPEN_FILE), SimpleIPCServer1.StringMessage)=1) and FileExists(fpath) then begin
        LoadFile(fpath);
        playClick(nil);
        exit;
   end
    else writeln(' --> Invalid message/filename received via IPC');
  if (pos(inttostr(ENQUEU_FILE), SimpleIPCServer1.StringMessage)=1) and FileExists(fpath) then begin
        LoadFile(fpath);
        exit;
   end
    else writeln(' --> Invalid message/filename received via IPC');
  case byte(StrToInt(SimpleIPCServer1.StringMessage)) of
     VOLUME_UP: if volumebar.Position>4 then  volumebar.Position:=volumebar.Position-5;
     VOLUME_DOWN: if volumebar.Position<46 then volumebar.Position:=volumebar.Position+5;
     NEXT_TRACK: nextClick(nil);
     STOP_PLAYING: stopClick(nil);
     START_PLAYING: playClick(nil);
     PREV_TRACK: prevClick(nil);
     PAUSE_PLAYING: pauseClick(nil);
   else writeln(' --> Invalid message/filename received via IPC');
  end;
end;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.update_player_display;
var pfileobj: PMp3fileobj;
    PPlaylistItem: PPlaylistItemClass;
    i: integer;
begin
   if player.playing then begin
      i:=player.CurrentTrack;
      pfileobj:=playlist.Items[player.CurrentTrack].Data;
      
      if player.Playlist.items[i].artist<>'' then current_title_edit.text:=player.Playlist.items[i].artist else current_title_edit.text:=ExtractFileName(player.Playlist.items[i].path);
      current_title_edit1.text:=player.Playlist.items[i].title;

      playwin.TitleImg.Picture.LoadFromFile(SkinData.Title.Img);
      playwin.TitleImg.canvas.Font.Color:=Clnavy;

      if player.Playlist.items[i].artist<>'' then playwin.TitleImg.canvas.textout(5,5,player.Playlist.items[i].artist) else playwin.TitleImg.canvas.textout(5,5,ExtractFileName(player.Playlist.items[i].path));
      playwin.TitleImg.canvas.textout(5,25,player.Playlist.items[i].title);
    end else begin  //clear everything
      playwin.TitleImg.canvas.Clear;
      CoverImage.Picture.Clear;
      playwin.TimeImg.Canvas.Clear;
      current_title_edit.Text:='';
      current_title_edit1.Text:='';
      playtime.Text:='00:00';
      trackbar.Position:=0;
    end;
end;

function TMain.LoadFile(path: string): boolean;
var z: integer;
    listitem: TListItem;
begin
 if FileExists(path) then begin
   z:=MediaCollection.get_index_by_path(path);
   if z=0 then begin
      MediaCollection.add_file(path);
      MediaCollection.sort;
      z:=MediaCollection.get_index_by_path(path);
   end;
   
   player.playlist.add(@MediaCollection.lib[z]);

   ListItem := Playlist.Items.Add;
   listitem.data:=MediaCollection.lib[z];

   if MediaCollection.lib[z].title<>'' then ListItem.Caption:=MediaCollection.lib[z].artist+' - '+MediaCollection.lib[z].title else ListItem.Caption:=extractfilename(MediaCollection.lib[z].path);
   playlist.Column[0].Caption:='Playlist                       ('+IntToStr(player.playlist.ItemCount)+' Files/ '+player.Playlist.TotalPlayTimeStr +')';
   result:=true;
   update_artist_view;
   update_title_view;
  end else result:=false
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem11Click(Sender: TObject);
var Listitem:TListItem;
    tmps: string;
    i:integer;
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
    s, tmps : string;
    PFobj: PMp3fileobj;
    i:integer;
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
     
     tmps:=ByteToFmtString(FreeSpaceOnDAP + sizediff, 3, 2);
     
     StatusBar1.Panels[1].Text:='Device connected     '+tmps+' Free';
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem16Click(Sender: TObject);
var tsitem: TListItem;
    tmps: string;
    pfobj: PMp3fileobj;
begin
  tsitem:=TitleTree.Selected;
  if (tsitem<>nil) and player_connected then begin
     PFobj:=tsitem.data;
     PFobj^.action:=AUPLOAD;

     update_artist_view;
     update_title_view;

     tmps:=ByteToFmtString(FreeSpaceOnDAP + sizediff, 3, 2);
     StatusBar1.Panels[1].Text:='Device connected     '+tmps+' Free';
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem19Click(Sender: TObject);
var z:int64;
    s, tmps, used:string;
    i:integer;
begin
  if player_connected then begin
     z:=0;
     for i:= 1 to PlayerCol.max_index-1 do z:=z+PlayerCol.lib[i].size;

     used:=ByteToFmtString(z, 4, 2);

     tmps:=ByteToFmtString(FreeSpaceOnDAP, 4 , 2);
     str(PlayerCol.max_index-1, s);
     
     ShowMessage(s+' Files on mobile player    '+#10+used+' of music'+#10+'Free Disk Space: '+tmps);
   end else ShowMessage(rsNotConnected);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem20Click(Sender: TObject);
var tsitem: TListItem;
    pfobj: PMp3fileobj;
    tmps: string;
    i:integer;
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

      tmps:=ByteToFmtString(FreeSpaceOnDAP + sizediff, 3, 2);
      StatusBar1.Panels[1].Text:='Device connected     '+tmps+' Free';
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem26Click(Sender: TObject);
begin
{$ifdef win32}
  ShowMessage('Cactus Jukebox'+LineEnding+'version 0.3 unstable'+LineEnding+'This windows version is in alpha state and not fully functional   '+LineEnding+'written by Sebastian Kraft '+LineEnding+LineEnding+'(c) 2006'+LineEnding+'http://cactus.hey-you-freaks.de     ');
{$endif win32}
{$ifdef linux}
  ShowMessage('Cactus Jukebox'+LineEnding+'version'+CACTUS_VERSION+LineEnding+'written by Sebastian Kraft '+LineEnding+LineEnding+'(c) 2005-2007'+LineEnding+'http://cactus.hey-you-freaks.de     ');
{$endif linux}
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem27Click(Sender: TObject);
var id, i:longint;
    listitem:TListitem;
begin
  OpenDialog1.Filter := 'M3U Playlist|*.m3u|All Files|*.*';
  OpenDialog1.InitialDir:=CactusConfig.HomeDir;
 // DoDirSeparators(OpenDialog1.InitialDir);
  //OpenDialog1.DefaultExt := 'mlb';
  OpenDialog1.FilterIndex := 1;
  if Opendialog1.execute=true then begin
     playlist.Clear;
     player.Playlist.clear;
     player.Playlist.LoadFromFile(Opendialog1.Filename);
     for id:= 0 to player.Playlist.Count-1 do begin
            ListItem := Playlist.Items.Add;
            listitem.Data:=TMp3fileobj.index_file(player.Playlist.Items[id].path);
            ListItem.Caption:=player.Playlist.items[id].Artist+' - '+player.Playlist.Items[id].Title;
         end;

   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem2Click(Sender: TObject);
var n, z, i:integer;
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

       Main.player.playlist.add(pfobj);
       
       ListItem := Main.Playlist.Items.Add;
       listitem.data:=pfobj;
       if pfobj^.title<>'' then ListItem.Caption:=pfobj^.artist+' - '+pfobj^.title else ListItem.Caption:=extractfilename(pfobj^.path);


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
   s1:=IntToStr((main.player.playlist.TotalPlayTime div 60) mod 60 );
   s2:=IntToStr((main.player.playlist.TotalPlayTime div 60) div 60 );
   main.playlist.Column[0].Caption:='Playlist            ('+IntToStr(main.player.playlist.ItemCount)+' Files/ '+s2+'h '+s1+'min )';
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem37Click(Sender: TObject);
var Pcol: PMediaCollection;
    curartist, curalbum, s, tmps: string;
    pfobj: PMp3fileobj;
    i:integer;
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

      tmps:=ByteToFmtString(FreeSpaceOnDAP + sizediff, 3, 2);
      StatusBar1.Panels[1].Text:='Device connected     '+tmps+' Free';
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

procedure TMain.TitleTreeMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // ensure that the popup menu is only opened when an item is selected
  // the menu is reanabled in TMain.TitleTreeSelectItem
  if (Button = mbRight) and (TitleTree.Selected = nil) then
    TitleTree.PopupMenu.AutoPopup := false;
end;

procedure TMain.TitleTreeSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  // reanable the popupmenu in case ist was disabled in TMain.TitleTreeMouseDown
  TitleTree.PopupMenu.AutoPopup := true;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.TrackInfoClick(Sender: TObject);
begin
       if (player.CurrentTrack)>=0 then begin
         playlist.selected:=main.playlist.Items[main.player.CurrentTrack];
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
    tmps: string;

begin
     if (player_connected=false) and FileExists(CactusConfig.DAPPath+'cactuslib') then begin
         write('DAP detected...');
         if connectDAP=0 then begin
            tmps:=GetCurrentDir;                             // get free memory on player, format string
            writeln('loaded');
            tmps:= ByteToFmtString(FreeSpaceOnDAP, 3, 2);
            StatusBar1.Panels[1].Text:='Device connected     '+tmps+' Free';
            if CactusConfig.background_scan then begin
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

     Application.ProcessMessages;
     if (player_connected=true) and (FileExists(CactusConfig.DAPPath+'cactuslib')=false) then begin
          disconnectDAP;
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
    PPlaylistItem: PPlaylistItemClass;
    z:integer;
    tmps: string;
begin
    Main.enabled:=false;

    Listitem:=playlist.Selected;
    if listitem<>nil then begin
       PFobj:=@TMp3fileobj(Listitem.Data);
       editid3win.show_tags(PFobj, nil);
     end;
//     else begin
 {       writeln('File not in Library');
        PPlaylistItem:=PPlaylistItemClass(player.Playlist.items[listitem.index]);
        mp3fileobj:=TMp3fileobj.index_file(PPlaylistItem^.Path);
        editid3win.artist_only:=false;
        editid3win.album_only:=false;
        editid3win.pathedit1.text:=mp3fileobj.path;
        editid3win.artistedit1.text:=mp3fileobj.artist;
        editid3win.titleedit1.text:=mp3fileobj.title;
        editid3win.albumedit1.text:=mp3fileobj.album;
        editid3win.commentedit1.text:=mp3fileobj.comment;
        editid3win.yearedit1.text:=mp3fileobj.year;
  }
{        editid3win.artistedit2.text:=mp3fileobj.artistv2;
        editid3win.titleedit2.text:=mp3fileobj.titlev2;
        editid3win.albumedit2.text:=mp3fileobj.albumv2;
        editid3win.yearedit2.text:=mp3fileobj.yearv2;
        editid3win.trackedit2.text:=mp3fileobj.trackv2;}
{        if mp3fileobj.filetype='.mp3' then editid3win.Filelogo.Picture.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'mp3_64.png');
        if mp3fileobj.filetype='.ogg' then editid3win.Filelogo.Picture.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'ogg_64.png');
        if mp3fileobj.filetype='.wav' then editid3win.Filelogo.Picture.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'wav_64.png');
        editid3win.metacontrol.ActivePage:=editid3win.metatab;
        editid3win.id3v1tab.TabVisible:=false;
        editid3win.id3v2tab.TabVisible:=false;
        EditID3win.pfileobj:=@mp3fileobj;
     end;
    end; }
    EditID3win.Show;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.clear_listClick(Sender: TObject);
begin
      Playlist.BeginUpdate;
      Playlist.Items.Clear;
      playlist.Column[0].Caption:= 'Playlist';
      player.playlist.clear;
      Playlist.EndUpdate;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.filetypeboxChange(Sender: TObject);
begin
     srch_buttonClick(nil);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.libinfoClick(Sender: TObject);
var z: int64;
    s, used:string;
    i:integer;
begin
     z:=0;
     for i:= 1 to MediaCollection.max_index-1 do z:=z+MediaCollection.lib[i].size;

     used:=ByteToFmtString(z, 3, 2);
     ShowMessage(s+' Files in library '+#10+' '+used+' of music files');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.muteClick(Sender: TObject);
begin
  player.mute;
  if player.muted then mute.Glyph.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'mute1.xpm') else mute.Glyph.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'mute2.xpm');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.openfileClick(Sender: TObject);
var mp3obj: TMp3fileobj;
    templistitem: TListItem;
    i:integer;
begin
     OpenDialog1.Filter := 'All supported audio|*.wav;*.mp3;*.ogg|MP3|*.mp3|OGG|*.ogg|WAV|*.wav';
     OpenDialog1.InitialDir:=CactusConfig.HomeDir;
     OpenDialog1.FilterIndex := 1;
     if Opendialog1.execute=true then begin
        LoadFile(Opendialog1.Filename);

{        mp3obj:=TMp3FileObj.index_file();
        player.playlist.add(@mp3obj);

        tempListItem := Playlist.Items.Add;
        templistitem.data:=mp3obj;

        if Mp3obj.artist<>'' then tempListitem.caption:=Mp3obj.artist+' - '+Mp3obj.title else tempListitem.caption:=ExtractFileName(mp3obj.path);
        playlist.Selected:=templistitem;
        playClick(nil);}
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
    i:integer;
begin
  write('Playlist keypress event: Keycode ');writeln(key);
  case key of

    // Key Ctrl
       17: ctrl_pressed:=true;

    // Key UP
       38: if playlist.Selected.Index>0 then begin
              i:=playlist.Selected.Index;
              writeln(i);
              if ctrl_pressed then begin
                   tempitem:=playlist.selected;
                   player.playlist.move(i, i-1);
                   playlist.items[i]:=playlist.items[i-1];
                   playlist.items[i-1]:=tempitem;
                   Playlist.SetFocus;
                   playlist.items[i].Selected:=false;
                   playlist.items[i-1].Selected:=true;
                   writeln(player.CurrentTrack);
                   //tempitem.MakeVisible(true);
                 end;
              writeln(playlist.Selected.Index);
            end;

    // Key DOWN
       40:  if playlist.Selected.Index<playlist.items.Count-1 then begin
              i:=playlist.Selected.Index;
              writeln(i);
              if ctrl_pressed then begin
                   tempitem:=playlist.selected;
                   player.playlist.move(i,i+1);
                   playlist.items[i]:=playlist.items[i+1];
                   playlist.items[i+1]:=tempitem;
                   Playlist.SetFocus;
                   playlist.items[i].Selected:=false;
                   playlist.items[i+1].Selected:=true;
                   writeln(player.CurrentTrack);
                   //tempitem.MakeVisible(true);
               end;
              writeln(playlist.Selected.Index);
            end;
     // Key Del
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
var tempitem: TListItem;
begin
  // ensure that the popup menu is only opened when an item is selected
  // the menu is reanabled in TMain.playlistSelectItem
  if (Button = mbRight) and (playlist.Selected = nil) then
    playlist.PopupMenu.AutoPopup := false;
end;

procedure TMain.playlistSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  // reanable the popupmenu in case ist was disabled in TMain.playlistMouseDown
  playlist.PopupMenu.AutoPopup := true;
end;

procedure TMain.playlistStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  sourceitem:=playlist.Selected;
  writeln(sourceitem.Caption);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.playtimerStartTimer(Sender: TObject);
var fileobj: TMp3fileobj;
    PPlaylistItem: PPlaylistItemClass;
    i: integer;
begin
  CoverFound:=false;
  LoopCount:=0;
  i:=player.CurrentTrack;
  fileobj:=TMp3fileobj(playlist.Items[player.CurrentTrack].Data);
  if (fileobj.album<>'') then begin
     fileobj.CoverPath:=CactusConfig.ConfigPrefix+DirectorySeparator+'covercache'+DirectorySeparator+fileobj.artist+'_'+fileobj.album+'.jpeg';
     if (FileExists(fileobj.CoverPath)=false) then begin
             CoverImage.Picture.Clear;
             if  (CactusConfig.CoverDownload) then begin
                  awsclass:=TAWSAccess.CreateRequest(fileobj.artist, fileobj.album);
                  awsclass.AlbumCoverToFile(fileobj.CoverPath);
               end;
        end else begin
             CoverImage.Picture.LoadFromFile(fileobj.CoverPath);
             playwin.AlbumCoverImg.Picture.LoadFromFile(fileobj.CoverPath);
             CoverFound:=true;
        end;
    end else CoverImage.Picture.Clear;//CoverImage.Picture.LoadFromFile(DataPrefix+'tools'+DirectorySeparator+'cactus-logo-small.png');
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
 // if ArtistTree.Selected<>nil then update_title_view;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.ArtistTreeKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var b: byte;
    c:char;
    i: integer;
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

procedure TMain.ArtistTreeMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ArtistTree.SetFocus;
 // ensure that the popup menu is only opened when an item is selected
 if Button = mbRight then
    if ArtistTree.GetNodeAt(X, Y) = nil then
        ArtistTree.PopupMenu.AutoPopup := false
    else
        ArtistTree.PopupMenu.AutoPopup := true;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem30Click(Sender: TObject);
var PCol: PMediaCollection;
    curartist, curalbum, tmps: string;
    tmpsize: int64;
    pfobj: PMp3fileobj;
    i:integer;
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

      tmps:=ByteToFmtString(FreeSpaceOnDAP + sizediff, 3, 2);
      StatusBar1.Panels[1].Text:='Device connected     '+tmps+' Free';
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem33Click(Sender: TObject);
var PFobj: PMp3fileobj;
begin
  Main.enabled:=false;

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
  EditID3win.Show;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.rm_artist_playeritemClick(Sender: TObject);
var PCol: PMediaCollection;
    curartist, curalbum, tmps: string;
    pfobj: PMp3fileobj;
    i, z:integer;
begin
   tsnode:=ArtistTree.Selected;
   if (tsnode<>nil) and (tsnode.level>0) and player_connected then begin
      PFobj:=tsnode.data;
      i:=PFobj^.index;
      Pcol:=PFobj^.collection;
      curartist:=lowercase(pfobj^.artist);
      repeat dec(i)
         until (lowercase(PCol^.lib[i].artist)<>curartist) or (i=0);
      inc(i);
      if tsnode.level=2 then   //remove one album
           begin
                curalbum:=lowercase(pfobj^.album);
                repeat begin
                      if (PCol^.lib[i].action=AONPLAYER) and (lowercase(PCol^.lib[i].album)=curalbum) then
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
      if tsnode.level=1 then      //remove the artist
           begin
                repeat begin
                       if PCol^.lib[i].action=AONPLAYER then
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
      
      tmps:=ByteToFmtString(FreeSpaceOnDAP + sizediff, 3, 2);
      StatusBar1.Panels[1].Text:='Device connected     '+tmps+' Free';
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.searchstrClick(Sender: TObject);
begin
  ArtistSrchField.Hide;
end;

procedure TMain.searchstrKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

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
    StatusBar1.Panels[1].Text:='Calculating...';
    rcount:=1;
    ucount:=1;
    bytesneeded:=0;       //Calculation the disk space that has to be available on player
    SyncThread:=TSyncThread.Create(true);
    SyncThread.Target:=PlayerCol.savepath;
    Enabled:=false;
    for n:= 1 to MediaCollection.max_index-1 do begin   //search for uploads in mediacollection
            if MediaCollection.lib[n].action=AUPLOAD then begin
                       inc(ucount);
                       bytesneeded:=bytesneeded + MediaCollection.lib[n].size;
                       if CactusConfig.mobile_subfolders then begin
                           if not DirectoryExists(CactusConfig.DAPPath+lowercase(MediaCollection.lib[n].artist)) then mkdir(CactusConfig.DAPPath+lowercase(MediaCollection.lib[n].artist));
                           newfile:=CactusConfig.DAPPath+lowercase(MediaCollection.lib[n].artist)+'/'+ExtractFileName(MediaCollection.lib[n].path);
                         end
                         else
                           newfile:=CactusConfig.DAPPath+ExtractFileName(MediaCollection.lib[n].path);
                       DoDirSeparators(newfile);
                       SyncThread.copyFile(MediaCollection.lib[n].path, newfile);
                end;
        end;
    for n:= 1 to PlayerCol.max_index-1 do begin    //find files to be deleted in playercollection
            if PlayerCol.lib[n].action=AREMOVE then begin
                      inc(rcount);
                      bytesneeded:=bytesneeded - PlayerCol.lib[n].size;
                      SyncThread.deleteFile(PlayerCol.lib[n].path);
                      writeln(PlayerCol.lib[n].path+' to be deleted');  //Debug
               end;
      end;
    Enabled:=true;

    if FreeSpaceOnDAP < bytesneeded then begin   //Check if there is enough free disk space on player
       ShowMessage('ERROR: Not enough free disk space on mobile device!');
       StatusBar1.Panels[1].Text:='Ready';
       SyncThread.Free;
       exit; //Free thread and exit
     end;

    checkmobile.Enabled:=false;
    disconnectDAP;
    
    StatusBar1.Panels[1].Text:='Please Wait...';
    SyncThread.Resume;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem3Click(Sender: TObject);
var s1, s2: string;
    i:integer;
begin
    if playlist.selected<>nil then begin
      i:=playlist.selected.index;
      player.playlist.remove(i);
      Playlist.Selected.delete;
      s1:=IntToStr((player.Playlist.TotalPlayTime div 60) mod 60 );
      s2:=IntToStr((player.Playlist.TotalPlayTime div 60) div 60 );
      playlist.Column[0].Caption:='Playlist            ('+IntToStr(player.Playlist.ItemCount)+' Files/ '+s2+'h '+s1+'min )';
      if (i>=1) and (i=playlist.items.count) then dec(i);
      playlist.selected:=playlist.items[i];
    end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.Menuitem22Click(Sender: TObject);
begin
    setupwin:=Tsettings.create(nil);

    setupwin.ShowModal;
    setupwin.Release;
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
    i:integer;
begin
  k:=trackbar.position;
  slength:=player.get_filelength;
  spos:=round((k*slength) / (100));
  i:=round(spos);
  player.set_fileposition(i);
  if player.playing then playtimer.enabled:=true;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.undoSyncItemClick(Sender: TObject);
var tmps:string;
    i:integer;
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

  tmps:=ByteToFmtString(FreeSpaceOnDAP, 3, 2);
  StatusBar1.Panels[1].Text:='Device connected     '+tmps+' Free';
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.volumebarChange(Sender: TObject);
begin
  player.set_volume((50-volumebar.Position)*2);
  writeln('volume set '+ IntToStr(player.volume));
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

{ currently unused, can be removed next time

procedure TMain.fileopen(path: string);
var mp3obj: TMp3fileobj;
    templistitem: TListItem;
    i:integer;
begin
        mp3obj:=TMp3FileObj.index_file(path);
        writeln('file '+path+' indexed');
        i:=player.playlist.add(qmp3obj);
        player.playlist[i].artist:=Mp3obj.artist;
        player.playlist[i].title:=Mp3obj.title;
        tempListItem := Playlist.Items.Add;
        templistitem.data:=nil;

        if Mp3obj.artist<>'' then tempListitem.caption:=Mp3obj.artist+' - '+Mp3obj.title else tempListitem.caption:=ExtractFileName(mp3obj.path);
        playClick(nil);
        mp3obj.destroy;
end;
}

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
    pfobj: PMp3fileobj;
    z, i:integer;
begin
   tsnode:=main.TitleTree.Selected;

   if (tsnode<>nil) and (tsnode.ImageIndex<>4) then begin
     PFobj:=tsnode.data;
     PCol:=PFobj^.collection;
     z:= PFobj^.index;
     Main.player.playlist.add(pfobj);

     ListItem := Main.Playlist.Items.Add;
     listitem.data:=PCol^.lib[z];

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
                   

   main.playlist.Column[0].Caption:='Playlist                       ('+IntToStr(main.player.playlist.ItemCount)+' Files/ '+main.player.Playlist.TotalPlayTimeStr +')';
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure artist_to_playlist;
var tempnode, tsnode:TTreeNode;
    curartist, curalbum: string;
    Listitem:TListitem;
    album_mode:boolean;
    PCol: PMediaCollection;
    pfobj: PMp3fileobj;
    ext: boolean;
    z, i:integer;
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

       Main.player.playlist.add(@PCol^.lib[z]);

       ListItem := Main.Playlist.Items.Add;
       listitem.data:=PCol^.lib[z];
       if PCol^.lib[z].title<>'' then ListItem.Caption:=PCol^.lib[z].artist+' - '+PCol^.lib[z].title else ListItem.Caption:=extractfilename(PCol^.lib[z].path);
       end;
      inc(z);
      if z<PCol^.max_index then if curartist=lowercase(PCol^.lib[z].artist) then else ext:=true;
      end;
      until (z>PCol^.max_index-1) or (ext=true);
     end;

   main.playlist.Column[0].Caption:='Playlist            ('+IntToStr(main.player.playlist.ItemCount)+' Files/ '+main.player.Playlist.TotalPlayTimeStr+' )';
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
    z, i:integer;
begin
     tsnode:=Main.ArtistTree.Selected;
     main.StatusBar1.Panels[0].Text:='Please wait... updating...';
     
    writeln;
    write('## update title view...');


    Main.TitleTree.Items.Clear;
    Main.TitleTree.BeginUpdate;
    write(' cleared items... ');

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

     writeln(' finished title view ##');
     Main.TitleTree.EndUpdate;
     main.StatusBar1.Panels[0].Text:='Ready.';

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure update_artist_view;
var existing, curartist, tmps2, tmps:string;
    tsnode, artnode, localnode, playernode, cdnode:Ttreenode;
    PCol, CurCol: PMediaCollection;
    AlbumList:TStringList;
    PFobj2: PMp3fileobj;
    pfobj: PMp3fileobj;
    i:integer;
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
          CurCol:=pfobj^.collection;
          curartist:=lowercase(pfobj^.artist);
       end else begin
           curartist:='';
         end;
     write(' clear trees...');
     Main.ArtistTree.Items.Clear;

     existing:='';
     localnode:=Main.ArtistTree.Items.Add(nil, 'Local Harddisk');
     localnode.ImageIndex:=6;
     localnode.SelectedIndex:=6;
     localnode.data:=pointer(1);
{Sorting}
     write(' sorting... ');
     MediaCollection.sort;
     write(' sorted... ');
     AlbumList:=TStringList.Create;
     for i:=1 to (MediaCollection.max_index-1) do begin
        MediaCollection.lib[i].index:=i;
        if MediaCollection.lib[i].artist<>'' then tmps:=MediaCollection.lib[i].artist else tmps:='Unknown';
        if lowercase(existing)<>lowercase(tmps) then begin
           AlbumList.Clear;
           existing:=tmps;
           artnode:=Main.ArtistTree.Items.AddChild(localnode, tmps);
           with artnode do
             begin
               MakeVisible;
               ImageIndex:=-1;
               Data:=@MediaCollection.lib[i];
             end;
            artnode.expand(false);
          end;
        case MediaCollection.lib[i].action of  //set the right Icon
               1: if (artnode.ImageIndex=-1) then artnode.ImageIndex:=1;
               2: artnode.ImageIndex:=2;
               3: artnode.ImageIndex:=3;
             end;
        artnode.SelectedIndex:=artnode.ImageIndex;
        
        if MediaCollection.lib[i].album<>'' then tmps2:=MediaCollection.lib[i].album else tmps2:='Unknown';

        if AlbumList.IndexOf(tmps2+':')=-1 then begin
           AlbumList.Add(tmps2+':');
           with Main.ArtistTree.Items.Addchild(artnode,tmps2) do
             begin
               MakeVisible;
               ImageIndex:=-1;
               SelectedIndex:=-1;
               Data:=@MediaCollection.lib[i];
             end;
            artnode.expanded:=(false);
          end;
     end;
     existing:='';
     playernode:=Main.ArtistTree.Items.Add(nil, 'Mobile Player');
     playernode.SelectedIndex:=1;
     playernode.ImageIndex:=1;
     playernode.data:=pointer(0);
   if Main.player_connected then begin
     write(' mobile collection...');
     PCol:=@PlayerCol;
     Pcol^.sort;
     AlbumList.Clear;
     for i:=1 to (PCol^.max_index-1) do begin
        PCol^.lib[i].index:=i;
        if PCol^.lib[i].artist<>'' then tmps:=PCol^.lib[i].artist else tmps:='Unknown';
        if lowercase(existing)<>lowercase(tmps) then begin
           AlbumList.clear;
           existing:=tmps;
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
        case PCol^.lib[i].action of  //set the right Icon
               1: if (artnode.ImageIndex=-1) then artnode.ImageIndex:=1;
               2: artnode.ImageIndex:=2;
               3: artnode.ImageIndex:=3;
             end;
        artnode.SelectedIndex:=artnode.ImageIndex;

        if PCol^.lib[i].album<>'' then tmps2:=PCol^.lib[i].album else tmps2:='Unknown';
        if AlbumList.IndexOf(tmps2+':')=-1 then begin
           AlbumList.Add(tmps2+':');
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
     end;

     i:=0;
     if curartist<>'' then begin
     repeat begin
            repeat inc(i) until (main.ArtistTree.items[i].Level=1) or (i>=main.ArtistTree.Items.Count-1);
            pfobj2:=main.ArtistTree.items[i].data;
         end;
     until ((lowercase(main.artisttree.items[i].text)=curartist) and (pfobj2^.collection=CurCol)) or (i>=main.artisttree.items.count-1);
     end;
     if lowercase(main.artisttree.items[i].text)=curartist then begin
            main.artisttree.selected:=main.artisttree.items[i];
            if i >=10 then begin
                main.ArtistTree.TopItem:=main.artisttree.items[i-10].Parent;
              end
            else main.ArtistTree.TopItem:=main.artisttree.items[0];

       end else main.artisttree.selected:=main.artisttree.items[1];
     AlbumList.Free;
     main.artisttree.endupdate;
     main.changetree:=false;
     writeln(' finished artistview##');
     main.StatusBar1.Panels[0].Text:='Ready.';
     main.Enabled:=true;
     main.ArtistTree.Enabled:=true;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.update_playlist;
var    PPlaylistItem: PPlaylistItemClass;
       fobj: TMp3fileobj;
       i:integer;
begin

     for i:= 0 to player.Playlist.ItemCount-1 do begin
          fobj:=TMp3fileobj(playlist.Items[i].Data);
          player.Playlist.Items[i].update(@fobj);
          if fobj.title<>'' then
              playlist.Items[i].caption:=fobj.artist+' - '+fobj.title
            else
              playlist.Items[i].caption:=extractfilename(fobj.path);
     end;

   {  if PCol^.max_index>1 then begin
        for i:= 1 to main.player.Playlist.ItemCount begin
            Pfobj:= PCol^.get_entry_by_id(player.Playlist[i].id);
            if pfobj<>nil then begin
               player.Playlist[i].artist:=Pfobj^.artist;
               player.Playlist[i].title:=Pfobj^.title;
               player.Playlist[i].path:=Pfobj^.path;

             end;
         end;
       end;
   if player_connected then begin
     PCol:=@PlayerCol;
     if PCol^.max_index>1 then begin
        for i:= 1 to main.player.maxlistindex do begin
            Pfobj:= PCol^.get_entry_by_id(player.Playlist[i].id);
            if pfobj<>nil then begin
               player.Playlist[i].artist:=Pfobj^.artist;
               player.Playlist[i].title:=Pfobj^.title;
               player.Playlist[i].path:=Pfobj^.path;
               playlist.Items[i-1].data:=Pfobj;
               if Pfobj^.title<>'' then playlist.Items[i-1].caption:=Pfobj^.artist+' - '+Pfobj^.title else playlist.Items[i-1].caption:=extractfilename(Pfobj^.path);
             end;
         end;
       end;
   end;                     }
     update_player_display;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.disconnectDAP;
var i : integer;
    PPlaylistItem: PPlaylistItemClass;
begin
    writeln('### Disconnect DAP ###');
    Enabled:=false;
    i:=0;
    while i < playlist.Items.Count do begin
         if PMp3fileobj(playlist.Items[i].Data)^.collection=@PlayerCol then begin
            Player.playlist.remove(i);
            if player.Playlist.ItemCount<>0 then Playlist.Items[i].Delete;
            dec(i);
          end;
      inc(i);
    end;
    FreeAndNil(PlayerCol);
    player_connected:=false;
    for i:= 1 to MediaCollection.max_index-1 do MediaCollection.lib[i].action:=-1;
    ArtistTree.Selected:=nil;
    Enabled:=true;
    update_artist_view;
    update_title_view;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMain.connectDAP:byte;
var i, z:integer;
begin
       Result:=255;
       PlayerCol:=TMediacollection.create;
       PlayerCol.PathFmt:=FRelative;
       PlayerCol.rootpath:=CactusConfig.DAPPath;
       writeln('### ConnectDAP  ###');
       if PlayerCol.load_lib(CactusConfig.DAPPath+'cactuslib')=0 then begin
              PlayerCol.dirlist:=CactusConfig.DAPPath+';';
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
            player_connected:=true;
            update_artist_view;
            update_title_view;
            checkmobile.Enabled:=true;
            result:=0;
       end else freeandnil(PlayerCol);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


initialization
  {$I mp3.lrs}

end.

