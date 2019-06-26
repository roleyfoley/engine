[#ftl]
[#include "/bootstrap.ftl" ]

[#-- Special processing --]
[#switch deploymentUnit]
    [#case "eip"]
    [#case "iam"]
    [#case "lg"]
        [#if (deploymentUnitSubset!"") == "genplan"]
            [@cfScript "script" getGenerationPlan("template") /]
        [#else]
            [#if !(deploymentUnitSubset?has_content)]
                [#assign allDeploymentUnits = true]
                [#assign deploymentUnitSubset = deploymentUnit]
                [#assign ignoreDeploymentUnitSubsetInOutputs = true]
            [/#if]
        [/#if]
        [#break]
[/#switch]

[@cfTemplate level="solution" /]
