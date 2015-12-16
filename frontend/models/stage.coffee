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
    return null unless stagePackage
    ret = JSON.parse(stagePackage.info)
    ret.name = stagePackage.name
    ret.id = stagePackage.sid
    return ret

  queryStagePackageList: () ->
    metaStage =  @getLocalStage(METASTAGE_ID)
    return [] unless metaStage
    stageIdList = JSON.parse(metaStage.info)
    ret = []
    for sid in stageIdList
      ret.push(@getStagePackage(sid))
    return ret

  # TODO : This method actually needs to be renamed to sync.
  # We have decided to load stages from local after sync.
  queryStageList: (packageName, callback) ->
    $.ajax
      url: '/backend/stage/'
      data : ''
      dataType: 'json'
    .done (data) =>
      # TODO : maybe we need to consider use local storage.
      @localStagePackageList = data
      callback data

  # TODO : This method seems outdated, seems we always sync and load
  # from local, instead of loading single stage from server.
  getStage: (stageId, callback) ->
    $.ajax
      url: '/backend/stage/' + stageId
      data : ''
      dataType: 'json'
    .done callback

module.exports = Stage
