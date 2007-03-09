unit convert;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { Tconvert }

  Tconvert = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure convertCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  convertwin: Tconvert;

implementation
uses mp3;
{ Tconvert }

procedure Tconvert.Button1Click(Sender: TObject);
begin

  Main.enabled:=true;
  destroy;
end;

procedure Tconvert.Button2Click(Sender: TObject);
begin

end;

procedure Tconvert.convertCreate(Sender: TObject);
begin

end;

initialization
  {$I convert.lrs}

end.

