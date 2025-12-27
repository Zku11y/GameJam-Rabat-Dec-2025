extends ProgressBar

@onready var timer = $Timer
@onready var dmg_bar = $dmgbar

var blood = 0 : set = _set_blood

func _set_blood(nu_blood):
	var prev_blood = blood
	blood = min(max_value, nu_blood)
	value = blood

	if blood <= 0 || blood > max_value:
		queue_free()

	if blood < prev_blood:
		timer.start()
	else:
		dmg_bar.value = blood

func init_health(_health):
	blood = _health
	max_value = blood
	value = blood
	dmg_bar.max_value = blood
	dmg_bar.value = blood

func _on_timer_timeout():
	dmg_bar.value = blood
