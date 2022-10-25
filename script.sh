#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt autoremove --purge
sudo apt autoclean
sudo apt install nginx unzip php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip php-fpm php-mysql -y
sudo wget https://wordpress.org/latest.zip
sudo unzip latest.zip
cd wordpress/
sudo cp -r * /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
cd /etc/nginx/sites-enabled/
sudo wget https://github.com/aarshsqaureops/nginx-configuration/archive/refs/heads/main.zip
sudo unzip main.zip
sudo mv nginx-configuration-main/wordpress /etc/nginx/sites-enabled/
sudo systemctl reload php7.4-fpm.service
sudo rm -rf default main.zip nginx-configuration-main/
sudo systemctl reload nginx
cd ~
sudo wget https://s3.us-east-2.amazonaws.com/amazoncloudwatch-agent-us-east-2/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
sudo apt install -y awscli
aws configure import --csv file://home/rachit/Downloads/rachit-squareops-dev_accessKeys.csv
aws ssm send-command --document-name "AmazonCloudWatch-ManageAgent" --document-version "8" --targets '[{"Key":"InstanceIds","Values":["i-077c4316ce14f8bf7","i-0b9d7c22d22df683b"]}]' --parameters '{"action":["configure"],"mode":["ec2"],"optionalConfigurationSource":["ssm"],"optionalConfigurationLocation":["AmazonCloudWatch-linux-rachit"],"optionalOpenTelemetryCollectorConfigurationSource":["ssm"],"optionalOpenTelemetryCollectorConfigurationLocation":[""],"optionalRestart":["yes"]}' --timeout-seconds 600 --max-concurrency "50" --max-errors "0" --region us-east-2
