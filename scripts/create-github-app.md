# GitHub App Creation Script

## Automated Setup with curl

```bash
#!/bin/bash

# Variables
GITHUB_USERNAME="your-github-username"
GITHUB_TOKEN="your-personal-access-token"
APP_NAME="CodeReviewBot"
WEBHOOK_URL="https://your-domain.com/webhook"
WEBHOOK_SECRET=$(openssl rand -base64 32)

# Create GitHub App
curl -X POST https://api.github.com/app-manifests \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d @- << EOF
{
  "name": "$APP_NAME",
  "url": "https://github.com/antono4/agent",
  "hook_attributes": {
    "url": "$WEBHOOK_URL",
    "active": true,
    "events": ["pull_request"]
  },
  "permissions": {
    "contents": "read",
    "pull_requests": "write",
    "checks": "read"
  }
}
EOF
```

## Manual Steps

1. Go to: https://github.com/settings/apps/new
2. Fill in the form:
   - **App name**: CodeReviewBot
   - **Homepage URL**: https://github.com/antono4/agent
   - **Webhook URL**: https://your-domain/webhook (update after deployment)
   - **Webhook secret**: (generate with `openssl rand -base64 32`)
3. Permissions:
   - **Contents**: Read-only
   - **Pull requests**: Read & write
   - **Checks**: Read-only
4. Events:
   - Check "Pull request"
5. Click "Create GitHub App"
6. Save:
   - App ID
   - Download private key
   - Webhook secret

## Add to .env

```bash
echo "GITHUB_APP_ID=YOUR_APP_ID" >> .env
echo "GITHUB_PRIVATE_KEY=YOUR_PRIVATE_KEY" >> .env
echo "GITHUB_WEBHOOK_SECRET=$WEBHOOK_SECRET" >> .env
echo "OPENAI_API_KEY=YOUR_OPENAI_KEY" >> .env
```

## Install on Repositories

1. Go to: https://github.com/settings/apps/your-app-name/installations
2. Click "Install"
3. Select repositories
4. Click "Install & Authorize"
