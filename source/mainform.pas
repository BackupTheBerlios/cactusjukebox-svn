
{
Main unit for Cactus Jukebox

written by Sebastian Kraft, <c> 2006

Contact the author at: sebastian_kraft@gmx.de

This Software is published under the GPL






}
unit mainform;


{$mode objfpc}{$H+}

interface


uses

  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  ExtCtrls, ComCtrls, StdCtrls, Menus, fmodplayer,
  ActnList, mediacol, dos, SimpleIPC, functions, EditBtn, aws;

resourcestring
  rsQuit = 'Quit';
  rsFile = 'File';
  rsOpenFile = 'Open File...';
  rsOpenDirector = 'Open Directory...';
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
    MenuItem13: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem9: TMenuItem;
    opendir: TMenuItem;
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
    procedure CoverImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
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
    procedure opendirClick(Sender: TObject);
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
     tmpcollection: TMediaCollectionClass;
     PTargetCollection: TMediaCollectionClass;
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
     TargetCollection: TMediaCollectionClass;
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
  SyncThread: TSyncThread;
  ScanThread: TscanThread;

//procedure update_title_view_album;
procedure update_artist_view;
procedure update_title_view;
procedure artist_to_playlist;
procedure title_to_playlist_at(index: integer);
procedure title_to_playlist;

//procedure album_to_playlist;



implementation
uses editid3, status, settings, player, directories, skin, cdrip, translations, bigcoverimg;

{$i cactus_const.inc}

var     sizediff: int64;


{ TSyncThread }

procedure TSyncThread.SyncStatus;
begin
   if finished=false then begin
     if SAction=SCopy then Main.StatusBar1.Panels[1].Text:=IntToStr(CopiedCnt)+' of '+IntToStr(CopyTotal)+ ' copied. Don''t Disconnect...';
     if SAction=SDelete then Main.StatusBar1.Panels[1].Text:=IntToStr(DeletedCnt)+' of '+IntToStr(DeleteTotal)+' deleted. Don''t Disconnect...';
    end else begin
     writeln('finished');
     TargetCollection.SaveToFile;
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
    TargetCollection:=TMediaCollectionClass.create;
    TargetCollection.PathFmt:=FRelative;
    TargetCollection.LoadFromFile(Target);
    while DeleteList.Count>0 do begin
           OpSuccess:=false;
         try

           sysutils.DeleteFile(self.DeleteList[0]);
           if FileExists(self.DeleteList[0])=false then begin
                  TargetCollection.remove(TargetCollection.getIndexByPath(self.DeleteList[0]));
              end;
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
            TargetCollection.add(TargetList[0]);
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
    if fStatus=1 then Main.StatusBar1.Panels[0].Text:='Scanning folders in background...';
    if fStatus=0 then begin
       main.Enabled:=false;
       if  MessageDlg('Some files on your harddisk seem to have changed.'+LineEnding+'Adopt changes in Cactus library?', mtWarning, mbOKCancel, 0)= mrOK then begin
       writeln(1);
             fstatus:=255;
             writeln('assigning');

//             PTargetCollection^.Assign(tmpcollection);
             writeln('saving');
//             PTargetCollection^.save_lib(PTargetCollection^.savepath);
             Main.clear_listClick(nil);

             writeln('WARNING: if excption occurs, playlist has to be cleared here!');
          //   Main.update_player_hdd_relations;
             update_artist_view;
             update_title_view;

             Main.StatusBar1.Panels[0].Text:=('Succesfully updated library...');
             tmpcollection.Free;
          end;
      main.Enabled:=true;
    end;
    if (fstatus=0) or (fstatus=128) then begin
        Main.StatusBar1.Panels[0].Text:='Ready';
        writeln('fstatus 0, 126');
        Main.StatusBar1.Panels[1].Alignment:=taRightJustify;
        tmpcollection.Free;
     end;
    writeln('showStatus');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TScanThread.Execute;
begin
   fStatus:=1;
   Synchronize(@ShowStatus);

//   fstatus:=tmpcollection.ScanForNew;
   Synchronize(@ShowStatus);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TScanThread.Create(Suspd: boolean);
 begin
  inherited Create(suspd);
  FreeOnTerminate := True;
  tmpcollection:=TMediaCollectionClass.create;
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
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.update_player_hdd_relations;
var i, z:integer;
begin
  for i:= 0 to PlayerCol.itemcount-1 do begin
      z:=0;
      PlayerCol.items[i].action:=AONPLAYER;
      while z < MediaCollection.ItemCount-1 do begin
         if MediaCollection.items[z].id=PlayerCol.items[i].id then begin
              MediaCollection.items[z].action:=1;
              z:= MediaCollection.ItemCount-1;
          end;
          inc(z);
       end;
  end;
Playercol.SaveToFile(CactusConfig.DAPPath+'cactuslib');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.loadlibClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'Mp3lib Library|*.mlb';
  OpenDialog1.InitialDir:=CactusConfig.HomeDir;
  OpenDialog1.FilterIndex := 1;
  if Opendialog1.execute=true then MediaCollection.LoadFromFile(Main.Opendialog1.Filename);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.newlibClick(Sender: TObject);
begin
     Selectdirectorydialog1.initialdir:=CactusConfig.HomeDir;
     Selectdirectorydialog1.title:='Add Directory...';
     if Selectdirectorydialog1.execute=true then begin
              MediaCollection.clear;
              Application.ProcessMessages;
              MediaCollection.add_directory(Selectdirectorydialog1.Filename);
              Writeln('finished scan of '+Selectdirectorydialog1.Filename);
              if MediaCollection.ItemCount>0 then begin
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
          playlist.Items[i].MakeVisible(false);
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
                     playlist.Items[i].MakeVisible(false);
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
                  playitem.MakeVisible(false);
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
    fileobj: TMediaFileClass;
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
                       fileobj:=TMediaFileClass(playlist.Items[player.CurrentTrack].Data);
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
    MediaFileObj: TMediaFileClass;
    MediaColObj: TMediaCollectionClass;
    z : integer;
