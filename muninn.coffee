#+--------------------------------------------------------------------+
#| muninn.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of Muninn
#|
#| Muninn is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# muninn framework
#

class muninn

  fs        = require("fs")                 # File system
  os        = require('os')                 # operating-system related utility functions
  path      = require('path')               # path utils
  format    = require('util').format

  _log = null
  _err = null

  Object.defineProperties @,

    log: get: ->
      _log = new muninn.core.Log unless _log?
      _log

    err: get: ->
      _err = new muninn.core.Exceptions unless _err?
      _err

  #
  # set the environment
  #
  @ENVIRONMENT = process.env.ENVIRONMENT ? process.env.NODE_ENV ? 'development'

  #
  #  Path to the system folder
  #
  @SYSPATH = __dirname

  #
  # The path to the application folder
  #
  @APPPATH = path.join(__dirname, 'app/')

  #
  # The path to the static assets folder
  #
  @DOCPATH = path.join(__dirname, 'www/')

  #
  # The path to the modules folder
  #
  @MODPATH = ''

  #
  # Init
  #
  # @param  [String]  root  app root
  # @param  [String]  app   app folder
  # @param  [String]  www   static assets folder
  # @param  [String]  mod   module folder
  # @return [Object] configuration hash
  #
  @init = ($root = __dirname, $app = 'app', $www = 'www', $mod = '') ->

    muninn.APPPATH = path.join($root, $app, '/')
    muninn.DOCPATH = path.join($root, $www, '/')
    muninn.MODPATH = if $mod is '' then '' else path.join($root, $mod, '/')
    muninn.config = require(path.join(muninn.APPPATH, 'config'))

  #
  # Start the server
  #
  @start = ($middleware...) ->
    server = new muninn.core.Server(muninn.config)
    server.start $middleware

  #
  # Set Routes
  #
  # @param  [Class]  Controller class
  # @return [Void] none
  #
  @setRoutes = (controllers) ->
    routes = {}
    for name in controllers
      Controller = require(path.join(muninn.APPPATH, "/controllers/#{name}"))
      for $route, $method of Controller.routes
        # Wrap each route in a closure
        do (Controller, $route, $method) ->
          routes[$route] = ($req, $res, $next, $args...) ->
            (new Controller($req, $res, $next))[$method]($args...)
    routes

  #
  # Error Handler
  #
  # This function lets us invoke the exception class and
  # display errors using the standard error template located
  # in application/errors/5xx.eco
  # This function will send the error page directly to the
  # browser and exit.
  #
  # @param  [Array] args  the argment array
  # @return [Boolean] true
  #
  @showError = ($args...) ->
    return false unless $args[0]?

    if typeof $args[0] is 'string'
      muninn.err.show5xx format.apply(undefined, $args), '5xx', 500
    else
      muninn.err.show5xx $args[0], '5xx', 500

  #
  # 404 Page Handler
  #
  # This function is similar to the show_error() function above
  # However, instead of the standard error template it displays
  # 404 errors.
  #
  # @param  [Array] args  the argment array
  # @param  [Boolean] log_error write to log
  # @return [Boolean] true
  #
  @show404 = ($page = '', $log_error = true) ->
    muninn.err.show404 $page, $log_error

  #
  # Error Logging Interface
  #
  # We use this as a simple mechanism to access the logging
  # class and send messages to be logged.
  #
  # @param [String] level the logging level: error | debug | info
  # @param [Array]  args  the remaining args match the sprintf signature
  # @return [Boolean] true
  #
  @logMessage = ($level = 'error', $args...) ->
    return true if muninn.config.log_threshold is 0
    muninn.log.write $level, format.apply(undefined, $args)





class muninn.controllers

class muninn.models

class muninn.core

module.exports = muninn

require './core/Controller'
require './core/Exceptions'
require './core/Log'
require './core/Server'
