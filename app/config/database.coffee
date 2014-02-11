#| -------------------------------------------------------------------
#| DATABASE
#| -------------------------------------------------------------------
#| This file specifies which systems should be loaded by default.
#|

module.exports =

  'connect-mongo':
    db: 'muninn'

  'mongo':
    driver: 'mongodb'
    host: 'localhost'
    port: 27017
    auto_reconnect: true

  pg:
    host: '127.0.0.1'
    user: 'postgres'
    password: 'barsoom'
    database: 'wines'
    charset: 'utf8'