#!/bin/bash

echo "Setting project..."
gcloud config set project swe455hw2

echo "Restoring infrastructure..."
terraform init
terraform apply -auto-approve

echo "Triggering CI/CD deployments..."

git -C ~/lost-found-auth-service commit --allow-empty -m "restore" && git -C ~/lost-found-auth-service push
git -C ~/lost-found-item-service commit --allow-empty -m "restore" && git -C ~/lost-found-item-service push
git -C ~/lost-found-matching-service commit --allow-empty -m "restore" && git -C ~/lost-found-matching-service push
git -C ~/lost-found-notification-service commit --allow-empty -m "restore" && git -C ~/lost-found-notification-service push
git -C ~/lost-found-search-service commit --allow-empty -m "restore" && git -C ~/lost-found-search-service push
git -C ~/lost-found-web-interface commit --allow-empty -m "restore" && git -C ~/lost-found-web-interface push

echo "Restore triggered. Wait for CI/CD pipelines."
