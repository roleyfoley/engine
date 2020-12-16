[#ftl]

[@addReference
    type=NETWORKPROFILE_REFERENCE_TYPE
    pluralType="NetworkProfiles"
    properties=[
            {
                "Type"  : "Description",
                "Value" : "A profile to desribe network level controls"
            }
        ]
    attributes=[
        {
            "Names" : "BaseSecurityGroup",
            "Children" : [
                {
                    "Names" : "Links",
                    "Description" : "Apply network security rules based on links",
                    "Subobjects" : true,
                    "Reference" : {
                        "Schema" : "attributeset",
                        "Type" : LINK_ATTRIBUTESET_TYPE
                    }
                },
                {
                    "Names" : "Outbound",
                    "Description" : "Outbound security group rules",
                    "Children" : [
                        {
                            "Names" : "GlobalAllow",
                            "Description" : "Allow all outbound traffic",
                            "Types" : BOOLEAN_TYPE,
                            "Default" : true
                        },
                        {
                            "Names" : "NetworkRules",
                            "SubObjects" : true,
                            "Children" : networkRuleChildConfiguration
                        }
                    ]
                }
            ]
        }
    ]
/]
