/**
 * Wraps an async function to catch any errors and pass them to the next() middleware.
 * This eliminates the need for repeated try-catch blocks in controllers.
 * 
 * @param {Function} fn - The async function to wrap.
 * @returns {Function}
 */
module.exports = (fn) => {
  return (req, res, next) => {
    fn(req, res, next).catch(next);
  };
};
