jest.dontMock '../stage.coffee'
Stage = require '../stage.coffee'

TEST_STAGE_JSON = [
  {
    "sid": 10,
    "name": "__meta_all_stage_packages",
    "info": "\n [101]\n "
  },
  {
    "sid": 101,
    "name": "Beginner's Gressland",
    "info": "\n {\n \"background\": \"grassland.png\",
    \n \"stages\": [1001, 1002]\n }\n "
  },
  {
    "sid": 1001,
    "name": "welcome",
    "info": "\n [\n {\n \"type\":\"carrot\",\n \"region\":{\"radius\":40},
    \n \"image\":{\"name\":\"carrot.svg\",\"width\":160,\"height\":160},
    \n \"x\":500,\n \"y\":100\n },\n {\n \"type\":\"rabbit\",
    \n \"image\":{\"name\":\"rabbit.svg\",\"width\":160,\"height\":160},
    \n \"x\":500,\n \"y\":700\n }\n ]\n "
  },
  {
    "sid": 1002,
    "name": "carrot",
    "info": "\n [\n {\n \"type\":\"carrot\",
    \n \"region\":{\"radius\":40},\n \"image\":{\"name\":\"carrot.svg\",
    \"width\":160,\"height\":160},\n \"x\":500,\n \"y\":100\n },
    \n {\n \"type\":\"carrot\",\n \"region\":{\"radius\":40},
    \n \"image\":{\"name\":\"carrot.svg\",\"width\":160,\"height\":160},
    \n \"x\":500,\n \"y\":400\n },\n {\n \"type\":\"rabbit\",
    \n \"image\":{\"name\":\"rabbit.svg\",\"width\":160,\"height\":160},
    \n \"x\":500,\n \"y\":700\n }\n ]\n "
  }
]

describe 'Stage.constructs', ->
  it 'constructs with no error and is a singleton', ->
    stage1 = new Stage
    stage2 = new Stage
    expect(stage1).toBeDefined()
    expect(stage1 == stage2).toBe(true)

describe 'Stage.queryStageList', ->
  it 'can load stage from the server', ->
    stageManager = new Stage
    # TODO : Need to mock jQuery

describe 'Stage.getLocalStage', ->
  it 'can find existing stage', ->
    stageManager = new Stage
    stageManager.localStagePackageList = TEST_STAGE_JSON
    stage = stageManager.getLocalStage(1001)
    expect(stage.name).toBe("welcome")

  it 'returns null when stage doesn\'t exist', ->
    stageManager = new Stage
    stageManager.localStagePackageList = TEST_STAGE_JSON
    stage = stageManager.getLocalStage(10001)
    expect(stage).toBeNull()

describe 'Stage.getStagePackage', ->
  it 'finds existing stage package and parse it', ->
    stageManager = new Stage
    stageManager.localStagePackageList = TEST_STAGE_JSON
    stagePackage = stageManager.getStagePackage(101)
    expect(stagePackage.background).toBe("grassland.png")
    expect(stagePackage.stages[0]).toBe(1001)
    expect(stagePackage.stages[1]).toBe(1002)

  it 'returns null when stage package doesn\'t exist', ->
    stageManager = new Stage
    stageManager.localStagePackageList = TEST_STAGE_JSON
    stagePackage = stageManager.getStagePackage(104)
    expect(stagePackage).toBeNull()

describe 'Stage.queryStagePackageList', ->
  it 'returns stage package list', ->
    stageManager = new Stage
    stageManager.localStagePackageList = TEST_STAGE_JSON
    stagePackageList = stageManager.queryStagePackageList()
    expect(stagePackageList[0].id).toBe(101)

  it 'returns empty list if stage METASTAGE_ID not present', ->
    stageManager = new Stage
    TEST_STAGE_JSON[0].sid = 1
    stageManager.localStagePackageList = TEST_STAGE_JSON
    stagePackageList = stageManager.queryStagePackageList()
    expect(stagePackageList.length).toBe(0)
    TEST_STAGE_JSON[0].sid = 10
