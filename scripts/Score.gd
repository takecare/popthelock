class_name Score extends TextureRect

export(int) var score = 0

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
  pass

func center_on(point: Vector2):
  set_global_position(
    Vector2(point.x - rect_size.x / 2, point.y - rect_size.y / 2)
  )

func increase():
  # TODO animate (quick scale+fade)
  score += 1

func reset():
  # TODO animate counting down until 0
  score = 0

func update():
  var readable = str(score)
  for i in range(0, readable.length()):
    print(i)
  pass
