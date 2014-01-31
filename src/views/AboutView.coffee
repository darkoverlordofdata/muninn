views = require('../views')

class views.AboutView extends Backbone.View

  constructor: (@options) ->
    super
    @render()

  render: ->
    $(@el).html @template.render()
    @

