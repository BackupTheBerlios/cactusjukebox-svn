//******************************************************************************
//***                     Cactus Jukebox                                     ***
//***                                                                        ***
//***        (c) Massimo Magnano 2002-2005                                   ***
//***                                                                        ***
//***                                                                        ***
//******************************************************************************
//  File        : CJ_Interfaces.pas
//
//  Description : Interfaces declaration that can be accessed by a plugin.
//
//******************************************************************************
unit cj_interfaces;
{$mode delphi}{$H+}
interface

const
     //Icon States
     STATE_NORMAL      = 0;
     STATE_SELECTED    = 1;
     STATE_DISABLED    = 2;
     STATE_HIGHLIGHTED = 3;
     STATE_DOWN        = 4;

     //Options Categories
     OPT_CAT_LANGUAGE  = 1;

     //MenuItem IDs
     CJ_MENUITEM_MAIN  = -1;
     CJ_MENUITEM_NULL  = -2;

     MSG_ICON_IMGLIST = -1;  // MSG_ICON_IMGLIST-MyIndex -> MyIndex in ADefImageList


type
    TCJ_MenuItem = Integer;

    TCJ_MenuItemClick = procedure (Sender :TCJ_MenuItem) of object;

//(EN) Strange behavior of the abstract classes:
    //    In order to maintain compatibility with older plugins, new methods in the
    //    abstract class must always be declared to the last, while in deployment can have any order.
    //    Obviously research in VT class method is not done by name but by position.
//(IT) Comportamento strano delle classi astratte :
    //    Per poter mantenere la compatibilità con i vecchi plugin, i nuovi metodi
    //    nella classe astratta devono essere dichiarati sempre per ultimi, mentre
    //    nell' implementazione posso avere qualunque ordine.
    //    Evidentemente la ricerca nella VT della classe di un metodo non viene fatta per nome ma per posizione.
    TCJ_PluginsMenu = class
    public
       function Add(Parent :TCJ_MenuItem;
                    Caption :PChar; OnClick :TCJ_MenuItemClick) :TCJ_MenuItem; virtual; abstract;
       function AddSeparator(Parent :TCJ_MenuItem) :TCJ_MenuItem; virtual; abstract;
       function Remove(MenuItem :TCJ_MenuItem) :Boolean; virtual; abstract;

       function SetCaption(MenuItem :TCJ_MenuItem;
                           NewCaption :PChar):PChar; virtual; abstract;
       function SetEnabled(MenuItem :TCJ_MenuItem; Value :Boolean):Boolean; virtual; abstract;
       function SetChecked(MenuItem :TCJ_MenuItem; Value :Boolean):Boolean; virtual; abstract;
       function SetIcon(MenuItem :TCJ_MenuItem;
                        State, NewIcon :Integer):Integer; virtual; abstract;
       function SetOnClick(MenuItem :TCJ_MenuItem;
                           NewOnClick :TCJ_MenuItemClick):TCJ_MenuItemClick; virtual; abstract;

       function GetCount(MenuItem :TCJ_MenuItem) :Integer; virtual; abstract;
       function GetItem(MenuItem :TCJ_MenuItem; Index :Integer) :TCJ_MenuItem; virtual; abstract;
       function GetCaption(MenuItem :TCJ_MenuItem; Buffer :PChar) :Integer; virtual; abstract;
       function GetEnabled(MenuItem :TCJ_MenuItem) :Boolean; virtual; abstract;
       function GetChecked(MenuItem :TCJ_MenuItem) :Boolean; virtual; abstract;
       function GetIcon(MenuItem :TCJ_MenuItem; State :Integer):Integer; virtual; abstract;
       function GetOnClick(MenuItem :TCJ_MenuItem):TCJ_MenuItemClick; virtual; abstract;
    end;

    TCJ_TrayIcon = class
    public
       procedure AddNotificationIcon(Icon :Integer; //-xxx = Predefs Icons, +xxx = User Icon
                            Sound :PChar;           //%GT-SOUNDS%Predefs Sounds, x:\mmmmm
                            ShowEverySec :Integer;
                            DelAfterSec :Integer    //-1 = when tray menù appear, 0 = manual
                            ); virtual; abstract;
       procedure ShowNotification(AImageList :Integer; Icon :Integer; Msg :PChar; Sound :PChar); virtual; abstract;
       procedure PlaySound(Sound :PChar); virtual; abstract;
    end;

    TCJ_Interface = class
    public
       function GetPluginsMenu : TCJ_PluginsMenu; virtual; abstract;
       function GetTrayIcon : TCJ_TrayIcon; virtual; abstract;
       function GetOption(OptionCategoryID :Integer; OptionID :Integer;
                          Buffer :Pointer):Integer; virtual; abstract;
    end;

implementation

end.
