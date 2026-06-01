#!/bin/bash

set -e

echo "========================================"
echo "CodeReviewBot Setup Script"
echo "========================================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Install dependencies
echo -e "${BLUE}[1/6]${NC} Installing dependencies..."
if [ ! -d "node_modules" ]; then
  npm install
else
  echo "✓ Dependencies already installed"
fi
echo ""

# Step 2: Setup environment
echo -e "${BLUE}[2/6]${NC} Setting up environment..."
if [ ! -f ".env" ]; then
  cp .env.example .env
  echo -e "${GREEN}✓${NC} Created .env file"
  echo -e "${YELLOW}⚠ Please edit .env with your credentials:${NC}"
  echo "  - GITHUB_APP_ID"
  echo "  - GITHUB_PRIVATE_KEY"
  echo "  - GITHUB_WEBHOOK_SECRET"
  echo "  - OPENAI_API_KEY"
else
  echo "✓ .env file already exists"
fi
echo ""

# Step 3: Build TypeScript
echo -e "${BLUE}[3/6]${NC} Building TypeScript..."
npm run build
echo ""

# Step 4: Run tests
echo -e "${BLUE}[4/6]${NC} Running tests..."
npm run test -- --passWithNoTests
echo ""

# Step 5: Linting
echo -e "${BLUE}[5/6]${NC} Running linter..."
npm run lint:fix
echo ""

# Step 6: Generate webhook secret
echo -e "${BLUE}[6/6]${NC} Generating webhook secret..."
SECRET=$(openssl rand -base64 32 2>/dev/null || python -c "import secrets; print(secrets.token_urlsafe(24))")
echo -e "${GREEN}✓${NC} Generated webhook secret:"
echo -e "  ${YELLOW}$SECRET${NC}"
echo -e "  ${YELLOW}(Add this to GITHUB_WEBHOOK_SECRET in .env and GitHub App settings)${NC}"
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Setup Complete! ✓${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Edit .env with your credentials"
echo "  2. Create GitHub App at: https://github.com/settings/apps"
echo "  3. Start dev server: npm run dev"
echo "  4. Use ngrok for local testing: ngrok http 3000"
echo ""
