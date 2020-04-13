import boto3
import json
import os
import logging
from boto3.dynamodb.conditions import Key

# Loggin
LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

# AWS
DYNAMODB = boto3.resource('dynamodb')
S3 = boto3.client('s3')

# Initialize DynamoDB tables
REC_DB = DYNAMODB.Table(os.environ['RECS_DB_NAME'])


def validate_call(event_path):
    """ Check if all the parameters are given from API call
    
    Args:
        event (dict): incoming event from API
        context (dict): info about incoming event from AWS
    """

    if 'rec_id' not in event_path:
        LOGGER.error("Recording ID Not Given")
        return False
    
    return True

def get_rec_url(rec_id):
    """ Retrieve a presigned URL (Valid for 1 hour) for a recording
    Args:
        rec_id: Recording UUID

    Returns:
        url: presigned URL for the recording
    """
    ### Presigned URL
    url = S3.generate_presigned_url(
        ClientMethod='get_object',
        Params={
            'Bucket': os.environ['S3_NAME'],
            'Key': rec_id + ".wav"
        },
        ExpiresIn=3600  # One Hour
    )

    return url


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
    rec = REC_DB.query(
        KeyConditionExpression=Key('id').eq(event_path['rec_id'])
    )

    if rec['Count'] == 0:
        body = {
            "error": "No recording matches id given",
            "id": event_path['rec_id']
        }
        # Create response Body
        response = {
            "isBase64Encoded": False,
            "statusCode": 404,
            "headers": {},
            "body": json.dumps(body)
        }

        return response

    # Create presigned URL
    pre_url = get_rec_url(event_path['rec_id'])
    
    recording = {
        "id": rec['Items'][0]['id'],
        "url": pre_url,
        "date_modified": rec['Items'][0]['date_modified'],
        "created_by": rec['Items'][0]['created_by'],
        "location": int(rec['Items'][0]['heart_location'])
    }

    response = {
    "isBase64Encoded": False,
    "statusCode": 200,
    "headers": {},
    "body": json.dumps(recording)
}

    return response