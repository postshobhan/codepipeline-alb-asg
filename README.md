# Sample SpringBoot application with necessary configs to be used on a codepipeline

This sample code includes buildpsec.yml for codebuild and appspec.yml for codedeploy to be used with alb. Also all the scripts are placed under scripts dir.

- The sample application runs on port 8080. This can be customized on springboot application.properties file (server.port=8080).
- Setup codebuild iam policy with artifact bucket s3 accees (read and write) and codecommit access.
- Make sure to install codedeploy agent on EC2 instance. I have used EC2 user script to achieve this. Refer to bash snippet below.

```bash
#!/bin/bash

sudo yum update -y
sudo yum install ruby wget httpd -y
/opt/codedeploy-agent/bin/codedeploy-agent stop
sudo yum erase codedeploy-agent -y
cd /home/ec2-user
rm -rf *
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

#for elb health check on port 80
#please make sure to open port 80 on security grp of ec2 instance.
service httpd start
cd /var/www/html
touch index.html
echo 'server running' > index.html

```

- EC2 instances (I have used Amazon Linux2 AMI) should have a instance profile that can read from s3 (artifact bucket) and have permission to interact with ELB and ASG. Refer to the first link below. IAM Policy snippet included below.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:Describe*",
        "autoscaling:EnterStandby",
        "autoscaling:ExitStandby",
        "autoscaling:UpdateAutoScalingGroup",
        "autoscaling:SuspendProcesses",
        "autoscaling:ResumeProcesses",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:RegisterTargets"
      ],
      "Resource": "*"
    }
  ]
}
```

- make sure to modify scripts/common_function.sh with the load balancer target group name (TARGET_GROUP_LIST="coolapp-tg-8081")
- codedeploy should have a role with managed codedeploy policy

### Links

- AWS sample for ELB with codedeploy https://github.com/aws-samples/aws-codedeploy-samples/tree/master/load-balancing/elb-v2
- [Codedeploy agent install guide ] https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install-linux.html
- https://medium.com/@octoz/building-your-ci-cd-pipeline-on-aws-8189800e8c96

### Guides

- youtube link coming soon
