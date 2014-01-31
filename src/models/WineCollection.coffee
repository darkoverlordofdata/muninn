models = require('../models')

class models.WineCollection extends Backbone.Collection
  model: models.Wine
  url: "/wines"
