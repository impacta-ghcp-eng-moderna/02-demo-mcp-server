# Demo: Agent Skills

Este repositório demonstra como uma Agent Skill oferece um procedimento
especializado e carrega recursos progressivamente. O cenário revisa uma
migration do Entity Framework Core sem aplicá-la nem alterar o banco.

## Cenário

A skill
[`review-ef-migration`](.github/skills/review-ef-migration/SKILL.md) compara uma
migration com entidade, configuração, model snapshot, especificação e
limitações do SQLite.

A candidata
[`RiskyRenameDescriptionToSummary`](docs/demo-migrations/20260903000000_RiskyRenameDescriptionToSummary.cs)
simula a troca de `Description` por `Summary` usando `DropColumn` e `AddColumn`.
Ela é deliberadamente inadequada:

- pode descartar as descrições existentes;
- não expressa a intenção de renomeação;
- diverge da entidade, da configuração e do snapshot;
- o método `Down` recria a coluna antiga, mas não recupera os dados.

O arquivo fica em `docs/demo-migrations`, fora da compilação e da descoberta de
migrations da aplicação. Ele existe somente para revisão estática.

## Estrutura da skill

```text
.github/skills/review-ef-migration/
├── SKILL.md
├── checklist.md
├── examples/
│   └── risky-column-change.md
└── scripts/
    ├── inspect-migration.ps1
    └── inspect-migration.sh
```

| Recurso | Responsabilidade |
| --- | --- |
| `SKILL.md` | Metadata, condições de ativação e fluxo principal. |
| `checklist.md` | Verificações detalhadas e identificadores citáveis. |
| `risky-column-change.md` | Exemplo de `DropColumn` + `AddColumn` e perguntas para investigação. |
| `inspect-migration.*` | Inspeção read-only de padrões relevantes. |

## Descoberta e carregamento progressivo

O front matter ativo usa:

| Campo | Efeito |
| --- | --- |
| `name` | Coincide com o diretório `review-ef-migration`. |
| `description` | Informa o que revisar e quando carregar a skill. |
| `argument-hint: "[caminho da migration]"` | Mostra a entrada esperada na invocação manual. |
| `user-invocable: true` | Disponibiliza a skill para invocação manual. Quando `false`, oculta essa opção. O padrão é `true`. |
| `disable-model-invocation: false` | Permite descoberta automática por relevância. Quando `true`, impede a ativação automática. O padrão é `false`. |

Uma descrição vaga como `Ajuda com migrations` oferece poucos sinais para
descoberta. A descrição ativa cita EF Core, riscos para dados, entidade,
snapshot e SQLite.

O progressive disclosure ocorre em três níveis:

1. `name` e `description` ficam disponíveis para descoberta.
2. O corpo de `SKILL.md` é carregado quando a tarefa corresponde.
3. Checklist, exemplo e scripts são consultados somente quando necessários.

`context: fork` não é usado porque a demo observa o carregamento no contexto
principal. `allowed-tools` também não é usado: seu suporte é experimental e não
deve ser apresentado como permissão de execução.

## Executar a demo no VS Code

Use uma versão atualizada do VS Code com GitHub Copilot e abra a raiz do
repositório em Codespaces.

1. Execute **Chat: Open Customizations** na Command Palette.
2. Abra **Skills** e selecione `review-ef-migration`.
3. Digite `/review-ef-migration` e observe o `argument-hint`, sem enviar o
   comando; os prompts seguintes demonstram a descoberta automática.
4. Use um chat novo para cada prompt.
5. Expanda as leituras exibidas no chat. Se a origem não estiver visível, use o
   Agent Debug Log.

### 1. Tarefa não relacionada

> Explique como o endpoint de contagem calcula o total de treinamentos. Não
> altere arquivos.

Observe que a skill de migration não é necessária e seus recursos não devem ser
consultados.

### 2. Tarefa relevante

> Revise a migration candidata em
> `docs/demo-migrations/20260903000000_RiskyRenameDescriptionToSummary.cs`.
> Identifique riscos para dados existentes e para SQLite. Não aplique a
> migration nem altere arquivos.

Observe a descoberta da skill, seguida pela leitura de `SKILL.md`. A revisão
inclui a inspeção estática com o recurso adequado ao ambiente, além da checklist
e do exemplo conforme as operações encontradas.

### 3. Recurso executável

Durante a execução do passo 2, observe se o agente:

1. consulta a seção de inspeção da skill;
2. escolhe a versão Bash no Codespace ou PowerShell no Windows;
3. lê o recurso antes de solicitar sua execução;
4. apresenta uma chamada de terminal sujeita à aprovação normal;
5. combina a saída com os demais artefatos da revisão.

Antes de aprovar, expanda a leitura e confira o comando. A versão Bash usa apenas
`grep` e `awk`; a PowerShell usa `Get-Content` e expressões regulares. Nenhuma
versão executa `dotnet ef`, escreve arquivos, cria banco, acessa rede ou instala
dependências.

No Codespace:

```bash
bash .github/skills/review-ef-migration/scripts/inspect-migration.sh \
  docs/demo-migrations/20260903000000_RiskyRenameDescriptionToSummary.cs
```

No PowerShell:

```powershell
& .github/skills/review-ef-migration/scripts/inspect-migration.ps1 `
  docs/demo-migrations/20260903000000_RiskyRenameDescriptionToSummary.cs
```

As duas versões devem localizar `DropColumn` e `AddColumn`. As correspondências
são sinais para revisão humana, não conclusões. Código `0` indica inspeção
concluída, `64` uso inválido e `66` arquivo indisponível; a versão Bash também
usa `69` quando `grep` ou `awk` não existe.

## Confirmar que nada foi aplicado

Não execute `dotnet ef database update` e não mova a candidata para
`src/Infrastructure/Migrations`.

Antes e depois da demo, confira o painel **Source Control** ou execute:

```bash
git diff --exit-code -- \
  src/Infrastructure/TrainingEntity.cs \
  src/Infrastructure/TrainingCatalogDbContext.cs \
  src/Infrastructure/Migrations \
  src/Api/training-catalog.db
```

## Validar o repositório

```bash
dotnet build src/TrainingCatalog.slnx
dotnet test src/TrainingCatalog.slnx
```

## Limitações e segurança

- A seleção da skill e a ordem exata das leituras são decisões do modelo e
  podem variar entre execuções.
- Interface, logs e suporte a campos podem variar entre versões e superfícies.
- A versão `.sh` requer Bash, `grep` e `awk`; a `.ps1` requer PowerShell.
- Skills de terceiros podem conter instruções enganosas ou scripts destrutivos.
  Revise origem e conteúdo antes de instalar ou executar.
- Recursos separados deixam de ocupar o contexto antes da necessidade, mas esta
  demo não mede nem promete uma redução exata de tokens.

## Referências

Documentação consultada em **3 de setembro de 2026**:

- [Agent Skills no VS Code](https://code.visualstudio.com/docs/agent-customization/agent-skills)
- [Agent Skills no GitHub Copilot](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)
- [Especificação aberta de Agent Skills](https://agentskills.io/specification)
- [Cheat sheet de customizações](https://docs.github.com/en/copilot/reference/customization-cheat-sheet)
- [Limitações do SQLite no EF Core](https://learn.microsoft.com/ef/core/providers/sqlite/limitations)
