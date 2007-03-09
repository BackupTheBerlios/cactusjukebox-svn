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
  ExtCtrls, Buttons, ComCtrls;
  
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
  

type

  { TSettings }

  TSettings = class(TForm)
    autoload1: TCheckBox;
    Button1: TButton;
    backscan: TCheckBox;
    kdeservicebox: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    ID3typebox: TGroupBox;
    PathBox: TGroupBox;
    LLanguage: TLabel;
    Lcdda2wav: TLabel;
    Llame: TLabel;
    Label5: TLabel;
    TabSheet3: TTabSheet;
    v1_prio: TRadioButton;
    subfolders: TCheckBox;
    GuessTagBox: TGroupBox;
    guesstag1: TRadioButton;
    LMountpoint: TLabel;
    PageControl1: TPageControl;
    playerpathedit1: TEdit;
    savebut: TButton;
    cancelbut: TButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    unknown1: TRadioButton;
    v2_prio: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cancelbutClick(Sender: TObject);
    procedure kdeserviceboxChange(Sender: TObject);
    procedure savebutClick(Sender: TObject);
  private
    { private declarations }
    servicemenu_changed:boolean;
  public
    { public declarations }
  end; 

var
  setupwin: TSettings;

implementation
uses mp3, mp3file, translations, functions;
{ TSettings }

procedure TSettings.savebutClick(Sender: TObject);
var tmps:string;
begin
  //   Main.mpg123:=mpg123pathedit1.text;
  //   Main.lame:=lamepathedit1.text;
     tmps:=playerpathedit1.text;
     tmps:=TrimRight(tmps);
     if (tmps<>'') and (tmps[length(tmps)]<>'/') and (tmps[length(tmps)]<>'\') then tmps:=tmps+'/';
     DoDirSeparators(tmps);
     Main.playerpath:=tmps;
{$ifdef linux}
     if servicemenu_changed then
          if kdeservicebox.checked then begin
                   if FileExists(main.HomeDir+'/.kde/share/apps/konqueror/servicemenus/') then begin
                         if FileCopy(main.DataPrefix+'/tools/cactus_servicemenu.desktop', main.HomeDir+'/.kde/share/apps/konqueror/servicemenus/cactus_servicemenu.desktop')
                                  then Main.cfgfile.SetValue('KDE/servicemenu', true)
                                  else begin
                                         Main.cfgfile.SetValue('KDE/servicemenu', false);
                                         ShowMessage('ERROR: Couldn''t create service menu...');
                                       end;
                    end;
                end else begin
                   DeleteFile(main.HomeDir+'/.kde/share/apps/konqueror/servicemenus/cactus_servicemenu.desktop');
                   Main.cfgfile.SetValue('KDE/servicemenu', false);
              end;
{$endif}
     if guesstag1.checked then MediaCollection.guess_tag:=true else MediaCollection.guess_tag:=false;
     if backscan.Checked then Main.background_scan:= true else Main.background_scan:=false;
     if v2_prio.Checked then main.id3v2_prio:=true else main.id3v2_prio:=false;
     if subfolders.checked then Main.mobile_subfolders:=true else Main.mobile_subfolders:=false;
     
     Main.cfgfile.SetValue('Library/id3v2_prio',Main.id3v2_prio);
     Main.cfgfile.SetValue('Mobile_Player/Mountpoint', Main.playerpath);
     
     Main.cfgfile.SetValue('Mobile_Player/Subfolders',Main.mobile_subfolders);

     Main.cfgfile.SetValue('Lame/Path', Main.lame);
     Main.cfgfile.SetValue('Library/GuessTags',MediaCollection.guess_tag);
     Main.cfgfile.SetValue('Library/background_scan',Main.background_scan);
     main.cfgfile.Flush;

     close;
end;

procedure TSettings.cancelbutClick(Sender: TObject);
begin
     close;
end;

procedure TSettings.kdeserviceboxChange(Sender: TObject);
begin
  servicemenu_changed:=true;
end;

procedure TSettings.Button1Click(Sender: TObject);
begin
     if FileExists(Main.Playerpath) then Main.Selectdirectorydialog1.initialdir:=Main.playerpath else Main.Selectdirectorydialog1.initialdir:='/';
     Main.Selectdirectorydialog1.title:='Choose mp3 player directory...';
     if Main.Selectdirectorydialog1.execute=true then begin
                playerpathedit1.text:=Main.Selectdirectorydialog1.FileName;
            end;
end;

procedure TSettings.FormCreate(Sender: TObject);
begin

   TranslateUnitResourceStrings('settings', Main.DataPrefix+'languages/cactus.%s.po', 'de', '');
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

 {$ifdef linux}
   kdeservicebox.Checked:=Main.cfgfile.GetValue('KDE/servicemenu', false);
   servicemenu_changed:=false;
   kdeservicebox.Visible:=true;
 {$else}
   kdeservicebox.Visible:=false;
 {$endif}

   
end;

initialization
  {$I settings.lrs}

end.

