# Documentación de Procedimientos Almacenados

Este documento proporciona detalles sobre los procedimientos almacenados utilizados en el sistema de gestión de permisos, junto con ejemplos de cómo utilizarlos en consultas.

## Índice

1. [Detalles sobre los Procedimientos Almacenados](#detalles-sobre-los-procedimientos-almacenados)
2. [Ejemplos de Consulta](#ejemplos-de-consulta)

## Detalles sobre los Procedimientos Almacenados

Los procedimientos almacenados son bloques de código SQL que se guardan en la base de datos y permiten ejecutar operaciones repetidamente. A continuación, se detallan algunos procedimientos clave en el sistema de gestión de permisos:

### 1. `sp_GetUserPermissions_Main`

- **Descripción**: obtiene los permisos asignados a un usuario a nivel de entidad y a nivel de registro dentro de la entidad  dado su ID y el ID de la entidad.
- **Parámetros**:
  - `@userId BIGINT`: Identificador del usuario.
  - `@entityId BIGINT`: Identificador de la entidad en la tabla EntityCatalog
- **Lógica**:
    1. Crear una tabla temporal o una variable de tabla para almacenar los permisos resultantes.

    2. // Verificar permisos directos del usuario sobre la entidad:
        - Obtener permisos del sp_GetUserPermissionsEntity
        - Insertar estos permisos en tabla temporal.

    3. // Verificar permisos de roles sobre la entidad:
        - Obtener permisos del sp_GetRolePermissionsEntity de forma agrupada
        - Insertar estos permisos en tabla temporal, verificando que no existan duplicados.

    4. // Verificar permisos directos del usuario sobre registros específicos de la entidad:
        - Obtener permisos del sp_GetUserPermissionsRecord
        - Insertar estos permisos en permisosUsuario, con el detalle de los registros.

    5. // Verificar permisos de roles sobre registros específicos de la entidad:
        - Obtener permisos agrupados del sp_GetRolePermissionsRecord 
        - Insertar estos permisos en tabla temporal, verificando que no existan duplicados.
    
    6. Devolver el contenido de tabla temporal con permisos como resultado.

### 2. `sp_GetUserPermissionsEntity`
- **Descripción**: obtiene los permisos asignados a un usuario a nivel de entidad dado su ID y el ID de la entidad.
- **Parámetros**:
  - `@userId BIGINT`: Identificador del usuario.
  - `@entityId BIGINT`: Identificador de la entidad en la tabla EntityCatalog
- **Lógica**:
    // Verificar permisos directos del usuario sobre la entidad:
        - Consultar la tabla de permisos de usuario a entidad.
        - Seleccionar y dar como resultado los permisos específicos del usuario para la entidad dada.

### 3. `sp_GetRolePermissionsEntity`
- **Descripción**: obtiene los permisos asignados por cada rol en un usuario a nivel de entidad dado el usuario ID y el ID de la entidad.
- **Parámetros**:
  - `@userId BIGINT`: Identificador del usuario.
  - `@entityId BIGINT`: Identificador de la entidad en la tabla EntityCatalog
  - `@Detail BIT`: Define si el resultado va a detallar los registros de los permisos por roles o va a agrupar el resultado de los permisos.
- **Lógica**:
    // Verificar permisos de roles sobre la entidad:
        - Para cada rol en rolesUsuario:
        - Consultar la tabla de permisos de rol a entidad.
        - Insertar estos permisos en tabla temporal, verificando que no existan duplicados.
        - Seleccionar los permisos de este rol sobre la entidad dada.
        - Si el parametro detail es 1 se enviara resultado con columna del nombre del rol, de lo contrario se eliminara esta columna y se agruparan resultados de la seleccion.
        - Seleccionar y dar como resultado estos permisos, verificando que no existan duplicados.

### 4. `sp_GetUserPermissionsRecord`
- **Descripción**: obtiene los permisos asignados a un usuario a nivel de registros especificos de una entidad dado su ID y el ID de la entidad.
- **Parámetros**:
  - `@userId BIGINT`: Identificador del usuario.
  - `@entityId BIGINT`: Identificador de la entidad en la tabla EntityCatalog
- **Lógica**:
    // Verificar permisos directos del usuario sobre registros específicos de la entidad:
        - Consultar la tabla de permisos de usuario a registros específicos.
        - Seleccionar los permisos que el usuario tiene sobre registros específicos dentro de la entidad dada.
        - Dar como resultado los permisos con el detalle de los registros.

### 5. `sp_GetRolePermissionsRecord`
- **Descripción**: obtiene los permisos asignados a un usuario por rol a nivel de registros especificos de una entidad dado id del usuarip y el ID de la entidad.
- **Parámetros**:
  - `@userId BIGINT`: Identificador del usuario.
  - `@entityId BIGINT`: Identificador de la entidad en la tabla EntityCatalog
  - `@Detail BIT`: Define si el resultado va a detallar los registros de los permisos por roles o va a agrupar el resultado de los permisos.
- **Lógica**:
    // Verificar permisos de roles sobre registros específicos de la entidad:
        - Para cada rol en rolesUsuario:
        - Consultar la tabla de permisos de rol a registros específicos.
        - Seleccionar los permisos que el rol tiene sobre registros específicos dentro de la entidad dada.
        - Insertar estos permisos en tabla temporal, verificando que no existan duplicados.
        - Si el parametro detail es 1 se enviara resultado con columna del nombre del rol, de lo contrario se eliminara esta columna y se agruparan resultados de la seleccion.
        - Seleccionar y dar como resultado estos permisos, verificando que no existan duplicados.

### 6.`sp_GetRegisterEntity`
- **Descripción**: obtiene los registros de una entidad dado el id o referencia que se encuentre en la tabla EntityCatalog.
- **Parámetros**:
  - `@entityId BIGINT`: Identificador de la entidad en la tabla EntityCatalog.
- **Lógica**:
    - Traer el nombre de la entidad.
    - Verificar si la tabla de esa entidad existe y traer las columnas id y nombre de esa tabla de forma dinamica.
    - Consultar, seleccionar y retornar los registros de la tabla a la cual pertenece la entidad. 


## Ejemplos de Consulta

A continuación se presentan ejemplos de cómo utilizar los procedimientos almacenados en consultas SQL.

### Ejemplo 1: los permisos asignados a un usuario a nivel de entidad y a nivel de registro dentro de la entidad

```sql
EXEC sp_GetUserPermissions_Main @userId = 3, @entityId = 4;
```

- **Resultado Permisos de usuario a nivel entidad y registros de entidad**

| Compania_Id | Compania   | Usuario_Id | Username    | Nivel_de_Permiso | Entidad_Id | Entidad      | Registro_id | Registro           | Leer_Registros | Crear_Registros | Actualizar_Registros | Eliminar_Registros | Exportacion_Masiva | Importacion_Masiva |
|-------------|------------|------------|-------------|------------------|------------|--------------|-------------|---------------------|----------------|-----------------|---------------------|--------------------|---------------------|---------------------|
| 1           | Stone ERP  | 3          | sebasgamba  | Entity           | 2          | CostCenter   | NULL        | NULL                | Sí             | Sí              | Sí                  | No                 | No                  | No                  |
| 1           | Stone ERP  | 3          | sebasgamba  | Register         | 2          | CostCenter   | 1           | Centro de Costo A   | Sí             | No              | Sí                  | No                 | No                  | No                  |
| 1           | Stone ERP  | 3          | sebasgamba  | Register         | 2          | CostCenter   | 2           | Centro de Costo B   | No             | No              | No                  | Sí                 | No                  | No                  |


### Ejemplo 2: los permisos asignados a un usuario a nivel de entidad.

```sql
    EXEC sp_GetUserPermissionsEnity @userId = 3, @entityId = 2;
```

| company_id | user_id | permission_level | entity_id | entity_name | register_id | Leer_Registros | Crear_Registros | Actualizar_Registros | Eliminar_Registros | Exportacion_Masiva | Importacion_Masiva |
|------------|---------|------------------|-----------|--------------|--------------|-----------------|------------------|---------------------|--------------------|---------------------|---------------------|
| 1          | 3       | Entidad          | 2         | CostCenter   | NULL         | Sí              | Sí               | No                  | No                 | No                  | No                  |


### Ejemplo 3: los permisos asignados a un usuario a nivel de entidad.

1. **Consulta a permisos por rol detalla**

```sql
    EXEC sp_GetRolePermissionsEntity @userId = 3, @entityId = 2, @Detail = 1;
```

| company_id | user_id | role      | permission_level | entitycatalog_id | entity_name | register_id | Leer_Registros | Crear_Registros | Actualizar_Registros | Eliminar_Registros | Exportacion_Masiva | Importacion_Masiva |
|------------|---------|-----------|------------------|-------------------|--------------|--------------|-----------------|------------------|---------------------|--------------------|---------------------|---------------------|
| 1          | 3       | Analista  | Entidad          | 2                 | CostCenter   | NULL         | Sí              | No               | No                  | No                 | No                  | No                  |
| 1          | 3       | Supervisor | Entidad          | 2                 | CostCenter   | NULL         | Sí              | No               | Sí                  | No                 | No                  | No                  |


2. **Consulta permisos por rol agrupada**

```sql
    EXEC sp_GetRolePermissionsEntity @userId = 3, @entityId = 2, @Detail = 0;
```

| company_id | user_id | permission_level | entitycatalog_id | entity_name | register_id | (No column name) | (No column name) | (No column name) | (No column name) | (No column name) | (No column name) |
|------------|---------|------------------|-------------------|--------------|--------------|------------------|------------------|------------------|------------------|------------------|------------------|
| 1          | 3       | Entidad          | 2                 | CostCenter   | NULL         | Sí               | No               | Sí               | No               | No               | No               |


### Ejemplo 4: los permisos asignados a un usuario a nivel de registros especificos de una entidad.


```sql
    EXEC sp_GetUserPermissionsRecord @userId = 3, @entityId = 2, @Detail = 0;
```

| company_id | user_id | permission_level | entity_id | entity_name | register_id | register_entity     | Leer_Registros | Crear_Registros | Actualizar_Registros | Eliminar_Registros | Exportacion_Masiva | Importacion_Masiva |
|------------|---------|------------------|-----------|--------------|--------------|---------------------|-----------------|------------------|---------------------|--------------------|---------------------|---------------------|
| 1          | 3       | Registro          | 2         | CostCenter   | 2            | Centro de Costo B   | No              | No               | No                  | Sí                 | No                  | No                  |


### Ejemplo 5: los permisos asignados a un Rol de un uuario a nivel de registros especificos de una entidad, puede ser detallado por rol o agrupado.

1. **Consulta a permisos por rol detalla**

```sql
    EXEC sp_GetRolePermissionsRecord @userId = 3, @entityId = 2, @Detail = 1;
```

| company_id | user_id | role      | permission_level | entity_id | entity_name | register_id | Leer_Registros | Crear_Registros | Actualizar_Registros | Eliminar_Registros | Exportacion_Masiva | Importacion_Masiva |
|------------|---------|-----------|------------------|-----------|--------------|--------------|-----------------|------------------|---------------------|--------------------|---------------------|---------------------|
| 1          | 3       | Supervisor | Registro          | 2         | CostCenter   | 1            | Sí              | No               | Sí                  | No                 | No                  | No                  |



2. **Consulta permisos por rol agrupada**

```sql
    EXEC sp_GetRolePermissionsRecord @userId = 3, @entityId = 2, @Detail = 0;
```

| company_id | user_id | permission_level | entity_id | entity_name | register_id | register_entity     | (No column name) | (No column name) | (No column name) | (No column name) | (No column name) | (No column name) |
|------------|---------|------------------|-----------|--------------|--------------|---------------------|------------------|------------------|------------------|------------------|------------------|------------------|
| 1          | 3       | Registro          | 2         | CostCenter   | 1            | Centro de Costo A   | Sí               | No               | Sí               | No               | No               | No               |


### Ejemplo 6: Traer registros de una entidad apartir del id de la entidad en la tabla entity_catalog

```sql
    EXEC sp_GetRolePermissionsRecord @entityId = 2;
```

| id_cosce | cosce_name          |
|----------|---------------------|
| 1        | Centro de Costo A   |
| 2        | Centro de Costo B   |


