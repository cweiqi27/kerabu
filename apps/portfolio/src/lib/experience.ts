import { z } from 'zod';
import { getCollection, type CollectionEntry } from 'astro:content';

export const experienceSchema = z.object({
  role: z.string().min(1, 'Role is required'),
  company_name: z.string().min(1, 'Company name is required'),
  period_start: z.string().min(1, 'Start date is required'),
  period_end: z.string().nullable(),
  description: z.string().optional(),
});

export type Experience = z.infer<typeof experienceSchema>;

export async function getExperienceCollection() {
  try {
    const entries = await getCollection('experience');
    return entries;
  } catch (error) {
    throw new Error(`Failed to fetch experience collection: ${error instanceof Error ? error.message : 'Unknown error'}`);
  }
}

export function sortExperiencesByDate(
  experiences: Array<{ data: { period_start: string; period_end: string | null } }>
): Array<{ data: { period_start: string; period_end: string | null } }> {
  return [...experiences].sort((a, b) => {
    const dateA = a.data.period_start;
    const dateB = b.data.period_start;

    if (a.data.period_end === null && b.data.period_end !== null) {
      return -1;
    }
    if (a.data.period_end !== null && b.data.period_end === null) {
      return 1;
    }

    return dateB.localeCompare(dateA);
  });
}