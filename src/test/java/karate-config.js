function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);

  if (!env) {
    env = 'dev';
  }

  var config = {
      apiUrl: 'https://conduit-api.bondaracademy.com/api/',
    }

  if (env == 'dev') {
      config.userEmail = 'sampleemail@master.com';
      config.userPassword = 'mastercarlo0987123!?';
  } else if (env == 'qa') {
      config.userEmail = 'emailsample@gmail.com';
      config.userPassword = 'mastercarlo0987123!?';
  }

  var result = karate.callSingle('classpath:helpers/CreateToken.feature', config);
  config.authToken = result.token; 
  karate.configure('headers', { Authorization: 'Token ' + config.authToken });
  karate.configure('logPrettyRequest', true);
  karate.configure('logPrettyResponse', true);
  return config;
}