{ classes and functions to get albumcovers from amazon web services
  written by Sebastian Kraft
  sebastian_kraft@gmx.de

  This software is free under the GNU Public License

  (c)2007
}

unit aws;

{$mode objfpc}{$H+}

interface

uses
 {$ifdef linux}
   cthreads,
 {$endif}
  Classes, SysUtils, HTTPSend, FPImage, xmlread, dom, strutils, fpreadjpeg, fpwritejpeg;
  
type

{ TScanThread }

   { TNetworkThread }

   TNetworkThread = class(TThread)
   private
     FHTTP: THTTPSend;
     FErrorCode: string;
   protected
     procedure Execute; override;
   public
     Constructor Create(Suspd : boolean);
     fStatus : byte;
     URL: string;
     Errorcode: string;
     ReceiveProc: procedure of object;
     ReceiveData: ^TMemoryStream;
   end;
{ TScanThread }


{ TAWSAccess }

TAWSAccess = class
    constructor CreateRequest(artist, album: string);
    destructor destroy;
  private
    { private declarations }
   // FAlbumCover: TFPImage;
    FArtist, FAlbum: string;
    FAccessKey: string;
    FMainURL, FAlbumCoverURL: string;
    XMLResult: TXMLDocument;
    HTTPRecData: TMemoryStream;
    FAlbumCoverImg: TFPMemoryImage;
    FImgReader: TFPReaderJPEG;
    FImgWriter:TFPCustomImageWriter;
    FImgW, FImgH: integer;
    HTTPThread: TNetworkThread;
    FSavePath: ansistring;
    FData_Ready: boolean;
    procedure ReceiveData;
    Procedure AlbumcoverReceive;
  public
    { public declarations }
    property data_ready: boolean read FData_Ready;
    procedure SendRequest;
    procedure LoadAlbumCover;
    procedure SaveAlbumCover(savepath: string);
    procedure AlbumCoverToFile(savepath: string); //Do everything in one procedure. Send request, download and save it
  end;

implementation
uses functions;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TAWSAccess.CreateRequest(artist, album: string);
begin
     FAlbum:=UTF8toLatin1(album);
     FArtist:=UTF8toLatin1(artist);
     HTTPRecData:=TMemoryStream.Create;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

destructor TAWSAccess.destroy;
begin
     HTTPRecData.Free;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TAWSAccess.ReceiveData;
var    node: TDOMNode;
       artistok, albumok: boolean;
begin
try
     XMLResult:=TXMLDocument.Create;

     artistok:=false;
     albumok:=false;
     write('reading XML file... ');
     ReadXMLFile(XMLResult, HTTPRecData);
     writeln(' done');
     node:=XMLResult.DocumentElement.FindNode('Items').FindNode('Item').FindNode('ItemAttributes').FindNode('Artist');
     if assigned(node) then begin
       // if pos(FArtist, node.FirstChild.NodeValue)=1 then artistok:=true else writeln('wrong artist');
        artistok:=true;  //artist always ok, only check for album name
        writeln(FArtist);
       end else writeln('ERROR parsing xml file');
     writeln(2);
     node:=XMLResult.DocumentElement.FindNode('Items').FindNode('Item').FindNode('ItemAttributes').FindNode('Title');
     if assigned(node) then begin
        //if node.FirstChild.NodeValue=FAlbum then albumok:=true else writeln('wrong album');
        albumok:=true;
        writeln(FAlbum);
      end else writeln('ERROR parsing xml file');

     if albumok and artistok then begin
     writeln('reading image information');
        node:=XMLResult.DocumentElement.FindNode('Items').FindNode('Item').FindNode('MediumImage').FindNode('URL');
        if assigned(node) then begin
           FAlbumCoverURL:=node.FirstChild.NodeValue;
           WriteLn(FAlbumCoverURL);
          end else writeln('ERROR parsing xml file');
        node:=XMLResult.DocumentElement.FindNode('Items').FindNode('Item').FindNode('MediumImage').FindNode('Height');
        if assigned(node) then begin
           FImgH:=StrToInt(node.FirstChild.NodeValue);
           WriteLn(FImgH);
          end else writeln('ERROR parsing xml file');
        node:=XMLResult.DocumentElement.FindNode('Items').FindNode('Item').FindNode('MediumImage').FindNode('Width');
        if assigned(node) then begin
           FImgW:=StrToInt(node.FirstChild.NodeValue);
           WriteLn(FImgW);
          end else writeln('ERROR parsing xml file');
