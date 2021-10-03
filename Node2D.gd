extends Node2D

onready var sprite = $Sprite
onready var center = $Sprite2

var offset = 150

func _ready() -> void:
  sprite.position = Vector2(center.position.x + offset, center.position.y + offset)
  pass

func rot(obj: Node2D, point: Node2D, angle):
  obj.global_transform = point.global_transform * Transform2D().rotated(deg2rad(angle))

func rotateAround(obj: Node2D, point, angle):
    var rot = deg2rad(angle)
    obj.global_translate(-point)
    obj.transform = obj.transform.rotated(rot)
    obj.global_translate(point)
#    sprite.look_at(center.position)

func rot2(obj, point, angle) -> void:
  var rot = deg2rad(angle)
  var x = point.x
  var y = point.y
  var trnsf = Transform2D()
  #trnsf.origin = Vector2(200, 300)
  trnsf.origin.x = -x * cos(angle) + y * sin(angle) + x
  trnsf.origin.y = -x * sin(angle) + y * cos(angle) - y
#  obj.global_translate(-point)
  trnsf.x = Vector2(cos(rot), sin(rot))
  trnsf.y = Vector2(-sin(rot), cos(rot))
  obj.transform = trnsf
  obj.global_translate(point)

func setpos(obj, point, angle) -> void:
  var a = deg2rad(angle)
  var x = point.x + offset * cos(a)
  var y = point.y + offset * sin(a)
  obj.global_position.x = x
  obj.global_position.y = y
  pass

var angle = 0

func _process(delta):
#  rotateAround(sprite, center.position, -25 * delta)
  if angle >= 360.0:
    angle = 0
  angle =  angle + -25 * delta
  setpos(sprite, center.position, angle)
#  rot2(sprite, center.position, -25 * delta)
#  rot(sprite, center, -25 * delta)
  pass
