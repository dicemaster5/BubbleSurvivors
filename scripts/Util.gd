class_name Util extends Node

static func format_time_string(time: int, verbose = false) -> String:
	var hrs = time / 3600
	var min = fmod(time / 60, 60)
	var sec = fmod(time, 60)
	var hrsString = "%d hours %d minutes %02d seconds" if verbose else "%02d:%02d:%02d"
	var minString = "%d minutes %02d seconds" if verbose else "%02d:%02d"

	if hrs > 0:
		return hrsString % [hrs, min, sec]
	return minString % [min, sec]
