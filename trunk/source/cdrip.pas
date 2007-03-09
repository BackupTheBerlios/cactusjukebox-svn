unit cdrip;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, Buttons, ExtCtrls, cddb, dos, Grids, DBCtrls, process;


resourcestring
  rsEncodeToMp3 = 'Encode to mp3';
  rsQuerryCDDB = 'Querry CDDB';
  rsLoad = 'Load';
  rsEject = 'Eject';
  rsStart = 'Start';
  rsBack = 'Back';
  rsSetID3Tag = 'Write ID3-Tags';
  rsCrSubfolders = 'Create artist subfolders';

type

  { Tcdrip }

  Tcdrip = class(TForm)
    bitratebox: TComboBox;
    FileNameType: TComboBox;
    Label2: TLabel;
    paranoia: TCheckBox;
    startbtn: TButton;
    backbtn: TButton;
    querrybtn: TButton;
    ejectbtn: TButton;
    loadbtn: TButton;
    Button6: TButton;
    encodecheck: TCheckBox;
    writetagscheck: TCheckBox;
    artistedit: TEdit;
    albumedit: TEdit;
    subfoldercheck: TCheckBox;
    drivebox: TComboBox;
    outputfolderbox: TComboBox;
    Label1: TLabel;
    LArtist: TLabel;
    LAlbum: TLabel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    Trackgrid: TStringGrid;
    Panel1: TPanel;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackgridHeaderClick(Sender: TObject; IsColumn: Boolean;
      index: Integer);
    procedure TrackgridMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrackgridSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean);
    procedure encodecheckChange(Sender: TObject);
    procedure startButClick(Sender: TObject);
  private
    { private declarations }
    Outputstring: TStringlist;
    Outputstream: TMemoryStream;
    RipProcess, EncodeProcess: TProcess;
  public
    { public declarations }
    ToRemove, ToRip, ToEncode: array[1..100] of boolean;
    OutFileNames: array[1..100] of string;
    RipTrack, EncodeTrack: byte;
    ripping, encoding: boolean;
    outfolder:string;
    CDDBcon: TCddbObject;
  end; 

var
  cdripwin: Tcdrip;


implementation
uses mp3file, mp3, translations;


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

{ Tcdrip }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tcdrip.Button1Click(Sender: TObject);
begin
     Button5Click(nil);
     if CDDBcon=nil then
        CDDBcon:=TCddbObject.create
       else begin
        Timer1.Enabled:=false;
        CDDBcon.destroy;
        CDDBcon:=TCddbObject.create;
       end;
     if CDDBcon.ReadTOC(CDDBcon.CDromDrives[drivebox.ItemIndex+1]) then begin
        CDDBcon.query(CDDBcon.CDromDrives[drivebox.ItemIndex+1], 'freedb.org', 8880);
        Timer1.Enabled:=true;
      end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tcdrip.Button2Click(Sender: TObject);
begin
  close;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tcdrip.Button4Click(Sender: TObject);
begin
{$ifdef linux}
   Exec('/usr/bin/eject',CDDBcon.CDromDrives[drivebox.ItemIndex+1]);
{$endif linux}
{$ifdef win32}
   Exec('eject.exe',CDDBcon.CDromDrives[drivebox.ItemIndex+1]);
{$endif win32}
   writeln('ATTENTION!! DIRTY! ejecting cdrom drive... ');
   Trackgrid.Clean([gzNormal, gzFixedCols]);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tcdrip.Button5Click(Sender: TObject);
var b, z:byte;
    tmps, s, t1, t2: string;
    ti1, ti2: integer;
