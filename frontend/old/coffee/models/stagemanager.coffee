class StageManager
  queryStageList: (handler) ->
    #TODO: Use Ajax to query server to acquire data
    $.ajax
      url: '/backend/stage/'
      data : ''
      dataType: 'json'
    .done handler


  getStage: (stageId, handler) ->
    $.ajax
      url: '/backend/stage/' + stageId
      data : ''
      dataType: 'json'
    .done handler

module.exports = StageManager
