views = require('../views')

class views.HeaderView extends Backbone.View

  constructor: (@options) ->
    super
    @render()

  render: ->
    $(@el).html @template.render()
    @

  selectMenuItem: (menuItem) ->
    $(".nav li").removeClass "active"
    $("." + menuItem).addClass "active"  if menuItem

