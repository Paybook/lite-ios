# Paybook Lite-ios

### Requerimientos

1. Xcode Version 7+
2. [Cocoapods](https://cocoapods.org) 
3. Un API Key de Paybook

### Descripción:

Este es un proyecto que muestra como construir una aplicación para iOS, haciendo uso de la librería de Paybook iOS, para traer información de bancos de México y Autoridades Tributarias(SAT). La aplicación tiene la siguientes características:

1. Integración completa con el API Rest de Paybook a través de la librería de Paybook para iOS [sync-ios](https://github.com/Paybook/sync-ios)
2. Cuenta con los endpoints básicos para que tu puedas construir a partir de estos tu propia aplicación, reciclándolos, o bien, agregando tus propios endpoints.
3. Cuenta con persistencia de datos para encargarse del manejo de cuentas de usuario localmente. 
4. Contiene las siguientes funcionalidades: registro de usuarios, inicio de sesión, registro y borrado de credenciales de instituciones y consulta de transacciones.



###Instalación:
Usar la terminal para clonar el proyecto en nuestro equipo.
`$ git clone https://github.com/Paybook/lite-ios.git`

###Instalar dependencias.
Trasladarse por medio de la terminal al directorio del proyecto y ejecutar el siguiente comando.
```$ pod install```

Abrir el proyecto.
```$ open -a Xcode LitePaybook.xcworkspace```


### Ejecución:

Agregar tu api_key en el archivo "Config/Config.swift" 

```swift
let api_key : String = "YOUR_API_KEY"
```

Ejecutar la aplicación en el simulador.
