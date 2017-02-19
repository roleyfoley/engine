[#-- KMS CMK --]
[#if slice?contains("cmk")]
    [#if resourceCount > 0],[/#if]
    [#switch productListMode]
        [#case "definition"]
[#-- Key for product --]
            "cmk" : {
                "Type" : "AWS::KMS::Key",
                "Properties" : {
                    "Description" : "${productName}",
                    "Enabled" : true,
                    "EnableKeyRotation" : ${(rotateKeys)?string("true","false")},
                    "KeyPolicy" : {
                        "Version": "2012-10-17",
                        "Statement": [
                            {
                                "Effect": "Allow",
                                "Principal": {
                                    "AWS": {
                                        "Fn::Join": [
                                            "",
                                            [
                                                "arn:aws:iam::",
                                                { "Ref" : "AWS::AccountId" },
                                                ":root"
                                            ]
                                        ]
                                    }
                                },
                                "Action": [ "kms:*" ],
                                "Resource": "*"
                            }
                        ]
                    }
                }
            },
            "aliasXcmk" : {
                "Type" : "AWS::KMS::Alias",
                "Properties" : {
                    "AliasName" : "alias/${productName}",
                    "TargetKeyId" : { "Fn::GetAtt" : ["cmk", "Arn"] }
                }
            }
            [#break]
        [#case "outputs"]
            "cmkXproductXcmk" : {
                "Value" : { "Ref" : "cmk" }
            }
            [#break]

    [/#switch]
    [#assign resourceCount += 1]
[/#if]

