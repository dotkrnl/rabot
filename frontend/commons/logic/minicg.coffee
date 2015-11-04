# This is a very tiny computational geometry library used by this project,
# to cover some very basic algorithm might be used in this project.

class Vec2D
  constructor: (@x, @y) ->

  lengthSquared: ->
    @x * @x + @y * @y

  length: ->
    Math.sqrt(@lengthSquared())

  normalized: ->
    new Vec2D(@x / @length(), @y / @length())

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

  @mul: (vec, scalar) ->
    new Vec2D(vec.x * scalar, vec.y * scalar)

  @dotProduct: (vec1, vec2) ->
    vec1.x * vec2.x + vec1.y * vec2.y

class Segment

  direction:  ->
    Vec2D.sub(@point2, @point1).normalized()

  constructor: (@point1, @point2) ->
    @slopeX = (@point2.x - @point1.x) / (@point2.y - @point1.y)
    @intersectX = @point2.x - @point2.y * @slopeX
    @slopeY = (@point2.y - @point1.y) / (@point2.x - @point1.x)
    @intersectY = @point2.y - @point2.x * @slopeY

  vecToLine: (point) ->
    vec = Vec2D.sub(@point2, point)
    return Vec2D.sub(vec, Vec2D.mul(
      @direction(),
      Vec2D.dotProduct(vec, @direction())
    ))

  distTo: (point) ->
    vecTo = @vecToLine(point)
    intersect = Vec2D.add(point, vecTo)
    if (
      @point1.y != @point2.y and
      ((@point1.y >= intersect.y and @point2.y <= intersect.y) or
      (@point1.y <= intersect.y and @point2.y >= intersect.y)))
      return vecTo.length()
    else if (
      @point1.x != @point2.x and
      ((@point1.x >= intersect.x and @point2.x <= intersect.x) or
      (@point1.x <= intersect.x and @point2.x >= intersect.x)))
      return vecTo.length()
    else
      return Math.min \
        Vec2D.sub(point, @point1).length(),
        Vec2D.sub(point, @point2).length()

class Circle
  constructor: (@center, @radius) ->

  collidePoly: (poly) ->
    if poly.pointInside(@center)
      return true

    for edge in poly.segmentList
      if edge.distTo(@center) <= @radius
        return true
    return false

  @collide: (circle1, circle2) ->
    return Vec2D.sub(circle1.center, circle2.center).length() <
    circle1.radius + circle2.radius

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
      if segment.slopeX != NaN and
      point.x == point.y * segment.slopeX + segment.intersectX and
      ((segment.point1.y >= point.y and segment.point2.y <= point.y) or
      (segment.point1.y <= point.y and segment.point2.y >= point.y))
        return true

      if segment.slopeX == NaN and
      point.y == segment.intersectY and
      ((segment.point1.x >= point.x and segment.point2.x <= point.x) or
      (segment.point1.x <= point.x and segment.point2.x >= point.x))
        return true

    for segment in @segmentList
      if ((segment.point1.y >= point.y and segment.point2.y < point.y) or
      (segment.point1.y < point.y and segment.point2.y >= point.y)) and
      segment.slopeX != NaN
        x = point.y * segment.slopeX + segment.intersectX
        if x >= point.x
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
module.exports.Circle = Circle
