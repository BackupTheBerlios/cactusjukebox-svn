{ query FreeDB for audio cd title informations
  written by Sebastian Kraft
  sebastian_kraft@gmx.de

  This software is free under the GNU Public License

  (c)2005
}

unit cddb;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, CDrom, discid, lnet, config;


type

{ TCddbObject }

TCddbObject = class
     year, genre, artist, album: string;
     title: array[1..99] of string;
     ErrorMsg, Status, QueryString: string;
     CDromDrives : Array[1..10] of String;
     DriveCount, NrTracks: byte;
     Device: string;
     ErrorCode: Integer;
     TOCEntries: array[1..99] of TTocEntry;
     DiscID: integer;
     query_send, data_ready:boolean;
    function connect(server:string; port: word):boolean;
    procedure callevents;
    procedure query(drive, server:string; port: word);
    function ReadTOC(drive:string):boolean;
    constructor create;
    destructor destroy;
  private
    { private declarations }
    procedure OnReceiveProc(asocket: TLSocket);
    procedure OnErrorProc(const msg: string; asocket: TLSocket);
    procedure OnDisconnectProc(asocket: TLSocket);
    procedure OnConnectProc(asocket: TLSocket);
    Connection: TLTcp;
    FServer, FUser, FSoftware, FVersion, FHostname: string;
    FPort: word;
  public
    { public declarations }

  end;

implementation

uses functions;

type

  { TLEvents }

  TLEvents = class
   public
    procedure DsProc(aSocket: TLSocket);
    procedure ReProc(aSocket: TLSocket);
    procedure ErProc(const msg: string; aSocket: TLSocket);
  end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TLEvents }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TLEvents.DsProc(aSocket: TLSocket);
begin

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TLEvents.ReProc(aSocket: TLSocket);
begin

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TLEvents.ErProc(const msg: string; aSocket: TLSocket);
begin

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TCddbObject }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TCddbObject.connect(server: string; port: word): boolean;
begin

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TCddbObject.OnReceiveProc(asocket: TLSocket);
var  s, s1, s2, tmp: string;
     i,n: byte;
     deleted: boolean;
     posi: integer;
