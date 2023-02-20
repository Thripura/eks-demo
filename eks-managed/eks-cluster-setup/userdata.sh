#!/bin/bash -xe
          yum update -y
          yum install git -y
          yum install python -y
          yum install python3-pip -y
          pip3 install awscli
          # Kubectl Installation
          curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.15/2023-01-11/bin/linux/amd64/kubectl
          chmod +x ./kubectl
          mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
          echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
          kubectl version --short --client
          #AWS IAM Authenticator Installation
          curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.9/aws-iam-authenticator_0.5.9_linux_amd64
          chmod +x ./aws-iam-authenticator
          mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
          echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
          aws-iam-authenticator help
          # Kubeconfig file configuration
          aws eks --region ${AWS::Region}  update-kubeconfig --name ${EnvironmentName}
          export KUBECONFIG=~/.kube/config
          curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname-s)_amd64.tar.gz" | tar xz -C /tmp
          sudo mv /tmp/eksctl /usr/bin
          eksctl version
          curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2
          mv /root/bin/kubectl /usr/bin/kubectl
          # OpenSSL Installation
          yum install openssl11 -y
          rm -rf /bin/openssl
          mv /bin/openssl11 /bin/openssl