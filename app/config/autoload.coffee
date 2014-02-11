#| -------------------------------------------------------------------
#| AUTO-LOADER
#| -------------------------------------------------------------------
#| This file specifies which systems should be loaded by default.
#|
module.exports =

  #
  #| -------------------------------------------------------------------
  #|  Auto-load core plugins
  #| -------------------------------------------------------------------
  #| folders to add
  #|
  #
  plugins: []

  #
  #| -------------------------------------------------------------------
  #|  Auto-load core server components
  #| -------------------------------------------------------------------
  #| These are the classes located in the core/ folder.
  #|
  #
  core: ['SocketIO', 'Sessions']

  #
  #| -------------------------------------------------------------------
  #|  Auto-load library classes
  #| -------------------------------------------------------------------
  #| These are the classes located in the lib/ folder.
  #|
  #
  libraries: ['Session']

  #
  #| -------------------------------------------------------------------
  #|  Auto-load Helpers
  #| -------------------------------------------------------------------
  #| These are the mixins located in the helpers/ folder.
  #|
  #
  helpers: []

  #
  #| -------------------------------------------------------------------
  #|  Auto-load Models
  #| -------------------------------------------------------------------
  #| These are the models located in the models/ folder.
  #|
  #
  models: []

  #
  #| -------------------------------------------------------------------
  #|  Auto-load controllers
  #| -------------------------------------------------------------------
  #| These are the classes located in the controllers/ folder.
  #|
  #
  controllers: ['wines']

