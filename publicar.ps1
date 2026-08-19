<#
.SYNOPSIS
    Copia una baraja ya renderizada a su carpeta dentro del hub de charlas.

.DESCRIPTION
    Hace el paso 2 de "Agregar una charla" del README: crea AAAA\slug\ si no
    existe y copia el .html ahi dentro con el nombre index.html, que es lo que
    da la URL limpia (/talks/2026/mi-slug/ en vez de /talks/2026/mi-slug.html).

    NO toca index.html: anunciar la charla en la portada sigue siendo un paso
    manual, a proposito. El resumen y el nombre del congreso los escribe una
    persona, no un script.

.PARAMETER Origen
    Ruta del .html renderizado. Relativa a este repositorio o absoluta.

.PARAMETER Anio
    Ano de la charla. Es el nombre de la carpeta de primer nivel.

.PARAMETER Slug
    Nombre de la carpeta de la charla. Minusculas, sin acentos ni espacios.

.PARAMETER Forzar
    Sobrescribe sin preguntar si ya habia un index.html ahi.

.EXAMPLE
    .\publicar.ps1 -Origen "..\COMEXANE\comexane-2026-keynote\docs\presentations\tesis_medico_residente.html" -Anio 2026 -Slug "comexane-tesis-medico-residente"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string] $Origen,
    [Parameter(Mandatory = $true)][ValidatePattern('^\d{4}$')][string] $Anio,
    [Parameter(Mandatory = $true)][ValidatePattern('^[a-z0-9]+(-[a-z0-9]+)*$')][string] $Slug,
    [switch] $Forzar
)

$ErrorActionPreference = 'Stop'

# Todo se resuelve contra la carpeta del script y no contra el directorio de
# trabajo: asi funciona igual si se invoca desde otro sitio.
$Raiz = $PSScriptRoot

if (-not (Test-Path -LiteralPath $Origen -PathType Leaf)) {
    throw "No existe el archivo de origen: $Origen"
}

if ([IO.Path]::GetExtension($Origen).ToLower() -ne '.html') {
    throw "El origen tiene que ser un .html; llego: $Origen"
}

$Destino     = Join-Path $Raiz (Join-Path $Anio $Slug)
$ArchivoDest = Join-Path $Destino 'index.html'

if ((Test-Path -LiteralPath $ArchivoDest) -and -not $Forzar) {
    $anterior = (Get-Item -LiteralPath $ArchivoDest).LastWriteTime
    Write-Host "Ya hay una version publicada del $anterior." -ForegroundColor Yellow
    $r = Read-Host '  Sobrescribir? (s/N)'
    if ($r -notmatch '^[sSyY]$') {
        Write-Host 'Cancelado.' -ForegroundColor Yellow
        return
    }
}

New-Item -ItemType Directory -Path $Destino -Force | Out-Null
Copy-Item -LiteralPath $Origen -Destination $ArchivoDest -Force

$mb = [math]::Round((Get-Item -LiteralPath $ArchivoDest).Length / 1MB, 1)

Write-Host ''
Write-Host "Publicado: $Anio/$Slug/index.html  ($mb MB)" -ForegroundColor Green
Write-Host ''
Write-Host 'Falta:' -ForegroundColor Cyan
Write-Host "  1. Anunciar la charla en index.html (arreglo CHARLAS y bloque <noscript>)."
Write-Host "     slug: `"$Anio/$Slug/`""
Write-Host '  2. Revisar abriendo index.html con doble clic.'
Write-Host '  3. git add . ; git commit -m "Agrega charla ..." ; git push'
Write-Host ''

# Aviso, no error: 8-10 MB es lo normal con embed-resources, pero pasado cierto
# punto conviene saber que cada render de este tamano se queda en el historial.
if ($mb -gt 20) {
    Write-Host "Aviso: $mb MB es grande incluso para una baraja autocontenida." -ForegroundColor Yellow
    Write-Host '       Cada render queda entero en el historial de Git.' -ForegroundColor Yellow
    Write-Host ''
}
