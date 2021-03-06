unit IDBEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, TypInfo, dbctrls,


  uEstSearchDialogConst,
  uEstSearchDialogTypes,
  fEstSearchDialog,
  uEstSearchDialogIntl,
  uEstSearchDialogDefaults,
  fEstSearchDialogPresetCustomize,
  uEstSearchDialog,
  ISFdbEditbtn,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet;


const
  REG_LOCATION = 'Software\Sistemas';
  
type

  TIDBEdit = class(TISFdbEditBtn)
  private
    { Private declarations }

    FFocusControl       : TWinControl;
    
    FdbComponenteSQL    : TFDQuery;

    FSQLSearch          : TStringList;
    FCampoRetorno,
    FRetornoVazio,
    FButtonClickForm,
    
    FCampoParametro     : String;
    FSQLdbFazBusca      : Boolean;
    FSQLdbMaxLenght     : Integer;

    FOnClickBtn:TNotifyEvent;
    FButtonSearchDialog  : Boolean;
    FButtonKeyActive     : Boolean;
    FButtonKeyClick      : TShortCut;

    // -------------------------------------------------------------------
    // ---    Componente de pesquisa                                   ---
    // -------------------------------------------------------------------
    FFrmSearchDialog: TFrmEstSearchDialog;

    FSearchSql: String;
    FCountSql: String;

    FMaxCriteria: Integer;
    FCriteriaCount: Integer;
    FMax: Integer;
    FSearchDialogFieldList: TEstSearchDialogFieldList;
    FSearchPresetList: TEstSearchPresetList;
    FSearchQuery: TStrings;
    FCountQuery: TStrings;
    FResultRecord: TEstSearchDialogResultRecord;
    FResultQuery: String;
    FRegistryPath: String;
    FDialogWidth: Integer;
    FDialogHeight: Integer;
    FDialogCaption: String;
    FStore: TEstSearchDialogStore;
    FStoreVersion: Integer;
    FQuoteChar: Char;
    FDecimalChar: Char;
    FCompareFormatDate: String;
    FCompareFormatDateTime: String;
    FCompareFormatTime: String;
    FQuotedDateTime: Boolean;
    FTrueExpression: String;
    FAdditionalWhere: String;
    FOnFilterRecord: TFilterRecordEvent;
    FOnBeforeExecuteCountQuery: TEstSearchDialogBeforeExecuteQueryEvent;
    FOnAfterExecuteCountQuery: TEstSearchDialogAfterExecuteQueryEvent;
    FOnBeforeExecuteSearchQuery: TEstSearchDialogBeforeExecuteQueryEvent;
    FOnAfterExecuteSearchQuery: TEstSearchDialogAfterExecuteQueryEvent;
    FOnInitControls: TEstSearchDialogInitControlsEvent;
    FOnSelect: TNotifyEvent;
    FStartOpen: Boolean;
    FStartPreset: Integer;
    FSearchStyle: TSearchStyle;
    FOnClose: TNotifyEvent;
    FCaseFormatLower: String;
    FCaseFormatUpper: String;
    FDefaults: TEstSearchDialogDefaults;
    FDefaultSet: TEstSearchDialogDefaultSet;
    FShowPresets: Boolean;
    FShowPresetsCustomization: Boolean;
    FShowHint: Boolean;
    FIgnoreEmptyValues: Boolean;
    FClearValueOnFieldChange: Boolean;
    FHelpKeyWord: String;
    FHelpContext: THelpContext;
    FHelpType: THelpType;


    // -------------------------------------------------------------------
    // ---                ZEOS                                         ---
    // -------------------------------------------------------------------

    FDBAccessDialog, FDBAccessDialogBkp : TFDConnection;
    FZSearchQuery: TFDQuery;
    FZcountQuery: TFDQuery;


    // -------------------------------------------------------------------
    // ---                                                             ---
    // -------------------------------------------------------------------
    procedure       SetSQL(const Value: TStringList);
    procedure       SetFocusControl(Value: TWinControl);
    procedure       WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;

    procedure       CriarForm;

  protected
    { Protected declarations }
    procedure BtnClicar (Sender: TObject); virtual;

    // -------------------------------------------------------------------
    // ---                ZEOS                                         ---
    // -------------------------------------------------------------------

    procedure ZSetConnection(const Value: TFDConnection); virtual;

    function ZSearchDataSet: TDataSet; virtual;
    function ZCountDataSet: TDataSet; virtual;

    procedure ZDoSetSearchQuery(Sender: TObject; SQL: String); virtual;
    procedure ZDoSetCountQuery(Sender: TObject; SQL: String); virtual;

    function ZValidConnection: Boolean; virtual;

    procedure ZNotification(AComponent: TComponent; Operation: TOperation); virtual;
 

    // -------------------------------------------------------------------
    // ---                                                             ---
    // -------------------------------------------------------------------
    procedure Change;      override;
    Function  ExecutaSQL : string;

    // -------------------------------------------------------------------
    // ---    Componente de pesquisa                                   ---
    // -------------------------------------------------------------------
    procedure DoDialogSetup(Sender: TObject); virtual;

    procedure DoBeforeSearchQueryOpen(DataSet: TDataSet); virtual;
    procedure DoAfterSearchQueryOpen(DataSet: TDataSet); virtual;

    procedure DoBeforeCountQueryOpen(DataSet: TDataSet); virtual;
    procedure DoAfterCountQueryOpen(DataSet: TDataSet); virtual;

    procedure SetCriteriaCount(const Value: Integer); virtual;
    procedure SetMaxCriteria(const Value: Integer); virtual;
    procedure SetSearchDialogFieldList(const Value: TEstSearchDialogFieldList); virtual;

    procedure SetCaseFormatLower(const Value: String); virtual;
    procedure SetCaseFormatUpper(const Value: String); virtual;

    procedure SetDefaults(const Value: TEstSearchDialogDefaults); virtual;
    procedure CopyDefaults; virtual;

    function SearchDataSet: TDataSet; virtual; abstract;
    function CountDataSet: TDataSet; virtual; abstract;

    procedure DoSetSearchQuery(Sender: TObject; SQL: String); virtual;
    procedure DoSetCountQuery(Sender: TObject; SQL: String); virtual;

    function ValidConnection: Boolean; virtual; abstract;

    procedure DoOK(Sender: TObject); virtual;
    procedure DoCancel(Sender: TObject); virtual;

    procedure DoClose; virtual;
    procedure DoSelect; virtual;

    procedure DoInitControls(Sender: TObject;
                             Field: TEstSearchDialogField;
                             FieldControl: TComboBox;
                             Comparison: TSearchComparison;
                             ComparisonControl: TComboBox;
                             ValueControl: TEdit;
                             UsingOperator: Boolean;
                             OperatorControl: TComboBox); virtual;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

  public
    { Public declarations }

    constructor Create(aOwner:TComponent); override;

    destructor Destroy; override;

    // -------------------------------------------------------------------
    // ---    Componente de pesquisa                                   ---
    // -------------------------------------------------------------------
    procedure AssignTo(Dest: TPersistent); override;

    function Execute: Boolean; virtual;
    procedure Close; virtual;

    // campos retornos
    function ResultFieldAsString(FieldName: String): String; overload;
    function ResultFieldAsString(FieldName: String; Default: String): String; overload;
    function ResultFieldAsInteger(FieldName: String): Integer; overload;
    function ResultFieldAsInteger(FieldName: String; Default: Integer): Integer; overload;
    function ResultFieldAsFloat(FieldName: String): Double; overload;
    function ResultFieldAsFloat(FieldName: String; Default: Double): Double; overload;
    function ResultFieldAsDateTime(FieldName: String): TDateTime; overload;
    function ResultFieldAsDateTime(FieldName: String; Default: TDateTime): TDateTime; overload;

    function ResultFieldExists(FieldName: String): Boolean;
    function ResultFieldIsNull(FieldName: String): Boolean;

    function FullRegistryPath: string; virtual;

    property ResultQuery: String read FResultQuery;

    // -------------------------------------------------------------------
    // ---                ZEOS                                         ---
    // -------------------------------------------------------------------


  published
    { Published declarations }

    // -------------------------------------------------------------------
    // ---                                                             ---
    // -------------------------------------------------------------------




    property        OnClickBtn: TNotifyEvent read FOnClickBtn write FOnClickBtn;
    property        ButtonSearchDialog    : Boolean read FButtonSearchDialog write FButtonSearchDialog  default True;
    property        ButtonKeyActive       : Boolean read FButtonKeyActive write FButtonKeyActive  default True;
    property        ButtonKeyClickBtn     : TShortCut read FButtonKeyClick write FButtonKeyClick  default 0;

    
    property        SQLdbFazBusca         : Boolean read FSQLdbFazBusca write FSQLdbFazBusca default False;
    property        SQLdbFocusControl     : TWinControl read FFocusControl write SetFocusControl;
    property        SQLdbCampoRetorno     : string read FCampoRetorno write FCampoRetorno;
    property        SQLdbRetornoVazio     : string read FRetornoVazio write FRetornoVazio;
    property        SQLdbCampoParametro   : string read FCampoParametro write FCampoParametro;
    property        SQLdbSQL              : TStringList read FSQLSearch write SetSQL;
    property        SQLdbMaxLenght        : Integer read  FSQLdbMaxLenght write FSQLdbMaxLenght;
    property        ButtonClickForm       : string  read  FButtonClickForm write FButtonClickForm;

    // -------------------------------------------------------------------
    // ---    Componente de pesquisa                                   ---
    // -------------------------------------------------------------------
    property SearchStyle: TSearchStyle read FSearchStyle write FSearchStyle default ssModal;

    property CriteriaCount: Integer read FCriteriaCount write SetCriteriaCount default 1;
    property MaxCriteria: Integer read FMaxCriteria write SetMaxCriteria default 1;

    property SearchQuery: TStrings read FSearchQuery write FSearchQuery;
    property CountQuery: TStrings read FCountQuery write FCountQuery;
    property Max: Integer read FMax write FMax default 0;

    property SearchDialogFieldList: TEstSearchDialogFieldList read FSearchDialogFieldList
                                                              write FSearchDialogFieldList;

    property SearchPresetList: TEstSearchPresetList read FSearchPresetList
                                                    write FSearchPresetList;

    property ShowPresets: Boolean read FShowPresets write FShowPresets default True;
    property ShowPresetsCustomization: Boolean read FShowPresetsCustomization write FShowPresetsCustomization default False;

    property ShowHint: Boolean read FShowHint write FShowHint default False;

    property CaseFormatUpper: String read FCaseFormatUpper write SetCaseFormatUpper;
    property CaseFormatLower: String read FCaseFormatLower write SetCaseFormatLower;

    property RegistryPath: string read FRegistryPath write FRegistryPath;

    property DialogCaption: String read FDialogCaption write FDialogCaption;
    property DialogWidth: Integer read FDialogWidth write FDialogWidth;
    property DialogHeight: Integer read FDialogHeight write FDialogHeight;

    property Store: TEstSearchDialogStore read FStore write FStore;
    property StoreVersion: Integer read FStoreVersion write FStoreVersion default 0;

    property CompareFormatDate: String read FCompareFormatDate write FCompareFormatDate;
    property CompareFormatTime: String read FCompareFormatTime write FCompareFormatTime;
    property CompareFormatDateTime: String read FCompareFormatDateTime write FCompareFormatDateTime;
    property QuotedDateTime: Boolean read FQuotedDateTime write FQuotedDateTime default True;

    property QuoteChar: Char read FQuoteChar write FQuoteChar default '''';
    property DecimalChar: Char read FDecimalChar write FDecimalChar default '.';

    property IgnoreEmptyValues: Boolean read FIgnoreEmptyValues write FIgnoreEmptyValues default True;
    property ClearValueOnFieldChange: Boolean read FClearValueOnFieldChange write FClearValueOnFieldChange default True;

    property TrueExpression: String read FTrueExpression write FTrueExpression;
    property AdditionalWhere: String read FAdditionalWhere write FAdditionalWhere;
    property StartOpen: Boolean read FStartOpen write FStartOpen default False;
    property StartPreset: Integer read FStartPreset write FStartPreset default -1;

    property Defaults: TEstSearchDialogDefaults read FDefaults write SetDefaults;
    property DefaultSet: TEstSearchDialogDefaultSet read FDefaultSet write FDefaultSet;

    property HelpContext: THelpContext read FHelpContext write FHelpContext default 0;
    property HelpKeyWord: String read FHelpKeyWord write FHelpKeyWord;
    property HelpType: THelpType read FHelpType write FHelpType default htContext;

    property OnFilterRecord: TFilterRecordEvent read FOnFilterRecord write FOnFilterRecord;

    property OnBeforeExecuteSearchQuery: TEstSearchDialogBeforeExecuteQueryEvent
                                           read FOnBeforeExecuteSearchQuery
                                           write FOnBeforeExecuteSearchQuery;
    property OnAfterExecuteSearchQuery: TEstSearchDialogAfterExecuteQueryEvent
                                          read FOnAfterExecuteSearchQuery
                                          write FOnAfterExecuteSearchQuery;

    property OnBeforeExecuteCountQuery: TEstSearchDialogBeforeExecuteQueryEvent
                                           read FOnBeforeExecuteCountQuery
                                           write FOnBeforeExecuteCountQuery;
    property OnAfterExecuteCountQuery: TEstSearchDialogAfterExecuteQueryEvent
                                          read FOnAfterExecuteCountQuery
                                          write FOnAfterExecuteCountQuery;

    property OnInitControls: TEstSearchDialogInitControlsEvent read FOnInitControls
                                                               write FOnInitControls;

    property OnSelect: TNotifyEvent read FOnSelect write FOnSelect;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;

    // -------------------------------------------------------------------
    // ---                ZEOS                                         ---
    // -------------------------------------------------------------------
    property ConnectionDialog: TFDConnection read FDBAccessDialog write ZSetConnection;


  end;

  //TEstSearchDialogClass = class of TEstSearchDialog;
  TEstSearchDialogClass = class of TIDBEdit;


  procedure RegisterSearchDialogFormClass(FrmEstSearchDialogClass: TFrmEstSearchDialogClass);
  procedure RegisterSearchDialogPresetCustomizeFormClass(FrmEstSearchDialogPresetCustomizeClass: TFrmEstSearchDialogPresetCustomizeClass);

{
procedure Register;
}

implementation

var
  InternalFrmEstSearchDialogClass: TFrmEstSearchDialogClass;
  InternalFrmEstSearchDialogPresetCustomizeClass: TFrmEstSearchDialogPresetCustomizeClass;

{
procedure Register;
begin
  // RegisterComponents('ISOFT Edits', [TIDBEdit]);
end;
}

constructor TIDBEdit.Create(aOwner: TComponent);
begin

  inherited Create(AOwner);

  // -------------------------------------------------------------------
  // ---                                                             ---
  // -------------------------------------------------------------------
  FSQLSearch                  := TStringList.Create;
  ControlStyle                := ControlStyle + [csReplicatable];
  FdbComponenteSQL            := TFDQuery.Create(Self) ;
  FSQLdbMaxLenght             := 10;
  self.LabelAlwaysEnabled     := True;
  FButtonKeyActive            := True;
  FButtonSearchDialog         := True;
  self.ButtonHint             := 'Procurar...';
  self.LabelCaption           := 'Label';
  self.SQLdbRetornoVazio      :=' *** ';
  self.Button.OnClick         := BtnClicar;

  // -------------------------------------------------------------------
  // ---    Componente de pesquisa                                   ---
  // -------------------------------------------------------------------
  // Init privates
  //FFrmSearchDialog := nil;

  FSearchSql := '';
  FCountSql := '';

  FMaxCriteria := 1;
  FCriteriaCount := 1;
  FMax := 0;
  FResultQuery := '';

  FSearchDialogFieldList := TEstSearchDialogFieldList.Create(Self);
  FSearchPresetList := TEstSearchPresetList.Create(Self);

  FIgnoreEmptyValues := True;
  FClearValueOnFieldChange := True;

  FHelpKeyWord := '';
  FHelpContext := 0;
  FHelpType := htContext;

  FShowPresets := True;
  FShowPresetsCustomization := False;

  FShowHint := False;

  FDefaults := nil;
  FDefaultSet := [ddSearchStyle, ddCriteriaCount, ddMaxCriteria, ddMax,
                  ddCaseFormatUpper, ddCaseFormatLower, ddRegistryPath,
                  ddDialogCaption, ddDialogWidth, ddDialogHeight,
                  ddStore, ddCompareFormatDate, ddCompareFormatTime,
                  ddCompareFormatDateTime, ddQuotedDateTime, ddQuoteChar,
                  ddDecimalChar, ddTrueExpression, ddStartOpen,
                  ddIgnoreEmptyValues, ddShowPresets, ddClearValueOnFieldChange,
                  ddShowPresetsCustomization, ddShowHint];


  FSearchQuery := TStringList.Create;
  FCountQuery := TStringList.Create;
  SetLength(FResultRecord, 0);

  FStore := dsFields;
  FStoreVersion := 0;

  FRegistryPath := '';

  FDialogCaption := EstSearchDialogIntl.CaptionDialog;
  FDialogWidth := 0;
  FDialogHeight := 0;

  FCompareFormatDate := 'DDMMYYYY';
  FCompareFormatTime := 'HHMMSS';
  FCompareFormatDateTime := 'DDMMYYYY';
  FQuotedDateTime := True;

  FQuoteChar := '''';
  FDecimalChar := '.';

  FTrueExpression := '1=1';
  FAdditionalWhere := '';
  FStartOpen := False;
  FStartPreset := -1;
  FSearchStyle := ssModal;

  FCaseFormatLower := '';
  FCaseFormatUpper := '';

  FOnFilterRecord := nil;
  FOnBeforeExecuteCountQuery := nil;
  FOnAfterExecuteCountQuery := nil;
  FOnAfterExecuteSearchQuery := nil;
  FOnBeforeExecuteSearchQuery := nil;
  FOnInitControls := nil;
  FOnSelect := nil;
  FOnClose := nil;

    // -------------------------------------------------------------------
    // ---                ZEOS                                         ---
    // -------------------------------------------------------------------

  FDBAccessDialog := nil;

  FZSearchQuery := TFDQuery.Create(Self);
  FZcountQuery := TFDQuery.Create(Self);

  FDBAccessDialogBkp :=FDBAccessDialog;

 
