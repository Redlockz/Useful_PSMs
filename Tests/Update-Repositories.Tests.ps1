Describe "Update-Repositories failing" {

    BeforeAll {
        Import-Module -Name D:\a\Useful_PSMs\Useful_PSMs\Update-Repositories\Update-Repositories.psm1 -Verbose -Force
    }

    Context "Update-Repositories" {
        It "Should throw" {
            {Update-Repositories} | Should -Throw "*location not found*"
        }
    
        It "Succeeds" {
            # Mock Get-Content { "C:/test/.ado_gitfolder.txt" }
            Mock Write-Host { }
            {Set-Content -Path "$HOME\.ado_gitfolder.txt" -Value 'D:\a\Useful_PSMs\Useful_PSMs'} | Should -Not -Throw
            Update-Repositories | Should -Not -Throw
            Should -Invoke Write-Host -Exactly 3
        }
    }
}
