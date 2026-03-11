# MultiLog4D — Provider Telegram

## 1. Visão geral

O `TMultiLog4DProviderTelegram` envia mensagens de log diretamente para um chat ou grupo do Telegram via Bot API. Herda de `TMultiLog4DProviderREST` e suporta filtragem por tipo de log e três modos de formatação de texto.

---

## 2. Pré-requisitos

### Criando o Bot (Token)

1. Abra o Telegram e converse com **@BotFather**.
2. Envie `/newbot` e siga as instruções.
3. Copie o **token** gerado (formato: `123456789:AABBccdd...`).

### Obtendo o Chat ID

- **Grupo/Canal**: adicione **@userinfobot** ao grupo → ele exibe o ID.
- **Chat direto**: envie uma mensagem ao bot e acesse:
  ```
  https://api.telegram.org/bot{TOKEN}/getUpdates
  ```
  Procure `"chat":{"id":...}` na resposta JSON.

---

## 3. Configuração via `.inc`

### Biblioteca (`src/Providers/MultiLog4D.Provider.Telegram.inc`)

Edite os valores padrão usados quando nenhum parâmetro é passado ao construtor:

```pascal
const
  ML4D_TELEGRAM_DEFAULT_TOKEN      = 'seu_token_aqui';
  ML4D_TELEGRAM_DEFAULT_CHAT_ID    = 'seu_chat_id_aqui';
  ML4D_TELEGRAM_DEFAULT_PARSE_MODE = tpmMarkdown;
  ML4D_TELEGRAM_DEFAULT_LOG_FILTER = [ltWarning, ltError, ltFatalError];
```

### Samples (`Samples/Providers/Telegram/TelegramConfig.inc`)

Compartilhado pelos três samples. Preencha antes de compilar qualquer sample:

```pascal
const
  TELEGRAM_BOT_TOKEN = 'seu_token_aqui';
  TELEGRAM_CHAT_ID   = 'seu_chat_id_aqui';
```

---

## 4. Uso básico

```pascal
uses
  MultiLog4D.Util,
  MultiLog4D.Provider.Telegram;

var
  LProvider: TMultiLog4DProviderTelegram;
begin
  LProvider := TMultiLog4DProviderTelegram.Create('TOKEN', 'CHAT_ID');

  TMultiLog4DUtil.Logger
    .Tag('MeuApp')
    .AddProvider(LProvider);

  TMultiLog4DUtil.Logger.LogWriteError('Falha ao conectar ao banco');
end;
```

---

## 5. ParseMode — exemplos dos 3 formatos

| ParseMode | Saída no Telegram |
|---|---|
| `tpmMarkdown` | **[ERR]** MeuApp / mensagem / _2026-03-10 14:30:00_ |
| `tpmHTML` | **[ERR]** MeuApp / mensagem / *2026-03-10 14:30:00* |
| `tpmPlainText` | [ERR] MeuApp / mensagem / 2026-03-10 14:30:00 |

```pascal
LProvider.ParseMode := tpmHTML;
```

> **Atenção**: o Telegram é sensível à formatação Markdown. Caracteres especiais como `_`, `*`, `` ` `` em mensagens podem causar erros de parse. Use `tpmPlainText` se as mensagens contiverem texto arbitrário.

---

## 6. LogTypeFilter — filtro por conjunto de tipos

O `LogTypeFilter` é do tipo `TLogTypeFilter = set of TLogType`. Apenas os tipos presentes no conjunto serão enviados ao Telegram.

```pascal
// Apenas Warning, Error e FatalError:
LProvider.LogTypeFilter := [ltWarning, ltError, ltFatalError];

// Apenas FatalError:
LProvider.LogTypeFilter := [ltFatalError];

// Todos os tipos:
LProvider.LogTypeFilter := [ltInformation, ltWarning, ltError, ltFatalError];
```

---

## 7. Headers customizados via `AddHeader`

Herdado de `TMultiLog4DProviderREST`. Por padrão, o provider já adiciona `Content-Type: application/json`. Use `AddHeader` para acrescentar outros headers se necessário:

```pascal
LProvider.AddHeader('X-Custom-Header', 'valor');
```

---

## 8. Exemplo completo com fluent API

```pascal
uses
  MultiLog4D.Util,
  MultiLog4D.Types,
  MultiLog4D.Provider.Telegram;

var
  LProvider: TMultiLog4DProviderTelegram;
begin
  LProvider := TMultiLog4DProviderTelegram.Create('TOKEN', 'CHAT_ID');
  LProvider.ParseMode     := tpmMarkdown;
  LProvider.LogTypeFilter := [ltWarning, ltError, ltFatalError];

  TMultiLog4DUtil.Logger
    .Tag('Producao')
    .AddProvider(LProvider)
    .LogWriteInformation('Nao enviado — filtrado')
    .LogWriteWarning('Disco acima de 90%')
    .LogWriteError('Timeout na conexao')
    .LogWriteFatalError('Servico encerrado');
end;
```

---

## 9. Rate limit do Telegram

A Bot API do Telegram permite **no máximo 30 mensagens por segundo** por bot (e 1 mensagem/segundo para o mesmo chat). Em aplicações de alto volume, considere:

- Usar `LogTypeFilter` para limitar o volume (enviar apenas erros críticos).
- Implementar um buffer/queue assíncrono em um provider customizado.
- Criar bots separados por ambiente (produção, staging).

Referência: [Telegram Bot API — sendMessage](https://core.telegram.org/bots/api#sendmessage)
