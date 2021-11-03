class_name Score extends Node2D

export(int) var score = 0 setget set_score,get_score

onready var currentScoreLayer: ScoreLayer = $CurrentScoreLayer
onready var nextScoreLayer: ScoreLayer = $NextScoreLayer

func _ready() -> void:
  currentScoreLayer.visible = true
  currentScoreLayer.visible = false
  var _result = currentScoreLayer.connect("appeared", self, "_current_appeared")
  _result = currentScoreLayer.connect("disappeared", self, "_current_disappeared")
  _result = nextScoreLayer.connect("appeared", self, "_next_appeared")
  _result = nextScoreLayer.connect("disappeared", self, "_next_disappeared")
  pass

func get_score() -> int:
  return currentScoreLayer.get_score()

func set_score(new: int) -> void:
  # we need to check if it's null because the first time this runs,
  # currentScoreLayer is not set yet
  if currentScoreLayer == null:
    return
  currentScoreLayer.set_score(new)
  nextScoreLayer.set_score(new + 1)

func increase() -> void:
  var nextScore = score + 1
  score += 1
  # TODO play "disappear" in CurrentScoreLayer
  # TODO play "appear" in NextScoreLayer
  # TODO when "appear" animation is over, update 'score'
  # TODO when "appear" animation is over, swap layers
  nextScoreLayer.set_score(nextScore)
  currentScoreLayer.disappear()
  nextScoreLayer.appear()
  pass

func reset() -> void:
  # TODO animate counting down until 0
  score = 0
  currentScoreLayer.reset()
  pass

func _current_appeared() -> void:
  print("> current appeared")
  pass

func _current_disappeared() -> void:
  print("> current disappeared: " + str(nextScoreLayer.get_score()))
  currentScoreLayer.set_score(nextScoreLayer.get_score())
  currentScoreLayer.reset()
  currentScoreLayer.visible = true
  nextScoreLayer.visible = false
  pass

func _next_appeared() -> void:
  print("> next appeared")
  #
  pass

func _next_disappeared() -> void:
  print("> next disappeared")
  pass

func _unhandled_key_input(event: InputEventKey) -> void:
  if event.echo || event.pressed: return
  if event.scancode == KEY_G:
    currentScoreLayer.disappear()
  elif event.scancode == KEY_H:
    currentScoreLayer.reset()
  elif event.scancode == KEY_F:
    increase()
  get_tree().set_input_as_handled()
