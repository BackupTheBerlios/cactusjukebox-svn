
Unit plugin;

{$mode objfpc}{$H+}

Interface

Uses 
Classes, SysUtils, plugintypes, dynlibs, settings, xmlcfg, playerclass, config, mediacol;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Type 

{ TPluginListItemClass }
  TPluginListItemClass = Class
    Private 
    FName, FLibName, FLibPath, FVersion, FComment, FAuthor: string;
    FPluginHandle: TCactusPlugInClass;
    FLibraryHandle: TLibHandle;
    FEnabled: Boolean;
    FPlayerObjectPointer: TPlayerClass;
    Procedure setEnabled( aValue: boolean);
    Public 
    constructor create;
    destructor destroy;
    Function ReadPlugin(pluginpath: String): boolean;
    property Name: string read FName;
    property LibName: string read FLibName;
    property Version: string read FVersion;
    property Author: string read FAuthor;
    property Comment: string read FComment;
    property PluginHandle: TCactusPlugInClass read FPluginHandle;
    property LibraryHandle: TLibHandle read FLibraryHandle;
    property enabled: boolean read FEnabled write setEnabled;
    property PlayerObjectPointer: TPlayerClass read FPlayerObjectPointer;

    Function loadPlugin: boolean;
    Function unloadPlugin: boolean;
  End;
{ TPluginListItemClass }

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

{ TPluginListClass }
  TPluginListClass = Class(Tlist)
   Private
    Function GetItems(index: integer): TPlugInListItemClass;
    Function ReadPluginConfig: boolean;

    FConfigPath: string;
    FConfigFile: TXMLConfig;
   Public
    constructor Create;
    destructor destroy;
    Function FlushPluginConfig: boolean;
    Function add(dllname: String): boolean;
    Procedure ScanPluginFolder;
    Procedure SendEvent(event: TCactusEvent; msg: string);
    property Items[index: integer]: TPlugInListItemClass read GetItems;
    PluginFolder: string;
    autoload: boolean;
    //reload all previous loaded plugins if found during ScanPluginFolder
  End;
{ TPluginListClass }

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Var CactusPlugins: TPluginListClass;


  Implementation

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TPluginListClass }
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Function TPluginListClass.GetItems(index: integer): TPlugInListItemClass;
Begin
  result := TPluginListItemClass(Inherited items[index]);
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Function TPluginListClass.ReadPluginConfig: boolean;

Var i: integer;
Begin
  For i:=0 To Count-1 Do
    Begin
      Items[i].Enabled := FConfigFile.GetValue('Plugin/'+Items[i].LibName+'/Enabled', true);
    End;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Function TPluginListClass.FlushPluginConfig: boolean;

Var i: integer;
Begin
  //writeln('pluginconfig');
  For i:=0 To Count-1 Do
    If Items[i].FEnabled Then
      Begin
        FConfigFile.SetValue('Plugin/'+Items[i].LibName+'/Enabled', true);
      End
    Else
      FConfigFile.SetValue('Plugin/'+Items[i].LibName+'/Enabled', false);
  FConfigFile.Flush;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TPluginListClass.Create;
Begin
  inherited create;

  FConfigPath := CactusConfig.DataPrefix+'plugins.cfg';
  FConfigFile := TXMLConfig.Create(Nil);
  FConfigFile.Filename := FConfigPath;

End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

destructor TPluginListClass.destroy;

Var i: integer;
Begin
  FlushPluginConfig;
  FConfigFile.Free;
  writeln('free plugins');
  For i:= 0 To Count-1 Do
    Items[i].Free;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Function TPluginListClass.add(dllname: String): boolean;

Var   listitem: TPluginListItemClass;
Begin

  listitem := TPluginListItemClass.Create;

  If listitem.ReadPlugin(dllname) Then
    Begin
      Inherited add(listitem);
      result := true;
    End
  Else
    Begin
      result := false;
      listitem.Free;
    End;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Procedure TPluginListClass.ScanPluginFolder;

Var srchstring: string;
  srchRec: TSearchRec;
