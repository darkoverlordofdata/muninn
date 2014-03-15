#+--------------------------------------------------------------------+
#| Connect.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2012 - 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of Exspresso
#|
#| Exspresso is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+

muninn = require('../muninn')
#
#	Connect driver
#
#   An adapter to the connect server instance
#   adds render support for views
#   registers all of our middleware in the right order
#   exposes an adapter registration point for sessions
#
class muninn.core.Server

  dispatch  = require('dispatch')           # URL dispatcher for Connect
  fs        = require("fs")                 # File system
  os        = require('os')                 # operating-system related utility functions
  path      = require('path')               # path utils
  ect       = require('ect')                # CoffeeScript template engine

  protocol = ($secure) -> if $secure then 'https' else 'http'
  ucfirst = ($str) -> $str.charAt(0).toUpperCase() + $str.substr(1)

  #
  # @property [String] http driver: connect
  #
  driver: 'express'
  #
  # @property [Object] app
  #
  app: null
  #
  # @property [system.core.config] configuration 
  #
  config: null
  #
  # @property [String] driver version
  #
  version: '0.0.1'

  #
  # inner class Vars
  #
  class Vars

    #
    # Provides variables to a view
    #
    # @param  [Array] args  a list of hash to merge into this
    #
    constructor: ($args...) ->

      for $data in $args
        for $key, $val of $data
          @[$key] = $val

  #
  # Set the server instance
  #
  # @return [Void]
  #
  constructor: (@config, $driver = 'express') ->

    muninn.logMessage 'debug', "%s Driver Initialized", ucfirst(@driver)

    @driver = require($driver)
    $version = ucfirst($driver)+' v'+@version
    @version = $version

  start: ($middleware) ->
    @app = @driver()
    #
    # properties
    #
    @app.set 'port', @config.port
    @app.set 'views', @config.views
    @app.set 'view engine', @config.ext.replace('.','')

    #
    # templates
    #
    @app.engine @config.ext, ect(watch: @config.watch, root: @config.views, ext : @config.ext).render

    #
    # middleware
    #
    @app.use @driver.static(@config.www)
    @app.use @driver.favicon()
    @app.use @driver.logger(@config.logger)
    @app.use @driver.json()
    @app.use @driver.urlencoded()
    @app.use @driver.methodOverride()
    @app.use @driver.bodyParser()
    @app.use @driver.cookieParser()
    @app.use @driver.cookieSession(secret: @config.encryption_key)


    #
    # development only
    #
    if 'development' is @app.get('env')
      @app.use @driver.errorHandler()

    @app.use ($req, $res, $next) =>

      #
      # Represent
      #
      $res.setHeader 'X-Powered-By', "Muninn/#{@version}"
      #
      # get the base url?
      #
      if (muninn.config.base_url or '') is ''
        muninn.config.base_url = protocol($req.connection.encrypted)+'://'+ $req.headers['host']

      $next()

    #
    # Custom middleware?
    #
    if $middleware?
      if Array.isArray($middleware)
        for m in $middleware
          @app.use m
      else
        @app.use $middleware

    @app.use muninn.err.exceptionHandler()
    #
    # Set dispatch routing
    #
    @app.use dispatch(muninn.setRoutes(@config.autoload.controllers))
    @app.use ($err, $req, $res, $next) -> muninn.showError $err
    @app.use ($req, $res, $next) -> muninn.show404 $req.originalUrl

    #
    # Careful with that axe, Eugene
    #
    @app.listen @config.port, @config.ip, =>

      console.log "listening on port http://%s:%d", @config.ip, @config.port



  #
  # Set view helpers
  #
  # Sets the autoloaded helpers on the Variables class
  # prototype. This makes them global to all views.
  #
  # @param  [Object] helpers hash of helpers to add
  # @return [Object] the helpers hash
  #
  setHelpers: ($helpers) ->
    for $key, $val of $helpers
      Vars::[$key] = $val
    $helpers

