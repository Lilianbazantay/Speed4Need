extends Node

var sensibility: float = 1;
var soundMusic: float = 50;
var soudEffects: float = 50;
var soundEnabled: bool = true;
var timerEnabled: bool = true;


# LOAD / SAVE SYSTEM

var SETTINGS_PATH : String = "user://settings.cfg"

func save_settings():
	var cfg := ConfigFile.new()
	cfg.set_value("controls", "sensibility", sensibility)
	cfg.set_value("audio", "music", soundMusic)
	cfg.set_value("audio", "effects", soudEffects)
	cfg.set_value("audio", "enabled", soundEnabled)
	cfg.set_value("gameplay", "timer_enabled", timerEnabled)
	cfg.save(SETTINGS_PATH)

func load_settings():
	var cfg := ConfigFile.new()
	var err := cfg.load(SETTINGS_PATH)
	if err != OK:
		return
	sensibility = cfg.get_value("controls", "sensibility", sensibility)
	soundMusic = cfg.get_value("audio", "music", soundMusic)
	soudEffects = cfg.get_value("audio", "effects", soudEffects)
	soundEnabled = cfg.get_value("audio", "enabled", soundEnabled)
	timerEnabled = cfg.get_value("gameplay", "timer_enabled", timerEnabled)
