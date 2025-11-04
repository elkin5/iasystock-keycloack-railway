# Keycloak personalizado para Railway

Este repositorio prepara una imagen de Keycloak 23.0.7 lista para desplegar en Railway con:

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/mSwigX?referralCode=AkM2z4)

- Importación automática del realm `iasy-stock`.
- Tema personalizado `iasystock` para las pantallas de autenticación.
- Configuración base (`keycloak.conf`) afinada para entornos de desarrollo alojados.

## Estructura

- `Dockerfile`: construye la imagen final usando una etapa de compilación (`kc.sh build`) e incluye el tema, la configuración y el realm.
- `keycloak.conf`: activa la importación de realms y deshabilita el cacheo de temas para facilitar iteraciones.
- `realm-config/iasy-stock-realm.json`: definición del realm que se importará en el primer arranque.
- `theme/iasystock`: archivos del tema de login.
- `java.config`: restricciones criptográficas adicionales aplicadas a la JVM.

## Despliegue en Railway

1. Crea un proyecto en Railway e importa este repositorio.
2. Configura las variables de entorno mínimas necesarias:
   - `KEYCLOAK_ADMIN`, `KEYCLOAK_ADMIN_PASSWORD`
   - `KC_DB=postgres`
   - `KC_DB_USERNAME`, `KC_DB_PASSWORD`
   - `KC_DB_URL` (por ejemplo `jdbc:postgresql://HOST:PORT/DATABASE`)
3. Opcionalmente ajusta `KC_HOSTNAME`, `KC_PROXY`, u otras variables que requiera tu entorno.

El contenedor se ejecutará con `kc.sh start --optimized --import-realm --import-realm-strategy=OVERWRITE_EXISTING`, por lo que si actualizas el archivo del realm, reemplaza la entrada subiendo una nueva imagen.

## Ejecución local

```
docker build -t iasystock-keycloak .
docker run --rm -p 8080:8080 \
  -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin123 \
  -e KC_DB=postgres -e KC_DB_USERNAME=postgres -e KC_DB_PASSWORD=postgres \
  -e KC_DB_URL='jdbc:postgresql://host.docker.internal:5432/keycloakdb' \
  iasystock-keycloak start-dev --import-realm --import-realm-strategy=OVERWRITE_EXISTING
```

En modo `start-dev` se mantienen las mismas rutas de importación y el tema personalizado para iterar rápidamente.
