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
