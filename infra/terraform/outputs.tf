output "laravel_service_url" {
  value = google_cloud_run_service.laravel_service.status[0].url
}

output "python_service_url" {
  value = google_cloud_run_service.python_service.status[0].url
}

output "mysql_connection_name" {
  value = google_sql_database_instance.mysql_instance.connection_name
}
