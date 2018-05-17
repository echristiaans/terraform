#!/bin/bash -xe
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install python-setuptools python-pip -y
hostname
easy_install --script-dir /opt/aws/bin https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz
ln -s /usr/local/lib/python2*/dist-packages/aws_cfn_bootstrap*/init/ubuntu/cfn-hup /etc/init.d/cfn-hup
chmod +x /etc/init.d/cfn-hup
sed -i 's/DAEMON=\/usr\/local\/bin\/cfn-hup/DAEMON=\/opt\/aws\/bin\/cfn-hup/g' /etc/init.d/cfn-hup
update-rc.d cfn-hup defaults
/opt/aws/bin/cfn-init -s ${AWS::StackId} --resource ${resource_name} --region ${aws_region} || error_exit 'Failed to run cfn-init'
wget https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py
python awslogs-agent-setup.py -n -r ${aws_region} -c /tmp/aws-logs.conf || error_exit 'Failed to run CloudWatch Logs agent setup'
systemctl start awslogs.service && systemctl enable awslogs.service || error_exit 'Failed to start CloudWatch Logs agent'
apt-get upgrade -y
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get install -y ansible
/opt/aws/bin/cfn-signal -e 0 --stack ${AWS::StackName} --resource ${resource_name} --region ${aws_region}
