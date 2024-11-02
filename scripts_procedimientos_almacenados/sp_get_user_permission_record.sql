USE PermitSystem;
GO

-- ===================================================
-- Author: Juan Gamba
-- Date: Noviembre 01, 2024
-- Description: Este procedimiento almacenado obtiene los permisos asignados activos a un Usuario a nivel de un registro especifico de una entidad.
--              Ejecutar el procedimiento para probar los resultados: 
--              EXEC sp_GetUserPermissionsRecord @userId = 3, @entityId = 2;
-- ===================================================

CREATE OR ALTER PROCEDURE sp_GetUserPermissionsRecord
    @userId BIGINT,
    @entityId BIGINT
AS
BEGIN

    SET NOCOUNT ON;  

    DECLARE @ResultsEntityRegisters TABLE (
        id BIGINT,
        register_name NVARCHAR(255)
    );

    INSERT INTO @ResultsEntityRegisters
    EXEC sp_GetRegisterEntity @entityId;

    
    SELECT
        uc.company_id,
        uc.user_id,
        'Registro' AS permission_level,
        pur.entitycatalog_id AS entity_id,
        ec.entit_name AS entity_name,
        pur.peusr_record AS register_id,
        rer.register_name AS register_entity,
        MAX(CASE WHEN p.can_read = 1 THEN 'Sí' ELSE 'No' END) AS Leer_Registros,
        MAX(CASE WHEN p.can_create = 1 THEN 'Sí' ELSE 'No' END) AS Crear_Registros,
        MAX(CASE WHEN p.can_update = 1 THEN 'Sí' ELSE 'No' END) AS Actualizar_Registros,
        MAX(CASE WHEN p.can_delete = 1 THEN 'Sí' ELSE 'No' END) AS Eliminar_Registros,
        MAX(CASE WHEN p.can_export = 1 THEN 'Sí' ELSE 'No' END) AS Exportacion_Masiva,
        MAX(CASE WHEN p.can_import = 1 THEN 'Sí' ELSE 'No' END) AS Importacion_Masiva
    FROM 
        PermiUserRecord pur
    INNER JOIN 
        UserCompany uc ON pur.usercompany_id = uc.id_useco
    INNER JOIN 
        EntityCatalog ec ON pur.entitycatalog_id = ec.id_entit
    INNER JOIN 
        Permission p ON pur.permission_id = p.id_permi 
    LEFT JOIN 
        @ResultsEntityRegisters rer ON pur.peusr_record = rer.id
    WHERE 
        uc.user_id = @userId 
        AND pur.entitycatalog_id = @entityId
        AND pur.peusr_include = 1
    GROUP BY 
        uc.company_id, uc.user_id, pur.entitycatalog_id, ec.entit_name, pur.peusr_record, rer.register_name;
    
END