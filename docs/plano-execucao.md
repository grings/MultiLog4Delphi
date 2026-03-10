# Plano de Execução — Melhorias MultiLog4D

**Referência:** LT-2026-001
**Branch de trabalho:** `QualityImprovements`
**Criada a partir de:** `develop` (sincronizada com `master@bb203bb`)
**Data:** 10/03/2026

---

## Visão Geral

Este documento organiza a execução das melhorias identificadas no laudo técnico LT-2026-001,
agrupadas por prioridade e dependência técnica.

---

## Fase 1 — Imediatas (antes do próximo release)

> Estimativa: 1–2 dias-homem
> Sem dependências entre si — podem ser executadas em paralelo

### 1.1 Corrigir tipo `TLogOutput` → `TLogOutputSet`

- **Arquivo:** `src/MultiLog4D.Windows.pas`
- **Linha:** 167
- **Problema:** O parâmetro usa `TLogOutput` (tipo simples) onde deveria ser `TLogOutputSet` (conjunto de flags), impedindo combinações de destinos de log.
- **Ação:** Alterar declaração do parâmetro/variável para `TLogOutputSet`.
- **Critério de aceite:** Compilar sem warnings; testar combinação `[loFile, loConsole]`.

---

### 1.2 Remover bloco dead code

- **Arquivo:** `src/MultiLog4D.Windows.pas`
- **Linhas:** 118–146
- **Problema:** Bloco comentado com `(*..*)` contendo código desatualizado.
- **Ação:** Excluir o bloco inteiro.
- **Critério de aceite:** Arquivo compila sem erros; histórico git preserva versão anterior.

---

### 1.3 Corrigir typo `'Faltal Error'` → `'Fatal Error'`

- **Arquivos:**
  - `Samples/VCL/desktop/Unit1.pas`
  - `Samples/FMX/Android/UMain.pas`
  - `Samples/FMX/iOS/UMain.pas`
- **Ação:** Busca global por `Faltal` e substituição por `Fatal`.
- **Critério de aceite:** Zero ocorrências de `Faltal` no repositório.

---

### 1.4 Remover import não utilizado `FMX.Dialogs`

- **Arquivo:** `src/MultiLog4D.macOS.pas`
- **Linha:** 13
- **Problema:** Unit FMX incluída desnecessariamente em contexto Desktop macOS.
- **Ação:** Remover `FMX.Dialogs` da cláusula `uses`.
- **Critério de aceite:** Compilar macOS sem warnings de unit não utilizada.

---

### 1.5 Remover criação manual do singleton no `initialization`

- **Arquivo:** `src/MultiLog4D.Util.pas`
- **Linha:** 96
- **Problema:** `TMultiLog4DUtil.Create` chamada manualmente no bloco `initialization`,
  criando instância duplicada do singleton antes da primeira chamada ao `GetInstance`.
- **Ação:** Remover a linha do `initialization`; verificar que `GetInstance` faz lazy initialization.
- **Critério de aceite:** Singleton criado apenas na primeira chamada a `GetInstance`.

---

## Fase 2 — Curto Prazo (≤ 30 dias)

> Estimativa: 3–5 dias-homem
> Executar após Fase 1

### 2.1 Thread-safety nos singletons

- **Arquivos afetados:** todas as units de plataforma (`Windows.pas`, `macOS.pas`, `Linux.pas`, `Android.pas`, `iOS.pas`, `Util.pas`)
- **Problema:** Padrão `if not Assigned(FInstance) then Create` não é thread-safe.
- **Ação:** Envolver a criação com `TMonitor.Enter/Exit` ou `TCriticalSection`.

```delphi
class function TMultiLog4DWindows.GetInstance: IMultiLog4D;
begin
  if not Assigned(FInstance) then
  begin
    TMonitor.Enter(TMultiLog4DWindows);
    try
      if not Assigned(FInstance) then
        FInstance := TMultiLog4DWindows.Create;
    finally
      TMonitor.Exit(TMultiLog4DWindows);
    end;
  end;
  Result := FInstance;
end;
```

- **Critério de aceite:** Teste de stress com 10 threads simultâneas sem crash ou instância duplicada.

---

### 2.2 Finalization com `FreeAndNil` em WriteToFile.pas

- **Arquivo:** `src/MultiLog4D.Common.WriteToFile.pas`
- **Problema:** Bloco `finalization` não libera o writer de arquivo, causando possível leak em shutdown.
- **Ação:**

```delphi
finalization
  FreeAndNil(FFileWriter);
```

- **Critério de aceite:** Sem warning de memória no FastMM após shutdown da aplicação.

---

### 2.3 Unificar `GetCurrentUserName` Linux/macOS

- **Arquivos:** `src/MultiLog4D.Linux.pas`, `src/MultiLog4D.macOS.pas`
- **Problema:** Código idêntico duplicado nas duas units.
- **Ação:** Mover implementação para `src/MultiLog4D.Common.pas` e referenciar nas duas units.
- **Critério de aceite:** Zero duplicação; compilar Linux e macOS sem erros.

