#!/bin/bash
# https://cloudacademy.com/blog/writing-your-first-cloudformation-template/
# create-stack --stack-name simple

deploy_stack=false
deploy_site=false
remove_stack=false
describe_stack=false
while getopts "sdri" opt; do
  case $opt in
    s)
      #echo "-a was triggered, Parameter: $OPTARG" >&2
	  deploy_stack=true
	  ;;
	d)
	  deploy_site=true
	  ;;
	r)
	  remove_stack=true
	  ;;
	i)
	  describe_stack=true
	  ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

getS3BucketName(){
	aws s3 ls | grep "s3bucket" | awk '{ print $3 }'
}

echo $deploy_stack
echo $deploy_site


if $deploy_stack ; then
	echo "deploying stack"
	aws cloudformation validate-template --template-body file://simple-cloudfoundation-bucket.json
	if [ $? -ne 0 ]; then
		exit
	fi

	aws --region us-east-1 cloudformation create-stack --stack-name simple-s3 --template-body file://simple-cloudfoundation-bucket.json
	if [ $? -ne 0 ]; then
		exit
	fi
fi

if $deploy_site ; then
	echo "deploying site"
	s3_bucket_secure_url=$(aws cloudformation --region us-east-1 describe-stacks --stack-name simple-s3 --query 'Stacks[0].Outputs[?OutputKey==`S3BucketSecureURL`].OutputValue' --output text)
	echo "S3 Secure Bucket URL [$s3_bucket_secure_url]"
	#aws s3 cp . s3://bucket/ --exclude "*" --include "*.jpg"
	aws s3 cp --profile s3manager index.html s3://$(getS3BucketName)/index.html
	if [ $? -ne 0 ]; then
		exit
	fi
fi

if $remove_stack ; then
	echo "remove stack"
    aws cloudformation delete-stack --stack-name simple-s3	
	if [ $? -ne 0 ]; then
		exit
	fi
fi


if $describe_stack ; then
	echo "describe stack"
    aws cloudformation describe-stacks --stack-name simple-s3	
	if [ $? -ne 0 ]; then
		exit
	fi
	
	bucket_count=$(aws s3 ls | grep "s3bucket" | wc -l)
	if [[ "$bucket_count" == "1" ]]; then
		echo "only one S3Bucket"
	else
		echo "error: more than one S3Bucket"
		exit
	fi
	
	bucket_name=$(getS3BucketName)
	echo "bucket name $bucket_name"

fi

#aws s3 cp ./index.html s3://dontkickthebucket/index.html

#aws cloudformation describe-stack-events --stack-name simple-s3
#aws cloudformation delete-stack --stack-name simple-s3
# "StackId": "arn:aws:cloudformation:us-east-1:132338995091:stack/simple-s3/68424fa0-fcb0-11e8-bbe8-126c686965ae"

# Policy Generator Tool
# http://awspolicygen.s3.amazonaws.com/policygen.html

#S3 Snippet:
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/quickref-s3.html
#S3 Upload Files:
# https://docs.aws.amazon.com/cli/latest/userguide/using-s3-commands.html
# aws s3 cp /tmp/foo/ s3://bucket/ --exclude "*" --include "*.jpg"
#aws cloudformation --region us-east-1 describe-stacks --stack-name simple-s3
#$ aws cloudformation --region us-east-1 describe-stacks --stack-name simple-s3 --query 'Stacks[0].Outputs[?OutputKey==`S3BucketSecureURL`].OutputValue' --output text

#GetAtt": ["S3Bucket
