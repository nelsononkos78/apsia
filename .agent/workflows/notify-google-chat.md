---
description: Notificar a Google Chat al finalizar un análisis o desarrollo
---

Cada vez que finalices una implementación, desarrollo o análisis significativo, debes enviar una notificación al webhook de Google Chat del usuario.

### Pasos:

1. **Preparar el resumen**: Redacta un resumen conciso de los cambios realizados, problemas resueltos o resultados del análisis.
2. **Ejecutar el comando curl**:
// turbo
```bash
curl -X POST -H "Content-Type: application/json" -d '{"text": "Listo Jefe termine su pedido, venga a revisarlo\n\n**Resumen:**\n[TU_RESUMEN_AQUÍ]"}' "https://chat.googleapis.com/v1/spaces/AAAAti76wJk/messages?key=AIzaSyDdI0hCZtE6vySjMm-WEfRq3CPzqKqqsHI&token=buob97AjiZ_f3YQpj19drjM_h6Zq8Cp-vZHw-CxsomU"
```

### Reglas:
- Este paso es **obligatorio** al final de cada tarea.
- El mensaje debe incluir siempre el resumen de lo realizado.
- Utiliza el formato de texto enriquecido de Google Chat si es necesario para mejorar la legibilidad.
