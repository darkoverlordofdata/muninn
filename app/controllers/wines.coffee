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

module.exports = class Wines extends muninn.core.Controller

  constructor: ->
    @model 'wines'


  routes: ->
    'GET /wines'        : @findAll
    'GET /wines/:id'    : @findById
    'POST /wines'       : @addWine
    'PUT /wines/:id'    : @updateWine
    'DELETE /wines/:id' : @deleteWine

  #
  # API
  #
  findAll: (req, res, next) =>
    @wines.collection (err, collection) =>
      collection.find().toArray (err, items) =>
        res.send items

  findById: (req, res, next, id) =>
    console.log "Retrieving wine: " + id
    @wines.collection (err, collection) =>
      collection.findOne _id: @wines.id(id), (err, item) =>
        res.send item

  addWine: (req, res, next) =>
    wine = req.body
    console.log "Adding wine: " + JSON.stringify(wine)
    @wines.collection (err, collection) =>
      collection.insert wine, safe: true, (err, result) =>
        if err
          res.send error: "An error has occurred"
        else
          console.log "Success: " + JSON.stringify(result[0])
          res.send result[0]

  updateWine: (req, res, next, id) =>
    wine = req.body
    delete wine._id

    console.log "Updating wine: " + id
    console.log JSON.stringify(wine)
    @wines.collection (err, collection) =>
      collection.update _id: @wines.id(id), wine, safe: true, (err, result) =>
        if err
          console.log "Error updating wine: " + err
          res.send error: "An error has occurred"
        else
          console.log "" + result + " document(s) updated"
          res.send wine

  deleteWine: (req, res, next, id) =>
    console.log "Deleting wine: " + id
    @wines.collection (err, collection) =>
      collection.remove _id: @wines.id(id), safe: true, (err, result) =>
        if err
          res.send error: "An error has occurred - " + err
        else
          console.log "" + result + " document(s) deleted"
          res.send req.body

