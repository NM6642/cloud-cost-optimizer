import json
import boto3

ec2 = boto3.client('ec2', region_name='eu-north-1')

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event))
    
    instance_id = "use your EC2 instance id  here :)"
    
    try:
        response = ec2.stop_instances(InstanceIds=[instance_id])
        print(f"Stopping instance {instance_id}: {response}")
        return {
            'statusCode': 200,
            'body': json.dumps(f"Stopped instance {instance_id}")
        }
    except Exception as e:
        print("Error stopping instance:", e)
        raise e
