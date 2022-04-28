import json
import os
import boto3
from datetime import datetime, timedelta
import time
from dateutil import tz
import dateutil.parser
import inspect

logs_client = boto3.client('logs')
sns_client = boto3.client('sns')
env = os.environ['ENVIRONMENT']
transfer_log_group = os.environ['TRANSFER_LOG_GROUP']
topic_arn = os.environ['TOPIC_ARN']
est = tz.gettz('US/Eastern')
utc = tz.gettz('UTC')
date_format = "%Y-%m-%d %H:%M:%S %Z"


def lambda_handler(event, context):
    print(event)
    end_datetime = datetime.now()
    if 'params' in event and 'time' in event['params']:
        #end_datetime = datetime.strptime(event['params']['time'], "%Y-%m-%dT%H:%M:%SZ")
        end_datetime = dateutil.parser.parse(event['params']['time'])
        end_datetime = end_datetime.replace(tzinfo=utc)

    est_end_datetime = end_datetime.astimezone(est)
    message_day = est_end_datetime.strftime(date_format)

    # print(f'end_datetime {end_datetime.strftime(date_format}')
    print(f'message_day {message_day}')

    query = inspect.cleandoc(f'''
        filter @message like "OPEN"
        | parse @message "*.* OPEN Path=* Mode=*" as account, sessionID, path, mode
        | fields @timestamp, replace(replace(replace(mode, "CREATE|EXCLUSIVE|TRUNCATE|WRITE", "inbound"), "CREATE|TRUNCATE|WRITE", "inbound"), "READ", "outbound") as direction
        | sort @timestamp desc
        | stats count(*) as count by account, direction, bin(24hr) as day'''
                             )

    print(query)

    start_query_response = logs_client.start_query(
        logGroupName=transfer_log_group,
        startTime=int((end_datetime - timedelta(hours=24*1)).timestamp()),
        endTime=int(end_datetime.timestamp()),
        queryString=query,
    )

    query_id = start_query_response['queryId']

    response = None

    while response == None or response['status'] == 'Running':
        print('Waiting for query to complete ...')
        time.sleep(1)
        response = logs_client.get_query_results(
            queryId=query_id
        )

    # print(response['results'])

    records = {}

    for row in response['results']:
        record = {}
        account = ""
        direction = ""
        count = 0
        day = ""
        for col in row:
            if col['field'] == 'account':
                record[col['field']] = col['value']
                account = col['value']
            elif col['field'] == 'direction':
                direction = col['value']
            elif col['field'] == 'day':
                day = col['value']
            #    record[col['field']] = col['value']
            #    if message_day == "": message_day = col['value']
            elif col['field'] == 'count':
                count = col['value']
        if direction == 'inbound':
            record['inbound'] = count
        elif direction == 'outbound':
            record['outbound'] = count
        key = f'{record["account"]}:{day}'
        if key not in records:
            records[key] = record
        else:
            records[key].update(record)

    message = {
        #'timestamp': message_day,
        'period': '24 hours',
        'stats': list(records.values())
    }

    print(message)

    if (len(records) > 0):
        response = sns_client.publish(
            TopicArn=topic_arn,
            Message=json.dumps({'default': json.dumps(message, indent=4),
                                'email': json.dumps(message, indent=4)}),
            Subject=f'{env}: Daily SFTP Server report for {message_day}',
            MessageStructure='json',
            MessageAttributes={
                'message_day': {
                    'DataType': 'String',
                    'StringValue': message_day
                }
            }
        )

    return True
