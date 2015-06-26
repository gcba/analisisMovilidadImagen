base_url = "https://apisensores.buenosaires.gob.ar/app_dev.php"
account = {
    "get_all": {
        "method": "GET",
        "url": "%s/api/cuenta"
    },
    "create": {
        "method": "POST",
        "url": "%s/api/cuenta/create"

    },
    "get": {
        "method": "GET",
        "url": "%s/api/cuenta/{id}"
    },
    "delete": {
        "method": "PUT",
        "url": "%s/api/cuenta/{id}/baja"

    },
    "update": {
        "method": "PUT",
        "url": "%s/api/cuenta/{id}/update"

    }
}
sensor = {
    "change_state": {
        "method": "PUT",
        "url": "%s/api/sensor/cambiarestado"
    },
    "create": {
        "method": "POST",
        "url": "%s/api/sensor/create"
    },
    "get": {
        "method": "GET",
        "url": "%s/api/sensor/{id}"
    },
    "delete": {
        "method": "PUT",
        "url": "%s/api/sensor/{id}/baja"
    },
    "update": {
        "method": "PUT",
        "url": "%s/api/sensor/{id}/update"
    },
    "get_all": {
        "method": "GET",
        "url": "%s/api/sensores"
    },
    "get_all_with_datatypes": {
        "method": "GET",
        "url": "%s/api/sensorestipodato"
    }
}
datatype = {
    "create": {
        "method": "POST",
        "url": "%s/api/sensor/tipo/data_type/create"
    },
    "get": {
        "method": "GET",
        "url": "%s/api/sensor/tipo/data_type/{id}"
    },
    "update": {
        "method": "PUT",
        "url": "%s/api/sensor/tipo/data_type/{id}/update"
    },
    "get_from_sensor_type": {
        "method": "GET",
        "url": "%s/api/sensor/tipo/{id}/data_type"
    },
    "get_from_sensor": {
        "method": "GET",
        "url": "%s/api/sensor/{id}/tipo/data_type"
    }
}
sensor_type = {
    "get_all": {
        "method": "GET",
        "url": "%s/api/sensor/tipo"
    },
    "create": {
        "method": "POST",
        "url": "%s/api/sensor/tipo/create"
    },
    "get": {
        "method": "GET",
        "url": "%s/api/sensor/tipo/{id}"
    },
    "update": {
        "method": "PUT",
        "url": "%s/api/sensor/tipo/{id}/update"
    },
    "get_from_sensor": {
        "method": "GET",
        "url": "%s/api/sensor/{id}/tipo"
    }
}
data = {
    "create": {
        "method": "POST",
        "url": "%s/api/data/create"
    },
    "dynamic_create": {
        "method": "POST",
        "url": "%s/api/data/dynamic/create"
    },
    "get": {
        "method": "GET",
        "url": "%s/api/data/{id}"
    },
    "get_last": {
        "method": "GET",
        "url": "%s/api/data/{id}/last"
    },
    "get_multiple_lasts": {
        "method": "GET",
        "url": "%s/api/data/{id}/status"
    }
}

for endpoint in [account, sensor, datatype, sensor_type, data]:
    for action in endpoint:
        endpoint[action]['url'] %= base_url
