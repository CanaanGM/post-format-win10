# get apps from winget 
## larger apps are first  no ryhme or reason i just think it's better ¯\_(ツ)_/¯

$apps = @(
    "Google.AndroidStudio" 
    "Microsoft.VisualStudioCode" 
    "Discord.Discord" 
    "Docker.DockerDesktop" 
    "vim.vim" 
    "Valve.Steam" 
    "OpenJS.NodeJS" 
    "Rainmeter.Rainmeter" 
    "Obsidian.Obsidian" 
    "RARLab.WinRAR" 
    "TeamViewer.TeamViewer" 
    "AnyDeskSoftwareGmbH.AnyDesk" 
    "Iriun.IriunWebcam" 
    "GoLang.Go" 
    "Mozilla.Firefox" 
    "BraveSoftware.BraveBrowser" 
    "Mozilla.Thunderbird" 
    "CodecGuide.K-LiteCodecPack.Mega" 
    "Microsoft.WindowsTerminal" 
    "Microsoft.PowerShell" 
    "uw-labs.BloomRPC" 
    "VideoLAN.VLC"
)

foreach ($app in $apps){
    Write-Host "installing $app . . ."
    winget install -e $app | Out-Host
    if($?) { Write-Host "Installed $app" }
}