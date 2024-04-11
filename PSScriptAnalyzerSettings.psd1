@{
    CustomRulePath='CustomPSScriptAnalyzerRules.psm1'
    IncludeDefaultRules=$true
	ExcludeRules = @(
        'PSAvoidUsingWriteHost',
        'PSAvoidUsingPositionalParameters',
        'PSUseSingularNouns'
    )
}