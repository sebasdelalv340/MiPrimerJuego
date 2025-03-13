extends Control

const URL_GET = "https://apijuego.onrender.com/api/Players/top10"
const URL_POST = "https://apijuego.onrender.com/api/Players"

@onready var score_table = $ScoreTable
@onready var name_input = $NameInput  # Referencia al LineEdit para el nombre
@onready var submit_button = $SubmitButton  # Referencia al Button para enviar los datos
@onready var http_request = $HTTPRequest

var is_post = false

func _ready():
	# Crear y configurar el nodo HTTPRequest
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)  # Conexión de la señal en Godot 4

	# Ejecutar una solicitud GET al iniciar
	make_get_request()
	
	
# Función para hacer una solicitud GET
func make_get_request():
	if http_request.get_http_client_status() == HTTPClient.STATUS_DISCONNECTED:
		is_post = false
		var headers = ["Content-Type: application/json"]
		http_request.request(URL_GET, headers, HTTPClient.METHOD_GET)
	else:
		print("HTTPRequest is busy. Wait for the current request to complete.")


func _on_button_pressed() -> void:
	Score_manager.set_score(0)
	get_tree().change_scene_to_file("res://scenes/tittle_scene.tscn")
	

# Función para manejar la respuesta de las solicitudes
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if response_code == 200:
		var body_string = body.get_string_from_utf8()
		var json_parse = JSON.new()
		var parse_result = json_parse.parse(body_string)
		
		if parse_result == OK:
			# Extraer los valores del JSON
			var data = json_parse.get_data()
			# Verificar si la solicitud fue POST
			if is_post:
				# Si fue POST, hacer una nueva solicitud GET para actualizar la tabla
				make_get_request()
			else:
				# Si fue GET, actualizar la tabla con los datos
				update_score_table(data)
		else:
			print("Error parsing JSON: ", json_parse.error_string)
	else:
		print("Request failed with code: ", response_code)


# Función llamada al presionar el botón de registrar puntuación
func _on_submit_button_pressed() -> void:
	var player_name = name_input.text.strip_edges()
	if player_name != "":
		if http_request.get_http_client_status() == HTTPClient.STATUS_DISCONNECTED:
			save_score(player_name)
			name_input.text = ""  # Limpiar el campo de entrada
		else:
			print("HTTPRequest is busy. Wait for the current request to complete.")
	else:
		print("Por favor ingrese un nombre válido.")


func update_score_table(scores: Array) -> void:
	score_table.clear()
	score_table.set_columns(2)
	score_table.set_column_title(0, "Jugador")
	score_table.set_column_title(1, "Puntuación")

	var root = score_table.create_item()
	for score in scores:
		var item = score_table.create_item(root)
		item.set_text(0, score.get("Name"))
		item.set_text(1, str(score.get("MaxScore", 0)))

# Función para guardar la puntuación del jugador
func save_score(player_name: String) -> void:
	var data = {
		"Name": player_name,
		"MaxScore": Score_manager.get_score() # Pasa la puntuación actual (puedes reemplazarla con la lógica de tu juego)
		}
	var json = JSON.new()  # Crear una instancia de JSON
	var json_data = json.stringify(data)  # Convertir el diccionario a JSON

	var headers = ["Content-Type: application/json"]
	is_post = true
	http_request.request(URL_POST, headers, HTTPClient.METHOD_POST, json_data)
