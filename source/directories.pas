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
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  dirwin: Tdirwin;

implementation
uses mp3file,mp3,status, settings;
{ Tdirwin }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tdirwin.FormCreate(Sender: TObject);
var Listitem:TListItem;
    tmps: string;
    i:integer;
begin
   tmps:='';
  // dirlistview.Clear;
   writeln(MediaCollection.dirlist);
   for i:= 1 to length(MediaCollection.dirlist) do begin
       if MediaCollection.dirlist[i]<>';' then tmps:=tmps+MediaCollection.dirlist[i]
          else begin
               dirlistview.Items.Add(tmps);

               writeln(tmps);
               writeln(i);
               tmps:='';
             end;
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
    tmps:='';
    for i:= 1 to length(MediaCollection.dirlist) do begin
       if MediaCollection.dirlist[i]<>';' then tmps:=tmps+MediaCollection.dirlist[i]
          else
            if pos(tmps, SelectDirectoryDialog1.FileName)=1 then begin
                      ShowMessage('Directory '+SelectDirectoryDialog1.FileName+' is still part of directorylist');
                      exit;
             end;
        end;
     Caption:='Please wait... Scanning...';
     Enabled:=false;
     Application.ProcessMessages;
     MediaCollection.dirlist:=MediaCollection.dirlist+SelectDirectoryDialog1.FileName+';';
     MediaCollection.add_directory(SelectDirectoryDialog1.FileName);
     dirlistview.Items.Add(SelectDirectoryDialog1.FileName);

     if MediaCollection.max_index>1 then begin
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
     dirlistview.Items.Delete(dirlistview.ItemIndex);
     if removedir[length(removedir)]=DirectorySeparator then delete(removedir,length(removedir), 1);
     i:=1;
     repeat begin
            if pos(removedir, ExtractFileDir(MediaCollection.lib[i].path))=1 then begin
               MediaCollection.remove_entry(i);
               dec(i);
             end;
            inc(i);
         end;
      until i>=MediaCollection.max_index;
     Delete(MediaCollection.dirlist, pos(removedir, MediaCollection.dirlist), length(removedir)+1);

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
            if pos(rescandir, ExtractFileDir(MediaCollection.lib[i].path))=1 then begin
               for z:=i to MediaCollection.max_index-2 do MediaCollection.lib[z]:=MediaCollection.lib[z+1];
               dec(MediaCollection.max_index);
               dec(i);
             end;
            inc(i);
         end;
      until i>=MediaCollection.max_index;
     Caption:='Please wait... Scanning...';
     Enabled:=false;
     Application.ProcessMessages;
     MediaCollection.add_directory(rescandir);
   end;

  if MediaCollection.max_index>1 then begin
                Main.ArtistTree.Selected:=nil;
                update_artist_view;
                update_title_view;
    end;
  Caption:='Directories';
  Enabled:=true;
  end;
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

