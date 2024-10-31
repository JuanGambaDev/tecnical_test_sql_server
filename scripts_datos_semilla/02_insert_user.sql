USE PermitSystem
GO

INSERT INTO [User]
(    
    user_username,                     -- Nombre de usuario para iniciar sesión
    user_password,                     -- Contraseña encriptada del usuario
    user_email,                        -- Dirección de correo electrónico del usuario
    user_phone,                        -- Número de teléfono del usuario
    user_is_admin,                     -- Indica si el usuario es Administrador (1) o normal (0)
    user_is_active                    -- Indica si el usuario está activo (1) o inactivo (0)
) 
VALUES
(
    'jgamba',
    '25d19baaef913d50b6a8e302909507b8059c6410a1c8d7e1a844d6069732202e',
    'jgamba@example.com',
    '3214321232',
    1,
    1
),
(
    'juantesting',
    '25d19baaef913d50b6a8e302909507b8059c6410a1c8d7e1a844d6069732202e',
    'jtesting@example.com',
    '3123243213',
    0,
    1

),
(
    'sebasgamba',
    '25d19baaef913d50b6a8e302909507b8059c6410a1c8d7e1a844d6069732202e',
    'sebasg@example.com',
    '3134567890',
    0,
    1

);

