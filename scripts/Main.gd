extends Node2D

enum RotationDirection { CW = 1, CCW = -1}

const progression = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17] # TODO fill this in
const speed_step = 0.1

export(int) var level = 0
export(int) var count = progression[0]

enum PlayState {
  Demo,
  Playing,
  Repositioning,
  Missed,
  Stopped
}
var state = PlayState.Demo

enum CrosshairPosition {
  Before,
  EnteredRight,
  ExitedTarget,
  EnteredLeft,
  ExitedRight,
  ExitedLeft
}
onready var crosshair = $Game/Crosshair
var crosshair_rotation_direction: int = RotationDirection.CW
var crosshair_speed: float = 1
var crosshair_rotation: float = 0
var crosshair_state = CrosshairPosition.Before

onready var camera: Camera2D = $Camera

onready var lock: Lock = $Game/Lock
onready var lock_center: Vector2 = lock.center.global_position

export(float) var target_radius = 74 # distance from the lock center
onready var target: Target = $Game/Target
export(float) var MIN_ANGLE = 35
export(float) var MAX_ANGLE = 95

onready var score: Score = $Game/Score

onready var start_button: FadeButton = $GUI/HBox/StartButton

onready var random: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
  score.center_on(lock_center)
  score.set_score(count)
  random.randomize()
  target.visible = false
  # debug:
  #yield(get_tree().create_timer(0.2), "timeout")
  #_on_start_button_tapped($GUI/HBox/StartButton)

func _fill_progression() -> void:
  # TODO
  pass


func _process(delta: float) -> void:
  if state == PlayState.Playing or state == PlayState.Demo:
    _move_crosshair(delta)
  elif state == PlayState.Missed:
    crosshair_speed -= speed_step / 2
    if crosshair_speed <= 0:
      _game_over()
    else:
      _move_crosshair(delta)


func _move_crosshair(delta: float) -> void:
  var angle = crosshair_speed * delta * crosshair_rotation_direction
  crosshair_rotation = angle
  crosshair.increase_rotation_around_by(lock_center, angle)


func _physics_process(_delta: float) -> void:
  pass


func _on_target_hit() -> void:
  if state != PlayState.Playing or score.in_progress:
    return
  state = PlayState.Repositioning
  target.disappear()


func _target_disappeared() -> void:
  _reposition_target()
  decrease_count()
  if count == 0:
    increase_level()
  target.appear()
  state = PlayState.Playing


func _reposition_target() -> void:
  crosshair_rotation_direction *= -1
  var min_angle_deg = random.randf_range(MIN_ANGLE, MAX_ANGLE)
  var max_angle_deg = random.randf_range(MIN_ANGLE, MAX_ANGLE)
  var angle_deg = random.randf_range(min_angle_deg, max_angle_deg)
  var signed_angle = crosshair_rotation_direction * deg2rad(angle_deg)
  target.increase_rotation_around_by(lock_center, signed_angle)


func decrease_count() -> void:
  count -= 1
  score.decrease()


func increase_level() -> void:
  level += 1
  if level >= len(progression):
      return
  crosshair_speed += speed_step
  count = progression[level]
  score.next_level(count)


func _on_target_missed() -> void:
  if state != PlayState.Playing:
    return
  state = PlayState.Missed


func _game_over() -> void:
  state = PlayState.Stopped
  _back_to_menu()
  level = 0
  count = progression[level]
  crosshair_speed = 1
  score.set_score(count)


func reset_target() -> void:
  target.reset()


func _on_start_button_tapped(start_button: FadeButton) -> void:
  start_button.fade_out()
  camera.zoom_in()
  target.visible = true
  _reposition_target()
  state = PlayState.Playing


func _back_to_menu() -> void:
  start_button.fade_in()
  camera.zoom_out()
  state = PlayState.Stopped


func _on_target_entered_left() -> void:
  if crosshair_rotation_direction == RotationDirection.CCW:
    crosshair_state = CrosshairPosition.EnteredLeft
  elif crosshair_rotation_direction == RotationDirection.CW:
    crosshair_state = CrosshairPosition.EnteredLeft

func _on_target_entered_right() -> void:
  if crosshair_rotation_direction == RotationDirection.CCW:
    crosshair_state = CrosshairPosition.EnteredRight
  elif crosshair_rotation_direction == RotationDirection.CW:
    crosshair_state = CrosshairPosition.EnteredRight

func _on_target_entered() -> void:
  $Game/Crosshair.on_target_area_entered()

func _on_target_exited() -> void:
  $Game/Crosshair.on_target_area_exited()
  if crosshair_rotation_direction == RotationDirection.CCW and crosshair_state == CrosshairPosition.ExitedRight:
    _on_target_missed()
  elif crosshair_rotation_direction == RotationDirection.CW and crosshair_state == CrosshairPosition.ExitedLeft:
    _on_target_missed()

func _on_target_exited_left() -> void:
  if crosshair_rotation_direction == RotationDirection.CCW:
    crosshair_state = CrosshairPosition.ExitedLeft
  elif crosshair_rotation_direction == RotationDirection.CW:
    crosshair_state = CrosshairPosition.ExitedLeft

func _on_target_exited_right() -> void:
  if crosshair_rotation_direction == RotationDirection.CCW:
    crosshair_state = CrosshairPosition.ExitedRight
  elif crosshair_rotation_direction == RotationDirection.CW:
    crosshair_state = CrosshairPosition.ExitedRight


# debugging utilities
func _unhandled_key_input(event: InputEventKey) -> void:
  if event.echo || event.pressed: return
  if event.scancode == KEY_Z:
    camera.zoom_in()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_X:
    camera.zoom_out()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_P:
    _on_start_button_tapped($GUI/HBox/StartButton)
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_O:
    # TODO reverse starting animations
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_H:
    $Game/Crosshair._target_hit()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_Y:
    _on_target_hit()
    yield(get_tree().create_timer(0.28), "timeout")
    _on_target_hit()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_M:
    $Game/Crosshair._target_missed()
    get_tree().set_input_as_handled()
