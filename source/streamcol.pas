unit streamcol;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils; 

Type

   { TStreamInfoItemClass }

   TStreamInfoItemClass = class
      private
       FURL, FName, FDescription: string;
      public
       constructor create(URL, name: string);
       property Name: string read FName write FName;
       property URL: string read FURL write FURL;
       property Description: string read FDescription write FDescription;
    end;

   { TStreamCollectionClass }

   TStreamCollectionClass = class(TStringList)
      private
        FFilename: string;
      public
       constructor create;
       destructor destroy;

       function add(URL, name: string):integer;
       
       procedure Delete(index: integer); override;
       
       function SaveToFile(filename: string):boolean;
       function LoadFromFile(filename: string):boolean;
   end;
       
var StreamCollection: TStreamCollectionClass;

implementation

{ TStreamCollectionClass }

constructor TStreamCollectionClass.create;
begin
  Inherited create;
end;

destructor TStreamCollectionClass.destroy;
var i:integer;
begin
  for i:= 0 to Count-1 do Objects[i].Free;
end;

function TStreamCollectionClass.add(URL, name: string): integer;
begin
   result:= inherited AddObject(name, TStreamInfoItemClass.create(URL, name));
end;

procedure TStreamCollectionClass.Delete(index: integer);
begin
    Objects[index].Free;
    inherited Delete(index);
end;

function TStreamCollectionClass.SaveToFile(filename: string): boolean;
var sfile: textfile;
    i: integer;
begin
  try
    system.Assign(sfile, filename);
    rewrite(sfile);
    writeln(sfile, 'This file is automaticly created by Cactus Jukebox');
    writeln(sfile, 'NEVER edit by hand!');
    writeln(sfile, '');
    
    for i:= 0 to Count-1 do begin
       writeln(sfile, TStreamInfoItemClass(Objects[i]).Name);
       WriteLn(sfile, TStreamInfoItemClass(Objects[i]).URL);
       WriteLn(sfile, TStreamInfoItemClass(Objects[i]).Description);
    end;
    close(sfile);
    result:=true;
  except
    result:=false;
  end;

end;

function TStreamCollectionClass.LoadFromFile(filename: string): boolean;
var sfile: textfile;
    tmps1, tmps2: string;
    i: integer;
begin
  try
    system.Assign(sfile, filename);
    Reset(sfile);
    
    ReadLn(sfile, tmps1);
    ReadLn(sfile, tmps1);
    ReadLn(sfile, tmps1);
    
    while not EOF(sfile) do begin
       ReadLn(sfile, tmps1);
       ReadLn(sfile, tmps2);
       i:=add(tmps2, tmps1);
       ReadLn(sfile, TStreamInfoItemClass(Objects[i]).Description);
    end;
  except
    writeln('ERROR reading stream collection');
  end;
end;

{ TStreamInfoItemClass }

constructor TStreamInfoItemClass.create(URL, name: string);
begin
  FName:=name;
  FURL:=URL;
end;

end.

