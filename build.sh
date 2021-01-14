#!/bin/bash
python3 -m venv env
source env/bin/activate
mkdir python
pip install -r requirements.txt -t ./python
zip -r layer_package.zip ./python

aws cloudformation deploy --template-file cfn/layer-bucket.yaml --stack-name lambda-layer-bucket
staging_bucket=$(aws cloudformation describe-stacks --stack-name lambda-layer-bucket --query 'Stacks[0].Outputs[?OutputKey==`CfnStagingBucket`].OutputValue' --output text)
layer_bucket=$(aws cloudformation describe-stacks --stack-name lambda-layer-bucket --query 'Stacks[0].Outputs[?OutputKey==`LayerBucket`].OutputValue' --output text)

aws s3 mv layer_package.zip s3://${layer_bucket}
aws cloudformation package --s3-bucket ${staging_bucket} --output-template-file packaged.yaml --region eu-west-1 --template-file cfn/lambda-layer.yaml
aws cloudformation deploy --template-file packaged.yaml --stack-name lambda-layer

echo "Ready! Python layer arn:"
echo $(aws cloudformation describe-stacks --stack-name lambda-layer --query 'Stacks[0].Outputs[?OutputKey==`LayerArn`].OutputValue' --output text)
