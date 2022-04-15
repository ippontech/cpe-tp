# cpe-terraform

Terraform repository for CPE classes

## Introduction

For all modules below, here are the first steps:
1) Start the sandbox environment (and not a Lab environment).
2) Create an AWS Cloud9 environment from the AWS Console with a `t3.small` instance type.
3) Change the network settings to target a subnet in the AZ a in region us-east-1.
4) Once in the Cloud9 environment, you can checkout the code:
```bash
git clone https://github.com/taufort/cpe-terraform.git
```

## Module 4 - AWS Cloud Security

1) After you have cloned the git repository, you can go into the module:
```bash
cd cpe-terraform/04_cloud_security/
```
2) And start working with Terraform:
```bash
# Init the Terraform layer and download required providers
terraform init

# Take a look at what Terraform will do on AWS
terraform plan

# Create/update resources on AWS
terraform apply
```
3) Go look into the AWS Console that an SNS topic was created after you ran `terraform apply`. 
4) Try to update the "Display name" through the AWS console and re-run `terraform apply` afterwards and see what
happens.
5) Check that you can send a message into the topic with the "Publish message" button in the console.
6) Take a look in the AWS console at the generated SNS policy in the "Access policy" tab. This policy 
was auto-generated and does not respect least privilege at the moment.
7) Now, you need to add an SNS policy on that topic with some Terraform code in `sns.tf` file to block the 
IAM role `voclabs` from publishing any SNS message in the topic. The `voclabs` IAM role is the role you
are assuming when you are using the AWS Console.
8) Once the policy has been modified with Terraform. Check that you cannot publish anymore an event in the topic
through the AWS console.
9) Once you have succeeded the previous steps, authorize the `voclabs` role to publish messages but block
every other IAM user/role from doing so (always with Terraform). Check that you can now publish again a message
into the topic.
10) Activate the encryption on the SNS topic with KMS (and Terraform) to respect the security pillars of AWS. 

### Module 4 - AWS Cloud Security - Solution

You'll find two solutions for this module:
* The first solution is to use an inlined JSON AWS IAM policy in the `aws_sns_topic` resource directly. This solution
works fine but is not very easy to maintain because you're manipulating JSON directly. This solution can be found
in `04_cloud_security/solution_1` directory.
* The second solution is to use the `aws_iam_policy_document` datasource instead on an inline IAM policy. This solution 
is more user-friendly because you do not have to manipulate JSON directly (the JSON is generated thanks
to the `aws_iam_policy_document` datasource). This solution can be found in `04_cloud_security/solution_2` directory.
* The third solution is to use the `aws_sns_topic_policy` resource and the `aws_iam_policy_document` datasource. 
This solution can be found in `04_cloud_security/solution_3` directory. 

### Go further

Terraform offers other useful commands such as:
 * `terraform state` to look into the state of your infrastructure (to read it or to update it for instance).
 * `terraform import` to include an already existing resource into the state.
 * `terraform destroy` to destroy the infrastructure you created.
 * ...

Check out the Terraform documentation and try out a few of these commands to get used to using Terraform. 

In this Terraform code example, we are using a Terraform local backend, which is not a good practice for
production. When working with AWS, it's strongly recommended to use 
the [S3 backend](https://www.terraform.io/language/settings/backends/s3). Try to set it up in place of the local
backend.

## Module 5 - Networking

1) After you have cloned the git repository, you can go into the module:
```bash
cd cpe-terraform/05_networking/
```

2) And start working with Terraform:
```bash
terraform init
terraform apply
```

3) Go look into the AWS Console for the new resources that have just been created:
* a VPC named `05_networking-vpc` with CIDR block `10.1.0.0/21`;
* an Internet gateway `05_networking-internet-gateway`;
* 2 route tables: one public and one private;
* Check the public route table: there should be one route towards the internet gateway. That route will help us later
to make public subnets.

4) Now, it's your turn to work! You will have to first create 2 subnets within the newly created VPC:
* 1 public subnet with CIDR `10.1.0.0/24`;
* 1 private subnet with CIDR `10.1.4.0/24`.
Both subnets should be created in the Availability zone A. Beware, public subnets should have `map_public_ip_on_launch`
parameter set to `true` so that instances started in these subnets get a public IP. You can check `aws_subnet`
resource in [Terraform documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet).

5) Once the subnets are created, you will have to associate them to the Route tables to allow internet access. 
If not, when you start an instance, you won't be able to access internet resources.
Use `aws_route_table_association` resources to associate the public subnet to the public route table and the private
subnet to the private route table.

