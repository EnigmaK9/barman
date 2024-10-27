# Final Project Barman

**Final Project Barman** es una aplicación iOS que permite a los usuarios explorar y agregar recetas de bebidas. La app muestra una lista de bebidas descargadas de un servidor y permite al usuario agregar sus propias recetas, que se almacenan utilizando Core Data.

## Características

- **Listado de Bebidas**: Muestra una lista de bebidas con imágenes y nombres.
- **Detalle de Receta**: Al seleccionar una bebida, se muestra la receta con ingredientes y pasos.
- **Agregar Nueva Bebida**: Los usuarios pueden agregar sus propias recetas personalizadas.
- **Almacenamiento Local**: Las recetas agregadas por el usuario se almacenan en Core Data.
- **Descarga de Datos**: Las bebidas predeterminadas se descargan desde un servidor remoto en formato JSON.
- **Cacheo de Imágenes**: Las imágenes de las bebidas se descargan y almacenan localmente.

## Requisitos

- iOS 13.0 o superior
- Xcode 11 o superior

## Instalación

1. Clona este repositorio:
   ```bash
   git clone https://github.com/tu_usuario/FinalProjectBarman.git
Abre el proyecto en Xcode:
bash
Copy code
cd FinalProjectBarman
open FinalProjectBarman.xcodeproj
Ejecuta la aplicación en un simulador o dispositivo.
Uso

Explorar Bebidas: Navega por la lista de bebidas y selecciona una para ver los detalles.
Agregar Bebida: Pulsa el botón "+" en la esquina superior derecha para agregar una nueva receta.
Almacenar Recetas: Las recetas agregadas se guardan y se muestran en la lista principal.
Estructura del Proyecto

AppDelegate.swift y SceneDelegate.swift: Configuración de la aplicación.
DrinksListViewController.swift: Controlador de la lista de bebidas.
DrinkTableViewCell.swift: Celda personalizada para mostrar bebidas.
RecipeViewController.swift: Controlador para mostrar y agregar recetas.
DataManager.swift: Manejo de datos, descarga y almacenamiento.
InternetMonitor.swift: Monitoreo del estado de la conexión a Internet.
Drink.swift: Modelo de datos para las bebidas.
Recursos

Imágenes: Las imágenes se descargan desde http://janzelaznog.com/DDAM/iOS/drinksimages/.
Datos JSON: Los datos de las bebidas se obtienen de http://janzelaznog.com/DDAM/iOS/drinks.json.
Créditos

Desarrollado por Carlos Ignacio Padilla Herrera.
Agradecimientos a los recursos gratuitos utilizados en imágenes y fuentes.
Licencia

Este proyecto se distribuye bajo la licencia MIT. Consulta el archivo LICENSE para más detalles.



