USE PermitSystem
GO

/*
Usuario por Rol.

Representa la relación entre un usuario y una rol, permitiendo gestionar
la asignacion de usuarios a múltiples roles en el sistema o visceversa.

¿Para qué sirve?:

1. Gestión de permisos de usuarios por rol.

2. Control de acceso multirol para cada usuario.

3. Seguimiento de actividades de usuarios por rol.

4. Configuración de preferencias específicas por usuario y rol.

5. Soporte para roles y responsabilidades diferentes en cada usuario.

Creado por:
Juan Gamba 

Fecha: 01/11/2024
*/

-- Create UserCompany Table
CREATE TABLE UserRole (
    -- Primary Key
    id_userol BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador único para la relación usuario-rol
    
    -- Foreign Keys
    user_id BIGINT NOT NULL                                   -- Usuario asociado a al rol
        CONSTRAINT FK_UserRole_User 
        FOREIGN KEY REFERENCES [User](id_user),
    
    role_id BIGINT NOT NULL                                -- rol asociada al usuario
        CONSTRAINT FK_UserRole_Role 
        FOREIGN KEY REFERENCES [Role](id_role),
    
    -- Status
    userol_active BIT NOT NULL DEFAULT 1,                      -- Indica si la relación usuario-rol está activa (1) o inactiva (0)
    
    -- Unique constraint for user and company combination
    CONSTRAINT UQ_User_Role UNIQUE (user_id, role_id)
);