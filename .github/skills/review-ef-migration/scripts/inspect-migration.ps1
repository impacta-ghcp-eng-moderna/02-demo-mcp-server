param(
    [Parameter(Position = 0)]
    [string]$MigrationPath
)

# Exit codes: 0 = inspection completed, 64 = invalid usage,
# 66 = file unavailable.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($MigrationPath)) {
    [Console]::Error.WriteLine('Uso: inspect-migration.ps1 <caminho-da-migration>')
    exit 64
}

if (-not (Test-Path -LiteralPath $MigrationPath -PathType Leaf)) {
    [Console]::Error.WriteLine(
        "Erro: o caminho não existe ou não é arquivo: $MigrationPath"
    )
    exit 66
}

try {
    $lines = @(Get-Content -LiteralPath $MigrationPath)
}
catch {
    [Console]::Error.WriteLine(
        "Erro: o arquivo não pode ser lido: $MigrationPath"
    )
    exit 66
}

$signals = @(
    @{ Label = 'remoção de coluna'; Pattern = 'migrationBuilder\.DropColumn\s*\(' }
    @{ Label = 'adição de coluna'; Pattern = 'migrationBuilder\.AddColumn(?:<[^>]+>)?\s*\(' }
    @{ Label = 'renomeação de coluna'; Pattern = 'migrationBuilder\.RenameColumn\s*\(' }
    @{ Label = 'alteração de coluna'; Pattern = 'migrationBuilder\.AlterColumn(?:<[^>]+>)?\s*\(' }
    @{ Label = 'SQL escrito manualmente'; Pattern = 'migrationBuilder\.Sql\s*\(' }
)

Write-Output "Inspeção estática: $MigrationPath"
Write-Output 'Correspondências são sinais para revisão humana, não conclusões.'

$foundSignal = $false

foreach ($signal in $signals) {
    $matchedLines = @(for ($index = 0; $index -lt $lines.Count; $index++) {
        if ($lines[$index] -match $signal.Pattern) {
            '{0}:{1}' -f ($index + 1), $lines[$index]
        }
    })

    if ($matchedLines.Count -gt 0) {
        $foundSignal = $true
        Write-Output ''
        Write-Output "Sinal: $($signal.Label)"
        Write-Output $matchedLines
    }
}

$content = $lines -join [Environment]::NewLine
$downMatch = [regex]::Match(
    $content,
    'protected\s+override\s+void\s+Down\s*\('
)

if (-not $downMatch.Success) {
    $foundSignal = $true
    Write-Output ''
    Write-Output 'Sinal: método Down não localizado.'
}
else {
    $downContent = $content.Substring($downMatch.Index)

    if ($downContent -notmatch 'migrationBuilder\.\w+\s*\(') {
        $foundSignal = $true
        Write-Output ''
        Write-Output 'Sinal: Down parece não conter operações de migrationBuilder.'
    }
}

if (-not $foundSignal) {
    Write-Output ''
    Write-Output 'Nenhum dos padrões selecionados foi localizado.'
}

Write-Output ''
Write-Output 'Inspeção concluída sem executar ou alterar a migration.'
exit 0