begin
     Trackgrid.Clean([gzNormal, gzFixedCols]);
     if CDDBcon.ReadTOC(CDDBcon.CDromDrives[drivebox.ItemIndex+1]) then begin
        artistedit.Text:='Unknown';
        albumedit.Text:='Unknown';
        Trackgrid.RowCount:=1;
        Trackgrid.ColWidths[0]:=20;
        for b := 1 to CDDBcon.NrTracks do begin
            str(b, tmps);
            Trackgrid.RowCount:=Trackgrid.RowCount+1;
            Trackgrid.Cells[0,b]:=tmps;
            Trackgrid.Cells[1,b]:='Track '+tmps;
            z:=b;
            ti1:=(CDDBcon.TOCEntries[z+1].min)-(CDDBcon.TOCEntries[z].min);
            ti2:=(CDDBcon.TOCEntries[z+1].sec)-(CDDBcon.TOCEntries[z].sec);
            if ti2<0 then dec(ti1);
            ti2:=abs(ti2);
            str(ti1, t1);
            str(ti2, t2);
            if ti2<10 then t2:='0'+t2;
            Trackgrid.Cells[3,b]:=t1+':'+t2;
            end;
      end;
     Timer1.Enabled:=true;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tcdrip.CheckBox1Change(Sender: TObject);
begin
   
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tcdrip.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Timer1.Enabled:=false;
  RipProcess.free;
  EncodeProcess.free;
  Outputstream.free;
  Outputstring.free;
  Timer1.free;
  CDDBcon.destroy;
  main.Enabled:=true;
end;


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tcdrip.FormCreate(Sender: TObject);
var b, z:byte;
    tmps, s, t1, t2: string;
    ti1, ti2: integer;
begin
     TranslateUnitResourceStrings('cdrip', main.DataPrefix+'languages/cactus.%s.po', 'de', '');

     encodecheck.Caption:= Utf8ToAnsi(rsEncodeToMp3);
     LArtist.Caption:= Utf8ToAnsi(rsArtist);
     LAlbum.Caption:= Utf8ToAnsi(rsAlbum);
     querrybtn.Caption:= Utf8ToAnsi(rsQuerryCDDB);
     loadbtn.Caption:= Utf8ToAnsi(rsLoad);
     ejectbtn.Caption:= Utf8ToAnsi(rsEject);
     startbtn.Caption:= Utf8ToAnsi(rsStart);
     backbtn.Caption:= Utf8ToAnsi(rsBack);
     writetagscheck.Caption:= Utf8ToAnsi(rsSetID3Tag);
     subfoldercheck.Caption:= Utf8ToAnsi(rsCrSubfolders);
     


     tmps:=MediaCollection.dirlist;
     ripping:=false;
     RipProcess:=TProcess.Create(nil);
     EncodeProcess:=TProcess.Create(nil);
     Outputstring:=TStringList.Create;
     Outputstream:=TMemoryStream.Create;
        
     repeat begin
            s:=copy(tmps, 1, pos(';', tmps)-1);
            outputfolderbox.AddItem(s, nil);
            delete(tmps, 1, pos(';', tmps));
        end;
      until length(tmps)<2;
     outputfolderbox.ItemIndex:=0;
     CDDBcon:=TCddbObject.create;
     if CDDBcon.DriveCount>0 then begin
        for b:=1 to CDDBcon.DriveCount do drivebox.AddItem(CDDBcon.CDromDrives[b], nil);
        drivebox.ItemIndex:=0;
      end;

     if CDDBcon.ReadTOC(CDDBcon.CDromDrives[drivebox.ItemIndex+1]) then begin
        artistedit.Text:='Unknown';
        albumedit.Text:='Unknown';
        Trackgrid.Clean([gzNormal, gzFixedCols]);
     Trackgrid.Cells[1,0]:='Title';
     Trackgrid.Cells[2,0]:='Rip';
     Trackgrid.Cells[3,0]:='Length';
        Trackgrid.RowCount:=1;
        Trackgrid.ColWidths[0]:=20;
        for b := 1 to CDDBcon.NrTracks do begin
            str(b, tmps);
            Trackgrid.RowCount:=Trackgrid.RowCount+1;
            Trackgrid.Cells[0,b]:=tmps;
            Trackgrid.Cells[1,b]:='Track '+tmps;
            z:=b;
            ti1:=(CDDBcon.TOCEntries[z+1].min)-(CDDBcon.TOCEntries[z].min);
            ti2:=(CDDBcon.TOCEntries[z+1].sec)-(CDDBcon.TOCEntries[z].sec);
            if ti2<0 then dec(ti1);
            ti2:=abs(ti2);
            str(ti1, t1);
            str(ti2, t2);
            if ti2<10 then t2:='0'+t2;
            Trackgrid.Cells[3,b]:=t1+':'+t2;
          end;
      end;
     Timer1.Enabled:=true;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

