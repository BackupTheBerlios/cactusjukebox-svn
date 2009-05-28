//******************************************************************************
//***                     Cactus Jukebox                                     ***
//***                                                                        ***
//***  (c) 2006-2009                                                         ***
//***                                                                        ***
//***  Sebastian Kraft, sebastian_kraft@gmx.de                               ***
//***  Massimo Magnano, maxm.dev@gmail.com                                   ***
//***                                                                        ***
//******************************************************************************
//  File        : global_vars.pas
//
//  Description : Common Global Vars of the project.
//
//******************************************************************************
unit global_vars;
{$mode delphi}{$H+}
interface

uses Controls, menus, ExtCtrls;

Const
     INI_PLUGINS ='plugins.ini';

Var
   AppMainMenu          :TMainMenu =Nil;
   AppTrayIcon          :TTrayIcon =Nil;
   ImageListNormal      :TImageList;
   ImageListHot         :TImageList;
   ImageListDis         :TImageList;
   PluginsSeparatorItem :TMenuItem=Nil;
   AppPath              :String;

procedure RegisterPlugin(Name, DLLFileName :String);

implementation

uses SysUtils, Forms, inifiles;


procedure RegisterPlugin(Name, DLLFileName :String);
Var
   theINI  :TIniFile;

begin
     theINI :=TIniFile.Create(AppPath+INI_PLUGINS);
     theINI.WriteString(Name, 'DLL', DLLFileName);
     theINI.Free;
end;

initialization
              AppPath :=paramstr(0);

end.