end;

destructor TIDBEdit.Destroy;
begin

  fdbComponenteSQL.Free;
  FSQLSearch.Free;

  // -------------------------------------------------------------------
  // ---    Componente de pesquisa                                   ---
  // -------------------------------------------------------------------
  if Assigned(FFrmSearchDialog) then
    FFrmSearchDialog.Free;

  FSearchDialogFieldList.Free;
  FSearchPresetList.Free;

  FSearchQuery.Free;
  FCountQuery.Free;
  SetLength(FResultRecord, 0);

    // -------------------------------------------------------------------
    // ---                ZEOS                                         ---
    // -------------------------------------------------------------------
  FZSearchQuery.Free;
  FZcountQuery.Free;


  inherited Destroy;
end;

procedure TIDBEdit.AssignTo(Dest: TPersistent);
var
  DestSearchDialog : TIDBEdit;
begin

    // -------------------------------------------------------------------
    // ---                                                             ---
    // -------------------------------------------------------------------
  DestSearchDialog := Dest as TIDBEdit;

  DestSearchDialog.ConnectionDialog  := ConnectionDialog;

  DestSearchDialog.CriteriaCount := FCriteriaCount;
  DestSearchDialog.MaxCriteria := FMaxCriteria;

  DestSearchDialog.SearchQuery.Text := FSearchQuery.Text;
  DestSearchDialog.CountQuery.Text := FCountQuery.Text;
  DestSearchDialog.Max := FMax;

  DestSearchDialog.RegistryPath := FRegistryPath;

  DestSearchDialog.DialogCaption := FDialogCaption;
  DestSearchDialog.DialogWidth := FDialogWidth;
  DestSearchDialog.DialogHeight := FDialogHeight;
  DestSearchDialog.Store := FStore;

  DestSearchDialog.CompareFormatDate := FCompareFormatDate;
  DestSearchDialog.CompareFormatTime := FCompareFormatTime;
  DestSearchDialog.CompareFormatDateTime := FCompareFormatDateTime;
  DestSearchDialog.QuotedDateTime := FQuotedDateTime;

  DestSearchDialog.QuoteChar := FQuoteChar;
  DestSearchDialog.DecimalChar := FDecimalChar;

  DestSearchDialog.CaseFormatUpper := FCaseFormatUpper;
  DestSearchDialog.CaseFormatLower := FCaseFormatLower;

  DestSearchDialog.SearchStyle := FSearchStyle;

  DestSearchDialog.TrueExpression := FTrueExpression;
  DestSearchDialog.AdditionalWhere := FAdditionalWhere;
  DestSearchDialog.StartOpen := FStartOpen;
  DestSearchDialog.StartPreset := FStartPreset;

  DestSearchDialog.DefaultSet := FDefaultSet;
  DestSearchDialog.Defaults := FDefaults;

  DestSearchDialog.IgnoreEmptyValues := FIgnoreEmptyValues;
  DestSearchDialog.ClearValueOnFieldChange := FClearValueOnFieldChange;

  DestSearchDialog.HelpContext := FHelpContext;
  DestSearchDialog.HelpKeyWord := FHelpKeyWord;
  DestSearchDialog.HelpType := FHelpType;

  DestSearchDialog.SearchDialogFieldList.Assign(FSearchDialogFieldList);
  DestSearchDialog.SearchPresetList.Assign(FSearchPresetList);

  DestSearchDialog.ShowPresets := FShowPresets;
  DestSearchDialog.ShowPresetsCustomization := FShowPresetsCustomization;

  DestSearchDialog.OnFilterRecord := FOnFilterRecord;
  DestSearchDialog.OnBeforeExecuteSearchQuery := FOnBeforeExecuteSearchQuery;
  DestSearchDialog.OnAfterExecuteSearchQuery := FOnAfterExecuteSearchQuery;

  DestSearchDialog.OnBeforeExecuteCountQuery := FOnBeforeExecuteCountQuery;
  DestSearchDialog.OnAfterExecuteCountQuery := FOnAfterExecuteCountQuery;

  DestSearchDialog.OnInitControls := FOnInitControls;

  DestSearchDialog.OnSelect := FOnSelect;
  DestSearchDialog.OnClose := FOnClose;

    // -------------------------------------------------------------------
    // ---                ZEOS                                         ---
    // -------------------------------------------------------------------


