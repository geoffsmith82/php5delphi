unit ufMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, cefvcl,
  PHPCustomLibrary, phpLibrary, php4delphi, PHPCommon, PHPFunctions, PHPAPI,
  ZENDAPI,Vcl.StdCtrls;

type

  TPhpDemoLib = class(TPHPSimpleLibrary)
  private
    procedure _logger_add;
    procedure _get_global_var;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Refresh; override;
  end;

  TfrmMain = class(TForm)
    statPanel: TStatusBar;
    pgcMain: TPageControl;
    tsGeneral: TTabSheet;
    bvlTop: TBevel;
    webkitView: TChromium;
    tsWebView: TTabSheet;
    phpEngine: TPHPEngine;
    phpPSV: TpsvPHP;
    phpLib: TPHPLibrary;
    btnRunPhpInfo: TButton;
    mmoLog: TMemo;
    btnGetGlobalVariants: TButton;
    procedure btnRunPhpInfoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGetGlobalVariantsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LOG(s:string);
  end;

var
  frmMain: TfrmMain;

implementation

uses
  zendTypes,zend_dynamic_array;

procedure LOGADD(s:string);
begin
  frmMain.LOG(s);
end;

{$R *.dfm}

procedure TfrmMain.btnGetGlobalVariantsClick(Sender: TObject);
begin
  phpPSV.RunCode('get_global_var(array("a"=>"ZZZ","b"=>"YYY","c"=>"XXX","d"=>"WWW"));');
end;

procedure TfrmMain.btnRunPhpInfoClick(Sender: TObject);
var
  html:string;
begin
  html := phpPSV.RunCode('include("rarptest.php");phpinfo();');
  webkitView.Browser.MainFrame.LoadString(html,'http://localphpapp/demo/phpinfo');
  pgcMain.ActivePage := tsWebView;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  TPhpDemoLib.Create(Self);
  phpEngine.StartupEngine;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  phpEngine.ShutdownAndWaitFor;
end;

procedure TfrmMain.LOG(s: string);
begin
  mmoLog.Lines.Add(s);
end;

{ TPhpDemoLib }

constructor TPhpDemoLib.Create(AOwner: TComponent);
begin
  inherited;
  LibraryName := 'phpapp_demo_utils';
end;

procedure TPhpDemoLib.Refresh;
begin
  Functions.Clear;
  RegisterMethod('logger_add','Add Log to Host: logger_add($text);',
    _logger_add, [tpString]);
  RegisterMethod('get_global_var','Get Php Global var: get_global_var();',
    _get_global_var, [tpArray]);
end;

procedure TPhpDemoLib._get_global_var;
var
  serv:pzval;
  var_count,i,j:Integer;
  tmp : ^ppzval;
  name,value:ansistring;
  ar : array of AnsiString;
  astr:AnsiString;
  pos: HashPosition;
  key:PAnsiChar;
  key_len ,idx:DWORD;
begin
  serv := GetSessionVariables(); //GetInputArgAsZValue(0);
  //GetInputArg
  LOGADD('serv._type:'+ZendTypeToString(serv^._type));
  if serv^._type = IS_ARRAY then
  begin
    add_assoc_string_ex(serv,'home',SizeOf('home'),'1234567890',0);
    var_count := zend_hash_num_elements(serv^.value.ht);
    SetLength(ar, var_count);
    j:=0;
    LOGADD('serv ARRAY size:'+IntToStr(var_count));
//    if (zend_hash_index_exists(serv^.value.ht, var_count - 1 ) = SUCCESS) then
//    begin
//      for i := 0 to var_count - 1 do
//      begin
//        new(tmp);
//        zend_hash_index_find(serv^.value.ht,i,tmp);
//        value := tmp^^^.value.str.val;
//        name := IntToStr(i);
//        freemem(tmp);
//        LOGADD('serv['+name+']:'+value);
//      end;
//    end else begin
      zend_hash_internal_pointer_reset_ex(serv^.value.ht,pos);
      while True do
      begin
        i := zend_hash_get_current_key_ex(serv^.value.ht, key, key_len, idx, False, pos);
        inc(j);
        if i = HASH_KEY_NON_EXISTANT then Break;
        if i = HASH_KEY_IS_STRING then
        begin
          new(tmp);
          zend_hash_get_current_data_ex(serv^.value.ht,tmp,pos);
          //;
          //value := tmp^^^.value.str.val;
          value := zval2variant(tmp^^^);
          name := IntToStr(j)+':'+key;
          freemem(tmp);
        end else if i = HASH_KEY_IS_LONG then
        begin
          new(tmp);
          zend_hash_get_current_data_ex(serv^.value.ht,tmp,pos);
          //value := tmp^^^.value.str.val;
          value := zval2variant(tmp^^^);
          name := IntToStr(idx);
          freemem(tmp);
        end;
        zend_hash_move_forward_ex(serv^.value.ht, pos);
        LOGADD('serv['+name+']:'+value);
      end;
//    end;
  end;
end;

procedure TPhpDemoLib._logger_add;
begin
  LOGADD(GetInputArgAsString(0));
end;

end.
