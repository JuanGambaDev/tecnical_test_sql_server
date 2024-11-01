USE PermitSystem
GO

INSERT INTO PermiRole 
(role_id, permission_id, entitycatalog_id, perol_include, perol_record) 
VALUES
(1, 1, 1, 1, NULL),
(1, 2, 1, 1, NULL),
(1, 3, 1, 1, NULL),
(1, 4, 1, 1, NULL),
(1, 5, 1, 1, NULL),
(1, 6, 1, 1, NULL),
(1, 1, 2, 1, NULL),
(1, 2, 2, 1, NULL),
(1, 3, 2, 1, NULL),
(1, 4, 2, 1, NULL),
(1, 5, 2, 1, NULL),
(1, 6, 2, 1, NULL),
(2, 2, 1, 1, NULL),
(2, 3, 1, 1, NULL),
(2, 2, 2, 1, NULL),
(2, 3, 2, 1, NULL),
(2, 4, 2, 1, NULL),
(3, 2, 2, 1, NULL),
(4, 2, 2, 1, NULL),
(4, 3, 2, 1, NULL);
