#!/bin/bash

set -e

echo "CodeReviewBot Deployment Script"
echo ""

# Parse arguments
if [ "$1" == "docker" ]; then
  echo "Deploying with Docker..."
  docker build -t codereviewbot:latest .
  docker-compose up -d
  echo "Docker deployment complete"
  echo "Access at: http://localhost:3000"

elif [ "$1" == "heroku" ]; then
  echo "Deploying to Heroku..."
  
  if ! command -v heroku &> /dev/null; then
    echo "Installing Heroku CLI..."
    npm install -g heroku
  fi
  
  APP_NAME="${2:-codereviewbot-$(date +%s)}"
  
  heroku create $APP_NAME
  
  echo "Setting environment variables..."
  echo "Please enter your credentials:"
  read -p "GitHub App ID: " GITHUB_APP_ID
  read -sp "GitHub Private Key (will not echo): " GITHUB_PRIVATE_KEY
  echo ""
  read -p "GitHub Webhook Secret: " GITHUB_WEBHOOK_SECRET
  read -sp "OpenAI API Key (will not echo): " OPENAI_API_KEY
  echo ""
  
  heroku config:set \
    GITHUB_APP_ID=$GITHUB_APP_ID \
    GITHUB_PRIVATE_KEY="$GITHUB_PRIVATE_KEY" \
    GITHUB_WEBHOOK_SECRET=$GITHUB_WEBHOOK_SECRET \
    OPENAI_API_KEY=$OPENAI_API_KEY \
    -a $APP_NAME
  
  git push heroku main
  
  echo ""
  echo "Heroku deployment complete"
  echo "Your app is running at: https://$APP_NAME.herokuapp.com"
  echo "Update GitHub App webhook URL to: https://$APP_NAME.herokuapp.com/webhook"

elif [ "$1" == "gcp" ]; then
  echo "Deploying to Google Cloud Run..."
  
  PROJECT_ID=$(gcloud config get-value project)
  SERVICE_NAME="codereviewbot"
  
  echo "Building and pushing image to Container Registry..."
  gcloud builds submit --tag gcr.io/$PROJECT_ID/$SERVICE_NAME
  
  echo "Deploying to Cloud Run..."
  gcloud run deploy $SERVICE_NAME \
    --image gcr.io/$PROJECT_ID/$SERVICE_NAME \
    --platform managed \
    --region us-central1 \
    --allow-unauthenticated
  
  echo ""
  echo "GCP deployment complete"
  echo "View your service: https://console.cloud.google.com/run"

else
  echo "Usage: ./scripts/deploy.sh [docker|heroku|gcp]"
  echo ""
  echo "Examples:"
  echo "  ./scripts/deploy.sh docker"
  echo "  ./scripts/deploy.sh heroku my-app-name"
  echo "  ./scripts/deploy.sh gcp"
fi
