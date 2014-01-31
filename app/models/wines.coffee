#+--------------------------------------------------------------------+
#| models/wines.coffee
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
# Wines controller
#

config  = require('../config').database.mongo

module.exports = class WinesModel

  mongo   = require(config.driver)
  Server  = mongo.Server
  Db      = mongo.Db
  BSON    = mongo.BSONPure
  server  = new Server(config.host, config.port, auto_reconnect: true)
  db      = new Db("winedb", server, safe: true)

  db.open (err, db) ->
    unless err
      console.log "Connected to 'winedb' database"
      db.collection "wines", safe: true, (err, collection) ->
        if err
          console.log "The 'wines' collection doesn't exist. Creating it with sample data..."
          wines = require('./wines/data')
          db.collection "wines", (err, collection) ->
            collection.insert wines, safe: true, (err, result) ->


  id: ($id) ->
    new BSON.ObjectID($id)

  collection: ($next) ->
    db.collection "wines", $next

