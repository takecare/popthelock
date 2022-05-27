extends Node2D

const progression = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] # TODO fill this in
const speed_step = 0.1

export(int) var level = 0
export(int) var count = progression[0]

var is_playing: bool = false

onready var crosshair: Crosshair = $Game/Crosshair
var crosshair_rotation_direction = -1 # 1=CW; -1=CCW # TODO should be enum and eport
var should_crosshair_rotate: bool = true
var crosshair_speed: float = 1

onready var camera: Camera2D = $Camera

onready var lock: Lock = $Game/Lock
onready var lock_center: Vector2 = lock.center.global_position

export(float) var target_radius = 74 # distance from the lock center
onready var target: Target = $Game/Target
var min_angle_deg: float = 30
var max_angle_deg: float = 60

onready var score: Score = $Game/Score

onready var start_button: FadeButton = $GUI/HBox/StartButton

onready var random: RandomNumberGenerator = RandomNumberGenerator.new()

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
  replace_target()
  random.randomize()


func _process(delta: float) -> void:
  if should_crosshair_rotate:
    var angle = crosshair_speed * delta * crosshair_rotation_direction
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
  print(min_angle_deg, " ", max_angle_deg)
  var angle = deg2rad(random.randf_range(min_angle_deg, max_angle_deg))
  var signed_angle = crosshair_rotation_direction * angle
  target.increase_rotation_around_by(lock_center, signed_angle)
  var s = 1 if random.randf() > 0.5 else -1
  min_angle_deg += random.randf_range(5, 25) * s
  max_angle_deg += random.randf_range(5, 25) * -s


func decrease_count() -> void:
  count -= 1
  #var fastforward = true if count == 0 else false
  score.decrease()


func increase_level() -> void:
  level += 1
  if level >= len(progression):
      return
  crosshair_speed += speed_step
  count = progression[level]
  score.next_level(count) # score.set_score(count)


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


