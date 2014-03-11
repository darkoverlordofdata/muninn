#+--------------------------------------------------------------------+
#| Log.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2012 - 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of Muninn
#|
#| Muninn is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+

muninn = require('../muninn')
#
# Logger class
#
class muninn.core.Log


  fs = require('fs')
  path = require('path')
  moment = require('moment')

  _enabled        : true                # Use logging?
  _log_path       : ''                  # Path to the log file
  _threshold      : 1                   # Current threshhold level
  _date_fmt       : 'YYYY-MM-DD H:m:s'  # Date format
  _levels:                              # Threshold Levels:
    ERROR         : 1                   #   log only errors
    DEBUG         : 2                   #   log errors and debug entries
    INFO          : 3                   #   log everything

  isDir = ($path) -> fs.existsSync($path) and fs.statSync($path).isDirectory()
  #
  # Load configuration
  #
  constructor: () ->

    $config = muninn.config

    @_log_path  = $config.log_path or path.join(muninn.APPPATH, 'logs/')
    @_enabled   = false if not isDir(@_log_path) #or not is_really_writable(@_log_path)
    @_threshold = parseInt($config.log_threshold, 10)
    @_date_fmt  = $config.log_date_format if $config.log_date_format isnt ''


  #
  # Write Log File
  #
  # Generally this function will be called using the global log_message() function
  #
  # @param  [String]  level the error level
  # @param  [String]  msg the error message
  # @return	[Boolean] always returns true
  #
  write: ($level = 'error', $msg) ->

    $level = $level.toUpperCase()

    return false unless @_levels[$level]?
    return false if parseInt(@_levels[$level]) > parseInt(@_threshold)
    $d = moment().format(@_date_fmt)
    $message = $level + (if $level is 'INFO' then ' ' else '') + ' ' + $d + ' -->' + $msg
    console.log $message

    if @_enabled
      try

        $filepath = @_log_path + 'log-' + $d.split(' ')[0] + '.log'
        fs.appendFile $filepath, $message+"\n", ($err) =>
          @_enabled = false if $err?

      catch $err
        @_enabled = false

    true
