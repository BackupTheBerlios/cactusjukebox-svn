{
  Cactus Jukebox
  
  Main Project File.
  
  written by Sebastian Kraft
  sebastian_kraft@gmx.de
  
  This software is free under the GNU Public License
  
  (c)2005-2006
}

program mp3proj;

{$mode objfpc}{$H+}

uses
 {$ifdef linux}
   cthreads,
 {$endif}
  Interfaces,SysUtils,
  Forms, mp3, mp3file, status, settings, fmod,
  player, fmodplayer, graphics, editid3, directories, skin,
  cdrip, functions, aws, JPEGForLazarus;

var
  s, loadfile, DataPrefix: string;
  invalid_param, skip_config: boolean;
  ScanThread: TscanThread;
  const configname='cactus.cfg';

  {$i cactus_const.inc}

begin
  Application.Title:='cactus';
  writeln();
  writeln('Cactus Jukebox v'+CACTUS_VERSION);
  writeln('written by Sebastian Kraft, (c) 2006');
  writeln();
  for i:= 1 to paramcount do if (paramstr(i)='-h') or (paramstr(i)='--help') or invalid_param then begin

        writeln('cactus_jukebox <OPTIONS> FILE');
        writeln;
        writeln(' Command line options:');
        writeln('    -c      don''t load config file, overwrite with standard settings');
        writeln('    -p      start in playermode');
        writeln();
        writeln('    -h/--help  show this help');
        writeln();
        halt;

      end;
      
  Application.Initialize;

{$ifdef CactusRPM}
   DataPrefix:='/usr/share/cactusjukebox/';
   writeln('RPM version');
  {$else}
   DataPrefix:=ExtractFilePath(ParamStr(0))+DirectorySeparator;
   writeln('ZIP version');
{$endif}

  MediaCollection:=TMediaCollection.create;
  SkinData:=TSkin.Create('default.xml', DataPrefix);

  Application.CreateForm(TMain, Main);
  Application.CreateForm(Tplaywin, playwin);
  Application.CreateForm(TEditID3, editid3win);
    
  invalid_param:=false;
  skip_config:=false;
  main.show;
  main.playermode:=false;
  for i:= 1 to paramcount do if paramstr(i)='-p' then begin
      playwin.show;
      main.playermode:=true;
      main.hide;
     end;

  for i:= 1 to paramcount do if paramstr(i)='-c' then begin
        skip_config:=true
     end;

  for i:= 1 to paramcount do if (paramstr(i)<>'-c') and (paramstr(i)<>'-p') and (paramstr(i)<>'-h') and (paramstr(i)<>'--help') then begin
        if FileExists(paramstr(i)) then begin
                                         loadfile:=paramstr(i);
                                      end
                                     else
                                       begin
                                         writeln('file not found: '+paramstr(i));
                                         halt;
                                   end;
     end;
  main.tempbitmap:=TBitmap.Create;
  main.timetmpbmp:=TBitmap.Create;
  main.tempbitmap.width:=300;
  main.tempbitmap.Height:=150;


  if skip_config then begin
                 writeln('*removing old config file');
              {$ifdef CactusRPM}
                 DeleteFile(main.ConfigPrefix+configname);
              {$else}
                 DeleteFile(configname);
              {$endif}
              end;

  CactusConfig:=TConfigObject.create(CONFIGNAME);

{$ifdef CactusRPM}
  if DirectoryExists(main.ConfigPrefix)=false then mkdir(main.ConfigPrefix);
  if DirectoryExists(main.ConfigPrefix+'/lib')=false then  mkdir(main.ConfigPrefix+'/lib');
  main.cfgfile.Filename:=main.ConfigPrefix+'/'+configname;
 {$else}
  if DirectoryExists('lib')=false then  mkdir('lib');
{$endif}




  writeln('last library '+CactusConfig.LastLib);
  if FileExists(CactusConfig.LastLib) then begin
     Main.StatusBar1.Panels[0].Text:='Loading last library...';
     Mediacollection.load_lib(CactusConfig.LastLib);
     update_artist_view;
     update_title_view;
   end;
   
{  if Main.background_scan then begin
    ScanThread:=TScanThread.Create(true);
    ScanThread.tmpcollection:=MediaCollection;
    ScanThread.Resume;
    writeln('starting scan thread...');
  end;     }
{  Main.Titletree.Columns[0].autosize:=false;
  Main.Titletree.Columns[1].autosize:=true;
  Main.Titletree.Columns[2].autosize:=true;
  Main.Titletree.Columns[3].autosize:=true;
  Main.Titletree.Columns[4].autosize:=false;
                                                }
  Main.checkmobile.Enabled:=true;
  Register_skins;
  writeln('-> loading skin '+main.DataPrefix+'skins/'+CactusConfig.CurrentSkin);
  SkinData.load_skin(CactusConfig.CurrentSkin);
  if loadfile<>'' then main.fileopen(loadfile);

  Application.Run;
end.

