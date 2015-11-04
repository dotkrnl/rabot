#LoginManager = require './models/loginmanager.coffee'
#LoginUI = require './views/loginui.coffee'

$ ->

  startUpStageLoad = true
  stageManager.queryStageList (result) ->
    menuHtml = ''
    for stage in result
      menuHtml += "<li class=\"stage-dropdown-item\" \
      id=\"stage-dropdown-item-#{stage.id}\"> \
      <a href=\"#\">#{stage.name}</a></li>"
    $('#stage-dropdown').html(menuHtml)

    if startUpStageLoad
      stageManager.getStage result[0].id, (result) ->
        if result.status == 'succeeded'
          game.loadStage(result.info)
      startUpStageLoad = false

    $(".stage-dropdown-item").unbind('click')
    $(".stage-dropdown-item").click ->
      arr = event.currentTarget.id.split('-')
      stageName = arr[arr.length - 1]

      stageManager.getStage stageName, (result) ->
        if result.status == 'succeeded'
          game.loadStage(result.info)
        else
          console.log("Stub, failed!")


  loginManager.loginCheck()

  $("#navbar_login_button").click ->
    loginManager.login($("#navbar_username").val(), $("#navbar_password").val())
    event.preventDefault()

  $("#navbar_logout_button").click ->
    loginManager.logout()
    event.preventDefault()
