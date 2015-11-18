require('../../commons/view.coffee')()

$ ->
  i18n.init
    resGetPath: '/locales/__lng__/__ns__.json'
    (err, t) ->
      window.t = t
      $('html').i18n()
      document.title = t(document.title)
