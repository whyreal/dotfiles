{
	"title": "grave_accent_and_tilde",
	"rules":[
		{
			"description": "Change grave_accent_and_tilde to Control when used as modifier, grave_accent_and_tilde when used alone",
			"manipulators": [
				{
					"from": {
						"key_code": "grave_accent_and_tilde",
						"modifiers": {
							"optional": [
								"any"
							]
						}
					},
					"to": [
						{
							"key_code": "left_control",
							"lazy": true
						}
					],
					"to_if_alone": [
						{
							"key_code": "grave_accent_and_tilde"
						}
					],
					"to_if_held_down": [
						{
							"key_code": "grave_accent_and_tilde"
						}
					],
					"type": "basic"
				}
			]
		}
	]
}
