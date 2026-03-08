extends Node
class_name State

@export var PLAYER : Player
@export var ENTITY : CollisionObject2D
@warning_ignore("unused_signal")
signal transition

#What happens when this state is the current state?
func enterState():
	pass

#What happens during the state's turn / lifetime?
#Usually where the state's code is placed
func updateState(_delta : float):
	pass

#What happens when this state doesn't become the current state?
#Usually ignorable
func exitState():
	pass
