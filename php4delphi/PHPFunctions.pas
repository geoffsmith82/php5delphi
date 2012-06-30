{ ******************************************************* }
{ PHP4Delphi }
{ PHP - Delphi interface }
{ }
{ Author: }
{ Serhiy Perevoznyk }
{ serge_perevoznyk@hotmail.com }
{ http://users.chello.be/ws36637 }
{ ******************************************************* }
{$I PHP.INC}
{ $Id: PHPFunctions.pas,v 7.2 10/2009 delphi32 Exp $ }

unit phpFunctions;

interface

uses
  Windows, SysUtils, Classes, {$IFDEF VERSION6} Variants,
{$ENDIF} ZendTypes, PHPTypes, ZendAPI, PHPAPI,
{.$IFDEF VERSION12}
  System.Generics.Defaults,
  System.Generics.Collections
{.$ENDIF}
;

type
  TParamType = (tpString, tpInteger, tpFloat, tpBoolean, tpArray, tpUnknown);

  TZendVariable = class(TObject)
  private
    FValue: PZval;
    FArrayValue : pppzval;
    function GetAsBoolean: boolean;
    procedure SetAsBoolean(const Value: boolean);
    function GetAsFloat: double;
    function GetAsInteger: integer;
    function GetAsString: AnsiString;
    procedure SetAsFloat(const Value: double);
    procedure SetAsInteger(const Value: integer);
    procedure SetAsString(const Value: AnsiString);
    function GetAsDate: TDateTime;
    function GetAsDateTime: TDateTime;
    function GetAsTime: TDateTime;
    procedure SetAsDate(const Value: TDateTime);
    procedure SetAsDateTime(const Value: TDateTime);
    procedure SetAsTime(const Value: TDateTime);
    function GetAsVariant: variant;
    procedure SetAsVariant(const Value: variant);
    function GetDataType: integer;
    function GetIsNull: boolean;
    function GetTypeName: string;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure UnAssign;
    function UsePPZVal:Boolean;
    procedure NewValue();
    property IsNull: boolean read GetIsNull;
    property AsZendVariable: PZval read FValue write FValue;
    property AsBoolean: boolean read GetAsBoolean write SetAsBoolean;
    property AsInteger: integer read GetAsInteger write SetAsInteger;
    property AsString: AnsiString read GetAsString write SetAsString;
    property AsFloat: double read GetAsFloat write SetAsFloat;
    property AsDate: TDateTime read GetAsDate write SetAsDate;
    property AsTime: TDateTime read GetAsTime write SetAsTime;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsVariant: variant read GetAsVariant write SetAsVariant;
    property DataType: integer read GetDataType;
    property TypeName: string read GetTypeName;
    property PPZVal: pppzval read FArrayValue;
  end;

  TFunctionParam = class(TCollectionItem)
  private
    FName: string;
    FParamType: TParamType;
    FZendVariable: TZendVariable;
    function GetZendValue: PZval;
    procedure SetZendValue(const Value: PZval);
    function GetValue: variant;
    procedure SetValue(const Value: variant);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    function GetDisplayName: string; override;
    procedure SetDisplayName(const Value: string); override;
    procedure AssignTo(Dest: TPersistent); override;
    property Value: variant read GetValue write SetValue;
    property ZendValue: PZval read GetZendValue write SetZendValue;
    property ZendVariable: TZendVariable read FZendVariable write FZendVariable;
  published
    property Name: string read FName write SetDisplayName;
    property ParamType: TParamType read FParamType write FParamType;
  end;

  TFunctionParams = class(TCollection)
  private
    FOwner: TPersistent;
    function GetItem(Index: integer): TFunctionParam;
    procedure SetItem(Index: integer; Value: TFunctionParam);
  protected
    function GetOwner: TPersistent; override;
    procedure SetItemName(Item: TCollectionItem); override;
  public
    constructor Create(Owner: TPersistent; ItemClass: TCollectionItemClass);
    function ParamByName(AName: string): TFunctionParam;
    function Values(AName: string): variant;
    function Add: TFunctionParam;
    property Items[Index: integer]: TFunctionParam read GetItem
      write SetItem; default;
  end;

  TPHPExtConstant = class(TCollectionItem)
  private
    FName: string;
    FConstantType: TParamType;
    FValue: variant;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    function GetDisplayName: string; override;
    procedure SetDisplayName(const Value: string); override;
    procedure AssignTo(Dest: TPersistent); override;
  published
    property Name: string read FName write SetDisplayName;
    property ConstantType: TParamType read FConstantType write FConstantType;
    property Value: variant read FValue write FValue;
  end;

  TPHPExtConstants = class(TCollection)
  private
    FOwner: TPersistent;
    function GetItem(Index: integer): TPHPExtConstant;
    procedure SetItem(Index: integer; Value: TPHPExtConstant);
  protected
    function GetOwner: TPersistent; override;
    procedure SetItemName(Item: TCollectionItem); override;
  public
    constructor Create(Owner: TPersistent; ItemClass: TCollectionItemClass);
    function ConstantByName(AName: string): TPHPExtConstant;
    function Values(AName: string): variant;
    function Add: TPHPExtConstant;
    property Items[Index: integer]: TPHPExtConstant read GetItem
      write SetItem; default;
  end;


  TPHPExecute = procedure(Sender: TObject; Parameters: TFunctionParams;
    var ReturnValue: variant; ZendVar: TZendVariable; TSRMLS_DC: pointer)
    of object;

  TPHPFunction = class(TCollectionItem)
  private
    FOnExecute: TPHPExecute;
    FFunctionName: AnsiString;
    FTag: integer;
    FFunctionParams: TFunctionParams;
    FDescription: AnsiString;
    procedure SetFunctionParams(const Value: TFunctionParams);
    procedure _SetDisplayName(const Value: AnsiString);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    function GetDisplayName: string; override;
    procedure SetDisplayName(const Value: string); override;
    procedure AssignTo(Dest: TPersistent); override;
  published
    property FunctionName: AnsiString read FFunctionName write _SetDisplayName;
    property Tag: integer read FTag write FTag;
    property Parameters: TFunctionParams read FFunctionParams
      write SetFunctionParams;
    property OnExecute: TPHPExecute read FOnExecute write FOnExecute;
    property Description: AnsiString read FDescription write FDescription;
  end;

  TPHPFunctions = class(TCollection)
  private
    FOwner: TPersistent;
  protected
    function GetItem(Index: integer): TPHPFunction;
    procedure SetItem(Index: integer; Value: TPHPFunction);
    function GetOwner: TPersistent; override;
    procedure SetItemName(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent;
      ItemClass: TCollectionItemClass); virtual;
    function Add: TPHPFunction;
    function FunctionByName(const AName: AnsiString): TPHPFunction;
    property Items[Index: integer]: TPHPFunction read GetItem
      write SetItem; default;
  end;

{.$IFDEF VERSION12}
  TArrayZendVariable = class(TObjectDictionary<string,TZendVariable>)
  public
    function IsExists(s:string):Boolean;
    procedure DelKeyAndObj(key:string);
    procedure ClearKeyAndObj();
    destructor Destroy; override;
  end;

  TArrayVariable = class(TDictionary<string,Variant>)
  public
    function IsExists(s:string):Boolean;
  end;

{.$ENDIF}

function IsParamTypeCorrect(AParamType: TParamType; z: PZval): boolean;

function ZendTypeToString(_type: integer): string;

function ZValToArrayZendVariable(value:pzval;var oVars:TArrayZendVariable):Boolean; overload;
function ZValToArrayZendVariable(value:pzval):TArrayZendVariable; overload;
function ZValToTStrings(value:pzval;var oVars:TStrings):Boolean; overload;
function ZValToTStrings(value:pzval):TStrings; overload;
function ZValToArrayVariable(value:pzval;var oVars:TArrayVariable):Boolean; overload;
function ZValToArrayVariable(value:pzval):TArrayVariable; overload;

implementation

function ZendTypeToString(_type: integer): string;
begin
  case _type of
    IS_NULL:
      Result := 'IS_NULL';
    IS_LONG:
      Result := 'IS_LONG';
    IS_DOUBLE:
      Result := 'IS_DOUBLE';
    IS_STRING:
      Result := 'IS_STRING';
    IS_ARRAY:
      Result := 'IS_ARRAY';
    IS_OBJECT:
      Result := 'IS_OBJECT';
    IS_BOOL:
      Result := 'IS_BOOL';
    IS_RESOURCE:
      Result := 'IS_RESOURCE';
    IS_CONSTANT:
      Result := 'IS_CONSTANT';
    IS_CONSTANT_ARRAY:
      Result := 'IS_CONSTANT_ARRAY';
  end;
end;

function IsParamTypeCorrect(AParamType: TParamType; z: PZval): boolean;
var
  ZType: integer;
begin
  ZType := z^._type;
  case AParamType Of
    tpString:
      Result := (ZType in [IS_STRING, IS_NULL]);
    tpInteger:
      Result := (ZType in [IS_LONG, IS_BOOL, IS_NULL, IS_RESOURCE]);
    tpFloat:
      Result := (ZType in [IS_NULL, IS_DOUBLE, IS_LONG]);
    tpBoolean:
      Result := (ZType in [IS_NULL, IS_BOOL]);
    tpArray:
      Result := (ZType in [IS_NULL, IS_ARRAY]);
    tpUnknown:
      Result := True;
  else
    Result := False;
  end;
end;

function ZValToArrayZendVariable(value: pzval; var oVars: TArrayZendVariable): Boolean;
var
  itemCount,i:Integer;
  pos: HashPosition;
  key:PAnsiChar;
  key_len ,idx:DWORD;
  oZVal:TZendVariable;
begin
  Result := False;
  if not Assigned(value) then Exit;
  if value^._type <> IS_ARRAY then Exit;
  itemCount := zend_hash_num_elements(value^.value.ht);
  if itemCount <= 0 then Exit;
  if not Assigned(oVars) then oVars := TArrayZendVariable.Create([doOwnsValues]);

  zend_hash_internal_pointer_reset_ex(value^.value.ht,pos);
  while True do
  begin
    i := zend_hash_get_current_key_ex(value^.value.ht, key, key_len, idx, False, pos);
    if i = HASH_KEY_NON_EXISTANT then Break;

    oZVal := TZendVariable.Create;
    zend_hash_get_current_data_ex(value^.value.ht,oZVal.PPZVal,pos);
    oZVal.UsePPZVal;
    //value := tmp^^^.value.str.val;

    if i = HASH_KEY_IS_STRING then oVars.Add(AnsiString(key),oZVal)
    else if i = HASH_KEY_IS_STRING then oVars.Add(IntToStr(idx),oZVal);

    zend_hash_move_forward_ex(value^.value.ht, pos);
    Result := True;
  end;
end;

function ZValToArrayZendVariable(value:pzval):TArrayZendVariable;
begin
  ZValToArrayZendVariable(value,Result);
end;

function ZValToTStrings(value:pzval;var oVars:TStrings):Boolean;
var
  itemCount,i:Integer;
  pos: HashPosition;
  key:PAnsiChar;
  key_len ,idx:DWORD;
  tmp:pppzval;
  val:Variant;
begin
  Result := False;
  if not Assigned(value) then Exit;
  if value^._type <> IS_ARRAY then Exit;
  itemCount := zend_hash_num_elements(value^.value.ht);
  if itemCount <= 0 then Exit;
  if not Assigned(oVars) then oVars := TStringList.Create();

  zend_hash_internal_pointer_reset_ex(value^.value.ht,pos);
  while True do
  begin
    i := zend_hash_get_current_key_ex(value^.value.ht, key, key_len, idx, False, pos);
    if i = HASH_KEY_NON_EXISTANT then Break;

    New(tmp);
    zend_hash_get_current_data_ex(value^.value.ht,tmp,pos);
    val := zval2variant(tmp^^^);

    if i = HASH_KEY_IS_STRING then oVars.Add(Trim(AnsiString(key))+'='+val)
    else if i = HASH_KEY_IS_STRING then oVars.Add(IntToStr(idx)+'='+val);

    FreeMem(tmp);
    zend_hash_move_forward_ex(value^.value.ht, pos);
    Result := True;
  end;
end;

function ZValToTStrings(value:pzval):TStrings;
begin
  ZValToTStrings(value,Result);
end;

function ZValToArrayVariable(value:pzval;var oVars:TArrayVariable):Boolean;
var
  itemCount,i:Integer;
  pos: HashPosition;
  s:AnsiString;
  key:PAnsiChar;
  key_len ,idx:DWORD;
  tmp:pppzval;
  val:Variant;
begin
  Result := False;
  if not Assigned(value) then Exit;
  if value^._type <> IS_ARRAY then Exit;

  itemCount := zend_hash_num_elements(value^.value.ht);
  if itemCount <= 0 then Exit;
  if not Assigned(oVars) then oVars := TArrayVariable.Create();

  zend_hash_internal_pointer_reset_ex(value^.value.ht,pos);
  while True do
  begin
    i := zend_hash_get_current_key_ex(value^.value.ht, key, key_len, idx, False, pos);
    if i = HASH_KEY_NON_EXISTANT then Break;
    New(tmp);
    zend_hash_get_current_data_ex(value^.value.ht,tmp,pos);
    val := zval2variant(tmp^^^);
//    if i = HASH_KEY_IS_LONG then
//    begin
//    MessageBox(0, 'long', '111', MB_OK);
//      New(tmp);
//      zend_hash_get_current_data_ex(value^.value.ht,tmp,pos);
//      val := zval2variant(tmp^^^);
//      oVars.Add(IntToStr(idx),val);
//      FreeMem(tmp);
//    end  else if i = HASH_KEY_IS_STRING then
//    begin
//    MessageBox(0, 'string', '111', MB_OK);
//      New(tmp);
//      zend_hash_get_current_data_ex(value^.value.ht,tmp,pos);
//      val := zval2variant(tmp^^^);
//      MessageBox(0, 'string1', '111', MB_OK);
//      SetLength(s,key_len);
//      StrLCopy(PAnsiChar(s), key, key_len);
//      //s := key^;
//      //Move(key,@s,key_len);
//      oVars.Add(s,val);
//      MessageBox(0, 'string2', '111', MB_OK);
//      FreeMem(tmp);
//    end;
    if i = HASH_KEY_IS_LONG then oVars.Add(IntToStr(idx),val)
    else if i = HASH_KEY_IS_STRING then oVars.Add(AnsiString(key),val);
    FreeMem(tmp);
    zend_hash_move_forward_ex(value^.value.ht, pos);
    Result := True;
  end;
end;

function ZValToArrayVariable(value:pzval):TArrayVariable;
begin
  ZValToArrayVariable(value,Result);
end;

{ TPHPFunctions }

function TPHPFunctions.Add: TPHPFunction;
begin
  Result := TPHPFunction(inherited Add);
end;

constructor TPHPFunctions.Create(AOwner: TPersistent;
  ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
  FOwner := AOwner;
end;

function TPHPFunctions.FunctionByName(const AName: AnsiString): TPHPFunction;
var
  cnt: integer;
begin
  Result := nil;
  for cnt := 0 to Count - 1 do
  begin
    if SameText(AName, Items[cnt].FunctionName) then
    begin
      Result := Items[cnt];
      break;
    end;
  end;
end;

function TPHPFunctions.GetItem(Index: integer): TPHPFunction;
begin
  Result := TPHPFunction(inherited GetItem(Index));
end;

function TPHPFunctions.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TPHPFunctions.SetItem(Index: integer; Value: TPHPFunction);
begin
  inherited SetItem(Index, TCollectionItem(Value));
end;

procedure TPHPFunctions.SetItemName(Item: TCollectionItem);
var
  I, J: integer;
  ItemName: string;
  CurItem: TPHPFunction;
begin
  J := 1;
  while True do
  begin
    ItemName := Format('phpfunction%d', [J]);
    I := 0;
    while I < Count do
    begin
      CurItem := Items[I] as TPHPFunction;
      if (CurItem <> Item) and (CompareText(CurItem.FunctionName, ItemName) = 0)
      then
      begin
        Inc(J);
        break;
      end;
      Inc(I);
    end;
    if I >= Count then
    begin
      (Item as TPHPFunction).FunctionName := ItemName;
      break;
    end;
  end;
end;

{ TPHPFunction }

procedure TPHPFunction.AssignTo(Dest: TPersistent);
begin
  if Dest is TPHPFunction then
  begin
    if Assigned(Collection) then
      Collection.BeginUpdate;
    try
      with TPHPFunction(Dest) do
      begin
        Tag := Self.Tag;
        Parameters.Assign(Self.Parameters);
        Description := Self.Description;
        FunctionName := Self.FunctionName;
      end;
    finally
      if Assigned(Collection) then
        Collection.EndUpdate;
    end;
  end
  else
    inherited AssignTo(Dest);
end;

constructor TPHPFunction.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FFunctionParams := TFunctionParams.Create(TPHPFunctions(Self.Collection)
    .GetOwner, TFunctionParam);
end;

destructor TPHPFunction.Destroy;
begin
  FOnExecute := nil;
  FFunctionParams.Free;
  inherited;
end;

function TPHPFunction.GetDisplayName: string;
begin
  if FFunctionName = '' then
    Result := inherited GetDisplayName
  else
    Result := FFunctionName;
end;

procedure TPHPFunction.SetDisplayName(const Value: string);
var
  I: integer;
  F: TPHPFunction;
  NameValue: AnsiString;
begin
  NameValue := Value;
  if AnsiCompareText(NameValue, FFunctionName) <> 0 then
  begin
    if Collection <> nil then
      for I := 0 to Collection.Count - 1 do
      begin
        F := TPHPFunctions(Collection).Items[I];
        if (F <> Self) and (F is TPHPFunction) and
          (AnsiCompareText(NameValue, F.FunctionName) = 0) then
          raise Exception.CreateFmt('Duplicate function name: %s', [Value]);
      end;
    FFunctionName := AnsiLowerCase(Value);
    Changed(False);
  end;
end;

procedure TPHPFunction._SetDisplayName(const Value: AnsiString);
var
  NewName: string;
begin
  NewName := Value;
  SetDisplayName(NewName);
end;

procedure TPHPFunction.SetFunctionParams(const Value: TFunctionParams);
begin
  FFunctionParams.Assign(Value);
end;

{ TFunctionParams }

function TFunctionParams.Add: TFunctionParam;
begin
  Result := TFunctionParam(inherited Add);
end;

constructor TFunctionParams.Create(Owner: TPersistent;
  ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
  FOwner := Owner;
end;

function TFunctionParams.GetItem(Index: integer): TFunctionParam;
begin
  Result := TFunctionParam(inherited GetItem(Index));
end;

function TFunctionParams.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

function TFunctionParams.ParamByName(AName: string): TFunctionParam;
var
  I: integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if SameText(AName, Items[I].Name) then
    begin
      Result := Items[I];
      break;
    end;
  end;
end;

procedure TFunctionParams.SetItem(Index: integer; Value: TFunctionParam);
begin
  inherited SetItem(Index, TCollectionItem(Value));
end;

procedure TFunctionParams.SetItemName(Item: TCollectionItem);
var
  I, J: integer;
  ItemName: string;
  CurItem: TFunctionParam;
begin
  J := 1;
  while True do
  begin
    ItemName := Format('Param%d', [J]);
    I := 0;
    while I < Count do
    begin
      CurItem := Items[I] as TFunctionParam;
      if (CurItem <> Item) and (CompareText(CurItem.Name, ItemName) = 0) then
      begin
        Inc(J);
        break;
      end;
      Inc(I);
    end;
    if I >= Count then
    begin
      (Item as TFunctionParam).Name := ItemName;
      break;
    end;
  end;
end;

function TFunctionParams.Values(AName: string): variant;
var
  P: TFunctionParam;
begin
  Result := NULL;
  P := ParamByName(AName);
  if Assigned(P) then
    Result := P.Value;
end;

{ TFunctionParam }

procedure TFunctionParam.AssignTo(Dest: TPersistent);
begin
  if Dest is TFunctionParam then
  begin
    if Assigned(Collection) then
      Collection.BeginUpdate;
    try
      with TFunctionParam(Dest) do
      begin
        ParamType := Self.ParamType;
        Name := Self.Name;
      end;
    finally
      if Assigned(Collection) then
        Collection.EndUpdate;
    end;
  end
  else
    inherited AssignTo(Dest);
end;

constructor TFunctionParam.Create(Collection: TCollection);
begin
  inherited;
  FZendVariable := TZendVariable.Create;
end;

destructor TFunctionParam.Destroy;
begin
  FZendVariable.Free;
  inherited;
end;

function TFunctionParam.GetDisplayName: string;
begin
  if FName = '' then
    Result := inherited GetDisplayName
  else
    Result := FName;
end;

function TFunctionParam.GetValue: variant;
begin
  Result := FZendVariable.AsVariant;
end;

function TFunctionParam.GetZendValue: PZval;
begin
  Result := FZendVariable.FValue;
end;

procedure TFunctionParam.SetDisplayName(const Value: string);
var
  I: integer;
  F: TFunctionParam;
begin
  if AnsiCompareText(Value, FName) <> 0 then
  begin
    if Collection <> nil then
      for I := 0 to Collection.Count - 1 do
      begin
        F := TFunctionParams(Collection).Items[I];
        if ((F <> Self) and (F is TFunctionParam) and
          (AnsiCompareText(Value, F.Name) = 0)) then
          raise Exception.Create('Duplicate parameter name');
      end;
    FName := Value;
    Changed(False);
  end;
end;

procedure TFunctionParam.SetValue(const Value: variant);
begin
  FZendVariable.AsVariant := Value;
end;

procedure TFunctionParam.SetZendValue(const Value: PZval);
begin
  FZendVariable.AsZendVariable := Value;
end;

{ TZendVariable }

constructor TZendVariable.Create;
begin
  inherited Create;
  New(FArrayValue);
  FValue := nil;
end;

destructor TZendVariable.Destroy;
begin
  FreeMem(FArrayValue);
  inherited;
end;

function TZendVariable.GetAsBoolean: boolean;
begin
  if not Assigned(FValue) then
  begin
    Result := False;
    Exit;
  end;

  case FValue^._type of
    IS_STRING:
      begin
        if SameText(GetAsString, 'True') then
          Result := True
        else
          Result := False;
      end;
    IS_BOOL:
      Result := (FValue^.Value.lval = 1);
    IS_LONG, IS_RESOURCE:
      Result := (FValue^.Value.lval = 1);
  else
    Result := False;
  end;
end;

function TZendVariable.GetAsDate: TDateTime;
begin
  if not Assigned(FValue) then
  begin
    Result := 0;
    Exit;
  end;

  case FValue^._type of
    IS_STRING:
      Result := StrToDate(GetAsString);
    IS_DOUBLE:
      Result := FValue^.Value.dval;
  else
    Result := 0;
  end;
end;

function TZendVariable.GetAsDateTime: TDateTime;
begin
  if not Assigned(FValue) then
  begin
    Result := 0;
    Exit;
  end;

  case FValue^._type of
    IS_STRING:
      Result := StrToDateTime(GetAsString);
    IS_DOUBLE:
      Result := FValue^.Value.dval;
  else
    Result := 0;
  end;
end;

{$IFDEF VERSION5}

function StrToFloatDef(const S: string; const Default: Extended): Extended;
begin
  if not TextToFloat(PAnsiChar(S), Result, fvExtended) then
    Result := Default;
end;
{$ENDIF}

function TZendVariable.GetAsFloat: double;
begin
  if not Assigned(FValue) then
  begin
    Result := 0;
    Exit;
  end;

  case FValue^._type of
    IS_STRING:
      Result := StrToFloatDef(GetAsString, 0.0);
    IS_DOUBLE:
      Result := FValue^.Value.dval;
    IS_LONG  :
      Result := FValue^.value.lval;
  else
    Result := 0;
  end;
end;

function TZendVariable.GetAsInteger: integer;
begin
  if not Assigned(FValue) then
  begin
    Result := 0;
    Exit;
  end;

  case FValue^._type of
    IS_STRING:
      Result := StrToIntDef(GetAsString, 0);
    IS_DOUBLE:
      Result := Round(FValue^.Value.dval);
    IS_NULL:
      Result := 0;
    IS_LONG:
      Result := FValue^.Value.lval;
    IS_BOOL:
      Result := FValue^.Value.lval;
    IS_RESOURCE:
      Result := FValue^.Value.lval;
  else
    Result := 0;
  end;
end;

function TZendVariable.GetAsString: AnsiString;
begin
  if not Assigned(FValue) then
  begin
    Result := '';
    Exit;
  end;

  case FValue^._type of
    IS_STRING:
      begin
        try
          SetLength(Result, FValue^.Value.str.len);
          Move(FValue^.Value.str.val^, Result[1], FValue^.Value.str.len);
        except
          Result := '';
        end;
      end;
    IS_DOUBLE:
      Result := FloatToStr(FValue^.Value.dval);
    IS_LONG:
      Result := IntToStr(FValue^.Value.lval);
    IS_NULL:
      Result := '';
    IS_RESOURCE:
      Result := IntToStr(FValue^.Value.lval);
    IS_BOOL:
      begin
        if FValue^.Value.lval = 1 then
          Result := 'True'
        else
          Result := 'False';
      end;
  else
    Result := '';
  end;
end;

function TZendVariable.GetAsTime: TDateTime;
begin
  if not Assigned(FValue) then
  begin
    Result := 0;
    Exit;
  end;

  case FValue^._type of
    IS_STRING:
      Result := StrToTime(GetAsString);
    IS_DOUBLE:
      Result := FValue^.Value.dval;
  else
    Result := 0;
  end;
end;

function TZendVariable.GetAsVariant: variant;
begin
  if not Assigned(FValue) then
  begin
    Result := NULL;
    Exit;
  end;

  Result := zval2variant(FValue^);
end;

function TZendVariable.GetDataType: integer;
begin
  if not Assigned(FValue) then
  begin
    Result := IS_NULL;
    Exit;
  end;

  Result := FValue^._type;
end;

function TZendVariable.GetIsNull: boolean;
begin
  if not Assigned(FValue) then
  begin
    Result := True;
    Exit;
  end;
  Result := FValue^._type = IS_NULL;
end;

function TZendVariable.GetTypeName: string;
begin
  if not Assigned(FValue) then
  begin
    Result := 'null';
    Exit;
  end;

  case FValue^._type of
    IS_NULL:
      Result := 'null';
    IS_LONG:
      Result := 'integer';
    IS_DOUBLE:
      Result := 'double';
    IS_STRING:
      Result := 'string';
    IS_ARRAY:
      Result := 'array';
    IS_OBJECT:
      Result := 'object';
    IS_BOOL:
      Result := 'boolean';
    IS_RESOURCE:
      Result := 'resource';
  else
    Result := 'unknown';
  end;
end;


procedure TZendVariable.NewValue;
begin
  //FValue := MAKE_STD_ZVAL;
  //ZVAL_EMPTY_STRING(FValue);
  //ZVAL_STRINGL(FValue,'',1,True);
end;

procedure TZendVariable.SetAsBoolean(const Value: boolean);
begin
  if not Assigned(FValue) then
  begin
    Exit;
  end;
  ZVAL_BOOL(FValue, Value);
end;

procedure TZendVariable.SetAsDate(const Value: TDateTime);
begin
  if not Assigned(FValue) then
  begin
    Exit;
  end;
  ZVAL_DOUBLE(FValue, Value);
end;

procedure TZendVariable.SetAsDateTime(const Value: TDateTime);
begin
  if not Assigned(FValue) then
  begin
    Exit;
  end;
  ZVAL_DOUBLE(FValue, Value);
end;

procedure TZendVariable.SetAsFloat(const Value: double);
begin
  if not Assigned(FValue) then
  begin
    Exit;
  end;
  ZVAL_DOUBLE(FValue, Value);
end;

procedure TZendVariable.SetAsInteger(const Value: integer);
begin
  if not Assigned(FValue) then
  begin
    Exit;
  end;
  ZVAL_LONG(FValue, Value);
end;

procedure TZendVariable.SetAsString(const Value: AnsiString);
begin
  if not Assigned(FValue) then
  begin
    Exit;
  end;
  ZVAL_STRINGL(FValue, PAnsiChar(Value), Length(Value), True);
end;

procedure TZendVariable.SetAsTime(const Value: TDateTime);
begin
  if not Assigned(FValue) then
  begin
    Exit;
  end;
  ZVAL_DOUBLE(FValue, Value);
end;

procedure TZendVariable.SetAsVariant(const Value: variant);
begin
  if not Assigned(FValue) then
  begin
    Exit;
  end;
  variant2zval(Value, FValue);
end;

procedure TZendVariable.UnAssign;
begin

  if not Assigned(FValue) then
  begin
    Exit;
  end;
  ZVAL_NULL(FValue);
end;

function TZendVariable.UsePPZVal:Boolean;
begin
  Result := Assigned(FArrayValue) and Assigned(FArrayValue^) and Assigned(FArrayValue^^);
  if Result then FValue := FArrayValue^^;
end;

{ TArrayZendVariable }

{ TArrayZendVariable }

procedure TArrayZendVariable.ClearKeyAndObj;
var
  obj:TZendVariable;
  keys:TArray<string>;
  i:Integer;
begin
  keys := Self.Keys.ToArray;
  for i := Low(keys) to High(keys) do
  begin
    obj := Self.Items[keys[i]];
    FreeAndNil(obj);
  end;
  Clear;
end;

procedure TArrayZendVariable.DelKeyAndObj(key: string);
var
  obj:TZendVariable;
begin
  if (Self.ContainsKey(key)) then
  begin
    obj := Self.Items[key];
    FreeAndNil(obj);
  end;
  Remove(key);
end;

destructor TArrayZendVariable.Destroy;
begin
  ClearKeyAndObj;
  inherited;
end;

function TArrayZendVariable.IsExists(s: string): Boolean;
begin
  Result := ContainsKey(s);
end;

{ TArrayVariable }

function TArrayVariable.IsExists(s: string): Boolean;
begin
  Result := ContainsKey(s);
end;

{ TPHPExtConstants }

function TPHPExtConstants.Add: TPHPExtConstant;
begin
  Result := TPHPExtConstant(inherited Add);
end;

function TPHPExtConstants.ConstantByName(AName: string): TPHPExtConstant;
var
  I: integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if SameText(AName, Items[I].Name) then
    begin
      Result := Items[I];
      break;
    end;
  end;
end;

constructor TPHPExtConstants.Create(Owner: TPersistent;
  ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
  FOwner := Owner;
end;

function TPHPExtConstants.GetItem(Index: integer): TPHPExtConstant;
begin
  Result := TPHPExtConstant(inherited GetItem(Index));
end;

function TPHPExtConstants.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TPHPExtConstants.SetItem(Index: integer; Value: TPHPExtConstant);
begin
  inherited SetItem(Index, TCollectionItem(Value));
end;

procedure TPHPExtConstants.SetItemName(Item: TCollectionItem);
var
  I, J: integer;
  ItemName: string;
  CurItem: TPHPExtConstant;
begin
  J := 1;
  while True do
  begin
    ItemName := Format('Const%d', [J]);
    I := 0;
    while I < Count do
    begin
      CurItem := Items[I] as TPHPExtConstant;
      if (CurItem <> Item) and (CompareText(CurItem.Name, ItemName) = 0) then
      begin
        Inc(J);
        break;
      end;
      Inc(I);
    end;
    if I >= Count then
    begin
      (Item as TPHPExtConstant).Name := ItemName;
      break;
    end;
  end;
end;

function TPHPExtConstants.Values(AName: string): variant;
var
  P: TPHPExtConstant;
begin
  Result := NULL;
  P := ConstantByName(AName);
  if Assigned(P) then
    Result := P.Value;
end;

{ TPHPExtConstant }

procedure TPHPExtConstant.AssignTo(Dest: TPersistent);
begin
  if Dest is TPHPExtConstant then
  begin
    if Assigned(Collection) then
      Collection.BeginUpdate;
    try
      with TFunctionParam(Dest) do
      begin
        ParamType := Self.ConstantType;
        Name := Self.Name;
      end;
    finally
      if Assigned(Collection) then
        Collection.EndUpdate;
    end;
  end
  else
    inherited AssignTo(Dest);
end;

constructor TPHPExtConstant.Create(Collection: TCollection);
begin
  inherited;
  FValue := '';
end;

destructor TPHPExtConstant.Destroy;
begin
  inherited;
end;

function TPHPExtConstant.GetDisplayName: string;
begin
  if FName = '' then
    Result := inherited GetDisplayName
  else
    Result := FName;
end;

procedure TPHPExtConstant.SetDisplayName(const Value: string);
var
  I: integer;
  F: TPHPExtConstant;
begin
  if AnsiCompareText(Value, FName) <> 0 then
  begin
    if Collection <> nil then
      for I := 0 to Collection.Count - 1 do
      begin
        F := TPHPExtConstants(Collection).Items[I];
        if ((F <> Self) and (F is TPHPExtConstant) and
          (AnsiCompareText(Value, F.Name) = 0)) then
          raise Exception.Create('Duplicate Constant name');
      end;
    FName := Value;
    Changed(False);
  end;
end;

end.
