extends Node2D

# game basics
# TODO add lock part of the lock
# TODO display score, animate it increasing, animate it decreasing when player loses (counting down)
# TODO track level, which determines the angle range in which the target is placed
# TODO animate target disappearing and reappearing
# TODO animate crosshair hitting and missing
# TODO screenshake on hit
# TODO dying animation
# TODO add sound

# extra mile
# TODO score is no longer updated on 1 increments. it's derived from how much of
# the crosshair is within the target so, for a given hit, your score can go from
# 0 to 10 (as an example)

export(float) var speed = 15
export(float) var step = 5
export(float) var yOffset = 74

onready var camera: Camera2D = $Camera

onready var lock: Lock = $Game/Lock
onready var target: Target = $Game/Target
onready var crosshair: Crosshair = $Game/Crosshair

onready var score: Score = $Game/Score

onready var lockCenter: Vector2 = lock.center.global_position

var crosshairRotationDirection = -1 # 1=CW; -1=CCW
var level = 0

# should target and crosshair be children of lock?
func _ready() -> void:
  target.position.x = lock.center.global_position.x
  target.position.y = lock.body.rect_global_position.y + yOffset #lock.body.rect_size.y / 2
  #target.position.y = lock.center.global_position.y - lock.body.rect_size.y / 2 + yOffset
  crosshair.set_position(target.global_position)
  score.center_on(lockCenter)
  randomize()

func _process(delta: float) -> void:
  crosshair.set_rotation_around(lockCenter, step * speed * delta * crosshairRotationDirection)

func _physics_process(_delta: float) -> void:
  pass

func _on_Crosshair_target_hit() -> void:
  score.increase()
  speed += 3 # TODO increase speed at reasonable pace
  increase_level()
  crosshairRotationDirection *= -1

var rot = 0 #temporary

func increase_level() -> void:
  level += 1
  rot += 10
  target.set_rotation_around(lockCenter, randi() % 360) #

func _on_Crosshair_target_missed() -> void:
  #crosshairRotationDirection = -1 if rand_range(0, 1) > 0.5 else 1
  print("> MISSED!")
  # TODO go to menu
  score.reset()
  reset_target() # not working!

func reset_target() -> void:
  score.reset()
  target.set_rotation_around(lockCenter, 0)
  # ^ it seems that rotation is cumulative so when we call set_rotation_arount(x)
  # we're just adding to the rotation that is already there

func _unhandled_key_input(event: InputEventKey) -> void:
  if event.echo || event.pressed: return
  if event.scancode == KEY_C:
    camera.zoom = Vector2(1, 1)
    get_tree().set_input_as_handled()
