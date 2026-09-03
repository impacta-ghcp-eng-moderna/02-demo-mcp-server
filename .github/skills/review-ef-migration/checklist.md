# Checklist de revisão de migration

Use os identificadores abaixo para tornar os achados rastreáveis.

## Escopo e coerência

- **CTX-01**: `Up`, `Down`, entidade, configuração, snapshot e especificação
  aplicável foram lidos em conjunto.
- **CTX-02**: entidade, configuração, snapshot e migration descrevem o mesmo
  nome, tipo, nulabilidade e valor padrão.
- **CTX-03**: o estado-alvo corresponde à intenção declarada da mudança.

## Dados e esquema

- **DATA-01**: `DropTable` e `DropColumn` têm impacto sobre dados explicitado.
- **DATA-02**: remoção seguida de adição foi comparada com uma possível
  renomeação, sem assumir que `RenameColumn` seja universalmente seguro.
- **DATA-03**: colunas obrigatórias novas têm estratégia válida para linhas
  existentes; valores padrão não ocultam perda ou alteração semântica.
- **DATA-04**: conversões de tipo, redução de tamanho e mudança de precisão
  consideram valores já armazenados.
- **SCHEMA-01**: chaves, índices, unicidade, relacionamentos e restrições são
  preservados ou alterados de modo intencional.
- **SQL-01**: chamadas a `Sql(...)` foram revisadas quanto a portabilidade,
  idempotência, quoting e efeito sobre dados.

## Provedor SQLite

- **SQLITE-01**: operações que exigem reconstrução foram identificadas.
- **SQLITE-02**: artefatos fora do modelo do EF Core, como triggers ou índices
  manuais, foram considerados antes de uma reconstrução.
- **SQLITE-03**: o suporte do provedor e o SQL gerado ainda precisam ser
  validados quando a conclusão depender da versão em uso.

## Reversão e validação

- **DOWN-01**: `Down` restaura coerentemente a estrutura anterior.
- **DOWN-02**: reversão estrutural não foi confundida com recuperação dos dados
  descartados ou transformados por `Up`.
- **RUN-01**: qualquer aplicação futura está limitada a banco descartável, com
  estado conhecido, backup e critérios de comparação definidos.

## Classificação do relatório

Classifique como **confirmado** o que decorre diretamente do código e dos
artefatos lidos. Classifique como **risco condicionado** o que depende do estado
real dos dados, de objetos externos ao modelo, do SQL gerado ou da versão do
provedor. Para cada item, cite o identificador da checklist, a evidência, o
impacto e a menor ação seguinte.
