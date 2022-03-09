
 function Install-Font {  
    param  
    (  
         [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][System.IO.FileInfo]$FontFile  
    )  
      
    #Get Font Name from the File's Extended Attributes  
    $oShell = new-object -com shell.application  
    $Folder = $oShell.namespace($FontFile.DirectoryName)  
    $Item = $Folder.Items().Item($FontFile.Name)  
    $FontName = $Folder.GetDetailsOf($Item, 21)  
    try {  
         switch ($FontFile.Extension) {  
              ".ttf" {$FontName = $FontName + [char]32 + '(TrueType)'}  
              ".otf" {$FontName = $FontName + [char]32 + '(OpenType)'}  
         }  
         $Copy = $true  
         Write-Host ('Copying' + [char]32 + $FontFile.Name + '.....') -NoNewline  
         Copy-Item -Path $fontFile.FullName -Destination ("C:\Windows\Fonts\" + $FontFile.Name) -Force  
         #Test if font is copied over  
         If ((Test-Path ("C:\Windows\Fonts\" + $FontFile.Name)) -eq $true) {  
              Write-Host ('Success') -Foreground Yellow  
         } else {  
              Write-Host ('Failed') -ForegroundColor Red  
         }  
         $Copy = $false  
         #Test if font registry entry exists  
         If ($null -ne (Get-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -ErrorAction SilentlyContinue)) {  
              #Test if the entry matches the font file name  
              If ((Get-ItemPropertyValue -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts") -eq $FontFile.Name) {  
                   Write-Host ('Adding' + [char]32 + $FontName + [char]32 + 'to the registry.....') -NoNewline  
                   Write-Host ('Success') -ForegroundColor Yellow  
              } else {  
                   $AddKey = $true  
                   Remove-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Force  
                   Write-Host ('Adding' + [char]32 + $FontName + [char]32 + 'to the registry.....') -NoNewline  
                   New-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $FontFile.Name -Force -ErrorAction SilentlyContinue | Out-Null  
                   If ((Get-ItemPropertyValue -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts") -eq $FontFile.Name) {  
                        Write-Host ('Success') -ForegroundColor Yellow  
                   } else {  
                        Write-Host ('Failed') -ForegroundColor Red  
                   }  
                   $AddKey = $false  
              }  
         } else {  
              $AddKey = $true  
              Write-Host ('Adding' + [char]32 + $FontName + [char]32 + 'to the registry.....') -NoNewline  
              New-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $FontFile.Name -Force -ErrorAction SilentlyContinue | Out-Null  
              If ((Get-ItemPropertyValue -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts") -eq $FontFile.Name) {  
                   Write-Host ('Success') -ForegroundColor Yellow  
              } else {  
                   Write-Host ('Failed') -ForegroundColor Red  
              }  
              $AddKey = $false  
         }  
           
    } catch {  
         If ($Copy -eq $true) {  
              Write-Host ('Failed') -ForegroundColor Red  
              $Copy = $false  
         }  
         If ($AddKey -eq $true) {  
              Write-Host ('Failed') -ForegroundColor Red  
              $AddKey = $false  
         }  
         write-warning $_.exception.message  
    }  
    Write-Host  
}  
 
#Get a list of all font files relative to this script and parse through the list  
foreach ($FontItem in (Get-ChildItem -Path "..\fonts" | Where-Object {  
              ($_.Name -like '*.ttf') -or ($_.Name -like '*.OTF')  
         })) {  
    Install-Font -FontFile $FontItem  
}  
 

# foreach($FontFile in Get-ChildItem $fontSourceFolder -Include '*.ttf','*.ttc','*.otf' -recurse ) {
# 	$targetPath = Join-Path $SystemFontsPath $FontFile.Name
# 	if(Test-Path -Path $targetPath){
# 		Write-Output $FontFile
        
# 		$FontFile.Name + " already installed"
# 	}
# 	else {
# 		"Installing font " + $FontFile.Name
# 		Write-Output $FontFile
# 		#Extract Font information for Reqistry 
# 		$ShellFolder = (New-Object -COMObject Shell.Application).Namespace($fontSourceFolder)
# 		$ShellFile = $ShellFolder.ParseName($FontFile.name)
# 		$ShellFileType = $ShellFolder.GetDetailsOf($ShellFile, 2)

# 		#Set the $FontType Variable
# 		If ($ShellFileType -Like '*TrueType font file*') {$FontType = '(TrueType)'}
			
# 		#Update Registry and copy font to font directory
# 		$RegName = $ShellFolder.GetDetailsOf($ShellFile, 21) + ' ' + $FontType
# 		$null = New-ItemProperty -Name $RegName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $FontFile.name -Force
# 		Copy-item $FontFile.FullName -Destination $SystemFontsPath
# 		"Done"
# 	}
# }

