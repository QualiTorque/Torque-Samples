// Lambda function code

module.exports.handler = async (event) => {
  console.log('Event: ', event);
  let responseMessage = 'Hello, Someone!';

  if (event.queryStringParameters && event.queryStringParameters['Name']) {
    responseMessage = 'This is the part of the new APIs code: ' + event.queryStringParameters['Name'] + '!';
  }

  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message: responseMessage,
    }),
  }
}
