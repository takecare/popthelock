extends Area2D

var _last_angle: float = 0.0

func set_rotation_around(point: Vector2, angle: float):
  _rotate(point, angle)

func _rotate(around: Vector2, angle: float):
  _rotate_around(around, angle)
  _rotate_facing(around)
  _last_angle = angle


func _rotate_around(point: Vector2, angle: float):
  var distX = position.x - point.x
  var distY = position.y - point.y
  var rotatedX = cos(angle) * distX - sin(angle) * distY + point.x;
  var rotatedY = sin(angle) * distX + cos(angle) * distY + point.y;
  position = Vector2(rotatedX, rotatedY)


func _rotate_facing(point: Vector2):
  var distX = position.x - point.x
  var distY = position.y - point.y
  rotation = atan2(distY, distX) + deg2rad(-90)


func reset_rotation(around: Vector2) -> void:
  # TODO i don't know why tis is 360/2
  var diff = deg2rad(360 / 2) - _last_angle
  _rotate(around, diff)
