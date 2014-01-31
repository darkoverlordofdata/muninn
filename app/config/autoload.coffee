#| -------------------------------------------------------------------
#| AUTO-LOADER
#| -------------------------------------------------------------------
#| This file specifies which systems should be loaded by default.
#|
module.exports =

  #
  #| -------------------------------------------------------------------
  #|  Auto-load controllers
  #| -------------------------------------------------------------------
  #| These are the classes located in the app/controllers folder.
  #|
  #
  controllers: ['wines']

  #
  #| -------------------------------------------------------------------
  #|  Auto-load Libraries
  #| -------------------------------------------------------------------
  #| These are the classes located in the app/lib folder.
  #|
  #
  libraries: ['SocketIO']