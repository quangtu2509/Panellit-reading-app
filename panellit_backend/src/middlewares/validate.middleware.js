const { ZodError } = require('zod');

/**
 * Creates an Express middleware that validates req.body against a Zod schema.
 * On failure → responds immediately with HTTP 400 and a list of error details.
 * On success → calls next() so the controller can proceed.
 *
 * @param {import('zod').ZodTypeAny} schema - The Zod schema to validate against.
 * @returns {import('express').RequestHandler}
 */
function validate(schema) {
  return (req, res, next) => {
    try {
      // parse() throws ZodError on invalid data
      req.body = schema.parse(req.body);
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        // Map ZodError issues to a clean array: [{ field, message }]
        const errors = error.issues.map((issue) => ({
          field: issue.path.join('.') || 'body',
          message: issue.message,
        }));
        return res.status(422).json({ status: 'fail', errors });
      }
      // Unexpected error – pass to global error handler
      next(error);
    }
  };
}

module.exports = { validate };
