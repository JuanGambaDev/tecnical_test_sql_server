USE PermitSystem;
GO

-- ===================================================
-- Author: Juan Gamba
-- Date: Noviembre 01, 2024
-- Description: Este procedimiento almacenado obtiene los permisos asignados a un usuario
--              a nivel de entidad y a nivel de registro dentro de la entidad.
--              Ejecutar el procedimiento para probar los resultados: 
--              EXEC sp_GetUserPermissions_Main @userId = 3, @entityId = 2;
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
        INSERT INTO @Permissions (company_id, user_id, entity_id, entity_name, register_id, 
            Leer_Registros, Crear_Registros, Actualizar_Registros, Eliminar_Registros, 
            Exportacion_Masiva, Importacion_Masiva)
        SELECT
            uc.company_id,
            uc.user_id,
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
        GROUP BY 
            uc.company_id, uc.user_id, pu.entitycatalog_id, ec.entit_name;

        -- Inserción de permisos a nivel de entidad para roles del usuario
        INSERT INTO @Permissions (company_id, user_id, entity_id, entity_name, register_id, 
            Leer_Registros, Crear_Registros, Actualizar_Registros, Eliminar_Registros, 
            Exportacion_Masiva, Importacion_Masiva)
        SELECT 
            r.company_id,
            ur.user_id,
            pr.entitycatalog_id,
            ec.entit_name AS entity_name,
            NULL AS register_id,
            MAX(CASE WHEN p.can_read = 1 THEN 'Sí' ELSE 'No' END) AS Leer_Registros,
            MAX(CASE WHEN p.can_create = 1 THEN 'Sí' ELSE 'No' END) AS Crear_Registros,
            MAX(CASE WHEN p.can_update = 1 THEN 'Sí' ELSE 'No' END) AS Actualizar_Registros,
            MAX(CASE WHEN p.can_delete = 1 THEN 'Sí' ELSE 'No' END) AS Eliminar_Registros,
            MAX(CASE WHEN p.can_export = 1 THEN 'Sí' ELSE 'No' END) AS Exportacion_Masiva,
            MAX(CASE WHEN p.can_import = 1 THEN 'Sí' ELSE 'No' END) AS Importacion_Masiva
        FROM 
            PermiRole pr
        INNER JOIN 
            Role r ON pr.role_id = r.id_role 
        INNER JOIN 
            EntityCatalog ec ON pr.entitycatalog_id = ec.id_entit
        INNER JOIN 
            Permission p ON pr.permission_id = p.id_permi
        INNER JOIN 
            UserRole ur ON r.id_role = ur.role_id
        WHERE 
            pr.entitycatalog_id = @entityId
            AND ur.user_id = @userId
        GROUP BY 
            r.company_id, ur.user_id, pr.entitycatalog_id, ec.entit_name;

        -- Permisos en registros específicos de la entidad para el usuario
        INSERT INTO @Permissions (company_id, user_id, entity_id, entity_name, register_id, 
            Leer_Registros, Crear_Registros, Actualizar_Registros, Eliminar_Registros, 
            Exportacion_Masiva, Importacion_Masiva)
        SELECT
            uc.company_id,
            uc.user_id,
            pur.entitycatalog_id AS entity_id,
            ec.entit_name AS entity_name,
            pur.peusr_record AS register_id,
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
        WHERE 
            uc.user_id = @userId 
            AND pur.entitycatalog_id = @entityId
        GROUP BY 
            uc.company_id, uc.user_id, pur.entitycatalog_id, ec.entit_name, pur.peusr_record;

        -- Permisos en registros específicos de la entidad para roles
        INSERT INTO @Permissions (company_id, user_id, entity_id, entity_name, register_id, 
            Leer_Registros, Crear_Registros, Actualizar_Registros, Eliminar_Registros, 
            Exportacion_Masiva, Importacion_Masiva)
        SELECT
            r.company_id,
            ur.user_id,
            prr.entitycatalog_id AS entity_id,
            ec.entit_name AS entity_name,
            prr.perrc_record AS register_id,
            MAX(CASE WHEN p.can_read = 1 THEN 'Sí' ELSE 'No' END) AS Leer_Registros,
            MAX(CASE WHEN p.can_create = 1 THEN 'Sí' ELSE 'No' END) AS Crear_Registros,
            MAX(CASE WHEN p.can_update = 1 THEN 'Sí' ELSE 'No' END) AS Actualizar_Registros,
            MAX(CASE WHEN p.can_delete = 1 THEN 'Sí' ELSE 'No' END) AS Eliminar_Registros,
            MAX(CASE WHEN p.can_export = 1 THEN 'Sí' ELSE 'No' END) AS Exportacion_Masiva,
            MAX(CASE WHEN p.can_import = 1 THEN 'Sí' ELSE 'No' END) AS Importacion_Masiva
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
        WHERE 
            prr.entitycatalog_id = @entityId
            AND ur.user_id = @userId
        GROUP BY 
            r.company_id, ur.user_id, prr.entitycatalog_id, ec.entit_name, prr.perrc_record;

        -- Obtener registros de una entidad de forma dinámica
        DECLARE @entityName NVARCHAR(255);
        DECLARE @idColumn NVARCHAR(255);
        DECLARE @nameColumn NVARCHAR(255);
        DECLARE @sql NVARCHAR(MAX);

        -- Obtener el nombre de la entidad de EntityCatalog
        SELECT @entityName = entit_name
        FROM EntityCatalog
        WHERE id_entit = @entityId; 

        -- Crear tabla temporal para almacenar los resultados de registros
        CREATE TABLE #ResultsEntityRegisters (
            id BIGINT,
            name NVARCHAR(255)
        );

        -- Verificar si el nombre de la entidad no es nulo
        IF @entityName IS NOT NULL
        BEGIN
            SELECT TOP 1 
                @idColumn = c1.name, 
                @nameColumn = c2.name
            FROM sys.columns c1
            JOIN sys.tables t ON c1.object_id = t.object_id
            JOIN sys.columns c2 ON c2.object_id = t.object_id 
                AND c2.name LIKE '%name%'  -- Asumiendo que el nombre de la columna incluye 'name'
            WHERE t.name = @entityName
            AND c1.is_identity = 1;  

            -- Verificar si se encontró la columna ID y Name
            IF @idColumn IS NOT NULL AND @nameColumn IS NOT NULL
            BEGIN
                -- Crear consulta para insertar datos
                SET @sql = N'
                INSERT INTO #ResultsEntityRegisters (id, name)
                SELECT 
                    ' + QUOTENAME(@idColumn) + ', 
                    ' + QUOTENAME(@nameColumn) + ' 
                FROM ' + QUOTENAME(@entityName) + ';';

                EXEC sp_executesql @sql;
            END
            ELSE
            BEGIN
                PRINT 'No se encontró una columna ID o Name para la tabla.';
            END
        END
        ELSE
        BEGIN
            PRINT 'El nombre de la entidad es nulo o no existe.';
        END

        -- Seleccionar resultados finales, eliminando duplicados
        SELECT 
            per.company_id AS Compania_Id,
            c.compa_name AS Compania,
            u.id_user AS Usuario_Id,
            u.user_username AS Username,
            CASE WHEN per.register_id IS NULL THEN 'Entity' ELSE 'Register' END AS Nivel_de_Permiso,
            per.entity_id AS Entidad_Id,
            per.entity_name AS Entidad,
            per.register_id AS Registro_id,
            tempr.name AS Registro,
            MAX(per.Leer_Registros) AS Leer_Registros,
            MAX(per.Crear_Registros) AS Crear_Registros,
            MAX(per.Actualizar_Registros) AS Actualizar_Registros,
            MAX(per.Eliminar_Registros) AS Eliminar_Registros,
            MAX(per.Exportacion_Masiva) AS Exportacion_Masiva,
            MAX(per.Importacion_Masiva) AS Importacion_Masiva
        FROM @Permissions per
        INNER JOIN [User] u ON per.user_id = u.id_user
        INNER JOIN [Company] c ON per.company_id = c.id_compa
        LEFT JOIN #ResultsEntityRegisters tempr ON per.register_id = tempr.id
        GROUP BY per.company_id, c.compa_name, u.id_user, u.user_username, per.entity_id, per.entity_name, per.register_id, tempr.name
        ORDER BY per.entity_name, per.register_id;

        -- Limpiar la tabla temporal
        DROP TABLE #ResultsEntityRegisters;

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

        -- Registrar error (se puede modificar para registrar en una tabla de errores o en logs)
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
        
        -- Opcionalmente, puedes limpiar la tabla temporal si es necesario
        IF OBJECT_ID('tempdb..#ResultsEntityRegisters') IS NOT NULL
            DROP TABLE #ResultsEntityRegisters;
    END CATCH
END
GO
