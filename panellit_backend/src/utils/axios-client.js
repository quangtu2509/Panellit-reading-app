const axios = require('axios');
const axiosRetry = require('axios-retry').default;

const axiosClient = axios.create({
  timeout: 10000,
});

// Implement Exponential Backoff for resiliency (specifically for 429 Too Many Requests)
axiosRetry(axiosClient, {
  retries: 3,
  retryDelay: (retryCount) => {
    console.log(`Retry attempt: ${retryCount}`);
    return axiosRetry.exponentialDelay(retryCount);
  },
  retryCondition: (error) => {
    // Retry on 429 (Too Many Requests) or network errors
    return (
      axiosRetry.isNetworkOrIdempotentRequestError(error) ||
      (error.response && error.response.status === 429)
    );
  },
});

module.exports = axiosClient;
