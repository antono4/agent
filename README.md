# CodeReviewBot 🤖

An intelligent GitHub Pull Request code review automation tool powered by GPT-4.

## ✨ Features

- **Intelligent Code Analysis** - Powered by GPT-4 for comprehensive code reviews
- **Detects** - Bugs, security issues, performance problems, best practice violations
- **GitHub Integration** - Seamless GitHub App integration with automatic webhook handling
- **Line-level Comments** - Posts reviews directly on PRs with specific suggestions
- **Flexible Configuration** - Customize review languages, file types, and thresholds
- **Production Ready** - Docker & Kubernetes support, comprehensive logging

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- GitHub App credentials
- OpenAI API key (GPT-4 access)

### Installation

```bash
git clone https://github.com/antono4/agent.git
cd agent
npm install
cp .env.example .env
# Edit .env with your credentials
npm run dev
```

### Configuration

Set environment variables in `.env`:

```env
GITHUB_APP_ID=your_app_id
GITHUB_PRIVATE_KEY=your_private_key
GITHUB_WEBHOOK_SECRET=your_webhook_secret
OPENAI_API_KEY=your_openai_key
PORT=3000
REVIEW_LANGUAGES=typescript,javascript,python,go,rust
```

## 📋 Architecture

```
GitHub Webhook → Express Server → Review Service
                                  ↓
                         GitHub Service (fetch files)
                                  ↓
                           AI Service (GPT-4 analysis)
                                  ↓
                         Post Review Comment on PR
```

## 🏗️ Project Structure

```
src/
├── app.ts                 # Express server entry point
├── types/
│   └── index.ts          # TypeScript interfaces
├── services/
│   ├── github.service.ts # GitHub API operations
│   ├── ai.service.ts     # OpenAI integration
│   └── review.service.ts # Review orchestration
├── handlers/
│   └── webhook.handler.ts # Webhook processing
└── utils/
    ├── logger.ts         # Pino logging setup
    ├── prompt.ts         # AI prompt templates
    └── config.ts         # Configuration loader
```

## 📦 Available Scripts

```bash
npm run build      # Build TypeScript
npm run start      # Start production server
npm run dev        # Start dev server with hot reload
npm run test       # Run tests
npm run lint       # Lint code
npm run format     # Format code with Prettier
```

## 🐳 Docker Deployment

```bash
# Build image
docker build -t codereviewbot:latest .

# Run with docker-compose
docker-compose up -d
```

## ☁️ Cloud Deployment

### Heroku
```bash
heroku create your-app-name
git push heroku main
heroku config:set GITHUB_APP_ID=...
```

### AWS Lambda
```bash
npm install -g serverless
serverless deploy
```

### GCP Cloud Run
```bash
cloud run deploy codereviewbot --source .
```

## 🔑 GitHub App Setup

### Create GitHub App
1. Go to https://github.com/settings/apps
2. Click "New GitHub App"
3. Fill in the form:
   - App name: `CodeReviewBot`
   - Webhook URL: `https://your-domain.com/webhook`
   - Generate webhook secret

### Permissions Required
- `Pull requests`: Read & write
- `Contents`: Read
- `Checks`: Read

### Subscribe to Events
- `Pull request`

## 📊 Review Output Example

```markdown
# 🤖 CodeReviewBot Analysis

## Summary
This PR adds authentication middleware with proper error handling.
Overall structure is clean with good separation of concerns.

## Overall Quality Score
8/10

## 🚨 Potential Issues
- Missing error handling for database connection failures
- No rate limiting on the auth endpoint

## 💡 Suggestions
- Add unit tests for edge cases
- Document the authentication flow
- Consider using dependency injection for better testability
```

## 🧪 Testing

```bash
# Run all tests
npm run test

# Watch mode
npm run test:watch

# Coverage
npm run test:coverage
```

## 📝 Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `GITHUB_APP_ID` | ✅ | GitHub App ID |
| `GITHUB_PRIVATE_KEY` | ✅ | GitHub App private key |
| `GITHUB_WEBHOOK_SECRET` | ✅ | Webhook secret |
| `OPENAI_API_KEY` | ✅ | OpenAI API key |
| `OPENAI_MODEL` | ❌ | Model (default: gpt-4) |
| `PORT` | ❌ | Server port (default: 3000) |
| `NODE_ENV` | ❌ | Environment (development/production) |
| `REVIEW_MIN_ADDITIONS` | ❌ | Min additions to review (default: 5) |
| `REVIEW_MAX_FILES` | ❌ | Max files to review (default: 50) |
| `REVIEW_LANGUAGES` | ❌ | Supported languages (comma-separated) |
| `LOG_LEVEL` | ❌ | Log level (default: info) |

## 🔒 Security

- All webhooks are validated with HMAC-SHA256
- Private keys are never logged
- Sensitive configuration via environment variables
- No storage of code or PR data

## 📄 License

MIT License - see LICENSE file for details

## 🤝 Contributing

Contributions welcome! Please read our contributing guidelines.

## 📮 Support

For issues and questions, please create a GitHub issue.

---

**Built with ❤️ by antono4**
