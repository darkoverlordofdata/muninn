views = require('../views')

class views.Paginator extends Backbone.View

  className: "pagination pagination-centered"

  constructor: (@options) ->
    super
    @model.bind "reset", @render, @
    @render()

  render: ->
    items = @model.models
    len = items.length
    pageCount = Math.ceil(len / 8)
    $(@el).html "<ul />"
    i = 0

    while i < pageCount
      $("ul", @el).append "<li" + ((if (i + 1) is @options.page then " class='active'" else "")) + "><a href='#wines/page/" + (i + 1) + "'>" + (i + 1) + "</a></li>"
      i++
    @
