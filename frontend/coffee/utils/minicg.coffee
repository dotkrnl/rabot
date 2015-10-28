# This is a very tiny computational geometry library used by this project,
# to cover some very basic algorithm might be used in this project.


class Vec2D
  constructor: (@x, @y) ->

  lengthSquared: (@x, @y) ->
    @x * @x + @y * @y

  length: ->
    Math.sqrt(@lengthSquared())

  @Add: (vec1, vec2) ->
    Vec2D(vec1.x + vec2.x, vec1.y + vec2.y)

  @Sub: (vec1, vec2) ->
    Vec2D(vec1.x - vec2.x, vec1.y - vec2.y)

  @Neg: (vec) ->
    Vec2D(-vec.x, -vec.y)

class Segment
  constructor: (@point1, @point2) ->
    @slopeX = (@point2.x - @point1.x) / (@point2.y - @point1.y)
    @intersectX = @point2.x - @point2.y * @slopeX
    @slopeY = (@point2.y - @point1.y) / (@point2.x - @point1.x)
    @intersectY = @point2.y - @point2.x * @slopeY

class Polygon
  constructor: (@vertexList) ->
    @segmentList = []
    for i in [0 .. @vertexList.length - 2]
      @segmentList.push(new Segment(@vertexList[i], @vertexList[i+1]))
    @segmentList.push(new Segment(
      @vertexList[@vertexList.length - 1],
      @vertexList[0]))


  pointInside: (point) ->
    count = 0
    for segment in @segmentList
      if ((segment.point1.y > point.y and segment.point2.y < point.y) or
        (segment.point1.y < point.y and segment.point2.y > point.y)) and
        segment.slopeX != NaN
        x = point.y * segment.intersectX + segment.slopeX
        if x > point.x
          count++
    if count % 2 == 0
      return false
    else
      return true

points = [new Vec2D(0,0), new Vec2D(0,1), new Vec2D(1,1), new Vec2D(1,0)]
polygen = new Polygon(points)
alert polgen.pointInside(5,5)
