
Unit config;

{$mode objfpc}{$H+}

Interface

Uses 
Classes, SysUtils, xmlcfg, gettext;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    { TConfigObject }
//Object to read and list config data
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Type 
  TConfigObject = Class
    Public 
    GuessTag, id3v2_prio: boolean;
    Mobile_Subfolders, background_scan, CoverDownload: boolean;
    OutputAlsa, KDEServiceMenu: boolean;

    AutostartPlay: Boolean;
    language: string;
    // country code, e.g. de -> germany

    DAPPath, CDRomDevice: string;
    CurrentSkin, LastLib, StreamColPath, LoadOnStart: string;
    Lame, CDDA2wav: string;

    DataPrefix, ConfigPrefix, LibraryPrefix, HomeDir: string;
    WWidth, WHeight, WSplitterWidth: Integer;

    AlbumCoverFirsttime: boolean;

    constructor create(ConfigFile:String);
    destructor destroy;

    Function ReadConfig: boolean;
    Function FlushConfig: boolean;
    Procedure Clear;
    Private 
    FConfigPath: string;
    FConfigFile: TXMLConfig;
  End;

Var   CactusConfig: TConfigObject;

Const configname = 'cactus.cfg';


  Implementation

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TConfigObject }
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  constructor TConfigObject.create(ConfigFile: String);
Begin
  FConfigPath := ConfigFile;

  FConfigFile := TXMLConfig.Create(Nil);
  FConfigFile.Filename := FConfigPath;
  ReadConfig;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

destructor TConfigObject.destroy;
Begin
  FlushConfig;
  FConfigFile.Free;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Function TConfigObject.ReadConfig: boolean;

Var tmps1, tmps2: string;
Begin
  result := true;

  Try
    GuessTag := FConfigFile.GetValue('Library/GuessTags', false);
    Mobile_Subfolders := FConfigFile.GetValue('Mobile_Player/Subfolders', true);
    id3v2_prio := FConfigFile.GetValue('Library/id3v2_prio', true);
    //    background_scan:=FConfigFile.GetValue('Library/background_scan', false);
    background_scan := false;
    DAPPath := IncludeTrailingPathDelimiter(FConfigFile.getValue('Mobile_Player/Mountpoint', ''));
    If FConfigFile.GetValue('Networking/Album_Cover_Download/Enabled','')='' Then
      AlbumCoverFirsttime := true;
    CoverDownload := FConfigFile.GetValue('Networking/Album_Cover_Download/Enabled', false);
    CurrentSkin := FConfigFile.getValue('Skin/File', 'green.xml');
    KDEServiceMenu := FConfigFile.GetValue('KDE/servicemenu', false);
    If FConfigFile.GetValue('Audio/Output', 'Alsa')='Alsa' Then OutputAlsa := true
    Else OutputAlsa := false;

    LastLib := FConfigFile.GetValue('Library/autoload','');
    StreamColPath := FConfigFile.GetValue('Library/StreamCollection','');
    AutostartPlay := FConfigFile.GetValue('Playlist/Autoplay', true);

    Lame := FConfigFile.GetValue('Lame/Path', '/usr/bin/lame');
    GetLanguageIDs(tmps1, tmps2);

    WWidth := FConfigFile.GetValue('Userinterface/Window/Width', 854);
    WHeight := FConfigFile.GetValue('Userinterface/Window/Height', 680);
    WSplitterWidth := FConfigFile.GetValue('Userinterface/Window/SplitterWidth', 270);
    language := FConfigFile.GetValue('Userinterface/Language/Code', tmps1);
    CDRomDevice := FConfigFile.GetValue('Devices/CDROM/Name', '/dev/cdrom');
  Except
    result := false;
  End;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Function TConfigObject.FlushConfig: boolean;
Begin
  result := true;
  Try
    FConfigFile.SetValue('Library/id3v2_prio',id3v2_prio);
    FConfigFile.SetValue('Mobile_Player/Mountpoint', DAPPath);
    If OutputAlsa Then
      Begin
        FConfigFile.SetValue('Audio/Output', 'Alsa');
      End
    Else
      Begin
        FConfigFile.SetValue('Audio/Output', 'OSS');
      End;
    FConfigFile.SetValue('Mobile_Player/Subfolders',mobile_subfolders);
    FConfigFile.SetValue('Networking/Album_Cover_Download/Enabled', CoverDownload);
    FConfigFile.SetValue('Lame/Path', lame);
    FConfigFile.SetValue('Library/GuessTags', guesstag);
    FConfigFile.SetValue('Library/background_scan', background_scan);
    FConfigFile.SetValue('Library/autoload', LastLib);
    FConfigFile.SetValue('Library/StreamCollection', StreamColPath);
    FConfigFile.SetValue('Skin/File', CurrentSkin);
    FConfigFile.SetValue('Userinterface/Language/Code', language);
    FConfigFile.SetValue('Playlist/Autoplay', AutostartPlay);
    FConfigFile.SetValue('Userinterface/Window/Width', WWidth);
    FConfigFile.SetValue('Userinterface/Window/Height', WHeight);
    FConfigFile.SetValue('Userinterface/Window/SplitterWidth', WSplitterWidth);
    FConfigFile.SetValue('Devices/CDROM/Name', CDRomDevice);

    FConfigFile.Flush;
  Except
    result := false;
  End;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Procedure TConfigObject.Clear;
Begin
  FConfigFile.Free;
  DeleteFile(IncludeTrailingPathDelimiter(ConfigPrefix)+CONFIGNAME);
  FConfigFile := TXMLConfig.Create(Nil);
  FConfigFile.Filename := FConfigPath;
  ReadConfig;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

End.
