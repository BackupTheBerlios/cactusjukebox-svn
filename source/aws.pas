
{ classes and functions to get albumcovers from amazon web services
  written by Sebastian Kraft
  sebastian_kraft@gmx.de

  This software is free under the GNU Public License

  (c)2007
}

Unit aws;

{$mode objfpc}{$H+}

Interface

Uses 
 {$ifdef linux}
cthreads,
 {$endif}
Classes, SysUtils, HTTPSend, FPImage, xmlread, dom, strutils, fpreadjpeg, fpwritejpeg;

Type 

{ TScanThread }

   { TNetworkThread }

  TNetworkThread = Class(TThread)
    Private 
    FHTTP: THTTPSend;
    FErrorCode: string;
    Protected 
    Procedure Execute;
    override;
    Public 
    Constructor Create(Suspd : boolean);
    fStatus : byte;
    URL: string;
    Errorcode: string;
    ReceiveProc: Procedure  Of object;
    ReceiveData: ^TMemoryStream;
  End;
{ TScanThread }


{ TAWSAccess }

  TAWSAccess = Class
    constructor CreateRequest(artist, album: String);
    destructor destroy;
    Private 
    { private declarations }
    // FAlbumCover: TFPImage;
    FArtist, FAlbum: string;
    FAccessKey: string;
    FMainURL, FAlbumCoverURL: string;
    XMLResult: TXMLDocument;
    HTTPRecData: TMemoryStream;
    FAlbumCoverImg: TFPMemoryImage;
    FImgReader: TFPReaderJPEG;
    FImgWriter: TFPCustomImageWriter;
    FImgW, FImgH: integer;
    HTTPThread: TNetworkThread;
    FSavePath: ansistring;
    FData_Ready, FImgNotFound: boolean;
    Procedure ReceiveData;
    Procedure AlbumcoverReceive;
    Public 
    { public declarations }
    property data_ready: boolean read FData_Ready;
    property ImgNotFound: boolean read FImgNotFound;
    Procedure SendRequest;
    Procedure LoadAlbumCover;
    Procedure SaveAlbumCover(savepath: String);
    Procedure AlbumCoverToFile(savepath: String);
    //Do everything in one procedure. Send request, download and save it
  End;

  Implementation

  Uses functions;

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  constructor TAWSAccess.CreateRequest(artist, album: String);
Begin
  FAlbum := UTF8toLatin1(album);
  FArtist := UTF8toLatin1(artist);
  HTTPRecData := TMemoryStream.Create;
  FData_Ready := false;
  FImgNotFound := false;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

destructor TAWSAccess.destroy;
Begin
  HTTPRecData.Free;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Procedure TAWSAccess.ReceiveData;

Var    node: TDOMNode;
  artistok, albumok: boolean;
Begin
  Try
    XMLResult := TXMLDocument.Create;

    artistok := false;
    albumok := false;
    write('reading XML file... ');
    ReadXMLFile(XMLResult, HTTPRecData);
    writeln(' done');
    node := XMLResult.DocumentElement.FindNode('Items').FindNode('Item').FindNode('ItemAttributes').
            FindNode('Artist');
    If assigned(node) Then
      Begin

   // if pos(FArtist, node.FirstChild.NodeValue)=1 then artistok:=true else writeln('wrong artist');
        artistok := true;
        //artist always ok, only check for album name
        writeln(FArtist);
      End
    Else writeln('ERROR parsing xml file');
    writeln('2');
    node := XMLResult.DocumentElement.FindNode('Items').FindNode('Item').FindNode('ItemAttributes').
            FindNode('Title');
    If assigned(node) Then
      Begin
        //if node.FirstChild.NodeValue=FAlbum then albumok:=true else writeln('wrong album');
        albumok := true;
        writeln(FAlbum);
      End
    Else writeln('ERROR parsing xml file');

    If albumok And artistok Then
      Begin
        writeln('reading image information');
        node := XMLResult.DocumentElement.FindNode('Items').FindNode('Item').FindNode('MediumImage')
                .FindNode('URL');
        If assigned(node) Then
          Begin
            FAlbumCoverURL := node.FirstChild.NodeValue;
           // WriteLn(FAlbumCoverURL);
          End
        Else writeln('ERROR parsing xml file');
        node := XMLResult.DocumentElement.FindNode('Items').FindNode('Item').FindNode('MediumImage')
                .FindNode('Height');
        If assigned(node) Then
          Begin
            FImgH := StrToInt(node.FirstChild.NodeValue);
            WriteLn(FImgH);
          End
        Else writeln('ERROR parsing xml file');
        node := XMLResult.DocumentElement.FindNode('Items').FindNode('Item').FindNode('MediumImage')
                .FindNode('Width');
        If assigned(node) Then
          Begin
            FImgW := StrToInt(node.FirstChild.NodeValue);
            WriteLn(FImgW);
          End
        Else writeln('ERROR parsing xml file');
        //        fdata_ready:=true; // mhm... this seems to be wrong here...
      End;

    XMLResult.Free;
  Except
    writeln('EXCEPTION while parsing xml file');
  End;
  If FAlbumCoverURL<>'' Then
    Begin
      fdata_ready := false;
      HTTPThread := TNetworkThread.Create(true);
      //      writeln(FSavePath);
      HTTPThread.URL := FAlbumCoverURL;
      HTTPThread.ReceiveProc := @AlbumcoverReceive;
      HTTPThread.ReceiveData := @HTTPRecData;
      //    writeln('exec albumcovertofile');
      HTTPThread.Resume;
    End
  Else FImgNotFound := true;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Procedure TAWSAccess.AlbumcoverReceive;