begin
     ErrorCode:=0;
     s:='';
     asocket.GetMessage(s);
     if s<>'' then begin
        if length(s)>3 then begin
             posi:=pos(#13, s);
             s1:=Copy(s, 1, 3);
             if (posi<>0) then s2:=Copy(s, posi+2, 3);
             try
               ErrorCode:=StrToInt(s1);
               Errorcode:=StrToInt(s2);
              except
              end;
           end;
        writeln('-------------------------------------------------');
        writeln(s);
        writeln(errorcode);
        writeln(s1);
        writeln(s2);
        writeln('-------------------------------------------------');
      end;

    if (ErrorCode=200) and query_send then begin
        delete(s, 1, 4);
        tmp:=copy(s, 1, pos(' ',s));
        delete(s, 1, pos(' ', s));
        s1:=copy(s, 1, pos(' ',s));
        Connection.SendMessage('cddb read '+tmp+' '+s1+' '+#13+#10);
        writeln('cddb read ',tmp,' ',s1,' ');
      end;
      
    if (ErrorCode=211) and query_send then begin
//        delete(s, 1, 4);
        delete(s, 1, pos(#10, s));
        tmp:=copy(s, 1, pos(' ',s));
        delete(s, 1, pos(' ', s));
        s1:=copy(s, 1, pos(' ',s));
        Connection.SendMessage('cddb read '+tmp+' '+s1+' '+#10+#13);
        writeln('cddb read ',tmp,' ',s1,' ');
      end;


    if (ErrorCode=200) and (query_send=false) then begin
        Connection.SendMessage('cddb query '+QueryString+#10+#13);
        writeln('cddb query '+QueryString);
        query_send:=true;
       end;


     if (ErrorCode=210) and (query_send) then begin
        artist:='';
        album:='';
        delete(s, 1, pos(#10, s));
        n:=0;
        i:=0;
        repeat begin
               deleted:=false;
               if pos('#', s)=1 then begin
                  delete(s, 1, pos(#10, s));
                  deleted:=true;
                 end;
               if pos('DISCID=', s)=1 then begin
                  delete(s, 1, pos(#10, s));
                  deleted:=true;
                end;

               if (pos('DTITLE=', s)=1) and (artist='') then begin
                  artist:=Copy(s, 8, pos(#10, s)-9);
                  artist:=Latin1toUTF8(artist);
                  delete(s, 1, pos(#10, s));
                  deleted:=true;
                end;

               if pos('TTITLE', s)=1 then begin
                  inc(i);
                  title[i]:=Copy(s, pos('=', s)+1, pos(#10, s)-pos('=', s)-2);
                  title[i]:=Latin1toUTF8(title[i]);
                  delete(s, 1, pos(#10, s));
                  writeln('title ---> ',title[i]);
                  deleted:=true;
                 end;
                 
               if (pos('EXTD=', s)=1) and (pos('YEAR:', s)<>0) then begin
                  year:=Copy(s, pos('YEAR:', s)+6, 4);
                  delete(s, 1, pos(#10, s));
                  deleted:=true;
                end;
                
               if (pos('EXTD=', s)=1) then begin
                  delete(s, 1, pos(#10, s));
                  deleted:=true;
                end;
                
               if (pos('PLAYORDER', s)=1)then begin
                  delete(s, 1, pos(#10, s));
                  deleted:=true;
                end;
                
               if (pos('EXTT', s)=1)then begin
                  delete(s, 1, pos(#10, s));
                  deleted:=true;
                end;
               if not deleted then delete(s, 1, pos(#10, s));
               inc(n);
         end;
        until (length(s)<5) or (n>200);
        album:=copy(artist, pos(' / ', artist)+3, length(artist)-pos(' / ', artist)+3);
        delete(artist, pos(' / ', artist), length(artist)-pos(' / ', artist)+1);
        album:=Latin1toUTF8(album);
        data_ready:=true;
        writeln('CDDB data ready...');
       end;
     s:='';
     s1:='';
     tmp:=''
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TCddbObject.OnErrorProc(const msg: string; asocket: TLSocket);
begin
     ErrorMsg:=msg;
     writeln(ErrorMsg);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TCddbObject.OnDisconnectProc(asocket: TLSocket);
begin
writeln('lost connection');
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TCddbObject.OnConnectProc(asocket: TLSocket);
var s:string;
begin
    asocket.GetMessage(s);
    writeln(s);
    Connection.CallAction;
    writeln('connected to cddb server, sending hello...');
    asocket.SendMessage('cddb hello '+FUser+' '+FHostname+' '+FSoftware+' '+FVersion+#13+#10);
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TCddbObject.callevents;
begin
  Connection.CallAction;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TCddbObject.query(drive, server: string; port: word);
begin
   if NrTracks>0 then begin
    discid:=(CDDBDiscID(TOCEntries, NrTracks));
    querystring:=GetCDDBQueryString(TOCEntries, NrTracks);
    writeln(QueryString);
    writeln(hexStr(discid, 8));

    FServer:=server;
    FPort:=port;
    query_send:=false;
    Connection.Connect(FServer, FPort);
  end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function TCddbObject.ReadTOC(drive: string):boolean;
begin
    NrTracks:=0;
    Device:=drive;
    Try
      NrTracks:= ReadCDTOC(drive, TOCEntries);
    except begin
             result:=false;
             NrTracks:=0;
           end;
    end;
    if NrTracks>100 then NrTracks:=0;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TCddbObject.create;
var b: byte;
begin
     Connection:=TLTcp.Create(nil);
     Connection.OnConnect:=@OnConnectProc;
     Connection.OnReceive:=@OnReceiveProc;
     Connection.OnDisconnect:=@OnDisconnectProc;
     Connection.OnError:=@OnErrorProc;
     data_ready:=false;
     FUser:='cddbuser';
     FSoftware:='cddbobject';
     FVersion:='v0.1';
     FHostname:='localhost';
 Try
     DriveCount:=GetCDRomDevices(CDromDrives);
     Writeln(DriveCount,' CD-ROM drives autodetected');
     For b:=1 to DriveCount do
       Writeln('Drive ',b,' on device: ',CDRomDrives[b]);
  Except
     On E : exception do
       Writeln(E.ClassName,' exception caught with message: ',E.Message);
  end;
     if DriveCount=0 then begin
          CDromDrives[1]:=CactusConfig.CDRomDevice;
          inc(DriveCount);
         end;
     Connection.CallAction;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

destructor TCddbObject.destroy;
begin
  Connection.destroy;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

begin
end.

