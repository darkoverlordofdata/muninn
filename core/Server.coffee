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
  Facebook  = require("facebook-node-sdk")  # Node.js SDK for the Facebook API

  protocol = ($secure) -> if $secure then 'https' else 'http'

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
  version: ''

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

    muninn.logMessage 'debug', "%s Driver Initialized", @driver

    @driver = require($driver)
    $version = $driver+' v'+@driver.version
    @version = $version

  start: ->
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
    @app.use @driver.session(secret: @config.encryption_key)

    @app.use Facebook.middleware
      appId: @config.fb.appId
      secret: @config.fb.secret

    #
    # development only
    #
    if 'development' is @app.get('env')
      @app.use @driver.errorHandler()

    @app.use muninn.err.exceptionHandler()
    #
    # Set dispatch routing
    #
    @app.use dispatch(muninn.setRoutes(@config.autoload.controllers))
    @app.use ($err, $req, $res, $next) -> muninn.showError $err
    @app.use ($req, $res, $next) -> muninn.show404 $req.originalUrl

    #
    # Start up
    #
    @app.listen @config.port, @config.ip, =>

      console.log "listening on port http://%s:%d", @config.ip, @config.port


    @app.use ($req, $res, $next) =>

      #
      # Represent
      #
      $res.setHeader 'X-Powered-By', "Muninn/#{@controller.version}"
      #
      # get the base url?
      #
      if @config.base_url or '' is ''
        @config.base_url = protocol($req.connection.encrypted)+'://'+ $req.headers['host']

      #
      # Send JSON
      #
      # Send object as JSON
      #
      # @private
      # @param [Object] data  hash of variables to render with template
      # @return [Void]
      #
      $res.json = ($data = {}) ->
        $res.writeHead 200,
          'Content-Type'    : 'application/json; charset=utf-8'
        $res.end JSON.stringify($data)
        return

      #
      # Redirect
      #
      # Redirect to another url
      #
      # @private
      # @param [String] url url to redirect to
      # @param [String] type  location | refresh
      # @param [String] url url to redirect to
      # @return [Void]
      #
      $res.redirect = ($url, $type='location', $status = 302) ->

        switch $type
          when 'refresh'
            $res.writeHead $status,
              Refresh: 0
              url: $url
            $res.end null
          else
            $res.writeHead $status,
              Location: $url
            $res.end null



      #
      # Render the view
      #
      # Create a new Variable instance to merge the $data param
      # with the flashdata, as well as the config values and
      # helpers that have been added to the prototype
      #
      # @private
      # @param [String] view  path to view template
      # @param [Object] data  hash of variables to render with template
      # @param [Funcion] next optional async callback
      # @return [Void]
      #
      $res.render = ($view, $data = {}, $next) ->
        if typeof $data is 'function' then [$data, $next] = [{}, $data]

        # if it's not a filename, then directly render partial
        if Array.isArray($view)

          $html = $render.eco($view.join(''), new Vars($data))
          return $next(null, $html)

        if not fs.existsSync($view)
          return show_error('Unable to load the requested file: %s', $view)
        #
        # Default terminal next
        #
        $next = $next ? ($err, $str) ->
          return $next($err) if $err
          $res.writeHead 200,
            'Content-Length'  : $str.length
            'Content-Type'    : 'text/html; charset=utf-8'
          $res.end $str
          return

        #
        # Read in the view file
        #
        fs.readFile $view, 'utf8', ($err, $str) ->
          return $next($err) if $err
          $ext = path.extname($view).replace('.','')

          if $render[$ext]?

            try
              $next(null, $render[$ext]($str, new Vars($data, filename: $view, flashdata: $res.flashdata)))

            catch $err
              show_error $err

          else show_error 'Invalid view file type: %s (%s)', $ext, $view

      $next()



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

