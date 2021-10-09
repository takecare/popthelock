class_name Score extends Label

export(int) var score = 0

func _ready() -> void:
  text = str(score)

func center_on(point: Vector2):
  set_global_position(
    Vector2(point.x - rect_size.x / 2, point.y - rect_size.y / 2)
  )

func increase():
  # TODO animate (quick scale+fade)
  score += 1
  text = str(score)

func reset():
  # TODO animate counting down until 0
  score = 0
  text = str(score)
