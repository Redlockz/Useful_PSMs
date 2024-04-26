Describe "Update-Repositories failing" {

    BeforeAll {
        Import-Module -Name D:\a\Useful_PSMs\Useful_PSMs\Update-Repositories\Update-Repositories.psm1 -Verbose -Force
        Update-Repositories
    }

    Context "Update-Repositories failing" {
        It "Should throw" {
            Should -Throw "*location not found*"
        }
    }
    
    Context "Update-Repositories succeeding" {
        It "Success" {
            Set-Content -Path "$HOME\.ado_gitfolder.txt" -Value 'D:\a\Useful_PSMs\Useful_PSMs'
            Mock Write-Host
            Should -Invoke Write-Host -Exactly 3
        }
    }
}
