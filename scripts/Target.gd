class_name Target extends Sprite

const TARGET_Y_OFFSET = 74

onready var pivot: Position2D = $Pivot

export (NodePath) var lockPath = null
var lock: Lock = null

func _ready() -> void:
  assert(lockPath != null, "ERROR: lockPath is null.");
  lock = get_node(lockPath)
  #position.x = lock.center.global_position.x
  #position.y = lock.body.rect_position.y + TARGET_Y_OFFSET #lock.body.get_global_rect().size

func _process(delta: float) -> void:
  pass
