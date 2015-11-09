class Stage
  queryStagePackageList: (handler) ->
    # TODO : This is a stub function.
    return {
      'Beginner\' s gressland':
        background: '123'
      'Branch forest':
        background: '456'
      'Loop\'s river':
        background: '789'
    }

  queryStageList: (handler) ->
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

module.exports = Stage
