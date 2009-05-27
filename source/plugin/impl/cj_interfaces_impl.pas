//******************************************************************************
//***                     Cactus Jukebox                                     ***
//***                                                                        ***
//***  (c) 2006-2009                                                         ***
//***                                                                        ***
//***  Sebastian Kraft, sebastian_kraft@gmx.de                               ***
//***  Massimo Magnano, maxm.dev@gmail.com                                   ***
//***                                                                        ***
//******************************************************************************
//  File        : cj_interfaces_impl.pas
//
//  Description : Implementation of the Interfaces
//                that can be accessed by a plugin.
//
//******************************************************************************

unit cj_interfaces_impl;
{$mode delphi}{$H+}
interface

uses cj_interfaces, Classes, Controls;

type
    TCJ_PluginsMenu_Impl = class(TCJ_PluginsMenu)
    private
       procedure MenuItemClick(Sender :TObject);
    public
       function Add(Parent :TCJ_MenuItem;
                    Caption :PChar; OnClick :TCJ_MenuItemClick) :TCJ_MenuItem; override;
       function AddSeparator(Parent :TCJ_MenuItem) :TCJ_MenuItem; override;
       function Remove(MenuItem :TCJ_MenuItem) :Boolean; override;

       function SetCaption(MenuItem :TCJ_MenuItem;
                           NewCaption :PChar):PChar; override;
       function SetEnabled(MenuItem :TCJ_MenuItem; Value :Boolean):Boolean; override;
       function SetChecked(MenuItem :TCJ_MenuItem; Value :Boolean):Boolean; override;
       function SetIcon(MenuItem :TCJ_MenuItem;
                        State, NewIcon :Integer):Integer; override;
       function SetOnClick(MenuItem :TCJ_MenuItem;
                           NewOnClick :TCJ_MenuItemClick):TCJ_MenuItemClick; override;

       function GetCount(MenuItem :TCJ_MenuItem) :Integer; override;
       function GetItem(MenuItem :TCJ_MenuItem; Index :Integer) :TCJ_MenuItem; override;
       function GetCaption(MenuItem :TCJ_MenuItem; Buffer :PChar) :Integer; override;
       function GetEnabled(MenuItem :TCJ_MenuItem) :Boolean; override;
       function GetChecked(MenuItem :TCJ_MenuItem) :Boolean; override;
       function GetIcon(MenuItem :TCJ_MenuItem; State :Integer):Integer; override;
       function GetOnClick(MenuItem :TCJ_MenuItem):TCJ_MenuItemClick; override;
    end;


    TCJ_TrayIcon_Impl = class(TCJ_TrayIcon)
    private
       procedure NotificationTitleMouseUp(Sender: TObject; Button: TMouseButton;
                                          Shift: TShiftState; X, Y: Integer);

    public
       procedure AddNotificationIcon(Icon :Integer;
                            Sound :PChar;
                            ShowEverySec :Integer;
                            DelAfterSec :Integer
                            ); override;
       procedure ShowNotification(AImageList :Integer; Icon :Integer; Msg :PChar; Sound :PChar); override;
       procedure PlaySound(Sound :PChar); override;
    end;

    
    TCJ_Interface_Impl = class(TCJ_Interface)
    private
       rPluginsMenu :TCJ_PluginsMenu_Impl;
       rTrayIcon    :TCJ_TrayIcon_Impl;
    public
       function GetPluginsMenu : TCJ_PluginsMenu; override;
       function GetTrayIcon : TCJ_TrayIcon; override;
       function GetOption(OptionCategoryID :Integer; OptionID :Integer;
                          Buffer :Pointer):Integer; override;

       constructor Create;
       destructor Destroy; override;
    end;

Var
   MenuOwner    :TComponent=Nil;
   CJ_Interface :TCJ_Interface_Impl=Nil;


implementation

uses SysUtils, menus, global_vars;

