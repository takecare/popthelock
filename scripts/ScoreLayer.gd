class_name ScoreLayer extends CenterContainer

export(int) var score = 0 setget set_score,get_score

onready var hBoxContainer: HBoxContainer = $HBoxContainer
onready var digit1: TextureRect = $HBoxContainer/Digit1
onready var digit2: TextureRect = $HBoxContainer/Digit2
onready var digit3: TextureRect = $HBoxContainer/Digit3

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
  #text = str(score)
  offset_pivot()
  pass

func center_on(point: Vector2):
  set_global_position(
    Vector2(point.x - rect_size.x / 2, point.y - rect_size.y / 2)
  )

func increase():
  # TODO animate (quick scale+fade)
  score += 1
  update()
  offset_pivot() # TODO re-calculate pivot offset on hBoxContainer

func reset():
  # TODO animate counting down until 0
  score = 0
  update()
  offset_pivot() # TODO re-calculate pivot offset on hBoxContainer

func get_score() -> int:
  return score

func set_score(new: int) -> void:
  score = new
  update()
  offset_pivot() # TODO re-calculate pivot offset on hBoxContainer

func offset_pivot():
  # pivot offset on hBoxContainer must be its w/2 and its h/2
  hBoxContainer.rect_pivot_offset = hBoxContainer.rect_size / 2

func update():
  var readable = str(score)
  var length = readable.length()
  if length == 1:
    digit1.visible = true
    digit2.visible = false
    digit3.visible = false
    digit1.texture = sprites[readable[0].to_int()]
  elif length == 2:
    digit1.visible = true
    digit2.visible = true
    digit3.visible = false
    digit1.texture = sprites[readable[0].to_int()]
    digit2.texture = sprites[readable[1].to_int()]
  else:
    digit1.visible = true
    digit2.visible = true
    digit3.visible = true
    digit1.texture = sprites[readable[0].to_int()]
    digit2.texture = sprites[readable[1].to_int()]
    digit3.texture = sprites[readable[2].to_int()]
