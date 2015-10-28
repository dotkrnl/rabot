# This is a very tiny computational geometry library used by this project,
# to cover some very basic algorithm might be used in this project.

class Vec2D
  constructor: (@x, @y) ->

  lengthSquared: (@x, @y) ->
    @x * @x + @y * @y

  length: ->
    Math.sqrt(@lengthSquared())

  rotate: (angle, pivot) ->
    pivot = new Vec2D(0, 0) unless pivot
    relative = Vec2D.sub(@, pivot)
    translated = new Vec2D(
      relative.x * Math.cos(angle) + relative.y * Math.sin(angle),
      -relative.x * Math.sin(angle) + relative.y * Math.cos(angle)
    )
    return Vec2D.add(pivot, translated)

  @add: (vec1, vec2) ->
    new Vec2D(vec1.x + vec2.x, vec1.y + vec2.y)

  @sub: (vec1, vec2) ->
    new Vec2D(vec1.x - vec2.x, vec1.y - vec2.y)

  @neg: (vec) ->
    new Vec2D(-vec.x, -vec.y)

class Segment
  constructor: (@point1, @point2) ->
    @slopeX = (@point2.x - @point1.x) / (@point2.y - @point1.y)
    @intersectX = @point2.x - @point2.y * @slopeX
    @slopeY = (@point2.y - @point1.y) / (@point2.x - @point1.x)
    @intersectY = @point2.y - @point2.x * @slopeY

class Polygon
  constructor: (@vertexList) ->
    @generateEdges()

  generateEdges: () ->
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
        x = point.y * segment.slopeX + segment.intersectX
        if x > point.x
          count++
    if count % 2 == 0
      return false
    else
      return true

  @collide: (poly1, poly2) ->
    for vertex in poly1.vertexList
      if poly2.pointInside(vertex)
        return true
    for vertex in poly2.vertexList
      if poly1.pointInside(vertex)
        return true

  @rotate: (angle, pivot) ->
    for vertex in @vertexList
      vertex.rotate(angle, pivot)
    @generateEdges()

  @translate: (vec) ->
    for vertex in @vertexList
      vertex.x += vec.x
      vertex.y += vec.y
    @generateEdges()

module.exports.Vec2D = Vec2D
module.exports.Segment = Segment
module.exports.Polygon = Polygon

p = new Vec2D(0.3,0.9)
console.log p.rotate(90, new Vec2D(0.1,0.1))
