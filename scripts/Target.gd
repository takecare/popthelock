class_name Target extends Sprite

const TARGET_Y_OFFSET = 74

export (NodePath) var lockPath = null
var lock: Lock = null

func _ready() -> void:
  #assert(lockPath != null, "ERROR: lockPath is null.");
  #lock = get_node(lockPath)
  pass

func _process(_delta: float) -> void:
  pass

func rotate_around(point: Vector2, angle: float):
  var rot = deg2rad(angle)
  global_translate(-point)
  transform = transform.rotated(rot)
  global_translate(point)
