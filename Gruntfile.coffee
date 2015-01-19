module.exports = (grunt) ->

  grunt.initConfig
    s3:
      options:
        key: process.env.TOBOBROWSE_AWS_ACCESS_KEY_ID
        secret: process.env.TOBOBROWSE_AWS_SECRET_ACCESS_KEY
        bucket: process.env.TOBOBROWSE_AWS_BUCKET
        region: process.env.TOBOBROWSE_AWS_REGION
        gzip: true

      deploy:
        upload: [
            # make sure this document is newer than the one on S3 and replace it
            src: 'dist/**/*'
            rel: 'dist/'
        ]

    exec:
      build:
        cmd: (environment) ->
          environment ?= 'development'
          "ember build --environment #{environment}"

  grunt.loadNpmTasks('grunt-s3')
  grunt.loadNpmTasks('grunt-exec')

  gruntAlias = (name, description, origName, defaultSuffix) ->
    grunt.task.registerTask name, description, ->
      args = Array.prototype.slice.call(arguments)

      suffix = if args.length > 0
        ":" + args.join(':')
      else if defaultSuffix?
        ":#{defaultSuffix}"
      else ""

      if typeof origName == 'object'
        for task in origName
          grunt.task.run (task + suffix)
      else
        grunt.task.run (origName + suffix)

  gruntAlias 'build', 'Build the app', 'exec:build'

  gruntAlias 'deploy', 'Deploy to S3', ['exec:build:production', 's3:deploy']
