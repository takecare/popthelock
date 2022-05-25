extends HBoxContainer

# TODO remove this
func _ready():
  for c in get_children():
    var _result = c.connect("visibility_changed", self, "_on_child_visibility_changed")
  pass


func _on_child_visibility_changed():
  pass


# we get notified to sort our children whenever there's a change in them (i.e.
# one becomes visible/invisible). when that happens we want to update our pivot
# offset so it's always coinciding with the center of this hboxcontainer:
#
#              score:  [ 1 2 3 ]    [ 1 2 ]  [ 1 ]
# pivot offset H pos:      x           x       x
#
# if we don't do this, the pivot offset stays the same regardless of how wide
# this container is. this causes transform operations (like scaling) to not
# look as expected, as they will be done relative to a pivot point that is not
# the one you'd expect. check docs the for set_pivot_offset() to learn more
# about what the pivot is
func _notification(what):
  if what == NOTIFICATION_SORT_CHILDREN:
    set_pivot_offset(rect_size/2)
