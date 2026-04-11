import { describe, it, expect, vi, beforeEach } from 'vitest';
import { z } from 'zod';
import { getExperienceCollection, experienceSchema, sortExperiencesByDate } from './experience';

vi.mock('astro:content', () => ({
  getCollection: vi.fn(),
}));

import { getCollection } from 'astro:content';

const mockGetCollection = getCollection as ReturnType<typeof vi.fn>;

describe('Experience Content Collection', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe('experienceSchema', () => {
    it('parses valid experience data', () => {
      const validData = {
        role: 'Senior Developer',
        company_name: 'Minimalist Studio',
        period_start: '2022-01',
        period_end: null,
        description: 'Building quiet software.',
      };

      const result = experienceSchema.parse(validData);
      expect(result).toEqual(validData);
    });

    it('throws validation error when company_name is missing', () => {
      const invalidData = {
        role: 'Senior Developer',
        company_name: '',
        period_start: '2022-01',
        period_end: null,
        description: 'Building quiet software.',
      };

      expect(() => experienceSchema.parse(invalidData)).toThrow();
    });

    it('throws validation error when role is missing', () => {
      const invalidData = {
        role: '',
        company_name: 'Minimalist Studio',
        period_start: '2022-01',
        period_end: null,
        description: 'Building quiet software.',
      };

      expect(() => experienceSchema.parse(invalidData)).toThrow();
    });

    it('throws validation error when period_start is missing', () => {
      const invalidData = {
        role: 'Senior Developer',
        company_name: 'Minimalist Studio',
        period_start: '',
        period_end: null,
        description: 'Building quiet software.',
      };

      expect(() => experienceSchema.parse(invalidData)).toThrow();
    });
  });

  describe('getExperienceCollection', () => {
    it('fetches and returns experience entries', async () => {
      const mockEntries = [
        {
          id: '1',
          data: {
            role: 'Senior Developer',
            company_name: 'Minimalist Studio',
            period_start: '2022-01',
            period_end: null,
            description: 'Building quiet software.',
          },
        },
        {
          id: '2',
          data: {
            role: 'Frontend Developer',
            company_name: 'Quiet Collective',
            period_start: '2018-01',
            period_end: '2020-12',
            description: 'Crafting interfaces.',
          },
        },
      ];

      mockGetCollection.mockResolvedValue(mockEntries);

      const result = await getExperienceCollection();

      expect(mockGetCollection).toHaveBeenCalledWith('experience');
      expect(result).toEqual(mockEntries);
    });

    it('throws error when collection fetch fails', async () => {
      mockGetCollection.mockRejectedValue(new Error('Collection not found'));

      await expect(getExperienceCollection()).rejects.toThrow('Collection not found');
    });
  });

  describe('sortExperiencesByDate', () => {
    it('sorts experiences by period_start in descending order (newest first)', () => {
      const experiences = [
        { data: { period_start: '2020-01', period_end: '2022-12' } },
        { data: { period_start: '2022-01', period_end: null } },
        { data: { period_start: '2018-01', period_end: '2020-12' } },
      ];

      const sorted = sortExperiencesByDate(experiences);

      expect(sorted[0].data.period_start).toBe('2022-01');
      expect(sorted[1].data.period_start).toBe('2020-01');
      expect(sorted[2].data.period_start).toBe('2018-01');
    });

    it('places null period_end (current job) before fixed end dates', () => {
      const experiences = [
        { data: { period_start: '2020-01', period_end: '2022-12' } },
        { data: { period_start: '2023-01', period_end: null } },
      ];

      const sorted = sortExperiencesByDate(experiences);

      expect(sorted[0].data.period_end).toBeNull();
      expect(sorted[1].data.period_end).toBe('2022-12');
    });

    it('returns empty array when input is empty', () => {
      const sorted = sortExperiencesByDate([]);
      expect(sorted).toEqual([]);
    });
  });
});