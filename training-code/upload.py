print("Hello Upload")

import subprocess

requirements_file = "requirements.txt"
subprocess.call(["pip", "install", "boto3==1.26.165", "botocore==1.29.165"])

# !pip install boto3==1.26.165 \
#             botocore==1.29.165