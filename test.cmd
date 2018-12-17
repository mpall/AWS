

aws ecs list-task-definitions

aws ecs deregister-task-definition --task-definition first-run-task-definition:1
aws ecs deregister-task-definition --task-definition first-run-task-definition:2
aws ecs update-service --service sample-app-service --cluster default --desired-count 0
aws ecs delete-service --service sample-app-service --cluster default
aws ecs delete-cluster --cluster default --region us-east-1
