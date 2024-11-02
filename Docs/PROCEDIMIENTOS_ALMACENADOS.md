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
  - `@entityId BIGINT`: Identificador del usuario.
- **Lógica**:
    1. Crear una tabla temporal o una variable de tabla para almacenar los permisos resultantes.

    2. // Verificar permisos directos del usuario sobre la entidad:
        - Consultar la tabla de permisos de usuario a entidad.
        - Seleccionar los permisos específicos de este usuario para la entidad dada.
        - Insertar estos permisos en tabla temporal.

    3. // Verificar permisos de roles sobre la entidad:
        - Para cada rol en rolesUsuario:
        - Consultar la tabla de permisos de rol a entidad.
        - Seleccionar los permisos de este rol sobre la entidad dada.
        - Insertar estos permisos en tabla temporal, verificando que no existan duplicados.

    4. // Verificar permisos directos del usuario sobre registros específicos de la entidad:
        - Consultar la tabla de permisos de usuario a registros específicos.
        - Seleccionar los permisos que el usuario tiene sobre registros específicos dentro de la entidad dada.
        - Insertar estos permisos en tabla temporal, con el detalle de los registros.

    5. // Verificar permisos de roles sobre registros específicos de la entidad:
        - Para cada rol en rolesUsuario:
        - Consultar la tabla de permisos de rol a registros específicos.
        - Seleccionar los permisos que el rol tiene sobre registros específicos dentro de la entidad dada.
        - Insertar estos permisos en tabla temporal, verificando que no existan duplicados.
    
    6. // Traer de forma dinamica el daalle de la entidad
        - traer el nombre de la entidad con el id recibido
        - Buscar la tabla que contiene el nombre de la entidad.
        - insertar en una tabla temporal todos los registros de esa entidad
        - hacer match con la tabla que contiene los permisos a travez de identificadores

    7. Devolver el contenido de tabla temporal con permisos como resultado.

## Ejemplos de Consulta

A continuación se presentan ejemplos de cómo utilizar los procedimientos almacenados en consultas SQL.

### Ejemplo 1: los permisos asignados a un usuario a nivel de entidad y a nivel de registro dentro de la entidad

```sql
EXEC sp_GetUserDetails @userId = 1, @entityId = 1;
```

- **Resultado Permisos de usuario a nivel entidad y registros de entidad**

| Compania_Id | Compania   | Usuario_Id | Username    | Nivel_de_Permiso | Entidad_Id | Entidad      | Registro_id | Registro           | Leer_Registros | Crear_Registros | Actualizar_Registros | Eliminar_Registros | Exportacion_Masiva | Importacion_Masiva |
|-------------|------------|------------|-------------|------------------|------------|--------------|-------------|---------------------|----------------|-----------------|---------------------|--------------------|---------------------|---------------------|
| 1           | Stone ERP  | 3          | sebasgamba  | Entity           | 2          | CostCenter   | NULL        | NULL                | Sí             | Sí              | Sí                  | No                 | No                  | No                  |
| 1           | Stone ERP  | 3          | sebasgamba  | Register         | 2          | CostCenter   | 1           | Centro de Costo A   | Sí             | No              | Sí                  | No                 | No                  | No                  |
| 1           | Stone ERP  | 3          | sebasgamba  | Register         | 2          | CostCenter   | 2           | Centro de Costo B   | No             | No              | No                  | Sí                 | No                  | No                  |

