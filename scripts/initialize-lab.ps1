$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$envPath = Join-Path $repoRoot ".env"

if (Test-Path -LiteralPath $envPath) {
    throw ".env already exists. Keep it, or remove it yourself before generating new lab credentials."
}

function New-LabSecret {
    $bytes = New-Object byte[] 48
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    try {
        $rng.GetBytes($bytes)
    }
    finally {
        $rng.Dispose()
    }

    return [Convert]::ToBase64String($bytes).TrimEnd("=").Replace("+", "-").Replace("/", "_")
}

$lines = @(
    "DB_NAME=osticket"
    "DB_USER=osticket"
    "DB_PASSWORD=$(New-LabSecret)"
    "DB_ROOT_PASSWORD=$(New-LabSecret)"
    "HOST_BIND_ADDRESS=127.0.0.1"
    "HOST_PORT=8080"
)
$content = ($lines -join [Environment]::NewLine) + [Environment]::NewLine
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($envPath, $content, $utf8NoBom)

Write-Host "Created .env with random database passwords. It is excluded from Git."
Write-Host "Start the lab with: docker compose up --build -d"
