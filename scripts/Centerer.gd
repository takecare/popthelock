extends Container

# goal: update pivot_offest when children are hidden/displayed

# need to know total available width - i.e. my own width
# need to know space (horizontal) between each item to place
#

func _ready() -> void:
  pass

func _process(_delta: float) -> void:
  pass

enum LayoutMode { SPREAD, PACKED }
var mode = LayoutMode.PACKED

func _notification(what):
  if what == NOTIFICATION_SORT_CHILDREN:
    assert(mode == LayoutMode.SPREAD || mode == LayoutMode.PACKED, "Unsupported layout mode.")
    print("> re-size requested")
    if mode == LayoutMode.PACKED:
      layout_children_packed()
    elif mode == LayoutMode.SPREAD:
      layout_children_spread()

func layout_children_packed() -> void:
  for i in get_child_count():
      var child = get_child(i)
      if child.is_class("Control"):
        layout_child_packed(i, child)

func layout_children_spread() -> void:
  for i in get_child_count():
      var child = get_child(i)
      if child.is_class("Control"):
        layout_child_spread(i, child)

# spread children horizontally
func layout_child_spread(num: int, child: Control) -> void:
  var rect_size = _get_rect_size()
  var available_width = rect_size.x
  var available_height = rect_size.y
  var num_children = get_child_count()
  var width_per_child = available_width / num_children
  var child_pos = Vector2(width_per_child * (num+1), 0)
  var child_size = Vector2(width_per_child, 0)
  fit_child_in_rect(child, Rect2(child_pos, child_size))

#
func layout_child_packed(num: int, child: Control) -> void:
  var rect_size = _get_rect_size()
  var available_width = rect_size.x
  var available_height = rect_size.y
  var center = rect_size / 2
  # middle child must be centered within this container, if we have an odd number of children
  # if the num of children are even, then we have to place X/2 to the left and X/2 to the right of the center
  pass


func _get_rect_size() -> Vector2:
  if rect_size.x == 0 && rect_size.y == 0:
    return rect_min_size
  else:
    return rect_size


func set_some_setting():
  # Some setting changed, ask for children re-sort
  queue_sort()

func _unhandled_key_input(event: InputEventKey) -> void:
  if event.echo || event.pressed: return
  if event.scancode == KEY_G:
    $AnimationPlayer.play("Test")
  elif event.scancode == KEY_H:
    $TextureRect2.visible = !$TextureRect2.visible
  elif event.scancode == KEY_J:
    rect_pivot_offset = Vector2(rect_pivot_offset.x + 10, rect_pivot_offset.y + 10)
  get_tree().set_input_as_handled()
