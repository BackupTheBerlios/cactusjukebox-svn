unit plugin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, plugintypes, dynlibs, settings, xmlcfg;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
type

{ TPluginListItemClass }
  TPluginListItemClass = class
  private
    FName, FLibName, FLibPath, FVersion, FComment, FAuthor: string;
    FPluginHandle: TCactusPlugInClass;
    FLibraryHandle: TLibHandle;
    FEnabled: Boolean;
   // FPlayerObjectPointer: TFModPlayerClass;
    procedure setEnabled( aValue: boolean);
  public
    constructor create;
    destructor destroy;
    function ReadPlugin(pluginpath: string):boolean;
    property Name: string read FName;
    property LibName: string read FLibName;
    property Version: string read FVersion;
    property Author: string read FAuthor;
    property Comment: string read FComment;
    property PluginHandle: TCactusPlugInClass read FPluginHandle;
    property LibraryHandle: TLibHandle read FLibraryHandle;
    property enabled: boolean read FEnabled write setEnabled;
 //   property PlayerObjectPointer: TFModPlayerClass read FPlayerObjectPointer;

    function loadPlugin: boolean;
    function unloadPlugin: boolean;
  end;
{ TPluginListItemClass }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

{ TPluginListClass }
  TPluginListClass = class(Tlist)
  private
    function GetItems(index: integer):TPlugInListItemClass;
    function ReadPluginConfig:boolean;

    FConfigPath: string;
    FConfigFile: TXMLConfig;
  public
    constructor Create;
    destructor destroy;
    function FlushPluginConfig:boolean;
    function add(dllname: string):boolean;
    procedure ScanPluginFolder;
    procedure SendEvent(event: TCactusEvent);
    property Items[index: integer]: TPlugInListItemClass read GetItems;
    PluginFolder: string;
    autoload: boolean;  //reload all previous loaded plugins if found during ScanPluginFolder
  end;
{ TPluginListClass }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Var CactusPlugins: TPluginListClass;


implementation

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TPluginListClass }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function TPluginListClass.GetItems(index: integer): TPlugInListItemClass;
begin
 // result:=TPluginListItemClass(inherited items[index]);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPluginListClass.ReadPluginConfig: boolean;
var i: integer;
begin
{  for i:=0 to Count-1 do  begin
        Items[i].Enabled:=FConfigFile.GetValue('Plugin/'+Items[i].LibName+'/Enabled', true);
      end;
}end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPluginListClass.FlushPluginConfig: boolean;
var i:integer;
begin
{  writeln('pluginconfig');
  for i:=0 to Count-1 do
       if Items[i].FEnabled then begin
             FConfigFile.SetValue('Plugin/'+Items[i].LibName+'/Enabled', true);
          end else
             FConfigFile.SetValue('Plugin/'+Items[i].LibName+'/Enabled', false);
  FConfigFile.Flush;}
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TPluginListClass.Create;
begin
{  inherited create;

  FConfigPath:=CactusConfig.DataPrefix+'plugins.cfg';
  FConfigFile:=TXMLConfig.Create(nil);
  FConfigFile.Filename:=FConfigPath;
 }
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

destructor TPluginListClass.destroy;
var i: integer;
begin
{  FlushPluginConfig;
  FConfigFile.Free;
  writeln('free plugins');
  for i:= 0 to Count-1 do Items[i].Free;}
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


function TPluginListClass.add(dllname: string): boolean;
var   listitem: TPluginListItemClass;
begin

{   listitem:=TPluginListItemClass.Create;

   if listitem.ReadPlugin(dllname) then
       begin
         Inherited add(listitem);
         result:=true;
       end
       else begin
         result:=false;
         listitem.Free;
    end;}
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TPluginListClass.ScanPluginFolder;
var srchstring: string;
    srchRec: TSearchRec;
begin
{
 Clear;
 {$ifdef Linux}
    srchstring:=PluginFolder+'lib*.so';
 {$endif}
 {$ifdef windows}
    srchstring:=PluginFolder+'*.dll';
 {$endif}
  if FindFirst(srchstring, faAnyFile, srchRec) = 0 then begin
    repeat
       begin
          write('Reading '+PluginFolder+srchRec.Name+' ... ');
          add(PluginFolder+srchRec.Name);
          writeln('done');
       end;
    until FindNext(srchRec)<>0;
    FindClose(srchRec);
  end;
  ReadPluginConfig;}
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TPluginListClass.SendEvent(event: TCactusEvent);
var i: integer;
begin
{  writelN('Sendevent');

  for i:= 0 to Count-1 do if Items[i].enabled then Items[i].PluginHandle.EventHandler(event);
}end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TPluginListItemClass.setEnabled(aValue: boolean);
begin
{  if (FEnabled=false) and (aValue=true) then loadPlugin else unloadPlugin;
  FEnabled:=aValue;
 }
end;


{ TPluginListItemClass }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
constructor TPluginListItemClass.create;
begin
  //FEnabled:=false;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

destructor TPluginListItemClass.destroy;
begin
  //unloadPlugin;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPluginListItemClass.ReadPlugin(pluginpath: string): boolean;
var GetInfoProcAdress: TGetPluginInfoProc;
    PluginInfo: TPluginInfoRec;
begin
 {try
   if FileExists(pluginpath) then write('ok');
   FLibraryHandle:=LoadLibrary(pluginpath);
 except;
   result:=false;
   exit;
 end;

 if FLibraryHandle=NilHandle then begin
      write('failed...');
      result:=false;
      exit;
    end;

 try
   GetInfoProcAdress:=TGetPluginInfoProc(GetProcAddress(FLibraryHandle, 'GetPluginInfo'));

   if GetInfoProcAdress<>nil then
         PluginInfo:=GetInfoProcAdress()
      else begin
             write('wrong plugin type...');
             result:=false;
             exit;
         end;

   FName:=StrPas(PluginInfo.Name);
   FLibName:=ExtractFileName(pluginpath);
   FLibPath:=IncludeTrailingPathDelimiter(ExtractFileDir(pluginpath));
   FAuthor:=StrPas(PluginInfo.Author);
   FVersion:=StrPas(PluginInfo.Version);
   FComment:=StrPas(PluginInfo.Comment);
   FPlayerObjectPointer:=player;
   result:=true;
 //finally
  except
   if UnloadLibrary(FLibraryHandle)=true then write('succes') else write('failed');
 end;
  }
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPluginListItemClass.loadPlugin: boolean;
var LoadAddr: TLoadPlugIn;
begin
 {write('Loading plugin '+FLibName+'...');
 try
   if FileExists(FLibPath+FLibName) then write(' ok ') else writeln(' error '+FLibPath+FLibName);
   FLibraryHandle:=LoadLibrary(FLibPath+FLibName);
 except;
   result:=false;
   writeln('file not found');
   exit;
 end;
   LoadAddr:=nil;
 try
   LoadAddr:=TLoadPlugIn(GetProcAddress(FLibraryHandle, 'LoadPlugin'));
   LoadAddr(FPluginHandle);
   writeln('done');
 except
   writeln('error loading object!');
 end;
  }
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPluginListItemClass.unloadPlugin: boolean;
begin
 // FPluginHandle.Free;
 // UnloadLibrary(FLibraryHandle);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end.

