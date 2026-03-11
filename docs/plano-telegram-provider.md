# Plano: Provider Telegram — MultiLog4D

**Branch:** `QualityImprovements`
**Última revisão:** 10/03/2026
**Status:** Implementado

---

## Contexto

Sistema de providers já implementado. Criado o primeiro provider de notificação externa:
**Telegram**, com padrões reutilizáveis para futuros providers (Discord, Slack, etc.).

---

## Decisões de Design

- `TMultiLog4DProviderTelegram` herda de `TMultiLog4DProviderREST`
- `FEndpointURL` e `FHeaders` tornaram-se `protected` em REST (para herança)
- `MinLogType: TLogType` foi **substituído** por `LogTypeFilter: TLogTypeFilter` (set) em toda a cadeia
- `TLogTypeFilter = set of TLogType` definido em `MultiLog4D.Types.pas`
- Zero uso de `+` para concatenação — usa `Format()` em todo o provider
- Dois níveis de `.inc`: biblioteca (`src/Providers/`) e samples (`Samples/Providers/Telegram/`)

---

## Arquivos Modificados

| Arquivo | Mudança |
|---|---|
| `src/MultiLog4D.Types.pas` | Adicionado `TLogTypeFilter = set of TLogType` |
| `src/MultiLog4D.Provider.Interfaces.pas` | Adicionado `GetLogTypeFilter`, `SetLogTypeFilter`, `LogTypeFilter` |
| `src/MultiLog4D.Provider.Base.pas` | Implementado `FLogTypeFilter`; default = todos os tipos |
| `src/MultiLog4D.Provider.REST.pas` | `FEndpointURL` e `FHeaders` movidos para `protected` |
| `src/MultiLog4D.Base.pas` | `NotifyProviders` filtra por `ALogType in LProvider.LogTypeFilter` |

## Arquivos Criados

| Arquivo | Descrição |
|---|---|
| `src/Providers/MultiLog4D.Provider.Telegram.inc` | Defaults da biblioteca |
| `src/Providers/MultiLog4D.Provider.Telegram.pas` | Provider Telegram |
| `Samples/Providers/Telegram/TelegramConfig.inc` | Credenciais dos samples |
| `Samples/Providers/Telegram/console/` | Sample console (Win32) |
| `Samples/Providers/Telegram/desktop/` | Sample VCL desktop (Win32) |
| `Samples/Providers/Telegram/android/` | Sample FMX Android |
| `docs/providers/telegram.md` | Documentação completa |

---

## Verificação

1. Compilar console sample — sem erros; warnings esperados se `.inc` não preenchido
2. Preencher `TelegramConfig.inc` com credenciais reais → executar → 3 mensagens chegam ao Telegram
3. `ltInformation` não chega ao Telegram com `LogTypeFilter := [ltWarning, ltError, ltFatalError]`
4. Testar `LogTypeFilter := [ltWarning, ltError]` — `ltFatalError` não é enviado
5. Testar os 3 `ParseMode` — Telegram renderiza Markdown e HTML corretamente
6. Zero uso de `+` para concatenação em `Provider.Telegram.pas`
7. Compilar todos os samples existentes — sem regressão
