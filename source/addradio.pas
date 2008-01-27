unit addradio; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, EditBtn, streamcol, mainform;

type

  { TaddRadioForm }

  TaddRadioForm = class(TForm)
    BitBtn1: TBitBtn;
    AdvancedBtn: TButton;
    PlaylistURLEdit: TEdit;
    StreamUrlEdit: TEdit;
    StationNameEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    StationName: TLabel;
    procedure AdvancedBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure PlaylistURLEditClick(Sender: TObject);
    procedure StreamUrlEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    FAdvanced: boolean;
  public
    { public declarations }
  end; 

var
  addRadioForm: TaddRadioForm;

implementation

{ TaddRadioForm }

procedure TaddRadioForm.StreamUrlEditChange(Sender: TObject);
begin

end;

procedure TaddRadioForm.FormCreate(Sender: TObject);
begin
  Height:=115;
  FAdvanced:=false;
  AdvancedBtnClick(nil);
end;

procedure TaddRadioForm.AdvancedBtnClick(Sender: TObject);
begin
if FAdvanced=false then begin
  FAdvanced:=true;
  AdvancedBtn.Caption:='Reduced <<';
  Height:=220;
  StationName.Visible:=true;
  Label2.Visible:=true;
  StreamUrlEdit.Visible:=true;
  StationNameEdit.Visible:=true;
  PlaylistURLEdit.Enabled:=false;
 end else begin
{  FAdvanced:=false;
  AdvancedBtn.Caption:='Advanced >>';
  Height:=115;
  StationName.Visible:=false;
  Label2.Visible:=false;
  StreamUrlEdit.Visible:=false;
  StationNameEdit.Visible:=false;
  PlaylistURLEdit.Enabled:=true;}
 end;
end;

procedure TaddRadioForm.BitBtn1Click(Sender: TObject);
var i: integer;
begin
  if FAdvanced then begin
    i:=StreamCollection.add(StreamUrlEdit.Text, StationNameEdit.Text);
    writeln(StreamUrlEdit.Text);
  end else begin

  end;
  Main.update_artist_view;
  close;
end;

procedure TaddRadioForm.PlaylistURLEditClick(Sender: TObject);
begin
  if PlaylistURLEdit.Enabled then PlaylistURLEdit.Text:='';
end;

initialization
  {$I addradio.lrs}

end.

