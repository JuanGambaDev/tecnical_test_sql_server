-- Drop the database 'PermitSystem'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Uncomment the ALTER DATABASE statement below to set the database to SINGLE_USER mode if the drop database command fails because the database is in use.
-- ALTER DATABASE PermitSystem SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
-- Drop the database if it exists
IF EXISTS (
    SELECT [name]
        FROM sys.databases
        WHERE [name] = N'PermitSystem'
)
DROP DATABASE PermitSystem
GO

-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT [name]
        FROM sys.databases
        WHERE [name] = N'PermitSystem'
)
CREATE DATABASE PermitSystem
GO

USE PermitSystem;
GO

-- Create Company Table
CREATE TABLE Company (
    -- Primary Key
    id_compa BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador único para la compañía
    
    -- Company Information
    compa_name NVARCHAR(255) NOT NULL,                        -- Nombre legal completo de la compañía
    compa_tradename NVARCHAR(255) NOT NULL,                   -- Nombre comercial o marca de la compañía
    
    -- Document Information
    compa_doctype NVARCHAR(2) NOT NULL                        -- Tipo de documento de identificación de la compañía
        CONSTRAINT CK_Company_DocType 
        CHECK (compa_doctype IN ('NI', 'CC', 'CE', 'PP', 'OT')),
    compa_docnum NVARCHAR(255) NOT NULL,                      -- Número de identificación fiscal o documento legal de la compañía
    
    -- Location Information
    compa_address NVARCHAR(255) NOT NULL,                     -- Dirección física de la compañía
    compa_city NVARCHAR(255) NOT NULL,                        -- Ciudad donde está ubicada la compañía
    compa_state NVARCHAR(255) NOT NULL,                       -- Departamento o estado donde está ubicada la compañía
    compa_country NVARCHAR(255) NOT NULL,                     -- País donde está ubicada la compañía
    
    -- Contact Information
    compa_industry NVARCHAR(255) NOT NULL,                    -- Sector industrial al que pertenece la compañía
    compa_phone NVARCHAR(255) NOT NULL,                       -- Número de teléfono principal de la compañía
    compa_email NVARCHAR(255) NOT NULL,                       -- Dirección de correo electrónico principal de la compañía
    compa_website NVARCHAR(255) NULL,                         -- Sitio web oficial de la compañía
    
    -- Media
    compa_logo NVARCHAR(MAX) NULL,                           -- Logo oficial de la compañía
    
    -- Status
    compa_active BIT NOT NULL DEFAULT 1                       -- Indica si la compañía está activa (1) o inactiva (0)
);
GO

-- Create User Table
CREATE TABLE [User] (
    -- Primary Key
    id_user BIGINT IDENTITY(1,1) PRIMARY KEY,                 -- Identificador único para el usuario
    
    -- Authentication Information
    user_username NVARCHAR(255) NOT NULL,                     -- Nombre de usuario para iniciar sesión
    user_password NVARCHAR(255) NOT NULL,                     -- Contraseña encriptada del usuario
    
    -- Contact Information
    user_email NVARCHAR(255) NOT NULL,                        -- Dirección de correo electrónico del usuario
    user_phone NVARCHAR(255) NULL,                            -- Número de teléfono del usuario
    
    -- Access Control
    user_is_admin BIT NOT NULL DEFAULT 0,                     -- Indica si el usuario es Administrador (1) o normal (0)
    user_is_active BIT NOT NULL DEFAULT 1,                    -- Indica si el usuario está activo (1) o inactivo (0)
    
    -- Unique Constraints
    CONSTRAINT UQ_User_Username UNIQUE (user_username),
    CONSTRAINT UQ_User_Email UNIQUE (user_email)
);
GO

