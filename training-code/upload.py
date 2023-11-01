print("Hello Upload")

import subprocess

requirements_file = "requirements.txt"
subprocess.call(["pip", "install", "boto3==1.26.165", "botocore==1.29.165"])

# !pip install boto3==1.26.165 \
#             botocore==1.29.165

import os
import boto3
import botocore

aws_access_key_id = os.environ.get('AWS_ACCESS_KEY_ID')
aws_secret_access_key = os.environ.get('AWS_SECRET_ACCESS_KEY')
endpoint_url = os.environ.get('AWS_S3_ENDPOINT')
region_name = os.environ.get('AWS_DEFAULT_REGION')
bucket_name = os.environ.get('AWS_S3_BUCKET')

session = boto3.session.Session(aws_access_key_id=aws_access_key_id,
                                aws_secret_access_key=aws_secret_access_key)

s3_resource = session.resource(
    's3',
    config=botocore.client.Config(signature_version='s3v4'),
    endpoint_url=endpoint_url,
    region_name=region_name)

bucket = s3_resource.Bucket(bucket_name)


def upload_directory_to_s3(local_directory, s3_prefix):
    for root, dirs, files in os.walk(local_directory):
        for filename in files:
            file_path = os.path.join(root, filename)
            relative_path = os.path.relpath(file_path, local_directory)
            s3_key = os.path.join(s3_prefix, relative_path)
            print(f"{file_path} -> {s3_key}")
            bucket.upload_file(file_path, s3_key)

def list_objects(prefix):
    filter = bucket.objects.filter(Prefix=prefix)
    for obj in filter.all():
        print(obj.key)

os.makedirs("models", exist_ok=True)


import shutil
# Define the source file and destination folder paths
source_file = 'model.onnx'
destination_folder = 'models'

# Use shutil.copy to copy the file to the destination folder
shutil.copy(source_file, destination_folder)


list_objects("models")

upload_directory_to_s3("models", "models")

list_objects("models")
