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
        It "Should throw git error" {
            Set-Content -Path "$HOME\.ado_gitfolder.txt" -Value 'D:\a\Useful_PSMs\Useful_PSMs'
            # {Update-Repositories} | Should -BeLike "" 
            $obj = Update-Repositories
            write-output $obj
            $obj | Should -Not -BeNullOrEmpty
        }
    }
}