6) Now we have 2 subnets, in the AZ a: one public and one private. But it's not highly available at the moment. If the AZ a
fails, our applications deployed in those subnets would not be able to recover. Let's now create 4 new
subnets:
* 2 new public subnets in AZ b and AZ c;
* 2 new private subnets in AZ b and AZ c as well.
Each of these subnets should have 256 IP addresses each. The public subnets IP addresses should be within the 
`10.1.0.0/22` CIDR block and the private subnets should be within the `10.1.4.0/22` CIDR block.

> Note: a `/22` contains 1,024 IP addresses. You can use this [IP address website](https://www.ipaddressguide.com/cidr) 
to help you set up your subnet's CIDR blocks.

7) (optional) Start an EC2 instance manually inside the AWS Console assigned to one of your public subnets. 
Try to connect through SSH to this instance and verify that you can access the internet with the help of the curl program. 
You can check that `curl http://ifconfig.io` returns the public IP address of your EC2 instance.

## Module 6 - Compute

> All resources in this lab should be created with Terraform!

1) After you have cloned the git repository, you can go into the module:
```bash
cd cpe-terraform/06_compute/
```

2) And start working with Terraform to initialize the VPC resources (VPC / subnets / Internet gateway / Route tables / NAT...):
```bash
terraform init
terraform apply
```

3) Go look into the AWS Console for the new resources that have just been created:
* a VPC named `06_compute-vpc` with CIDR block `10.1.0.0/21`;
* 6 subnets: 3 public and 3 private in 3 different AZ; 
* an Internet gateway `06_compute-internet-gateway`;
* 2 route tables, one public and one private:
    * the public one contains a route towards the internet gateway to access the internet;
    * the private one contains a route towards the NAT gateway.

4) Take a look at the `ec2.tf` file. It currently contains 2 datasources which are already existing resources on the 
AWS account you are using:
* an `aws_ami` datasource named `amazon_linux_2_ami` which we will use as a base machine image to start an EC2 instance.
This AMI will retrieve the most recent Amazon Linux 2 AMI provided by Amazon with a 64 bits architecture and it will
use a GP2 SSD as a hard drive.
* an `aws_iam_instance_profile` datasource named `ssm_instance_profile` which we will use to provide IAM rights to the
EC2 instance you will create afterwards. This instance profile is provided by Amazon lab and contains, among others, 
some IAM rights so that you can access a terminal on your EC2 instance thanks an AWS service called AWS Systems Manager.

5) Now, you must create an EC2 instance with an `instance_type` of `t3.small` in one of the public subnets provided 
for you in the code. This EC2 instance will be called `bastion`. We will use it for SSH access to your AWS resources. 
This instance will need to use the provided AMI (`amazon_linux_2_ami`) in the code as well as the IAM instance profile 
also provided (`ssm_instance_profile`). To create an EC2 instance through Terraform, you can use `aws_instance` resource. 
Take a look at the [Terraform doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)

6) When the instance has been created, you should be able to access it through AWS Systems Manager in the AWS UI.
Go to the [EC2 AWS console](https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1#Instances:), right 
click on the instance and choose "Connect". This will bring you to a new "Connect to instance" page, here choose
"Session Manager" and then click on "Connect". This will bring you to a browser shell terminal. Check that
`curl http://ifconfig.io` returns the public IP address of your EC2 instance. You can then disconnect from the EC2
 instance with your browser.

7) Create an SSH key pair on the Cloud9 instance (and not the bastion instance previously accessed through AWS System
 Manager) by using the following command:
```bash
ssh-keygen -f bastion_cpe_key 
```
When asked to enter a passphrase, leave it empty.

8) Now that you have an SSH key pair, you can import the public key into AWS with `aws_key_pair` resource. You will have
to fill in a `key_name` and the `public_key` with the content of the file `bastion_cpe_key.pub` created in step 7.

9) Now that you have created the `aws_key_pair`, you must associate it to your `aws_instance` with the argument
`key_name`.

10) In `ec2.tf`, there is an already existing `aws_security_group` allowing all outgoing traffic. 
You must edit that security group to allow SSH access on tcp port 22 with an ingress rule.
Check out the [documentation if needed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group).

11) Now, you can use this security group in your `aws_instance` with the argument `vpc_security_group_ids`
which is an array.

12) To connect through SSH to your instance, we'll use the AWS CLI to retrieve the EC2 instance public IP address and
then SSH into the instance:
```bash
export BASTION_IP=$(aws --region us-east-1 ec2 describe-instances \
    --filters \
    "Name=instance-state-name,Values=running" \
    "Name=tag:project,Values=06_compute" \
    --query 'Reservations[*].Instances[*].[PublicIpAddress]' \
    --output text)
ssh -i bastion_cpe_key ec2-user@${BASTION_IP}
```

