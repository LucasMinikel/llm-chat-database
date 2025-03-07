PROJECT_ID=$(gcloud config get-value project)
REGION="us-central1"
LARAVEL_IMAGE="${REGION}-docker.pkg.dev/${PROJECT_ID}/app-repo/laravel-nginx:latest"
PYTHON_IMAGE="${REGION}-docker.pkg.dev/${PROJECT_ID}/app-repo/python-app:latest"

gcloud auth configure-docker ${REGION}-docker.pkg.dev

docker build --target nginx -t ${LARAVEL_IMAGE} .
docker push ${LARAVEL_IMAGE}

cd ./infra/terraform/

terraform init
terraform apply -var="project_id=${PROJECT_ID}"
