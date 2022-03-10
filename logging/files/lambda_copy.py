################WORKING CODE FOR SNS TOPIC ######################################
##################################################################################
import os
import urllib
import boto3
import json
print('Loading function')

def lambda_handler(event, context):
    s3 = boto3.client('s3')

    target_bucket = os.environ['destination_bucket']
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key'] #.decode('utf8')

    print('Copying %s from bucket %s to bucket %s ' % (key, source_bucket, target_bucket))

    copy_source = {'Bucket':source_bucket, 'Key':key}
    s3.copy_object(Bucket=target_bucket, Key=key,  ServerSideEncryption='AES256', CopySource=copy_source)

    print('Replication Complete!')


    return {
        'statusCode': 200,
        'body': json.dumps('Copy OK')
    }
###################################################################################