library php_mediainfo;

uses
  Windows,
  SysUtils,
  phpApp,
  phpModules,
  MediaInfoDLL in 'MediaInfoDLL.pas',
  uMediaInfo in 'uMediaInfo.pas' {PHPMediaInfo: TPHPExtension};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TPHPMediaInfo, PHPMediaInfo);
  Application.Run;
end.