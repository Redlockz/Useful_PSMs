BeforeAll {
    Import-Module -Name D:\a\Useful_PSMs\Useful_PSMs\Update-Repositories\Update-Repositories.psm1 -Verbose -Force
}

Describe "Update-Repositories" {
    Context "location not found" {
        It "Should throw" {
            {Update-Repositories} | Should -Throw "*location not found*"
        }
    }
    Context "Enter git directory and update repository" {
        It "Create Test File" {
            {Set-Content -Path "$HOME\.ado_gitfolder.txt" -Value 'D:\a\Useful_PSMs\Useful_PSMs'} | Should -Not -Throw
        }
        It "Should throw" {
            {Update-Repositories} | Should -Throw
        }
    }
}