13) (optional) Create another EC2 instance (with Terraform of course) named `web-server` in one of the private
subnets. Use the argument `user_data` to install httpd Apache web server inside the EC2 instance when it boots for the
first time. Create a Security Group to allow ingress on TCP port 80 (HTTP port). Use SSH on the bastion instance you
created earlier with the `-L` option to create a secured SSH tunnel to access your web-server EC2 instance from Cloud9.

To be able to access the HTTPD server on your private instance from Cloud9, you can do:
```bash
ssh -i bastion_cpe_key ec2-user@${BASTION_IP} -L 8080:${PRIVATE_WEB_SERVER_IP}:80
```

In Cloud9, you should now be able to access the HTTPD home page by clicking on "Preview" then "Preview Running 
Application" at the top of your screen.

## Module 6 - Container services

1) After you have cloned the git repository, you can go into the module:
```bash
cd cpe-terraform/06_container/
```

2) You have been provided a file named `Dockerfile` which describes what you will install in your Docker image. A
Dockerfile usually starts with a `FROM` directive to indicate from which other Docker image you inherit. Here, 
we inherit from the Docker image `nginx` and we use the tag `latest` which represents the version of the image you
want to use.

3) Build your Docker image with the following command in your Cloud9 terminal:
```bash
docker build -t nginx-cpe:latest .
```

4) Search for documentation on [Docker website](https://docs.docker.com/engine/reference/commandline/run/) on how
you can start your freshly built Docker image and redirects the nginx server (which started on port 80) to port 
8080 of your Cloud9 instance.

5) Use the preview feature of Cloud9, you should see the nginx welcome page appear.

6) Create an `index.html` file next to your Dockerfile with whatever you want inside, it can be an HTML hello world 
message for instance or something else.

7) Use the `ADD` or `COPY` directives in the Dockerfile to add the `index.html` into your Docker image so that it
can be exposed by nginx (look in the [Docker documentation](https://docs.docker.com/engine/reference/builder/#add)). 
You will have to put the `index.html` in `/usr/share/nginx/html` in your Docker image so that it can be used by nginx
server.

8) Rebuild your docker image after saving your files and rerun the new Docker image with a `docker run` command.
Click on the Cloud9 "Preview running application" button up top and check that your `index.html` is now exposed
on the nginx server.

10) (optional) Follow this NodeJS guide to have a dynamic application: https://nodejs.org/en/docs/guides/nodejs-docker-webapp/


## Module 7  - Storage

The purpose of this module is to:
* Put a file into a first S3 bucket;
* Trigger an AWS lambda when a file is put into that first S3 bucket. The Lambda will then copy the file from
the first S3 bucket into a second S3 bucket. Once this is done, the file in the first bucket should be deleted;
* Finally, be notified through an email with AWS SNS that the file was moved from the first S3 bucket to
the second S3 bucket.

> AWS SNS is a notification service that can be used to send email notifications for instance.

1) After you have cloned the git repository, you can go into the module:
```bash
cd cpe-terraform/07_storage/
```

2) Unfortunately, you won't be able to use Terraform to create an S3 bucket because of IAM restrictions on
   the sandbox environment.
   You first need to create two S3 buckets through the AWS console directly. To do so,
   go to: https://s3.console.aws.amazon.com/s3/get-started?region=us-east-1.
   The bucket names must be unique worldwide, so be sure to choose a unique name (you can use your name, the
   current date, etc...).

For instance, your buckets could be called:
* `taufort-06042022-source`
* `taufort-06042022-target`

From now on, let's call the first bucket the `source` bucket and the second bucket the `target` bucket.

Once your buckets are created, be sure to update the content of `bucket_source` and `bucket_target` variables
in `07_storage/variables.tf`.

3) Now you should be able to start working with Terraform:
```bash
# Init the Terraform layer and download required providers
terraform init

# Take a look at what Terraform will do on AWS
terraform plan

# Create/update resources on AWS
terraform apply
```

4) You have been provided a Python Hello World lambda in `lambda.tf` file. The first thing you need to do is to 
trigger that lambda when an object is uploaded in your source bucket. For that, you now need to:
* Create an `aws_s3_bucket_notification` on your source bucket (https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification)
* Create a `aws_lambda_permission` to authorize the AWS S3 service to invoke your lambda.

