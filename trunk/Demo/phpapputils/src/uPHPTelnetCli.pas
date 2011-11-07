unit uPHPTelnetCli;

interface

uses
   Windows,
   Messages,
   SysUtils, System.StrUtils,
   Classes,
   Forms,
   zendTypes,
   zendAPI,
   phpTypes,
   phpAPI,
   phpFunctions,
   PHPModules,
   IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdTelnet,IdGlobal,
  PHPCommon, phpClass
   ;

type

  TdmPHP = class(TPHPExtension)
    idTelnet: TIdTelnet;
    phpTelnet: TPHPClass;
    procedure phpTelnet_open(Sender: TPHPClassInstance;
      Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
      this_ptr: pzval; TSRMLS_DC: Pointer);
    procedure phpTelnet_close(Sender: TPHPClassInstance;
      Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
      this_ptr: pzval; TSRMLS_DC: Pointer);
    procedure phpTelnet_sendcmd(Sender: TPHPClassInstance;
      Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
      this_ptr: pzval; TSRMLS_DC: Pointer);
    procedure phpTelnet_getresult(Sender: TPHPClassInstance;
      Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
      this_ptr: pzval; TSRMLS_DC: Pointer);
    procedure idTelnetConnected(Sender: TObject);
    procedure PHPExtensionCreate(Sender: TObject);
    procedure idTelnetDataAvailable(Sender: TIdTelnet;
      const Buffer: TArray<Byte>);
    procedure idTelnetDisconnected(Sender: TObject);
    procedure idTelnetStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure idTelnetTelnetCommand(Sender: TIdTelnet;
      Status: TIdTelnetCommand);
  private
    { Private declarations }
    FTelnetData:TStrings;
  public
    { Public declarations }
  end;

var
  dmPHP: TdmPHP;

implementation

{$R *.DFM}

procedure TdmPHP.phpTelnet_getresult(Sender: TPHPClassInstance;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
  this_ptr: pzval; TSRMLS_DC: Pointer);
var
  mode:Integer;
begin
  if idTelnet.Connected and Assigned(FTelnetData) then
  begin
    ReturnValue := False;
    Exit;
  end;
  ReturnValue := '';
  if Parameters.Count = 0 then
  begin
    if FTelnetData.Count > 0 then
      ReturnValue := FTelnetData.Strings[0];
    if FTelnetData.Count > 1 then
      FTelnetData.Delete(0);
  end else begin
    mode := Parameters[0].Value;
    if mode = -1 then
    begin
      ReturnValue := FTelnetData.Text;
    end else if mode = 0 then
    begin
      if FTelnetData.Count > 0 then
      begin
        ReturnValue := FTelnetData.Strings[0];
        FTelnetData.Delete(0);
      end;
    end;
  end;
end;

procedure TdmPHP.idTelnetConnected(Sender: TObject);
begin
  //
end;

procedure TdmPHP.idTelnetDataAvailable(Sender: TIdTelnet;
  const Buffer: TArray<Byte>);
var
  bufstr: AnsiString;
  ibuf: Cardinal;
begin
  ibuf := Length(Buffer);
  bufstr := BytesToString(Buffer);
  FTelnetData.Text := FTelnetData.Text+bufstr;
  //PHPBuffer.Append(bufstr);
end;

procedure TdmPHP.idTelnetDisconnected(Sender: TObject);
begin
  //
end;

procedure TdmPHP.idTelnetStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  //
end;

procedure TdmPHP.idTelnetTelnetCommand(Sender: TIdTelnet;
  Status: TIdTelnetCommand);
begin
  //
end;

procedure TdmPHP.PHPExtensionCreate(Sender: TObject);
begin
  idTelnet.OnDataAvailable := idTelnetDataAvailable;
  idTelnet.OnConnected := idTelnetConnected;
  idTelnet.OnDisconnected := idTelnetDisconnected;
  idTelnet.OnTelnetCommand := idTelnetTelnetCommand;
  idTelnet.OnStatus := idTelnetStatus;
end;

procedure TdmPHP.phpTelnet_close(Sender: TPHPClassInstance;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
  this_ptr: pzval; TSRMLS_DC: Pointer);
begin
  if IdTelnet.Connected then
    idTelnet.Disconnect(True);
  if Assigned(FTelnetData) then FreeAndNil(FTelnetData);
end;

procedure TdmPHP.phpTelnet_open(Sender: TPHPClassInstance;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
  this_ptr: pzval; TSRMLS_DC: Pointer);
begin
  if not IdTelnet.Connected then
  begin
    idTelnet.Host := phpTelnet.Properties.ByName('host').AsString;
    idTelnet.Port := phpTelnet.Properties.ByName('port').AsInteger;
    IdTelnet.Connect;
    if idTelnet.Connected and not Assigned(FTelnetData) then
      FTelnetData := TStringList.Create;
  end;
  Sleep(100);
  ReturnValue := IdTelnet.Connected;
end;

procedure TdmPHP.phpTelnet_sendcmd(Sender: TPHPClassInstance;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
  this_ptr: pzval; TSRMLS_DC: Pointer);
begin
  if IdTelnet.Connected then
  begin
    if (Parameters.Count = 1) then
      idTelnet.SendString(Parameters[0].ZendVariable.AsString);
  end;
end;

end.
