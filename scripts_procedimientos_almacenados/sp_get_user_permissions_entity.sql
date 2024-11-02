USE PermitSystem;
GO

-- ===================================================
-- Author: Juan Gamba
-- Date: Noviembre 01, 2024
-- Description: Este procedimiento almacenado obtiene los permisos asignados activos a un usuario a nivel de entidad.
--              Ejecutar el procedimiento para probar los resultados: 
--              EXEC sp_GetUserPermissionsEnity @userId = 3, @entityId = 2;
-- ===================================================

CREATE OR ALTER PROCEDURE sp_GetUserPermissionsEntity
    @userId BIGINT,
    @entityId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
            uc.company_id,
            uc.user_id,
            'Entidad' AS permission_level,
            pu.entitycatalog_id AS entity_id,
            ec.entit_name AS entity_name,
            NULL AS register_id,
            MAX(CASE WHEN p.can_read = 1 THEN 'Sí' ELSE 'No' END) AS Leer_Registros,
            MAX(CASE WHEN p.can_create = 1 THEN 'Sí' ELSE 'No' END) AS Crear_Registros,
            MAX(CASE WHEN p.can_update = 1 THEN 'Sí' ELSE 'No' END) AS Actualizar_Registros,
            MAX(CASE WHEN p.can_delete = 1 THEN 'Sí' ELSE 'No' END) AS Eliminar_Registros,
            MAX(CASE WHEN p.can_export = 1 THEN 'Sí' ELSE 'No' END) AS Exportacion_Masiva,
            MAX(CASE WHEN p.can_import = 1 THEN 'Sí' ELSE 'No' END) AS Importacion_Masiva
        FROM 
            PermiUser pu
        INNER JOIN 
            UserCompany uc ON pu.usercompany_id = uc.id_useco 
        INNER JOIN 
            EntityCatalog ec ON pu.entitycatalog_id = ec.id_entit
        INNER JOIN 
            Permission p ON pu.permission_id = p.id_permi
        WHERE 
            uc.user_id = @userId 
            AND pu.entitycatalog_id = @entityId
            AND pu.peusr_include = 1
        GROUP BY 
            uc.company_id, uc.user_id, pu.entitycatalog_id, ec.entit_name;

END