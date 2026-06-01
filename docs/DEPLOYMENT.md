# Deployment Guide

## Docker Deployment

### Build Docker Image

```bash
docker build -t codereviewbot:latest .
```

### Run with Docker

```bash
docker run -p 3000:3000 \
  -e GITHUB_APP_ID=your_app_id \
  -e GITHUB_PRIVATE_KEY='your_private_key' \
  -e GITHUB_WEBHOOK_SECRET=your_secret \
  -e OPENAI_API_KEY=your_openai_key \
  codereviewbot:latest
```

### Docker Compose

```bash
# Create .env file with all variables
echo "GITHUB_APP_ID=..." > .env
echo "GITHUB_PRIVATE_KEY=..." >> .env
echo "GITHUB_WEBHOOK_SECRET=..." >> .env
echo "OPENAI_API_KEY=..." >> .env

# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## Heroku Deployment

### Prerequisites

- Heroku CLI installed
- Heroku account

### Deploy Steps

```bash
# Login to Heroku
heroku login

# Create app
heroku create your-app-name

# Set environment variables
heroku config:set GITHUB_APP_ID=your_app_id
heroku config:set GITHUB_PRIVATE_KEY='your_private_key'
heroku config:set GITHUB_WEBHOOK_SECRET=your_webhook_secret
heroku config:set OPENAI_API_KEY=your_openai_key

# Deploy
git push heroku main

# View logs
heroku logs --tail

# Get your Heroku URL
heroku apps:info
```

### Update GitHub App Webhook

Update your GitHub App settings with Heroku URL:
- Webhook URL: `https://your-app-name.herokuapp.com/webhook`

## AWS Lambda + API Gateway

### Prerequisites

```bash
npm install -g serverless
serverless config credentials --provider aws
```

### Deploy

```bash
serverless deploy
```

### Configure Environment

Update `serverless.yml` environment variables or use AWS Lambda console

## GCP Cloud Run

### Prerequisites

```bash
gcloud auth login
project=your-project-id
gcloud config set project $project
```

### Deploy

```bash
# Build and push to Container Registry
gcloud builds submit --tag gcr.io/$project/codereviewbot

# Deploy to Cloud Run
gcloud run deploy codereviewbot \
  --image gcr.io/$project/codereviewbot \
  --platform managed \
  --region us-central1 \
  --set-env-vars GITHUB_APP_ID=... \
  --set-env-vars GITHUB_PRIVATE_KEY=... \
  --set-env-vars GITHUB_WEBHOOK_SECRET=... \
  --set-env-vars OPENAI_API_KEY=...
```

## Kubernetes Deployment

### Create ConfigMap

```bash
kubectl create configmap codereviewbot-config \
  --from-literal=OPENAI_MODEL=gpt-4 \
  --from-literal=REVIEW_LANGUAGES=typescript,javascript,python
```

### Create Secret

```bash
kubectl create secret generic codereviewbot-secrets \
  --from-literal=GITHUB_APP_ID=your_app_id \
  --from-literal=GITHUB_PRIVATE_KEY='your_private_key' \
  --from-literal=GITHUB_WEBHOOK_SECRET=your_webhook_secret \
  --from-literal=OPENAI_API_KEY=your_openai_key
```

### Deploy with Helm

```bash
helm install codereviewbot ./helm \
  -f helm/values.yaml
```

## Monitoring & Logging

### Docker

```bash
# View logs
docker logs -f container_id

# Health check
curl http://localhost:3000/health
```

### Heroku

```bash
# View logs
heroku logs --tail

# App status
heroku ps
```

### GCP Cloud Run

```bash
# View logs
gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=codereviewbot" --limit 50 --format json
```

## Production Checklist

- [ ] All environment variables set
- [ ] Database backups configured (if needed)
- [ ] Monitoring alerts configured
- [ ] Log aggregation setup
- [ ] Auto-scaling configured
- [ ] Health checks enabled
- [ ] SSL certificates configured
- [ ] Rate limiting enabled
- [ ] Security headers configured
- [ ] Regular backups tested

## Scaling Considerations

### Horizontal Scaling

The application is stateless and can be scaled horizontally:

```bash
# Docker Compose - scale to 3 instances
docker-compose up -d --scale codereviewbot=3
```

### Performance Optimization

- Use CDN for static assets
- Cache AI responses if reviewing similar code
- Implement request queuing for high load
- Use read replicas for database

## Cost Optimization

### Reduce OpenAI Costs

1. Filter files before sending to AI
2. Set reasonable token limits
3. Use GPT-3.5-turbo for non-critical reviews
4. Cache common patterns

### Infrastructure Costs

1. Use spot instances where possible
2. Auto-scale based on metrics
3. Archive old logs
4. Use serverless for unpredictable load
