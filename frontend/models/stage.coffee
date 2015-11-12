class Stage

  METASTAGE_ID = 10

  instance = null

  constructor: ->
    if instance
      return instance
    else
      instance = this
    @localStagePackageList = {}

  # Find a stage in local storage by its stageId
  getLocalStage: (stageId) ->
    return null if not @localStagePackageList?
    for elem in @localStagePackageList
      if elem.sid == stageId
        return elem
    return null

  getStagePackage: (stagePackageId) ->
    stagePackage = @getLocalStage(stagePackageId)
    ret = JSON.parse(stagePackage.info)
    ret.name = stagePackage.name
    ret.id = stagePackage.sid
    return ret

  queryStagePackageList: () ->
    metaStage =  @getLocalStage(METASTAGE_ID)
    stageIdList = JSON.parse(metaStage.info)
    ret = []
    for sid in stageIdList
      ret.push(@getStagePackage(sid))
    return ret

  queryStageList: (packageName, callback) ->
    $.ajax
      url: '/backend/stage/'
      data : ''
      dataType: 'json'
    .done (data) =>
      @localStagePackageList = data
      callback data


  getStage: (stageId, callback) ->
    $.ajax
      url: '/backend/stage/' + stageId
      data : ''
      dataType: 'json'
    .done callback

module.exports = Stage
