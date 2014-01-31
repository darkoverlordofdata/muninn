views = require('../views')

class views.WineListView extends Backbone.View

  constructor: (@options) ->
    super
    @render()

  render: ->
    wines = @model.models
    len = wines.length
    startPos = (@options.page - 1) * 8
    endPos = Math.min(startPos + 8, len)
    $(@el).html "<ul class=\"thumbnails\"></ul>"
    i = startPos

    while i < endPos
      $(".thumbnails", @el).append new views.WineListItemView(model: wines[i]).render().el
      i++
    $(@el).append new views.Paginator(
      model: @model
      page: @options.page
    ).render().el
    @

