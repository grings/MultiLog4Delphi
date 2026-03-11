program Console_Telegram;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  MultiLog4D.Util,
  MultiLog4D.Types,
  MultiLog4D.Provider.Telegram;

{$R *.res}

{$I ..\TelegramConfig.inc}

var
  LProvider: TMultiLog4DProviderTelegram;
begin
  try
    LProvider := TMultiLog4DProviderTelegram.Create(TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID);
    LProvider.ParseMode    := tpmMarkdown;
    LProvider.LogTypeFilter := [ltWarning, ltError, ltFatalError];

    TMultiLog4DUtil.Logger
      .Tag('TelegramConsole')
      .AddProvider(LProvider);

    TMultiLog4DUtil.Logger.LogWriteInformation('Nao vai ao Telegram (filtrado)');
    TMultiLog4DUtil.Logger.LogWriteWarning('Uso de memoria acima de 80%');
    TMultiLog4DUtil.Logger.LogWriteError('Falha ao conectar ao banco');
    TMultiLog4DUtil.Logger.LogWriteFatalError('Processo encerrado inesperadamente');

    Writeln('Mensagens enviadas. Verifique o Telegram.');
    Readln;
  except
    on E: Exception do
      Writeln(Format('Erro: %s', [E.Message]));
  end;
end.