type
    PMethod =^TMethod;

    TMyMenuItem = class(TMenuItem)
    public
       pluginOnClick : TCJ_MenuItemClick;
    end;



//==============================================================================
//  TCJ_PluginsMenu_Impl = class(TCJ_PluginsMenu)
// Implementazione dell' Interfaccia al Menu dei Plugins
//==============================================================================

procedure TCJ_PluginsMenu_Impl.MenuItemClick(Sender :TObject);
Var
   PluginMethod :TCJ_MenuItemClick;

begin
  try
     if (Sender is TMyMenuItem) then
     begin
          //TMethod(PluginMethod).Data :=PMethod(TMenuItem(Sender).Tag)^.Data;
          //TMethod(PluginMethod).Code :=PMethod(TMenuItem(Sender).Tag)^.Code;
          //if Assigned(PluginMethod)
          if Assigned(TMyMenuItem(Sender).pluginOnClick)
          then TMyMenuItem(Sender).pluginOnClick(TMyMenuItem(Sender).Command);
     end;
  except
  end;
end;

function TCJ_PluginsMenu_Impl.Add(Parent :TCJ_MenuItem;
                    Caption :PChar; OnClick :TCJ_MenuItemClick) :TCJ_MenuItem;
Var
   NewItem        :TMyMenuItem;
   ParentMenuItem :TMenuItem;
   xCaption       :String;
   itemMethod     :PMethod;

begin
  Result :=CJ_MENUITEM_NULL;
  try
     if (AppMainMenu<>Nil) then
     begin
          if (Parent<>CJ_MENUITEM_MAIN)
          then begin
                    ParentMenuItem :=TMenuItem(AppMainMenu.FindItem(Parent, fkCommand));
                    if (ParentMenuItem=Nil)
                    then Exit;
               end;

          NewItem :=TMyMenuItem.Create(MenuOwner);
          xCaption :=Copy(Caption, 1, Length(Caption));
          NewItem.Caption :=xCaption;
          NewItem.OnClick :=MenuItemClick;

//          GetMem(itemMethod, sizeof(TMethod));
//          itemMethod^ :=TMethod(OnClick);
//          NewItem.Tag := Integer(itemMethod);
          NewItem.pluginOnClick :=OnClick;

          if (Parent=CJ_MENUITEM_MAIN)
          then AppMainmenu.Items.Insert(0, NewItem)
          else ParentMenuItem.Add(NewItem);

          Result :=NewItem.Command;
     end;
  except
     On E:Exception do Result :=CJ_MENUITEM_NULL;
  end;
end;

function TCJ_PluginsMenu_Impl.AddSeparator(Parent :TCJ_MenuItem) :TCJ_MenuItem;
begin
     Result :=Add(Parent, '-', Nil);
end;

function TCJ_PluginsMenu_Impl.Remove(MenuItem :TCJ_MenuItem) :Boolean;
Var
   curItem,
   toDelMenuItem :TMenuItem;
   i             :Integer;

begin
  Result :=False;
  try
     toDelMenuItem :=TMenuItem(AppMainMenu.FindItem(MenuItem, fkCommand));
     if (toDelMenuItem=Nil)
     then Exit;

     //Avoid delete of our Menu Item....
     i :=AppMainMenu.Items.Count-1;
     repeat
           curItem :=TMenuItem(AppMainMenu.Items[i]);
           if (curItem=toDelMenuItem)
           then Exit;
           Dec(i);
     Until (curItem=PluginsSeparatorItem) or (i=0);

     AppMainMenu.Items.Remove(toDelMenuItem);
     Result :=True;
  except
     On E:Exception do Result :=False;
  end;
end;

function TCJ_PluginsMenu_Impl.SetCaption(MenuItem :TCJ_MenuItem;
                           NewCaption :PChar):PChar;
Var
   toChangeMenuItem :TMyMenuItem;
   xCaption         :String;

