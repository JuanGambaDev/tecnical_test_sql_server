# Sistema de Permisos - Documentación del Modelo de Datos

Este documento describe el modelo de datos utilizado en el sistema de permisos, incluyendo las tablas, sus relaciones y campos relevantes. Este sistema está diseñado para gestionar permisos de acceso y roles de usuario dentro de un entorno ERP.

## Tablas

### Company

- **Descripción**: 

    Una compañía representa una entidad empresarial con sus datos de identificación,
    ubicación y características principales dentro del sistema ERP.

    ¿Para qué sirve?:

    1. Gestión centralizada de la información básica de las empresas en el sistema.

    2. Soporte para operaciones comerciales y administrativas específicas de cada empresa.

    3. Cumplimiento de requisitos legales y fiscales relacionados con la identificación empresarial.

    4. Base para la configuración de parámetros y políticas específicas de cada empresa.

    5. Facilitar la gestión multi-empresa dentro del sistema ERP.

- **Campos**:
  - `id_compa` BIGINT IDENTITY(1,1) PRIMARY KEY: Identificador único para la compañía.
  - `compa_name` NVARCHAR(255) NOT NULL: Nombre legal completo de la compañía.
  - `compa_tradename` NVARCHAR(255) NOT NULL: Nombre comercial o marca de la compañía.
  - `compa_doctype` NVARCHAR(2) NOT NULL: Tipo de documento de identificación de la compañía (debe estar entre ('NI', 'CC', 'CE', 'PP', 'OT')).
  - `compa_docnum` NVARCHAR(255) NOT NULL: Número de identificación fiscal o documento legal de la compañía.
  - `compa_address` NVARCHAR(255) NOT NULL: Dirección física de la compañía.
  - `compa_city` NVARCHAR(255) NOT NULL: Ciudad donde está ubicada la compañía.
  - `compa_state` NVARCHAR(255) NOT NULL: Departamento o estado donde está ubicada la compañía.
  - `compa_country` NVARCHAR(255) NOT NULL: País donde está ubicada la compañía.
  - `compa_industry` NVARCHAR(255) NOT NULL: Sector industrial al que pertenece la compañía.
  - `compa_phone` NVARCHAR(255) NOT NULL: Número de teléfono principal de la compañía.
  - `compa_email` NVARCHAR(255) NOT NULL: Dirección de correo electrónico principal de la compañía.
  - `compa_website` NVARCHAR(255) NULL: Sitio web oficial de la compañía.
  - `compa_logo` NVARCHAR(MAX) NULL: Logo oficial de la compañía.
  - `compa_active` BIT NOT NULL DEFAULT 1: Indica si la compañía está activa (1) o inactiva (0).

### User

- **Descripción**: 

    Un usuario representa una persona que interactúa con el sistema,
    con sus credenciales y datos básicos de acceso.

    ¿Para qué sirve?:

    1. Gestión de acceso y autenticación en el sistema.

    2. Almacenamiento de información básica de los usuarios.

    3. Control de estados y permisos de usuarios.

    4. Seguimiento de actividad y auditoría de usuarios.

    5. Base para la personalización de la experiencia de usuario.

- **Campos**:
  - `id_user` BIGINT IDENTITY(1,1) PRIMARY KEY: Identificador único para el usuario.
  - `user_username` NVARCHAR(255) NOT NULL: Nombre de usuario para iniciar sesión, debe ser único.
  - `user_password` NVARCHAR(255) NOT NULL: Contraseña hasheada del usuario.
  - `user_email` NVARCHAR(255) NOT NULL: Dirección de correo electrónico del usuario, debe ser única.
  - `user_phone` NVARCHAR(255) NULL: Número de teléfono del usuario.
  - `user_is_admin` BIT NOT NULL DEFAULT 0: Indica si el usuario es Administrador (1) o normal (0).
  - `user_is_active` BIT NOT NULL DEFAULT 1: Indica si el usuario está activo (1) o inactivo (0).

### Permission

- **Descripción**: Define los permisos disponibles que pueden ser asignados a los usuarios o roles dentro del sistema.

Un permiso representa los diferentes niveles de acceso y operaciones
que pueden realizarse sobre una entidad del sistema.

¿Para qué sirve?:

1. Control granular de acciones sobre entidades del sistema.

2. Definición de permisos específicos para operaciones CRUD.

3. Gestión de capacidades de importación y exportación de datos.

