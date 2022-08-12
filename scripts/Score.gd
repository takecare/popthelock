class_name Score extends Node2D

export(int) var score: int setget set_score,get_score
# warning-ignore:unused_class_variable
export(bool) var in_progress: bool = false setget ,_in_progress

onready var current_score_layer: ScoreLayer = $CurrentScoreLayer
onready var next_score_layer: ScoreLayer = $NextScoreLayer

func _ready() -> void:
  current_score_layer.set_score(score)
  current_score_layer.visible = true
  next_score_layer.visible = false
  var _result = current_score_layer.connect("appeared", self, "_current_appeared")
  _result = current_score_layer.connect("disappeared", self, "_current_disappeared")
  _result = next_score_layer.connect("appeared", self, "_next_appeared")
  _result = next_score_layer.connect("disappeared", self, "_next_disappeared")

func center_on(_point: Vector2) -> void:
  current_score_layer.center_on(_point)
  next_score_layer.center_on(_point)


func get_score() -> int:
  return current_score_layer.get_score()


# state for the current score, it can be
# RESTING: nothing is happening
# INCREASING: score is increasing, increase animation is playing
# DECREASING: score is decreasing, decrease animation is playing
# NEXT_LEVEL: score is quickly animating from 0 to X
enum Mode { RESTING, INCREASING, DECREASING, NEXT_LEVEL }
var mode = Mode.RESTING


func set_score(new: int) -> void:
  # we need to check if it's null because the first time this runs,
  # current_score_layer is not yet set
  if current_score_layer == null:
    return
  current_score_layer.set_score(new)
  score = new


func next_level(new: int) -> void:
  mode = Mode.NEXT_LEVEL
  #current_score_layer.set_score(new) #current_score_layer.animate_to(new)
  score = new


func increase() -> void:
  mode = Mode.INCREASING
  next_score_layer.set_score(score + 1)
  current_score_layer.disappear()
  next_score_layer.appear()


# ff = fastforward: useful when going from 1 to 0,
# so we can animate from 0 to NEW quickly
func decrease(ff: bool = false) -> void:
  mode = Mode.DECREASING
  next_score_layer.set_score(score - 1)
  current_score_layer.disappear(ff)
  next_score_layer.appear(ff)


func reset() -> void:
  # TODO animate counting down until 0
  set_score(0)
  current_score_layer.reset()
  next_score_layer.reset(false)


func _current_appeared() -> void:
  pass


func _current_disappeared() -> void:
  pass


signal handled


func _next_appeared() -> void:
  current_score_layer.reset()
  next_score_layer.reset(false)
  if mode == Mode.NEXT_LEVEL:
    current_score_layer.animate_to(score)
    return
  current_score_layer.reset()
  if mode == Mode.DECREASING:
    set_score(score - 1) # score = score - 1
  else:
    set_score(score + 1) # score = score + 1
  current_score_layer.set_score(score)
  mode = Mode.RESTING
  emit_signal("handled")


func _next_disappeared() -> void:
  pass


# check if any of the layers are currently animating
func _in_progress() -> bool:
  return current_score_layer.in_progress || next_score_layer.in_progress


# debug only. remove extra _ to use.
func __unhandled_key_input(event: InputEventKey) -> void:
  if event.echo || event.pressed: return
  if event.scancode == KEY_W:
    increase()
    get_tree().set_input_as_handled()
  if event.scancode == KEY_S:
    decrease()
    get_tree().set_input_as_handled()
