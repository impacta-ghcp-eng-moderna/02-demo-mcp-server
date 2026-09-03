#!/usr/bin/env bash

# Exit codes: 0 = inspection completed, 64 = invalid usage,
# 66 = file unavailable, 69 = required command unavailable.

set -u

if [[ $# -ne 1 ]]; then
    printf 'Uso: %s <caminho-da-migration>\n' "$0" >&2
    exit 64
fi

migration_path=$1

if [[ ! -f "$migration_path" || ! -r "$migration_path" ]]; then
    printf 'Erro: o caminho não existe, não é arquivo ou não pode ser lido: %s\n' "$migration_path" >&2
    exit 66
fi

for command_name in grep awk; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        printf 'Erro: comando necessário não encontrado: %s\n' "$command_name" >&2
        exit 69
    fi
done

labels=(
    'remoção de coluna'
    'adição de coluna'
    'renomeação de coluna'
    'alteração de coluna'
    'SQL escrito manualmente'
)

patterns=(
    'migrationBuilder[.]DropColumn[[:space:]]*[(]'
    'migrationBuilder[.]AddColumn(<[^>]+>)?[[:space:]]*[(]'
    'migrationBuilder[.]RenameColumn[[:space:]]*[(]'
    'migrationBuilder[.]AlterColumn(<[^>]+>)?[[:space:]]*[(]'
    'migrationBuilder[.]Sql[[:space:]]*[(]'
)

printf 'Inspeção estática: %s\n' "$migration_path"
printf 'Correspondências são sinais para revisão humana, não conclusões.\n'

found_signal=false

for index in "${!patterns[@]}"; do
    if matches=$(grep -nE "${patterns[$index]}" -- "$migration_path"); then
        found_signal=true
        printf '\nSinal: %s\n%s\n' "${labels[$index]}" "$matches"
    fi
done

down_pattern='protected[[:space:]]+override[[:space:]]+void[[:space:]]+Down[[:space:]]*[(]'

if ! grep -qE "$down_pattern" -- "$migration_path"; then
    found_signal=true
    printf '\nSinal: método Down não localizado.\n'
elif ! awk '
    $0 ~ /protected[[:space:]]+override[[:space:]]+void[[:space:]]+Down[[:space:]]*[(]/ {
        in_down = 1
    }
    in_down && $0 ~ /migrationBuilder[.][[:alnum:]_]+[[:space:]]*[(]/ {
        has_operation = 1
    }
    END {
        exit has_operation ? 0 : 1
    }
' "$migration_path"; then
    found_signal=true
    printf '\nSinal: Down parece não conter operações de migrationBuilder.\n'
fi

if [[ "$found_signal" == false ]]; then
    printf '\nNenhum dos padrões selecionados foi localizado.\n'
fi

printf '\nInspeção concluída sem executar ou alterar a migration.\n'
