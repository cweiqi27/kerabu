import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    environment: 'node',
    globals: true,
    include: ['src/lib/**/*.test.ts'],
    exclude: ['node_modules/**'],
  },
  server: {
    host: '127.0.0.1',
  },
});