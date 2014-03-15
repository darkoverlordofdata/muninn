#+--------------------------------------------------------------------+
#  Exceptions.coffee
#+--------------------------------------------------------------------+
#  Copyright DarkOverlordOfData (c) 2012 - 2014
#+--------------------------------------------------------------------+
#
#  This file is a part of Muninn
#
#  Muninn is free software you can copy, modify, and distribute
#  it under the terms of the MIT License
#
#+--------------------------------------------------------------------+

muninn  = require('../muninn')
#
# Server Error Class
#
#   This class is used to raise a Server Error 5xx
#

class muninn.core.ServerError extends Error

  #
  # @property [String] The http status code
  #
  code: ''
  #
  # @property [String] The description of the http status code
  #
  desc: ''
  #
  # @property [String] A short description of the error condition, such as the class name
  #
  name: ''
  #
  # @property [String] The css class to use for formatting the error display
  #
  class: ''
  #
  # @property [String] A description of the actual error
  #
  message: ''
  #
  # @property [String] The stack of prior error messages, seperated by new line.
  #
  stack: ''

  #
  # Initialize the exspresso error
  #
  #
  # @param  [Object]  err the native error object to wrap
  # @param  [String]  status  http status code to associate to the error
  #
  constructor: ($err = {}, $status = 500) ->

    $err = new Error($err) if 'string' is typeof($err)
    $status = $err.status || $status

    @code     = $status
    @desc     = getStatusText($status)
    @name     = $err.name || 'Error'
    @class    = if $status >= 500 then 'error' else 'info'
    @message  = if $status is 404 then "The page you requested was not found" else $err.message || 'Unknown error'
    @stack    = '<ul>'+($err.stack || '').split('\n').slice(1).map((v) ->
      '<li>' + v + '</li>' ).join('')+'</ul>'


#
# Authorization Error Class
#
class muninn.core.AuthorizationError extends Error

  #
  # @property [String] The http status code
  #
  code: ''
  #
  # @property [String] The description of the http status code
  #
  desc: ''
  #
  # @property [String] A short description of the error condition, such as the class name
  #
  name: ''
  #
  # @property [String] The css class to use for formatting the error display
  #
  class: ''
  #
  # @property [String] A description of the actual error
  #
  message: ''
  #
  # @property [String] The stack of prior error messages, seperated by new line.
  #
  stack: ''

  #
  # Initialize the authorization error
  #
  #
  # @param  [Object]  msg the error description
  # @param  [String]  status  http status code to associate to the error
  #
  constructor: ($msg, $status = 401) ->

    @code     = $status
    @desc     = getStatusText($status)
    @name     = 'Authorization Check Failed'
    @class    = 'info'
    @message  = getStatusText($status)
    @stack    = "\nAuthorization Check Failed\n#{$msg}"


#
# Application Error Class
#
class muninn.core.AppError extends Error

#
# @property [String] The http status code
#
  code: ''
  #
  # @property [String] The description of the http status code
  #
  desc: ''
  #
  # @property [String] A short description of the error condition, such as the class name
  #
  name: ''
  #
  # @property [String] The css class to use for formatting the error display
  #
  class: ''
  #
  # @property [String] A description of the actual error
  #
  message: ''
  #
  # @property [String] The stack of prior error messages, seperated by new line.
  #
  stack: ''

  #
  # Initialize the application error
  #
  #
  # @param  [Object]  msg the error description
  # @param  [String]  status  http status code to associate to the error
  #
  constructor: ($name, $msg, $status = 401) ->

    @code     = $status
    @desc     = getStatusText($status)
    @name     = $name
    @class    = 'info'
    @message  = getStatusText($status)
    @stack    = "\n#{$name}\n#{$msg}"

