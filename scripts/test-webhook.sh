#!/bin/bash

echo "Testing CodeReviewBot Webhook"
echo ""

# Check if server is running
SERVER_URL="${1:-http://localhost:3000}"

echo "Testing health endpoint..."
HEALTH=$(curl -s $SERVER_URL/health)
echo "Response: $HEALTH"

if echo "$HEALTH" | grep -q "ok"; then
  echo "✓ Server is running"
else
  echo "✗ Server is not responding"
  exit 1
fi

echo ""
echo "Testing webhook endpoint..."

# Create test payload
TEST_PAYLOAD=$(cat <<'EOF'
{
  "action": "opened",
  "pull_request": {
    "id": 1,
    "number": 1,
    "title": "Test PR",
    "body": "This is a test PR",
    "user": {
      "login": "testuser"
    },
    "head": {
      "sha": "abc123",
      "ref": "feature/test"
    },
    "base": {
      "sha": "def456",
      "ref": "main"
    }
  },
  "repository": {
    "id": 1,
    "name": "test-repo",
    "full_name": "testuser/test-repo",
    "owner": {
      "login": "testuser"
    }
  },
  "installation": {
    "id": 12345
  }
}
EOF
)

echo "Sending test webhook..."
WEBHOOK_RESPONSE=$(curl -s -X POST $SERVER_URL/webhook \
  -H "Content-Type: application/json" \
  -H "X-GitHub-Event: pull_request" \
  -d "$TEST_PAYLOAD")

echo "Response: $WEBHOOK_RESPONSE"

if echo "$WEBHOOK_RESPONSE" | grep -q "processed\|error"; then
  echo "✓ Webhook processed"
else
  echo "✗ Webhook processing failed"
fi