end;

procedure TIDBEdit.BtnClicar (Sender: TObject);
begin

  if (DataSource=Nil) and (DataField>'') then
  Begin
    Showmessage('Programador(a), n�o foi definido um DataSource para o componente '+Self.Name);
    Exit;
  End;
  
  if FButtonSearchDialog then
  begin

     // Salva no campo
     If Self.Execute then
     begin

       // se n�o foi informado um "CAMPO" ent�o salvar na propriedade "TEXT" do
       // componente
       //if (DataField=nil) or (DataField='') then
       if (DataField='') then
       begin
          Self.Text :=Self.ResultFieldAsString( UpperCase( Trim(SQLdbCampoParametro)  ) );
       end
       else
       begin
          // se foi informado um "CAMPO" ent�o salvar diretamente no banco de dados

          // testar antes de salvar
          if not (DataSource.DataSet.State in [dsEdit,dsInsert]) then
             DataSource.DataSet.Edit;
          //begin
             //Self.Text :=Self.ResultFieldAsString( UpperCase( Trim(SQLdbCampoParametro)  ) );
             DataSource.DataSet.FieldByName(DataField).AsVariant :=ResultFieldAsString( UpperCase( Trim(SQLdbCampoParametro)  ) );

          //end;

       end;
       
     end;


  end;

  if Assigned(FOnClickBtn) then
     FOnClickBtn(Self);


