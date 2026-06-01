import { AIService } from '../../src/services/ai.service';
import { FileChange } from '../../src/types';

describe('AIService', () => {
  let service: AIService;

  beforeEach(() => {
    service = new AIService();
  });

  describe('filterFiles', () => {
    it('should skip lock files', () => {
      const files: FileChange[] = [
        {
          filename: 'package-lock.json',
          status: 'modified',
          additions: 100,
          deletions: 50,
        },
      ];

      const filtered = (service as any).filterFiles(files);
      expect(filtered).toHaveLength(0);
    });

    it('should skip files with unsupported languages', () => {
      const files: FileChange[] = [
        {
          filename: 'test.xyz',
          status: 'added',
          additions: 10,
          deletions: 0,
          language: 'unknown',
        },
      ];

      const filtered = (service as any).filterFiles(files);
      expect(filtered).toHaveLength(0);
    });

    it('should include TypeScript files', () => {
      const files: FileChange[] = [
        {
          filename: 'src/app.ts',
          status: 'added',
          additions: 50,
          deletions: 0,
          language: 'typescript',
        },
      ];

      const filtered = (service as any).filterFiles(files);
      expect(filtered).toHaveLength(1);
    });
  });

  describe('shouldSkipFile', () => {
    it('should skip .map files', () => {
      const result = (service as any).shouldSkipFile('dist/app.js.map');
      expect(result).toBe(true);
    });

    it('should skip minified files', () => {
      const result = (service as any).shouldSkipFile('dist/app.min.js');
      expect(result).toBe(true);
    });

    it('should skip node_modules', () => {
      const result = (service as any).shouldSkipFile('node_modules/package/index.js');
      expect(result).toBe(true);
    });

    it('should not skip source files', () => {
      const result = (service as any).shouldSkipFile('src/app.ts');
      expect(result).toBe(false);
    });
  });
});