Var Teststr: TMemoryStream;
  excep: boolean;
Begin
  write('received... ');
  Teststr := TMemoryStream.Create;
  excep := false;
  If Not DirectoryExists(ExtractFileDir(FSavePath)) Then mkdir(ExtractFileDir(FSavePath));
  Try
    Teststr.LoadFromStream(HTTPRecData);
    Teststr.SaveToFile(FSavePath);
  Except
    FData_Ready := false;
    excep := true;
  End;
  teststr.free;
  If Not excep Then
    Begin
      fdata_ready := true;
      writeln(FSavePath + ' written');
    End;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Procedure TAWSAccess.SendRequest;

Var URL: string;
  i: integer;
Begin
  fdata_ready := false;
  FAccessKey := '0ZVTC2NNPR453JRCG8R2';
  url := Format(
'http://webservices.amazon.com/onca/xml?Service=AWSECommerceService&AWSAccessKeyId=%s&Operation=ItemSearch&Artist=%s&Keywords=%s&SearchIndex=Music&ResponseGroup=Medium'
         , [FAccessKey, FArtist, FAlbum]);
  url := AnsiReplaceStr(url, ' ', '%20');
  // writeln(url);
  HTTPThread := TNetworkThread.Create(true);
  HTTPThread.URL := url;
  HTTPThread.ReceiveProc := @ReceiveData;
  HTTPThread.ReceiveData := @HTTPRecData;
  // writeln('startthread');
  HTTPThread.Resume;
End;

Procedure TAWSAccess.LoadAlbumCover;
Begin

End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Procedure TAWSAccess.AlbumCoverToFile(savepath: ansistring);

Var url: string;
Begin
  fdata_ready := false;
  FAccessKey := '0ZVTC2NNPR453JRCG8R2';
  url := Format(
'http://webservices.amazon.com/onca/xml?Service=AWSECommerceService&AWSAccessKeyId=%s&Operation=ItemSearch&Artist=%s&Keywords=%s&SearchIndex=Music&ResponseGroup=Medium'
         , [FAccessKey, FArtist, FAlbum]);
  url := AnsiReplaceStr(url, ' ', '%20');
 // writeln(url);
  FSavePath := savepath;
  HTTPThread := TNetworkThread.Create(true);
  HTTPThread.URL := url;
  HTTPThread.ReceiveProc := @ReceiveData;
  HTTPThread.ReceiveData := @HTTPRecData;
  HTTPThread.Resume;
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Procedure TAWSAccess.SaveAlbumCover(savepath: String);
Begin

End;


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{ TNetworkThread }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Procedure TNetworkThread.Execute;
Begin
  FHTTP := THTTPSend.Create;

  FHTTP.HTTPMethod('GET', URL);
  ReceiveData^ := FHTTP.Document;
  Synchronize(ReceiveProc);
  FHTTP.Free;
  writeln('NetworkThread terminated');
End;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

constructor TNetworkThread.Create(Suspd: boolean);
Begin
  inherited Create(suspd);
  FreeOnTerminate := True;
  fStatus := 255;
End;

End.
