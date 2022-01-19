class_name Score extends Node2D

export(int) var score = 3 setget set_score,get_score

onready var currentScoreLayer: ScoreLayer = $CurrentScoreLayer
onready var nextScoreLayer: ScoreLayer = $NextScoreLayer

signal updated

func _ready() -> void:
  currentScoreLayer.set_score(score)

  currentScoreLayer.visible = true
  nextScoreLayer.visible = false
  var _result = currentScoreLayer.connect("appeared", self, "_current_appeared")
  _result = currentScoreLayer.connect("disappeared", self, "_current_disappeared")
  _result = nextScoreLayer.connect("appeared", self, "_next_appeared")
  _result = nextScoreLayer.connect("disappeared", self, "_next_disappeared")

func center_on(_point: Vector2):
  currentScoreLayer.center_on(_point)
  nextScoreLayer.center_on(_point)
  pass

func get_score() -> int:
  return currentScoreLayer.get_score()

enum Mode { INCREASING, DECREASING, NEXT_LEVEL }
var mode = Mode.DECREASING

func set_score(new: int) -> void:
  # we need to check if it's null because the first time this runs,
  # currentScoreLayer is not set yet
  if currentScoreLayer == null:
    return
  print("[SCORE] setting score to "+str(new))
  currentScoreLayer.set_score(new)
  score = new

func next_level(new: int) -> void:
  print("[SCORE] next level. setting score to "+str(new))
  mode = Mode.NEXT_LEVEL
  # TODO animate count from 0 to new
  currentScoreLayer.set_score(new)
  score = new

func increase() -> void:
  mode = Mode.INCREASING
  nextScoreLayer.set_score(score + 1)
  currentScoreLayer.disappear()
  nextScoreLayer.appear()

# ff = fastforward (TODO) useful when going from 1 to 0 so we can animate from
# 0 to NEW
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

func _next_appeared() -> void:
  currentScoreLayer.reset()
  nextScoreLayer.reset(false)

  if mode == Mode.NEXT_LEVEL:
    currentScoreLayer.set_score(score)
    return

  print("[SCORE] animation finished. current score="+str(score))
  if mode == Mode.DECREASING:
    set_score(score - 1) # score = score - 1
  else:
    set_score(score + 1) # score = score + 1
  print("[SCORE] animation finished. setting score to "+str(score))
  currentScoreLayer.set_score(score)

func _next_disappeared() -> void:
  pass

# TODO debug only. remove
func _unhandled_key_input(event: InputEventKey) -> void:
  if event.echo || event.pressed: return
  if event.scancode == KEY_W:
    increase()
    get_tree().set_input_as_handled()
  if event.scancode == KEY_S:
    decrease()
    get_tree().set_input_as_handled()
