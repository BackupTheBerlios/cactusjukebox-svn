{
Settings Dialog for Cactus Jukebox

written by Sebastian Kraft, <c> 2006

Contact the author at: sebastian_kraft@gmx.de

This Software is published under the GPL






}


unit settings; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, ComCtrls, CheckLst, config;
  
resourcestring
  rsAutoloadLast = 'Autoload last library at startup';
  rsScanForNewFi = 'Scan for new files in background  on startup';
  rsLanguage = 'Language';
  rsWhatToDoWhen = 'What to do when there is no ID3';
  rsGuessTagFrom = 'Guess tag from filename';
  rsMoveToSectio = 'Move to section %sUnknown%s';
  rsID3Type = 'ID3 type';
  rsID3v1Priorit = 'ID3v1 Priority';
  rsID3v2Priorit = 'ID3v2 Priority';
  rsGeneral = 'General';
  rsPathToMp3pla = 'Path to mp3player mountpoint';
  rsCreateSubfol = 'Create subfolders on upload';
  rsPathsToAddit = 'Paths to additional application needed for Cactus Jukebox';
  rsCdda2wavTool = 'Cdda2wav (tool to rip CDs)';
  rsSave = 'Save';
  rsCancel = 'Cancel';
  rsMobileDevice = 'Mobile Device';
  rsPaths = 'Paths';
  rsLameNeededTo = 'lame (needed to encode mp3 files)';
  rsEnableKDESer = 'Enable KDE Service Menu';
  rsAudioOutput = 'Audio Output';
  rsDownloadAlbu = 'Download album cover image from internet';
  rsClearCache = 'Clear Cache';
  rsAutomaticlyS = 'Automaticly start playing first song in playlist';
  

type


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  { TSettings }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  TSettings = class(TForm)
    autoload1: TCheckBox;
    Button1: TButton;
    backscan: TCheckBox;
    Button2: TButton;
    CDRomEdit: TEdit;
    AutoPlayBox: TCheckBox;
    Label2: TLabel;
    PluginList: TCheckListBox;
    ClearCover: TButton;
    AudioOut: TComboBox;
    CoverDownload: TCheckBox;
    guesstag1: TRadioButton;
    GuessTagBox: TGroupBox;
    ID3typebox: TGroupBox;
    kdeservicebox: TCheckBox;
    Label1: TLabel;
    LanguageBox: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    LAudioOut: TLabel;
    PluginInfo: TMemo;
    PathBox: TGroupBox;
    LLanguage: TLabel;
    Lcdda2wav: TLabel;
    Llame: TLabel;
    Label5: TLabel;
    RadioGroup1: TRadioGroup;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    subfolders: TCheckBox;
    LMountpoint: TLabel;
    PageControl1: TPageControl;
    playerpathedit1: TEdit;
    savebut: TButton;
    cancelbut: TButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet5: TTabSheet;
    unknown1: TRadioButton;
    v1_prio: TRadioButton;
    v1_prio1: TRadioButton;
    v2_prio: TRadioButton;
    v2_prio1: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure ClearCoverClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LanguageBoxChange(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PluginListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cancelbutClick(Sender: TObject);
    procedure kdeserviceboxChange(Sender: TObject);
    procedure savebutClick(Sender: TObject);
  private
    { private declarations }
    servicemenu_changed:boolean;
  public
    { public declarations }
  end; 

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

var
  setupwin: TSettings;


implementation
uses mainform, translations, functions, plugin, fmodplayer;


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TSettings }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TSettings.savebutClick(Sender: TObject);
var tmps:string;
    i: integer;
