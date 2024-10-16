extends Resource

enum Env { DEV, PROD }

@export var environment : Env

@export_group("General")
@export var cartridge_tag = ""
@export var cartridge_name = ""
@export var bundle_id = "" # TODO get from engine if possible

@export_group("Analytics")
@export var dev_api_url : String
@export var prod_api_url : String
