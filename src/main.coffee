utils = require('./utils')
views = require('./views')
models = require('./models')

require './models/Wine'
require './models/WineCollection'
require './views/AboutView'
require './views/HeaderView'
require './views/HomeView'
require './views/Paginator'
require './views/WineView'
require './views/WineListView'
require './views/WineListItemView'


class AppRouter extends Backbone.Router

  routes:
    ""                  : "home"
    "wines"             : "list"
    "wines/page/:page"  : "list"
    "wines/add"         : "addWine"
    "wines/:id"         : "wineDetails"
    "about"             : "about"

  constructor: ->
    super
    @headerView = new views.HeaderView()
    $(".header").html @headerView.el

  home: (id) ->
    @homeView = new views.HomeView()  unless @homeView
    $("#content").html @homeView.el
    @headerView.selectMenuItem "home-menu"

  list: (page) ->
    p = if page then parseInt(page, 10) else 1
    wineList = new models.WineCollection()
    wineList.fetch success: ->
      $("#content").html new views.WineListView(model: wineList, page: p).el

    @headerView.selectMenuItem "home-menu"

  wineDetails: (id) ->
    wine = new models.Wine(_id: id)
    wine.fetch success: ->
      $("#content").html new views.WineView(model: wine).el

    @headerView.selectMenuItem()

  addWine: ->
    wine = new models.Wine()
    $("#content").html new views.WineView(model: wine).el
    @headerView.selectMenuItem "add-menu"

  about: ->
    @aboutView = new views.AboutView()  unless @aboutView
    $("#content").html @aboutView.el
    @headerView.selectMenuItem "about-menu"


utils.loadTemplate [
  "HomeView"
  "HeaderView"
  "WineView"
  "WineListItemView"
  "AboutView"
], ->
  new AppRouter
  Backbone.history.start()

