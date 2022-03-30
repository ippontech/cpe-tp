# cpe-terraform

Terraform repository for CPE classes

## Introduction

For all modules below, here are the first steps:
1) Start the sandbox environment (and not a Lab environment).
2) Create an AWS Cloud9 environment from the AWS Console with a `t3.small` instance type.
3) Once in the Cloud9 environment, you can checkout the code:
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
