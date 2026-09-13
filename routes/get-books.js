import { Router } from 'express';
import { z } from 'zod';
import { rateLimiter } from '../middleware/rate-limit.js';
import { Book } from '../models/book.js';

const router = Router();

const querySchema = z.object({
  limit: z.coerce.number().int().positive().optional(),
  offset: z.coerce.number().int().nonnegative().optional(),
});

router.get('/get-books', rateLimiter, (req, res) => {
  const result = querySchema.safeParse(req.query);

  if (!result.success) {
    return res.status(400).json({ data: null, error: result.error.flatten() });
  }

  const books = Book.find(result.data);
  res.json({ data: books, error: null });
});

export default router;
