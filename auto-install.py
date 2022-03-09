import subprocess


class AfterFormat:
    def __init__(self) -> None:
        self.create_restore = ["PowerShell", "-ExecutionPolicy", "Unrestricted","./power_scripts/create-restore-point.ps1"] 
        self.lower_ram = ["PowerShell", "-ExecutionPolicy", "Unrestricted","./power_scripts/lower_ram.ps1"] 
        self.install_apps = ["PowerShell", "-ExecutionPolicy", "Unrestricted","./power_scripts/apps.ps1"]
        self.disable_tele = ["PowerShell", "-ExecutionPolicy", "Unrestricted","./power_scripts/disable-telementary.ps1"]
        self.bloat = ["PowerShell", "-ExecutionPolicy", "Unrestricted","./power_scripts/bloat.ps1"]
        self.cp_rar_key = ["PowerShell", "-ExecutionPolicy", "Unrestricted","./power_scripts/copy_rar.ps1"]
        self.disable_services = ["PowerShell", "-ExecutionPolicy", "Unrestricted","./power_scripts/disable_services.ps1"]
        self.disable_apps = ["PowerShell", "-ExecutionPolicy", "Unrestricted","./power_scripts/disable-background-apps.ps1"]
        self.fonts = ["PowerShell", "-ExecutionPolicy", "Unrestricted","./power_scripts/install-fonts.ps1"]
        self.winget = ["PowerShell", "-ExecutionPolicy", "Unrestricted","./power_scripts/install_winget.ps1"]
        
    def install(self) -> None:
        """invokes powershell install/adjusting scripts"""

        #! can make more robust function but i dont wanna bother
        # TODO: maybe just maybe make this better xD
        #create restore point
        subprocess.call(self.create_restore)
        winget_installed:int = subprocess.call(self.winget)

        #disable bloat and telementary
        subprocess.call(self.disable_tele)
        subprocess.call(self.bloat)

        # lower ram script 
        subprocess.call(self.lower_ram)

        # first install all apps then turn off services
        # for app in winget_apps invoke subprocess no async cause it needs to wait but catch any errors success -> 0 fail -> 1

        # install language packs 
        # then security updates only 
        if winget_installed == 0:
            subprocess.call(self.install_apps)
            subprocess.call(self.cp_rar_key) 

        subprocess.call(self.disable_apps)
        subprocess.call(self.disable_services)






if __name__ =="__main__":
    af = AfterFormat()
    af.install()