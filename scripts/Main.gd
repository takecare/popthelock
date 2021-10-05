extends Node2D

export(float) var speed = 15
export(float) var step = 5
export(float) var yOffset = 74

onready var lock: Lock = $Lock
onready var target: Target = $Target
onready var crosshair: Crosshair = $Crosshair

var crosshairRotationDirection = -1 # 1=CW; -1=CCW

# should target and crosshair be children of lock?
func _ready() -> void:
  target.position.x = lock.center.global_position.x
  target.position.y = lock.body.rect_global_position.y + yOffset #lock.body.rect_size.y / 2
  crosshair.position.x = target.global_position.x
  crosshair.position.y = target.global_position.y

func _process(delta: float) -> void:
  crosshair.set_rotation_around(lock.center.global_position, step * speed * delta * crosshairRotationDirection)

func _physics_process(_delta: float) -> void:
  if Input.is_action_just_pressed("click"):
    crosshairRotationDirection *= -1

