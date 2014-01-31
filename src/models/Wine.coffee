models = require('../models')

class models.Wine extends Backbone.Model

  urlRoot: "/wines"
  idAttribute: "_id"

  constructor: ->
    super
    @validators = {}
    @validators.name = (value) ->
      if value.length > 0
        isValid: true
      else
        isValid: false
        message: "You must enter a name"


    @validators.grapes = (value) ->
      if value.length > 0
        isValid: true
      else
        isValid: false
        message: "You must enter a grape variety"


    @validators.country = (value) ->
      if value.length > 0
        isValid: true
      else
        isValid: false
        message: "You must enter a country"


  validateItem: (key) ->
    if (@validators[key]) then @validators[key](@get(key)) else isValid: true

  
  # TODO: Implement Backbone's standard validate() method instead.
  validateAll: ->
    messages = {}
    for key of @validators
      if @validators.hasOwnProperty(key)
        check = @validators[key](@get(key))
        messages[key] = check.message  if check.isValid is false
    if _.size(messages) > 0
      isValid: false
      messages: messages
    else isValid: true

  defaults:
    _id: null
    name: ""
    grapes: ""
    country: "USA"
    region: "California"
    year: ""
    description: ""
    picture: null

