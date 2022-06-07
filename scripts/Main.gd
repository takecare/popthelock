extends Node2D

enum RotationDirection { CW = 1, CCW = -1}

const progression = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] # TODO fill this in
const speed_step = 0.1

export(int) var level = 0
export(int) var count = progression[0]

var is_playing: bool = false

onready var crosshair = $Game/Crosshair
var crosshair_rotation_direction: int = RotationDirection.CW
var should_crosshair_rotate: bool = true
var crosshair_speed: float = .25
var crosshair_rotation: float = 0

onready var camera: Camera2D = $Camera

onready var lock: Lock = $Game/Lock
onready var lock_center: Vector2 = lock.center.global_position

export(float) var target_radius = 74 # distance from the lock center
onready var target: Target = $Game/Target
var min_angle_deg: float = 30
var max_angle_deg: float = 60
var target_rotation: float = 0

onready var score: Score = $Game/Score

onready var start_button: FadeButton = $GUI/HBox/StartButton

onready var random: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
  score.center_on(lock_center)
  score.set_score(count)
  random.randomize()
  replace_target()

#  target.rotate_around_to(lock_center, target_radius, deg2rad(0.0))
#  target.rotate_around_to(lock_center, target_radius, deg2rad(45.0))
#  target.rotate_around_to(lock_center, target_radius, deg2rad(45.0))

  # debug:
  yield(get_tree().create_timer(0.2), "timeout")
  _on_start_button_tapped($GUI/HBox/StartButton)


func _process(delta: float) -> void:
  if not should_crosshair_rotate:
    return
  _move_crosshair(delta)
  if crosshair_rotation > target_rotation:
    pass


func _move_crosshair(delta: float) -> void:
  var angle = crosshair_speed * delta * crosshair_rotation_direction
  crosshair_rotation = angle
  crosshair.increase_rotation_around_by(lock_center, angle)


func _physics_process(_delta: float) -> void:
  pass


func _on_target_hit() -> void:
  if !is_playing or $Game/Score.in_progress:
    return
  replace_target()
  decrease_count()
  if count == 0:
    increase_level()


func replace_target() -> void:
  crosshair_rotation_direction *= -1
  var angle_deg = random.randf_range(min_angle_deg, max_angle_deg)
  var signed_angle = crosshair_rotation_direction * deg2rad(angle_deg)
  target.increase_rotation_around_by(lock_center, signed_angle)
  var s = 1 if random.randf() > 0.5 else -1
  min_angle_deg += random.randf_range(15, 40) * s
  max_angle_deg += random.randf_range(15, 40) * -s


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
  if !is_playing:
    return
  back_to_()
  level = 0
  count = progression[level]
  crosshair_speed = 1
  score.set_score(count)
  reset_target()


func reset_target() -> void:
  # TODO slowdown crosshair's movement instead of stopping outright
  should_crosshair_rotate = false
  target.reset()


func _on_start_button_tapped(origin: FadeButton) -> void:
  origin.fade_out()
  camera.zoom_in()
  is_playing = true


func back_to_() -> void: # TODO rename "back_to_menu"?
  start_button.fade_in()
  camera.zoom_out()
  is_playing = false


enum CrosshairPosition { Before, EnteredRight, ExitedTarget, EnteredLeft, ExitedRight, ExitedLeft, Past }
var crosshair_state = CrosshairPosition.Before

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


func _on_target_exited() -> void:
  if crosshair_rotation_direction == RotationDirection.CCW and crosshair_state == CrosshairPosition.ExitedRight:
    print('>>> PAST (ccw)')
  elif crosshair_rotation_direction == RotationDirection.CW and crosshair_state == CrosshairPosition.ExitedLeft:
    print('>>> PAST (cw)')

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
