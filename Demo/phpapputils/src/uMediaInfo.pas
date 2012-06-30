unit uMediaInfo;

interface

uses
   Windows,
   Messages,
   SysUtils,
   Classes,
   Forms,
   zendTypes,
   zendAPI,
   phpTypes,
   phpAPI,
   phpFunctions,
   PHPModules, PHPCommon, phpClass,
   MediaInfoDLL;

type

  TPHPMediaInfo = class(TPHPExtension)
    php_mediainfo: TPHPClass;
    procedure php_mediainfo_open(Sender: TPHPClassInstance;
      Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
      this_ptr: pzval; TSRMLS_DC: Pointer);
    procedure php_mediainfo_close(Sender: TPHPClassInstance;
      Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
      this_ptr: pzval; TSRMLS_DC: Pointer);
    procedure php_mediainfo_option(Sender: TPHPClassInstance;
      Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
      this_ptr: pzval; TSRMLS_DC: Pointer);
    procedure php_mediainfo_get_inform(Sender: TPHPClassInstance;
      Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
      this_ptr: pzval; TSRMLS_DC: Pointer);
    procedure php_mediainfo_get_i(Sender: TPHPClassInstance;
      Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
      this_ptr: pzval; TSRMLS_DC: Pointer);
    procedure php_mediainfo_get_count(Sender: TPHPClassInstance;
      Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
      this_ptr: pzval; TSRMLS_DC: Pointer);
    procedure php_mediainfo_get(Sender: TPHPClassInstance;
      Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
      this_ptr: pzval; TSRMLS_DC: Pointer);
    procedure php_mediainfo_list_constants(Sender: TObject;
      Parameters: TFunctionParams; var ReturnValue: Variant;
      ZendVar: TZendVariable; TSRMLS_DC: Pointer);
  private
    { Private declarations }
    FHandle: Cardinal;
    FisLoad: Boolean;
  public
    constructor Create(AOwner : TComponent); override;
    { Public declarations }
  end;

var
  PHPMediaInfo: TPHPMediaInfo;

implementation

{$R *.DFM}
const
  cntMediainfo_LibFile = 'mediainfo.dll';

constructor TPHPMediaInfo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHandle := 0;
  FisLoad := False;
  //if FileExists(cntMediainfo_LibFile) then
  begin
    FisLoad := MediaInfoDLL_Load(cntMediainfo_LibFile);
    php_mediainfo.Properties.ByName('isload').AsBoolean := FisLoad;
  end;
end;

procedure TPHPMediaInfo.php_mediainfo_list_constants(Sender: TObject;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendVar: TZendVariable;
  TSRMLS_DC: Pointer);
begin
  ReturnValue := 'Constants List:' + #13#10 +
    '  Stream Kind:' + #13#10 +
    '  MEDIAINFO_STREAM_GENERAL = 0' + #13#10 +
    '  MEDIAINFO_STREAM_VIDEO = 1' + #13#10 +
    '  MEDIAINFO_STREAM_AUDIO = 2' + #13#10 +
    '  MEDIAINFO_STREAM_TEXT = 3' + #13#10 +
    '  MEDIAINFO_STREAM_CHAPTERS = 4' + #13#10 +
    '  MEDIAINFO_STREAM_IMAGE = 5' + #13#10 +
    '  MEDIAINFO_STREAM_MENU = 6' + #13#10 +
    '  MEDIAINFO_STREAM_MAX = 7' + #13#10 + #13#10 +
    '  Info:' + #13#10 +
    '  MEDIAINFO_INFO_NAME = 0' + #13#10 +
    '  MEDIAINFO_INFO_TEXT = 1' + #13#10 +
    '  MEDIAINFO_INFO_MEASURE = 2' + #13#10 +
    '  MEDIAINFO_INFO_OPTIONS = 3' + #13#10 +
    '  MEDIAINFO_INFO_NAME_TEXT = 4' + #13#10 +
    '  MEDIAINFO_INFO_MEASURE_TEXT = 5' + #13#10 +
    '  MEDIAINFO_INFO_INFO = 6' + #13#10 +
    '  MEDIAINFO_INFO_HOWTO = 7' + #13#10 +
    '  MEDIAINFO_INFO_MAX = 8' + #13#10 + #13#10 +
    '  Info Option:' + #13#10 +
    '  MEDIAINFO_INFOOPTION_SHOWININFORM = 0' + #13#10 +
    '  MEDIAINFO_INFOOPTION_RESERVED = 1' + #13#10 +
    '  MEDIAINFO_INFOOPTION_SHOWINSUPPORTED = 2' + #13#10 +
    '  MEDIAINFO_INFOOPTION_TYPEOFVALUE = 3' + #13#10 +
    '  MEDIAINFO_INFOOPTION_MAX = 4' + #13#10 ;