end;

procedure TIDBEdit.Change;
begin

  //FDataLink.Modified;

  if Self.SQLdbFazBusca=True then
  begin
     ExecutaSQL;
  end;

  inherited;

end;

{ Executa Busca pr�-definida }
Function TIDBEdit.ExecutaSQL : string;
begin

  ConnectionDialog   := FDBAccessDialog;
  FDBAccessDialogBkp := FDBAccessDialog;

  {
  if (ConnectionDialog=Nil) then
  Begin
     ConnectionDialog := FDBAccessDialogBkp;
     if (ConnectionDialog=Nil) then
     Begin
        Showmessage('Programador(a), '+#10+#13+
        'n�o foi definido uma conex�o v�lida na propriedade "ConnectionDialog" para o componente '+Self.Name);
        Exit;
     End;
  End;
  }

  if Trim(Self.Text)='' then
  begin
     TEdit(Self.SQLdbFocusControl).Clear;

     if Self.SQLdbRetornoVazio<>'' then
        TEdit(Self.SQLdbFocusControl).Text :=Trim(Self.SQLdbRetornoVazio);

     exit;

  end;

  if Trim(FSQLSearch.Text)='' then
     exit;

  TEdit(Self.SQLdbFocusControl).Clear;

  Try
     FdbComponenteSQL.Connection :=ConnectionDialog;
     FdbComponenteSQL.close;
     FdbComponenteSQL.SQL.Clear;
     FdbComponenteSQL.SQL.Add ( FSQLSearch.Text );
     FdbComponenteSQL.ParamByName( UpperCase( Trim(FCampoParametro) )).AsString := Trim( UpperCase( Copy(Trim(Self.Text),1,Self.SQLdbMaxLenght) ) );
     FdbComponenteSQL.Open;

  Except
      begin

         FdbComponenteSQL.close;
         //TEdit(Self.SQLdbFocusControl).Text :=' ** COMPONENTE ** ';
         TEdit(Self.SQLdbFocusControl).Text :='***';
         Exit;
      end;
  End;


  if FdbComponenteSQL.RecordCount<=0 then
  begin
     TEdit(Self.SQLdbFocusControl).Clear;

     if Self.SQLdbRetornoVazio<>'' then
        TEdit(Self.SQLdbFocusControl).Text :=Trim(Self.SQLdbRetornoVazio);

     FdbComponenteSQL.close;
     Exit;
  end;

  FdbComponenteSQL.First;
  if   (Self.SQLdbFocusControl is  TEdit) then
  begin
     TEdit(Self.SQLdbFocusControl).Clear;
     TEdit(Self.SQLdbFocusControl).Text :=FdbComponenteSQL.FieldByName( UpperCase( Trim(Self.SQLdbCampoRetorno)) ).AsString;

  end;

