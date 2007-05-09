{
Minimized Player View for Cactus Jukebox

written by Sebastian Kraft, <c> 2006

Contact the author at: sebastian_kraft@gmx.de

This Software is published under the GPL






}


unit player;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, fmodplayer, mp3file, mp3, {messages,} ComCtrls, Menus;

type

  { Tplaywin }

  Tplaywin = class(TForm)
    BackgroundImg: TImage;
    AlbumCoverImg: TImage;
    ViewImg: TImage;
    PlayImg: TImage;
    StopImg: TImage;
    PauseImg: TImage;
    backImg: TImage;
    NextImg: TImage;
    ToolbarImg: TImage;
    OpenImg: TImage;
    InfoImg: TImage;
    MuteImg: TImage;
    textBackImg: TImage;
    TitleImg: TImage;
    TimeImg: TImage;
    TrackbarImg: TImage;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    popup_open: TMenuItem;
    file_info: TMenuItem;
    PopupMenu1: TPopupMenu;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormDestroy(Sender: TObject);
    procedure InfoImgClick(Sender: TObject);
    procedure InfoImgMouseEnter(Sender: TObject);
    procedure InfoImgMouseLeave(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
 //   procedure WMEraseBkgnd(var message:TWMEraseBkgnd); message  WM_ERASEBKGND;
    procedure Image1Click(Sender: TObject);
    procedure Image1Paint(Sender: TObject);
    procedure MuteImgClick(Sender: TObject);
    procedure MuteImgMouseEnter(Sender: TObject);
    procedure NextImgClick(Sender: TObject);
    procedure NextImgMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NextImgMouseEnter(Sender: TObject);
    procedure NextImgMouseLeave(Sender: TObject);
    procedure NextImgMouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OpenImgClick(Sender: TObject);
    procedure PauseImgClick(Sender: TObject);
    procedure PauseImgMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PauseImgMouseEnter(Sender: TObject);
    procedure PauseImgMouseLeave(Sender: TObject);
    procedure PauseImgMouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlayImgClick(Sender: TObject);
    procedure PlayImgMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlayImgMouseEnter(Sender: TObject);
    procedure PlayImgMouseLeave(Sender: TObject);
    procedure PlayImgMouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StopImgClick(Sender: TObject);
    procedure StopImgMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StopImgMouseEnter(Sender: TObject);
    procedure StopImgMouseLeave(Sender: TObject);
    procedure StopImgMouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ViewImgClick(Sender: TObject);
    procedure ViewImgMouseEnter(Sender: TObject);
    procedure ViewImgMouseLeave(Sender: TObject);
    procedure backImgClick(Sender: TObject);
    procedure backImgMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure backImgMouseEnter(Sender: TObject);
    procedure backImgMouseLeave(Sender: TObject);
    procedure backImgMouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure r(Sender: TObject);
    procedure MuteImgMouseLeave(Sender: TObject);
    procedure OpenImgMouseEnter(Sender: TObject);
    procedure OpenImgMouseLeave(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure file_infoClick(Sender: TObject);
    procedure openClick(Sender: TObject);
    procedure pauseClick(Sender: TObject);
    procedure playClick(Sender: TObject);
    procedure playwinClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure playwinCreate(Sender: TObject);
    procedure playwinKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure playwinKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure prevClick(Sender: TObject);
    procedure stopClick(Sender: TObject);
    procedure toggle_viewClick(Sender: TObject);
    procedure trackbarMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
    strg:boolean;
  public
    procedure draw_artist(a:string);
    procedure draw_title(t:string);
    
    { public declarations }
  end; 

var
  playwin: Tplaywin;

implementation
uses skin;

var mp3obj: TMp3fileobj ;
var tmpbmp: TBitmap;

{ Tplaywin }

{procedure TPlaywin.WMEraseBkgnd(var message:TWMEraseBkgnd);
begin
 message.result:=1;
end;}

procedure Tplaywin.MenuItem1Click(Sender: TObject);
begin

end;

procedure Tplaywin.FormDestroy(Sender: TObject);
begin

end;

procedure Tplaywin.InfoImgClick(Sender: TObject);
begin
  main.TrackInfoClick(nil);
end;

procedure Tplaywin.InfoImgMouseEnter(Sender: TObject);
begin
     InfoImg.Picture.LoadFromFile(SkinData.info.MouseOver);
end;

procedure Tplaywin.InfoImgMouseLeave(Sender: TObject);
begin
     InfoImg.Picture.LoadFromFile(SkinData.info.Img);
end;

procedure Tplaywin.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin

end;

procedure Tplaywin.MenuItem2Click(Sender: TObject);
begin
  main.MenuItem27Click(nil);
end;

procedure Tplaywin.MenuItem3Click(Sender: TObject);
begin
  main.save_listClick(nil);
end;

procedure Tplaywin.Image1Click(Sender: TObject);
begin
end;

procedure Tplaywin.Image1Paint(Sender: TObject);
begin

end;

procedure Tplaywin.MuteImgClick(Sender: TObject);
begin
  main.muteClick(nil);
end;

procedure Tplaywin.MuteImgMouseEnter(Sender: TObject);
begin
     MuteImg.Picture.LoadFromFile(SkinData.mute.MouseOver);
end;

procedure Tplaywin.NextImgClick(Sender: TObject);
begin
  main.nextClick(nil);
end;

procedure Tplaywin.NextImgMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  NextImg.Picture.LoadFromFile(SkinData.Pnext.Clicked);
end;

procedure Tplaywin.NextImgMouseEnter(Sender: TObject);
begin
  NextImg.Picture.LoadFromFile(SkinData.Pnext.MouseOver);
end;

procedure Tplaywin.NextImgMouseLeave(Sender: TObject);
begin
  NextImg.Picture.LoadFromFile(SkinData.Pnext.Img);
end;

procedure Tplaywin.NextImgMouseUp(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  NextImg.Picture.LoadFromFile(SkinData.Pnext.MouseOver);
end;

procedure Tplaywin.OpenImgClick(Sender: TObject);
begin
  main.openfileClick(nil);
end;

procedure Tplaywin.PauseImgClick(Sender: TObject);
begin
  main.pauseClick(nil);
end;

procedure Tplaywin.PauseImgMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PauseImg.Picture.LoadFromFile(SkinData.Ppause.Clicked);
end;

procedure Tplaywin.PauseImgMouseEnter(Sender: TObject);
begin
  PauseImg.Picture.LoadFromFile(SkinData.Ppause.MouseOver);
end;

procedure Tplaywin.PauseImgMouseLeave(Sender: TObject);
begin
  PauseImg.Picture.LoadFromFile(SkinData.Ppause.Img);
end;

procedure Tplaywin.PauseImgMouseUp(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PauseImg.Picture.LoadFromFile(SkinData.Ppause.MouseOver);
end;

procedure Tplaywin.PlayImgClick(Sender: TObject);
begin
  main.playClick(nil);
end;

procedure Tplaywin.PlayImgMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PlayImg.Picture.LoadFromFile(SkinData.Pplay.Clicked);
end;

procedure Tplaywin.PlayImgMouseEnter(Sender: TObject);
begin
  PlayImg.Picture.LoadFromFile(SkinData.Pplay.MouseOver);
end;

procedure Tplaywin.PlayImgMouseLeave(Sender: TObject);
begin
  PlayImg.Picture.LoadFromFile(SkinData.Pplay.Img);
end;

procedure Tplaywin.PlayImgMouseUp(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PlayImg.Picture.LoadFromFile(SkinData.Pplay.MouseOver);
end;

procedure Tplaywin.StopImgClick(Sender: TObject);
begin
  main.stopClick(nil);
end;

procedure Tplaywin.StopImgMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  StopImg.Picture.LoadFromFile(SkinData.Pstop.Clicked);
end;

procedure Tplaywin.StopImgMouseEnter(Sender: TObject);
begin
  StopImg.Picture.LoadFromFile(SkinData.Pstop.MouseOver);
end;

procedure Tplaywin.StopImgMouseLeave(Sender: TObject);
begin
  StopImg.Picture.LoadFromFile(SkinData.Pstop.Img);
end;

procedure Tplaywin.StopImgMouseUp(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  StopImg.Picture.LoadFromFile(SkinData.Pstop.MouseOver);
end;

procedure Tplaywin.ViewImgClick(Sender: TObject);
begin
  main.player_libClick(nil);
end;

procedure Tplaywin.ViewImgMouseEnter(Sender: TObject);
begin
     ViewImg.Picture.LoadFromFile(SkinData.view.MouseOver);
end;

procedure Tplaywin.ViewImgMouseLeave(Sender: TObject);
begin
     ViewImg.Picture.LoadFromFile(SkinData.view.Img);
end;

procedure Tplaywin.backImgClick(Sender: TObject);
begin
  main.prevClick(nil);
end;

procedure Tplaywin.backImgMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  backImg.Picture.LoadFromFile(SkinData.Pprevious.Clicked);
end;

procedure Tplaywin.backImgMouseEnter(Sender: TObject);
begin
  backImg.Picture.LoadFromFile(SkinData.Pprevious.MouseOver);
end;

procedure Tplaywin.backImgMouseLeave(Sender: TObject);
begin
  backImg.Picture.LoadFromFile(SkinData.Pprevious.Img);
end;

procedure Tplaywin.backImgMouseUp(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  backImg.Picture.LoadFromFile(SkinData.Pprevious.MouseOver);
end;

procedure Tplaywin.r(Sender: TObject);
begin

end;

procedure Tplaywin.MuteImgMouseLeave(Sender: TObject);
begin
     MuteImg.Picture.LoadFromFile(SkinData.mute.Img);
end;

procedure Tplaywin.OpenImgMouseEnter(Sender: TObject);
begin
     OpenImg.Picture.LoadFromFile(SkinData.open.MouseOver);
end;

procedure Tplaywin.OpenImgMouseLeave(Sender: TObject);
begin
     OpenImg.Picture.LoadFromFile(SkinData.open.Img);
end;

procedure Tplaywin.SpeedButton1Click(Sender: TObject);
begin
  main.nextClick(nil);
end;

procedure Tplaywin.SpeedButton2Click(Sender: TObject);
begin

end;

procedure Tplaywin.file_infoClick(Sender: TObject);
begin
     if (main.player.CurrentTrack)>=0 then begin
         main.playlist.selected:=main.playlist.Items[main.player.CurrentTrack-1];
         Main.MenuItem10Click(nil);
       end;
end;

procedure Tplaywin.openClick(Sender: TObject);
begin
  Main.openfileClick(nil);
end;

procedure Tplaywin.pauseClick(Sender: TObject);
begin
  main.pauseClick(nil);
  BackgroundImg.Canvas.Refresh;
end;

procedure Tplaywin.playClick(Sender: TObject);
begin
  Main.playClick(nil);
end;

procedure Tplaywin.playwinClose(Sender: TObject; var CloseAction: TCloseAction);
begin

{  BackgroundImg.Free;
  timeimage.Free;
  titleimg1.Free;
  titleimg2.Free;
  trackbar.Free;
  timeimage.Free;}
  AlbumCoverImg.Free;

  if main.playermode then begin
     main.Close;
   end;
end;

procedure Tplaywin.playwinCreate(Sender: TObject);
begin
with SkinData do begin
     BackgroundImg.canvas.Font.Color:=CLRED;
     
     BackgroundImg.AutoSize:=true;
     BackgroundImg.Picture.LoadFromFile(SkinData.Background.Img);
     
     ToolbarImg.Top:=Toolbar.y;
     ToolbarImg.Left:=Toolbar.x;
     ToolbarImg.Picture.LoadFromFile(SkinData.Toolbar.Img);
     ToolbarImg.AutoSize:=true;

     TrackbarImg.Top:=Trackbar.y;
     TrackbarImg.Left:=Trackbar.x;
     TrackbarImg.Picture.LoadFromFile(SkinData.Trackbar.Img);
     TrackbarImg.AutoSize:=true;
     
     TimeImg.Top:=Time.y;
     TimeImg.Left:=Time.x;
     TimeImg.Picture.LoadFromFile(SkinData.Time.Img);
     TimeImg.AutoSize:=true;
     
     TitleImg.Top:=Title.y;
     TitleImg.Left:=Title.x;
     TitleImg.Picture.LoadFromFile(SkinData.Title.Img);
     TitleImg.AutoSize:=true;
     
     AlbumCoverImg.top:=Title.y+3;
     AlbumCoverImg.left:=Title.x+ TitleImg.Picture.Width-55;
     AlbumCoverImg.Width:=TitleImg.Picture.Height-6;
     AlbumCoverImg.Height:=TitleImg.Picture.Height-6;
     AlbumCoverImg.Stretch:=true;

     textBackImg.Top:=TitleBack.y;
     textBackImg.Left:=TitleBack.x;
     textBackImg.Picture.LoadFromFile(SkinData.TitleBack.Img);
     textBackImg.AutoSize:=true;
     
     MuteImg.Top:=mute.y;
     MuteImg.Left:=mute.x;
     MuteImg.Picture.LoadFromFile(SkinData.mute.Img);
     MuteImg.AutoSize:=true;

     ViewImg.Top:=view.y;
     ViewImg.Left:=view.x;
     ViewImg.Picture.LoadFromFile(SkinData.view.Img);
     ViewImg.AutoSize:=true;
     
     OpenImg.Top:=Open.y;
     OpenImg.Left:=open.x;
     OpenImg.Picture.LoadFromFile(SkinData.open.Img);
     OpenImg.AutoSize:=true;
     
     InfoImg.Top:=info.y;
     InfoImg.Left:=info.x;
     InfoImg.Picture.LoadFromFile(SkinData.info.Img);
     InfoImg.AutoSize:=true;
     
     PlayImg.Top:=Pplay.y;
     PlayImg.Left:=Pplay.x;
     PlayImg.AutoSize:=true;
     PlayImg.Picture.LoadFromFile(Pplay.Img);

     PauseImg.Top:=Ppause.y;
     PauseImg.Left:=Ppause.x;
     PauseImg.AutoSize:=true;
     PauseImg.Picture.LoadFromFile(Ppause.Img);

     StopImg.Top:=Pstop.y;
     StopImg.Left:=Pstop.x;
     StopImg.AutoSize:=true;
     StopImg.Picture.LoadFromFile(PStop.Img);

     NextImg.Top:=Pnext.y;
     NextImg.Left:=Pnext.x;
     NextImg.AutoSize:=true;
     NextImg.Picture.LoadFromFile(Pnext.Img);

     backImg.Top:=Pprevious.y;
     backImg.Left:=Pprevious.x;
     backImg.AutoSize:=true;
     backImg.Picture.LoadFromFile(Previous.Img);
     
     AutoSize:=true;
     DoubleBuffered:=true;
   end;
end;

procedure Tplaywin.playwinKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  writeln(key);
  if key=113 then Main.player_libClick(nil);
  if key = 17 then strg:=true;
  if (strg=true) and (key=78) then Main.nextClick(nil);
  if (key=32) or ((strg=true) and (key=80)) then if Main.player.playing then Main.pauseClick(nil) else Main.playClick(nil);
  if (key=77) or ((strg=true) and (key=77)) then Main.muteClick(nil);
  if (strg=true) and (key=66) then Main.prevClick(nil);
end;

procedure Tplaywin.playwinKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=17 then strg:=false;
end;

procedure Tplaywin.prevClick(Sender: TObject);
begin
  main.prevClick(nil);
end;

procedure Tplaywin.stopClick(Sender: TObject);
begin
  main.stopClick(nil);
{  playwin.titleimg1.Picture.LoadFromFile(SKIN_DIR+'title.bmp');
  playwin.titleimg2.Picture.LoadFromFile(SKIN_DIR+'title.bmp');
  playwin.trackbar.Picture.LoadFromFile(SKIN_DIR+'trackbar.bmp');
  playwin.timeimage.Picture.LoadFromFile(SKIN_DIR+'time.bmp');}
end;

procedure Tplaywin.toggle_viewClick(Sender: TObject);
begin
  main.player_libClick(nil);
end;

procedure Tplaywin.trackbarMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var spos,slength:integer;
begin
  slength:=Main.player.get_filelength;
  spos:=(x*slength) div (200);
  Main.player.set_fileposition(spos);

end;

procedure Tplaywin.draw_artist(a: string);
begin
   {titleimg1.Picture.LoadFromFile(SKIN_DIR+'title.bmp');
   titleimg1.canvas.Font.Color:=Clnavy;
   titleimg1.canvas.textout(5,5,a);}

end;

procedure Tplaywin.draw_title(t: string);
begin
   {titleimg2.Picture.LoadFromFile(SKIN_DIR+'title.bmp');
   titleimg2.canvas.Font.Color:=Clnavy;
   titleimg2.canvas.textout(5,5,t);}
end;


initialization
  {$I player.lrs}

end.

