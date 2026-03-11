{ ============================================================
  TelegramConfig.inc - Credenciais para os samples Telegram
  Compartilhado por: console, desktop e android.
  ============================================================ }

const
  TELEGRAM_BOT_TOKEN = 'SEU_BOT_TOKEN_AQUI';
  TELEGRAM_CHAT_ID   = 'SEU_CHAT_ID_AQUI';

{$IF TELEGRAM_BOT_TOKEN = 'SEU_BOT_TOKEN_AQUI'}
  {$MESSAGE WARN 'Preencha TELEGRAM_BOT_TOKEN em TelegramConfig.inc antes de compilar'}
{$ENDIF}
{$IF TELEGRAM_CHAT_ID = 'SEU_CHAT_ID_AQUI'}
  {$MESSAGE WARN 'Preencha TELEGRAM_CHAT_ID em TelegramConfig.inc antes de compilar'}
{$ENDIF}
