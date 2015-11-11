class Stage

  queryLocalStagePackageList: () ->
    return [
      {
        id: 100
        name: 'Beginner\' s gressland'
        background: 'grassland.svg'
      },
      {
        id: 101
        name: 'Branch forest'
        background: 'forest.svg'
      },
      {
        id: 102
        name: 'Loop river'
        background: '789'
      }
    ]

  queryStagePackageList: (callback) ->
    # TODO : This is a stub function.
    callback @queryLocalStagePackageList()

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
