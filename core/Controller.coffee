#+--------------------------------------------------------------------+
#| controller.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of Frodo
#|
#| Frodo is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
#	Controller
#
muninn = require('../muninn')

class muninn.core.Controller

  constructor: (@req, @res, @next) ->

