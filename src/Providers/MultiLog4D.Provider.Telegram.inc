{ ============================================================
  MultiLog4D.Provider.Telegram.inc

  Configuracao padrao do provider Telegram.
  Preencha com suas credenciais antes de compilar.

  Obtendo as credenciais:
    TOKEN  : Converse com @BotFather no Telegram -> /newbot
    CHAT_ID: Use @userinfobot no grupo/canal, ou acesse
             https://api.telegram.org/bot[TOKEN]/getUpdates
  ============================================================ }

const
  ML4D_TELEGRAM_DEFAULT_TOKEN      = '8793713206:AAFNz985vaIYmX91gnH_8LwSXqh3uKHWcc8';
  ML4D_TELEGRAM_DEFAULT_CHAT_ID    = '-5287646884';
  ML4D_TELEGRAM_DEFAULT_PARSE_MODE = tpmMarkdown;
  ML4D_TELEGRAM_DEFAULT_LOG_FILTER = [ltWarning, ltError, ltFatalError];

{$IF ML4D_TELEGRAM_DEFAULT_TOKEN = ''}
  {$MESSAGE HINT 'Configure ML4D_TELEGRAM_DEFAULT_TOKEN em MultiLog4D.Provider.Telegram.inc'}
{$ENDIF}
