class Stage
  queryStagePackageList: (handler) ->
    # TODO : This is a stub function.
    handler [
      {
        name: 'Beginner\' s gressland'
        background: 'grassland.svg'
      },
      {
        name: 'Branch forest'
        background: 'forest.svg'
      },
      {
        name: 'Loop river'
        background: '789'
      }
    ]

  queryStageList: (packageName, handler) ->
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
