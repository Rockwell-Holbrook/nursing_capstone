import boto3
import json
import os
import logging
from datetime import date
from boto3.dynamodb.conditions import Key

# Loggin
LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

# Time
TODAY = date.today()

# AWS
DYNAMODB = boto3.resource('dynamodb')

# Initialize DynamoDB tables
PAT_DB = DYNAMODB.Table(os.environ['PATS_DB_NAME'])


def validate_call(event_path):
    """ Check if all the parameters are given from API call
    
    Args:
        event (dict): incoming event from API
        context (dict): info about incoming event from AWS
    """

    if 'pat_id' not in event_path:
        LOGGER.error("Patient ID Not Given")
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
    event_body = json.loads(event['body'])

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

    pat_id = event_path['pat_id']
    pat_modified = TODAY.strftime("%d/%m/%Y")

    # Get Patient Info
    pat = PAT_DB.query(
        KeyConditionExpression=Key('id').eq(pat_id)
    )

    if pat['Count'] == 0:
        body = {
            "error": "No patient matches id given",
            "id": pat_id
        }
        # Create response Body
        response = {
            "isBase64Encoded": False,
            "statusCode": 404,
            "headers": {},
            "body": json.dumps(body)
        }

        return response
    
    created_by = str(pat['Items'][0]['created_by'])
    tags = pat['Items'][0]['tags']
    abnormal = pat['Items'][0]['abnormal']

    # Check for Updates
    if 'tags' in event_body['patient']:
        tags = event_body['patient']['tags']

    if 'created_by' in event_body['patient']:
        created_by = event_body['patient']['created_by']

    if 'abnormal' in event_body['patient']:
        abnormal = event_body['patient']['abnormal']
    
    patient = {
        "id": pat_id,
        "recordings": pat['Items'][0]['recordings'],
        "date_modified": pat_modified,
        "created_by": created_by,
        "tags": tags,
        "abnormal": abnormal
    }
    
    # Add Item to database
    PAT_DB.update_item(
        Key={'id': pat_id},
        UpdateExpression=(
            'SET tags=:set_tags,'
            +'date_modified=:set_date_modified,'
            +'created_by=:set_created_by,'
            +'abnormal=:set_abnormal'
        ),
        ExpressionAttributeValues={
            ':set_tags': tags,
            ':set_date_modified': pat_modified,
            ':set_created_by': created_by,
            ':set_abnormal': abnormal
        }
    )

    response = {
    "isBase64Encoded": False,
    "statusCode": 200,
    "headers": {},
    "body": json.dumps(patient)
}

    return response