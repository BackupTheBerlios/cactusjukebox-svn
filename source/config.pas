unit config;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, xmlcfg, gettext;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    { TConfigObject }  //Object to read and list config data
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
type
  TConfigObject = class
   public
    GuessTag, id3v2_prio: boolean;
    Mobile_Subfolders, background_scan, CoverDownload: boolean;
    OutputAlsa, KDEServiceMenu: boolean;

    AutostartPlay: Boolean;
    language: string; // country code, e.g. de -> germany

    DAPPath, CDRomDevice: string;
    CurrentSkin, LastLib, LoadOnStart: string;
    Lame, CDDA2wav: string;

    DataPrefix, ConfigPrefix, LibraryPrefix, HomeDir: string;
    WWidth, WHeight, WSplitterWidth: Integer;

    AlbumCoverFirsttime:boolean;

    constructor create(ConfigFile:string);
    destructor destroy;

    function ReadConfig:boolean;
    function FlushConfig:boolean;
    procedure Clear;
   private
    FConfigPath: string;
    FConfigFile: TXMLConfig;
 end;
 
var   CactusConfig: TConfigObject;
const configname='cactus.cfg';


implementation

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TConfigObject }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
constructor TConfigObject.create(ConfigFile: string);
begin
  FConfigPath:=ConfigFile;

  FConfigFile:=TXMLConfig.Create(nil);
  FConfigFile.Filename:=FConfigPath;
  ReadConfig;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

destructor TConfigObject.destroy;
begin
     FlushConfig;
     FConfigFile.Free;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TConfigObject.ReadConfig: boolean;
var tmps1, tmps2: string;
begin
 result:=true;

 try
    GuessTag:=FConfigFile.GetValue('Library/GuessTags', false);
    Mobile_Subfolders:=FConfigFile.GetValue('Mobile_Player/Subfolders', true);
    id3v2_prio:=FConfigFile.GetValue('Library/id3v2_prio', true);
//    background_scan:=FConfigFile.GetValue('Library/background_scan', false);
    background_scan:=false;
    DAPPath:=IncludeTrailingPathDelimiter(FConfigFile.getValue('Mobile_Player/Mountpoint', ''));
    if FConfigFile.GetValue('Networking/Album_Cover_Download/Enabled','')='' then AlbumCoverFirsttime:=true;
    CoverDownload:=FConfigFile.GetValue('Networking/Album_Cover_Download/Enabled', false);
    CurrentSkin:=FConfigFile.getValue('Skin/File', 'green.xml');
    KDEServiceMenu:=FConfigFile.GetValue('KDE/servicemenu', false);
    if FConfigFile.GetValue('Audio/Output', 'Alsa')='Alsa' then OutputAlsa:=true else OutputAlsa:=false;

    LastLib:=FConfigFile.GetValue('Library/autoload','');
    AutostartPlay:=FConfigFile.GetValue('Playlist/Autoplay', true);

    Lame:=FConfigFile.GetValue('Lame/Path', '/usr/bin/lame');
    GetLanguageIDs(tmps1, tmps2);

    WWidth:=FConfigFile.GetValue('Userinterface/Window/Width', 854);
    WHeight:=FConfigFile.GetValue('Userinterface/Window/Height', 680);
    WSplitterWidth:=FConfigFile.GetValue('Userinterface/Window/SplitterWidth', 270);
    language:=FConfigFile.GetValue('Userinterface/Language/Code', tmps1);
    CDRomDevice:=FConfigFile.GetValue('Devices/CDROM/Name', '/dev/cdrom');
 except result:=false;
 end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TConfigObject.FlushConfig: boolean;
begin
  result:=true;
  try
    FConfigFile.SetValue('Library/id3v2_prio',id3v2_prio);
    FConfigFile.SetValue('Mobile_Player/Mountpoint', DAPPath);
    if OutputAlsa then
       begin
            FConfigFile.SetValue('Audio/Output', 'Alsa');
       end else
       begin
            FConfigFile.SetValue('Audio/Output', 'OSS');
       end;
    FConfigFile.SetValue('Mobile_Player/Subfolders',mobile_subfolders);
    FConfigFile.SetValue('Networking/Album_Cover_Download/Enabled', CoverDownload);
    FConfigFile.SetValue('Lame/Path', lame);
    FConfigFile.SetValue('Library/GuessTags', guesstag);
    FConfigFile.SetValue('Library/background_scan', background_scan);
    FConfigFile.SetValue('Library/autoload', LastLib);
    FConfigFile.SetValue('Skin/File', CurrentSkin);
    FConfigFile.SetValue('Userinterface/Language/Code', language);
    FConfigFile.SetValue('Playlist/Autoplay', AutostartPlay);
    FConfigFile.SetValue('Userinterface/Window/Width', WWidth);
    FConfigFile.SetValue('Userinterface/Window/Height', WHeight);
    FConfigFile.SetValue('Userinterface/Window/SplitterWidth', WSplitterWidth);
    FConfigFile.SetValue('Devices/CDROM/Name', CDRomDevice);

    FConfigFile.Flush;
  except result:=false;
  end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TConfigObject.Clear;
begin
  FConfigFile.Free;
  DeleteFile(IncludeTrailingPathDelimiter(ConfigPrefix)+CONFIGNAME);
  FConfigFile:=TXMLConfig.Create(nil);
  FConfigFile.Filename:=FConfigPath;
  ReadConfig;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end.

