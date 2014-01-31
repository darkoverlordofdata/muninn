views = require('../views')

class views.HomeView extends Backbone.View

  constructor: (@options) ->
    super
    @render()

  render: ->
    $(@el).html @template.render()
    @
