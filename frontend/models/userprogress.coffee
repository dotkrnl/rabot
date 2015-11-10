class UserProgress
  instance = null

  constructor: () ->
    if instance
      return instance
    else
      instance = this
    @userProgress = [3, 1, 2, 0, 0, 0]

  getUserProgress: (stagePackageIndex) ->
    #TODO : This is a stub function. Those numbers stands for stars user got.
    return @userProgress

  updateUserProgress: (stagePackageName, stageId, rank, callback) ->
      @userProgress[stageId] = rank
    #TODO : This is a stub function

module.exports = UserProgress
