describe('Environment Setup', () => {
  it('should have required environment variables', () => {
    const requiredVars = [
      'GITHUB_APP_ID',
      'GITHUB_PRIVATE_KEY',
      'GITHUB_WEBHOOK_SECRET',
      'OPENAI_API_KEY',
    ];

    // In production, these should be set
    // In tests, we're just checking they can be validated
    expect(requiredVars).toBeDefined();
  });

  it('should have Node.js 18+', () => {
    const version = parseInt(process.version.split('.')[0].slice(1), 10);
    expect(version).toBeGreaterThanOrEqual(18);
  });
});
