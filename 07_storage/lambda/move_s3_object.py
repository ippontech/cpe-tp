import boto3

def lambda_handler(event, context):
    s3 = boto3.resource('s3')
    print(event)
    print("Hello world!")
