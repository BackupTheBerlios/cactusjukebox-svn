unit plugintypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TEventNotification = (evnFileNew, evnFileOpen, evnFileSave, evnFileSaveAs,
      evnCut, evnCopy, evnPaste, evnClose);


  TPluginInfoRec = record
	Name, Author, Version, Comment: pchar;
  end;

{ TCactusPlugInClass }
  TCactusPlugInClass = class
  public
    constructor Create(aParent: THandle);

    function GetName: pchar; virtual; stdcall; abstract;
    function GetVersion: pchar; virtual; stdcall; abstract;
    function GetAuthor: pchar; virtual; stdcall; abstract;
    function GetComment: pchar; virtual; stdcall; abstract;

    procedure Execute; virtual; stdcall; abstract;

    function EventHandler(EventNotification: TEventNotification): boolean;
        virtual; stdcall; abstract;
  end;
{ TCactusPlugInClass }

  TLoadPlugIn = function(Parent: THandle; var CactusPlugIn: TCactusPlugInClass): Boolean;
  TGetPluginInfoProc = function : TPluginInfoRec;


implementation

{ TCactusPlugInClass }

constructor TCactusPlugInClass.Create(aParent: THandle);
begin

end;

end.