-- Create Permission Table
CREATE TABLE Permission (
    -- Primary Key
    id_permi BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador único para el permiso
    
    -- Basic Information
    name NVARCHAR(255) NOT NULL,                              -- Nombre descriptivo del permiso
    description NVARCHAR(MAX) NULL,                           -- Descripción detallada del permiso y su propósito
    
    -- CRUD Permissions
    can_create BIT NOT NULL DEFAULT 0,                        -- Permite crear nuevos registros
    can_read BIT NOT NULL DEFAULT 0,                          -- Permite ver registros existentes
    can_update BIT NOT NULL DEFAULT 0,                        -- Permite modificar registros existentes
    can_delete BIT NOT NULL DEFAULT 0,                        -- Permite eliminar registros existentes
    
    -- Data Transfer Permissions
    can_import BIT NOT NULL DEFAULT 0,                        -- Permite importar datos masivamente
    can_export BIT NOT NULL DEFAULT 0                         -- Permite exportar datos del sistema
);
GO

-- Create EntityCatalog Table
CREATE TABLE EntityCatalog (
    -- Primary Key
    id_entit BIGINT IDENTITY(1,1) PRIMARY KEY,                    -- Identificador único para el elemento del catálogo de entidades
    
    -- Entity Information
    entit_name NVARCHAR(255) NOT NULL UNIQUE,                  -- Nombre del modelo Django asociado
    entit_descrip NVARCHAR(255) NOT NULL,                      -- Descripción del elemento del catálogo de entidades
    
    -- Status
    entit_active BIT NOT NULL DEFAULT 1,                       -- Indica si el elemento del catálogo está activo (1) o inactivo (0)
    
    -- Configuration
    entit_config NVARCHAR(MAX) NULL                           -- Configuración adicional para el elemento del catálogo
);
GO

-- Create BranchOffice Table
CREATE TABLE BranchOffice (
    -- Primary Key
    id_broff BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador único para la sucursal

    -- Company Reference
    company_id BIGINT NOT NULL                                -- Compañía a la que pertenece esta sucursal
        CONSTRAINT FK_BranchOffice_Company 
        FOREIGN KEY REFERENCES Company(id_compa),
    
    -- Branch Office Information
    broff_name NVARCHAR(255) NOT NULL,                        -- Nombre descriptivo de la sucursal
    broff_code NVARCHAR(255) NOT NULL,                        -- Código único que identifica la sucursal dentro de la empresa
    
    -- Location Information
    broff_address NVARCHAR(255) NOT NULL,                     -- Dirección física de la sucursal
    broff_city NVARCHAR(255) NOT NULL,                        -- Ciudad donde está ubicada la sucursal
    broff_state NVARCHAR(255) NOT NULL,                       -- Departamento o estado donde está ubicada la sucursal
    broff_country NVARCHAR(255) NOT NULL,                     -- País donde está ubicada la sucursal
    
    -- Contact Information
    broff_phone NVARCHAR(255) NOT NULL,                       -- Número de teléfono de la sucursal
    broff_email NVARCHAR(255) NOT NULL,                       -- Dirección de correo electrónico de la sucursal
    
    -- Status
    broff_active BIT NOT NULL DEFAULT 1,                      -- Indica si la sucursal está activa (1) o inactiva (0)

    -- Unique constraint for company and branch code combination
    CONSTRAINT UQ_Company_BranchCode UNIQUE (company_id, broff_code)
);
GO

-- Create CostCenter Table
CREATE TABLE CostCenter (
    -- Primary Key
    id_cosce BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador único para el centro de costo
    
    -- Foreign Keys
    company_id BIGINT NOT NULL                                -- Compañía a la que pertenece este centro de costo
        CONSTRAINT FK_CostCenter_Company 
        FOREIGN KEY REFERENCES Company(id_compa),
    
    cosce_parent_id BIGINT NULL                               -- Centro de costo superior en la jerarquía organizacional
        CONSTRAINT FK_CostCenter_Parent 
        FOREIGN KEY REFERENCES CostCenter(id_cosce),
    
    -- Basic Information
    cosce_code NVARCHAR(255) NOT NULL,                        -- Código único que identifica el centro de costo
    cosce_name NVARCHAR(255) NOT NULL,                        -- Nombre descriptivo del centro de costo
    cosce_description NVARCHAR(MAX) NULL,                     -- Descripción detallada del centro de costo y su propósito
    
    -- Financial Information
    cosce_budget DECIMAL(15,2) NOT NULL DEFAULT 0,            -- Presupuesto asignado al centro de costo
    
    -- Hierarchical Information
    cosce_level SMALLINT NOT NULL DEFAULT 1                   -- Nivel en la jerarquía de centros de costo (1 para nivel superior)
        CONSTRAINT CK_CostCenter_Level 
        CHECK (cosce_level > 0),
    
    -- Status
    cosce_active BIT NOT NULL DEFAULT 1,                      -- Indica si el centro de costo está activo (1) o inactivo (0)
    
    -- Unique constraint for company and cost center code combination
    CONSTRAINT UQ_Company_CostCenterCode UNIQUE (company_id, cosce_code)
);
GO

