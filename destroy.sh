#!/bin/bash

echo "Setting project..."
gcloud config set project swe455hw2

echo "Deleting Cloud Run services..."

gcloud run services delete auth-service --region us-central1 --quiet || true
gcloud run services delete lost-found-item-service --region us-central1 --quiet || true
gcloud run services delete matching-service --region us-central1 --quiet || true
gcloud run services delete notification-service --region us-central1 --quiet || true
gcloud run services delete search-service --region us-central1 --quiet || true
gcloud run services delete web-interface --region us-central1 --quiet || true

echo "Destroying Terraform infrastructure..."

terraform init
terraform destroy -auto-approve

echo "All cloud resources deleted."
