views = require('../views')

class views.WineListItemView extends Backbone.View

  tagName: "li"

  constructor: (@options) ->
    super
    @model.bind "change", @render, @
    @model.bind "destroy", @close, @

  render: ->
    $(@el).html @template.render(@model.toJSON())
    @