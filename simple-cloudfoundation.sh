#!/bin/bash
# https://cloudacademy.com/blog/writing-your-first-cloudformation-template/
# create-stack --stack-name simple

aws cloudformation validate-template --template-body file://simple-cloudfoundation-bucket.txt
if [ $? -ne 0 ]; then
    exit
fi

aws --region us-east-1 cloudformation create-stack --stack-name simple-s3 --template-body file://simple-cloudfoundation-bucket.txt
if [ $? -ne 0 ]; then
    exit
fi

#aws cloudformation describe-stack-events --stack-name simple-s3
#aws cloudformation delete-stack --stack-name simple-s3
# "StackId": "arn:aws:cloudformation:us-east-1:132338995091:stack/simple-s3/68424fa0-fcb0-11e8-bbe8-126c686965ae"
