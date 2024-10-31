# Prueba Técnica: Sistema de Permisos

### Requisitos Técnicos Obligatorios:
- **Base de Datos:** SQL Server (únicamente SQL Server será aceptado como tecnología para este proyecto. No se admiten otras plataformas o sistemas de bases de datos).

### Objetivo
El objetivo de esta prueba técnica es desarrollar un sistema de permisos en **SQL Server** que permita asignar privilegios a usuarios, ya sea a nivel de entidad o por registro individual. Este sistema gestionará los permisos de manera flexible, permitiendo asociarlos tanto a roles como a usuarios específicos.

### Modelos Implementados (Tablas en SQL Server)
Para implementar la funcionalidad de permisos en SQL Server, se deben crear las siguientes tablas dentro de la base de datos:

- **PermiUser:** Esta tabla gestionará los permisos asignados a un usuario.
  
- **PermiRole:** Esta tabla gestionará los permisos asignados a un rol. 
  
- **PermiUserRecord:** Esta tabla se encargará de asignar permisos a usuarios sobre registros específicos de una entidad. 
  
- **PermiRoleRecord:** Similar a `PermiUserRecord`, esta tabla asigna permisos a roles sobre registros específicos. 

- **Permission:** Define la combinatoria de permisos que pueden ser otorgados a usuarios o roles. 

### Funcionalidad del Sistema de Permisos
El sistema permitirá lo siguiente:

- **Asignar permisos a nivel de entidad:** Se podrán asignar permisos a usuarios o roles sobre entidades completas, como una sucursal o un centro de costos. Esto proporcionará acceso general a la entidad sin especificar registros individuales.
  
- **Asignar permisos a nivel de registro individual:** Se podrán asignar permisos más específicos a nivel de registros individuales dentro de una entidad. Esto permitirá un control más detallado, de modo que un usuario o rol solo pueda acceder a ciertos registros (por ejemplo, una sucursal específica o un centro de costos particular).

Este enfoque proporciona una mayor granularidad en el control de acceso, ya que es posible combinar permisos según las necesidades del usuario o del rol.



### Entidades Para Pruebas
Para las pruebas de este sistema de permisos, se gestionarán las siguientes entidades principales dentro de la aplicación:

- **Sucursal (Branch Office):** Esta entidad representa una oficina de la empresa. Los permisos pueden ser asignados a nivel de sucursal completa o a nivel de registros específicos dentro de la sucursal.

- **Centro de Costos (Cost Center):** Esta entidad representa una unidad dentro de la empresa a la que se le asignan costos. Los permisos también pueden asignarse tanto a nivel de entidad completa como a nivel de registros individuales dentro del centro de costos.

Cada una de estas entidades puede tener permisos específicos asociados, tanto a nivel de entidad como de registros individuales dentro de ellas, gestionados a través de las tablas mencionadas anteriormente.

---

### Entregables

1. **Procedimientos Almacenados:**
   - Los **procedimientos almacenados** que implementen la lógica de permisos deben ser guardados en la carpeta `scripts_procedimientos_almacenados`.
   - Estos procedimientos se encargarán de la asignación, revocación y verificación de permisos a usuarios y roles. Incluir todos los procedimientos desarrollados en esta carpeta es esencial.

2. **Scripts para Creación de Tablas:**
   - Los **scripts necesarios para la creación de las tablas** deben estar ubicados en la carpeta `scripts_para_crear_tablas`.
   - Estos scripts deben contener las sentencias `CREATE TABLE` y cualquier otra estructura necesaria para soportar el sistema de permisos.

3. **Subida a GitHub:**
   - Todos los archivos, incluyendo **procedimientos almacenados** y **scripts para la creación de tablas**, deben subirse a un repositorio en **GitHub**.
   - Asegúrate de seguir la estructura correcta: 
     - `scripts_procedimientos_almacenados`: Procedimientos almacenados.
     - `scripts_para_crear_tablas`: Scripts de creación de tablas.
   - El repositorio debe estar bien organizado y documentado para facilitar su comprensión.

4. **Video Explicativo:**
   - Se debe proporcionar un **video explicativo** en el que se detalle:
     - La lógica detrás de los procedimientos almacenados y su implementación.
     - La estrategia utilizada para resolver el problema de permisos.
     - Cómo los scripts para la creación de tablas generan la estructura de la base de datos en SQL Server.
   - Este video es parte del entregable obligatorio.

