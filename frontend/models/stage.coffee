class Stage
  queryStagePackageList: (callback) ->
    # TODO : This is a stub function.
    callback [
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

  queryStageList: (packageName, callback) ->
    $.ajax
      url: '/backend/stage/'
      data : ''
      dataType: 'json'
    .done callback


  getStage: (stageId, callback) ->
    $.ajax
      url: '/backend/stage/' + stageId
      data : ''
      dataType: 'json'
    .done callback

module.exports = Stage
