library kopeteaway;

{$mode objfpc}{$H+}



uses
  Classes, SysUtils, plugintypes, dos;

type

  { TKopeteAwayMsgPlugin }

  TKopeteAwayMsgPlugin = class(TCactusPluginClass)
  public
    constructor Create;

    function GetName: pchar; override; stdcall;
    function GetVersion: pchar; override; stdcall;
    function GetAuthor: pchar; override; stdcall;
    function GetComment: pchar; override; stdcall;

    procedure Execute; override; stdcall;
    function EventHandler(Event: TCactusEvent): BOOLEAN;
        override; stdcall;
  end;

{ TKopeteAwayMsgPlugin }

CONST PluginInfo: TPluginInforec = (
	Name: 'Kopete Away Message Plugin';
	Author: 'Sebastian Kraft';
	Version: '0.1';
	Comment: 'This plugin automaticly puts the name of the currently played track'
                   +' into your Kopete away message'+LineEnding
                   +'(for example "listening to: Great band - Wonderful Song)';
	);



constructor TKopeteAwayMsgPlugin.Create;
begin

end;

function TKopeteAwayMsgPlugin.GetName: pchar;stdcall;
begin
     result:='Kopete Away Message Plugin';
end;

function TKopeteAwayMsgPlugin.GetVersion: pchar;stdcall;
begin
     result:='0.1';
end;

function TKopeteAwayMsgPlugin.GetAuthor: Pchar;stdcall;
begin
     result:='Sebastian Kraft';
end;

function TKopeteAwayMsgPlugin.GetComment: Pchar;stdcall;
begin
     result:='This plugin automaticly puts the name of the currently played track'
                   +' into your Kopete away message'+LineEnding
                   +'(for example "listening to: Great band - Wonderful Song)';
end;

procedure TKopeteAwayMsgPlugin.Execute;stdcall;
begin
end;

function TKopeteAwayMsgPlugin.EventHandler(Event: TCactusEvent): boolean;stdcall;
begin
   case Event of
     evnStartPlay: begin
	   exec('/usr/bin/dcop', 'kopete KopeteIface setAway "away"');
         end;
     evnStopPlay: begin
	   exec('/usr/bin/dcop', 'kopete KopeteIface setAvailable');
	 end;
   end;
end;

function LoadPlugin(var CactusPlugIn: TCactusPluginClass): Boolean; export;
begin
  try
    CactusPlugIn := TKopeteAwayMsgPlugin.Create;
    Result := True;
  except
    Result := False;
  end;
end;

function GetPluginInfo: TPluginInfoRec;export;
begin
  result:=PluginInfo;
end;


//exports LoadPlugIn name 'LoadPlugIn';

exports  GetPluginInfo;
exports  LoadPlugin;


begin
end.

