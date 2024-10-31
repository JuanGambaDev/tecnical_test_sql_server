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
    'Rol con todos los permisos', 
    1
),
(
    1, 
    'Usuario Normal', 
    'ROLE_USER', 
    'Rol con permisos limitados', 
    1
);


