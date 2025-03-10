PROJECT_ID=$(gcloud config get-value project)
cd ./infra/terraform/
terraform plan -var="project_id=${PROJECT_ID}"
terraform destroy -var="project_id=${PROJECT_ID}"
