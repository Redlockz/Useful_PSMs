Describe "Update-Repositories failing" {

    BeforeAll {
        Import-Module -Name D:\a\Useful_PSMs\Useful_PSMs\Update-Repositories\Update-Repositories.psm1 -Verbose -Force
    }

    Context "Update-Repositories" {
        It "Should throw" {
            {Update-Repositories} | Should -Throw "*location not found*"
        }
        It "Succeeds" {
            {Set-Content -Path "$HOME\.ado_gitfolder.txt" -Value 'D:\a\Useful_PSMs\Useful_PSMs'} | Should -Not -Throw
            Mock Test-Path { return $true }
            Mock Get-Content { return '$HOME\.ado_gitfolder.txt' }
            Mock Set-Location { 'D:\a\Useful_PSMs\Useful_PSMs' }
            {Update-Repositories} | Should -Not -Throw
        }
        It "Succeeds, but not a git folder" {
            {Set-Content -Path "$HOME\.ado_gitfolder.txt" -Value 'D:\a\Useful_PSMs\Useful_PSMs'} | Should -Not -Throw
            $dir = Get-ChildItem
            $dir1 = Get-ChildItem D:\a\Useful_PSMs
            $dir2 = Get-ChildItem D:\a\Useful_PSMs\Useful_PSMs
            Write-Host $dir
            Write-Host $dir1
            Write-Host $dir2
            Remove-Item -Path D:\a\Useful_PSMs\Useful_PSMs\.git -Force
            Mock Test-Path { return $true }
            Mock Get-Content { return '$HOME\.ado_gitfolder.txt' }
            Mock Set-Location { 'D:\a\Useful_PSMs\Useful_PSMs' }
            {Update-Repositories} | Should -Not -Throw
        }
    }
}