4. Implementación de políticas de seguridad y acceso.

5. Configuración flexible de permisos por funcionalidad.

- **Campos**:
  - `id_permi` BIGINT IDENTITY(1,1) PRIMARY KEY: Identificador único para el permiso.
  - `name` NVARCHAR(255) NOT NULL: Nombre descriptivo del permiso.
  - `description` NVARCHAR(MAX) NULL: Descripción detallada del permiso y su propósito.
  - `can_create`, `can_read`, `can_update`, `can_delete`: Permisos para operaciones CRUD.
  - `can_import`, `can_export`: Permisos para transferencias de datos.

### EntityCatalog

- **Descripción**: Almacena información sobre las entidades dentro del sistema.

Un catálogo de entidades representa una tabla que almacena todas las entidades 
(modelos) disponibles en el sistema Django, facilitando su gestión y referencia.

¿Para qué sirve?:

1. Mantener un registro centralizado de todas las entidades del sistema.

2. Facilitar la gestión y el mantenimiento de la estructura de la base de datos.

3. Permitir la referencia dinámica a diferentes modelos del sistema.

4. Proveer una base para la implementación de funcionalidades genéricas.

5. Apoyar en la documentación y organización del sistema.

- **Campos**:
  - `id_entit` BIGINT IDENTITY(1,1) PRIMARY KEY: Identificador único para el elemento del catálogo de entidades.
  - `entit_name` NVARCHAR(255) NOT NULL UNIQUE: Nombre del modelo Django asociado.
  - `entit_descrip` NVARCHAR(255) NOT NULL: Descripción del elemento del catálogo de entidades.
  - `entit_active` BIT NOT NULL DEFAULT 1: Indica si el elemento del catálogo está activo (1) o inactivo (0).
  - `entit_config` NVARCHAR(MAX) NULL: Configuración adicional para el elemento del catálogo.

### BranchOffice

- **Descripción**: Representa las sucursales de una compañía.

Una sucursal representa un establecimiento físico o punto de operación 
que pertenece a una compañía específica.

¿Para qué sirve?:

1. Gestión y control de múltiples ubicaciones de una misma empresa.

2. Organización de operaciones por punto de venta o servicio.

3. Seguimiento y análisis de desempeño por sucursal.

4. Asignación y control de recursos específicos por ubicación.

5. Facilitar la gestión descentralizada de operaciones empresariales.


- **Campos**:
  - `id_broff` BIGINT IDENTITY(1,1) PRIMARY KEY: Identificador único para la sucursal.
  - `company_id` BIGINT NOT NULL: Referencia a la compañía a la que pertenece esta sucursal.
  - `broff_name`, `broff_code`, `broff_address`, `broff_city`, `broff_state`, `broff_country`, `broff_phone`, `broff_email`: Información descriptiva y de contacto de la sucursal.
  - `broff_active` BIT NOT NULL DEFAULT 1: Indica si la sucursal está activa (1) o inactiva (0).

### CostCenter

- **Descripción**: Representa los centros de costo dentro de una compañía.

Un centro de costo representa una unidad organizacional dentro de una empresa
que permite agrupar y controlar costos específicos.

¿Para qué sirve?:

1. Gestión y control de costos por unidad organizativa.

2. Seguimiento detallado de gastos y presupuestos por área.

3. Análisis de rentabilidad por centro de responsabilidad.

4. Facilitación de la toma de decisiones basada en costos.

5. Implementación de estructuras jerárquicas para el control de costos.

- **Campos**:
  - `id_cosce` BIGINT IDENTITY(1,1) PRIMARY KEY: Identificador único para el centro de costo.
  - `company_id` BIGINT NOT NULL: Referencia a la compañía a la que pertenece este centro de costo.
  - `cosce_parent_id` BIGINT NULL: Centro de costo superior en la jerarquía organizacional.
  - `cosce_code`, `cosce_name`, `cosce_description`: Información básica del centro de costo.
  - `cosce_budget` DECIMAL(15,2) NOT NULL DEFAULT 0: Presupuesto asignado al centro de costo.
  - `cosce_level` SMALLINT NOT NULL DEFAULT 1: Nivel en la jerarquía de centros de costo.
  - `cosce_active` BIT NOT NULL DEFAULT 1: Indica si el centro de costo está activo (1) o inactivo (0).

### Role

- **Descripción**: Define los roles de usuario en el sistema.

