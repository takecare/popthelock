extends Area2D

# the last point around which we were rotated. we use this to offer a reset()
# that reverts the total rotation to place this area2d back where it was
var _last_point: Vector2

# the total by which we've rotated so far. we use this to offer a reset()
# that reverts the total rotation to place this area2d back where it was
var _cumulative_rotation: float = 0.0


func increase_rotation_around_by(point: Vector2, angle: float):
  _rotate(point, angle)


func _rotate(around: Vector2, angle: float):
  _rotate_around(around, angle)
  _rotate_facing(around)
  _cumulative_rotation += angle
  _last_point = around


func _rotate_around(point: Vector2, angle: float):
  var distX = position.x - point.x
  var distY = position.y - point.y
  var rotatedX = cos(angle) * distX - sin(angle) * distY + point.x;
  var rotatedY = sin(angle) * distX + cos(angle) * distY + point.y;
  position = Vector2(rotatedX, rotatedY)


func _rotate_facing(point: Vector2):
  var distX = position.x - point.x
  var distY = position.y - point.y
  rotation = atan2(distY, distX) + deg2rad(90)


func reset() -> void:
  _reset_rotation(_last_point)


func _reset_rotation(around: Vector2) -> void:
 # TODO find current angle
  var angle = _angle(around)
  _rotate(around, -_cumulative_rotation)


func _angle(around: Vector2) -> float:
  # cos(a) = u . v / ||u|| * ||v||
  # u . v => dot product = ux * vx + uy * vy
  # ||u|| = length of u = sqrt(ux^2 + uy^2)
  # acos()
  # u -> (0, radius)
  # v -> (posX - centerX, posY - centerY)

  # radius = distance from 'around' to 'position'
  var radius = sqrt(pow(around.x - position.x, 2) + pow(around.y - position.y, 2))

  var u = Vector2(0, radius)
  var v = Vector2(position.x - around.x, position.y - around.y) # this is wrong

  var len_u = sqrt(pow(u.x, 2) + pow(u.y, 2))
  var len_v = sqrt(pow(v.x, 2) + pow(v.y, 2))

  var dot_prod =  u.x * v.x  + u.y * v.y
  var cosa = dot_prod / (len_u * len_v)
  var a = acos(cosa)

  return a
