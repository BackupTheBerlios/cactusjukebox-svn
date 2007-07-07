{
Directory dialog for Cactus Jukebox

written by Sebastian Kraft, <c> 2006

Contact the author at: sebastian_kraft@gmx.de

This Software is published under the GPL






}


unit directories;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, CheckLst, StdCtrls;

type

  { Tdirwin }

  Tdirwin = class(TForm)
    add: TButton;
    Button1: TButton;
    dirlistview: TListBox;
    removebut: TButton;
    rescan: TButton;
    rescanall: TButton;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure addClick(Sender: TObject);
    procedure removeClick(Sender: TObject);
    procedure rescanClick(Sender: TObject);
    procedure rescanallClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  dirwin: Tdirwin;

implementation
uses mp3,status,mediacol, settings;
{ Tdirwin }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tdirwin.FormCreate(Sender: TObject);
var i:integer;
begin
   dirlistview.Clear;
   for i:= 0 to MediaCollection.dirlist.Count-1 do begin
               dirlistview.Items.Add(MediaCollection.dirlist[i]);
      end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tdirwin.addClick(Sender: TObject);
var listitem:TListitem;
    tmps: string;
    i: integer;
begin
  SelectDirectoryDialog1.InitialDir:=CactusConfig.HomeDir;


  If SelectDirectoryDialog1.Execute=true then begin
    for i:= 0 to MediaCollection.dirlist.Count-1 do begin
            if pos(MediaCollection.dirlist[i], SelectDirectoryDialog1.FileName)=1 then begin
                      ShowMessage('Directory '+SelectDirectoryDialog1.FileName+' is still part of directorylist');
                      exit;
             end;
       end;
     Caption:='Please wait... Scanning...';
     Enabled:=false;
     Application.ProcessMessages;
     MediaCollection.add_directory(SelectDirectoryDialog1.FileName);
     dirlistview.Items.Add(SelectDirectoryDialog1.FileName);

     if MediaCollection.ItemCount>1 then begin
                Main.ArtistTree.Selected:=nil;
                update_artist_view;
                update_title_view;
      end;
     Caption:='Directories';
     Enabled:=true;
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tdirwin.removeClick(Sender: TObject);
var removedir: string;
    tmpc: char;
    i, z, n:integer;
begin

     removedir:=dirlistview.Items[dirlistview.ItemIndex];
     if removedir[length(removedir)]=DirectorySeparator then delete(removedir,length(removedir), 1);
     i:=0;

     repeat begin
            if pos(removedir, ExtractFileDir(MediaCollection.items[i].path))=1 then begin
               MediaCollection.remove(i);
               dec(i);
             end;
            inc(i);
         end;
      until i>=MediaCollection.ItemCount;
      MediaCollection.DirList.Delete(dirlistview.ItemIndex);
      dirlistview.Items.Delete(dirlistview.ItemIndex);

  Main.ArtistTree.Selected:=nil;
  update_artist_view;
  update_title_view;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tdirwin.rescanClick(Sender: TObject);
var rescandir: string;
    listitem:TListitem;
    i, z, n:integer;
begin
 for n:= 0 to dirlistview.Items.Count-1 do begin
   if dirlistview.Selected[n] then begin
    rescandir:=dirlistview.Items[n];
    dirlistview.show;
    if rescandir[length(rescandir)]=DirectorySeparator then delete(rescandir,length(rescandir), 1);
    i:=1;
    repeat begin
       if pos(rescandir, ExtractFileDir(MediaCollection.items[i].path))=1 then begin
             MediaCollection.remove(i);
             dec(i);
       end;
       inc(i);
    end;
    until i>=MediaCollection.ItemCount;
    MediaCollection.DirList.Delete(n);
    Caption:='Please wait... Scanning...';
    Enabled:=false;
    Application.ProcessMessages;
    MediaCollection.add_directory(rescandir);
   end;

  if MediaCollection.ItemCount>1 then begin
                Main.ArtistTree.Selected:=nil;
                update_artist_view;
                update_title_view;
    end;
  Caption:='Directories';
  Enabled:=true;
  end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tdirwin.rescanallClick(Sender: TObject);
var i: integer;
begin
  for i:= 0 to dirlistview.Items.Count-1 do dirlistview.Selected[i]:=true;
  rescanClick(nil);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tdirwin.Button1Click(Sender: TObject);
begin
  Close;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tdirwin.Button3Click(Sender: TObject);
begin

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

initialization
  {$I directories.lrs}

end.

