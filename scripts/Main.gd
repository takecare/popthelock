extends Node2D

export(float) var speed = 1

onready var lock: Lock = $Lock
onready var target: Target = $Target

func _ready() -> void:
  $Sprite.global_position = lock.center.global_position
  pass

func rotateAround(obj: Node2D, point: Vector2, angle: float):
  var rot = deg2rad(angle)
  obj.global_translate(-point)
  obj.transform = obj.transform.rotated(rot)
  obj.global_translate(point)

func _process(delta: float) -> void:
  rotateAround(target, lock.center.global_position, -25 * speed * delta)
#  target.look_at(lock.center.global_position)
  pass
