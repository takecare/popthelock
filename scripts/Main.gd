extends Node2D

# TODO display score, animate it increasing
# TODO track level, which determines the angle range in which the target is placed
# TODO animate target disappearing and reappearing
# TODO animate crosshair hitting and missing
# TODO screenshake on hit
# TODO add sound

export(float) var speed = 15
export(float) var step = 5
export(float) var yOffset = 74

onready var lock: Lock = $Lock
onready var target: Target = $Target
onready var crosshair: Crosshair = $Crosshair

onready var lockPos: Vector2 = lock.center.global_position

var crosshairRotationDirection = -1 # 1=CW; -1=CCW
var score = 0
var level = 0


# should target and crosshair be children of lock?
func _ready() -> void:
  target.position.x = lock.center.global_position.x
  target.position.y = lock.body.rect_global_position.y + yOffset #lock.body.rect_size.y / 2
  crosshair.position.x = target.global_position.x
  crosshair.position.y = target.global_position.y
  randomize()


func _process(delta: float) -> void:
  crosshair.set_rotation_around(lockPos, step * speed * delta * crosshairRotationDirection)


func _physics_process(_delta: float) -> void:
  pass


func _on_Crosshair_target_hit() -> void:
  score += 1
  speed += 3 # TODO increase speed at reasonable pace
  increase_level()
  crosshairRotationDirection *= -1

func increase_level() -> void:
  level += 1
  target.set_rotation_around(lockPos, randi() % 360 + 1)


func _on_Crosshair_target_missed() -> void:
  #crosshairRotationDirection = -1 if rand_range(0, 1) > 0.5 else 1
  reset_target()


func reset_target() -> void:
  score = 0
  target.set_rotation_around(lockPos, 0)
