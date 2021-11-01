extends HBoxContainer

func _ready():
  for c in get_children():
    var _result = c.connect("visibility_changed", self, "_on_child_visibility_changed")
  pass


func _on_child_visibility_changed():
  print("child vis changed")


# we get notified to sort our children whenever there's a change in them (i.e.
# one comes visible/invisible). when that happens we want to update our pivot
# offset so it's always coincided with the center of this container:
#              score:  [ 1 2 3 ]    [ 1 2 ]  [ 1 ]
# pivot offset H pos:      x           x       x
# if we don't do this, the pivot offset stays the same regardless of how wide
# this container is

func _notification(what):
  if what == NOTIFICATION_SORT_CHILDREN:
    set_pivot_offset(rect_size/2)
