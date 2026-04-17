# INPARQUES PDF Manager Skill

## Descripción
Este skill define las reglas obligatorias para la generación, estructuración y modificación de documentos PDF en el Sistema de Gestión de Guardias de INPARQUES, utilizando los paquetes `pdf` y `printing` de Flutter.

## Reglas de Arquitectura
1. Todo nuevo reporte o modificación debe aislarse estrictamente en la carpeta `logic` de su respectivo *feature* (por ejemplo, `lib/src/features/reports/logic/pdf_generator_service.dart` o `lib/src/features/incidents/logic/acta_generator.dart`).
2. Los datos a imprimir deben agruparse previamente en Data Transfer Objects (DTOs), como `ReporteDataDTO` o `ActaDataDTO`, antes de inyectarlos al generador PDF.
3. El generador PDF **NUNCA** debe ejecutar consultas directas a la base de datos local (Drift). Toda la información debe venir resuelta y precargada desde el controlador.

## Reglas de Diseño y Formato Legal
1. Utilizar siempre fuentes robustas o pre-cargadas (ej. `PdfGoogleFonts.nunitoExtraLight()` o `pw.Font.courier()`) para evitar excepciones de renderizado en dispositivos móviles.
2. Los membretes oficiales deben conservar la estructura jerárquica: "REPÚBLICA BOLIVARIANA DE VENEZUELA", "MINISTERIO DEL PODER POPULAR PARA EL ECOSOCIALISMO" e "INSTITUTO NACIONAL DE PARQUES".
3. Toda fecha impresa debe formatearse con el paquete `intl` siguiendo el patrón `dd/MM/yyyy` (o el indicado según el contexto legal del acta).
4. El manejo de las firmas en cascada debe prever valores nulos (Fallback a "S/R" o "ADMINISTRADOR") para evitar colapsos al generar el documento.

## Reglas de Ejecución del Agente
Cada vez que se solicite intervenir la lógica de los PDFs, debes aplicar estos lineamientos rigurosamente, indicar siempre la ruta del archivo afectado y entregar la totalidad del código resultante.
