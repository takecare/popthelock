extends Node2D

# game basics
# TODO add lock part of the lock
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

export(float) var initial_speed = 15
export(float) var step = 5
export(float) var yOffset = 74

var isPlaying: bool = false
var speed: float = initial_speed

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
  if !isPlaying:
    return
  score.increase()
  speed += 3 # TODO increase speed at reasonable pace
  increase_level()
  crosshairRotationDirection *= -1

func increase_level() -> void:
  level += 1
  target.set_rotation_around(lockCenter, randi() % 360) #

func _on_Crosshair_target_missed() -> void:
  if !isPlaying:
    return
  #crosshairRotationDirection = -1 if rand_range(0, 1) > 0.5 else 1
  print("> MISSED!")
  # TODO go to menu
  speed = initial_speed
  score.reset()
  reset_target() # not working!

func reset_target() -> void:
  score.reset()
  target.set_rotation_around(lockCenter, 0)
  # ^ it seems that rotation is cumulative so when we call set_rotation_arount(x)
  # we're just adding to the rotation that is already there

func _unhandled_key_input(event: InputEventKey) -> void:
  if event.echo || event.pressed: return
  if event.scancode == KEY_Z:
    camera.zoom_in()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_X:
    camera.zoom_out()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_P:
    isPlaying = !isPlaying
    get_tree().set_input_as_handled()

func _on_StartButton_tapped(origin: FadeButton) -> void:
  origin.fade_out()
  camera.zoom_in()
  isPlaying = true
