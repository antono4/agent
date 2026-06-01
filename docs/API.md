# API Documentation

## Endpoints

### Health Check

**GET** `/health`

Healthiness check endpoint. Returns 200 if the service is running.

**Response:**
```json
{
  "status": "ok"
}
```

### Webhook

**POST** `/webhook`

GitHub webhook endpoint for processing pull request events.

**Headers:**
```
X-GitHub-Event: pull_request
X-GitHub-Hook-ID: ...
X-GitHub-Delivery: ...
X-Hub-Signature-256: sha256=...
```

**Payload:**
GitHub pull request event payload (see [GitHub Docs](https://docs.github.com/en/developers/webhooks-and-events/webhooks/webhook-events-and-payloads#pull_request))

**Triggers on:**
- `pull_request.opened`
- `pull_request.synchronize`
- `pull_request.reopened`

**Response:**
```json
{
  "message": "Webhook processed"
}
```

## Request/Response Examples

### Webhook Request

```bash
curl -X POST http://localhost:3000/webhook \
  -H "Content-Type: application/json" \
  -H "X-GitHub-Event: pull_request" \
  -H "X-Hub-Signature-256: sha256=..." \
  -d @webhook-payload.json
```

### Health Check Request

```bash
curl http://localhost:3000/health
```

## Error Handling

### HTTP Status Codes

| Status | Description |
|--------|-------------|
| 200 | Success |
| 400 | Bad request (missing installation ID) |
| 500 | Internal server error |

### Error Response

```json
{
  "error": "Error message"
}
```

## Rate Limiting

- GitHub Webhook: No rate limiting (GitHub throttles)
- OpenAI: Per your OpenAI API plan
- GitHub API: 5,000 requests/hour (per GitHub App)

## Logging

All requests are logged with:
- Timestamp
- Event type
- PR number
- Owner/repo
- Status
- Duration

Example log:
```
info: Received webhook eventName=pull_request
info: Processing PR review prNumber=42 owner=antono4 repo=agent
info: Posted review owner=antono4 repo=agent prNumber=42
```

## Configuration

### Environment Variables

See [README.md](../README.md#-environment-variables)

## Integration Examples

### GitHub App Workflow

1. PR is opened/updated on GitHub
2. GitHub sends webhook to your endpoint
3. Server validates webhook signature
4. Gets installation access token
5. Fetches PR files changed
6. Sends to OpenAI for analysis
7. Posts review comment with suggestions

### With CI/CD Pipeline

```yaml
# .github/workflows/review.yml
name: Automated Review
on:
  pull_request:
    types: [opened, synchronize]
jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - name: Trigger CodeReviewBot
        # CodeReviewBot is triggered via webhook automatically
        run: echo "CodeReviewBot will review this PR"
```

## Development API

### Testing Webhooks Locally

Use [Webhook.cool](https://webhook.cool) or similar service:

```bash
# Get a temporary URL
# Then set it as your GitHub App webhook URL
# Send test event from GitHub app settings
```

### Mock Webhook Request

```javascript
const payload = {
  action: 'opened',
  pull_request: {
    number: 1,
    title: 'Test PR',
    body: 'Test description',
    user: { login: 'testuser' },
    head: { sha: 'abc123', ref: 'feature' },
    base: { sha: 'def456', ref: 'main' }
  },
  repository: {
    name: 'agent',
    full_name: 'antono4/agent',
    owner: { login: 'antono4' }
  },
  installation: { id: 12345 }
};

fetch('http://localhost:3000/webhook', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(payload)
});
```