end;


procedure TIDBEdit.SetFocusControl(Value: TWinControl);
begin
  FFocusControl := Value;

  if Value <> nil then
  Begin
     Value.FreeNotification(Self);
  End;

end;


procedure TIDBEdit.WMKeyDown(var Message: TWMKeyDown);
begin

  if (FButtonKeyClick <> 0)  and (FButtonKeyClick = ShortCut(Message.CharCode,
     KeyDataToShiftState(Message.KeyData))  )  and (FButtonKeyActive) then
  begin

     Self.BtnClicar( Self );

    Message.CharCode := 0;
  end;
  inherited;
end;

procedure TIDBEdit.SetSQL(const Value: TStringList);
begin
  FSQLSearch.Assign(Value);
end;

procedure TIDBEdit.CriarForm;
begin
  //


end;

// -------------------------------------------------------------------
// ---    Componente de pesquisa                                   ---
// -------------------------------------------------------------------

procedure RegisterSearchDialogFormClass(FrmEstSearchDialogClass: TFrmEstSearchDialogClass);
begin
  InternalFrmEstSearchDialogClass := FrmEstSearchDialogClass;
end;

{
  Procedure : RegisterSearchDialogPresetCustomizeFormClass
  Auteur    : Erik Stok
  Doel      : Geef een eigen TFrmEstSearchDialogPresetCustomizeClass afgeleide
              aan als te gebruiken form voor de search dialog preset customization
}
procedure RegisterSearchDialogPresetCustomizeFormClass(FrmEstSearchDialogPresetCustomizeClass: TFrmEstSearchDialogPresetCustomizeClass);
begin
  InternalFrmEstSearchDialogPresetCustomizeClass := FrmEstSearchDialogPresetCustomizeClass;
end;

{ TIDBEdit }


procedure TIDBEdit.SetSearchDialogFieldList(const Value: TEstSearchDialogFieldList);
begin
  FSearchDialogFieldList := Value;
end;

procedure TIDBEdit.SetCaseFormatLower(const Value: String);
begin
  FCaseFormatLower := Value;
end;

procedure TIDBEdit.SetCaseFormatUpper(const Value: String);
begin
  FCaseFormatUpper := Value;
end;

procedure TIDBEdit.SetDefaults(const Value: TEstSearchDialogDefaults);
begin
  // Zet defaults component
  FDefaults := Value;

  // Kopieer defaults naar component
  if Assigned(FDefaults) then
    CopyDefaults;
end;

{
  Procedure : TIDBEdit.CopyDefaults
  Auteur    : Erik Stok
  Doel      : Kopieer ingestelde defaults van defaults component naar dit component

}
procedure TIDBEdit.CopyDefaults;
begin

  if ddSearchStyle in FDefaultSet then
    SearchStyle := FDefaults.SearchStyle;

  if ddCriteriaCount in FDefaultSet then
    CriteriaCount := FDefaults.CriteriaCount;

  if ddMaxCriteria in FDefaultSet then
    MaxCriteria := FDefaults.MaxCriteria;

  if ddMax in FDefaultSet then
    Max := FDefaults.Max;

  if ddCaseFormatUpper in FDefaultSet then
    CaseFormatUpper := FDefaults.CaseFormatUpper;

  if ddCaseFormatLower in FDefaultSet then
    CaseFormatLower := FDefaults.CaseFormatLower;

  if ddRegistryPath in FDefaultSet then
    RegistryPath := FDefaults.RegistryPath;

  if ddDialogCaption in FDefaultSet then
    DialogCaption := FDefaults.DialogCaption;

  if ddDialogWidth in FDefaultSet then
    DialogWidth := FDefaults.DialogWidth;

  if ddDialogHeight in FDefaultSet then
    DialogHeight := FDefaults.DialogHeight;

  if ddStore in FDefaultSet then
    Store := FDefaults.Store;

  if ddCompareFormatDate in FDefaultSet then
    CompareFormatDate := FDefaults.CompareFormatDate;

  if ddCompareFormatTime in FDefaultSet then
    CompareFormatTime := FDefaults.CompareFormatTime;

  if ddCompareFormatDateTime in FDefaultSet then
    CompareFormatDateTime := FDefaults.CompareFormatDateTime;

  if ddQuotedDateTime in FDefaultSet then
    QuotedDateTime := FDefaults.QuotedDateTime;

  if ddQuoteChar in FDefaultSet then
    QuoteChar := FDefaults.QuoteChar;

  if ddDecimalChar in FDefaultSet then
    DecimalChar := FDefaults.DecimalChar;

  if ddTrueExpression in FDefaultSet then
    TrueExpression := FDefaults.TrueExpression;

  if ddStartOpen in FDefaultSet then
    StartOpen := FDefaults.StartOpen;

  if ddIgnoreEmptyValues in FDefaultSet then
    IgnoreEmptyValues := FDefaults.IgnoreEmptyValues;

  if ddShowPresets in FDefaultSet then
    ShowPresets := FDefaults.ShowPresets;

  if ddShowPresetsCustomization in FDefaultSet then
    ShowPresetsCustomization := FDefaults.ShowPresetsCustomization;

  if ddShowHint in FDefaultSet then
    ShowHint := FDefaults.ShowHint;

  if ddClearValueOnFieldChange in FDefaultSet then
    ClearValueOnFieldChange := FDefaults.ClearValueOnFieldChange;
end;

{
  Procedure : TIDBEdit.DoDialogSetup
  Auteur    : Erik Stok
  Doel      : Stel het dialog in volgens de properties van het component
}
procedure TIDBEdit.DoDialogSetup(Sender: TObject);
var
  Dialog : TfrmEstSearchDialog;
