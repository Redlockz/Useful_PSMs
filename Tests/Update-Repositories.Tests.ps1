Describe "Update-Repositories failing" {

    BeforeAll {
        Import-Module -Name D:\a\Useful_PSMs\Useful_PSMs\Update-Repositories\Update-Repositories.psm1 -Verbose -Force
    }

    Context "Update-Repositories" {
        It "Should throw" {
            {Update-Repositories} | Should -Throw "*location not found*"
        }
        It "Succeeds" {
            {Set-Content -Path 'D:\a\Useful_PSMs\Useful_PSMs\.git' -Value 'Test'}
            {Set-Content -Path "$HOME\.ado_gitfolder.txt" -Value 'D:\a\Useful_PSMs\Useful_PSMs'} | Should -Not -Throw
            {Update-Repositories} | Should -Not -Throw
        }
        It "Succeeds, but not a git folder" {
            {Set-Content -Path "$HOME\.ado_gitfolder.txt" -Value 'D:\a'} | Should -Not -Throw
            Mock Test-Path { return $true }
            Mock Get-Content { return '$HOME\.ado_gitfolder.txt' }
            {Update-Repositories} | Should -Not -Throw
            {Set-Location D:\a\Useful_PSMs\Useful_PSMs\Update-Repositories\}
        }
    }
}
