output "laravel_service_url" {
  value = google_cloud_run_service.laravel_service.status[0].url
}
