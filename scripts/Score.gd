class_name Score extends Node2D

export(int) var score = 0 setget set_score,get_score

onready var currentScoreLayer: ScoreLayer = $CurrentScoreLayer
onready var nextScoreLayer: ScoreLayer = $NextScoreLayer

func _ready() -> void:
  set_score(score)
  currentScoreLayer.visible = true
  nextScoreLayer.visible = false
  var _result = currentScoreLayer.connect("appeared", self, "_current_appeared")
  _result = currentScoreLayer.connect("disappeared", self, "_current_disappeared")
  _result = nextScoreLayer.connect("appeared", self, "_next_appeared")
  _result = nextScoreLayer.connect("disappeared", self, "_next_disappeared")

func get_score() -> int:
  return currentScoreLayer.get_score()

func set_score(new: int) -> void:
  # we need to check if it's null because the first time this runs,
  # currentScoreLayer is not set yet
  if currentScoreLayer == null:
    return
  currentScoreLayer.set_score(new)
  nextScoreLayer.set_score(new + 1)
  score = new

func increase() -> void:
  currentScoreLayer.disappear()
  nextScoreLayer.appear()
  #set_score(score + 1)

func reset() -> void:
  # TODO animate counting down until 0
  score = 0
  currentScoreLayer.reset()
  nextScoreLayer.reset(false)

func _current_appeared() -> void:
  pass

func _current_disappeared() -> void:
  pass #print("> current disappeared: " + str(nextScoreLayer.get_score()))

func _next_appeared() -> void:
  currentScoreLayer.reset()
  nextScoreLayer.reset(false)
  set_score(score + 1)

func _next_disappeared() -> void:
  pass

func _unhandled_key_input(event: InputEventKey) -> void:
  if event.echo || event.pressed: return
  if event.scancode == KEY_F:
    increase()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_G:
    currentScoreLayer.disappear()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_H:
    nextScoreLayer.appear()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_J:
    currentScoreLayer.reset()
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_K:
    nextScoreLayer.reset()
    get_tree().set_input_as_handled()
