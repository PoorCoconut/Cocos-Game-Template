extends Node
class_name HealthComponent

@export var MAX_HP : int
## Saving Grace stops one-shots. When damage is fatal, sets health to 1 instead (one-time).
@export var hasSavingGrace : bool = false
var CUR_HP : int

signal hp_changed(new_hp, max_hp)
signal died

func _ready() -> void:
	## Only set CUR_HP to MAX_HP on a true fresh start.
	## If GameManager already has stats, Player._ready() will overwrite these
	## values immediately after via restore_player_stats() — so this default
	## is only ever used the very first time the component boots with no save.
	CUR_HP = MAX_HP

##FLAT DAMAGE
func take_damage(damage : int) -> void:
	if hasSavingGrace and CUR_HP - damage <= 0:
		CUR_HP = 1
		hasSavingGrace = false
	else:
		CUR_HP = clampi(CUR_HP - damage, 0, MAX_HP)

	hp_changed.emit(CUR_HP, MAX_HP)
	check_death()

func check_death() -> void:
	if CUR_HP <= 0:
		died.emit()
