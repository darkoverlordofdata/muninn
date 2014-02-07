#+--------------------------------------------------------------------+
#| controllers/wines.coffee
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
muninn = require('muninn')

class Wines extends muninn.core.Controller

  #
  # REST API
  #
  @routes =
    'GET /wines'        : 'findAll'
    'GET /wines/:id'    : 'findById'
    'POST /wines'       : 'addWine'
    'PUT /wines/:id'    : 'updateWine'
    'DELETE /wines/:id' : 'deleteWine'

  constructor: ->
    super
    @load.model 'wines'

  #
  # Find All
  #
  findAll: () ->
    @wines.collection (err, collection) =>
      collection.find().toArray (err, items) =>
        @res.send items

  #
  # Find by Id
  #
  findById: (id) ->
    muninn.logMessage 'debug',  "Get wine: " + id
    @wines.collection (err, collection) =>
      collection.findOne _id: @wines.id(id), (err, item) =>
        @res.send item

  #
  # Add a Wine
  #
  addWine: () ->
    wine = req.body
    muninn.logMessage 'debug',  "Add wine: " + JSON.stringify(wine)
    @wines.collection (err, collection) =>
      collection.insert wine, safe: true, (err, result) =>
        if err
          res.send error: "An error has occurred"
        else
          muninn.logMessage 'debug',  "Success: " + JSON.stringify(result[0])
          @res.send result[0]

  #
  # Update a Wine
  #
  updateWine: (id) ->
    wine = @req.body
    delete wine._id

    muninn.logMessage 'debug',  "Update wine: " + id
    muninn.logMessage 'debug',  JSON.stringify(wine)
    @wines.collection (err, collection) =>
      collection.update _id: @wines.id(id), wine, safe: true, (err, result) =>
        if err
          muninn.logMessage 'debug',  "Error updating wine: " + err
          @res.send error: "An error has occurred"
        else
          muninn.logMessage 'debug',  "" + result + " document(s) updated"
          @res.send wine

  #
  # Delete a Wine
  #
  deleteWine: (id) ->
    muninn.logMessage 'debug',  "Delete wine: " + id
    @wines.collection (err, collection) =>
      collection.remove _id: @wines.id(id), safe: true, (err, result) =>
        if err
          @res.send error: "An error has occurred - " + err
        else
          muninn.logMessage 'debug',  "" + result + " document(s) deleted"
          @res.send @req.body





module.exports = Wines
