unit plugin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, plugintypes, dynlibs, settings, xmlcfg;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
type
  TPlayerEvent = (evnStartPlay, evnStopPlay);

{ TPluginListItemClass }
  TPluginListItemClass = class
  private
    FName, FLibName, FLibPath, FVersion, FComment, FAuthor: string;
    FPluginHandle: TCactusPlugInClass;
    FLibraryHandle: TLibHandle;
    FEnabled: Boolean;
  public
    constructor create;
    function ReadPlugin(pluginpath: string):boolean;
    property Name: string read FName;
    property LibName: string read FLibName;
    property Version: string read FVersion;
    property Author: string read FAuthor;
    property Comment: string read FComment;
    property PluginHandle: TCactusPlugInClass read FPluginHandle;
    property LibraryHandle: TLibHandle read FLibraryHandle;
    property enabled: boolean read FEnabled;

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
    function FlushPluginConfig:boolean;
    FConfigPath: string;
    FConfigFile: TXMLConfig;
  public
    constructor Create;
    function add(dllname: string):boolean;
    procedure ScanPluginFolder;
//    procedure SendEvent( Evn
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
  result:=TPluginListItemClass(inherited items[index]);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPluginListClass.ReadPluginConfig: boolean;
var i: integer;
begin
  for i:=0 to Count-1 do  begin
        Items[i].FEnabled:=FConfigFile.GetValue('Plugins/'+Items[i].FLibName+'/Enabled', false);
        if autoload and items[i].FEnabled then Items[i].loadPlugin;
      end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPluginListClass.FlushPluginConfig: boolean;
var i:integer;
begin
  for i:=0 to Count-1 do
       if Items[i].FEnabled then
             FConfigFile.SetValue('Plugin/'+Items[i].LibName+'/Enabled', true)
           else
             FConfigFile.DeletePath('Plugin/'+Items[i].LibName);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TPluginListClass.Create;
begin
  inherited create;

  FConfigPath:=CactusConfig.DataPrefix+'plugins.cfg';
  FConfigFile:=TXMLConfig.Create(nil);
  FConfigFile.Filename:=FConfigPath;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


function TPluginListClass.add(dllname: string): boolean;
var   listitem: TPluginListItemClass;
begin

   listitem:=TPluginListItemClass.Create;

   if listitem.ReadPlugin(dllname) then
       begin
         Inherited add(listitem);
         result:=true;
       end
       else begin
         result:=false;
         listitem.Free;
    end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TPluginListClass.ScanPluginFolder;
var srchstring: string;
    srchRec: TSearchRec;
begin

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
  ReadPluginConfig;
end;


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TPluginListItemClass }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
constructor TPluginListItemClass.create;
begin
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPluginListItemClass.ReadPlugin(pluginpath: string): boolean;
var GetInfoProcAdress: TGetPluginInfoProc;
    PluginInfo: TPluginInfoRec;
begin
 try
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
   FLibPath:=ExtractFileDir(pluginpath);
   FAuthor:=StrPas(PluginInfo.Author);
   FVersion:=StrPas(PluginInfo.Version);
   FComment:=StrPas(PluginInfo.Comment);
   result:=true;
 //finally
  except
   if UnloadLibrary(FLibraryHandle)=true then write('succes') else write('failed');
 end;

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPluginListItemClass.loadPlugin: boolean;
var LoadAddr: TLoadPlugIn;
begin
 try
   if FileExists(FLibPath+FLibName) then write('ok');
   FLibraryHandle:=LoadLibrary(FLibPath+FLibName);
 except;
   result:=false;
   exit;
 end;
   LoadAddr:=TLoadPlugIn(GetProcAddress(FLibraryHandle, 'LoadPlugin'));
   LoadAddr(FLibraryHandle, FPluginHandle);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TPluginListItemClass.unloadPlugin: boolean;
begin

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end.

