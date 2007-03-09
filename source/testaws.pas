program testaws;

uses aws;

var TMPAWS: TAWSAccess;

begin
 tmpaws:=tawsaccess.createRequest('pearl jam', ' vs');
 tmpaws.sendrequest;
 repeat until tmpaws.data_ready;
 tmpaws.albumcovertofile('test.jpg');
 repeat until tmpaws.data_ready;
end.
