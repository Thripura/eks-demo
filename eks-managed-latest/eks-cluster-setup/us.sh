        UserData:
          Fn::Base64:
            !Sub |
            #!/bin/bash
            set -o xtrace
            /etc/eks/bootstrap.sh ${ClusterName} $BootstrapArgumentsForOnDemand
            /opt/aws/bin/cfn-signal --exit-code $? \
                     --stack  ${AWS::StackName} \
                     --resource NodeGroup  \
                     --region ${AWS::Region}
        IamInstanceProfile:
          Arn: !GetAtt NodeInstanceProfile.Arn
        KeyName: !Ref KeyName]
        ImageId:
          !If
            - HasNodeImageId
            - !Ref NodeImageId
            - Ref: NodeImageIdSSMParam
        InstanceType: !Ref NodeInstanceType
        BlockDeviceMappings:
          - DeviceName: /dev/xvda
            Ebs:
              VolumeSize: !Ref NodeVolumeSize
              VolumeType: gp2
              DeleteOnTermination: true