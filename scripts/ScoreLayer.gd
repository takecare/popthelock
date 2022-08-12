class_name ScoreLayer extends CenterContainer

signal appeared # emtited when this score layer appears
signal disappeared # emtited when this score layer disappears

export(int) var score: int = 0 setget set_score,get_score
# warning-ignore:unused_class_variable
export(bool) var in_progress: bool = false setget ,_in_progress

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var hbox_container: HBoxContainer = $HBoxContainer
onready var tween: Tween = $Tween


# we'll have 2 ScoreLayers - does the engine share these sprites or does it load them twice?
const sprites = [
  preload("res://sprites/0.png"),
  preload("res://sprites/1.png"),
  preload("res://sprites/2.png"),
  preload("res://sprites/3.png"),
  preload("res://sprites/4.png"),
  preload("res://sprites/5.png"),
  preload("res://sprites/6.png"),
  preload("res://sprites/7.png"),
  preload("res://sprites/8.png"),
  preload("res://sprites/9.png")
]


func _ready() -> void:
  # reset aniamted properties so it doesn't matter in which position the animation is in (in the editor)
  hbox_container.rect_scale = Vector2(1, 1)
  hbox_container.modulate = Color(1, 1, 1, 1)
  update()


# TODO is this needed/used?
func center_on(point: Vector2) -> void:
  set_global_position(
    Vector2(point.x - rect_size.x / 2, point.y - rect_size.y / 2)
  )


func get_score() -> int:
  return score


func set_score(new: int) -> void:
  score = new
  update()


func animate_to(to: int) -> void:
  reset()
  var _result = tween.interpolate_property(
    self,
    @"score",
    0, # initial
    to, # final
    0.15, # duration
    Tween.TRANS_LINEAR,
    Tween.EASE_IN_OUT,
    0 # delay
  )
  _result = tween.start()


func appear(ff: bool = false) -> void:
  visible = true
  animation_player.play("Appear", -1, 2.0 if ff else 1.0)


func _appeared() -> void:
  emit_signal("appeared")


func disappear(ff: bool = false) -> void:
  animation_player.play("Disappear", -1, 2.0 if ff else 1.0)


func _disappeared() -> void:
  emit_signal("disappeared")
  visible = false


func reset(is_visible: bool = true) -> void:
  animation_player.seek(0, true)
  hbox_container.modulate = Color(1, 1, 0, 1)
  hbox_container.rect_scale = Vector2(1, 1)
  visible = is_visible


# we have to reference nodes this way as this is called in the score setter,
# which means this runs before _ready()/onready
func update():
  var digit1: TextureRect = $HBoxContainer/Digit1
  var digit2: TextureRect = $HBoxContainer/Digit2
  var digit3: TextureRect = $HBoxContainer/Digit3
  var readable = str(score)
  var length = readable.length()
  if length == 1:
    digit1.texture = sprites[readable[0].to_int()]
    digit1.visible = true
    digit2.visible = false
    digit3.visible = false
  elif length == 2:
    digit1.texture = sprites[readable[0].to_int()]
    digit2.texture = sprites[readable[1].to_int()]
    digit1.visible = true
    digit2.visible = true
    digit3.visible = false
  else:
    digit1.texture = sprites[readable[0].to_int()]
    digit2.texture = sprites[readable[1].to_int()]
    digit3.texture = sprites[readable[2].to_int()]
    digit1.visible = true
    digit2.visible = true
    digit3.visible = true


func _in_progress() -> bool:
  return animation_player.current_animation != "" and animation_player.current_animation_position > 0


func _unhandled_key_input(event: InputEventKey) -> void:
  if event.echo || event.pressed: return
  if event.scancode == KEY_V:
    disappear()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_B:
    appear()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_N:
    reset()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_U:
    var _result = tween.interpolate_property(
      self,
      @"score",
      0, # initial
      3, # final
      0.15, # duration
      Tween.TRANS_LINEAR,
      Tween.EASE_IN_OUT,
      0 # delay
    )
    _result = tween.start()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_K:
    animation_player.set_speed_scale(0.25)
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_L:
    animation_player.set_speed_scale(1)
    get_tree().set_input_as_handled()