begin
  // Cast naar een TfrmEstSearchDialog
  Dialog := (Sender as TfrmEstSearchDialog);

  Dialog.SearchStyle := FSearchStyle;

  Dialog.Caption := FDialogCaption;
  if FDialogWidth <> 0 then
    Dialog.Width := FDialogWidth;
    
  if FDialogHeight <> 0 then
    Dialog.Height := FDialogHeight;

  Dialog.SearchDataSet := SearchDataSet;
  Dialog.CountDataSet := CountDataSet;

  Dialog.SearchQuery := FSearchQuery.Text;
  Dialog.CountQuery := FCountQuery.Text;

  Dialog.MaxCriteria := FMaxCriteria;
  Dialog.CriteriaCount := FCriteriaCount;
  Dialog.Max := FMax;

  Dialog.CaseFormatUpper := FCaseFormatUpper;
  Dialog.CaseFormatLower := FCaseFormatLower;

  Dialog.RegistryPath := FullRegistryPath;
  Dialog.Store := FStore;
  Dialog.StoreVersion := FStoreVersion;

  Dialog.CompareFormatDate := FCompareFormatDate;
  Dialog.CompareFormatTime := FCompareFormatTime;
  Dialog.CompareFormatDateTime := FCompareFormatDateTime;
  Dialog.QuotedDateTime := FQuotedDateTime;

  Dialog.QuoteChar := FQuoteChar;
  Dialog.DecimalChar := FDecimalChar;

  Dialog.IgnoreEmptyValues := FIgnoreEmptyValues;
  Dialog.ClearValueOnFieldChange := FClearValueOnFieldChange;

  Dialog.HelpContext := FHelpContext;
  Dialog.HelpKeyword := FHelpKeyWord;
  Dialog.HelpType := FHelpType;

  Dialog.SearchDialogFieldList := FSearchDialogFieldList;
  Dialog.ShowPresets := FShowPresets;
  Dialog.ShowPresetsCustomization := FShowPresetsCustomization;
  Dialog.ShowHint := FShowHint;
  Dialog.SearchPresetList := FSearchPresetList;

  Dialog.AdditionalWhere := FAdditionalWhere;
  Dialog.StartOpen := FStartOpen;
  Dialog.StartPreset := FStartPreset;

  Dialog.OnSetSearchQuery := DoSetSearchQuery;
  Dialog.OnSetCountQuery := DoSetCountQuery;
end;

{
  Procedure : TIDBEdit.Execute
  Auteur    : Erik Stok
  Doel      : Het daadwerkelijk uitvoeren van de zoekopdracht. Dus het aanmaken
              van het dialog volgens de instellingen van het component en het
              afhandelen van de selectie van de gebruiker in dat dialog.
}
function TIDBEdit.Execute: Boolean;
var
  i : Integer;
  SearchFieldAvailable : Boolean;
begin
  if not ValidConnection then
    raise EEstSearchDialogException.Create('Conex�o Inv�lida');

  // Als er al een dialog operationeel is, activeer dat dan. Stel anders een
  // heel nieuw dialog op.
  if Assigned(FFrmSearchDialog) then
  begin

    // Breng bestaand dialog naar voren
    FFrmSearchDialog.BringToFront;

    // Er is geen resultaat bepaald
    Result := False;

  end
  else
  begin

    // Controleer of er velden zijn waarop gezocht kan worden
    SearchFieldAvailable := False;
    for i := 0 to FSearchDialogFieldList.Count - 1 do
    begin

      if TEstSearchDialogField(FSearchDialogFieldList.Items[i]).Search then
      begin
        SearchFieldAvailable := True;
        Break;
      end;

    end;

    if not SearchFieldAvailable then
      raise EEstSearchDialogException.Create('No search fields are defined for the search dialog');

    // Controleer of er een zoek query is
    if Trim(FSearchQuery.Text) = '' then
      raise EEstSearchDialogException.Create('No search query is defined for the search dialog');

    // Controleer of er een count query is indien nodig
    if (Trim(FSearchQuery.Text) = '') and (FMax > 0) then
      raise EEstSearchDialogException.Create('No count query is defined for the search dialog');

    if not (csDesigning in ComponentState) then
    begin
      // Koppel filterrecord event aan de searchquery
      SearchDataSet.OnFilterRecord := FOnFilterRecord;
      SearchDataSet.Filter := '';
      SearchDataSet.Filtered := True;
    end;

    // Koppel events aan datasets
    SearchDataSet.BeforeOpen := DoBeforeSearchQueryOpen;
    SearchDataSet.AfterOpen := DoAfterSearchQueryOpen;

    CountDataSet.BeforeOpen := DoBeforeCountQueryOpen;
    CountDataSet.AfterOpen := DoAfterCountQueryOpen;

    // Wis eventueel vorige resultaat
    SetLength(FResultRecord, 0);
    FResultQuery := '';

    // Toon scherm
    if (FSearchStyle <> ssMDIChild) or (csDesigning in ComponentState) then
      FFrmSearchDialog := InternalFrmEstSearchDialogClass.Create(Self, False, DoDialogSetup)
    else
      FFrmSearchDialog := InternalFrmEstSearchDialogClass.Create(Self, True, DoDialogSetup);

    // Stel preset customization formclass in
    FFrmSearchDialog.FrmEstSearchDialogPresetCustomizeClass :=
      InternalFrmEstSearchDialogPresetCustomizeClass;

    // Koppel initcontrol event aan het dialog
    FFrmSearchDialog.OnInitControls := DoInitControls;

    // Als het form modaal is, handel het dan als dusdanig af
    if (FSearchStyle = ssModal) or (csDesigning in ComponentState) then
    begin

      try
        // Aleen als er OK gegeven is wordt het resultaat intern opgeslagen
        if FFrmSearchDialog.ShowModal = mrOK then
        begin
          SetLength(FResultRecord, 0);
          FResultRecord:= FFrmSearchDialog.GetResultRecord;
          FResultQuery := FFrmSearchDialog.GetResultQuery;
          DoClose;
          Result := True;
        end
        else
        begin
          DoClose;
          Result := False;
        end;

      finally
        FFrmSearchDialog.Free;
        FFrmSearchDialog := nil;
      end;

    end
    else
    begin
      // Koppel extra events
      FFrmSearchDialog.OnOK := DoOK;
      FFrmSearchDialog.OnCancel := DoCancel;

      // Toon dialog
      FFrmSearchDialog.Show;

      // Geef altijd False terug voor non-modal executes, er is immers (nog) niets
      // geselecteerd
      Result := False;
    end;

  end;

end;

{
  Procedure : TIDBEdit.AssignTo
  Auteur    : Erik Stok
  Doel      : Assign dit TIDBEdit aan een ander
}

{
  Procedure : TIDBEdit.SetCriteriaCount
  Auteur    : Erik Stok
  Doel      : Setter van CriteriaCount property voor extra validatie
}
procedure TIDBEdit.SetCriteriaCount(const Value: Integer);
begin
  // Waarde mag niet lager dan 1 zijn
  if Value < 1 then
    FCriteriaCount := 1
  else
    FCriteriaCount := Value;

  // Maximum aantal criteria wordt automatisch aangepast indien dit niet voldoet
  if FMaxCriteria < FCriteriaCount then
    MaxCriteria := FCriteriaCount;
end;

