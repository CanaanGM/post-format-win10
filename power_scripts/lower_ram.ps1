

$startprocessParams = @{
    FilePath     = "$Env:SystemRoot\REGEDIT.exe"
    ArgumentList = '/s', '.\registery_keys\lower_ram.reg'
    Verb         = 'RunAs'
    PassThru     = $true
    Wait         = $true
}
$proc = Start-Process @startprocessParams

if ($proc.ExitCode -eq 0) {
    'Success!'
}
else {
    "Fail! Exit code: $($Proc.ExitCode)"
}

