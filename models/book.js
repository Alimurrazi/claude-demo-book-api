const books = [
  { id: 1, title: 'The Pragmatic Programmer', author: 'David Thomas' },
  { id: 2, title: 'Clean Code', author: 'Robert C. Martin' },
  { id: 3, title: 'The Hobbit', author: 'J.R.R. Tolkien' },
];

export const Book = {
  find({ limit, offset } = {}) {
    const start = offset ?? 0;
    const end = limit !== undefined ? start + limit : undefined;
    return books.slice(start, end);
  },
};
