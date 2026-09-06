param([switch]$InstallEditor)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$engineVersion = (Get-Content -Raw -LiteralPath (Join-Path $repoRoot 'config/validation.json') | ConvertFrom-Json).engine.version
if ($engineVersion -ne '4.7.2') { throw 'Update the pinned installer URLs when upgrading Godot.' }
$cacheDir = Join-Path $repoRoot 'artifacts/downloads'
New-Item -ItemType Directory -Force -Path $cacheDir | Out-Null
$templateArchive = Join-Path $cacheDir "Godot_v$engineVersion-stable_export_templates.tpz"
if (!(Test-Path -LiteralPath $templateArchive)) {
  Invoke-WebRequest -Uri 'https://downloads.godotengine.org/?flavor=stable&platform=templates&slug=export_templates.tpz&version=4.7.2' -OutFile "$templateArchive.partial"
  Move-Item -LiteralPath "$templateArchive.partial" -Destination $templateArchive
}
Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [System.IO.Compression.ZipFile]::OpenRead($templateArchive)
try {
  $versionEntry = $archive.GetEntry('templates/version.txt')
  if (!$versionEntry) { throw 'Export template archive is missing version.txt.' }
  $reader = [System.IO.StreamReader]::new($versionEntry.Open())
  try { $templateVersion = $reader.ReadToEnd().Trim() } finally { $reader.Dispose() }
  if ($templateVersion -ne "$engineVersion.stable") { throw "Unexpected template version: $templateVersion" }
  $templateDir = Join-Path $env:APPDATA "Godot/export_templates/$templateVersion"
  New-Item -ItemType Directory -Force -Path $templateDir | Out-Null
  foreach ($name in @('version.txt', 'windows_debug_x86_64.exe', 'windows_release_x86_64.exe')) {
    $entry = $archive.GetEntry("templates/$name")
    if (!$entry) { throw "Missing template: $name" }
    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, (Join-Path $templateDir $name), $true)
  }
  Write-Output "Installed Godot $templateVersion Windows x86_64 debug/release templates into $templateDir"
} finally { $archive.Dispose() }
if ($InstallEditor) {
  $editorArchive = Join-Path $cacheDir "Godot_v$engineVersion-stable_win64.exe.zip"
  if (!(Test-Path -LiteralPath $editorArchive)) {
    Invoke-WebRequest -Uri 'https://downloads.godotengine.org/?flavor=stable&platform=windows.64&slug=win64.exe.zip&version=4.7.2' -OutFile "$editorArchive.partial"
    Move-Item -LiteralPath "$editorArchive.partial" -Destination $editorArchive
  }
  $toolDir = Join-Path $repoRoot '.tools'
  Expand-Archive -LiteralPath $editorArchive -DestinationPath $toolDir -Force
  Write-Output "Editor installed in $toolDir"
}