begin
  Result :=Nil;
  try
     toChangeMenuItem :=TMyMenuItem(AppMainMenu.FindItem(MenuItem, fkCommand));
     if (toChangeMenuItem<>Nil) then
     begin
          xCaption :=Copy(NewCaption, 1, Length(NewCaption));
          toChangeMenuItem.Caption :=xCaption;
     end;
  except
     On E:Exception do Result :=Nil;
  end;
end;

function TCJ_PluginsMenu_Impl.SetEnabled(MenuItem :TCJ_MenuItem; Value :Boolean):Boolean;
Var
   toChangeMenuItem :TMyMenuItem;

begin
  Result :=False;
  try
     toChangeMenuItem :=TMyMenuItem(AppMainMenu.FindItem(MenuItem, fkCommand));
     if (toChangeMenuItem<>Nil) then
     begin
          Result :=toChangeMenuItem.Enabled;
          toChangeMenuItem.Enabled :=Value;
     end;
  except
     On E:Exception do Result :=False;
  end;
end;

function TCJ_PluginsMenu_Impl.SetChecked(MenuItem :TCJ_MenuItem; Value :Boolean):Boolean;
Var
   toChangeMenuItem :TMyMenuItem;

begin
  Result :=False;
  try
     toChangeMenuItem :=TMyMenuItem(AppMainMenu.FindItem(MenuItem, fkCommand));
     if (toChangeMenuItem<>Nil) then
     begin
          Result :=toChangeMenuItem.Checked;
          toChangeMenuItem.Checked :=Value;
     end;
  except
     On E:Exception do Result :=False;
  end;
end;


function TCJ_PluginsMenu_Impl.SetIcon(MenuItem :TCJ_MenuItem;
                              State, NewIcon :Integer):Integer;
Var
   toChangeMenuItem :TMyMenuItem;

begin
  Result :=-1;
  try
     toChangeMenuItem :=TMyMenuItem(AppMainMenu.FindItem(MenuItem, fkCommand));
     if (toChangeMenuItem<>Nil) then
     begin
     {
          Case State of
          STATE_NORMAL      :begin
                                  Result :=toChangeMenuItem.icoUnchecked;
                                  toChangeMenuItem.icoUnchecked :=NewIcon;
                             end;
          STATE_SELECTED    :begin
                                  Result :=toChangeMenuItem.icoSelected;
                                  toChangeMenuItem.icoSelected :=NewIcon;
                             end;
          STATE_DISABLED    :begin
                                  Result :=toChangeMenuItem.icoDisabled;
                                  toChangeMenuItem.icoDisabled :=NewIcon;
                             end;
          STATE_HIGHLIGHTED :begin
                                  Result :=toChangeMenuItem.icoHighlighted;
                                  toChangeMenuItem.icoHighlighted :=NewIcon;
                             end;
          STATE_DOWN        :begin
                                  Result :=toChangeMenuItem.icoChecked;
                                  toChangeMenuItem.icoChecked :=NewIcon;
                             end;
          end;
      }
     end;
  except
     On E:Exception do Result :=-1;
  end;
end;

function TCJ_PluginsMenu_Impl.SetOnClick(MenuItem :TCJ_MenuItem;
                           NewOnClick :TCJ_MenuItemClick):TCJ_MenuItemClick;
Var
   toChangeMenuItem :TMyMenuItem;
   PluginMethod     :TCJ_MenuItemClick;

begin
  Result :=Nil;
  try
     toChangeMenuItem :=TMyMenuItem(AppMainMenu.FindItem(MenuItem, fkCommand));
     if (toChangeMenuItem<>Nil) then
     begin
