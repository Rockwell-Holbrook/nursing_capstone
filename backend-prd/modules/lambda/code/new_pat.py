import boto3
import json
import logging
import os
import uuid
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

def validate_call(event_body):
    """ Check if all the parameters are given from API call
    
    Args:
        event (dict): incoming event from API
        context (dict): info about incoming event from AWS
    """

    if 'created_by' not in event_body:
        return False
    
    return True
        

def lambda_handler(event,context):
    """ Main Function
    Args:
        event (dict): incoming event from API
        context (dict): info about incoming event from AWS
    """
    LOGGER.info(event)
    event_body = json.loads(event['body'])

    if not validate_call(event_body):
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


    # Build User
    user_id = str(uuid.uuid1())
    user_modified = TODAY.strftime("%d/%m/%Y")

    user = {
                "id": user_id,
                "recordings": [],
                "date_modified": user_modified,
                "created_by": str(event_body['created_by']),
                "abnormal": "false",
                "tags": []
            }

    # Add Item to database
    PAT_DB.update_item(
        Key={'id': user_id},
        UpdateExpression=(
            'SET recordings=:set_recordings,'
            +'date_modified=:set_date_modified,'
            +'created_by=:set_created_by,'
            +'tags=:set_tags,'
            +'abnormal=:set_abnormal'
        ),
        ExpressionAttributeValues={
            ':set_recordings': [],
            ':set_date_modified': user_modified,
            ':set_created_by': str(event_body['created_by']),
            ':set_tags': [],
            ':set_abnormal': "false"
        }
    )

    # Create response Body
    response = {
        "isBase64Encoded": False,
        "statusCode": 200,
        "headers": {},
        "body": json.dumps(user)
    }

    return response