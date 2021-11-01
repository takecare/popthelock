class_name Score extends Node2D

export(int) var score = 0 setget set_score,get_score

onready var currentScoreLayer: ScoreLayer = $CurrentScoreLayer

func _ready() -> void:
  #set_score(score)
  pass

func get_score() -> int:
  return currentScoreLayer.get_score()


func set_score(new: int) -> void:
  if currentScoreLayer == null:
    return
  currentScoreLayer.set_score(new)


func increase():
  # TODO animate (quick scale+fade)
  score += 1
  pass


func reset():
  # TODO animate counting down until 0
  score = 0
  currentScoreLayer.reset()
  pass


func _unhandled_key_input(event: InputEventKey) -> void:
  if event.echo || event.pressed: return
  if event.scancode == KEY_G:
    currentScoreLayer.disappear()
  elif event.scancode == KEY_H:
    currentScoreLayer.reset()
  elif event.scancode == KEY_F:
    currentScoreLayer.increase()
  get_tree().set_input_as_handled()