Once this is done, you should be able to verify that your lambda is indeed triggered when you put an object
into your source bucket. You can find the logs of your Lambda in [AWS CloudWatch](https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#logsV2:log-groups/log-group/$252Faws$252Flambda$252Fmove-s3-object-07_storage)

> You can trigger your lambda manually from the AWS console directly in the 'Test' tab when you click on the 'Test'
button (go see https://us-east-1.console.aws.amazon.com/lambda/home?region=us-east-1#/functions/move-s3-object-07_storage?tab=testing)

5) Now you must modify your lambda Python code to copy the object put in the source bucket to the target bucket.
You can edit the Python code in the python script provided in the code (see `07_storage/lambda/move_s3_object.py` file)
and then use `terraform apply` to deploy the new version of your Python code.

As the previous method is not ideal for tests, you can also directly edit the python code in the AWS console 
to test your modifications more rapidly (the use of Terraform can be cumbersome for that). 
For that, go edit the code here: https://us-east-1.console.aws.amazon.com/lambda/home?region=us-east-1#/functions/move-s3-object-07_storage?tab=code
Once the code has been edited, you can click on the 'Deploy' button and then go to the 'Test' tab to retest the new 
version of the code of your Lambda.

Take a look closer to the logs of your lambda, you will see that an S3 JSON event is logged. It has the following form:
`{'Records':.....}`.
This event contains the name of the object that you put into the source bucket. You'll need to use that event to retrieve
the object's name to be able to copy it to the target bucket.

To copy an S3 object from one bucket to another, you will need to use the Python boto3 library. The S3 boto3 service
is documented here: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#bucket

6) Once you have successfully copied the file from the source bucket to the target bucket, you need to delete
the original file from the source bucket. We do not want to pay for the old file stored in the source bucket.

7) You now must send an event to the SNS topic provided in `sns.tf`. To do so, you have several solutions:
* You can use `aws_s3_bucket_notification` on the target bucket to trigger a notification to the SNS topic
when an object is created in the target bucket. You will also need to update the `policy` of the `aws_sns_topic`
to authorize S3 to send notifications to that topic (you can find an example in [Terraform documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification))
* You can also send the notification to the SNS topic from the Python code of your lambda. For that, you will need
to use the SNS service in boto3 (see https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sns.html)

8) To receive an email notification from the SNS topic, you need to manually create a subscription in the AWS 
console with the "Create subscription" button: https://us-east-1.console.aws.amazon.com/sns/v3/home?region=us-east-1#/topic/arn:aws:sns:us-east-1:722738513845:s3-notification-07_storage.
You can then choose the protocol of the subscription and enter your personal email address to receive an email.

Once this is done, check that you can now receive an email and that the whole chain works!

## Module 8 - Databases

The purpose of this module is to create a public EC2 instance exposing an HTTP server that will use a RDS PostgreSQL
instance.

1) After you have cloned the git repository, you can go into the module:
```bash
cd cpe-terraform/08_databases/
```

2) You can apply the Terraform code to create the base resources:
```bash
terraform init
terraform apply
```

3) You will now have to create a DB subnet group for your future RDS instance. A DB subnet group must define in which
subnets your RDS instance will be deployed. Your future RDS instance should be private of course. We do not want to
expose it on the internet. 
Take a look at file `rds.tf`. There is a `aws_db_subnet_group` resource in there, the code block is commented, 
you can uncomment it and you will have to complete it.

4) In this step, you will have to define a Security Group for your RDS instance. Check out the `rds.tf` file, you
will find a `aws_security_group` resource predefined for you. Uncomment it and complete it.

5) You must now create your PostgreSQL RDS instance. It was predefined in `rds.tf` with some predefined arguments
that you can keep but you will have to add some missing ones. You'll need at least to add:
* the DB subnet group created in a previous step
* the Security group created a bit before
* a name for your PostgreSQL database
* a username/password couple to access this database

6) In this step, you will have to define a Security Group for the EC2 instance that will access your RDS instance 
a bit later. Check out the `ec2.tf` file, you will find a `aws_security_group` resource predefined for you. 
Uncomment it and complete it.

7) In this step, you will create an EC2 instance in which we will deploy a Java HTTP server.
Check out the `ec2.tf` file, you will find a `aws_instance` resource predefined for you.
Uncomment it and complete it.

The `user_data` argument uses a built-in Terraform function called `templatefile` which takes a local file name
as a first argument and then a list of variables. You must pass the right variables to the templated shell script
to be able to properly start your Java HTTP server.
Check out the documentation if needed: https://www.terraform.io/language/functions/templatefile.

8) If you have not made any mistake before, you should be able to access your public EC2 instance from the internet
in a browser with such an URL (find yours in the AWS console): http://ec2-54-209-130-246.compute-1.amazonaws.com/

9) Look into your JHipster application UI for a way to interact with your RDS database. If you need to login, use
the following user/password couple: `admin/admin`.
You can interact with the RDS database through the entity screen or through the Swagger API. You should be able to
find a table called 'Student' and to insert entities in this table.

10) (optional) Log into your instance with AWS SSM from the AWS Console and find the Cloud init log file to see what
    was done by the `cloud_init.sh.tpl` file at the start of the instance.
