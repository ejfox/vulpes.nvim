<#
.SYNOPSIS
  Install the vulpes theme into native-Windows tools: WezTerm, Windows Terminal, bat.
.DESCRIPTION
  Run from anywhere:  pwsh -File extras\install-vulpes.ps1
  Idempotent — re-run any time. Only writes theme files + injects a Windows Terminal
  color scheme; it does not select the scheme unless you pass -SetDefault.
.PARAMETER SetDefault
  Also set the injected "Vulpes" scheme as Windows Terminal's default colorScheme.
.PARAMETER DryRun
  Print what would happen, change nothing.
#>
[CmdletBinding()]
param(
  [switch]$SetDefault,
  [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$Extras = Split-Path -Parent $MyInvocation.MyCommand.Path
function Say  ($m) { Write-Host "  $m" }
function Step ($m) { Write-Host "`n$m" -ForegroundColor Cyan }

function Put ($src, $dest) {
  $s = Join-Path $Extras $src
  if (-not (Test-Path $s)) { Say "skip  $src (not in extras/)"; return }
  if ($DryRun) { Say "would copy $src -> $dest"; return }
  $dir = Split-Path -Parent $dest
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  Copy-Item -Force $s $dest
  Say "ok    $dest"
}

# ---- WezTerm -----------------------------------------------------------------
Step "WezTerm"
Put 'vulpes-wezterm.lua' (Join-Path $HOME '.config\wezterm\colors\vulpes.lua')

# ---- Windows Terminal --------------------------------------------------------
Step "Windows Terminal"
$wtCandidates = @(
  "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
  "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json",
  "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
)
$wt = $wtCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $wt) {
  Say "Windows Terminal settings.json not found — open WT once, then re-run. Skipping."
} else {
  $schemeJson = Get-Content (Join-Path $Extras 'vulpes-windows-terminal.json') -Raw | ConvertFrom-Json
  if ($DryRun) {
    $extra = if ($SetDefault) { ' and set as default' } else { '' }
    Say "would inject 'Vulpes' scheme into $wt$extra"
  } else {
    $cfg = Get-Content $wt -Raw | ConvertFrom-Json
    if (-not $cfg.schemes) { $cfg | Add-Member -NotePropertyName schemes -NotePropertyValue @() -Force }
    # drop any prior "Vulpes", then add ours (idempotent)
    $cfg.schemes = @($cfg.schemes | Where-Object { $_.name -ne 'Vulpes' }) + $schemeJson
    if ($SetDefault) {
      if (-not $cfg.profiles) { $cfg | Add-Member -NotePropertyName profiles -NotePropertyValue (@{}) -Force }
      if (-not $cfg.profiles.defaults) { $cfg.profiles | Add-Member -NotePropertyName defaults -NotePropertyValue (@{}) -Force }
      $cfg.profiles.defaults | Add-Member -NotePropertyName colorScheme -NotePropertyValue 'Vulpes' -Force
    }
    Copy-Item -Force $wt "$wt.bak"        # backup before touching their config
    # WriteAllText emits UTF-8 without BOM on both Windows PowerShell 5.1 and pwsh 7+
    # (Set-Content -Encoding utf8 would add a BOM under 5.1).
    [System.IO.File]::WriteAllText($wt, ($cfg | ConvertTo-Json -Depth 32))
    Say "ok    injected 'Vulpes' scheme (backup at settings.json.bak)"
    if ($SetDefault) { Say "ok    set as default colorScheme" }
  }
}

# ---- bat ---------------------------------------------------------------------
Step "bat"
if (Get-Command bat -ErrorAction SilentlyContinue) {
  $batThemes = Join-Path (bat --config-dir) 'themes'
  Put 'vulpes-bat.tmTheme' (Join-Path $batThemes 'vulpes.tmTheme')
  if (-not $DryRun) { bat cache --build | Out-Null; Say "ok    bat cache rebuilt" }
} else {
  Say "bat not installed — skipping"
}

# ---- turn-on notes -----------------------------------------------------------
Step "Turn it on"
@"
  WezTerm  ~/.wezterm.lua           config.color_scheme = 'vulpes'
  WT       (Settings > pick 'Vulpes', or re-run with -SetDefault)
  bat      `$env:USERPROFILE\.config\bat\config   --theme=vulpes
  nvim     install ejfox/vulpes.nvim, then: colorscheme vulpes
  WSL2     run install-vulpes.sh inside Debian for the Linux-side tools
"@ | Write-Host
