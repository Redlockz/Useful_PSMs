BeforeAll {
    Import-Module -Name D:\a\Useful_PSMs\Useful_PSMs\Update-Repositories\Update-Repositories.psm1 -Verbose -Force
}

Describe "Update-Repositories" {
    Context "Read-Host" {
        It "Should throw" {
            {Update-Repositories} | Should -Throw "*location not found*"
        }
    }
    Context "Enter git directory and update repository" {
        Set-Content -Path "D:\a\Useful_PSMs\Useful_PSMs\.ado_gitfolder.txt" -Value 'nada'
        It "Should invoke Read-Host" {
            {Update-Repositories} | Should -Invoke -CommandName Read-Host
        }
    }
}
