rem https://cloudacademy.com/blog/writing-your-first-cloudformation-template/
rem create-stack --stack-name simple

aws cloudformation validate-template --template-body file://simple-cloudfoundation-bucket.txt
