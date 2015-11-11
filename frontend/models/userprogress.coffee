Stage = require('./stage.coffee')

class UserProgress
  instance = null

  constructor: () ->
    if instance
      return instance
    else
      instance = this
    @stage = new Stage()

  # Get all user progress data of current user. This will also initialize
  # all user progress of locked stages.
  getAllUserProgress: () ->
    userProgress = JSON.parse(localStorage.getItem('userProgress'))
    if not userProgress?
      userProgress = {}
    for elem in @stage.queryLocalStagePackageList()
      stagePackageId = elem.id
      if not userProgress[stagePackageId]?
        userProgress[stagePackageId] = []
      #TODO : This fixed length for stage count need to be replaced.
      for stageIndex in [0..5]
        if not userProgress[stagePackageId][stageIndex]?
          userProgress[stagePackageId][stageIndex] = -1
    localStorage.setItem('userProgress', JSON.stringify(userProgress))
    return userProgress

  updateAllUserProgress: (userProgress) ->
    localStorage.setItem('userProgress', JSON.stringify(userProgress))

  # Get the user's progress for the level package of name stagePackageIndex.
  # @param satgePackageIndex: the level package you want to get
  # user progress from.
  getUserProgress: (stagePackageIndex, stageIndex) ->
    allUserProgress = @getAllUserProgress()
    if not stagePackageIndex?
      return allUserProgress
    else if not stageIndex?
      return allUserProgress[stagePackageIndex]
    else
      return allUserProgress[stagePackageIndex][stageIndex]

  updateUserProgress: (stagePackageId, stageIndex, rank) ->
    allUserProgress =  @getAllUserProgress()
    allUserProgress[stagePackageId][stageIndex] = rank
    @updateAllUserProgress(allUserProgress)
    #TODO : This is a stub function

  sync: () ->
    #TODO: sync with backend

module.exports = UserProgress
