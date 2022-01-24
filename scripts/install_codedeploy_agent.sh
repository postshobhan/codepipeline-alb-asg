#!/bin/bash

#You can use this script on EC2 user script section to install codedeploy agent during startup.
#This also includes optional installation of httpd service, which I used for ELB health check purpose
sudo yum update -y
sudo yum install ruby wget httpd -y
/opt/codedeploy-agent/bin/codedeploy-agent stop
sudo yum erase codedeploy-agent -y
cd /home/ec2-user
rm -rf *
#You may want to modify the below line to make it dynamic using metadata service to fetch the installer from a suitable region
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

#for elb health check on port 80
#please make sure to open port 80 on security grp of ec2 instance.
service httpd start
cd /var/www/html
touch index.html
echo 'server running' > index.html