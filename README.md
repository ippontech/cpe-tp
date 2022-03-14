# cpe-terraform

Terraform repository for CPE classes

## Module 4 - AWS Cloud Security

1) Start the sandbox environment (and not a Lab environment).
2) Create an AWS Cloud9 environment from the AWS Console.
3) Once in the Cloud9 environment, you can checkout the code:
```bash
git clone https://github.com/taufort/cpe-terraform.git
```
4) Then you can go into the module:
```bash
cd cpe-terraform/04_cloud_security/
```
5) and start working with Terraform:
```bash
# Init the Terraform layer and download required providers
terraform init

# Take a look at what Terraform will do on AWS
terraform plan

# Create/update resources on AWS
terraform apply
```
6) Go look into the AWS Console that an SNS topic was created after you ran `terraform apply`. 
7) Try to update the "Display name" through the AWS console and re-run `terraform apply` afterwards and see what
happens.
8) Check that you can send a message into the topic with the "Publish message" button in the console.
9) Take a look in the AWS console at the generated SNS policy in the "Access policy" tab. This policy 
was auto-generated and does not respect least privilege at the moment.
10) Now, you need to add an SNS policy on that topic with some Terraform code in `sns.tf` file to block the 
IAM role `voclabs` from publishing any SNS message in the topic. The `voclabs` IAM role is the role you
are assuming when you are using the AWS Console.
11) Once the policy has been modified with Terraform. Check that you cannot publish anymore an event in the topic
through the AWS console.
12) Once you have succeeded the previous steps, authorize the `voclabs` role to publish messages but block
every other IAM user/role from doing so (always with Terraform). Check that you can now publish again a message
into the topic.
13) Activate the encryption on the SNS topic with KMS (and Terraform) to respect the security pillars of AWS. 

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
