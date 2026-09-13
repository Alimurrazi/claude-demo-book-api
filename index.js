import express from 'express';
import getBooksRouter from './routes/get-books.js';

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(getBooksRouter);

app.listen(PORT, () => {
  console.log(`book-api listening on port ${PORT}`);
});

export default app;
