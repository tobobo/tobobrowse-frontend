/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'tobobrowse-frontend',
    environment: environment,
    baseURL: '/',
    locationType: 'auto',
    transmissionURL: 'http://pork.whatbox.ca:33304',
    backendURL: 'http://pork.whatbox.ca:8000/',
    httpURL: 'https://pork.whatbox.ca/private/',
    browserURL: 'https://pork.whatbox.ca/filebrowser/',
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      }
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    }
  };

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
  }

  if (environment === 'production') {

  }

  return ENV;
};
