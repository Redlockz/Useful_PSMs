BeforeAll {
    Import-Module -Name D:\a\Useful_PSMs\Useful_PSMs\Update-Repositories\Update-Repositories.psm1 -Verbose -Force
}

Describe "Update-Repositories" {
    Context "Update-Repositories" {
        It "Should throw" {
            {Update-Repositories} | Should -Throw "*location not found*"
        }
        It "Create Test File" {
            {Set-Content -Path "$HOME\.ado_gitfolder.txt" -Value 'D:\a\Useful_PSMs\Useful_PSMs'} | Should -Not -Throw
        }
        It "Should throw" {
            $output = Update-Repositories
            Write-Host $output
            Write-Verbose $output
            $output
            $output | Should -NotBeNullOrEmpty
        }
    }
}