-- Create Role Table
CREATE TABLE Role (
    -- Primary Key
    id_role BIGINT IDENTITY(1,1) PRIMARY KEY,                 -- Identificador único para el rol
    
    -- Foreign Keys
    company_id BIGINT NOT NULL                                -- Compañía a la que pertenece este rol
        CONSTRAINT FK_Role_Company 
        FOREIGN KEY REFERENCES Company(id_compa),
    
    -- Basic Information
    role_name NVARCHAR(255) NOT NULL,                         -- Nombre descriptivo del rol
    role_code NVARCHAR(255) NOT NULL,                         -- Código del rol (agregado basado en unique_together)
    role_description NVARCHAR(MAX) NULL,                      -- Descripción detallada del rol y sus responsabilidades
    
    -- Status
    role_active BIT NOT NULL DEFAULT 1,                       -- Indica si el rol está activo (1) o inactivo (0)
    
    -- Unique constraint for company and role code combination
    CONSTRAINT UQ_Company_RoleCode UNIQUE (company_id, role_code)
);
GO

-- Create UserCompany Table
CREATE TABLE UserCompany (
    -- Primary Key
    id_useco BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador único para la relación usuario-compañía
    
    -- Foreign Keys
    user_id BIGINT NOT NULL                                   -- Usuario asociado a la compañía
        CONSTRAINT FK_UserCompany_User 
        FOREIGN KEY REFERENCES [User](id_user),
    
    company_id BIGINT NOT NULL                                -- Compañía asociada al usuario
        CONSTRAINT FK_UserCompany_Company 
        FOREIGN KEY REFERENCES Company(id_compa),
    
    -- Status
    useco_active BIT NOT NULL DEFAULT 1,                      -- Indica si la relación usuario-compañía está activa (1) o inactiva (0)
    
    -- Unique constraint for user and company combination
    CONSTRAINT UQ_User_Company UNIQUE (user_id, company_id)
);
GO

-- Create PermiUser Table
CREATE TABLE PermiUser (
    -- Primary Key
    id_peusr BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador único para el permiso de usuario
    
    -- Foreign Keys
    usercompany_id BIGINT NOT NULL                            -- Relación usuario-compañía a la que se asigna el permiso
        CONSTRAINT FK_PermiUser_UserCompany 
        FOREIGN KEY REFERENCES UserCompany(id_useco),
        
    permission_id BIGINT NOT NULL                             -- Permiso asignado al usuario
        CONSTRAINT FK_PermiUser_Permission 
        FOREIGN KEY REFERENCES Permission(id_permi),
        
    entitycatalog_id BIGINT NOT NULL                          -- Entidad sobre la que se aplica el permiso
        CONSTRAINT FK_PermiUser_EntityCatalog 
        FOREIGN KEY REFERENCES EntityCatalog(id_entit),
    
    -- Permission Configuration
    peusr_include BIT NOT NULL DEFAULT 1,                     -- Indica si el permiso se incluye (1) o se excluye (0) para el usuario
    
    -- Unique constraint for user-company, permission and entity catalog combination
    CONSTRAINT UQ_UserCompany_Permission_Entity 
        UNIQUE (usercompany_id, permission_id, entitycatalog_id)
);

