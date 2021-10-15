class_name Score extends Node2D

export(int) var score = 0

onready var currentScoreLayer: ScoreLayer = $CurrentScoreLayer

func _ready() -> void:
  #text = str(score)
  currentScoreLayer.set_score(0)
  pass

func center_on(point: Vector2):
  #set_global_position(Vector2(point.x - rect_size.x / 2, point.y - rect_size.y / 2))
  pass

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
