#| -------------------------------------------------------------------
#| CONFIGURATION
#| -------------------------------------------------------------------
#|
#| Configuration root
#|
module.exports =

  #|
  #|--------------------------------------------------------------------------
  #| HTTP Port
  #|--------------------------------------------------------------------------
  #|
  #|  port to serve http
  #|
  http_port: process.env.OPENSHIFT_NODEJS_PORT or process.env.PORT or 0xd16a

  #|
  #|--------------------------------------------------------------------------
  #| HTTP IP
  #|--------------------------------------------------------------------------
  #|
  #|  ip to serve http
  #|
  http_ip: process.env.OPENSHIFT_NODEJS_IP || '127.0.0.1'


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
  #|
  #|--------------------------------------------------------------------------
  #|  Logger option
  #|--------------------------------------------------------------------------
  #|
  #| default  Verbose output
  #| short    Consise output
  #| tiny     Terse output
  #| dev      Colorized version of tiny
  #|
  logger: 'dev'

  #|
  #|--------------------------------------------------------------------------
  #| Cacheing
  #|--------------------------------------------------------------------------
  #|
  #| Leave this BLANK unless you would like to set something other than the default
  #| system/cache/ folder.  Use a full server path with trailing slash.
  #|
  #|
  cache_path: ''
  cache_rules:
    '.*': 0


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
  #| Session Variables
  #|--------------------------------------------------------------------------
  #|
  #| 'sess_cookie_name'		    = cookie name
  #| 'sess_expiration'			  = seconds the session will last.
  #|                            by default sessions last 7200 seconds (two hours).
  #|                            Set to zero for no expiration.
  #| 'sess_expire_on_close'	  = true/false True causes the session to expire automatically
  #|                            when the browser window is closed
  #| 'sess_encrypt_cookie'		= true/false Encrypt the cookie?
  #| 'sess_use_database'		  = true/false Persist the session data to a database
  #| 'sess_table_name'			  = Session database table name
  #| 'sess_match_ip'			    = true/false Match the user's IP address when reading the session data?
  #| 'sess_match_useragent'	  = true/false Match the User Agent when reading the session data?
  #| 'sess_time_to_update'		= Seconds between refresh of session data
  #|
  sess_driver: 'sql'
  sess_cookie_name: 'sid'
  sess_expiration: 7200*60
  sess_expire_on_close: false
  sess_encrypt_cookie: false
  sess_use_database: false
  sess_table_name: 'sessions'
  sess_match_ip: false
  sess_match_useragent: true
  sess_time_to_update: 300

  #|
  #|--------------------------------------------------------------------------
  #| Cookie Related Variables
  #|--------------------------------------------------------------------------
  #|
  #| 'cookie_prefix' = Set a prefix if you need to avoid collisions
  #| 'cookie_domain' = Set to .your-domain.com for site-wide cookies
  #| 'cookie_path'   =  Typically will be a forward slash
  #| 'cookie_secure' =  Cookies will only be set if a secure HTTPS connection exists.
  #|
  #|
  cookie_prefix: "connect."
  cookie_domain: ""
  cookie_path: "/"
  cookie_secure: false

  #|--------------------------------------------------------------------------
  #| Public assets
  #|--------------------------------------------------------------------------
  #|
  #|  folder root to serve static resources
  #|
  public: 'www'

  #|
  #|--------------------------------------------------------------------------
  #| View Extension
  #|--------------------------------------------------------------------------
  #|
  #| The default view filetype that is loaded when no extension is specified
  #|
  #|
  view_ext: '.liquid'

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