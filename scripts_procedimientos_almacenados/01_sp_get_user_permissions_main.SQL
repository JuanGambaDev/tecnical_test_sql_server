USE PermitSystem;
GO

-- ===================================================
-- Author: Juan Gamba
-- Date: Noviembre 01, 2024
-- Description: Este procedimiento almacenado obtiene los permisos asignados a un usuario
--              a nivel de entidad y a nivel de registro dentro de la entidad.

-- Ejecutar el procedimiento para probar los resultados: EXEC sp_GetUserPermissions_Main @userId = 3, @entityId = 2;
-- ===================================================
CREATE OR ALTER PROCEDURE sp_GetUserPermissions_Main
    @userId BIGINT,
    @entityId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Tabla temporal para almacenar los permisos
        DECLARE @Permissions TABLE (
            company_id BIGINT,
            user_id BIGINT,
            permission_level NVARCHAR(20),
            entity_id BIGINT,
            entity_name NVARCHAR(255),
            register_id BIGINT,
            Leer_Registros NVARCHAR(2),
            Crear_Registros NVARCHAR(2),
            Actualizar_Registros NVARCHAR(2),
            Eliminar_Registros NVARCHAR(2),
            Exportacion_Masiva NVARCHAR(2),
            Importacion_Masiva NVARCHAR(2)
        );



        -- Inserción de permisos a nivel de entidad para el usuario
        INSERT INTO @Permissions 
        EXEC sp_GetUserPermissionsEntity @userId, @entityId;
        
        -- Inserción de permisos a nivel de entidad para roles del usuario
        INSERT INTO @Permissions
        EXEC sp_GetRolePermissionsEntity @userId, @entityId;
        
        -- Permisos en registros específicos de la entidad para el usuario
        INSERT INTO @Permissions 
        EXEC sp_GetUserPermissionsRecord @userId, @entityId;

        -- Permisos en registros específicos de la entidad para roles
        INSERT INTO @Permissions
        EXEC sp_GetRolePermissionsRecord @userId, @entityId;

        -- Insertar registros de entidades
        INSERT INTO @ResultsEntityRegisters
        EXEC sp_GetRegisterEntity @entityId;

        -- Seleccionar resultados finales, eliminando duplicados
        SELECT 
            per.company_id AS Compania_Id,
            c.compa_name AS Compania,
            u.id_user AS Usuario_Id,
            u.user_username AS Username,
            per.permission_level AS Nivel_de_Permiso,
            per.entity_id AS Entidad_Id,
            per.entity_name AS Entidad,
            per.register_id AS Registro_id,
            rer.register_name AS Registro, 
            MAX(per.Leer_Registros) AS Leer_Registros,
            MAX(per.Crear_Registros) AS Crear_Registros,
            MAX(per.Actualizar_Registros) AS Actualizar_Registros,
            MAX(per.Eliminar_Registros) AS Eliminar_Registros,
            MAX(per.Exportacion_Masiva) AS Exportacion_Masiva,
            MAX(per.Importacion_Masiva) AS Importacion_Masiva
        FROM @Permissions per
        INNER JOIN [User] u ON per.user_id = u.id_user
        INNER JOIN [Company] c ON per.company_id = c.id_compa
        LEFT JOIN @ResultsEntityRegisters rer ON per.register_id = rer.id
        GROUP BY per.company_id, c.compa_name, u.id_user, per.permission_level, 
                 u.user_username, per.entity_id, per.entity_name, per.register_id, rer.register_name
        ORDER BY per.entity_name, per.register_id;

    END TRY
    BEGIN CATCH
        -- Manejo de errores
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        -- Registrar error
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
        
    END CATCH
END
GO
