PROJECT_ID=$(gcloud config get-value project)
REGION="us-central1"
LARAVEL_IMAGE="us-central1-docker.pkg.dev/${PROJECT_ID}/app-repo/laravel-nginx:latest"
LARAVEL_API_IMAGE="us-central1-docker.pkg.dev/${PROJECT_ID}/app-repo/laravel-api:latest"

gcloud auth configure-docker ${REGION}-docker.pkg.dev

docker build --target laravel -t ${LARAVEL_API_IMAGE} .
docker push ${LARAVEL_API_IMAGE}

docker build --target nginx -t ${LARAVEL_IMAGE} .
docker push ${LARAVEL_IMAGE}

cd ./infra/terraform/

terraform init
terraform plan -var="project_id=${PROJECT_ID}"
terraform apply -var="project_id=${PROJECT_ID}"
