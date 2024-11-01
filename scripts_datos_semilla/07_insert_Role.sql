USE PermitSystem
GO

INSERT INTO Role 
(
    company_id, 
    role_name, 
    role_code, 
    role_description, 
    role_active
) 
VALUES
(
    1, 
    'Administrador', 
    'ROLE_ADMIN', 
    'Rol con todos los permisos. Crear, leer, actualizar, eliminar, importar, exportar', 
    1
),
(
    1, 
    'Usuario', 
    'ROLE_USU', 
    'Rol con permisos de Creacion, lectura, Actualizacion', 
    1
),
(
    1, 
    'Analista', 
    'ROLE_ANALIST', 
    'Rol con permisos de lectura', 
    1
),
(
    1, 
    'Supervisor', 
    'ROLE_SUPERV', 
    'Rol con permisos de lectura y actualizacion', 
    1
);







