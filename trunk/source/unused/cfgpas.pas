unit cfgpas;

{$mode objfpc}{$H+}

interface

Type TConfig=class
     constructor create(cfgpath:string; max_ln:integer);
     function read_config(tag:string):string;
     procedure write_config(tag, value:string);
    private
     cfgfile: text;
     cfgdata: array of string;
     max_lines, i: integer;
    public
     
   end;


implementation
uses sysutils;

constructor TConfig.create(cfgpath:string; max_ln:integer);
begin
     max_lines:=max_ln;
     setlength(cfgdata,max_lines);
     if FileSearch(extractfilename(cfgpath),extractfilepath(cfgpath))='' then
  		begin
                    writeln('no config file found... creating a new one...');
                    assign(cfgfile, cfgpath);
		    rewrite(cfgfile);
		    close(cfgfile);
   		end;
     assign(cfgfile, cfgpath);
end;


function TConfig.read_config(tag:string):string;
var tmps: string;
begin
     reset(cfgfile);
     i:=1;
     while (i<=max_lines) and (not(eof(cfgfile))) do begin
         repeat readln(cfgfile, tmps) until pos('#',tmps)<>1;
         if pos(tag, tmps)<>0 then begin
                     delete(tmps,1,length(tag)+1);
                     read_config:=tmps;
                     close(cfgfile);
                     exit;
            end;
          inc(i);
        end;
     close(cfgfile);
end;

procedure TConfig.write_config(tag, value:string);
var tmps: string;
    z:integer;
    b: byte;
    ext:boolean;
begin
     reset(cfgfile);
     i:=1;
     ext:=false;
     while (i<=max_lines) and (not(eof(cfgfile))) do begin
         readln(cfgfile, cfgdata[i]);
         if pos(tag, cfgdata[i])<>0 then begin
                     cfgdata[i]:=tag+' '+value;
                     ext:=true;
               end;
          inc(i);
        end;
     close(cfgfile);
     rewrite(cfgfile);
     for z:= 1 to i-1 do writeln(cfgfile, cfgdata[z]);
     if ext=false then writeln(cfgfile, tag+' '+value);
     close(cfgfile);
end;

end.

