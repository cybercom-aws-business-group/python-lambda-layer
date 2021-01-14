# AWS lambda layer with python requests

## Deployment

### Prerequisites

    python3 
    aws cli

### Content

1. cfn/layer-bucket.yaml Provisions two S3 buckets. One for cloudformation package staging and another one for lambda layer zip-file.

2. cfn/lambda-layer.yaml Provisions Python Lambda Layer from the zip-file. If "OrganizationId" stack parameter is given, layer is shared to the Organization. 

3. cfn/layer-test-function.yaml Simple Lambda function to test the created layer.

### Build and package Lambda Layer

build.sh contains the script to first create zip-file with python modules listed on requirements.txt. 

After the zip-file is ready Cloudformation templates from ./cfn are used to provision Lambda Layer.

    ./build.sh

When build finishes you will get the layer arn string: 

    Successfully created/updated stack - lambda-layer
    Ready! Python layer arn:
    arn:aws:lambda:eu-west-1:XXXXXXXXXXX:layer:python-modules-layer:1

### Testing 

Small Lambda function is included to test the newly created Python Lambda Layer.

    aws cloudformation deploy --template-file cfn/layer-test-function.yaml --stack-name lambda-layer-test-function --parameter-overrides LayerArn=arn:aws:lambda:eu-west-1:XXXXXXXXXXX:layer:python-modules-layer:1 --capabilities CAPABILITY_IAM

Happy hacking!