end;

procedure TPHPMediaInfo.php_mediainfo_close(Sender: TPHPClassInstance;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
  this_ptr: pzval; TSRMLS_DC: Pointer);
begin
  ReturnValue := False;
  if (not FisLoad) or (FHandle = 0) then
  begin
    ReturnValue := False;
    Exit;
  end;
  if (FisLoad) then
  begin
    MediaInfo_Close(FHandle);
    FHandle := 0;
    ReturnValue := True;
  end;
end;

procedure TPHPMediaInfo.php_mediainfo_get(Sender: TPHPClassInstance;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
  this_ptr: pzval; TSRMLS_DC: Pointer);
var
  kind,num,info,search:Integer;
  p,rs:WideString;
begin
  if (not FisLoad) or (FHandle = 0) then
  begin
    ReturnValue := '';
    Exit;
  end;
  if FisLoad and (Parameters.Count = 5) then
  begin
    kind := Parameters[0].Value;
    num := Parameters[1].Value;
    p := Parameters[2].Value;
    info := Parameters[3].Value;
    search := Parameters[4].Value;
    rs := MediaInfo_Get(FHandle,TMIStreamKind(kind),num,PWideChar(p),TMIInfo(info),TMIInfo(search));
    ReturnValue := rs;
  end;
end;

procedure TPHPMediaInfo.php_mediainfo_get_count(Sender: TPHPClassInstance;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
  this_ptr: pzval; TSRMLS_DC: Pointer);
var
  kind,num,rs:Integer;
begin
  ReturnValue := 0;
  if (not FisLoad) or (FHandle = 0) then
  begin
    ReturnValue := -1;
    Exit;
  end;
  if FisLoad and (Parameters.Count = 2) then
  begin
    kind := Parameters[0].Value;
    num := Parameters[1].Value;
    rs := MediaInfo_Count_Get(FHandle,TMIStreamKind(kind),num);
    ReturnValue := rs;
  end;
end;

procedure TPHPMediaInfo.php_mediainfo_get_i(Sender: TPHPClassInstance;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
  this_ptr: pzval; TSRMLS_DC: Pointer);
var
  kind,num,p,info:Integer;
  rs:WideString;
begin
  if (not FisLoad) or (FHandle = 0) then
  begin
    ReturnValue := '';
    Exit;
  end;
  if FisLoad and (Parameters.Count = 4) then
  begin
    kind := Parameters[0].Value;
    num := Parameters[1].Value;
    p := Parameters[2].Value;
    info := Parameters[3].Value;
    rs := MediaInfo_GetI(FHandle,TMIStreamKind(kind),num,p,TMIInfo(info));
    ReturnValue := rs;
  end;
end;

procedure TPHPMediaInfo.php_mediainfo_get_inform(Sender: TPHPClassInstance;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
  this_ptr: pzval; TSRMLS_DC: Pointer);
var
  rev:Integer;
  rs : WideString;
begin
  if (not FisLoad) or (FHandle = 0) then
  begin
    ReturnValue := '';
    Exit;
  end;
  if FisLoad and (Parameters.Count = 1) then
  begin
    rev := Parameters[0].Value;
    rs := MediaInfo_Inform(FHandle,rev);
    ReturnValue := rs;
  end;
end;

procedure TPHPMediaInfo.php_mediainfo_open(Sender: TPHPClassInstance;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
  this_ptr: pzval; TSRMLS_DC: Pointer);
var
  mediafile : WideString;
begin
  ReturnValue := False;
  if FHandle > 0 then
  begin
    MediaInfo_Close(FHandle);
    FHandle := 0;
  end;

  if (FisLoad) and (FHandle = 0) and (Parameters.Count = 1) then
  begin
    FHandle := MediaInfo_New();
    mediafile := Parameters[0].Value;
    //if (FileExists(mediafile)) then
    begin
      MediaInfo_Open(FHandle,PWideChar(Mediafile));
      ReturnValue := FHandle;
      php_mediainfo.Properties.ByName('mediafile').Value := mediafile;
    end;
  end;
end;

procedure TPHPMediaInfo.php_mediainfo_option(Sender: TPHPClassInstance;
  Parameters: TFunctionParams; var ReturnValue: Variant; ZendValue,
  this_ptr: pzval; TSRMLS_DC: Pointer);
var
  opt,val,rs : WideString;
begin
  if (not FisLoad) then
  begin
    ReturnValue := '';
    Exit;
  end else begin
    if (Parameters.Count = 2) then
    begin
      opt := Parameters[0].Value;
      val := Parameters[1].Value;
      rs := MediaInfo_Option(0,PWideChar(opt),PWideChar(val));
      ReturnValue := rs;
    end;

  end;

end;

end.