//        fdata_ready:=true; // mhm... this seems to be wrong here...
      end;
      
     XMLResult.Free;
  except writeln('EXCEPTION while parsing xml file');
    end;

     fdata_ready:=false;
     HTTPThread:=TNetworkThread.Create(true);
//     writeln(FSavePath);
     HTTPThread.URL:=FAlbumCoverURL;
     HTTPThread.ReceiveProc:=@AlbumcoverReceive;
     HTTPThread.ReceiveData:=@HTTPRecData;
  //   writeln('exec albumcovertofile');
     HTTPThread.Resume;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TAWSAccess.AlbumcoverReceive;
var Teststr: TMemoryStream;
    excep: boolean;
begin
     write('received... ');
     Teststr:=TMemoryStream.Create;
     excep:=false;
     if not DirectoryExists(ExtractFileDir(FSavePath)) then mkdir(ExtractFileDir(FSavePath));
     try
        Teststr.LoadFromStream(HTTPRecData);
        Teststr.SaveToFile(FSavePath);
      except
          FData_Ready:=false;
          excep:=true;
        end;
      teststr.free;
      if not excep then begin
             fdata_ready:=true;
             writeln(FSavePath + ' written');
           end;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TAWSAccess.SendRequest;
var URL: string;
    i:integer;
begin
  fdata_ready:=false;
  FAccessKey:='0ZVTC2NNPR453JRCG8R2';
  url:=Format('http://webservices.amazon.com/onca/xml?Service=AWSECommerceService&AWSAccessKeyId=%s&Operation=ItemSearch&Artist=%s&Keywords=%s&SearchIndex=Music&ResponseGroup=Medium', [FAccessKey, FArtist, FAlbum]);
  url:=AnsiReplaceStr(url, ' ', '%20');
 // writeln(url);
  HTTPThread:=TNetworkThread.Create(true);
  HTTPThread.URL:=url;
  HTTPThread.ReceiveProc:=@ReceiveData;
  HTTPThread.ReceiveData:=@HTTPRecData;
 // writeln('startthread');
  HTTPThread.Resume;
end;

procedure TAWSAccess.LoadAlbumCover;
begin

end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TAWSAccess.AlbumCoverToFile(savepath: ansistring);
var url: string;
begin
  fdata_ready:=false;
  FAccessKey:='0ZVTC2NNPR453JRCG8R2';
  url:=Format('http://webservices.amazon.com/onca/xml?Service=AWSECommerceService&AWSAccessKeyId=%s&Operation=ItemSearch&Artist=%s&Keywords=%s&SearchIndex=Music&ResponseGroup=Medium', [FAccessKey, FArtist, FAlbum]);
  url:=AnsiReplaceStr(url, ' ', '%20');
  writeln(url);
  FSavePath:=savepath;
  HTTPThread:=TNetworkThread.Create(true);
  HTTPThread.URL:=url;
  HTTPThread.ReceiveProc:=@ReceiveData;
  HTTPThread.ReceiveData:=@HTTPRecData;
  HTTPThread.Resume;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TAWSAccess.SaveAlbumCover(savepath: string);
begin

end;


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TNetworkThread }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

procedure TNetworkThread.Execute;
begin
     FHTTP := THTTPSend.Create;

     FHTTP.HTTPMethod('GET', URL);
     ReceiveData^:=FHTTP.Document;
     Synchronize(ReceiveProc);
     FHTTP.Free;
end;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TNetworkThread.Create(Suspd: boolean);
begin
  FreeOnTerminate := True;
  fStatus:=255;
  inherited Create(suspd);
end;

end.

