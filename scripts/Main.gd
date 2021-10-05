extends Node2D

export(float) var speed = 15
export(float) var step = 5
export(float) var yOffset = 74

onready var lock: Lock = $Lock
onready var target: Target = $Target
onready var crosshair: Sprite = $Crosshair

func _ready() -> void:
  target.position.x = lock.center.global_position.x
  target.position.y = lock.body.rect_global_position.y + yOffset #lock.body.rect_size.y / 2

func _process(delta: float) -> void:
  crosshair.set_rotation_around(lock.center.global_position, step * speed * delta)
