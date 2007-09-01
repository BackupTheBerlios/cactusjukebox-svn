unit BigCoverImg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TBigCoverImg }

  TBigCoverImg = class(TForm)
    Image1: TImage;
    BackImg: TImage;
    procedure BackImgClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure Image1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  BigCoverImgForm: TBigCoverImg;

implementation
uses mainform;
{ TBigCoverImg }

procedure TBigCoverImg.Image1Click(Sender: TObject);
begin
  close;
end;

procedure TBigCoverImg.BackImgClick(Sender: TObject);
begin
 close;
end;

procedure TBigCoverImg.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  main.Enabled:=true;

end;

initialization
  {$I bigcoverimg.lrs}

end.

