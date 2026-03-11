unit UMain;

interface

uses
  MultiLog4D.Types,
  MultiLog4D.Util,
  MultiLog4D.Provider.Telegram,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TFormTelegramDesktop = class(TForm)
    grpCredentials: TGroupBox;
    lblToken: TLabel;
    edtToken: TEdit;
    lblChatID: TLabel;
    edtChatID: TEdit;
    grpParseMode: TGroupBox;
    cmbParseMode: TComboBox;
    grpFilter: TGroupBox;
    chkInformation: TCheckBox;
    chkWarning: TCheckBox;
    chkError: TCheckBox;
    chkFatalError: TCheckBox;
    btnApply: TButton;
    grpLog: TGroupBox;
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
  FormTelegramDesktop: TFormTelegramDesktop;

implementation

{$R *.dfm}

procedure TFormTelegramDesktop.FormCreate(Sender: TObject);
begin
  FProvider := nil;
  cmbParseMode.Items.Add('PlainText');
  cmbParseMode.Items.Add('Markdown');
  cmbParseMode.Items.Add('HTML');
  cmbParseMode.ItemIndex := 1;
  chkWarning.Checked   := True;
  chkError.Checked     := True;
  chkFatalError.Checked := True;
end;

function TFormTelegramDesktop.BuildLogTypeFilter: TLogTypeFilter;
begin
  Result := [];
  if chkInformation.Checked then Include(Result, ltInformation);
  if chkWarning.Checked     then Include(Result, ltWarning);
  if chkError.Checked       then Include(Result, ltError);
  if chkFatalError.Checked  then Include(Result, ltFatalError);
end;

procedure TFormTelegramDesktop.ApplyProvider;
const
  ParseModes: array[0..2] of TMultiLog4DTelegramParseMode = (
    tpmPlainText, tpmMarkdown, tpmHTML);
begin
  TMultiLog4DUtil.Logger.ClearProviders;
  FProvider := TMultiLog4DProviderTelegram.Create(edtToken.Text, edtChatID.Text);
  FProvider.ParseMode     := ParseModes[cmbParseMode.ItemIndex];
  FProvider.LogTypeFilter := BuildLogTypeFilter;
  TMultiLog4DUtil.Logger
    .Tag('TelegramDesktop')
    .AddProvider(FProvider);
  memoFeedback.Lines.Add('Provider aplicado com sucesso.');
end;

procedure TFormTelegramDesktop.btnApplyClick(Sender: TObject);
begin
  try
    ApplyProvider;
  except
    on E: Exception do
      memoFeedback.Lines.Add(Format('Erro ao aplicar provider: %s', [E.Message]));
  end;
end;

procedure TFormTelegramDesktop.btnInformationClick(Sender: TObject);
begin
  TMultiLog4DUtil.Logger.LogWriteInformation('Mensagem de informacao');
  memoFeedback.Lines.Add('[INF] Enviado.');
end;

procedure TFormTelegramDesktop.btnWarningClick(Sender: TObject);
begin
  TMultiLog4DUtil.Logger.LogWriteWarning('Uso de memoria acima de 80%');
  memoFeedback.Lines.Add('[WAR] Enviado.');
end;

procedure TFormTelegramDesktop.btnErrorClick(Sender: TObject);
begin
  TMultiLog4DUtil.Logger.LogWriteError('Falha ao conectar ao banco');
  memoFeedback.Lines.Add('[ERR] Enviado.');
end;

procedure TFormTelegramDesktop.btnFatalErrorClick(Sender: TObject);
begin
  TMultiLog4DUtil.Logger.LogWriteFatalError('Processo encerrado inesperadamente');
  memoFeedback.Lines.Add('[FAT] Enviado.');
end;

end.
