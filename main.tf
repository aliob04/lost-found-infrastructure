terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
resource "google_project_service" "cloud_sql_admin" {
  project = var.project_id
  service = "sqladmin.googleapis.com"

  disable_on_destroy = false
}
resource "google_storage_bucket" "lost_found_bucket" {
  name     = "${var.project_id}-lost-found-storage"
  location = "US"

  force_destroy = true
}

resource "google_artifact_registry_repository" "lost_found_repo" {
  location      = var.region
  repository_id = "lost-found-containers"
  description   = "Docker images for lost and found system"
  format        = "DOCKER"
}
resource "google_sql_database_instance" "postgres" {
  name             = "lost-found-postgres"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }

  deletion_protection = false

  depends_on = [google_project_service.cloud_sql_admin]
}

resource "google_sql_database" "lost_found_db" {
  name     = "lostfound"
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "lost_found_user" {
  name     = "lostfounduser"
  instance = google_sql_database_instance.postgres.name
  password = "LostFound12345!"
}
resource "google_project_service" "pubsub" {
  project = var.project_id
  service = "pubsub.googleapis.com"

  disable_on_destroy = false
}

resource "google_pubsub_topic" "item_created" {
  name = "item-created"

  depends_on = [google_project_service.pubsub]
}

resource "google_pubsub_subscription" "item_created_push" {
  name  = "item-created-push-to-matching"
  topic = google_pubsub_topic.item_created.name

  push_config {
    push_endpoint = "https://matching-service-512993707354.us-central1.run.app/events/item-created"
  }
}