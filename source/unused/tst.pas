program tst;
uses lnet;

var CDdbconnection: TLConnection;

begin
	CDdbconnection:=TLConnection.create(nil);
	if CDdbconnection.connect('http://us.freedb.org/~cddb/',8880) then writeln('connected');
	CDdbconnection.disconnect;
end.
