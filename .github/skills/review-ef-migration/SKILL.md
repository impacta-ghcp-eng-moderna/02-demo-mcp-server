---
name: review-ef-migration
description: Revisa migrations do Entity Framework Core antes da aplicação, com foco em risco para dados, coerência com entidade e model snapshot e limitações do provedor SQLite. Use quando uma migration for criada ou alterada.
argument-hint: "[caminho da migration]"
user-invocable: true
disable-model-invocation: false
---

# Revisar migrations do Entity Framework Core

Use esta skill para revisar uma migration criada ou alterada. Não a use para
explicar consultas, endpoints ou regras de negócio sem mudança de esquema. Se
nenhum caminho for informado, revise a migration mais recente na pasta
Migrations, pelo timestamp do nome do arquivo. Se houver mais de uma migration
alterada no diff atual, liste-as e peça ao usuário para escolher antes de
prosseguir.

## Procedimento

1. Para cada migration selecionada, execute a inspeção estática reproduzível
   descrita abaixo.
2. Leia `Up`, `Down`, model snapshot, entidade, configuração do EF Core e
   especificação aplicável.
3. Compare a intenção declarada, os sinais da inspeção, as operações e o modelo
   atual.
4. Classifique separadamente problemas confirmados e riscos que dependem dos
   dados existentes, do SQL gerado ou do provedor.
5. Use [checklist.md](checklist.md) sempre que a migration contiver qualquer
   operação além de `CreateTable` ou `CreateIndex` em tabelas novas, por
   exemplo, `AlterColumn`, `DropColumn`, `RenameColumn`, mudança de chave ou
   índice único.
6. Consulte
   [examples/risky-column-change.md](examples/risky-column-change.md) quando
   houver `DropColumn` seguido de `AddColumn`, mudança de nulabilidade ou
   possível reconstrução de tabela.

Se algum artefato estiver ausente, registre a limitação. Segurança em banco
vazio não comprova segurança sobre dados existentes.

## Inspeção estática reproduzível

Escolha o script compatível com o ambiente:

- [scripts/inspect-migration.sh](scripts/inspect-migration.sh) para Bash;
- [scripts/inspect-migration.ps1](scripts/inspect-migration.ps1) para
  PowerShell.

Os dois apenas localizam padrões para revisão humana. Em toda revisão:

1. leia a versão escolhida;
2. confirme que o comando recebe somente o caminho da migration;
3. solicite sua execução pela tool normal, sem presumir aprovação;
4. relacione a saída aos itens aplicáveis da checklist.

Repita a inspeção separadamente para cada migration analisada. Não trate
correspondências como veredito. Se a execução não for aprovada ou não estiver
disponível, faça o mesmo inventário por leitura direta e registre que o script
não foi executado.

Não aplique nem reverta a migration. Não altere arquivos durante a revisão.

## Formato da resposta

Apresente achados agrupados nesta ordem de severidade: Bloqueante (perda ou
corrupção de dados confirmada), Alto (risco dependente de dados existentes ou do
provedor), Médio (incoerência entre migration, snapshot ou entidade sem perda de
dados), Baixo (estilo ou Down incompleto sem impacto em dados). Para cada um,
informe arquivo e operação, evidência, impacto e menor ação de correção ou
validação. Se não houver problema confirmado, não declare risco zero: liste o
que ainda exigiria um banco descartável com estado conhecido.
