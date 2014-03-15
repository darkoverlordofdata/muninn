path      = require('path')
#| -------------------------------------------------------------------
#| CONFIGURATION
#| -------------------------------------------------------------------
#|
#| Configuration root
#|
module.exports =

  #|
  #|--------------------------------------------------------------------------
  #| HTTP IP
  #|--------------------------------------------------------------------------
  #|
  #|  ip to serve http
  #|
  ip:     process.env.OPENSHIFT_NODEJS_IP or "127.0.0.1"

  #|
  #|--------------------------------------------------------------------------
  #| HTTP Port
  #|--------------------------------------------------------------------------
  #|
  #|  port to serve http
  #|
  port:   process.env.OPENSHIFT_NODEJS_PORT or 0xd16a

  #|--------------------------------------------------------------------------
  #| views
  #|--------------------------------------------------------------------------
  #|
  #|  folder root to serve dynamic pages
  #|
  views:  path.join(__dirname, '..', 'views')

  #|
  #|--------------------------------------------------------------------------
  #| watch views?
  #|--------------------------------------------------------------------------
  #|
  #|  check if view files have changed
  #|
  watch:  true

  #|--------------------------------------------------------------------------
  #| Public assets
  #|--------------------------------------------------------------------------
  #|
  #|  folder root to serve static resources
  #|
  www:    path.join(__dirname, '..', '..', 'www')

  #|
  #|--------------------------------------------------------------------------
  #| View Extension
  #|--------------------------------------------------------------------------
  #|
  #| The default view filetype that is loaded when no extension is specified
  #|
  #|
  ext:    '.ect'

  #|
  #|--------------------------------------------------------------------------
  #| Favicon
  #|--------------------------------------------------------------------------
  #|
  #| For the browser or desktop
  #|
  #|
  favicon: 'ico/favicon.png'

  #|
  #|--------------------------------------------------------------------------
  #| Encryption Key
  #|--------------------------------------------------------------------------
  #|
  #| If you use the Encryption class or the Session class you
  #| MUST set an encryption key.  See the user guide for info.
  #|
  #|
  encryption_key: process.env.CLIENT_SECRET ? 'ZAHvYIu8u1iRS6Hox7jADpnCMYKf57ex0BEWc8bM0/4='

  #|
  #|--------------------------------------------------------------------------
  #| Logging
  #|--------------------------------------------------------------------------
  #|
  #| Logging Options
  #|
  #|
  log_path: ''
  log_date_format: 'YYYY-MM-DD HH:mm:ss'
  log_threshold: 3
  #|	               0        Disables logging, Error logging TURNED OFF
  #|	               1        Error Messages (including PHP errors)
  #|	               2        Debug Messages
  #|	               3        All Messages
  #|
  logger: 'tiny'
  #|                 default  Verbose output
  #|                 short    Consise output
  #|                 tiny     Terse output
  #|                 dev      Colorized version of tiny
  #|

  #|--------------------------------------------------------------------------
  #| Autoload
  #|--------------------------------------------------------------------------
  #|
  #|  Hash of classes/modules to autoload
  #|
  autoload: require('./autoload')

  #|--------------------------------------------------------------------------
  #| Database
  #|--------------------------------------------------------------------------
  #|
  #|  Hash of database params
  #|
  database: require('./database')

  #|--------------------------------------------------------------------------
  #| Theme
  #|--------------------------------------------------------------------------
  #|
  #|  Hash of theming config
  #|
  theme: require('./theme')

