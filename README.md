<b>Readme</b> 

Step 1:Configure the IAM user in your computer using AWS-CLI command.

aws configure

this will ask you to enter the access key ,secret key and other details

AWS Access Key ID : enter access key
AWS Secret Access Key: secret key
Default region name : ap-south-1
Default output format [json]: json

I have created this project in such a way that we need to change only few variables in root directory of the project and it will deploy in any AWS account

1.if you need any specific instance type, change nginxinstance_instance_type variable

2.change key pair name by changing the key_pair_name variable

3.change vpc to your vpc id by changing the vpc_id variable

4.please change the subnet also by changing nginxinstance_subnet_id variable. Please try to give a public subnet id

The above given changes (1-4) has to done in the variable.tf in the project root directory

Once the changes are done, execute the below commands( Please make sure your IAM user  have enough permission to create the infrastructure for you )


terraform init
terraform plan
terraform apply


Now, server is up with docker installed

Step 2:Next is create a Repository in ECR

login to aws console, select ECR and click on create repository called "nginx-custom" make a note of repository URL we will use this in our jenkins pipeline


Step 3: create a sample web project 

This web project will be configured as the root folder in nginx. it will have the index.html, Dockerfile and Jenkinsfile

Docker file using the nginx image from docker hub and  copy the index.html to the image, this process will happen as part of the pipeline automatically during every commit

Changes to be made in Jenkinsfile for the smooth running of process

dev.host: give ip address of newly created instance
REPOSITORY_URI: change it with the repository we created 

in the withcredential section of jenkins file change the repository URI in both docker pull and docker run command



Step 4:Configure jenkins job 

install jenkins and install ssh and sshagent plugin

create github hook
create pipeline
  *choose pipeline from SCM
  *give repository url
  *give branch name
  *give filepath-in our case Jenkinsfile



Now, make any small change to the web project it will trigger the pipeline and deploy the changes in EC2 server














