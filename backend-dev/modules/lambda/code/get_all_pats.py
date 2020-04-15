import boto3
import json
import os
import logging
from boto3.dynamodb.conditions import Key, Attr

# Loggin
LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

# AWS
DYNAMODB = boto3.client('dynamodb')
S3 = boto3.client('s3')


def lambda_handler(event,context):
    """ Main Function
    Args:
        event (dict): incoming event from API
        context (dict): info about incoming event from AWS
    """
    LOGGER.info(event)

    # Event Parsing
    event_query = event['queryStringParameters']
    event_query_list = event['multiValueQueryStringParameters']
    
    # Intialize filters
    next_token = None
    query_list = []
    query_values = {}
    

    # Check for Filters
    if event_query_list is not None:
        if 'tags' in event_query_list:
            query_list.append("tags=:set_tags")
            query_values[':set_tags'] = {"L" : []}
            for tag in event_query_list['tags']:
                query_values[':set_tags']['L'].append({"S": tag})
    
        if 'created_by' in event_query:
            query_list.append("created_by=:set_created_by")
            query_values[':set_created_by'] = { "S" : event_query['created_by']}
    
        if 'abnormal' in event_query:
            query_list.append("abnormal=:set_abnormal")
            query_values[':set_abnormal'] = { "S" : event_query['abnormal']}
        
        if 'date_modified' in event_query:
            query_list.append("date_modified=:set_date_modified")
            query_values[':set_date_modified'] = { "S" : event_query['date_modified']}
    
        if 'next_token' in event_query:
            next_token = event_query['next_token']

    if next_token is None:
        if not query_list:
            # Get Patient Info
            pats = DYNAMODB.scan(
                TableName=os.environ['PATS_DB_NAME']
            )
        else:
            # Get Patient Info
            pats = DYNAMODB.scan(
                TableName=os.environ['PATS_DB_NAME'],
                FilterExpression=" AND ".join(query_list),
                ExpressionAttributeValues = query_values
            )
    else:
        if not query_list:
            # Get Patient Info
            pats = DYNAMODB.scan(
                TableName=os.environ['PATS_DB_NAME'],
                ExclusiveStartKey={
                    'id': {
                        "S": next_token
                    }
                }
            )
        else:
            # Get Patient Info
            pats = DYNAMODB.scan(
                TableName=os.environ['PATS_DB_NAME'],
                FilterExpression=" AND ".join(query_list),
                ExpressionAttributeValues = query_values,
                ExclusiveStartKey={
                    'id': {
                        "S": next_token
                    }
                }
            )

    if pats['Count'] == 0:
        body = {
            "error": "No patient matches filter given"
        }
        # Create response Body
        response = {
            "isBase64Encoded": False,
            "statusCode": 404,
            "headers": {},
            "body": json.dumps(body)
        }

        return response
    next_token = ""
    if 'LastEvaluatedKey' in pats:
        next_token = pats['LastEvaluatedKey']['id']['S']
    response_body = {
        "next_token": next_token,
        "patients" : []
    }
    
    
    for pat in pats['Items']:
        patient = {
            "id": pat['id']['S'],
            "date_modified": pat['date_modified']['S'],
            "created_by": pat['created_by']['S'],
            "tags": [],
            "abnormal": pat['abnormal']['S']
        }
        for tag in pat['tags']['L']:
            patient['tags'].append(tag['S'])
        response_body['patients'].append(patient)

    response = {
    "isBase64Encoded": False,
    "statusCode": 200,
    "headers": {},
    "body": json.dumps(response_body)
}

    return response