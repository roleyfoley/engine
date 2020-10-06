[#ftl]

[#-- Deployment frameworks --]
[#assign DEFAULT_DEPLOYMENT_FRAMEWORK = "default"]

[#-- Management Contracts --]
[#macro createManagementContractStage deploymentUnit deploymentPriority deploymentGroup deploymentMode=getDeploymentMode() ]

    [#local deploymentModeDetails = getDeploymentModeDetails(deploymentMode)]
    [#local deploymentGroupDetails = getDeploymentGroupDetails(deploymentGroup) ]

    [#local executionPolicy = deploymentModeDetails.ExecutionPolicy ]

    [#local mandatoryContract = false]
    [#switch executionPolicy ]
        [#case "Required" ]
            [#local mandatoryContract = true ]
            [#break]

        [#case "Optional" ]
            [#local mandatoryContract = false ]
            [#break]
    [/#switch]

    [#if deploymentGroupDetails?has_content ]

        [#local stageId = deploymentGroupDetails.Id ]
        [#local stagePriority = 0 ]
        [#local stageEnabled = false ]

        [#-- Determine the group order --]
        [#switch deploymentModeDetails.Membership ]
            [#case "explicit" ]
                [#local groupList = (deploymentModeDetails.Explicit.Groups)![] ]
                [#if groupList?seq_contains(deploymentGroupDetails.Name) ]
                    [#local stageEnabled = true]
                    [#local stagePriority = groupList?seq_index_of(deploymentGroupDetails.Name) + 1 ]
                [/#if]
                [#break]

            [#case "priority" ]
                [#if deploymentGroupDetails.Name?matches( deploymentModeDetails.Priority.GroupFilter ) ]
                    [#local stageEnabled = true]
                    [#local stagePriority = valueIfTrue(
                                                deploymentGroupDetails.Priority,
                                                (deploymentModeDetails.Priority.Order == "LowestFirst"),
                                                1000 - deploymentGroupDetails.Priority
                                            )]
                [/#if]
                [#break]

        [/#switch]

        [#if stageEnabled ]
            [@contractStage
                id=stageId
                executionMode=CONTRACT_EXECUTION_MODE_PRIORITY
                priority=stagePriority
                mandatory=mandatoryContract
            /]

            [#local stepPriority = valueIfTrue(
                deploymentPriority,
                (deploymentModeDetails.Priority.Order == "LowestFirst"),
                1000 - deploymentPriority
            )]]

            [@contractStep
                id=formatId(stageId, deploymentUnit)
                stageId=stageId
                taskType=MANAGE_DEPLOYMENT_TASK_TYPE
                priority=stepPriority
                mandatory=mandatoryContract
                parameters=
                    {
                        "DeploymentUnit" : deploymentUnit,
                        "DeploymentGroup" : deploymentGroupDetails.Name
                    }
            /]
        [/#if]
    [/#if]
[/#macro]

[#macro createOccurrenceManagementContractStep occurrence ]
    [#local solution = occurrence.Configuration.Solution ]
    [#if ((solution["deployment:Group"])!"")?has_content ]
        [@createManagementContractStage
            deploymentUnit=getOccurrenceDeploymentUnit(occurrence)
            deploymentGroup=solution["deployment:Group"]
            deploymentPriority=solution["deployment:Priority"]
        /]
    [/#if]
[/#macro]

[#macro createResourceSetManagementContractStep deploymentGroupDetails ]
    [#list (deploymentGroupDetails.ResourceSets)?values as resourceSet ]
        [@createManagementContractStage
            deploymentUnit=resourceSet["deployment:Unit"]
            deploymentGroup=deploymentGroupDetails.Name
            deploymentPriority=resourceSet["deployment:Priority"]
        /]
    [/#list]
[/#macro]
