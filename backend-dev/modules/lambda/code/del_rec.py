import boto3
import json
import logging
import os
from boto3.dynamodb.conditions import Key

# Loggin
LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

# AWS
DYNAMODB = boto3.resource('dynamodb')
S3 = boto3.client('s3')

# Initialize DynamoDB tables
PAT_DB = DYNAMODB.Table(os.environ['PATS_DB_NAME'])
REC_DB = DYNAMODB.Table(os.environ['RECS_DB_NAME'])

def validate_call(event_path):
    """ Check if all the parameters are given from API call
    
    Args:
        event (dict): incoming event from API
        context (dict): info about incoming event from AWS
    """

    if 'pat_id' not in event_path or 'rec_id' not in event_path:
        return False
    
    return True
        

def lambda_handler(event,context):
    """ Main Function
    Args:
        event (dict): incoming event from API
        context (dict): info about incoming event from AWS
    """
    LOGGER.info(event)
    event_path = event['pathParameters']

    if not validate_call(event_path):
        body = {
            "error": "Invalid data given in body."
        }
        # Create response Body
        response = {
            "isBase64Encoded": False,
            "statusCode": 409,
            "headers": {},
            "body": json.dumps(body)
        }

        return response

    # Get Patient Info
    pat = PAT_DB.query(
        KeyConditionExpression=Key('id').eq(event_path['pat_id'])
    )

    if pat['Count'] == 0:
        body = {
            "error": "Patient Not Found",
            "id": event_path['pat_id']
        }
        # Create response Body
        response = {
            "isBase64Encoded": False,
            "statusCode": 404,
            "headers": {},
            "body": json.dumps(body)
        }

        return response

    # Remove Patient Recordings
    rec_id = event_path['rec_id']
    # Remove from DB
    REC_DB.delete_item(
        Key={'id': rec_id}
    )
    # Remove from S3
    S3.delete_object(
        Bucket=os.environ['S3_NAME'],
        Key=rec_id + ".wav"
    )

    # Create new list of recordings without old recording
    if rec_id in pat['Items'][0]['recordings']:
        recordings = pat['Items'][0]['recordings'].remove(rec_id)
        if recordings is None:
            recordings = []
    else:
        recordings = pat['Items'][0]['recordings']

    # Remove Recording from Patient
    PAT_DB.update_item(
        Key={'id': event_path['pat_id']},
        UpdateExpression=(
            'SET recordings=:set_recordings'
        ),
        ExpressionAttributeValues={
            ':set_recordings': recordings
        }
    )

    # Create response Body
    response = {
        "isBase64Encoded": False,
        "statusCode": 200,
        "headers": {}
    }

    return response