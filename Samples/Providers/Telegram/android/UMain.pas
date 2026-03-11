unit UMain;

interface

uses
  MultiLog4D.Types,
  MultiLog4D.Util,
  MultiLog4D.Provider.Telegram,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Edit,
  FMX.ListBox,
  FMX.Layouts,
  FMX.Memo,
  FMX.ScrollBox, FMX.Memo.Types;

type
  TFormTelegramAndroid = class(TForm)
    Layout1: TLayout;
    lblToken: TLabel;
    edtToken: TEdit;
    lblChatID: TLabel;
    edtChatID: TEdit;
    lblParseMode: TLabel;
    cmbParseMode: TComboBox;
    chkInformation: TCheckBox;
    chkWarning: TCheckBox;
    chkError: TCheckBox;
    chkFatalError: TCheckBox;
    btnApply: TButton;
    Layout2: TLayout;
    btnInformation: TButton;
    btnWarning: TButton;
    btnError: TButton;
    btnFatalError: TButton;
    memoFeedback: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnInformationClick(Sender: TObject);
    procedure btnWarningClick(Sender: TObject);
    procedure btnErrorClick(Sender: TObject);
    procedure btnFatalErrorClick(Sender: TObject);
  private
    FProvider: TMultiLog4DProviderTelegram;
    procedure ApplyProvider;
    function BuildLogTypeFilter: TLogTypeFilter;
  public
  end;

var
  FormTelegramAndroid: TFormTelegramAndroid;

implementation

{$R *.fmx}

procedure TFormTelegramAndroid.FormCreate(Sender: TObject);
begin
  FProvider := nil;
  cmbParseMode.Items.Add('PlainText');
  cmbParseMode.Items.Add('Markdown');
  cmbParseMode.Items.Add('HTML');
  cmbParseMode.ItemIndex := 1;
  chkWarning.IsChecked   := True;
  chkError.IsChecked     := True;
  chkFatalError.IsChecked := True;
end;

function TFormTelegramAndroid.BuildLogTypeFilter: TLogTypeFilter;
begin
  Result := [];
  if chkInformation.IsChecked then Include(Result, ltInformation);
  if chkWarning.IsChecked     then Include(Result, ltWarning);
  if chkError.IsChecked       then Include(Result, ltError);
  if chkFatalError.IsChecked  then Include(Result, ltFatalError);
end;

procedure TFormTelegramAndroid.ApplyProvider;
const
  ParseModes: array[0..2] of TMultiLog4DTelegramParseMode = (
    tpmPlainText, tpmMarkdown, tpmHTML);
begin
  TMultiLog4DUtil.Logger.ClearProviders;
  FProvider := TMultiLog4DProviderTelegram.Create(edtToken.Text, edtChatID.Text);
  FProvider.ParseMode     := ParseModes[cmbParseMode.ItemIndex];
  FProvider.LogTypeFilter := BuildLogTypeFilter;
  TMultiLog4DUtil.Logger
    .Tag('TelegramAndroid')
    .AddProvider(FProvider);
  memoFeedback.Lines.Add('Provider aplicado com sucesso.');
end;

procedure TFormTelegramAndroid.btnApplyClick(Sender: TObject);
begin
  try
    ApplyProvider;
  except
    on E: Exception do
      memoFeedback.Lines.Add(Format('Erro ao aplicar provider: %s', [E.Message]));
  end;
end;

procedure TFormTelegramAndroid.btnInformationClick(Sender: TObject);
begin
  TMultiLog4DUtil.Logger.LogWriteInformation('Mensagem de informacao');
  memoFeedback.Lines.Add('[INF] Enviado.');
end;

procedure TFormTelegramAndroid.btnWarningClick(Sender: TObject);
begin
  TMultiLog4DUtil.Logger.LogWriteWarning('Uso de memoria acima de 80%');
  memoFeedback.Lines.Add('[WAR] Enviado.');
end;

procedure TFormTelegramAndroid.btnErrorClick(Sender: TObject);
begin
  TMultiLog4DUtil.Logger.LogWriteError('Falha ao conectar ao banco');
  memoFeedback.Lines.Add('[ERR] Enviado.');
end;

procedure TFormTelegramAndroid.btnFatalErrorClick(Sender: TObject);
begin
  TMultiLog4DUtil.Logger.LogWriteFatalError('Processo encerrado inesperadamente');
  memoFeedback.Lines.Add('[FAT] Enviado.');
end;

end.
