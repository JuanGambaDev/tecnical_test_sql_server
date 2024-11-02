USE PermitSystem;
GO

-- ===================================================
-- Author: Juan Gamba
-- Date: Noviembre 01, 2024
-- Description: Este procedimiento almacenado obtiene los permisos asignados (activos) a un Role a nivel de un registro especifico de una entidad.

-- Parameters: 
--      @userId BIGINT, -- id referencia del usuario
--      @entityId BIGINT, -- id referencia del usuario entidad
--      @Detail BIT -- define si el resultado va a detallar los registros de los permisos por roles o va a agrupar el resultado de los permisos.
--
-- Ejecutar el procedimiento para probar los resultados: 
--              EXEC sp_GetRolePermissionsRecord @userId = 3, @entityId = 2, @Detail = 0;
-- ===================================================

CREATE OR ALTER PROCEDURE sp_GetRolePermissionsRecord
    @userId BIGINT,
    @entityId BIGINT,
    @Detail BIT
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
        r.company_id,
        ur.user_id,
        r.role_name AS [role],
        'Registro' AS permission_level,
        prr.entitycatalog_id AS entity_id,
        ec.entit_name AS entity_name,
        prr.perrc_record AS register_id,
        rer.register_name AS register_entity,
        MAX(CASE WHEN p.can_read = 1 THEN 'Sí' ELSE 'No' END) AS Leer_Registros,
        MAX(CASE WHEN p.can_create = 1 THEN 'Sí' ELSE 'No' END) AS Crear_Registros,
        MAX(CASE WHEN p.can_update = 1 THEN 'Sí' ELSE 'No' END) AS Actualizar_Registros,
        MAX(CASE WHEN p.can_delete = 1 THEN 'Sí' ELSE 'No' END) AS Eliminar_Registros,
        MAX(CASE WHEN p.can_export = 1 THEN 'Sí' ELSE 'No' END) AS Exportacion_Masiva,
        MAX(CASE WHEN p.can_import = 1 THEN 'Sí' ELSE 'No' END) AS Importacion_Masiva
    INTO #RESULT
    FROM 
        PermiRoleRecord prr
    INNER JOIN 
        Role r ON prr.role_id = r.id_role 
    INNER JOIN 
        EntityCatalog ec ON prr.entitycatalog_id = ec.id_entit
    INNER JOIN 
        Permission p ON prr.permission_id = p.id_permi 
    INNER JOIN 
        UserRole ur ON r.id_role = ur.role_id
    LEFT JOIN 
        @ResultsEntityRegisters rer ON prr.perrc_record = rer.id
    WHERE 
        prr.entitycatalog_id = @entityId
        AND prr.perrc_include = 1
        AND ur.user_id = @userId
        
    GROUP BY 
        r.company_id, ur.user_id, r.role_name,prr.entitycatalog_id, ec.entit_name, prr.perrc_record, rer.register_name;

    IF @Detail = 0
    BEGIN
        ALTER TABLE #RESULT DROP COLUMN [role]

        SELECT 
            company_id,
            user_id,
            permission_level,
            entity_id,
            entity_name,
            register_id,
            register_entity,
            MAX(Leer_Registros),
            MAX(Crear_Registros),
            MAX(Actualizar_Registros),
            MAX(Eliminar_Registros),
            MAX(Exportacion_Masiva),
            MAX(Importacion_Masiva)
        FROM #RESULT
        GROUP BY 
            company_id,
            user_id,
            permission_level,
            entity_id,
            entity_name,
            register_id,
            register_entity;
    END
    ELSE
    BEGIN
        SELECT 
            company_id,
            user_id,
            [role], 
            permission_level,
            entity_id,
            entity_name,
            register_id,
            Leer_Registros,
            Crear_Registros,
            Actualizar_Registros,
            Eliminar_Registros,
            Exportacion_Masiva,
            Importacion_Masiva
        FROM #RESULT;
    END

    
END