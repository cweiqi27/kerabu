import { defineCollection, z } from 'astro:content';

const experienceSchema = z.object({
  role: z.string().min(1, 'Role is required'),
  company_name: z.string().min(1, 'Company name is required'),
  period_start: z.string().min(1, 'Start date is required'),
  period_end: z.string().nullable(),
  description: z.string().optional(),
});

export const collections = {
  experience: defineCollection({
    type: 'content',
    schema: experienceSchema,
  }),
};