{
  Procedure : TIDBEdit.SetMaxCriteria
  Auteur    : Erik Stok
  Doel      : Setter van MaxCriteria property voor extra validatie
}
procedure TIDBEdit.SetMaxCriteria(const Value: Integer);
begin
  // Waarde mag niet lager dan 1 zijn
  if Value < 1 then
    FMaxCriteria := 1
  else
    FMaxCriteria := Value;


  // Aantal criteria wordt automatisch aangepast indien dit niet voldoet
  if FCriteriaCount > FMaxCriteria then
    CriteriaCount := FMaxCriteria;
end;

{
  Procedure : TIDBEdit.ResultFieldAsString
  Auteur    : Erik Stok
  Doel      : Resultaatveldbenadering
}
function TIDBEdit.ResultFieldAsString(FieldName: String): String;
var
  i : Integer;
  FieldFound : Boolean;
begin
  // Veronderstel dat het veld niet gevonden wordt
  FieldFound := False;

  // Loop door het resultaatrecord
  for i := 0 to Length(FResultRecord) - 1 do
  begin
    // Als de naam matcht, geef de terug dat het veld gevonden is en stop met zoeken
    if SameText(FResultRecord[i].FieldName, FieldName) then
    begin
      Result := FResultRecord[i].FieldValue;
      FieldFound := True;
      Break;
    end;
  end;

  if not FieldFound then
    raise EEstSearchDialogException.CreateFmt('Field %s is not a searchdialog result field', [FieldName]);
end;

function TIDBEdit.ResultFieldAsString(FieldName: String; Default: String): String;
begin
  if not ResultFieldIsNull(FieldName) then
    Result := ResultFieldAsString(FieldName)
  else
    Result := Default;
end;

{
  Procedure : TIDBEdit.ResultFieldAsInteger
  Auteur    : Erik Stok
  Doel      : Resultaatveldbenadering
}
function TIDBEdit.ResultFieldAsInteger(FieldName: String): Integer;
begin
  Result := StrToInt(ResultFieldAsString(FieldName));
end;

function TIDBEdit.ResultFieldAsInteger(FieldName: String; Default: Integer): Integer;
begin
  if not ResultFieldIsNull(FieldName) then
    Result := ResultFieldAsInteger(FieldName)
  else
    Result := Default;
end;

{
  Procedure : TIDBEdit.ResultFieldAsFloat
  Auteur    : Erik Stok
  Doel      : Resultaatveldbenadering
}
function TIDBEdit.ResultFieldAsFloat(FieldName: String): Double;
begin
  Result := StrToFloat(ResultFieldAsString(FieldName));
end;

function TIDBEdit.ResultFieldAsFloat(FieldName: String; Default: Double): Double;
begin
  if not ResultFieldIsNull(FieldName) then
    Result := ResultFieldAsFloat(FieldName)
  else
    Result := Default;
end;

{
  Procedure : TIDBEdit.ResultFieldAsDateTime
  Auteur    : Erik Stok
  Doel      : Resultaatveldbenadering
}
function TIDBEdit.ResultFieldAsDateTime(FieldName: String): TDateTime;
begin
  Result := StrToDateTime(ResultFieldAsString(FieldName));
end;

function TIDBEdit.ResultFieldAsDateTime(FieldName: String; Default: TDateTime): TDateTime;
begin
  if not ResultFieldIsNull(FieldName) then
    Result := ResultFieldAsDateTime(FieldName)
  else
    Result := Default;
end;

{
  Procedure : TIDBEdit.ResultFieldExists
  Auteur    : Erik Stok
  Doel      : Controleer of een bepaald veld in het zoekresultaat aanwezig is
}
function TIDBEdit.ResultFieldExists(FieldName: String): Boolean;
var
  i : Integer;
begin
  // Standaard resultaat
  Result := False;

  // Loop door het resultaatrecord
  for i := 0 to Length(FResultRecord) - 1 do
  begin
    // Als de naam matcht, geef de terug dat het veld gevonden is en stop met zoeken
    if SameText(FResultRecord[i].FieldName, FieldName) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

{
  Procedure : TIDBEdit.ResultFieldIsNull
  Auteur    : Erik Stok
  Doel      : Controleer of een bepaald veld in het zoekresultaat null is. Als
              het veld niet bestaat wordt null aangenomen.
}
function TIDBEdit.ResultFieldIsNull(FieldName: String): Boolean;
var
  i : Integer;
begin
  // Standaard resultaat
  Result := True;

  // Loop door het resultaatrecord
  for i := 0 to Length(FResultRecord) - 1 do
  begin
    // Als de naam matcht, geef de terug dat het veld gevonden is en stop met zoeken
    if SameText(FResultRecord[i].FieldName, FieldName) then
    begin
      Result := FResultRecord[i].IsNull;
      Break;
    end;
  end;
end;

{
  Procedure : TIDBEdit.FullRegistryPath
  Auteur    : Erik Stok
  Doel      : Bepaal het volldige registry pad waar instellingen worden
              opgeslagen. Dit pad worden bepaald door de instelling van de
              RegistryPath property.
}
function TIDBEdit.FullRegistryPath: string;
var
  OwnerName : String;
begin
  // Bepaal de naam van de owner. Als die er niet is, sla dan op onder application
  if Assigned(Owner) then
    OwnerName := Owner.ClassName
  else
    OwnerName := Application.ClassName;

  // Als er geen specifiek registry path gegevens is, neem dan het standaard pad
  if FRegistryPath <> '' then
    Result := Format('%s\%s\%s', [FRegistryPath, OwnerName, Name])
  else
    Result := Format('%s\%s\LastSearch\%s\%s',
      [REG_LOCATION, ChangeFileExt(ExtractFileName(Application.ExeName), ''),
        OwnerName, Name]);
end;

{
  Procedure : TIDBEdit.DoBeforeSearchQueryOpen
  Auteur    : Erik Stok
  Doel      : Roep OnBeforeExecuteSearchQuery event handler aan
}
procedure TIDBEdit.DoBeforeSearchQueryOpen(DataSet: TDataSet);
begin
  if Assigned(FOnBeforeExecuteSearchQuery) and (not (csDesigning in ComponentState)) then
    FOnBeforeExecuteSearchQuery(Self, FSearchSql);
end;

{
  Procedure : TIDBEdit.DoAfterSearchQueryOpen
  Auteur    : Erik Stok
  Doel      : Roep OnAfterExecuteSearchQuery event handler aan
}
procedure TIDBEdit.DoAfterSearchQueryOpen(DataSet: TDataSet);
begin
  if Assigned(FOnAfterExecuteSearchQuery) and (not (csDesigning in ComponentState)) then
    FOnAfterExecuteSearchQuery(Self, FSearchSql, SearchDataSet);
end;

