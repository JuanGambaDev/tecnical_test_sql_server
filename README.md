
# Sistema de Permisos

Este repositorio implementa un sistema de permisos desarrollado en SQL Server, diseñado para gestionar asignaciones de privilegios a usuarios y roles, tanto a nivel de entidad como de registro individual. Este enfoque permite un control granular del acceso, asegurando que los permisos se asignen de manera flexible y específica según las necesidades organizativas.

## Estructura del Proyecto

El proyecto está organizado en las siguientes carpetas:

- **scripts_para_crear_tablas/**: Contiene los scripts para la creación de tablas y la inserción de datos de prueba.
- **scripts_procedimientos_almacenados/**: Contiene los scripts de los procedimientos almacenados utilizados para gestionar y consultar permisos.
- **documentación/**: Incluye documentación detallada del modelo de datos y ejemplos de uso de los procedimientos.
- **videos/**: Contiene un video explicativo sobre la lógica y funcionamiento del sistema.

## Requisitos

- [SQL Server](https://www.microsoft.com/es-co/sql-server/sql-server-downloads) Versión 2019 o superior.
- **Herramientas de gestión de bases de datos**: Por ejemplo, [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16).

## Instalación y Configuración

1. **Clonar el repositorio**:
   ```bash
   git clone https://github.com/JuanGambaDev/tecnical_test_sql_server.git
   cd mi-proyecto-sistema-permisos
   ```

2. **Ejecutar los scripts de creación de tablas**:
   - Abre SQL Server Management Studio.
   - Navega a la carpeta `scripts_para_crear_tablas/`.
   - Ejecuta los archivos `.sql` en el orden indicado por los prefijos numéricos (por ejemplo, `01_crear_tablas.sql` debe ejecutarse primero).
   - También puedes utilizar el archivo `init_db.sql`, que consolida todos los scripts de creación en uno solo.

3. **Insertar datos semilla**:
   - Accede a la carpeta `scripts_datos_semilla/`.
   - Ejecuta los archivos `.sql` en el orden indicado por los prefijos numéricos (por ejemplo, `01_insertar_datos.sql` debe ejecutarse primero).

4. **Implementar los procedimientos almacenados**:
   - Navega a la carpeta `scripts_procedimientos_almacenados/`.
   - Ejecuta los archivos `.sql` en el orden indicado por los prefijos numéricos (por ejemplo, `01_sp_GetUserPermissions.sql` debe ejecutarse primero).

## Uso

Para obtener los permisos asignados a un usuario, ejecuta el procedimiento almacenado `sp_GetUserPermissions_Main`. A continuación, se muestra un ejemplo de uso:

```sql
EXEC sp_GetUserPermissions_Main @user_id = 123, @entity_id = 1;
```

## Documentación

Para más detalles sobre la lógica de implementación, el modelo de datos y ejemplos de consultas, revisa los archivos en la carpeta `documentación/`.

## Video Explicativo

Puedes encontrar un video que detalla la implementación y la lógica detrás del sistema en la carpeta `videos/`.

## Contribuciones

Las contribuciones son bienvenidas. Si deseas proponer cambios, por favor crea un fork del repositorio y envía un pull request.

## Licencia

Este proyecto está licenciado bajo la [MIT License](./LICENSE). Consulta el archivo LICENSE para más detalles.


