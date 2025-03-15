resource "google_artifact_registry_repository" "app_repo" {
  location      = var.region
  repository_id = "app-repo"
  format        = "DOCKER"
}

resource "google_cloud_run_service" "laravel_service" {
  name     = "laravel-service"
  location = var.region
  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.app_repo.repository_id}/laravel-nginx:latest"
        name  = "nginx"
        resources {
          limits = {
            cpu    = "1000m"
            memory = "512Mi"
          }
        }
        ports {
          container_port = 80
          name           = "http1"
        }
        startup_probe {
          initial_delay_seconds = 5
          timeout_seconds       = 3
          period_seconds        = 10
          failure_threshold     = 3
          tcp_socket {
            port = 80
          }
        }
        env {
          name  = "FLASK_SERVICE_URL"
          value = google_cloud_run_service.flask_service.status[0].url
        }
      }
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.app_repo.repository_id}/laravel-api:latest"
        name  = "php-fpm"
        resources {
          limits = {
            cpu    = "500m"
            memory = "256Mi"
          }
        }
        env {
          name  = "FLASK_SERVICE_URL"
          value = google_cloud_run_service.flask_service.status[0].url
        }
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service" "flask_service" {
  name     = "flask-service"
  location = var.region
  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.app_repo.repository_id}/flask-service:latest"
        name  = "flask"
        resources {
          limits = {
            cpu    = "500m"
            memory = "256Mi"
          }
        }
        ports {
          container_port = 5000
          name           = "http1"
        }
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "laravel_public" {
  service  = google_cloud_run_service.laravel_service.name
  location = google_cloud_run_service.laravel_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_service_iam_member" "flask_service_invoker" {
  service  = google_cloud_run_service.flask_service.name
  location = google_cloud_run_service.flask_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