Begin

  Clear;
 {$ifdef Linux}
  srchstring := PluginFolder+'lib*.so';
 {$endif}
 {$ifdef windows}
  srchstring := PluginFolder+'*.dll';
 {$endif}
  If FindFirst(srchstring, faAnyFile, srchRec) = 0 Then
    Begin
      Repeat
        Begin
          write('Reading '+PluginFolder+srchRec.Name+' ... ');
          add(PluginFolder+srchRec.Name);
          writeln('done');
        End;
      Until FindNext(srchRec)<>0;
      FindClose(srchRec);
    End;
  ReadPluginConfig;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Procedure TPluginListClass.SendEvent(event: TCactusEvent; msg: string);

Var i: integer;
    p: PChar;
Begin
  writelN('Sendevent');

  p:=StrAlloc(length(msg)+1);
  StrPCopy(p, msg);

  For i:= 0 To Count-1 Do
    If Items[i].enabled Then Items[i].PluginHandle.EventHandler(event, p);
    writeln('end');
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Procedure TPluginListItemClass.setEnabled(aValue: boolean);
Begin
  If (FEnabled=false) And (aValue=true) Then loadPlugin
  Else unloadPlugin;
  FEnabled := aValue;

End;


{ TPluginListItemClass }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
constructor TPluginListItemClass.create;
Begin
  FEnabled := false;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

destructor TPluginListItemClass.destroy;
Begin
  unloadPlugin;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Function TPluginListItemClass.ReadPlugin(pluginpath: String): boolean;

Var GetInfoProcAdress: TGetPluginInfoProc;
  PluginInfo: TPluginInfoRec;
Begin
  Try
    If FileExists(pluginpath) Then write('ok ');
  //   FLibraryHandle := LoadLibrary('/usr/lib/libzip.so.1.0.0');
    FLibraryHandle := LoadLibrary(pluginpath);
  Except;
    result := false;
    writeln('eeeeee');
    exit;
  End;

  If FLibraryHandle=NilHandle Then
    Begin
      write('failed...');
      result := false;
      exit;
    End;

  Try
    GetInfoProcAdress := TGetPluginInfoProc(GetProcAddress(FLibraryHandle, 'GetPluginInfo'));

    If GetInfoProcAdress<>Nil Then
      PluginInfo := GetInfoProcAdress()
    Else
      Begin
        write('wrong plugin type...');
        result := false;
        exit;
      End;

    FName := StrPas(PluginInfo.Name);
    FLibName := ExtractFileName(pluginpath);
    FLibPath := IncludeTrailingPathDelimiter(ExtractFileDir(pluginpath));
    FAuthor := StrPas(PluginInfo.Author);
    FVersion := StrPas(PluginInfo.Version);
    FComment := StrPas(PluginInfo.Comment);
    result := true;
    //finally
  Except
    If UnloadLibrary(FLibraryHandle)=true Then write('succes')
    Else write('failed');
  End;

End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Function TPluginListItemClass.loadPlugin: boolean;

Var LoadAddr: TLoadPlugIn;
  SetObjectConAdrr: TSetObjectConnections;
Begin
  write('Loading plugin '+FLibName+'...');
  Try
    If FileExists(FLibPath+FLibName) Then write(' ok ')
    Else writeln(' error '+FLibPath+FLibName);
    FLibraryHandle := LoadLibrary(FLibPath+FLibName);
  Except;
    result := false;
    writeln('file not found');
    exit;
  End;
  LoadAddr := Nil;
  Try
    LoadAddr := TLoadPlugIn(GetProcAddress(FLibraryHandle, 'LoadPlugin'));
    LoadAddr(FPluginHandle);
   // SetObjectConAdrr := TSetObjectConnections(GetProcAddress(FLibraryHandle, 'SetObjectConnections')
                        //);
   // writeln(PlayerObj.CurrentTrack);
   // SetObjectConAdrr(@PlayerObj);

    writeln('done');
  Except
    writeln('error loading object!');
  End;

End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Function TPluginListItemClass.unloadPlugin: boolean;
Begin
  FPluginHandle.Free;
  UnloadLibrary(FLibraryHandle);
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

End.
