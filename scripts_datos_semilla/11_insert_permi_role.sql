USE PermitSystem
GO

INSERT INTO PermiRole 
(
    role_id, permission_id, entitycatalog_id, perol_include, perol_record
) 
VALUES
(
    3, 
    1, 
    1, 
    1, 
    NULL
),
(
    4, 
    2, 
    2, 
    1, 
    NULL
);
