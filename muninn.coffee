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
fs = require('fs')
path = require('path')
format = require('util').format

class muninn

  #
  # set the environment
  #
  @ENVIRONMENT = process.env.ENVIRONMENT ? process.env.NODE_ENV ? 'development'

  #
  #  The coffee-script file extension
  #
  @EXT = '.coffee'

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
  # muninn.core.Log object
  #
  @log = null

  #
  # muninn.core.Config object
  #
  @config = null

  @init = ($root = __dirname, $app = 'app', $www = 'www', $mod = '') ->
    muninn.APPPATH = path.join($root, $app, '/')
    muninn.DOCPATH = path.join($root, $www, '/')
    muninn.MODPATH = if $mod is '' then '' else path.join($root, $mod, '/')


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


class muninn.controllers

class muninn.models

class muninn.core

module.exports = muninn

require './core/Controller'
require './core/Exceptions'
require './core/Log'
