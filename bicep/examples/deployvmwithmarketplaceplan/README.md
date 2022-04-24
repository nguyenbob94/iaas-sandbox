# Deploy Ubuntu VM with Docker 

This Bicep template deploys a Ubuntu Server with Docker installed using an image by readymind on the Marketplace.

## Reprequesites

You must accept the terms of the image through Azure CLI before deploy a VM image that contains a plan. 

In this case `az vm image terms accept --publisher "readymind" --offer "ubuntults20_docker" --plan "Docker_Ubuntu20LTS1"`

## Limitations

MSDN Azure subscriptions (MDN) do not support deployments of marketplace resources with software plans. Attempting to deploy this template will get an error similar to this https://stackoverflow.com/questions/68624621/azure-cant-deploy-fortigate-from-arm-error-the-unknown-payment-instrument

## Contents in the bicep

Check the code comments.

## How to deploy this template,

Simply run the `deploy.ps1` PS script and let it do its magic.

## Post deployment configuration

Copy and pasted directly from the marketplace description

1. Login to your VM via ssh and run the following command to start with Docker: sudo docker version Optional configuration: 

2. If you want manage Docker as a non-root user: 
	2.1 To create the docker group and add your user: Create the docker group: sudo groupadd docker 
	2.2 Add your user to the docker group: sudo usermod -aG docker $USER 
	2.3 Log out and log back in so that your group membership is re-evaluated. For more information visit: https://docs.docker.com/engine/install/linux-postinstall/ How to use Portainer 

3. Login to your VM via ssh and run the following commands: sudo docker pull portainer/portainer-ce:latest sudo docker run -d -p 9000:9000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest 

4. Goto Network section of your VM and add inbound rule with the port 9000 and protocol TCP. 

5. Got to your browser and type your URL with the port: "http://your-vm-ip:9000" 

6. Create a admin user with password in the Portainer Web. The image contains the following software: * Docker Engine - Community Version: 20.10.12 API version: 1.41 * Ubuntu Server LTS 20.04 If you have any questions or need more information about the content of this Virtual Machine, please visit our website: http://readymindsitewp.azurewebsites.net/get-started/docker-ready