begin
  //   Main.mpg123:=mpg123pathedit1.text;
  //   Main.lame:=lamepathedit1.text;
     CactusConfig.DAPPath:=IncludeTrailingPathDelimiter(playerpathedit1.Text);
     CactusConfig.CDRomDevice:=CDRomEdit.Text;
{$ifdef linux}
     if servicemenu_changed then
          if kdeservicebox.checked then begin
                   if FileExists(CactusConfig.HomeDir+'/.kde/share/apps/konqueror/servicemenus/') then begin
                         if FileCopy(CactusConfig.DataPrefix+'/tools/cactus_servicemenu.desktop', CactusConfig.HomeDir+'/.kde/share/apps/konqueror/servicemenus/cactus_servicemenu.desktop')
                                  then CactusConfig.KDEServiceMenu:=true
                                  else begin
                                         CactusConfig.KDEServiceMenu:=false;
                                         ShowMessage('ERROR: Couldn''t create service menu...');
                                       end;
                    end;
                end else begin
                   DeleteFile(CactusConfig.HomeDir+'/.kde/share/apps/konqueror/servicemenus/cactus_servicemenu.desktop');
                   CactusConfig.KDEServiceMenu:=true;
              end;
     If AudioOut.ItemIndex=0 then CactusConfig.OutputAlsa:=true else CactusConfig.OutputAlsa:=false;
{$endif}
     if guesstag1.checked then CactusConfig.GuessTag:=true else CactusConfig.GuessTag:=false;
     if backscan.Checked then CactusConfig.background_scan:= true else CactusConfig.background_scan:=false;
     if v2_prio.Checked then CactusConfig.id3v2_prio:=true else CactusConfig.id3v2_prio:=false;
     if subfolders.checked then CactusConfig.mobile_subfolders:=true else CactusConfig.mobile_subfolders:=false;
     if CoverDownload.Checked then CactusConfig.CoverDownload:=true else CactusConfig.CoverDownload:=false;
     if AutoPlayBox.Checked then CactusConfig.AutostartPlay:=true else CactusConfig.AutostartPlay:=false;
//     MediaCollection.guess_tag:=CactusConfig.GuessTag;
     fmodplayer.player.oss:=not CactusConfig.OutputAlsa;

     CactusConfig.language:=LanguageBox.Items[LanguageBox.ItemIndex];
     CactusConfig.FlushConfig;
     
     for i:=0 to PluginList.Count-1 do
        if PluginList.Checked[i] then
            CactusPlugins.Items[i].enabled:=true
         else CactusPlugins.Items[i].enabled:=false;

     TranslateUnitResourceStrings('settings', CactusConfig.DataPrefix+'languages/cactus.%s.po', CactusConfig.language, '');
     TranslateUnitResourceStrings('mp3', CactusConfig.DataPrefix+'languages/cactus.%s.po', CactusConfig.language, '');
     close;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TSettings.cancelbutClick(Sender: TObject);
begin
     close;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TSettings.kdeserviceboxChange(Sender: TObject);
begin
  servicemenu_changed:=true;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TSettings.Button1Click(Sender: TObject);
begin
     if FileExists(CactusConfig.DAPPath) then Main.Selectdirectorydialog1.initialdir:=CactusConfig.DAPPath else Main.Selectdirectorydialog1.initialdir:='/';
     Main.Selectdirectorydialog1.title:='Choose mp3 player directory...';
     if Main.Selectdirectorydialog1.execute=true then begin
                playerpathedit1.text:=IncludeTrailingPathDelimiter(Main.Selectdirectorydialog1.FileName);
            end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TSettings.ClearCoverClick(Sender: TObject);
begin
  if DirectoryExists(CactusConfig.ConfigPrefix+DirectorySeparator+'covercache') then begin
     if EraseDirectory(CactusConfig.ConfigPrefix+DirectorySeparator+'covercache') then
        writeln('Covercache has been cleared...')
      else writeln('ERROR while clearing covercache...');
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TSettings.FormCreate(Sender: TObject);
var srec: TSearchRec;
    i: integer;