---

### 2.4 Definir alias `TEventID`

- **Arquivo:** `src/MultiLog4D.Types.pas`
- **Problema:** Tipo de evento sem alias semântico, dificultando leitura da API.
- **Ação:** Adicionar `TEventID = type Integer;` (ou tipo base adequado).
- **Critério de aceite:** API pública usa `TEventID` consistentemente.

---

## Fase 3 — Médio Prazo (≤ 90 dias)

> Estimativa: 8–14 dias-homem

### 3.1 Template Method na classe base

- **Arquivo:** `src/MultiLog4D.Base.pas`
- **Objetivo:** Eliminar ~20 métodos duplicados entre as 5 classes de plataforma.
- **Abordagem:** Definir métodos abstratos/virtuais na base e implementar apenas as variações específicas de plataforma.
- **Critério de aceite:** Cada plataforma implementa apenas o que é diferente; testes passam em todas.

---

### 3.2 Suite de testes DUnitX

- **Estrutura sugerida:**
  ```
  tests/
  ├── MultiLog4D.Tests.Base.pas
  ├── MultiLog4D.Tests.Windows.pas
  ├── MultiLog4D.Tests.Singleton.pas
  └── MultiLog4D.Tests.WriteToFile.pas
  ```
- **Cobertura mínima:** 60% dos métodos públicos
- **Critério de aceite:** Suite executa sem falhas; relatório gerado.

---

### 3.3 Substituir `TextFile` por `TStreamWriter`

- **Arquivo:** `src/MultiLog4D.Common.WriteToFile.pas`
- **Problema:** `TextFile` é legado Delphi sem suporte a encoding moderno ou acesso concorrente seguro.
- **Ação:** Migrar para `TStreamWriter` com `TFileStream` e lock por `TCriticalSection`.
- **Critério de aceite:** Logs gravados com UTF-8 BOM; sem corrupção em acesso concorrente.

---

### 3.4 Sincronização na escrita de log

- **Arquivo:** `src/MultiLog4D.Common.WriteToFile.pas`
- **Ação:** Adicionar `TCriticalSection` envolvendo o bloco de escrita no arquivo.
- **Critério de aceite:** Teste com 100 threads escrevendo simultaneamente sem corrupção de arquivo.

---

## Fase 4 — Estratégico (90+ dias)

> Estimativa: 5–10 dias-homem

### 4.1 Segregar interface por plataforma (ISP)

Criar interfaces específicas:
- `IMultiLog4DDesktop` — Windows, macOS, Linux
- `IMultiLog4DMobile` — Android, iOS
- `IMultiLog4DBase` — métodos comuns a todas

---

### 4.2 Padrão Strategy com `ILogSink`

Permitir backends plugáveis:
```delphi
ILogSink = interface
  procedure Write(const ALevel: TLogLevel; const AMessage: string);
end;
```
Implementações: `TFileSink`, `TConsoleSink`, `TNetworkSink`, `TDatabaseSink`

---

### 4.3 XMLDoc na API pública

Adicionar documentação XML em todos os métodos públicos da interface e classe base.

---

### 4.4 CI/CD no GitHub Actions

```yaml
# .github/workflows/build.yml
name: Build & Test
on: [push, pull_request]
jobs:
  test:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: # comando de build Delphi
      - name: Test
        run: # executar DUnitX runner
```

---

## Rastreamento de Progresso

| # | Tarefa | Status | Responsável | PR |
|---|---|---|---|---|
| 1.1 | Corrigir TLogOutputSet | Pendente | — | — |
| 1.2 | Remover dead code | Pendente | — | — |
| 1.3 | Corrigir typo Fatal Error | Pendente | — | — |
| 1.4 | Remover FMX.Dialogs | Pendente | — | — |
| 1.5 | Remover init redundante | Pendente | — | — |
| 2.1 | Thread-safety singletons | Pendente | — | — |
| 2.2 | Finalization WriteToFile | Pendente | — | — |
| 2.3 | Unificar GetCurrentUserName | Pendente | — | — |
| 2.4 | Alias TEventID | Pendente | — | — |
| 3.1 | Template Method | Pendente | — | — |
| 3.2 | Suite DUnitX | Pendente | — | — |
| 3.3 | TStreamWriter | Pendente | — | — |
| 3.4 | Sincronização escrita | Pendente | — | — |
| 4.1 | Segregar interfaces | Pendente | — | — |
| 4.2 | Strategy ILogSink | Pendente | — | — |
| 4.3 | XMLDoc | Pendente | — | — |
| 4.4 | CI/CD GitHub Actions | Pendente | — | — |

---

*Documento gerado a partir do Laudo Técnico LT-2026-001*
*Branch: QualityImprovements — MultiLog4D*