Un rol representa un conjunto de permisos y responsabilidades que pueden
ser asignados a usuarios dentro de una compañía específica.

¿Para qué sirve?:

1. Definición de niveles de acceso y permisos por compañía.

2. Agrupación de funcionalidades y accesos para asignación eficiente.

3. Control granular de las capacidades de los usuarios en el sistema.

4. Simplificación de la gestión de permisos por grupos de usuarios.

5. Estandarización de roles y responsabilidades dentro de cada compañía.

- **Campos**:
  - `id_role` BIGINT IDENTITY(1,1) PRIMARY KEY: Identificador único para el rol.
  - `company_id` BIGINT NOT NULL: Referencia a la compañía a la que pertenece este rol.
  - `role_name`, `role_code`, `role_description`: Información básica del rol.
  - `role_active` BIT NOT NULL DEFAULT 1: Indica si el rol está activo (1) o inactivo (0).

### UserCompany

- **Descripción**: Relaciona usuarios con las compañías.

Representa la relación entre un usuario y una compañía, permitiendo gestionar
el acceso de usuarios a múltiples compañías en el sistema.

¿Para qué sirve?:

1. Gestión de permisos de usuarios por compañía.

2. Control de acceso multiempresa para cada usuario.

3. Seguimiento de actividades de usuarios por compañía.

4. Configuración de preferencias específicas por usuario y compañía.

5. Soporte para roles y responsabilidades diferentes en cada compañía.

- **Campos**:
  - `id_useco` BIGINT IDENTITY(1,1) PRIMARY KEY: Identificador único para la relación usuario-compañía.
  - `user_id`, `company_id`: Referencias a usuario y compañía.
  - `useco_active` BIT NOT NULL DEFAULT 1: Indica si la relación usuario-compañía está activa (1) o inactiva (0).

### UserRole

- **Descripción**: Relaciona usuarios con roles.

¿Para qué sirve?:

1. Gestión de permisos de usuarios por rol.

2. Control de acceso multirol para cada usuario.

3. Seguimiento de actividades de usuarios por rol.

4. Configuración de preferencias específicas por usuario y rol.

5. Soporte para roles y responsabilidades diferentes en cada usuario.

- **Campos**:
  - `id_userol` BIGINT IDENTITY(1,1) PRIMARY KEY: Identificador único para la relación usuario-rol.
  - `user_id`, `role_id`: Referencias a usuario y rol.
  - `userol_active` BIT NOT NULL DEFAULT 1: Indica si la relación usuario-rol está activa (1) o inactiva (0).

### PermiUser

- **Descripción**: Gestiona los permisos asignados a los usuarios.


¿Para qué sirve?:

1. Asignación de permisos específicos por usuario y entidad.

2. Control granular de accesos a nivel de usuario-compañía.

3. Personalización de capacidades por entidad del sistema.

4. Gestión detallada de privilegios por usuario.

5. Implementación de políticas de seguridad específicas por entidad.

- **Campos**:
  - `id_peusr` BIGINT IDENTITY(1,1) PRIMARY KEY: Identificador único para el permiso de usuario.
  - `usercompany_id`, `permission_id`, `entitycatalog_id`: Referencias a la relación usuario-compañía, permiso y entidad.
  - `peusr_include` BIT NOT NULL DEFAULT 1: Indica si el permiso se incluye (1) o se excluye (0) para el usuario.

### PermiRole

- **Descripción**: Gestiona los permisos asignados a los roles.

¿Para qué sirve?:

1. Asignación de permisos específicos por rol y entidad.

2. Control granular de accesos a nivel de rol.

3. Personalización de capacidades por entidad del sistema.

4. Gestión detallada de privilegios por rol.

5. Implementación de políticas de seguridad específicas por rol y entidad.

- **Campos**:
  - `id_perol` BIGINT IDENTITY(1,1) PRIMARY KEY: Identificador único para el permiso de rol.
  - `role_id`, `permission_id`, `entitycatalog_id`: Referencias a rol, permiso y entidad.
  - `perol_include` BIT NOT NULL DEFAULT 1: Indica si el permiso se incluye (1) o se excluye (0) para el rol.

### PermiRoleRecord

- **Descripción**: Representa los permisos específicos asignados a un rol para una 
entidad y registro particular dentro del sistema.

¿Para qué sirve?:

1. Asignación de permisos específicos por rol, entidad y registro.

2. Control granular de accesos a nivel de rol y registro.

