class_name Score extends Node2D

export(int) var score: int setget set_score,get_score
export(bool) var in_progress: bool = false setget ,_in_progress

onready var currentScoreLayer: ScoreLayer = $CurrentScoreLayer
onready var nextScoreLayer: ScoreLayer = $NextScoreLayer

func _ready() -> void:
  currentScoreLayer.set_score(score)
  currentScoreLayer.visible = true
  nextScoreLayer.visible = false
  var _result = currentScoreLayer.connect("appeared", self, "_current_appeared")
  _result = currentScoreLayer.connect("disappeared", self, "_current_disappeared")
  _result = nextScoreLayer.connect("appeared", self, "_next_appeared")
  _result = nextScoreLayer.connect("disappeared", self, "_next_disappeared")

func center_on(_point: Vector2) -> void:
  currentScoreLayer.center_on(_point)
  nextScoreLayer.center_on(_point)

func get_score() -> int:
  return currentScoreLayer.get_score()

# state for the current score, it can be
# RESTING: nothing is happening
# INCREASING: score is increasing, increase animation is playing
# DECREASING: score is decreasing, decrease animation is playing
# NEXT_LEVEL: score is quickly animating from 0 to X
enum Mode { RESTING, INCREASING, DECREASING, NEXT_LEVEL }
var mode = Mode.RESTING

func set_score(new: int) -> void:
  # we need to check if it's null because the first time this runs,
  # currentScoreLayer is not yet set
  if currentScoreLayer == null:
    return
  currentScoreLayer.set_score(new)
  score = new

func next_level(new: int) -> void:
  mode = Mode.NEXT_LEVEL
  #currentScoreLayer.set_score(new) #currentScoreLayer.animate_to(new)
  score = new

func increase() -> void:
  mode = Mode.INCREASING
  nextScoreLayer.set_score(score + 1)
  currentScoreLayer.disappear()
  nextScoreLayer.appear()

# ff = fastforward: useful when going from 1 to 0,
# so we can animate from 0 to NEW quickly
func decrease(ff: bool = false) -> void:
  mode = Mode.DECREASING
  nextScoreLayer.set_score(score - 1)
  currentScoreLayer.disappear(ff)
  nextScoreLayer.appear(ff)

func reset() -> void:
  # TODO animate counting down until 0
  set_score(0)
  currentScoreLayer.reset()
  nextScoreLayer.reset(false)

func _current_appeared() -> void:
  pass

func _current_disappeared() -> void:
  pass

signal handled

func _next_appeared() -> void:
  currentScoreLayer.reset()
  nextScoreLayer.reset(false)
  if mode == Mode.NEXT_LEVEL:
    currentScoreLayer.animate_to(score)
    return
  currentScoreLayer.reset()
  if mode == Mode.DECREASING:
    set_score(score - 1) # score = score - 1
  else:
    set_score(score + 1) # score = score + 1
  currentScoreLayer.set_score(score)
  mode = Mode.RESTING
  emit_signal("handled")

func _next_disappeared() -> void:
  pass

# check if any of the layers are currently animating
func _in_progress() -> bool:
  return $CurrentScoreLayer.in_progress || $NextScoreLayer.in_progress

# TODO debug only. remove
func _unhandled_key_input(event: InputEventKey) -> void:
  if event.echo || event.pressed: return
  if event.scancode == KEY_W:
    increase()
    get_tree().set_input_as_handled()
  if event.scancode == KEY_S:
    decrease()
    get_tree().set_input_as_handled()
