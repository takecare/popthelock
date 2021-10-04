extends Node2D

export(float) var speed = 15
export(float) var step = 5

onready var lock: Lock = $Lock
onready var target: Target = $Target
onready var crosshair: Sprite = $Crosshair

func _ready() -> void:
  pass

func _process(delta: float) -> void:
  crosshair.rotate_around(lock.center.global_position, step * speed * delta)