//          TMethod(PluginMethod).Data :=PMethod(toChangeMenuItem.Tag)^.Data;
//          TMethod(PluginMethod).Code :=PMethod(toChangeMenuItem.Tag)^.Code;
//          Result :=PluginMethod;
//          PMethod(toChangeMenuItem.Tag)^ := TMethod(NewOnClick);
            Result := toChangeMenuItem.pluginOnClick;
            toChangeMenuItem.pluginOnClick := NewOnClick;
     end;
  except
     On E:Exception do Result :=Nil;
  end;
end;

function TCJ_PluginsMenu_Impl.GetCount(MenuItem :TCJ_MenuItem) :Integer; 
Var
   toChangeMenuItem :TMyMenuItem;

begin
  Result :=-1;
  try
     toChangeMenuItem :=TMyMenuItem(AppMainMenu.FindItem(MenuItem, fkCommand));
     if (toChangeMenuItem<>Nil) then
     begin
          Result :=toChangeMenuItem.Count;
     end;
  except
     On E:Exception do Result :=-1;
  end;
end;

function TCJ_PluginsMenu_Impl.GetItem(MenuItem :TCJ_MenuItem; Index :Integer) :TCJ_MenuItem;
Var
   theParentMenuItem,
   toGetMenuItem      :TMenuItem;

begin
  Result :=CJ_MENUITEM_NULL;
  try
     theParentMenuItem :=TMenuItem(AppMainMenu.FindItem(MenuItem, fkCommand));
     if (theParentMenuItem<>Nil) then
     begin
          toGetMenuItem :=TMenuItem(theParentMenuItem.Items[Index]);
          if (toGetMenuItem<>Nil)
          then Result :=toGetMenuItem.Command;
     end;
  except
     On E:Exception do Result :=CJ_MENUITEM_NULL;
  end;
end;

function TCJ_PluginsMenu_Impl.GetCaption(MenuItem :TCJ_MenuItem; Buffer :PChar) :Integer;
Var
   toChangeMenuItem :TMyMenuItem;

begin
  Result :=0;
  try
     toChangeMenuItem :=TMyMenuItem(AppMainMenu.FindItem(MenuItem, fkCommand));
     if (toChangeMenuItem<>Nil) then
     begin
          Result :=Length(toChangeMenuItem.Caption)+1;
          if (Buffer<>Nil)
          then StrPLCopy(Buffer, toChangeMenuItem.Caption, Result-1);
     end;
  except
     On E:Exception do Result :=0;
  end;
end;

function TCJ_PluginsMenu_Impl.GetEnabled(MenuItem :TCJ_MenuItem) :Boolean;
Var
   toChangeMenuItem :TMyMenuItem;

begin
  Result :=False;
  try
     toChangeMenuItem :=TMyMenuItem(AppMainMenu.FindItem(MenuItem, fkCommand));
     if (toChangeMenuItem<>Nil) then
     begin
          Result :=toChangeMenuItem.Enabled;
     end;
  except
     On E:Exception do Result :=False;
  end;
end;

function TCJ_PluginsMenu_Impl.GetChecked(MenuItem :TCJ_MenuItem) :Boolean;
Var
   toChangeMenuItem :TMyMenuItem;

begin
  Result :=False;
  try
     toChangeMenuItem :=TMyMenuItem(AppMainMenu.FindItem(MenuItem, fkCommand));
     if (toChangeMenuItem<>Nil) then
     begin
          Result :=toChangeMenuItem.Checked;
     end;
  except
     On E:Exception do Result :=False;
  end;
end;


function TCJ_PluginsMenu_Impl.GetIcon(MenuItem :TCJ_MenuItem; State :Integer):Integer;
Var
   toChangeMenuItem :TMyMenuItem;

begin
  Result :=-1;
  try
     toChangeMenuItem :=TMyMenuItem(AppMainMenu.FindItem(MenuItem, fkCommand));
     if (toChangeMenuItem<>Nil) then
     begin
       {   Case State of
          STATE_NORMAL      :Result :=toChangeMenuItem.icoUnchecked;
          STATE_SELECTED    :Result :=toChangeMenuItem.icoSelected;
          STATE_DISABLED    :Result :=toChangeMenuItem.icoDisabled;
          STATE_HIGHLIGHTED :Result :=toChangeMenuItem.icoHighlighted;
          STATE_DOWN        :Result :=toChangeMenuItem.icoChecked;
          end;
        }
     end;
  except
     On E:Exception do Result :=-1;
  end;
