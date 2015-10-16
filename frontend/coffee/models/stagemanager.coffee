class StageManager
  queryStageList: (handler) ->
    #TODO: Use Ajax to query server to acquire data
    handler
      status: "succeeded"
      data: ['level1', 'level2', 'level3', 'level4', 'level5']

  getStage: (stageId, handler) ->
    #TODO: Use Ajax to query server to acquire data
    stageData =
      level1: """[
        {"type":"carrot","x":300,"y":50},
        {"type":"rabbit","x":300,"y":370,"angle":0}
      ]"""
      level2: """[
        {"type":"carrot","x":300,"y":50},
        {"type":"rabbit","x":300,"y":370,"angle":0},
        {"type":"carrot","x":300,"y":200,"angle":0}
      ]"""
      level3: """[
        {"type":"rabbit","x":300,"y":370,"angle":0}
      ]"""
    if stageData[stageId]?
      handler
        status: "succeeded"
        stageId: stageId
        data: stageData[stageId]
    else
      handler
        status: "failed"
        stageId: stageId

module.exports = StageManager