{
  Procedure : TIDBEdit.DoBeforeCountQueryOpen
  Auteur    : Erik Stok
  Doel      : Roep OnBeforeExecuteCountQuery event handler aan
}
procedure TIDBEdit.DoBeforeCountQueryOpen(DataSet: TDataSet);
begin
  if Assigned(FOnBeforeExecuteCountQuery) and (not (csDesigning in ComponentState)) then
    FOnBeforeExecuteCountQuery(Self, FCountSql);
end;

{
  Procedure : TIDBEdit.DoAfterCountQueryOpen
  Auteur    : Erik Stok
  Doel      : Roep OnAfterExecuteCountQuery event handler aan
}
procedure TIDBEdit.DoAfterCountQueryOpen(DataSet: TDataSet);
begin
  if Assigned(FOnAfterExecuteCountQuery) and (not (csDesigning in ComponentState)) then
    FOnAfterExecuteCountQuery(Self, FCountSql, CountDataSet);
end;

{
  Procedure : TIDBEdit.DoSetCountQuery
  Auteur    : Erik Stok
  Doel      : Stel de zoek query in. Afgeleiden moeten een override maken van
              deze method om de database specifieke componenten in te stellen.
}
procedure TIDBEdit.DoSetCountQuery(Sender: TObject; SQL: String);
begin
  FCountSql := SQL;
end;

{
  Procedure : TIDBEdit.DoSetCountQuery
  Auteur    : Erik Stok
  Doel      : Stel de zoek query in. Afgeleiden moeten een override maken van
              deze method om de database specifieke componenten in te stellen.
}
procedure TIDBEdit.DoSetSearchQuery(Sender: TObject; SQL: String);
begin
  FSearchSql := SQL;
end;

{
  Procedure : TIDBEdit.DoOK
  Auteur    : Erik Stok
  Doel      : Handel OK af van Normal of MDIChild search dialog
}
procedure TIDBEdit.DoOK(Sender: TObject);
begin
  if not (csDesigning in ComponentState) then
  begin

    // Stel huidig resultaat in
    SetLength(FResultRecord, 0);
    FResultRecord := (Sender as TFrmEstSearchDialog).GetResultRecord;
    FResultQuery  := (Sender as TFrmEstSearchDialog).GetResultQuery;

    // Execute eventueel event
    DoSelect;

  end;
end;

procedure TIDBEdit.DoSelect;
begin
  if not (csDesigning in ComponentState) then
  begin

    // Roep event handler aan indien gekoppeld
    if Assigned(FOnSelect) then
      FOnSelect(Self);

  end;
end;

procedure TIDBEdit.DoCancel(Sender: TObject);
begin
  if not (csDesigning in ComponentState) then
    DoClose;
end;

{
  Procedure : TIDBEdit.DoClose
  Auteur    : Erik Stok
  Doel      : Handel OnClose event af
}
procedure TIDBEdit.DoClose;
begin
  if not (csDesigning in ComponentState) then
  begin

    if Assigned(FOnClose) then
      FOnClose(Self);

    // Wis form referentie voor niet modale dialogs
    if FSearchStyle <> ssModal then
      FFrmSearchDialog := nil;

  end;

  // Sluit datasets
  SearchDataSet.Close;
  CountDataSet.Close;
end;


{
  Procedure : TIDBEdit.Close
  Auteur    : Erik Stok
  Doel      : Sluit eventuele niet modale dialogs
}
procedure TIDBEdit.Close;
begin

  if Assigned(FFrmSearchDialog) then
  begin
    FFrmSearchDialog.Close;
  end;
  
end;

{
  Procedure : TIDBEdit.DoInitControls
  Auteur    : Erik Stok
  Doel      : Initlialiseer controls indien er een event handler
              gekoppeld is
}
procedure TIDBEdit.DoInitControls(Sender: TObject;
                                          Field: TEstSearchDialogField;
                                          FieldControl: TComboBox;
                                          Comparison: TSearchComparison;
                                          ComparisonControl: TComboBox;
                                          ValueControl: TEdit;
                                          UsingOperator: Boolean;
                                          OperatorControl: TComboBox);
begin
  // Als de init controls event handler is gekoppeld, roep die dan aan
  // met de betreffende controls
  if Assigned(FOnInitControls) then
    FOnInitControls(Self, Field, FieldControl, Comparison, ComparisonControl,
      ValueControl, UsingOperator, OperatorControl);
end;

procedure TIDBEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  // Als het defaults component verwijderd wordt, wis dan de default property
  if (AComponent = FDefaults) and (Operation = opRemove) then
    Defaults := nil;
end;


// -------------------------------------------------------------------
// ---                ZEOS                                         ---
// -------------------------------------------------------------------
{
  Procedure : TIDBEdit.ZSetConnection
  Auteur    : Erik Stok
  Doel      : Stel de connection van het search dialog component in
}
procedure TIDBEdit.ZSetConnection(const Value: TFDConnection);
begin
  if Value <> FDBAccessDialog then
  begin
    // Stel connection in op gegeven waarde
    FDBAccessDialog := Value;

    // Stel van de search en count queries ook de connections in
    FZSearchQuery.Connection  := FDBAccessDialog;
    FZcountQuery.Connection   := FDBAccessDialog;

  end;
end;

function TIDBEdit.ZCountDataSet: TDataSet;
begin
  Result := FZcountQuery;
end;


function TIDBEdit.ZSearchDataSet: TDataSet;
begin
  Result := FZSearchQuery;
end;

procedure TIDBEdit.ZDoSetSearchQuery(Sender: TObject; SQL: String);
begin
  inherited;

  // Stel search query in
  FZSearchQuery.Close;
  FZSearchQuery.SQL.Clear;
  FZSearchQuery.SQL.Add ( SQL );
end;

procedure TIDBEdit.ZDoSetCountQuery(Sender: TObject; SQL: String);
begin
  inherited;

  // Stel count query in
  FZcountQuery.Close;
  FZcountQuery.SQL.Clear;
  FZcountQuery.SQL.Add( SQL );
end;

{
  Procedure : TIDBEdit.ZValidConnection
  Auteur    : Erik Stok
  Doel      : Controleer of de opgegeven connection geldig is
}
function TIDBEdit.ZValidConnection: Boolean;
begin
  Result := Assigned(ConnectionDialog);
end;

procedure TIDBEdit.ZNotification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  // Als de connection verwijderd wordt, zet dan de property op nil
  if (AComponent = FDBAccessDialog) and (Operation = opRemove) then
    ConnectionDialog := nil;
end;



initialization
  // Stel form classes op de standaard forms in
  InternalFrmEstSearchDialogClass := TFrmEstSearchDialog;
  InternalFrmEstSearchDialogPresetCustomizeClass := TFrmEstSearchDialogPresetCustomize;


end.
