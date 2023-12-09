import boto3
import json
import urllib.parse

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    # print("Received event: " + json.dumps(event, indent=2))

    # Get the object from the event and show its content type
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    try:
        response = s3_client.get_object(Bucket=bucket, Key=key)
        returnValue = {
            "content_type": response['ContentType'],
            "metadata": response['Metadata'],
            "last_modified": response['LastModified'].isoformat(),
            "size": response['ContentLength'] / 1024
        }
        print("summary: ", returnValue)
        return returnValue
    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
        raise e