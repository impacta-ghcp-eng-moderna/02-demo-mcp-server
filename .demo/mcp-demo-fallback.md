# Fallback da demo do GitHub MCP Server

Este documento permite continuar a demonstração quando OAuth, rede, API ou
tempo de resposta impedirem a investigação ao vivo. Ele contém somente
evidências públicas e sanitizadas.

Não apresente este material como resultado da execução atual. Informe que se
trata de uma coleta anterior e destaque os commits consultados.

## Escopo da coleta

Consulta realizada em **5 de setembro de 2026**, nas branches padrão dos
repositórios da organização `impacta-ghcp-eng-moderna`.

| Ordem | Repositório | Branch | Commit consultado |
| ---: | --- | --- | --- |
| 1 | `01-lab` | `main` | `a7fcc0e5713c163b561b007b3e5e8c16a4424e0e` |
| 2 | `02-demo-instructions` | `main` | `c28e17ed08685eac6454300777280dc640103220` |
| 3 | `02-demo-agent-skills` | `main` | `9c29f6b3d8fbc8dda91093a95bed04eb0dc6da1c` |
| 4 | `02-demo-prompt-file` | `main` | `0df6becb2a59b7eec51233b7928b14f10baa530c` |
| 5 | `02-demo-custom-agents` | `main` | `c580638b6cd94148aeb59a2b04a729ceb2eeb8af` |
| 6 | `02-demo-hooks-logs` | `main` | `1fca14967830946db47261601d50f7204a8cdcd9` |
| 7 | `02-demo-hooks-logs-vscode` | `main` | `86d6a223cb41b82c0ddfd829d1fedd89f0145447` |
| 8 | `02-demo-hooks-prevencao` | `main` | `3a1f1db8d868964cc1f4580f3f7d9d80be003f81` |

## Resultado esperado

| Repositório | Conceito confirmado | Principais evidências |
| --- | --- | --- |
| `01-lab` | Lab do Módulo 1 e baseline usado pelas demos | `README.md`, `.github/copilot-instructions.md`, `.github/agents/revisor-entrega.md`, `.github/prompts/criar-endpoint-treinamento.prompt.md`, `.github/skills/review-ef-migration` |
| `02-demo-instructions` | Instructions gerais, por caminho e pessoais | `README.md`, `.github/copilot-instructions.md`, `.github/instructions/api.instructions.md`, `.github/instructions/tests.instructions.md` |
| `02-demo-agent-skills` | Agent Skill com carregamento progressivo | `README.md`, `.github/skills/review-ef-migration/SKILL.md`, `checklist.md`, `examples/risky-column-change.md`, scripts de inspeção |
| `02-demo-prompt-file` | Prompt file reutilizável com entradas e tools limitadas | `README.md`, `.github/prompts/criar-endpoint-treinamento.prompt.md` |
| `02-demo-custom-agents` | Custom agent, subagent e handoff | `README.md`, `.github/agents/revisor-entrega.md`, `.github/agents/pesquisador-criterios.md` |
| `02-demo-hooks-logs` | Registro de eventos de hooks no Copilot CLI | `README.md`, `.github/hooks/log-all-events.json`, `.github/scripts/log-copilot-hook.ps1`, `.github/scripts/log-copilot-hook.sh` |
| `02-demo-hooks-logs-vscode` | Registro dos eventos de hooks no VS Code | `README.md`, `.github/hooks/log-all-events.json`, `.github/scripts/log-copilot-hook.ps1`, `.github/scripts/log-copilot-hook.sh` |
| `02-demo-hooks-prevencao` | Bloqueio de alterações em arquivos críticos com `preToolUse` | `README.md`, `.github/hooks/protect-critical-config.json`, `.github/protected-files.txt`, scripts de proteção |

## Evidências de evolução

Os hashes retornados pelo GitHub ajudam a evitar conclusões baseadas somente em
nomes:

- `02-demo-instructions`, `02-demo-prompt-file`,
  `02-demo-custom-agents` e `02-demo-agent-skills` compartilham o mesmo conteúdo
  em `.github/copilot-instructions.md`;
- `api.instructions.md` e `tests.instructions.md` também possuem o mesmo
  conteúdo nesses quatro repositórios;
- o prompt file muda entre `02-demo-instructions` e
  `02-demo-prompt-file`;
- os arquivos de agentes mudam em `02-demo-custom-agents`;
- a skill recebe checklist, exemplo e scripts em `02-demo-agent-skills`;
- as três demos de hooks são variações independentes e não uma continuação
  cumulativa das quatro demos anteriores;
- os scripts de logging são compartilhados entre as duas demos de logs, mas os
  arquivos de configuração dos hooks são diferentes.

Essas observações mostram por que os repositórios devem ser comparados com o
baseline, e não interpretados como uma sequência de commits.

## Exemplo de síntese

Uma resposta aceitável deve:

1. manter a ordem solicitada;
2. citar ao menos um arquivo por repositório;
3. distinguir Copilot CLI de VS Code nas demos de hooks;
4. não afirmar que os repositórios são cumulativos;
5. não recomendar a cópia indiscriminada de arquivos para `01-lab`;
6. não criar uma issue antes da busca de duplicidade e da aprovação.

## Exemplo de rascunho de issue

### Título

```text
Documentar o mapa das demonstrações do Módulo 2
```

### Corpo

```markdown
## Contexto

O Módulo 2 possui demonstrações separadas para instructions, prompt files,
custom agents, agent skills e hooks. Falta um mapa único que relacione cada
repositório ao conceito e aos artefatos que o comprovam.

## Proposta

Adicionar uma documentação navegável contendo, para cada demonstração:

- link do repositório;
- conceito principal;
- arquivos relevantes;
- comportamento que o aluno deve observar;
- superfície utilizada, quando houver diferença entre VS Code e Copilot CLI.

## Repositórios

- `01-lab`
- `02-demo-instructions`
- `02-demo-agent-skills`
- `02-demo-prompt-file`
- `02-demo-custom-agents`
- `02-demo-hooks-logs`
- `02-demo-hooks-logs-vscode`
- `02-demo-hooks-prevencao`

## Critérios de conclusão

- todos os repositórios estão vinculados;
- cada conclusão cita arquivos existentes;
- as demos de hooks distinguem CLI e VS Code;
- o conteúdo não apresenta os repositórios como uma cadeia cumulativa;
- nenhuma credencial ou configuração pessoal é incluída.
```

Este é apenas um exemplo sanitizado. Antes da criação, substitua-o pelo
rascunho produzido a partir da investigação atual e revise todos os argumentos.

## Procedimento de contingência

1. Mostre que o servidor ou a chamada falhou.
2. Não descreva a falha como sucesso.
3. Abra a tabela de commits consultados.
4. Explique que o conteúdo abaixo foi coletado anteriormente.
5. Use o resultado esperado para discutir evidência e síntese.
6. Se o GitHub voltar a responder, execute somente a busca de duplicidade.
7. Crie a issue apenas se a busca atual funcionar e houver aprovação explícita.

Não use o fallback como autorização para escrever no GitHub sem confirmar o
estado atual do repositório e das issues.
