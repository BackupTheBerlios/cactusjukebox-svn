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
  Forms, status, settings, player, graphics, editid3, directories, skin,
  cdrip, JPEGForLazarus, mediacol, BigCoverImg, mainform;

var
  s, loadfile: string;
  invalid_param, skip_config: boolean;
  i:integer;


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
  writeln('##### Application init  #####');
  Application.Initialize;

//   Init config object
{$ifdef CactusRPM}
   CactusConfig:=TConfigObject.create(IncludeTrailingPathDelimiter(GetEnvironmentVariable('HOME'))+'.cactusjukebox'+DirectorySeparator+configname);
   CactusConfig.homeDir:=IncludeTrailingPathDelimiter(GetEnvironmentVariable('HOME'));
   CactusConfig.DataPrefix:='/usr/share/cactusjukebox/';
   CactusConfig.ConfigPrefix:=CactusConfig.HomeDir+'.cactusjukebox/';
   writeln('This is Cactus RPM.');
 {$else}
   SetCurrentDir(ExtractFilePath(ParamStr(0)));
   CactusConfig:=TConfigObject.create(CONFIGNAME);
   CactusConfig.HomeDir:=IncludeTrailingPathDelimiter(GetEnvironmentVariable('HOME'));
   CactusConfig.DataPrefix:=ExtractFilePath(ParamStr(0));
   CactusConfig.ConfigPrefix:=ExtractFilePath(ParamStr(0));
   if DirectoryExists('lib')=false then  mkdir('lib');
{$endif}
  skip_config:=false;
  for i:= 1 to paramcount do if paramstr(i)='-c' then begin
        skip_config:=true
     end;
  if skip_config then begin
                 writeln('*removing old config file');
                 CactusConfig.Clear;
              end;

   if DirectoryExists(CactusConfig.ConfigPrefix)=false then mkdir(CactusConfig.ConfigPrefix);
   if DirectoryExists(CactusConfig.ConfigPrefix+'lib')=false then  mkdir(CactusConfig.ConfigPrefix+'lib');
// end config

  MediaCollection:=TMediaCollectionClass.create;
  SkinData:=TSkin.Create('default.xml', CactusConfig.DataPrefix);

  for i:= 1 to paramcount do if (paramstr(i)<>'-c') and (paramstr(i)<>'-p') and (paramstr(i)<>'-h') and (paramstr(i)<>'--help') then begin
        if FileExists(paramstr(i)) then begin
                                         CactusConfig.LoadOnStart:=paramstr(i);
                                      end
                                     else
                                       begin
                                         writeln('file not found: '+paramstr(i));
                                         halt;
                                   end;
     end;

  Application.CreateForm(TMain, Main);
  Application.CreateForm(Tplaywin, playwin);
  Application.CreateForm(TEditID3, editid3win);

    
  invalid_param:=false;

  main.show;
  main.playermode:=false;
  for i:= 1 to paramcount do if paramstr(i)='-p' then begin
      playwin.show;
      main.playermode:=true;
      main.hide;
      writeln('starting in player mode');
     end;


  Register_skins;
  writeln('-> loading skin '+CactusConfig.DataPrefix+'skins/'+CactusConfig.CurrentSkin);
  SkinData.load_skin(CactusConfig.CurrentSkin);

  update_artist_view;
  update_title_view;

  if CactusConfig.background_scan then begin
    ScanThread:=TScanThread.Create(true);
    ScanThread.tmpcollection.Assign(MediaCollection);
    ScanThread.PTargetCollection:=MediaCollection;
    ScanThread.Resume;
    writeln('starting scan thread...');
  end;
  writeln('##### Application running  #####');
  Application.Run;
end.

