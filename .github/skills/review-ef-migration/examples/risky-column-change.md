# Alteração arriscada de coluna

## Padrão observado

```csharp
migrationBuilder.DropColumn(
    name: "Description",
    table: "Trainings");

migrationBuilder.AddColumn<string>(
    name: "Summary",
    table: "Trainings",
    type: "TEXT",
    nullable: false,
    defaultValue: "");
```

Esse código remove `Description` e cria `Summary`. A estrutura final pode
parecer uma renomeação, mas os valores existentes não são transferidos; o valor
padrão pode apenas substituir silenciosamente o conteúdo perdido.

## Intenção a investigar

Se a intenção for preservar o mesmo dado sob outro nome, investigue
`RenameColumn` e o SQL gerado pelo provedor:

```csharp
migrationBuilder.RenameColumn(
    name: "Description",
    table: "Trainings",
    newName: "Summary");
```

Isso não é uma receita universal. O suporte e a estratégia do SQLite variam por
operação e versão, e reconstruções podem afetar artefatos que não pertencem ao
modelo do EF Core. Mudanças de nulabilidade também podem exigir tratamento
prévio dos dados.

## Perguntas antes da aplicação

1. A mudança é realmente uma renomeação ou cria um conceito diferente?
2. Existem valores que precisam ser preservados ou transformados?
3. Entidade, configuração e snapshot já descrevem o estado-alvo?
4. Qual SQL o provedor e a versão atuais geram?
5. Há triggers, índices ou outros objetos criados fora do modelo?
6. `Down` recupera dados ou somente recria a estrutura antiga vazia?
7. O plano foi validado em cópia descartável com dados representativos?
