{
helper application to control Cactus Jukebox from external scripts
currently only loading/appending files is implemented.

in future this can also control start/stop/next/... which makes it easy to 
interface Cactus Jukebox by LIRC

written by Sebastian Kraft, <c> 2006

Contact the author at: sebastian_kraft@gmx.de

This Software is published under the GPL



}


program cactus_remote;

{$mode objfpc}{$H+}

uses SimpleIPC, Sysutils, dos;

{$i cactus_const.inc}
       

var CactusIPC: TSimpleIPCClient;
    FileName,tmps, WorkingDir: String;
    tchar: Char;
    i, ActionID: byte;
    invalid_param: boolean;


begin
   WorkingDir:= ExtractFilePath(Paramstr(0));
   if paramcount > 0 then begin
	tmps:= paramstr(1);
        tchar:=tmps[2];
        invalid_param:=false;
        case tchar of 
          'o' : ActionID:=OPEN_FILE;
          'e' : ActionID:=ENQUEU_FILE;
          'n' : ActionID:=OPEN_AS_NEXT;
         else invalid_param:=true;
         end
      end
     else invalid_param:=true;

   if invalid_param then begin
        writeln('Cactus Remote is a tool to control Cactus Jukebox from external programs, scripts...');
        writeln('cactus_remote  <OPTION>');
        writeln;
        writeln(' Command line options:');
        writeln('    -o <File>  open file');
        writeln('    -e <File>  enqueu file to playlist');
        writeln('    -n <file>  enqueu file as next track in playlist');
        writeln();
        writeln('    -h/--help  show this help');
        writeln();
        halt;
      end;


   FileName:= ExpandFileName(paramstr(2));
   writeln(Filename);
   CactusIPC:= TSimpleIPCClient.create(nil);	
   with CactusIPC do begin
     ServerID:='cactusjukeboxipc';
     try 
         connect;
     except 
            writeln('Cactus Remote:');
            writeln('   no instance of cactus jukebox found, trying to start one');
            writeln;
	    exec(WorkingDir+directoryseparator+'cactus_jukebox','"'+Filename+'"');	
            free;
            halt;
       end;     
   end;

   tmps:=inttostr(ActionID);
   writeln(tmps);
   CactusIPC.SendStringMessage(tmps+': '+FileName);
   CactusIPC.Free;
end.

