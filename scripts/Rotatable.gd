extends Area2D

func set_rotation_around(point: Vector2, angle: float):
  var rot = deg2rad(angle)
  global_translate(-point)
  transform = transform.rotated(rot)
  global_translate(point)
