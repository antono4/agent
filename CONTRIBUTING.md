# Contributing to CodeReviewBot

Thank you for your interest in contributing to CodeReviewBot! This document provides guidelines and instructions for contributing.

## Code of Conduct

- Be respectful and inclusive
- Follow best practices
- Help others learn and grow
- Report issues professionally

## Getting Started

### Prerequisites

- Node.js 18+
- npm 9+
- Git

### Setup

```bash
git clone https://github.com/antono4/agent.git
cd agent
npm install
cp .env.example .env
# Edit .env with test credentials
```

### Development

```bash
# Start dev server
npm run dev

# Run tests
npm run test

# Linting
npm run lint:fix

# Format code
npm run format
```

## Submitting Changes

### Branch Naming

- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation
- `test/description` - Tests
- `chore/description` - Maintenance

### Commit Messages

Follow conventional commits:

```
type(scope): description

Optional body

Optional footer
```

Examples:
- `feat(ai): add support for code security analysis`
- `fix(webhook): handle missing installation id`
- `docs(setup): update GitHub App instructions`
- `test(services): add AI service tests`

### Pull Request Process

1. Create feature branch from `main`
2. Make changes and test
3. Run linting: `npm run lint:fix`
4. Run tests: `npm run test`
5. Update documentation
6. Submit PR with description
7. Address review feedback
8. Merge when approved

## Code Standards

### TypeScript

- Strict mode enabled
- Explicit return types
- No implicit any
- Meaningful variable names

### Testing

- Aim for >80% coverage
- Test happy paths and edge cases
- Mock external services
- Use descriptive test names

### Documentation

- Update README for user-facing changes
- Document complex logic
- Add JSDoc comments for public APIs
- Update CHANGELOG

## Reporting Bugs

Use GitHub Issues to report bugs. Include:

1. **Description** - Clear summary
2. **Steps to Reproduce** - Exact steps to reproduce
3. **Expected Behavior** - What should happen
4. **Actual Behavior** - What actually happens
5. **Environment** - Node version, OS, etc.
6. **Logs** - Error messages and stack traces

## Feature Requests

Use GitHub Issues for feature requests. Include:

1. **Description** - Feature summary
2. **Problem** - Problem it solves
3. **Solution** - Proposed solution
4. **Use Cases** - Real-world use cases

## Project Structure

```
src/              # Source code
tests/            # Test files
docs/             # Documentation
.github/          # GitHub config
scripts/          # Utility scripts
```

## Performance Tips

- Minimize AI API calls
- Cache responses when possible
- Batch GitHub API requests
- Use appropriate logging levels

## Questions?

- Check existing documentation
- Search existing issues
- Create a discussion
- Open an issue

Thanks for contributing! 🎉
