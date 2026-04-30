output "storage_bucket_name" {
  value = google_storage_bucket.lost_found_bucket.name
}

output "artifact_registry_repo" {
  value = google_artifact_registry_repository.lost_found_repo.repository_id
}
