import boto3
import os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    instance_id = os.getenv('INSTANCE_ID')
    
    if not instance_id:
        return "Instance ID not set in environment variables."

    response = ec2.describe_instances(InstanceIds=[instance_id])
    state = response['Reservations'][0]['Instances'][0]['State']['Name']
    
    if state == 'stopped':
        ec2.start_instances(InstanceIds=[instance_id])
        return f"Started instance: {instance_id}"
    elif state == 'running':
        ec2.stop_instances(InstanceIds=[instance_id])
        return f"Stopped instance: {instance_id}"
    else:
        return f"Instance {instance_id} is in state {state}, no action taken."
