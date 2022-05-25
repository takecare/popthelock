extends Node2D

# game basics
# TODO add shackle part of the lock
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

const progression = [1, 3, 5, 7, 9, 11, 13]

export(int) var level = 0
export(int) var count = progression[0]

var is_playing: bool = false

onready var crosshair: Crosshair = $Game/Crosshair
export(float) var initial_speed = 1
var crosshair_rotation_direction = -1 # 1=CW; -1=CCW
var should_crosshair_rotate: bool = true
var crosshair_speed: float = initial_speed

onready var camera: Camera2D = $Camera

onready var lock: Lock = $Game/Lock
onready var lock_center: Vector2 = lock.center.global_position

export(float) var target_radius = 74 # distance from the lock center
onready var target: Target = $Game/Target

onready var score: Score = $Game/Score


func _ready() -> void:
  target.set_position(
    Vector2(
      lock.center.global_position.x,
      lock.body.rect_global_position.y + target_radius
    )
  )
  crosshair.set_position(target.global_position)
  score.center_on(lock_center)
  score.set_score(count)
  randomize()

func _process(delta: float) -> void:
  if should_crosshair_rotate:
    var angle = crosshair_speed * delta * crosshair_rotation_direction
    crosshair.increase_rotation_around_by(lock_center, angle)

func _physics_process(_delta: float) -> void:
  pass

func _on_Crosshair_target_hit() -> void:
  if !is_playing:
    return
  print("[MAIN] HIT score="+str(score.get_score())+", count="+str(count)+", level="+str(level)+". in progress? "+str($Game/Score.in_progress)+". resting? "+str($Game/Score.mode == 0))
  if $Game/Score.in_progress:
    return
  decrease_count()
  if count == 0:
    increase_level()

func decrease_count() -> void:
  count -= 1
  #var fastforward = true if count == 0 else false
  score.decrease()

func increase_level() -> void:
  level += 1
  if level >= len(progression):
      return
  crosshair_speed += initial_speed # TODO increase speed at reasonable pace
  crosshair_rotation_direction *= -1

  count = progression[level]
  score.next_level(count) # score.set_score(count)
  # TODO next angle has to place the target in the same direction as the xhair's movement
  target.increase_rotation_around_by(lock_center, deg2rad(randi() % 360))

func _on_Crosshair_target_missed() -> void:
  if !is_playing:
    return
  # TODO go to menu
  crosshair_speed = initial_speed
  level = 0
  count = progression[level]
  score.set_score(count)
  reset_target()

func reset_target() -> void:
  should_crosshair_rotate = false
  target.reset()

func _on_StartButton_tapped(origin: FadeButton) -> void:
  origin.fade_out()
  camera.zoom_in()
  is_playing = true

func _unhandled_key_input(event: InputEventKey) -> void:
  if event.echo || event.pressed: return
  if event.scancode == KEY_Z:
    camera.zoom_in()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_X:
    camera.zoom_out()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_P:
    _on_StartButton_tapped($GUI/HBox/StartButton)
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_H:
    _on_Crosshair_target_hit()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_Y:
    _on_Crosshair_target_hit()
    yield(get_tree().create_timer(0.28), "timeout")
    _on_Crosshair_target_hit()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_M:
    _on_Crosshair_target_missed()
    get_tree().set_input_as_handled()


