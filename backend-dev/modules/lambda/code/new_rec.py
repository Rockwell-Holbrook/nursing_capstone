import boto3
import json
import os
from datetime import date
import logging
import uuid
from boto3.dynamodb.conditions import Key

# Time
TODAY = date.today()

# Loggin
LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

# AWS
DYNAMODB = boto3.resource('dynamodb')
S3 = boto3.client('s3',
                  config=boto3.session.Config(signature_version='s3v4'))

# Initialize DynamoDB tables
PAT_DB = DYNAMODB.Table(os.environ['PATS_DB_NAME'])
REC_DB = DYNAMODB.Table(os.environ['RECS_DB_NAME'])


def validate_call(event_path, event_body):
    """ Check if all the parameters are given from API call
    
    Args:
        event (dict): incoming event from API
        context (dict): info about incoming event from AWS
    """

    if 'pat_id' not in event_path or 'created_by' not in event_body or 'location' not in event_body:
        LOGGER.error("Patient ID, Created By, or Location Not Given")
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
        ClientMethod='put_object',
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
    event_body = json.loads(event['body'])

    if not validate_call(event_path, event_body):
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

    # Recording Info
    rec_id = str(uuid.uuid1())
    recording_modified = TODAY.strftime("%d/%m/%Y")
    pre_url = get_rec_url(rec_id)

    # Get Patient Info
    pat = PAT_DB.query(
        KeyConditionExpression=Key('id').eq(event_path['pat_id'])
    )

    if pat['Count'] == 0:
        body = {
            "error": "No patient matches id given",
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
    
    recording = {
        "id": rec_id,
        "url": pre_url,
        "location": event_body['location'],
        "date_modified": recording_modified,
        "created_by": event_body['created_by']
    }

    # Add Recording to database
    REC_DB.update_item(
        Key={'id': rec_id},
        UpdateExpression=(
            'SET date_modified=:set_date_modified,'
            +'created_by=:set_created_by,'
            +'heart_location=:set_heart_location'
        ),
        ExpressionAttributeValues={
            ':set_date_modified': recording_modified,
            ':set_created_by': str(event_body['created_by']),
            ':set_heart_location': int(event_body['location'])
        }
    )

    # Append Recording to Patient
    PAT_DB.update_item(
        Key={'id': event_path['pat_id']},
        UpdateExpression=(
            'SET recordings=list_append(recordings, :set_recording_id),'
            +'date_modified=:set_date_modified'
        ),
        ExpressionAttributeValues={
            ':set_date_modified': recording_modified,
            ':set_recording_id': [rec_id]
        }
    )

    response = {
    "isBase64Encoded": False,
    "statusCode": 200,
    "headers": {},
    "body": json.dumps(recording)
}

    return response