begin
   //Look for available translations and add them into the combobox
   if FindFirst(IncludeTrailingPathDelimiter(CactusConfig.DataPrefix)+'languages'+DirectorySeparator+'*.mo', faAnyFile,srec)=0 then
       begin
          repeat begin
               i:=LanguageBox.Items.Add(Copy(srec.Name, 8, length(srec.Name)-10));
               if (CactusConfig.language=LanguageBox.Items[i]) or (copy(CactusConfig.language, 0, 2)=LanguageBox.Items[i]) then LanguageBox.ItemIndex:=i;
           end;
          until FindNext(srec)<>0;
     end;
   {$ifdef win32}
       label2.Hide;
       CDRomEdit.Hide;;
   {$endif}
   TranslateUnitResourceStrings('settings', CactusConfig.DataPrefix+'languages/cactus.%s.po', CactusConfig.language, copy(CactusConfig.language, 0, 2));
   autoload1.Caption:=rsAutoloadLast;
   backscan.Caption:=rsScanForNewFi;
   LLanguage.Caption:=rsLanguage;
   GuessTagBox.Caption:=rsWhatToDoWhen;
   guesstag1.Caption:=rsGuessTagFrom;
   unknown1.Caption:=Format(rsMoveToSectio, ['"', '"']);
   ID3typebox.Caption:=rsID3Type;
   v1_prio.Caption:=rsID3v1Priorit;
   v2_prio.Caption:=rsID3v2Priorit;
   TabSheet1.Caption:=rsGeneral;
   TabSheet2.Caption:=rsMobileDevice;
   TabSheet3.Caption:=rsPaths;
   LMountpoint.Caption:=rsPathToMp3pla;
   subfolders.Caption:=rsCreateSubfol;
   PathBox.Caption:=rsPathsToAddit;
   Lcdda2wav.Caption:=rsCdda2wavTool;
   llame.Caption:=rsLameNeededTo;
   savebut.Caption:=rsSave;
   cancelbut.Caption:=rsCancel;
   kdeservicebox.Caption:=rsEnableKDESer;
   LAudioOut.Caption:=rsAudioOutput;
   CoverDownload.Caption:=rsDownloadAlbu;
   ClearCover.Caption:=rsClearCache;
   LLanguage.Caption:=rsLanguage;
//   AutostartBox.Caption:=rsAutomaticlyS;

 {$ifdef linux}
   kdeservicebox.Checked:=CactusConfig.KDEServiceMenu;
   if CactusConfig.OutputAlsa then AudioOut.ItemIndex:=0 else AudioOut.ItemIndex:=1;
   servicemenu_changed:=false;
   kdeservicebox.Visible:=true;
 {$else}
   AudioOut.Visible:=false;
   LAudioOut.Visible:=false;
   kdeservicebox.Visible:=false;
 {$endif}
   CoverDownload.Checked:=CactusConfig.CoverDownload;

   playerpathedit1.text:=CactusConfig.DAPPath;
   CDRomEdit.Text:=CactusConfig.CDRomDevice;
   if CactusConfig.GuessTag then guesstag1.checked:=true else unknown1.checked:=true;
   if CactusConfig.background_scan then backscan.checked:=true else backscan.checked:=false;
   if CactusConfig.mobile_subfolders then subfolders.checked:=true else subfolders.checked:=false;
   if CactusConfig.id3v2_prio then v2_prio.Checked:=true else v1_prio.checked:=true;
   AutoPlayBox.Checked:=CactusConfig.AutostartPlay;

   for i:=0 to CactusPlugins.Count-1 do begin
          writeln(i);
          PluginList.Items.Add(CactusPlugins.Items[i].Name);
          PluginList.Checked[i]:=CactusPlugins.Items[i].enabled;
       end;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TSettings.FormDestroy(Sender: TObject);
begin
end;

procedure TSettings.LanguageBoxChange(Sender: TObject);
begin
  ShowMessage('To show user interface with new selected language'+LineEnding+' you need to restart cactus Jukebox');
end;

procedure TSettings.PageControl1Change(Sender: TObject);
begin

end;


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TSettings.PluginListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var index: integer;
begin
  index:=PluginList.GetIndexAtY(Y);
  PluginInfo.Clear;
//  if index >= 0 then PluginInfo.Lines.Add(CactusPlugins.Items[index].Comment);
end;




initialization
  {$I settings.lrs}

end.