{This timerevent is too confusing big and buggy. split in 2 timer objects -> one for IP communication and one for rip/encode status }

procedure Tcdrip.Timer1Timer(Sender: TObject);
var ListItem: TListItem;
    b:byte;
    tmps, tmps2:string;
    ledit:TEdit;
    editRect: TRect;
    ti1, ti2:integer;
    t1,t2: string;
    buf: array[0..256] of byte;
    i, n: integer;
begin

 if (ripping=false) and (encoding=false) then begin
  CDDBcon.callevents;
  if CDDBcon.data_ready then begin
     artistedit.Text:=CDDBcon.artist;
     albumedit.Text:=CDDBcon.album;
     Trackgrid.Clean([gzNormal, gzFixedCols]);
     Trackgrid.RowCount:=1;
     Trackgrid.ColWidths[0]:=20;
     for i:= 1 to length(CDDBcon.album) do begin write(byte(CDDBcon.album[i]));write('-'); end;
     writeln;
     for b:= 1 to CDDBcon.NrTracks do begin
         str(b, tmps);
         Trackgrid.RowCount:=Trackgrid.RowCount+1;
         Trackgrid.Cells[0,b]:=tmps;
         Trackgrid.Cells[1,b]:=CDDBcon.title[b];
         ti1:=(CDDBcon.TOCEntries[b+1].min)-(CDDBcon.TOCEntries[b].min);
         ti2:=(CDDBcon.TOCEntries[b+1].sec)-(CDDBcon.TOCEntries[b].sec);
         if ti2<0 then dec(ti1);
         ti2:=abs(ti2);
         str(ti1, t1);
         str(ti2, t2);
         if ti2<10 then t2:='0'+t2;
         Trackgrid.Cells[3,b]:=t1+':'+t2;
     end;
     CDDBcon.data_ready:=false;
   end;
  end;
 if ripping and RipProcess.Running then begin
   Outputstream.Clear;
   Outputstream.SetSize(2048);
   i:=(RipProcess.OutPut.Read(Outputstream.Memory^, 2048));
   Outputstream.SetSize(i);
   if i>5 then begin
      Outputstring.clear;
      Outputstring.LoadFromStream(Outputstream);
      tmps:=copy(Outputstring.Strings[Outputstring.Count-1], pos('%', Outputstring.Strings[Outputstring.Count-1])-3, 3);
      Trackgrid.Cells[2,RipTrack]:=tmps+'%';
      // Uncomment for Debug if Outputstring.Count>0 then for n:= 1 to Outputstring.Count-1 do {if pos('(==',Outputstring.Strings[n])>0 then }writeln(Outputstring.Strings[n]);
    end;
 end;
 if (ripping) and (RipProcess.Running=false) then begin
    if ToEncode[RipTrack] then begin
         encoding:=true;
         EncodeTrack:=RipTrack;
         str(EncodeTrack, tmps);
         if EncodeTrack<10 then tmps:='0'+tmps;
         if FileNameType.ItemIndex=0 then OutFileNames[EncodeTrack]:=outfolder+'/'+tmps+' - '+artistedit.Text+' - '+Trackgrid.Cells[1, EncodeTrack]+'.mp3';
         if FileNameType.ItemIndex=1 then OutFileNames[EncodeTrack]:=outfolder+'/'+artistedit.Text+' - '+Trackgrid.Cells[1, EncodeTrack]+'.mp3';
         if FileNameType.ItemIndex=2 then OutFileNames[EncodeTrack]:=outfolder+'/'+artistedit.Text+' - '+inttostr(EncodeTrack)+' - '+Trackgrid.Cells[1, EncodeTrack]+'.mp3';
         OutFileNames[EncodeTrack]:=StringReplace(OutFileNames[EncodeTrack], #39, '', [rfReplaceAll]);
         writeln(OutFileNames[EncodeTrack]);
         EncodeProcess.CommandLine:='/usr/bin/lame -h -b'+bitratebox.Items[bitratebox.ItemIndex]+' --tt "'+Trackgrid.Cells[1, EncodeTrack]+'" --ta "'+artistedit.Text+'" --tl "'+albumedit.Text+'" --tn '+tmps+' "'+outfolder+'/Track'+tmps+'.wav"'+' "'+OutFileNames[EncodeTrack]+'"';
         writeln(EncodeProcess.CommandLine);
         Caption:='Encoding Track '+inttostr(EncodeTrack)+' ...';
         EncodeProcess.Options:=[poUsePipes, poStderrToOutPut];
         EncodeProcess.Execute;
         encoding:=true;
         ripping:=false;
         Timer1.Enabled:=true;
        end
       else begin
        encoding:=false;
        i:=0;
        str(Riptrack, tmps);
        if RipTrack<10 then tmps:='0'+tmps;
        if ToRemove[RipTrack] then begin
              DeleteFile(outfolder+'/Track'+tmps+'.wav');
              DeleteFile(outfolder+'/Track'+tmps+'.inf');
              writeln('delete '+outfolder+'/Track'+tmps+'.wav');
           end;
        repeat inc(i) until (ToRip[i]=true) or (i>CDDBcon.NrTracks);


        if i<=CDDBcon.NrTracks then begin
           Trackgrid.Cells[2,i]:='0%';
           ToRip[i]:=false;
           ToRemove[RipTrack]:=false;
           Trackgrid.Cells[2,RipTrack]:='100%';
           RipTrack:=i;
           str(i, tmps);
           if i<10 then tmps:='0'+tmps;
           if paranoia.Checked then
              RipProcess.CommandLine:='/usr/bin/cdda2wav -paranoia -D'+CDDBcon.Device+' -t '+tmps+' '''+outfolder+'/Track'+tmps+'.wav'''
              else
              RipProcess.CommandLine:='/usr/bin/cdda2wav -D'+CDDBcon.Device+' -t '+tmps+' '''+outfolder+'/Track'+tmps+'.wav''';
           RipProcess.Options:=[poUsePipes,poStderrToOutPut, poDefaultErrorMode];
           Caption:='Ripping Track '+tmps+' ...';
           writeln('Ripping Track '+tmps);
           RipProcess.Execute;
           Timer1.Enabled:=true;
         end else begin
           writeln('Finished all tracks');
           Trackgrid.Cells[2,RipTrack]:='100%';
           Caption:='CD Rip... < Finished >';
           Trackgrid.Enabled:=true;
           Timer1.Enabled:=false;
           update_artist_view;
           update_title_view;
           ripping:=false;
           encoding:=false;
           ShowMessage('Ripping and encoding finished');
         end;
     end;
   end;
   If encoding and EncodeProcess.Running and ToEncode[RipTrack] then begin
      Outputstream.Clear;
      Outputstream.SetSize(1024);
      i:=(EncodeProcess.OutPut.Read(Outputstream.Memory^, 1024));
      Outputstream.SetSize(i);
      //writeln(i);
      if i>0 then begin
         Outputstring.clear;
         Outputstring.LoadFromStream(Outputstream);
         tmps:=copy(Outputstring.Strings[Outputstring.Count-1], pos('%', Outputstring.Strings[Outputstring.Count-1])-2, 2);
     //    writeln(tmps);
         Trackgrid.Cells[2,EncodeTrack]:=tmps+'%';
         Application.ProcessMessages;
        //if Outputstring.Count>0 then for n:= 1 to Outputstring.Count-1 do {if pos('(==',Outputstring.Strings[n])>0 then }writeln(Outputstring.Strings[n]);
       end;
    end;
    
   If encoding and (EncodeProcess.Running=false) {and (ToEncode[RipTrack]=false)} then begin
        ripping:=true;
        encoding:=false;
        ToEncode[RipTrack]:=false;
        writeln('adding file');
        MediaCollection.add_file(OutFileNames[EncodeTrack]);
     end;
end;

procedure Tcdrip.TrackgridHeaderClick(Sender: TObject; IsColumn: Boolean;
  index: Integer);
var row: integer;
begin
  if index = 2 then begin
     for row:=1 to Trackgrid.RowCount-1 do if Trackgrid.Cells[2, row]='' then Trackgrid.Cells[2, row]:='x' else Trackgrid.Cells[2, row]:='';
  end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tcdrip.TrackgridMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tcdrip.TrackgridSelectCell(Sender: TObject; Col, Row: Integer;
  var CanSelect: Boolean);
begin
  if col=2 then if Trackgrid.Cells[2, row]='' then Trackgrid.Cells[2, row]:='x' else Trackgrid.Cells[2, row]:='';
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tcdrip.encodecheckChange(Sender: TObject);
begin
    if EncodeCheck.Checked then begin
     writetagscheck.Enabled:=true;
     subfoldercheck.Enabled:=true;
     bitratebox.enabled:=true;
   end else begin
     writetagscheck.Enabled:=false;
     subfoldercheck.Enabled:=false;
     bitratebox.enabled:=false;
   end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure Tcdrip.startButClick(Sender: TObject);
var row: integer;
begin
  outfolder:=outputfolderbox.Items[outputfolderbox.ItemIndex];
  if subfoldercheck.Checked then outfolder:=outfolder+DirectorySeparator+artistedit.Text;
  if DirectoryExists(outfolder)=false then mkdir(outfolder);
  for i:= 1 to CDDBcon.NrTracks do begin
      if Trackgrid.Cells[2,i]='x' then ToRip[i]:=true;
    end;
  i:=0;
  if encodecheck.Checked then ToEncode:=ToRip;
  ToRemove:=ToRip;
  repeat inc(i) until (ToRip[i]=true) or (i>CDDBcon.NrTracks);
  if i<=CDDBcon.NrTracks then begin
    if FileExists('/usr/bin/cdda2wav') then begin {NOT PORTABLE!!!}
      Trackgrid.Enabled:=false;
      Trackgrid.Cells[2,i]:='0%';
      ToRip[i]:=false;
      RipTrack:=i;
      str(i, tmps);
      if i<10 then tmps:='0'+tmps;

      if paranoia.Checked then
         RipProcess.CommandLine:='/usr/bin/cdda2wav -paranoia -D'+CDDBcon.Device+' -t '+tmps+' "'+outfolder+'/Track'+tmps+'.wav"'
        else
         RipProcess.CommandLine:='/usr/bin/cdda2wav -D'+CDDBcon.Device+' -t '+tmps+' "'+outfolder+'/Track'+tmps+'.wav"';
      RipProcess.Options:=[poUsePipes, poStderrToOutPut, poDefaultErrorMode];
      writeln('Ripping Track '+tmps);
      Caption:='Ripping Track '+tmps+' ...';
      RipProcess.Execute;
      Timer1.Enabled:=true;
      ripping:=true;
     end else ShowMessage('ERROR: cdda2wav executable not found. Please install cdda2wav package first...');
    end else if MessageDlg('No tracks selected. Rip complete disc?', mtWarning, mbOKCancel, 0)=mrOK then begin
               for row:=1 to Trackgrid.RowCount-1 do if Trackgrid.Cells[2, row]='' then Trackgrid.Cells[2, row]:='x' else Trackgrid.Cells[2, row]:='';
               startButClick(nil);
             end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

initialization
  {$I cdrip.lrs}

end.