-- Create PermiRoleRecord Table
CREATE TABLE PermiRoleRecord (
    -- Primary Key
    id_perrc BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador único para el permiso de rol por registro
    
    -- Foreign Keys
    role_id BIGINT NOT NULL                                   -- Rol al que se asigna el permiso
        CONSTRAINT FK_PermiRoleRecord_Role 
        FOREIGN KEY REFERENCES Role(id_role),
        
    permission_id BIGINT NOT NULL                             -- Permiso asignado al rol
        CONSTRAINT FK_PermiRoleRecord_Permission 
        FOREIGN KEY REFERENCES Permission(id_permi),
        
    entitycatalog_id BIGINT NOT NULL                          -- Entidad sobre la que se aplica el permiso
        CONSTRAINT FK_PermiRoleRecord_EntityCatalog 
        FOREIGN KEY REFERENCES EntityCatalog(id_entit),
    
    -- Record Specific Information
    perrc_record BIGINT NOT NULL,                             -- Identificador del registro específico al que se aplica el permiso
    
    -- Permission Configuration
    perrc_include BIT NOT NULL DEFAULT 1,                     -- Indica si el permiso se incluye (1) o se excluye (0) para el rol y registro
    
    -- Unique constraint for role, permission, entity catalog and record combination
    CONSTRAINT UQ_RoleId_PermissionId_Entity_RecordId 
        UNIQUE (role_id, permission_id, entitycatalog_id, perrc_record)
);
GO

-- Create PermiRole Table
CREATE TABLE PermiRole (
    -- Primary Key
    id_perol BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador único para el permiso de rol
    
    -- Foreign Keys
    role_id BIGINT NOT NULL                                   -- Rol al que se asigna el permiso
        CONSTRAINT FK_PermiRole_Role 
        FOREIGN KEY REFERENCES Role(id_role),
        
    permission_id BIGINT NOT NULL                             -- Permiso asignado al rol
        CONSTRAINT FK_PermiRole_Permission 
        FOREIGN KEY REFERENCES Permission(id_permi),
        
    entitycatalog_id BIGINT NOT NULL                          -- Entidad sobre la que se aplica el permiso
        CONSTRAINT FK_PermiRole_EntityCatalog 
        FOREIGN KEY REFERENCES EntityCatalog(id_entit),
    
    -- Permission Configuration
    perol_include BIT NOT NULL DEFAULT 1,                     -- Indica si el permiso se incluye (1) o se excluye (0) para el rol
    perol_record BIGINT NULL,                                 -- Campo mencionado en unique_together pero no en el modelo
    
    -- Unique constraint for role, permission, entity catalog, and record combination
    CONSTRAINT UQ_Role_Permission_Entity_Record 
        UNIQUE (role_id, permission_id, entitycatalog_id, perol_record)
);
GO

-- Create PermiUserRecord Table
CREATE TABLE PermiUserRecord (
    -- Primary Key
    id_peusr BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador único para el permiso de usuario
    
    -- Foreign Keys
    usercompany_id BIGINT NOT NULL                            -- Relación usuario-compañía a la que se asigna el permiso
        CONSTRAINT FK_PermiUserRecord_UserCompany 
        FOREIGN KEY REFERENCES UserCompany(id_useco),
        
    permission_id BIGINT NOT NULL                             -- Permiso asignado al usuario
        CONSTRAINT FK_PermiUserRecord_Permission 
        FOREIGN KEY REFERENCES Permission(id_permi),
        
    entitycatalog_id BIGINT NOT NULL                          -- Entidad sobre la que se aplica el permiso
        CONSTRAINT FK_PermiUserRecord_EntityCatalog 
        FOREIGN KEY REFERENCES EntityCatalog(id_entit),
    
    -- Record Specific Information
    peusr_record BIGINT NOT NULL,                             -- Identificador del registro específico de la entidad al que aplica el permiso
    
    -- Permission Configuration
    peusr_include BIT NOT NULL DEFAULT 1,                     -- Indica si el permiso se incluye (1) o se excluye (0) para el usuario
    
    -- Unique constraint for user-company, permission, entity catalog and record combination
    CONSTRAINT UQ_UserCompany_Permission_Entity_Record 
        UNIQUE (usercompany_id, permission_id, entitycatalog_id, peusr_record)
);
GO