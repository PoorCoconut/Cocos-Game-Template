extends Trail

func _get_position():
	#print("THE TRAIL NODE SAYS THE PLAYER IS @ ", get_tree().get_first_node_in_group("player").global_position)
	return get_tree().get_first_node_in_group("player").global_position
