/**
 * Lambda Entry Point
 * 
 * This is the neutral adapter layer between AWS Lambda and the command dispatcher.
 * It handles the Lambda event/context contract and delegates to commands.js.
 */

const commands = require('./commands');

/**
 * Lambda handler function
 * @param {object} event - API Gateway event
 * @param {object} context - Lambda context (unused but available)
 * @returns {Promise<object>} HTTP response
 */
exports.handler = async (event, context) => {
  return commands.handler(event, context);
};