begin
tsnode:=Main.ArtistTree.Selected;
if (tsnode<>nil) and (tsnode.Level>0) then begin
  if MessageDlg('The selected file(s) will permanently be'+#10+#13+'removed from harddisk!'+#10+#13+' Proceed?', mtWarning, mbOKCancel, 0)=mrOK then
    begin
       if tsnode.level<2 then album_mode:=false else album_mode:=true;
       MediaFileObj:=TMediaFileClass(tsnode.data);
       MediaColObj:=MediaFileObj.Collection;
       curartist:=lowercase(MediaFileObj.artist);
       curalbum:=lowercase(MediaFileObj.album);

       z:=MediaColObj.getTracks(curartist, MediaFileObj.index);

       repeat begin
         if (album_mode=false) or
            ((album_mode=true) and (lowercase(MediaColObj.items[z].album)=curalbum)) then
            begin
               if DeleteFile(MediaColObj.items[z].path) then begin
                    writeln('deleted file from disk: '+MediaColObj.items[z].path);
                    MediaColObj.remove(z);
                  end
                    else writeln('ERROR deleting file: '+MediaColObj.items[z].path);
            end;
         z:=MediaColObj.getNext;
       end;
       until (z=-1);
       update_artist_view;
       update_title_view;
       MediaColObj.SaveToFile;
   end;
 end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.rescanlibClick(Sender: TObject);
begin

 if MessageDlg('Cactus will now look for new files...'+LineEnding+'If new files or changes to files are not detected'+LineEnding+'try Library/Manage Libray and click Rescan. ', mtWarning, mbOKCancel, 0)=mrOK then
   begin
   // stopClick(nil);
   // clear_listClick(nil);
    ScanThread:=TScanThread.Create(true);

    ScanThread.tmpcollection.Assign(MediaCollection);
//    ScanThread.PTargetCollection:=@MediaCollection;
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
  saveDialog1.Filter := 'Cactus Media Library|*.cml';
  saveDialog1.DefaultExt := 'cml';
  saveDialog1.FilterIndex := 1;
  SaveDialog1.InitialDir:=CactusConfig.HomeDir;
   if Savedialog1.execute=true then MediaCollection.SaveToFile(Savedialog1.Filename);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.scanplayeritemClick(Sender: TObject);
var s, tmps:string;
    ScanCol: TMediaCollectionClass;
    z, i: integer;
begin
  if FileExists(CactusConfig.DAPPath)=false then begin ShowMessage(rsNotConnected);exit;end;

  If FileExists(CactusConfig.DAPPath) then begin
     checkmobile.Enabled:=false;
     disconnectDAP;
     ScanCol:=TMediaCollectionClass.create;
     Enabled:=false;
     ScanCol.PathFmt:=FRelative;
     ScanCol.savepath:=CactusConfig.DAPPath+'cactuslib';
     ScanCol.add_directory(CactusConfig.DAPPath);
     ScanCol.SaveToFile;
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
    i:integer;
begin
     TitleTree.Items.Clear;
     TitleTree.BeginUpdate;
     changetree:=true;
     artisttree.selected:=nil;
     changetree:=false;
     searchstring:=searchstr.text;
     found:=false;
     for i:= 0 to MediaCollection.ItemCount-1 do begin
         if srch_title.checked then if  pos(lowercase(searchstring),lowercase(MediaCollection.items[i].title))<>0 then found:=true;
         if srch_artist.checked then if  pos(lowercase(searchstring),lowercase(MediaCollection.items[i].artist))<>0 then found:=true;
         if srch_album.checked then if  pos(lowercase(searchstring),lowercase(MediaCollection.items[i].album))<>0 then found:=true;
         if srch_file.checked then if  pos(lowercase(searchstring),lowercase(extractfilename(MediaCollection.items[i].path)))<>0 then found:=true;
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
             if (ft='all') or (ft=MediaCollection.items[i].filetype) then begin

              ListItem := Main.Titletree.Items.Add;

              listitem.data:=MediaCollection.items[i];
              Listitem.ImageIndex:=MediaCollection.items[i].action;
              Listitem.caption:='';

              if MediaCollection.items[i].title<>'' then ListItem.SubItems.Add(MediaCollection.items[i].artist)
                    else ListItem.SubItems.Add(extractfilename(MediaCollection.items[i].path));
              ListItem.SubItems.Add (MediaCollection.items[i].title);
              ListItem.SubItems.Add (MediaCollection.items[i].album);
              ListItem.SubItems.Add(MediaCollection.items[i].playtime);
              end;
           end;
       end;
     TitleTree.EndUpdate;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.EditID3itemClick(Sender: TObject);
var tsitem:TListitem;
begin
  Main.enabled:=false;

  tsitem:=TitleTree.Selected;

  editid3win.display_window(TMediaFileClass(tsitem.data));
  EditID3win.Show;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.ArtistTreeSelectionChanged(Sender: TObject);
begin
  if main.changetree=false then update_title_view;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.CoverImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if player.playing {and player.Playlist.Items[player.CurrentTrack].co} then begin

  BigCoverImgForm:=TBigCoverImg.Create(self);
  BigCoverImgForm.AutoSize:=true;

  BigCoverImgForm.Image1.Top:=16;
  BigCoverImgForm.Image1.Left:=16;
  BigCoverImgForm.Image1.AutoSize:=true;


  BigCoverImgForm.Image1.Picture.Assign(CoverImage.Picture);

  BigCoverImgForm.BackImg.Canvas.Color:=clWhite;

  BigCoverImgForm.BackImg.Width:=150;//BigCoverImgForm.Image1.Width+32;
  BigCoverImgForm.BackImg.Height:=150;//BigCoverImgForm.Image1.Height+32;
  BigCoverImgForm.BackImg.Canvas.FillRect(0,0, BigCoverImgForm.BackImg.Width, BigCoverImgForm.BackImg.Height);

//  BigCoverImgForm.BackImg.Canvas.Color:=clBlack;
  BigCoverImgForm.BackImg.Canvas.Rectangle(5,5, BigCoverImgForm.BackImg.Width-5, BigCoverImgForm.BackImg.Height-5);


  BigCoverImgForm.Image1.BringToFront;

  BigCoverImgForm.Left:=x+Panel1.Left+self.Left+20;
  BigCoverImgForm.Top:=y+Panel1.height+self.top- 220;
  BigCoverImgForm.ShowModal;

 // Enabled:=false;
end;
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

procedure TMain.MenuItem13Click(Sender: TObject);
begin

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem6Click(Sender: TObject);
var MedFileObj:TMediaFileClass;
    MedColObj: TMediaCollectionClass;
    i:integer;
begin
if TitleTree.Selected<>nil then
if MessageDlg('The selected file(s) will permanently be'+#10+#13+'removed from harddisk!'+#10+#13+' Proceed?', mtWarning, mbOKCancel, 0)=mrOK then
 begin
  MedFileObj:=TMediaFileClass(TitleTree.Selected.Data);
  MedColObj:=MedFileObj.collection;
  i:=MedFileObj.index;

  if DeleteFile(MedFileObj.path) then
      begin
          writeln('deleted file from disk: '+MedFileObj.path);
          MedColObj.remove(i);
      end else begin
          if FileGetAttr(MedFileObj.path)=faReadOnly then ShowMessage('File is read only!');
          if FileExists(MedFileObj.path)=false then MedColObj.remove(i);
        end;

  update_artist_view;
  update_title_view;
  MedColObj.SaveToFile;
 end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem7Click(Sender: TObject);
begin
    title_to_playlist;
    Playlist.Items[Playlist.Items.Count-1].Focused:=true;
    playClick(nil);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem9Click(Sender: TObject);
begin
  title_to_playlist_at(player.CurrentTrack+1);
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

     CactusConfig.WHeight:=Height;
     CactusConfig.WWidth:=Width;
     CactusConfig.WSplitterWidth:=Splitter1.Left;
     if (MediaCollection.ItemCount>1) then
          begin
             MediaCollection.SaveToFile(CactusConfig.ConfigPrefix+'lib'+DirectorySeparator+'last.mlb');
             CactusConfig.LastLib:=MediaCollection.savepath;
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
     if CactusConfig.FlushConfig then writeln('Config succesfully written to disk') else writeln('ERROR: writing config to disk');
     CactusConfig.Free;
     Application.Terminate;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MainCreate(Sender: TObject);
var tmps1, tmps2: string;
begin
  writeln('## Main.onCreate ##');
  Caption:='Cactus Jukebox '+CACTUS_VERSION;

  Width:=CactusConfig.WWidth;
  Height:=CactusConfig.WHeight;
  
  TranslateUnitResourceStrings('mainform', CactusConfig.DataPrefix+'languages'+DirectorySeparator+'cactus.%s.po', CactusConfig.language, copy(CactusConfig.language, 0, 2));
  if SystemCharSetIsUTF8 then writeln('##System charset is UTF8');


  // Load resourcestrings to Captions
  QuitItem.Caption:= rsQuit;
  FileItem.Caption:= rsFile;
  openfile.Caption:=  rsOpenFile;
  opendir.Caption:= rsOpenDirector;
  player_lib.Caption:= rsPlayerOnly;
  skinmenu.Caption:= rsChooseSkin;
  SettingsItem.Caption:= rsSettings;

  MIlibrary.Caption:= rsLibrary;
  MInewlib.Caption:= rsNewLibrary;
  MIloadlib.Caption:=  rsLoadLibrary;
  MIsavelib.Caption:= rsSaveLibrary;
  MIlibinfo.Caption:= rsLibraryInfo;
  MIManagLib.Caption:= rsManageLibrar;
  MIrescanlib.Caption:= rsRescanDirect;

  MIPlaylist.Caption:= rsPlaylist;
  MIplay.Caption:= rsPlay;
  MInext.Caption:= rsNext;
  MIprevious.Caption:= rsPrevious;
  MImute.Caption:= rsMute;
  MIload_list.Caption:= rsLoadPlaylist;
  MIsave_list.Caption:= rsSavePlaylist;

  MImobile.Caption:= rsMobilePlayer;
  MImobile_info.Caption:= rsDeviceInfo;
  MIscan_mobile.Caption:= rsScanPlayer;
  MIsync.Caption:= rsSync;
  MIclear_mobile.Caption:= rsClearPlayer;
  MIundosync.Caption:= rsUndoSelectio;

  MIaudiocd.Caption:= rsAudioCD;
  MIrip.Caption:= rsRipEncode;

  MIhelp.Caption:= rsHelp;
  MIabout.Caption:= rsAbout;
  MImanual.Caption:= rsManual;

  clear_list.Caption:= rsClear;
  srch_button.Caption:= rsSearch;
  srch_album.Caption:= rsAlbum;
  srch_artist.Caption:= rsArtist;
  srch_file.Caption:= rsFilename;
  srch_title.Caption:= rsTitle;
  randomcheck.Caption:= rsRandom;

  oldSplitterWidth:=CactusConfig.WSplitterWidth;
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
//  Main.homedir:='C:\';
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
     //main.StatusBar1.Panels[0].Text:='Loading last library...';
     if Mediacollection.LoadFromFile(CactusConfig.LastLib)=false then begin
           //MediaCollection.clear;
           ShowMessage('ERROR while reading last library. You need to create a new one.'+LineEnding+'Please choose a directory to scan for mediafiles...');
           newlibClick(nil);
           TitleTree.Clear;
        end;
   end;

  // Load file specified on commandline
  if CactusConfig.LoadOnStart<>'' then begin
       LoadFile(CactusConfig.LoadOnStart);
    end;
//  update_artist_view;
//  update_title_view;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.ApplicationIdle(Sender: TObject; var Done: Boolean);
var templistitem: TListitem;
    fpath: string;
    i:integer;
begin

if SimpleIPCServer1.PeekMessage(1,True) then begin
  fpath:=copy(SimpleIPCServer1.StringMessage, 4, length(SimpleIPCServer1.StringMessage));
  writeln(fpath);
  case byte(StrToInt(SimpleIPCServer1.StringMessage)) of
     VOLUME_UP: if volumebar.Position>4 then  volumebar.Position:=volumebar.Position-5;
     VOLUME_DOWN: if volumebar.Position<46 then volumebar.Position:=volumebar.Position+5;
     NEXT_TRACK: nextClick(nil);
     STOP_PLAYING: stopClick(nil);
     START_PLAYING: playClick(nil);
     PREV_TRACK: prevClick(nil);
     PAUSE_PLAYING: pauseClick(nil);
   else writeln(' --> Invalid message/filename received via IPC');
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
  end;
end;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.update_player_display;
var MedFileObj: TMediaFileClass;
    PPlaylistItem: PPlaylistItemClass;
    i: integer;
begin
   if player.playing then begin
      i:=player.CurrentTrack;
      //MedFileObj:=playlist.Items[player.CurrentTrack].Data;

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

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TMain.LoadFile(path: string): boolean;
var z: integer;
    listitem: TListItem;
begin
 if FileExists(path) then begin
   writeln('** Loadfile **');
   z:=MediaCollection.GetIndexByPath(path);
   writeln(z);
   if z<0 then begin
      z:=MediaCollection.add(path);
   end;
   player.playlist.add(MediaCollection.items[z]);
   ListItem := Playlist.Items.Add;
   listitem.data:=MediaCollection.items[z];

   if MediaCollection.items[z].title<>'' then ListItem.Caption:=MediaCollection.items[z].artist+' - '+MediaCollection.items[z].title else ListItem.Caption:=extractfilename(MediaCollection.items[z].path);
   playlist.Column[0].Caption:='Playlist                       ('+IntToStr(player.playlist.ItemCount)+' Files/ '+player.Playlist.TotalPlayTimeStr +')';
   result:=true;
   update_artist_view;
   update_title_view;
  end else result:=false
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem11Click(Sender: TObject);
begin
   dirwin:=Tdirwin.Create(nil);

   dirwin.ShowModal;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem14Click(Sender: TObject);
var tsitem: TListItem;
    s, tmps : string;
    MedFileObj: TMediaFileClass;
    i:integer;
begin
  tsitem:=TitleTree.Selected;
  if (tsitem<>nil) and player_connected then begin
     MedFileObj:=TMediaFileClass(tsitem.data);
     for i:= 1 to MediaCollection.ItemCount-1 do
                  if MedFileObj.id=MediaCollection.items[i].id then MediaCollection.items[i].action:=AREMOVE;

     for i:= 1 to PlayerCol.ItemCount-1 do
                  if MedFileObj.id=PlayerCol.items[i].id then PlayerCol.items[i].action:=AREMOVE;
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
    MedFileObj: TMediaFileClass;
begin
  tsitem:=TitleTree.Selected;
  if (tsitem<>nil) and player_connected then begin
     MedFileObj:=TMediaFileClass(tsitem.data);
     MedFileObj.action:=AUPLOAD;

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
     for i:= 0 to PlayerCol.ItemCount-1 do z:=z+PlayerCol.items[i].size;

     used:=ByteToFmtString(z, 4, 2);

     tmps:=ByteToFmtString(FreeSpaceOnDAP, 4 , 2);
     str(PlayerCol.ItemCount-1, s);

     ShowMessage(s+' Files on mobile player    '+#10+used+' of music'+#10+'Free Disk Space: '+tmps);
   end else ShowMessage(rsNotConnected);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem20Click(Sender: TObject);
var tsitem: TListItem;
    MedFileObj: TMediaFileClass;
    tmps: string;
    i:integer;
begin
  tsitem:=TitleTree.Selected;
  if tsitem<>nil then begin
     MedFileObj:=TMediaFileClass(tsitem.data);
     if MedFileObj.action=AREMOVE then begin
                  //PFobj^.action:=1;
                  sizediff:=sizediff-MedFileObj.size;
                  for i:= 1 to MediaCollection.ItemCount-1 do
                        if MedFileObj.id=MediaCollection.items[i].id then MediaCollection.items[i].action:=1;

                  for i:= 1 to PlayerCol.ItemCount-1 do
                        if MedFileObj.id=PlayerCol.items[i].id then PlayerCol.items[i].action:=-1;
                end
                 else begin
                         MedFileObj.action:=-1;
                         sizediff:=sizediff+MedFileObj.size;
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
            listitem.Data:=TMediaFileClass.create(player.Playlist.Items[id].path, nil);
            ListItem.Caption:=player.Playlist.items[id].Artist+' - '+player.Playlist.Items[id].Title;
         end;

   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem2Click(Sender: TObject);
var i:integer;
    MedFileObj: TMediaFileClass;
    Listitem: TListItem;

begin

   if (TitleTree.Items.Count>0) then begin
     for i:= 0 to TitleTree.Items.Count-1 do begin
           MedFileObj:=TMediaFileClass(TitleTree.Items[i].Data);
           player.playlist.add(MedFileObj);

           ListItem := Playlist.Items.Add;
           listitem.data:=MedFileObj;

           if MedFileObj.title<>'' then
                  ListItem.Caption:=MedFileObj.artist+' - '+MedFileObj.title
                else
                  ListItem.Caption:=extractfilename(MedFileObj.path);
       end;
   end;
   playlist.Column[0].Caption:='Playlist                       ('+IntToStr(player.playlist.ItemCount)+' Files/ '+player.Playlist.TotalPlayTimeStr +')';
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem37Click(Sender: TObject);
var MedColObj: TMediaCollectionClass;
    curartist, curalbum, s, tmps: string;
    MedFileObj: TMediaFileClass;
    i:integer;
begin
   tsnode:=ArtistTree.Selected;

   if (tsnode<>nil) and (tsnode.level>0) then begin
      MedFileObj:=TMediaFileClass(tsnode.data);
      MedColObj:=MedFileObj.collection;
      i:=MedColObj.getTracks(MedFileObj.Artist, MedFileObj.index);
      if tsnode.level=2 then
           begin
                curartist:=lowercase(MedFileObj.artist);
                curalbum:=lowercase(MedFileObj.album);
                repeat begin
                      if (lowercase(MedColObj.items[i].album)=curalbum) and (MedColObj.items[i].action=AREMOVE) then begin
                         MedColObj.items[i].action:=AONPLAYER;
                         sizediff:=sizediff-MedColObj.items[i].size;
                       end;
                      if (lowercase(MedColObj.items[i].album)=curalbum) and (MedColObj.items[i].action<>AONPLAYER) then begin
                         MedColObj.items[i].action:=ANOTHING;
                         sizediff:=sizediff+MedColObj.items[i].size;
                       end;
                      i:=MedColObj.GetNext;
                    end;
                  until i<0;

           end;
      if tsnode.level=1 then
           begin
                curartist:=lowercase(MedFileObj.artist);
                repeat begin
                       if (MedColObj.items[i].action=AREMOVE) then begin
                          MedColObj.items[i].action:=AONPLAYER;
                          sizediff:=sizediff-MedColObj.items[i].size;
                         end;
                       if (MedColObj.items[i].action<>AONPLAYER) then begin
                          MedColObj.items[i].action:=ANOTHING;
                          sizediff:=sizediff+MedColObj.items[i].size;
                         end;
                       i:=MedColObj.GetNext;
                     end;
                  until i<0;
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
           if IndexOfCurrentColumn<>4 then sl.sort else sl.CustomSort(@NumericCompare);
        end;
     for counter := 0 to titletree.items.count -1 do begin
        titletree.items[counter] := TListItem(sl. Objects[counter]);
      end;
   finally
   sl.free;
end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.TitleTreeMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // ensure that the popup menu is only opened when an item is selected
  // the menu is reanabled in TMain.TitleTreeSelectItem
  if (Button = mbRight) and (TitleTree.Selected = nil) then
    TitleTree.PopupMenu.AutoPopup := false;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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
         playlist.selected:=playlist.Items[main.player.CurrentTrack];
         MenuItem10Click(nil);
       end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.artisttreemenuPopup(Sender: TObject);
var    MedFileObj: TMediaFileClass;
begin
  if ArtistTree.Selected.Level>0 then begin
    MedFileObj:=TMediaFileClass(ArtistTree.Selected.Data);
    if MedFileObj.collection=PlayerCol then Menuitem30.enabled:=false else Menuitem30.enabled:=true;
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
               PlayerScanThread.tmpcollection.Assign(PlayerCol);
               PlayerScanThread.PTargetCollection:=PlayerCol;
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
             err:=DeleteFile(PlayerCol.items[i].path);
             if err=true then dec(PlayerCol.max_index); {array length is not shorten here !!}
             dec(i);
           end;
        until i=0;

      if err=false then ShowMessage('Error while deleting one or more files.'+#10+#13+' Perhaps no write permission or file doesn''t exist')
    end;

  end else ShowMessage(rsNotConnected);}
  ShowMessage('Not implemented yet!');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem10Click(Sender: TObject);
var MedFileObj: TMediaFileClass;
begin
    Main.enabled:=false;

    if playlist.Selected<>nil then begin
       MedFileObj:=TMediaFileClass(Playlist.Selected.Data);
       editid3win.display_window(MedFileObj);
     end;
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
     for i:= 1 to MediaCollection.ItemCount-1 do z:=z+MediaCollection.items[i].size;

     used:=ByteToFmtString(z, 3, 2);
    s:= IntToStr(MediaCollection.ItemCount);
     ShowMessage(s+' Files in library '+#10+' '+used+' of music files');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.muteClick(Sender: TObject);
begin
  player.mute;
  if player.muted then mute.Glyph.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'mute1.xpm') else mute.Glyph.LoadFromFile(SkinData.DefaultPath+DirectorySeparator+'icon'+DirectorySeparator+'mute2.xpm');
end;

procedure TMain.opendirClick(Sender: TObject);
var i: integer;
begin
  SelectDirectoryDialog1.InitialDir:=CactusConfig.HomeDir;
  Selectdirectorydialog1.title:='Add Directory...';
  If SelectDirectoryDialog1.Execute=true then begin
    for i:= 0 to MediaCollection.dirlist.Count-1 do begin
            if pos(MediaCollection.dirlist[i], SelectDirectoryDialog1.FileName)=1 then begin
                      ShowMessage('Directory '+SelectDirectoryDialog1.FileName+' is still part of directorylist');
                      exit;
             end;
       end;
     Enabled:=false;
     Application.ProcessMessages;
     MediaCollection.add_directory(SelectDirectoryDialog1.FileName);
     Writeln('finished scan of '+Selectdirectorydialog1.Filename);
     if MediaCollection.ItemCount>1 then begin
                Main.ArtistTree.Selected:=nil;
                update_artist_view;
                update_title_view;
      end;
     Enabled:=true;
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.openfileClick(Sender: TObject);
var mp3obj: TMediaFileClass;
    templistitem: TListItem;
    i:integer;
begin
     OpenDialog1.Filter := 'All supported audio|*.wav;*.mp3;*.ogg|MP3|*.mp3|OGG|*.ogg|WAV|*.wav';
     OpenDialog1.InitialDir:=CactusConfig.HomeDir;
     OpenDialog1.FilterIndex := 1;
     if Opendialog1.execute=true then begin
        LoadFile(Opendialog1.Filename);
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

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.playlistMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var tempitem: TListItem;
begin
  // ensure that the popup menu is only opened when an item is selected
  // the menu is reanabled in TMain.playlistSelectItem
  if (Button = mbRight) and (playlist.Selected = nil) then
    playlist.PopupMenu.AutoPopup := false;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.playlistSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  // reanable the popupmenu in case ist was disabled in TMain.playlistMouseDown
  playlist.PopupMenu.AutoPopup := true;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.playlistStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  sourceitem:=playlist.Selected;
  writeln(sourceitem.Caption);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.playtimerStartTimer(Sender: TObject);
var MedFileObj: TMediaFileClass;
    PPlaylistItem: PPlaylistItemClass;
    i: integer;
begin
  CoverFound:=false;
  LoopCount:=0;
  i:=player.CurrentTrack;
  MedFileObj:=TMediaFileClass(playlist.Items[player.CurrentTrack].Data);
  if (MedFileObj.album<>'') then begin
     MedFileObj.CoverPath:=CactusConfig.ConfigPrefix+DirectorySeparator+'covercache'+DirectorySeparator+MedFileObj.artist+'_'+MedFileObj.album+'.jpeg';
     if (FileExists(MedFileObj.CoverPath)=false) then begin
             CoverImage.Picture.Clear;
             if  (CactusConfig.CoverDownload) then begin
                  awsclass:=TAWSAccess.CreateRequest(MedFileObj.artist, MedFileObj.album);
                  awsclass.AlbumCoverToFile(MedFileObj.CoverPath);
               end;
        end else begin
             CoverImage.Picture.LoadFromFile(MedFileObj.CoverPath);
             playwin.AlbumCoverImg.Picture.LoadFromFile(MedFileObj.CoverPath);
             CoverFound:=true;
        end;
    end else CoverImage.Picture.Clear;//CoverImage.Picture.LoadFromFile(DataPrefix+'tools'+DirectorySeparator+'cactus-logo-small.png');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.ArtistTreeDblClick(Sender: TObject);
var first: boolean;
begin
   first:=false;
   if Playlist.Items.Count=0 then first:=true;
   if (ArtistTree.Selected<>nil) and (ArtistTree.Selected.Level>0) then artist_to_playlist;
   if first and CactusConfig.AutostartPlay then playClick(nil);
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

    65..255:begin
             if not ArtistSrchField.visible then begin
                ArtistSrchField.Top:=main.Height-120;
                ArtistSrchField.Left:=Panel4.Width-155;
                ArtistSrchField.Show;
                artistsearch.Text:=c;
                artistsearch.SetFocus;
                artistsearch.SelStart:=1;
//                artistsearch.SelLength:=0;

              end;
             i:=0;
             repeat inc(i) until ((pos(lowercase(artistsearch.Text), lowercase(ArtistTree.Items[i].Text))=1) and (ArtistTree.Items[i].Level=1)) or (i>=ArtistTree.Items.Count-1);
             ArtistTree.Selected:=ArtistTree.Items[i];
          end;
  end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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
var MedColObj: TMediaCollectionClass;
    curartist, curalbum, tmps: string;
    tmpsize: int64;
    MedFileObj: TMediaFileClass;
    i:integer;
begin
   tsnode:=ArtistTree.Selected;
   tmpsize:=0;

   if (tsnode<>nil) and (tsnode.level>0) and player_connected then begin
      MedFileObj:=TMediaFileClass(tsnode.data);
      MedColObj:=MedFileObj.collection;
      curartist:=lowercase(MedFileObj.artist);
      i:=MedColObj.getTracks(MedFileObj.Artist, MedFileObj.index);
      if tsnode.level=2 then     //album
           begin
                curalbum:=lowercase(MedFileObj.album);
                repeat begin
                      if (lowercase(MedColObj.items[i].album)=curalbum) and (MedColObj.items[i].action=AREMOVE) then begin
                         MedColObj.items[i].action:=AONPLAYER;
                         sizediff:=sizediff - MedColObj.items[i].size;
                       end;
                      if (lowercase(MedColObj.items[i].album)=curalbum) and (MedColObj.items[i].action<>AONPLAYER) then begin
                          MedColObj.items[i].action:=AUPLOAD;
                          sizediff:=sizediff - MedColObj.items[i].size;
                        end;
                      i:=MedColObj.GetNext;
                    end;
                  until i<0;

           end;
      if tsnode.level=1 then     //artist
           begin
                repeat begin
                       if (MedColObj.items[i].action=AREMOVE) then begin
                          MedColObj.items[i].action:=AONPLAYER;
                          sizediff:=sizediff - MedColObj.items[i].size;
                         end;
                       if (MedColObj.items[i].action<>AONPLAYER) then begin
                           MedColObj.items[i].action:=AUPLOAD;
                           sizediff:=sizediff - MedColObj.items[i].size;
                         end;
                       i:=MedColObj.GetNext;
                     end;
                  until i<0;
           end;
      update_artist_view;
      update_title_view;

      tmps:=ByteToFmtString(FreeSpaceOnDAP + sizediff, 3, 2);
      StatusBar1.Panels[1].Text:='Device connected     '+tmps+' Free';
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.MenuItem33Click(Sender: TObject);
var MedFileObj: TMediaFileClass;
begin
  Enabled:=false;

  tsnode:=ArtistTree.Selected;
  MedFileObj:=TMediaFileClass(tsnode.data);
  if tsnode.level= 1 then begin
    editid3win.display_window(MedFileObj, ARTIST_MODE);
  end;
  if tsnode.level= 2 then begin
    editid3win.display_window(MedFileObj, ALBUM_MODE);
  end;
  EditID3win.Show;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.rm_artist_playeritemClick(Sender: TObject);
var MedColObj: TMediaCollectionClass;
    curartist, curalbum, tmps: string;
    MedFileObj: TMediaFileClass;
    i, z:integer;
begin
   tsnode:=ArtistTree.Selected;
   if (tsnode<>nil) and (tsnode.level>0) and player_connected then begin
      MedFileObj:=TMediaFileClass(tsnode.data);
      MedColObj:=MedFileObj.collection;

      if tsnode.level=2 then   //remove one album
           begin
                i:=PlayerCol.getTracks(MedFileObj.Artist, MedFileObj.Album);
                repeat begin
                      if PlayerCol.Items[i].Action=AONPLAYER then
                         begin
                              PlayerCol.items[i].action:=AREMOVE;
                              for z:= 0 to MediaCollection.ItemCount-1 do
                                     if PlayerCol.items[i].id=MediaCollection.items[z].id then MediaCollection.items[z].action:=AREMOVE;
                              sizediff:=sizediff + PlayerCol.items[i].size;
                         end;
                      i:=PlayerCol.getNext;
                    end;
                  until  (i<0);
           end;
      if tsnode.level=1 then      //remove the artist
           begin
                i:=PlayerCol.getTracks(MedFileObj.Artist);
                repeat begin
                       if PlayerCol.items[i].action=AONPLAYER then begin
                              PlayerCol.items[i].action:=AREMOVE;
                              for z:= 0 to MediaCollection.ItemCount-1 do
                                     if PlayerCol.items[i].id=MediaCollection.items[z].id then MediaCollection.items[z].action:=AREMOVE;
                              sizediff:=sizediff + PlayerCol.items[i].size;
                         end;
                       i:=PlayerCol.getNext;
                     end;
                  until (i<0);
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
    for n:= 0 to MediaCollection.ItemCount-1 do begin   //search for uploads in mediacollection
            if MediaCollection.items[n].action=AUPLOAD then begin
                       inc(ucount);
                       bytesneeded:=bytesneeded + MediaCollection.items[n].size;
                       if CactusConfig.mobile_subfolders then begin
                           if not DirectoryExists(CactusConfig.DAPPath+lowercase(MediaCollection.items[n].artist)) then mkdir(CactusConfig.DAPPath+lowercase(MediaCollection.items[n].artist));
                           newfile:=CactusConfig.DAPPath+lowercase(MediaCollection.items[n].artist)+'/'+ExtractFileName(MediaCollection.items[n].path);
                         end
                         else
                           newfile:=CactusConfig.DAPPath+ExtractFileName(MediaCollection.items[n].path);
                       DoDirSeparators(newfile);
                       SyncThread.copyFile(MediaCollection.items[n].path, newfile);
                end;
        end;
    for n:= 0 to PlayerCol.ItemCount-1 do begin    //find files to be deleted in playercollection
            if PlayerCol.items[n].action=AREMOVE then begin
                      inc(rcount);
                      bytesneeded:=bytesneeded - PlayerCol.items[n].size;
                      SyncThread.deleteFile(PlayerCol.items[n].path);
                      writeln(PlayerCol.items[n].path+' to be deleted');  //Debug
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
var MedFileObj: TMediaFileClass;
begin
if TitleTree.Selected<>nil then begin
  MedFileObj:=TMediaFileClass(TitleTree.Selected.Data);
 // Menuitem16.ImageIndex:=1;
  if MedFileObj.collection=PlayerCol then begin
      Menuitem16.enabled:=false;
      Menuitem14.enabled:=true;
     end
     else begin
      Menuitem16.enabled:=false; //upload
      Menuitem14.Enabled:=false; //remove

      if MedFileObj.action=-1 then begin
          Menuitem16.enabled:=true;
         end;

      if MedFileObj.action=1 then begin
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
  for i:= 1 to MediaCollection.ItemCount-1 do begin
      if MediaCollection.items[i].action=AUPLOAD then MediaCollection.items[i].action:=ANOTHING;
      if MediaCollection.items[i].action=AREMOVE then MediaCollection.items[i].action:=AONPLAYER;
    end;

  for i:= 1 to PlayerCol.ItemCount-1 do begin
      if PlayerCol.items[i].action=AUPLOAD then PlayerCol.items[i].action:=ANOTHING;
      if PlayerCol.items[i].action=AREMOVE then PlayerCol.items[i].action:=AONPLAYER;
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

procedure TMain.TitleTreeDblClick(Sender: TObject);
var first: boolean;
begin
    first:=false;
    if Playlist.Items.Count=0 then first:=true;
    title_to_playlist;
    if first and CactusConfig.AutostartPlay then playClick(nil);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.addFileItemClick(Sender: TObject);
begin
     if Opendialog1.execute=true then MediaCollection.add(Opendialog1.Filename);
     update_artist_view;
     update_title_view;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure title_to_playlist_at(index: integer);
var tsnode:TListitem;
    MedColObj: TMediaCollectionClass;
    listitem:TListitem;
    MedFileObj: TMediaFileClass;
begin
   tsnode:=main.TitleTree.Selected;
   if (tsnode<>nil) and (tsnode.ImageIndex<>4) then begin
     MedFileObj:=TMediaFileClass(tsnode.data);

     main.player.playlist.Insert(index, MedFileObj);

     ListItem := Main.Playlist.Items.Insert(index);
     listitem.data:=MedFileObj;
     listitem.MakeVisible(false);
     if MedFileObj.title<>'' then ListItem.Caption:=MedFileObj.artist+' - '+MedFileObj.title else ListItem.Caption:=extractfilename(MedFileObj.path);
   end;
   main.playlist.Column[0].Caption:='Playlist                       ('+IntToStr(main.player.playlist.ItemCount)+' Files/ '+main.player.Playlist.TotalPlayTimeStr +')';
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure title_to_playlist;
var tsnode:TListitem;
    MedColObj: TMediaCollectionClass;
    listitem:TListitem;
    MedFileObj: TMediaFileClass;
    z, i:integer;
begin
   tsnode:=main.TitleTree.Selected;
   if (tsnode<>nil) and (tsnode.ImageIndex<>4) then begin
     MedFileObj:=TMediaFileClass(tsnode.data);

     main.player.playlist.add(MedFileObj);

     ListItem := Main.Playlist.Items.Add;
     listitem.data:=MedFileObj;
     listitem.MakeVisible(false);
//     listitem.Focused:=true;
     if MedFileObj.title<>'' then ListItem.Caption:=MedFileObj.artist+' - '+MedFileObj.title else ListItem.Caption:=extractfilename(MedFileObj.path);
   end;
   main.playlist.Column[0].Caption:='Playlist                       ('+IntToStr(main.player.playlist.ItemCount)+' Files/ '+main.player.Playlist.TotalPlayTimeStr +')';
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure artist_to_playlist;
var tempnode, tsnode:TTreeNode;
    curartist, curalbum: string;
    Listitem:TListitem;
    album_mode:boolean;
    MedColObj: TMediaCollectionClass;
    MedFileObj: TMediaFileClass;
    z, i:integer;
begin
  tsnode:=Main.ArtistTree.Selected;
  if (tsnode<>nil) and (tsnode.Level>0) then begin
     if tsnode.level<2 then album_mode:=false else album_mode:=true;
     MedFileObj:=TMediaFileClass(tsnode.data);
     MedColObj:=MedFileObj.Collection;
     curartist:=lowercase(MedFileObj.Artist);
     curalbum:=lowercase(MedFileObj.Album);
     z:=MedColObj.getTracks(MedFileObj.Artist, MedFileObj.index);
     repeat begin
        writeln(MedColObj.items[z].title);
        if (album_mode=false) or ((album_mode=true) and (lowercase(MedColObj.items[z].album)=curalbum)) then begin
           Main.player.playlist.add(MedColObj.items[z]);
           ListItem := Main.Playlist.Items.Add;
           listitem.data:=MedColObj.items[z];
          // Listitem.Focused:=true;
           if MedColObj.items[z].title<>'' then ListItem.Caption:=MedColObj.items[z].artist+' - '+MedColObj.items[z].title else ListItem.Caption:=extractfilename(MedColObj.items[z].path);
        end;
        z:=MedColObj.GetNext;
      end;
      until z<0;
     Listitem.MakeVisible(false);
   end;
  main.playlist.Column[0].Caption:='Playlist            ('+IntToStr(main.player.playlist.ItemCount)+' Files/ '+main.player.Playlist.TotalPlayTimeStr+' )';
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure update_title_view;
var tsnode:TTreeNode;
    curartist, curalbum: string;
    Listitem:TListItem;
    album_mode:boolean;
    MedColObj: TMediaCollectionClass;
    MedFileObj: TMediaFileClass;
    i:integer;
begin
    tsnode:=Main.ArtistTree.Selected;
    main.StatusBar1.Panels[0].Text:='Please wait... updating...';

    writeln;
    write('## update title view...');


    Main.TitleTree.Clear;
 //   Main.TitleTree.BeginUpdate;
    write(' cleared items... ');

     if (tsnode<>nil) and (tsnode.level>0) then begin
         if tsnode.level=2 then album_mode:=true else album_mode:=false;

         MedFileObj:=TMediaFileClass(tsnode.data);
         MedColObj:=MedFileObj.Collection;
         curartist:=lowercase(MedFileObj.artist);
         curalbum:=lowercase(MedFileObj.album);
         write(curartist);

         i:=MedColObj.getTracks(MedFileObj.Artist, MedFileObj.index);

         repeat begin
            if (album_mode=false) or ((album_mode) and (curalbum=lowercase(MedColObj.items[i].album))) then
              begin
                 ListItem := Main.Titletree.Items.Add;
                 MedColObj.items[i].index:=i;
                 listitem.data:=MedColObj.items[i];
                 Listitem.ImageIndex:=MedColObj.items[i].action;
                 Listitem.caption:='';

                 if MedColObj.items[i].title<>'' then
                        ListItem.SubItems.Add((MedColObj.items[i].Artist))
                     else ListItem.SubItems.Add(extractfilename(MedColObj.items[i].path));

                 ListItem.SubItems.Add ((MedColObj.items[i].title));
                 ListItem.SubItems.Add ((MedColObj.items[i].album));
                 ListItem.SubItems.Add (MedColObj.items[i].track);
                 ListItem.SubItems.Add(MedColObj.items[i].playtime);
               end;
            i:=MedColObj.GetNext;
          end;
         until (i<0);
     end;

     writeln(' finished title view ##');
    // Main.TitleTree.EndUpdate;
     main.StatusBar1.Panels[0].Text:='Ready.';

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure update_artist_view;
var existing, curartist, tmps2, tmps:string;
    tsnode, artnode, localnode, playernode, cdnode:Ttreenode;
    MedColObj, CurCol: TMediaCollectionClass;
    AlbumList:TStringList;
    MedFileObj: TMediaFileClass;
    i, z:integer;
begin
if MediaCollection.Count>0 then begin
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
          MedFileObj:=TMediaFileClass(tsnode.data);
          curartist:=lowercase(MedFileObj.artist);
          CurCol:=MedFileObj.Collection;
       end else begin
           curartist:='';
         end;
     write(' clear trees...');
     Main.ArtistTree.Items.Clear;

//     for i:= 0 to MediaCollection.Count-1 do writeln(MediaCollection.Items[i].artist + '   ' +MediaCollection.Items[i].Title+'   '+MediaCollection.Items[i].Album);
     localnode:=Main.ArtistTree.Items.Add(nil, 'Local Harddisk');
     localnode.ImageIndex:=6;
     localnode.SelectedIndex:=6;
     localnode.data:=pointer(1);

     i:=MediaCollection.getArtists;
     repeat begin
        if MediaCollection.Items[i].Artist<>'' then artnode:=Main.ArtistTree.Items.AddChild(localnode, MediaCollection.Items[i].Artist)
          else artnode:=Main.ArtistTree.Items.AddChild(localnode, 'Unknown');
        with artnode do
            begin
               MakeVisible;
               ImageIndex:=MediaCollection.Items[i].Action;
               SelectedIndex:=MediaCollection.Items[i].Action;
               Data:=MediaCollection.items[i];
            end;
        AlbumList:=MediaCollection.getAlbums(MediaCollection.Items[i].Artist, i);
        for z:=0 to AlbumList.Count-1 do begin  // add albums to node of current artist
           with Main.ArtistTree.Items.Addchild(artnode, AlbumList[z]) do
             begin
               MakeVisible;
               ImageIndex:=MediaCollection.Items[i].Action;
               SelectedIndex:=MediaCollection.Items[i].Action;
               Data:=AlbumList.Objects[z];
             end;
        end;
        artnode.Expanded:=false;
        i:=MediaCollection.getNextArtist;
     end;
     until i<0;

     existing:='';
  if main.player_connected then begin
     playernode:=Main.ArtistTree.Items.Add(nil, 'Mobile Player');
     playernode.SelectedIndex:=1;
     playernode.ImageIndex:=1;
     playernode.data:=pointer(0);


     i:=PlayerCol.getArtists;
     repeat begin
        if PlayerCol.Items[i].Artist<>'' then artnode:=Main.ArtistTree.Items.AddChild(playernode, PlayerCol.Items[i].Artist)
          else artnode:=Main.ArtistTree.Items.AddChild(playernode, 'Unknown');
        with artnode do
            begin
               MakeVisible;
               ImageIndex:=PlayerCol.Items[i].Action;
               SelectedIndex:=PlayerCol.Items[i].Action;
               Data:=PlayerCol.items[i];
            end;
        AlbumList:=PlayerCol.getAlbums(PlayerCol.Items[i].Artist, i);
        for z:=0 to AlbumList.Count-1 do begin  // add albums to node of current artist
           with Main.ArtistTree.Items.Addchild(artnode, AlbumList[z]) do
             begin
               MakeVisible;
               ImageIndex:=PlayerCol.Items[i].Action;
               SelectedIndex:=PlayerCol.Items[i].Action;
               Data:=AlbumList.Objects[z];
             end;
        end;
        artnode.Expanded:=false;
        i:=PlayerCol.getNextArtist;
     end;
     until i<0;
  end;


     i:=0;
     if curartist<>'' then begin
        repeat begin
            repeat inc(i) until (main.ArtistTree.items[i].Level=1) or (i>=main.ArtistTree.Items.Count-1);
            MedFileObj:=TMediaFileClass(main.ArtistTree.items[i].data);
         end;
        until ((lowercase(main.artisttree.items[i].text)=curartist) and (MedFileObj.collection=CurCol))
               or (i>=main.artisttree.items.count-1);
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
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TMain.update_playlist;
var    PPlaylistItem: PPlaylistItemClass;
       MedfileObj: TMediaFileClass;
       i:integer;
begin

     for i:= 0 to player.Playlist.ItemCount-1 do begin
          MedfileObj:=TMediaFileClass(playlist.Items[i].Data);
          player.Playlist.Items[i].update(MedfileObj);

          if MedfileObj.title<>'' then
              playlist.Items[i].caption:=MedfileObj.artist+' - '+MedfileObj.title
            else
              playlist.Items[i].caption:=extractfilename(MedfileObj.path);
     end;
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
         if TMediaFileClass(playlist.Items[i].Data).collection=PlayerCol then begin
            Player.playlist.remove(i);
            if player.Playlist.ItemCount<>0 then Playlist.Items[i].Delete;
            dec(i);
          end;
      inc(i);
    end;
    FreeAndNil(PlayerCol);
    player_connected:=false;
    for i:= 1 to MediaCollection.ItemCount-1 do MediaCollection.items[i].action:=-1;
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
       PlayerCol:=TMediaCollectionClass.create;
       PlayerCol.PathFmt:=FRelative;
       writeln('### ConnectDAP  ###');
       if PlayerCol.LoadFromFile(CactusConfig.DAPPath+'cactuslib')=true then begin

              sizediff:=0;
              for i:= 0 to PlayerCol.ItemCount-1 do begin
                z:=0;
                PlayerCol.items[i].action:=AONPLAYER;
                while z < MediaCollection.ItemCount-1 do begin
                        if MediaCollection.items[z].id=PlayerCol.items[i].id then begin
                             MediaCollection.items[z].action:=AONPLAYER;
                             z:= MediaCollection.ItemCount-1;
                          end;
                        inc(z);
                    end;

              end;
            player_connected:=true;
            update_artist_view;
            update_title_view;
            checkmobile.Enabled:=true;
            result:=0;
       end else
         freeandnil(PlayerCol);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


initialization
  {$I mainform.lrs}

end.

