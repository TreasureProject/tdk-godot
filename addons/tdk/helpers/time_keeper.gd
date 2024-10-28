extends Node

const SERVER_TIME_ENDPOINT_DEV = "https://darkmatter.spellcaster.lol/utils/time-unix"
const SERVER_TIME_ENDPOINT_PROD = "https://darkmatter.treasure.lol/utils/time-unix"
const RETRY_INTERVAL = 5

var Http = preload("res://addons/tdk/helpers/http.gd")
var http = Http.new(self)

var tdk_config = preload("res://addons/tdk/resources/tdk_config.tres")

var _is_fectching_time = false
var _did_fetch = false
var _timer = Timer.new()

var _epoch_time_diff = 0

func _ready() -> void:
	_fetch_server_time()
	_timer.wait_time = RETRY_INTERVAL
	_timer.autostart = true
	_timer.timeout.connect(_fetch_server_time)
	add_child(_timer)

func _fetch_server_time():
	if _is_fectching_time or _did_fetch:
		return
	_is_fectching_time = true
	
	var response = await http.http_get(
		SERVER_TIME_ENDPOINT_DEV if tdk_config.is_dev_env()
		else SERVER_TIME_ENDPOINT_PROD
	)
	
	var success = response.response_code >= 200 and response.response_code < 400
	if success:
		_did_fetch = true
		_epoch_time_diff = int(response.body) - get_local_epoch_time()
		_timer.stop()
	
	_is_fectching_time = false

func get_local_epoch_time() -> int:
	return floor(Time.get_unix_time_from_system() * 1000)

func get_server_epoch_time() -> int:
	return get_local_epoch_time() + _epoch_time_diff
