{
  Unit for showing DebugOutput

  written by Sebastian Kraft
  sebastian_kraft@gmx.de

  This software is free under the GNU Public License

  (c)2007
}

unit debug;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

var CVerbosityLevel: Integer;   //Current verbosity level.

{ Verbosity 0     -> absolutely no output
  Verbosity 1     -> standard output
  Verbosity 1..9  -> more specific output }

//DebugOut checks verbosity level and only outputs string s when it
//fits debug level.
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function DebugOutLn(s: string; level: integer):boolean;
function DebugOut(s: string; level: integer):boolean;
function DebugOutLn(s: integer; level: integer):boolean;
function DebugOut(s: integer; level: integer):boolean;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

implementation
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function DebugOutLn(s: string; level: integer): boolean;
begin
  if (CVerbosityLevel>0) and (CVerbosityLevel>=level) then begin
           writeln(s);
        end;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function DebugOut(s: string; level: integer): boolean;
begin
  if (CVerbosityLevel>0) and (CVerbosityLevel>=level) then begin
           write(s);
        end;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function DebugOutLn(s: integer; level: integer): boolean;
begin
  if (CVerbosityLevel>0) and (CVerbosityLevel>=level) then begin
           writeln(s);
        end;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function DebugOut(s: integer; level: integer): boolean;
begin
  if (CVerbosityLevel>0) and (CVerbosityLevel>=level) then begin
           write(s);
        end;
end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
end.