end;

function TCJ_PluginsMenu_Impl.GetOnClick(MenuItem :TCJ_MenuItem):TCJ_MenuItemClick;
Var
   toChangeMenuItem :TMyMenuItem;
   PluginMethod     :TCJ_MenuItemClick;

begin
  Result :=Nil;
  try
     toChangeMenuItem :=TMyMenuItem(AppMainMenu.FindItem(MenuItem, fkCommand));
     if (toChangeMenuItem<>Nil) then
     begin
         // TMethod(PluginMethod).Data :=Pointer(toChangeMenuItem.Tag);
         // TMethod(PluginMethod).Code :=Pointer(toChangeMenuItem.Tag2);
         // Result :=PluginMethod;
         Result :=toChangeMenuItem.pluginOnClick;
     end;
  except
     On E:Exception do Result :=Nil;
  end;
end;

//==============================================================================
//  TCJ_TrayIcon_Impl = class(TCJ_TrayIcon)
// Implementazione dell'interfaccia alla Tray Icon & ai Messaggi
//==============================================================================
procedure TCJ_TrayIcon_Impl.AddNotificationIcon(Icon :Integer;
                            Sound :PChar;
                            ShowEverySec :Integer;
                            DelAfterSec :Integer
                            );
begin
end;

procedure TCJ_TrayIcon_Impl.ShowNotification(AImageList :Integer; Icon :Integer; Msg :PChar; Sound :PChar);
begin
     if (AImageList=-1)
     then AImageList :=global_vars.ImageListNormal.Handle;

(*     TTrayNotifications.ShowNotification(-1, 'Green Tree',
                                         Icon, Msg, Sound,
                                         AImageList,
                                         NotificationTitleMouseUp, Nil);
*)
end;

procedure TCJ_TrayIcon_Impl.PlaySound(Sound :PChar);
begin
end;

procedure TCJ_TrayIcon_Impl.NotificationTitleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
begin
     //AppTrayIcon.RunTNAPopup;
end;



//==============================================================================
//  TCJ_Interface_Impl = class(TCJ_Interface)
// Implementazione dell'interfaccia al Programma
//==============================================================================

function TCJ_Interface_Impl.GetPluginsMenu : TCJ_PluginsMenu;
begin
     Result :=rPluginsMenu;
end;

function TCJ_Interface_Impl.GetTrayIcon : TCJ_TrayIcon;
begin
     Result :=rTrayIcon;
end;

function TCJ_Interface_Impl.GetOption(OptionCategoryID :Integer; OptionID :Integer;
                                      Buffer :Pointer):Integer;

   procedure ReturnString(theString :String);
   begin
        Result :=Length(theString)+1;
        if (Buffer<>Nil)
        then begin
                  FillChar(PChar(Buffer)^, Result, 0);
                  StrPLCopy(PChar(Buffer), theString, Result-1);
             end;     
   end;

   procedure ReturnInteger(theInteger :Integer);
   begin
        Result :=theInteger;
   end;

begin
{     case OptionCategoryID of
     end;
}
end;

constructor TCJ_Interface_Impl.Create;
begin
     inherited Create;
     rPluginsMenu :=TCJ_PluginsMenu_Impl.Create;
     rTrayIcon :=TCJ_TrayIcon_Impl.Create;
end;

destructor TCJ_Interface_Impl.Destroy;
begin
     rPluginsMenu.Free;
     rPluginsMenu :=Nil;
     rTrayIcon.Free;
     rTrayIcon :=Nil;
end;


end.
