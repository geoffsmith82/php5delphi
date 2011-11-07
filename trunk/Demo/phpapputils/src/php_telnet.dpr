library php_telnet;

uses
  Windows,
  SysUtils,
  phpApp,
  phpModules,
  uPHPTelnetCli in 'uPHPTelnetCli.pas' {dmPHP: TPHPExtension};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TdmPHP, dmPHP);
  Application.Run;
end.