import { validateConfig } from '../../src/utils/config';

describe('Config', () => {
  const originalEnv = process.env;

  beforeEach(() => {
    process.env = { ...originalEnv };
  });

  afterEach(() => {
    process.env = originalEnv;
  });

  describe('validateConfig', () => {
    it('should return errors when required env vars are missing', () => {
      process.env.GITHUB_APP_ID = '';
      process.env.GITHUB_PRIVATE_KEY = '';
      process.env.GITHUB_WEBHOOK_SECRET = '';
      process.env.OPENAI_API_KEY = '';

      const errors = validateConfig();
      expect(errors.length).toBeGreaterThan(0);
      expect(errors).toContain('GITHUB_APP_ID is required');
    });
  });
});
