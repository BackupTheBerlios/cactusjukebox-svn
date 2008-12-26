unit plugintypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TCactusEvent = (
            evnStartPlay,
            evnStopPlay
            );


  TPluginInfoRec = record
	Name, Author, Version, Comment: pchar;
  end;

{ TCactusPlugInClass }
  TCactusPlugInClass = class
  public
    constructor Create;

    function GetName: pchar; virtual; stdcall; abstract;
    function GetVersion: pchar; virtual; stdcall; abstract;
    function GetAuthor: pchar; virtual; stdcall; abstract;
    function GetComment: pchar; virtual; stdcall; abstract;

    procedure Execute; virtual; stdcall; abstract;

    function EventHandler(Event: TCactusEvent; msg: PChar): boolean;
        virtual; stdcall; abstract;

  end;
{ TCactusPlugInClass }

  TLoadPlugIn = function(var CactusPlugIn: TCactusPlugInClass): Boolean;
  TGetPluginInfoProc = function : TPluginInfoRec;
  TSetObjectConnections =  procedure (PlayerObj:pointer);


implementation

{ TCactusPlugInClass }

constructor TCactusPlugInClass.Create;
begin

end;

end.
