# Installation Guide

## Prerequisites

- Node.js 18.0.0 or higher
- npm 9.0.0 or higher
- GitHub account
- OpenAI account with GPT-4 access

## Step 1: Clone Repository

```bash
git clone https://github.com/antono4/agent.git
cd agent
```

## Step 2: Install Dependencies

```bash
npm install
```

## Step 3: Create GitHub App

### 3.1 Go to GitHub App Settings

Visit: https://github.com/settings/apps

### 3.2 Create New GitHub App

Click "New GitHub App" and fill in:

**Form Fields:**
- **GitHub App name**: `CodeReviewBot`
- **Homepage URL**: `https://github.com/antono4/agent` (or your project URL)
- **Webhook URL**: Leave blank for now (update after deployment)
- **Webhook secret**: Generate a random secret (e.g., `openssl rand -base64 32`)

### 3.3 Set Permissions

Under "Repository permissions":
- `Contents`: Read-only
- `Pull requests`: Read & write
- `Checks`: Read-only

### 3.4 Subscribe to Events

Check:
- ✅ Pull request

### 3.5 Save Credentials

After creating the app, note:
- **App ID** (visible in the app page header)
- **Private Key** (download from app settings)
- **Webhook Secret** (you created above)

## Step 4: Get OpenAI API Key

1. Go to https://platform.openai.com/account/api-keys
2. Click "Create new secret key"
3. Copy the key (you won't see it again)
4. Ensure you have GPT-4 access

## Step 5: Configure Environment

```bash
cp .env.example .env
```

Edit `.env` with your credentials:

```env
# GitHub App Configuration
GITHUB_APP_ID=123456
GITHUB_PRIVATE_KEY=-----BEGIN RSA PRIVATE KEY-----
...
-----END RSA PRIVATE KEY-----
GITHUB_WEBHOOK_SECRET=your_generated_secret_here

# OpenAI Configuration
OPENAI_API_KEY=sk-...
OPENAI_MODEL=gpt-4

# Server Configuration
PORT=3000
NODE_ENV=development

# Review Configuration
REVIEW_MIN_ADDITIONS=5
REVIEW_MAX_FILES=50
REVIEW_LANGUAGES=typescript,javascript,python,go,rust

# Logging
LOG_LEVEL=info
```

## Step 6: Local Testing with ngrok

For local development, use ngrok to expose your local server:

### 6.1 Install ngrok

https://ngrok.com/download

### 6.2 Update GitHub App Webhook

1. Go to your GitHub App settings
2. Click "Edit"
3. Update Webhook URL to: `https://your-ngrok-url.ngrok.io/webhook`
4. Save

### 6.3 Start ngrok

```bash
ngrok http 3000
```

Copy the forwarding URL (e.g., `https://abc123.ngrok.io`)

## Step 7: Run Application

### Development Mode

```bash
npm run dev
```

You should see:
```
info: Server started port=3000
```

### Production Mode

```bash
npm run build
npm start
```

## Step 8: Install App on Repository

### 8.1 Go to App Installation

Visit: https://github.com/settings/apps/your-app-name/installations

### 8.2 Install on Repository

Click "Install" and select the repository to install on

### 8.3 Grant Permissions

Review and approve the requested permissions

## Step 9: Test the Setup

### 9.1 Create a Test PR

Create a pull request in your repository

### 9.2 Verify

- Check if CodeReviewBot commented on your PR
- Review the quality score and suggestions

## Troubleshooting

### Issue: "No installation ID in webhook"

**Solution**: Ensure the app is properly installed on the repository

```bash
# Check webhook logs
ngrok web  # Visit localhost:4040 to see requests
```

### Issue: "OPENAI_API_KEY is required"

**Solution**: 
1. Check `.env` file has the key
2. Restart the server

```bash
cat .env | grep OPENAI_API_KEY
```

### Issue: "Configuration validation failed"

**Solution**: Run the validation script

```bash
npm run type-check
```

### Issue: Reviews not posting

**Solution**: Check permissions in GitHub App settings:
- ✅ `Pull requests: Read & write`
- ✅ `Contents: Read`

## Next Steps

1. **Deploy to Production** - See [DEPLOYMENT.md](./DEPLOYMENT.md)
2. **Customize Prompts** - Edit `src/utils/prompt.ts`
3. **Add More Languages** - Update `REVIEW_LANGUAGES` in `.env`
4. **Monitor Performance** - Check logs and adjust settings

## Support

For issues:
1. Check logs: `tail -f logs/*.log`
2. Review webhook delivery: https://github.com/settings/apps/your-app/installations
3. Open GitHub issue with details
