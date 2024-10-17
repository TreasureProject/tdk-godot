extends Node

var Identity = preload("res://addons/tdk/modules/identity.gd")
var Analytics = preload("res://addons/tdk/modules/analytics.gd")

var _identity = Identity.new()
var _analytics = Analytics.new()

func _init() -> void:
	add_child(_identity)
	add_child(_analytics)

func get_auth_token():
	return _identity.get_auth_token()

func get_user(api_url: String, auth_token: String) -> Dictionary:
	return await _identity.get_user(api_url, auth_token)

func start_session(
	backendWallet: String,
	approvedTargets: Array,
	nativeTokenLimitPerTransaction: int = 0,
	sessionDurationSec: int = 0,
	sessionMinDurationLeftSec: int = 0
) -> Dictionary:
	return await _identity.start_session(
		backendWallet,
		approvedTargets,
		nativeTokenLimitPerTransaction,
		sessionDurationSec,
		sessionMinDurationLeftSec
	)

func track_custom_event(event_name: String, event_props: Dictionary):
	await _analytics.track_custom_event(event_name, event_props)