#
# Exceptions Class
#
class muninn.core.Exceptions

  _Exceptions = null
  @create = ->
    if _Exceptions? then _Exceptions else _Exceptions = new Exceptions

  constructor: ->
    muninn.logMessage 'debug', "Exceptions Class Initialized"
    ect = require('ect')
    fs = require('fs')
    path = require('path')
    $root =
      layout  : String(fs.readFileSync(path.join(muninn.SYSPATH, '/errors/layout.ect')))
      '5xx'   : String(fs.readFileSync(path.join(muninn.SYSPATH, '/errors/5xx.ect')))
      '404'   : String(fs.readFileSync(path.join(muninn.SYSPATH, '/errors/404.ect')))

    @ect = new ect(root: $root, ext: '.ect')

  #
  # Exception Logger
  #
  #
  # @param  [String]  severity  the error severity
  # @param  [String]  message the error string
  # @param  [String]  filepath  the error filepath
  # @param  [String]  line  the error line number
  # @return	[Void]
  #
  logException : ($severity, $message, $filepath, $line) ->
    muninn.logMessage('error', 'Severity: ' + $severity + '  --> ' + $message + ' ' + $filepath + ' ' + $line, true)
    return

  #
  # 404 Page Not Found Handler
  #
  #   Show the custom 404 page
  #
  # @param  [String]  page  the requested url
  # @param  [String]  status_code the status/error code
  # @param  [Function]  next  callback
  # @return	[Boolean] true
  #
  show404 : ($page = '', $log_error = true) ->
    $message = "The page you requested was not found."

    #  By default we log this, but allow a dev to skip it
    if $log_error
      muninn.logMessage('error', '404 Page Not Found --> ' + $page)


    @show5xx($message, '404', 404)

  #
  # General Server Error Page
  #
  # This function takes an error message as input
  # (either as a string or an array) and displays
  # it using the specified template.
  #
  # @param  [String]  err the error object
  # @param  [String]  template  the template name
  # @param  [String]  status_code the status/error code
  # @param  [Function]  next  callback
  # @return	[Boolean] true
  #
  show5xx : ($message, $template = '5xx', $status_code = 500) ->
    # if we're here, then Exspresso is still booting...
    console.log "Exceptions::show5xx --> #{$message}"
    process.exit 1

  #
  # Native error handler
  #
  #   Displays node.js error
  #
  # @param  [String]  severity  the error severity
  # @param  [String]  message the error string
  # @param  [String]  filepath  the error filepath
  # @param  [String]  line  the error line number
  # @return	[Boolean] true
  #
  showError : ($severity, $message, $filepath, $line) ->
    # if we're here, then Exspresso is still booting...
    console.log "Exceptions::showError --> #{$message}"
    console.log " at line #{$line},  #{$filepath}"
    process.exit 1

  #
  # Exception handler
  #
  #   Middleware hook to display custom exception pages
  #
  # @param  [Object]  req the http request object
  # @param  [Object]  res the http response object
  # @param  [Function]  next  callback
  # @return [Void]
  #
  exceptionHandler: -> ($req, $res, $next) =>

    #
    # 404 Page Not Found Handler
    #
    #   Show the custom 404 page
    #
    # @param  [String]  page  the requested url
    # @param  [String]  status_code the status/error code
    # @param  [Function]  next  callback
    # @return	[Boolean] true
    #
    @show404 = ($page = '', $log_error = true, $next) =>

      if typeof $log_error is 'function'
        [$log_error, $next] = [true, $log_error]

      $err =
        status:       404
        stack:        [
          "The page you requested was not found."
          getStatusText(404)+': ' +$req.originalUrl
          ].join("\n")

      #  By default we log this, but allow a dev to skip it
      if $log_error
        muninn.logMessage('error', '404 Page Not Found --> ' + $page)

      @show5xx $err, '404', 404, $next


    #
    # General Server Error Page
    #
    # This function takes an error message as input
    # (either as a string or an array) and displays
    # it using the specified template.
    #
    # @param  [String]  err the error object
    # @param  [String]  template  the template name
    # @param  [String]  status_code the status/error code
    # @param  [Function]  next  callback
    # @return	[Boolean] true
    #
    @show5xx = ($err, $template = '5xx', $status_code = 500, $next) =>

      if typeof $template is 'function'
        [$template, $status_code, $next] = ['5xx', 500, $template]

      $error = new muninn.core.ServerError($err)

      $str = @ect.render($template, site_name: muninn.config.site_name, err: $error)
      $res.writeHead 200,
        'Content-Length'  : $str.length
        'Content-Type'    : 'text/html; charset=utf-8'
      $res.end $str
      return true


    #
    # Native error handler
    #
    #   Displays node.js error
    #
    # @param  [String]  severity  the error severity
    # @param  [String]  message the error string
    # @param  [String]  filepath  the error filepath
    # @param  [String]  line  the error line number
    # @return	[Boolean] true
    #
    @showError = ($severity, $message, $filepath, $line) ->

      $filepath = $filepath.replace(/\\/g, "/")
      #  For safety reasons we do not show the full file path
      if $filepath.indexOf('/') isnt -1
        $x = $filepath.split('/')
        $filepath = $x[$x.length - 2] + '/' + $x[$x.length - 1]

      $res.render 'errors/native',
        $severity : $severity
        $message  : $message
        $filepath : $filepath
        $line     : $line

      return true

    $next()

#
# Get HTTP Status Text
#
# @param  [Integer] code		the status code
# @param  [String]  text  alternate status text
# @return [String] the status text
#
getStatusText = ($code = 200, $text = '') ->
  $stat =
    200:'OK',
    201:'Created',
    202:'Accepted',
    203:'Non-Authoritative Information',
    204:'No Content',
    205:'Reset Content',
    206:'Partial Content',

    300:'Multiple Choices',
    301:'Moved Permanently',
    302:'Found',
    304:'Not Modified',
    305:'Use Proxy',
    307:'Temporary Redirect',

    400:'Bad Request',
    401:'Unauthorized',
    403:'Forbidden',
    404:'Not Found',
    405:'Method Not Allowed',
    406:'Not Acceptable',
    407:'Proxy Authentication Required',
    408:'Request Timeout',
    409:'Conflict',
    410:'Gone',
    411:'Length Required',
    412:'Precondition Failed',
    413:'Request Entity Too Large',
    414:'Request-URI Too Long',
    415:'Unsupported Media Type',
    416:'Requested Range Not Satisfiable',
    417:'Expectation Failed',

    500:'Internal Server Error',
    501:'Not Implemented',
    502:'Bad Gateway',
    503:'Service Unavailable',
    504:'Gateway Timeout',
    505:'HTTP Version Not Supported'

  return '' if $code is '' or  not 'number' is typeof($code)
  $text = $stat[$code] if $stat[$code]?  and $text is ''
  $text
    
