import os
import json
import boto3

env_name = os.environ['ENVIRONMENT']
fileSystemId = os.environ['FILE_SYSTEM_ID']
sftpServerId = os.environ['SFTP_SERVER_ID']
sftpServer = os.environ['SFTP_DNS']
basePath = os.environ['BASE_PATH']
localMountPath = os.environ['LOCAL_MOUNT_PATH']
exceptionSNSTopic = os.environ['EXCEPTION_SNS_TOPIC']
sns_client = boto3.client('sns')


def lambda_handler(event, context):
    # The requested SFTP Server Id must match the configured SFTP Server Id
    reqServerId = event['detail']['requestParameters']['serverId']
    userFullHomeDir = event['detail']['requestParameters'][
        'homeDirectoryMappings'][0]['target']
    username = event['detail']['requestParameters']['userName']

    #Try, send SNS, if failed
    try:
        validateRequest(reqServerId, userFullHomeDir)
    except Exception as ex:
        sendMessage(str(ex), username, 'FAILURE')
        return True

    homeDirToCreate = userFullHomeDir.replace(basePath, localMountPath)

    uid = str(event['detail']['requestParameters']['posixProfile']['uid'])
    gid = str(event['detail']['requestParameters']['posixProfile']['gid'])

    try:
        # Create home directory structure in EFS based on Transfer Family CreateUser event
        os.makedirs(f'{homeDirToCreate}/inbound', exist_ok=True)
        os.makedirs(f'{homeDirToCreate}/outbound', exist_ok=True)
        os.makedirs(f'{homeDirToCreate}/archive/inbound', exist_ok=True)
        os.makedirs(f'{homeDirToCreate}/archive/outbound', exist_ok=True)
        # Set appropriate permissions and ownership based on Transfer Family CreateUser event
        os.system(f'chmod -R 770 {homeDirToCreate}')
        os.system(f'chown -R {uid}:{gid} {homeDirToCreate}')
    except Exception as ex:
        sendMessage(
            f'There was a problem creating the home directory structure: {homeDirToCreate} for the request {userFullHomeDir}. Exception: {ex}',
            username, 'FAILURE')
    else:
        sendMessage(
            f'The home directory structure was created successfully: {homeDirToCreate} for the request {userFullHomeDir}',
            username, 'SUCCESS')

    return True


def validateRequest(reqServerId, userFullHomeDir):
    if (reqServerId != sftpServerId):
        raise Exception(
            f'SFTP Server mismatch. Received ServerId: {reqServerId} Expected ServerId: {sftpServerId}'
        )

    # aGet Home Directory from Transfer Family CreateUser event
    userFullHomeDir = os.path.normpath(userFullHomeDir)
    homeDirSplit = userFullHomeDir.split(os.sep)

    # The requested EFS File System Id must match the configured EFS File System Id
    if (homeDirSplit[1] != fileSystemId):
        raise Exception(
            f'EFS File System Id mismatch. Received FileSystemId: {homeDirSplit[1]} Expected FileSystemId: {fileSystemId}'
        )

    # The requrested home dir must start with the configured basePath
    if (not userFullHomeDir.startswith(basePath)):
        raise Exception(
            f'Requested Home Directory not allowed. Received: {userFullHomeDir} Expected: {basePath}/home/<username>'
        )


def sendMessage(message, username, status):
    print(message)

    response = sns_client.publish(
        TopicArn=exceptionSNSTopic,
        Message=json.dumps({
            'default': json.dumps(message, indent=4),
            'email': json.dumps(message, indent=4)
        }),
        Subject=
        f'{env_name}: {status} SFTP User Automation for {username}@{sftpServer}',
        MessageStructure='json',
        MessageAttributes={
            'sftpServerId': {
                'DataType': 'String',
                'StringValue': sftpServer
            }
        })
    print(response)