3. Personalización de capacidades por entidad y registro del sistema.

4. Gestión detallada de privilegios por rol y registro específico.

5. Implementación de políticas de seguridad específicas por rol, entidad y registro.

- **Campos**:
    `id_perrc` BIGINT IDENTITY(1,1) PRIMARY KEY: Identificador único para el permiso de rol por registr
    `role_id` BIGINT NOT NULL:Referencia Rol al que se asigna el permiso   
    `permission_id` BIGINT NOT NULL: Referencia Permiso asignado al rol      
    `entitycatalog_id` BIGINT NOT NULL:Referencia Entidad sobre la que se aplica el permiso
    `perrc_record` BIGINT NOT NULL:Identificador del registro específico al que se aplica el permiso
    `perrc_include` BIT NOT NULL DEFAULT 1:Indica si el permiso se incluye (1) o se excluye (0) para el rol y registro

### PermiUserRecord

- **Descripción**: Representa los permisos específicos asignados a un usuario para una 
entidad particular y un registro específico dentro de una compañía.

¿Para qué sirve?:

1. Asignación de permisos específicos por usuario y entidad a nivel de registro.

2. Control granular de accesos a nivel de usuario-compañía y registro.

3. Personalización de capacidades por entidad y registro del sistema.

4. Gestión detallada de privilegios por usuario a nivel de registro.

5. Implementación de políticas de seguridad específicas por entidad y registro.

- **Campos**:
    `id_peusr` BIGINT IDENTITY(1,1) PRIMARY KEY: Identificador único para el permiso de usuario
    `usercompany`_id BIGINT NOT NULL: Relación usuario-compañía a la que se asigna el permiso
    `permission_id` BIGINT NOT NULL: Permiso asignado al usuario
    `entitycatalog_id` BIGINT NOT NULL: Entidad sobre la que se aplica el permiso
    `peusr_record` BIGINT NOT NULL: Identificador del registro específico de la entidad al que aplica el permiso
    `peusr_include` BIT NOT NULL DEFAULT 1: Indica si el permiso se incluye (1) o se excluye (0) para el usuario
    

## Relaciones

- **Company**: 
    - Relacionado uno a mucho con `BranchOffice`, `CostCenter`, `Role`.
    - Relacion muchos a muchos con `User` tabla intermediaria `UserCompany`.
- **User**: 
    - Relacionado muchos a muchos con `Company` usando tabla intermediaria `UserCompany`, , `PermiUser`,`PermiUserRecor`
    - Relacion muchos a muchos con `Role` usando tabla intermediaria `UserRole`.
    - Relacion muchos a muchos con `Permission` y `Entity Catalog` usando tablas intermedias `PermiUser` para gestionar permisos de usuario sobre entidad
    - Relacion muchos a muchos con `Permission` y `Entity Catalog` usando tablas intermedias `PermiUserRecord` para gestionar permisos de usuaio sobre registros especificos de una entidad.
- **Role**: 
    - Relacionado muchos a uno con `Company`.
    - Relacion muchos a muchos con `User` usando tabla intermediaria `UserRole`.
    - Relacion muchos a muchos con `Permission` y `Entity Catalog` usando tablas intermedias `PermiRole` para gestionar permisos del rol sobre entidad
    - Relacion muchos a muchos con `Permission` y `Entity Catalog` usando tablas intermedias `PermiRoleRecord` para gestionar permisos del rol sobre registros especificos de una entidad.

## Modelo Entidad Relacion

[Modelo Entidad - Relacion ](../Docs/er_tecnical_test.png)

## Jerarquía de Aplicación de Permisos

Al aplicar esta estructura, es importante definir una jerarquía de precedencia. Esta jerarquía ayuda a resolver posibles conflictos cuando un usuario tiene múltiples roles o permisos directos sobre entidades o registros específicos. La jerarquía de permisos sugerida es:

1. **Permisos de usuario a registros específicos de una entidad**: Se aplican primero los permisos directos del usuario sobre registros específicos.
2. **Permisos por rol a registros específicos de una entidad**: Si no hay permisos específicos de usuario, se aplican los permisos a nivel de rol sobre registros específicos.
3. **Permisos de usuario a entidad**: Si no hay permisos a nivel de registro, se revisan los permisos del usuario a nivel de entidad.
4. **Permisos por rol a entidad**: Finalmente, si ninguna de las reglas anteriores aplica, se aplican los permisos del rol a nivel de entidad.







