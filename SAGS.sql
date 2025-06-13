  -- phpMyAdmin SQL Dump
  -- version 5.2.1
  -- https://www.phpmyadmin.net/
  --
  -- Servidor: 127.0.0.1
  -- Tiempo de generación: 13-06-2025 a las 06:09:16
  -- Versión del servidor: 10.4.32-MariaDB
  -- Versión de PHP: 8.0.30

  SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
  START TRANSACTION;
  SET time_zone = "+00:00";


  /*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
  /*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
  /*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
  /*!40101 SET NAMES utf8mb4 */;

  --
  -- Base de datos: `sags`
  --
  CREATE DATABASE IF NOT EXISTS `sags` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
  USE `sags`;

  DELIMITER $$
  --
  -- Procedimientos
  --
  CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarUsuario` (IN `p_email` VARCHAR(40), IN `p_nuevosdatos` VARCHAR(50))   BEGIN
      UPDATE usuarios
      SET datos = CONCAT(datos, p_nuevosdatos)
      WHERE email = p_email;
  END$$

  CREATE DEFINER=`root`@`localhost` PROCEDURE `Act_y_Reg_Proyectos` (IN `p_idproy` INT, IN `p_nombre` VARCHAR(45), IN `p_descripcion` VARCHAR(1000), IN `p_tipo` VARCHAR(25), IN `p_fechaI` DATE, IN `p_fechaF` DATE, IN `p_linkform` VARCHAR(200), IN `accion` VARCHAR(45))   BEGIN
  CASE 
    WHEN accion='registrar' THEN
    INSERT INTO proyectos(idproy, nombre, descripcion, tipo, fechaI, fechaF, linkform)
    VALUES(p_idproy, p_nombre, p_descripcion, p_tipo, p_fechaI, p_fechaF, p_linkform);
    WHEN accion='actualizar' THEN
    UPDATE proyectos SET
    nombre=p_nombre, descripcion=p_descripcion, tipo=p_tipo, fechaI=p_fechaI, fechaF=p_fechaF, linkform=p_linkform
    WHERE idproy=p_idproy;
  END CASE;
  END$$

  CREATE DEFINER=`root`@`localhost` PROCEDURE `Act_y_Reg_Usuarios` (IN `u_email` VARCHAR(100), IN `u_tipodoc` VARCHAR(11), IN `u_documento` INT, IN `u_password` VARBINARY(10), IN `u_telefono` INT, IN `u_nombres` VARCHAR(33), IN `u_apellidos` VARCHAR(33), IN `u_foto` VARCHAR(200), IN `u_perfil` VARCHAR(80), IN `accion` VARCHAR(100))   BEGIN
    CASE 
      WHEN accion = 'registrar' THEN
        INSERT INTO usuarios (email, tipodoc, documento, password, telefono, nombres, apellidos, foto, perfil)
        VALUES (u_email, u_tipodoc, u_documento, u_password, u_telefono, u_nombres, u_apellidos, u_foto, u_perfil);
      WHEN accion = 'actualizar' THEN
        UPDATE usuarios 
        SET tipodoc = u_tipodoc, documento = u_documento, password = u_password, telefono = u_telefono, nombres = u_nombres, apellidos = u_apellidos, foto = u_foto, perfil = u_perfil
        WHERE email = u_email;
    END CASE;
  END$$

  CREATE DEFINER=`root`@`localhost` PROCEDURE `Agregar_requisitos_a_proyecto` (IN `p_id_proyecto` INT, IN `p_id_requisito` INT)   INSERT INTO requisitos_proyectos (idreq, idproy)
    VALUES (p_id_requisito, p_id_proyecto)$$

  CREATE DEFINER=`root`@`localhost` PROCEDURE `Asignar_usuario_a_proyecto` (IN `p_id_proyecto` INT, IN `et_id` INT(100))   BEGIN
    INSERT INTO usu_proy (idproy, id)
    VALUES (p_id_proyecto,et_id);
  END$$

  CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarRequisitosProyecto` (IN `p_idproy` INT)   BEGIN
      DELETE FROM requisitos_proyectos
      WHERE idproy = p_idproy;
  END$$

  CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarUsuario` (IN `p_email` VARCHAR(40))   BEGIN
      DELETE FROM usuarios
      WHERE email = p_email;
  END$$

  CREATE DEFINER=`root`@`localhost` PROCEDURE `Eliminar_requisito_de_proyecto` (IN `p_id_proyecto` INT, IN `p_id_requisito` INT)   BEGIN
    DELETE FROM requisitos_proyectos
    WHERE idreq = p_id_requisito AND idproy = p_id_proyecto;
  END$$

  CREATE DEFINER=`root`@`localhost` PROCEDURE `Elim_y_Cons_Proyectos` (IN `p_idproy` INT, IN `accion` VARCHAR(20))   BEGIN
  CASE
      when accion ='eliminar' THEN
      DELETE FROM proyectos
      WHERE idproy = p_idproy;
      when accion ='consultar' THEN
      SELECT * FROM proyectos
      WHERE idproy = p_idproy;
  END CASE;
  END$$

  CREATE DEFINER=`root`@`localhost` PROCEDURE `Elim_y_Cons_Requisitos` (IN `r_idreq` INT, IN `accion` VARCHAR(45))   BEGIN
  CASE
  WHEN accion='consultar' THEN
  SELECT * FROM requisitos WHERE r_idreq=idreq;
  WHEN accion='eliminar' THEN
  DELETE FROM requisitos WHERE r_idreq=idreq;
  END CASE;
  END$$

  CREATE DEFINER=`root`@`localhost` PROCEDURE `Elim_y_Cons_Usuarios` (IN `p_email` VARCHAR(40), IN `accion` VARCHAR(20))   BEGIN
  CASE
      when accion ='eliminar' THEN
      DELETE FROM usuarios
      WHERE email = p_email;
      when accion ='consultar' THEN
      SELECT * FROM usuarios
      WHERE email = p_email;
  END CASE;
  END$$

  CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertarRequisito` (IN `p_nombre` VARCHAR(20), IN `p_descripcion` VARCHAR(50), IN `p_tipo_pri_req` VARCHAR(80), IN `p_tipo_req` VARCHAR(80))   BEGIN
      INSERT INTO requisitos (nombre, descripcion, tipo_pri_req, tipo_req)
      VALUES (p_nombre, p_descripcion, p_tipo_pri_req, p_tipo_req);
  END$$

  CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertarUsuario` (IN `p_email` VARCHAR(100), IN `p_tipodoc` VARCHAR(11), IN `p_documento` INT, IN `p_password` VARCHAR(6), IN `p_telefono` INT, IN `p_nombres` VARCHAR(33), IN `p_apellidos` VARCHAR(33), IN `p_foto` VARCHAR(50), IN `p_idrol` INT)   BEGIN
      INSERT INTO usuarios (email, tipodoc, documento, password, telefono, nombres, apellidos, foto, idrol)
      VALUES (p_email, p_tipodoc, p_documento, p_password, p_telefono, p_nombres, p_apellidos, p_foto, p_idrol);
  END$$

  CREATE DEFINER=`root`@`localhost` PROCEDURE `Proyectos_asociados` (IN `id_usuario` VARCHAR(40))   BEGIN
    SELECT p.idproy, p.nombre, p.descripcion
    FROM proyectos p
    INNER JOIN usu_proy up ON p.idproy = up.idproy
    INNER JOIN usuarios u ON up.email = u.email
    WHERE u.email = id_usuario;
  END$$

  CREATE DEFINER=`root`@`localhost` PROCEDURE `Tareas_por_sprint` (IN `p_id_sprint` INT)   BEGIN
    SELECT t.id_tar, t.nombre, t.descripcion
    FROM tareas t
    WHERE t.idsprint = p_id_sprint;
  END$$

  --
  -- Funciones
  --
  CREATE DEFINER=`root`@`localhost` FUNCTION `#_De_Tareas_por_Sprint` (`p_idsprint` INT) RETURNS INT(11)  BEGIN
      DECLARE numero_tareas INT;
      SELECT COUNT(*) INTO numero_tareas FROM tareas WHERE idsprint = p_idsprint;
      RETURN numero_tareas;
  END$$

  CREATE DEFINER=`root`@`localhost` FUNCTION `ContarProyectos` () RETURNS INT(11)  BEGIN
      DECLARE num_proyectos INT;
      SELECT COUNT(*) INTO num_proyectos FROM proyectos;
      RETURN num_proyectos;
  END$$

  CREATE DEFINER=`root`@`localhost` FUNCTION `encriptar` (`password` VARCHAR(20)) RETURNS VARBINARY(100)  BEGIN
  DECLARE ClaveEncri varbinary(100);
  SET ClaveEncri = AES_ENCRYPT(password,'sena');
  RETURN ClaveEncri;
  END$$

  CREATE DEFINER=`root`@`localhost` FUNCTION `Nombre_del_Usuario` (`p_email` VARCHAR(100)) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
      DECLARE usuario_email VARCHAR(100);
      SELECT CONCAT(email, ' - ', nombres, ' ', apellidos) INTO usuario_email
      FROM usuarios
      WHERE email = p_email;
      RETURN usuario_email;
  END$$

  CREATE DEFINER=`root`@`localhost` FUNCTION `Numero_de_Requisitos` (`p_idproy` INT) RETURNS INT(11)  BEGIN
      DECLARE numero_requisitos INT;
      SELECT COUNT(*) INTO numero_requisitos FROM requisitos_proyectos WHERE idproy = p_idproy;
      RETURN numero_requisitos;
  END$$

  CREATE DEFINER=`root`@`localhost` FUNCTION `ObtenerPrioridadRequisito` (`p_idreq` INT) RETURNS VARCHAR(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
      DECLARE prioridad_requisito VARCHAR(20);
      SELECT tipo_pri_req INTO prioridad_requisito
      FROM requisitos
      WHERE idreq = p_idreq;
      RETURN prioridad_requisito;
  END$$

  CREATE DEFINER=`root`@`localhost` FUNCTION `ObtenerRequisitosProyecto` (`p_idproy` INT) RETURNS VARCHAR(200) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
      DECLARE requisitos_proyecto VARCHAR(200);
      SELECT GROUP_CONCAT(r.nombre SEPARATOR ', ') INTO requisitos_proyecto
      FROM requisitos r
      JOIN requisitos_proyectos rp ON r.idreq = rp.idreq
      WHERE rp.idproy = p_idproy;
      RETURN requisitos_proyecto;
  END$$

  CREATE DEFINER=`root`@`localhost` FUNCTION `ObtenerTipoRequisito` (`p_idreq` INT) RETURNS VARCHAR(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
      DECLARE tipo_requisito VARCHAR(20);
      SELECT tipo_req INTO tipo_requisito
      FROM requisitos
      WHERE idreq = p_idreq;
      RETURN tipo_requisito;
  END$$

  CREATE DEFINER=`root`@`localhost` FUNCTION `ObtenerUsuario` (`p_email` VARCHAR(100)) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
      DECLARE usuario_email VARCHAR(100);
      SELECT CONCAT(email, ' - ', nombres, ' ', apellidos) INTO usuario_email
      FROM usuarios
      WHERE email = p_email;
      RETURN usuario_email;
  END$$

  CREATE DEFINER=`root`@`localhost` FUNCTION `Prioridad_del_Requisito` (`p_idreq` INT) RETURNS VARCHAR(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
      DECLARE prioridad_requisito VARCHAR(20);
      SELECT tipo_pri_req INTO prioridad_requisito
      FROM requisitos
      WHERE idreq = p_idreq;
      RETURN prioridad_requisito;
  END$$

  CREATE DEFINER=`root`@`localhost` FUNCTION `Requisitos_del_Proyecto` (`p_idproy` INT) RETURNS VARCHAR(200) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
      DECLARE requisitos_proyecto VARCHAR(200);
      SELECT GROUP_CONCAT(r.nombre SEPARATOR ', ') INTO requisitos_proyecto
      FROM requisitos r
      JOIN requisitos_proyectos rp ON r.idreq = rp.idreq
      WHERE rp.idproy = p_idproy;
      RETURN requisitos_proyecto;
  END$$

  CREATE DEFINER=`root`@`localhost` FUNCTION `Rol_Del_Usuario` (`p_email` VARCHAR(100)) RETURNS VARCHAR(65) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
      DECLARE rol_usuario VARCHAR(65);
      SELECT descripcion INTO rol_usuario FROM roles WHERE idrol = (SELECT idrol FROM usuarios WHERE email = p_email);
      RETURN rol_usuario;
  END$$

  CREATE DEFINER=`root`@`localhost` FUNCTION `Tipo_de_Requisito` (`p_idreq` INT) RETURNS VARCHAR(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
      DECLARE tipo_requisito VARCHAR(20);
      SELECT tipo_req INTO tipo_requisito
      FROM requisitos
      WHERE idreq = p_idreq;
      RETURN tipo_requisito;
  END$$

  CREATE DEFINER=`root`@`localhost` FUNCTION `Total_de_Proyectos` () RETURNS INT(11)  BEGIN
      DECLARE num_proyectos INT;
      SELECT COUNT(*) INTO num_proyectos FROM proyectos;
      RETURN num_proyectos;
  END$$

  DELIMITER ;

  -- --------------------------------------------------------

  --
  -- Estructura de tabla para la tabla `checklists`
  --

  CREATE TABLE `checklists` (
    `idcheck` int(11) NOT NULL COMMENT 'Identificador único del checklist',
    `idmod` varchar(5) NOT NULL COMMENT 'Llave foránea, identificadora de tabla modelos ',
    `aprobacion` int(11) DEFAULT NULL COMMENT 'Indica si el checklist está aprobado',
    `archivo` varchar(200) DEFAULT NULL COMMENT 'Archivo adjunto al checklist',
    `fecha` date DEFAULT NULL COMMENT 'Fecha del checklist',
    `progreso` int(11) NOT NULL COMMENT 'Campo de seguimiento acerca del avance de proyecto',
    `idproy` int(11) DEFAULT NULL COMMENT 'ID del proyecto asociado'
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar información de checklists';

  --
  -- Volcado de datos para la tabla `checklists`
  --

  INSERT INTO `checklists` (`idcheck`, `idmod`, `aprobacion`, `archivo`, `fecha`, `progreso`, `idproy`) VALUES
  (1, 'CU', 0, '', '0000-00-00', 0, 27),
  (2, 'MC', 0, '', '0000-00-00', 0, 27),
  (3, 'MER', 0, '', '0000-00-00', 0, 27),
  (4, 'MO', 0, '', '0000-00-00', 0, 27),
  (5, 'MR', 0, '', '0000-00-00', 0, 27),
  (6, 'RQ', 0, '', '0000-00-00', 0, 27),
  (7, 'CU', 1, 'Casos de Uso Extendido SAGS.pdf', '2024-09-29', 70, 4),
  (8, 'MC', 0, 'MANUAL_DE_DESPLIEGUE_DE_LA_BASE_DE_DATOS._GRAVITY.docx', '2025-06-12', 90, 4),
  (9, 'MER', 0, 'Plan_de_Instalacion.pdf', '2025-06-12', 0, 4),
  (11, 'MR', 0, 'MR SAGS.pdf', '2024-09-30', 100, 4),
  (12, 'RQ', 0, '', '0000-00-00', 0, 4),
  (13, 'CU', 0, '', '0000-00-00', 0, 28),
  (14, 'MC', 0, '', '0000-00-00', 0, 28),
  (15, 'MER', 0, '', '0000-00-00', 0, 28),
  (16, 'MO', 0, '', '0000-00-00', 0, 28),
  (17, 'MR', 0, '', '0000-00-00', 0, 28),
  (18, 'RQ', 0, '', '0000-00-00', 0, 28),
  (19, 'CU', 0, '', '0000-00-00', 0, 29),
  (20, 'MC', 0, '', '0000-00-00', 0, 29),
  (21, 'MER', 0, '', '0000-00-00', 0, 29),
  (22, 'MO', 0, '', '0000-00-00', 0, 29),
  (23, 'MR', 0, '', '0000-00-00', 0, 29),
  (24, 'RQ', 0, '', '0000-00-00', 0, 29),
  (25, 'CU', 0, '', '0000-00-00', 0, 30),
  (26, 'MC', 0, '', '0000-00-00', 0, 30),
  (27, 'MER', 0, '', '0000-00-00', 0, 30),
  (28, 'MO', 0, '', '0000-00-00', 0, 30),
  (29, 'MR', 0, '', '0000-00-00', 0, 30),
  (30, 'RQ', 0, '', '0000-00-00', 0, 30),
  (31, 'CU', 0, '', '0000-00-00', 0, 31),
  (32, 'MC', 0, '', '0000-00-00', 0, 31),
  (33, 'MER', 0, '', '0000-00-00', 0, 31),
  (34, 'MO', 0, '', '0000-00-00', 0, 31),
  (35, 'MR', 0, '', '0000-00-00', 0, 31),
  (36, 'RQ', 0, '', '0000-00-00', 0, 31),
  (37, 'CU', 0, '', '0000-00-00', 0, 32),
  (38, 'MC', 0, '', '0000-00-00', 0, 32),
  (39, 'MER', 0, '', '0000-00-00', 0, 32),
  (40, 'MO', 0, '', '0000-00-00', 0, 32),
  (41, 'MR', 0, '', '0000-00-00', 0, 32),
  (42, 'RQ', 0, '', '0000-00-00', 0, 32),
  (43, 'CU', 0, '', '0000-00-00', 0, 33),
  (44, 'MC', 0, '', '0000-00-00', 0, 33),
  (45, 'MER', 0, '', '0000-00-00', 0, 33),
  (46, 'MO', 0, '', '0000-00-00', 0, 33),
  (47, 'MR', 0, '', '0000-00-00', 0, 33),
  (48, 'RQ', 0, '', '0000-00-00', 0, 33),
  (72, 'RQ', NULL, NULL, NULL, 0, 40),
  (73, 'CU', NULL, NULL, NULL, 0, 40),
  (74, 'CUX', NULL, NULL, NULL, 0, 40),
  (0, 'RQ', NULL, NULL, NULL, 0, 42),
  (0, 'CU', NULL, NULL, NULL, 0, 42),
  (0, 'CUX', NULL, NULL, NULL, 0, 42),
  (0, 'MC', NULL, NULL, NULL, 0, 42),
  (0, 'MO', NULL, NULL, NULL, 0, 42),
  (0, 'MER', NULL, NULL, NULL, 0, 42),
  (0, 'MR', NULL, NULL, NULL, 0, 42),
  (0, 'RQ', NULL, NULL, NULL, 0, 43),
  (0, 'CU', NULL, NULL, NULL, 0, 43),
  (0, 'CUX', NULL, NULL, NULL, 0, 43),
  (0, 'RQ', NULL, NULL, NULL, 0, 44),
  (0, 'CU', NULL, NULL, NULL, 0, 44),
  (0, 'CUX', NULL, NULL, NULL, 0, 44),
  (0, 'MC', NULL, NULL, NULL, 0, 44),
  (0, 'MO', NULL, NULL, NULL, 0, 44),
  (0, 'RQ', NULL, NULL, NULL, 0, 48),
  (0, 'CU', NULL, NULL, NULL, 0, 48),
  (0, 'CUX', NULL, NULL, NULL, 0, 48),
  (0, 'RQ', NULL, NULL, NULL, 0, 49),
  (0, 'CU', NULL, NULL, NULL, 0, 49),
  (0, 'CUX', NULL, NULL, NULL, 0, 49),
  (0, 'MC', NULL, NULL, NULL, 0, 49),
  (0, 'MO', NULL, NULL, NULL, 0, 49),
  (0, 'RQ', NULL, NULL, NULL, 0, 50),
  (0, 'CU', NULL, NULL, NULL, 0, 50),
  (0, 'CUX', NULL, NULL, NULL, 0, 50),
  (0, 'MC', NULL, NULL, NULL, 0, 50),
  (0, 'MO', NULL, NULL, NULL, 0, 50),
  (0, 'MER', NULL, NULL, NULL, 0, 50),
  (0, 'MR', NULL, NULL, NULL, 0, 50),
  (0, 'RQ', NULL, NULL, NULL, 0, 51),
  (0, 'MER', NULL, NULL, NULL, 0, 51);

  -- --------------------------------------------------------

  --
  -- Estructura de tabla para la tabla `modelos`
  --

  CREATE TABLE `modelos` (
    `idmod` varchar(5) NOT NULL COMMENT 'Identificador único del modelo',
    `nombre` varchar(40) DEFAULT NULL COMMENT 'Nombre del modelo',
    `descripcion` varchar(80) DEFAULT NULL COMMENT 'Descripción del modelo'
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar información de modelos';

  --
  -- Volcado de datos para la tabla `modelos`
  --

  INSERT INTO `modelos` (`idmod`, `nombre`, `descripcion`) VALUES
  ('CU', 'Documento Casos de Uso', 'Modelo y Diagrama Casos de Uso'),
  ('CUX', 'Casos de Uso Extendido', 'Modelo y Diagrama de Casos de Uso Extendido'),
  ('MC', 'Documento Diagrama de Clases', 'Modelo de clases del sistema'),
  ('MER', 'Documento del Modelo Entidad Relación', 'Diagrama del modelo entidad relación'),
  ('MO', 'Documento Diagrama de Objetos', 'Modelo de objetos del sistema'),
  ('MR', 'Documento del Modelo Relacional', 'Diagrama del modelo relacional'),
  ('RQ', 'Documentos RF y RNF (IEEE-830)', 'Especificación de requisitos funcionales y no funcionales');

  -- --------------------------------------------------------

  --
  -- Estructura de tabla para la tabla `opiniones`
  --

  CREATE TABLE `opiniones` (
    `id_opi` int(11) NOT NULL COMMENT 'Identificador clave de tabla opiniones',
    `opinion` varchar(1000) DEFAULT NULL COMMENT 'Descripción de contenido de PQRS por parte del usuario',
    `calificacion` int(11) DEFAULT NULL COMMENT 'Prioridad de PQRS',
    `tipo_opi` varchar(25) DEFAULT NULL COMMENT 'Tipo de categoría (Petición, Queja, Reclamo, Sugerencia) ',
    `email` varchar(100) NOT NULL COMMENT 'Llave foránea, email del usuario que registra el PQRS'
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar opiniones de usuarios';

  --
  -- Volcado de datos para la tabla `opiniones`
  --

  INSERT INTO `opiniones` (`id_opi`, `opinion`, `calificacion`, `tipo_opi`, `email`) VALUES
  (1, 'Al intentar previsualizar algunos documentos PDF, noté que en ocasiones no se cargan correctamente o tardan demasiado en aparecer. Esto dificulta la revisión rápida de archivos, especialmente cuando necesito hacer comparaciones rápidas entre documentos.', 2, 'Queja', 'smithcortes01@gmail.com'),
  (2, 'Sería muy útil que el sistema incluyera una funcionalidad para enviar notificaciones a los usuarios cuando un documento ha sido actualizado o aprobado por el administrador. Esto nos permitiría estar al tanto de los cambios sin necesidad de revisar constantemente la plataforma.', 4, 'Petición ', 'majogalan2006@gmail.com'),
  (3, 'He notado que, al intentar cargar documentos de gran tamaño, el sistema tiende a ser un poco lento, lo que afecta la experiencia de usuario. Sería ideal optimizar la carga para archivos más pesados, ya que trabajamos con muchos documentos extensos.', 3, 'Queja', 'diego.lopezm0405@gmail.com'),
  (4, 'Me gustaría sugerir que se integre una función de búsqueda avanzada, donde los usuarios puedan filtrar los documentos por fecha de creación, tipo de archivo o estado de aprobación. Esto haría mucho más eficiente la gestión y localización de documentos específicos.', 4, 'Sugerencia', 'nicolasgiraldo1020@gmail.com'),
  (5, 'Sería excelente si el sistema permitiera colaborar en línea, es decir, que varios usuarios puedan realizar comentarios o editar ciertos documentos de forma colaborativa en tiempo real. Esto agilizaría el flujo de trabajo en proyectos donde varias personas necesitan revisar los mismos archivos.', 4, 'Sugerencia', 'linaessofia33@gmail.com');

  -- --------------------------------------------------------

  --
  -- Estructura de tabla para la tabla `planes`
  --

  CREATE TABLE `planes` (
    `nomplan` varchar(30) NOT NULL COMMENT 'Nombre descriptivo de planes',
    `descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripción según lo ofrecido en cada categoría del plan',
    `precio` int(11) DEFAULT NULL COMMENT 'Valor estimado por servicios ofrecidos'
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar planes disponibles';

  --
  -- Volcado de datos para la tabla `planes`
  --

  INSERT INTO `planes` (`nomplan`, `descripcion`, `precio`) VALUES
  ('BASIC', 'IEEE-830, ', 150000),
  ('PERSONALIZADO', NULL, NULL),
  ('PREMIUM', 'IEEE-830, ', 600000),
  ('STANDARD', 'IEEE-830, ', 300000);

  -- --------------------------------------------------------

  --
  -- Estructura de tabla para la tabla `proyectos`
  --

  CREATE TABLE `proyectos` (
    `idproy` int(11) NOT NULL COMMENT 'Identificador primario de la tabla proyectos',
    `nombre` varchar(55) DEFAULT NULL COMMENT 'Identificador de proyectos por medio de un nombre descriptivo',
    `descripcion` varchar(700) DEFAULT NULL COMMENT 'Explicación breve del proyecto',
    `tipo` varchar(25) DEFAULT NULL COMMENT 'Categoría del proyecto (web - móvil)',
    `fechaI` date DEFAULT NULL COMMENT 'Fecha de registro del proyecto',
    `fechaF` date DEFAULT NULL COMMENT 'Fecha de entrega del proyecto',
    `nomplan` varchar(55) DEFAULT NULL COMMENT 'Llave foránea del plan asignado al proyecto '
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar información de proyectos';

  --
  -- Volcado de datos para la tabla `proyectos`
  --

  INSERT INTO `proyectos` (`idproy`, `nombre`, `descripcion`, `tipo`, `fechaI`, `fechaF`, `nomplan`) VALUES
  (4, 'SAGS', 'El presente documento tiene como fin definir los requisitos funcionales y no funcionales para el desarrollo del aplicativo web (SIRS) con el fin de conocer sus fundamentos, sus bases y motivos de su surgimiento, creación o causas originarias.', 'Aplicativo Web', '2022-04-10', '0000-00-00', NULL),
  (27, 'TOEXS', 'Para el desarrollo del proyecto se tiene como propósito definir y establecer los RF y RNF del aplicativo Web TOEXS, con un modelo cliente/servidor, que permita llevar a cabo procesos de comunicación, gestión e intercambio de juguetes online.', 'Aplicativo Web', '2023-08-24', '0000-00-00', NULL),
  (28, 'GIET', 'El presente documento tiene como propósito definir las especificaciones funcionales y no funcionales que deberá cumplir el aplicativo web (GIET), el cual hará uso de las herramientas y prestaciones administrativas para la gestión de recursos informáticos, dirigido al uso de usuarios específicos y administradores del inventario de la institución educativa (CTJFR).', 'Aplicativo Web', '2022-02-01', '0000-00-00', NULL),
  (29, 'SOFT_SPA', 'Tiene como propósito definir las especificaciones de requisitos funcionales y no funcionales para el desarrollo del aplicativo web (soft-spa).', 'Aplicativo Web', '2022-04-01', '0000-00-00', NULL),
  (30, 'JOSE FELIX LIBRARY', 'El presente documento tiene como propósito definir las especificaciones de requisitos funcionales y no funcionales para el desarrollo de un sistema de información web modelo usuario/servidor, que permitirá sistematizar y gestionar los distintos materiales didácticos que se encuentran en la biblioteca del colegio JFR (libros, archivos, etc.), dirigido al desarrollo y análisis de nuevos proyectos.', 'Aplicativo Web', '2022-02-17', '0000-00-00', NULL),
  (31, 'SIVOTU', 'El presente documento tiene como propósito definir las especificaciones de requisitos funcionales y no funcionales para el desarrollo de un aplicativo web (SIVOTU) modelo cliente servidor, que permita sistematizar y gestionar distintos procesos administrativos y servidor online de la tienda \"the shift urbans\" dirigido al uso de usuarios externos empleados y administradores.', 'Aplicativo Web', '2004-07-24', '0000-00-00', NULL),
  (32, 'New Life', 'Brindar una herramienta que ayude a las entidades de salud mental a tratar profesionalmente a personas que fueron y son violentadas física y psicológicamente, así ayudándolos a progresar y tener un nuevo cambio en su vida social y personal.', 'Aplicativo Web', '2022-07-13', '0000-00-00', NULL),
  (33, 'All Sport System', 'Gestionar ayudas y acceso a la comunidad de alternativas de ayuda profesional a través de consultas y terapias que se les brindan de acuerdo al diagnóstico que se le den a los pacientes o usuarios registrados en el aplicativo.', 'Aplicativo Web', '2022-05-10', '0000-00-00', NULL),
  (40, 'SGIT', 'Sistema para la gestion e intercambio de equipos tecnologicos en la institucion educativa Colegio Tecnico Jose Felix Restrepo', 'web', '2024-12-09', NULL, 'BASIC'),
  (42, 'Sirs2', 'gsfgs', 'web', '2025-04-19', NULL, 'PREMIUM'),
  (43, 'Sirs', 'fdfsdf', 'web', '2025-04-19', NULL, 'BASIC'),
  (44, 'Sirs', 'hrhgh', 'web', '2025-05-09', NULL, 'STANDARD'),
  (48, 'p1', 'p1', 'web', '2025-06-12', NULL, 'BASIC'),
  (49, 'p2', 'p2', 'web', '2025-06-12', NULL, 'STANDARD'),
  (50, 'p3', 'p3', 'web', '2025-06-12', NULL, 'PREMIUM'),
  (51, 'p4', 'p4', 'web', '2025-06-12', NULL, 'PERSONALIZADO');

  -- --------------------------------------------------------

  --
  -- Estructura de tabla para la tabla `proy_reu`
  --

  CREATE TABLE `proy_reu` (
    `form_proy_reu` int(11) NOT NULL COMMENT 'Identificador primario de la tercer tabla entre proyectos y reuniones',
    `idproy` int(11) DEFAULT NULL COMMENT 'Llave foránea proveniente de la tabla proyectos',
    `idreu` int(11) DEFAULT NULL COMMENT 'Llave foránea proveniente de la tabla reuniones'
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla de relación entre proyectos y reuniones';

  --
  -- Volcado de datos para la tabla `proy_reu`
  --

  INSERT INTO `proy_reu` (`form_proy_reu`, `idproy`, `idreu`) VALUES
  (8, 30, 2),
  (14, 27, 3),
  (35, 28, 4),
  (43, 32, 0);

  -- --------------------------------------------------------

  --
  -- Estructura de tabla para la tabla `reset_tokens`
  --

  CREATE TABLE `reset_tokens` (
    `id` int(11) NOT NULL COMMENT 'Identificador primario de la tabla asignadora de tokens',
    `user_id` varchar(100) NOT NULL COMMENT 'Llave foránea, identificadora del usuario',
    `token` varchar(64) NOT NULL COMMENT 'Código de autorización asignado al usuario para inicio de sesión ',
    `expires_at` datetime NOT NULL COMMENT 'Tiempo limite de sesión inactiva'
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

  --
  -- Volcado de datos para la tabla `reset_tokens`
  --

  INSERT INTO `reset_tokens` (`id`, `user_id`, `token`, `expires_at`) VALUES
  (1, 'svalenzuela073@misena.edu.co', 'nOziarwXx_2tuwV-bdS2KkNVIKmUdla--KqGRMiLvOQ', '2024-09-26 20:18:18'),
  (9, 'roger@gmail.com', 'V3fXbpYCyi9N6UENq927slsYuE-1qnQkyRDOFhh1Ijc', '2024-09-30 17:42:01'),
  (11, 'jeanpierrebbedoya@gmail.com', '8lEeVePJ8kTPL8c3Dh5q3bkFgK_c9CDhQ4l1lnOYjL4', '2024-09-30 18:27:25'),
  (12, 'jeanpierrebbedoya@gmail.com', '_fsaaORguSYKPUpu7maOQ9N-et8rf2jyW47Slh0nF6o', '2024-09-30 18:27:26'),
  (13, 'jeanpierrebbedoya@gmail.com', '8hXgsyq5dRLH6eNK6r33P89jQI-RSMjXuIktsTUYtyg', '2024-09-30 18:27:27'),
  (14, 'jeanpierrebbedoya@gmail.com', 'Nczjf677THxSwEFVmlnqDlu82vVrRW7I_Ws9GsoCz4A', '2024-09-30 18:27:28'),
  (16, 'jeanpierrebbedoya@gmail.com', '-wclB_XvcZ_GfYVbWT2j_5XyvrM0mQoTjkWVPZ103mg', '2024-09-30 18:27:28'),
  (17, 'jeanpierrebbedoya@gmail.com', 'WzyEGJnQg4is_Cd67DBy79lJswLIRO6ME-lEZYQa0qw', '2024-09-30 18:27:28'),
  (18, 'jeanpierrebbedoya@gmail.com', 'EINcjniG0nTGdVDmJ6sEddzH6b9gmlYMdCIwIOCctG0', '2024-09-30 18:27:28'),
  (19, 'santicardenash@gmail.com', '6TmXdNC3B6s8enFwO9RZJ_RaPtZwdkMWMaeQmA-ZW3M', '2024-12-08 16:13:26'),
  (21, 'mglnares2006@gmail.com', '6ZvxBqV6z6XrYyYKyw3j6YkEt47Pf-OeOfwmjv-fPtM', '2024-12-09 11:31:11');

  -- --------------------------------------------------------

  --
  -- Estructura de tabla para la tabla `reuniones`
  --

  CREATE TABLE `reuniones` (
    `idreu` int(11) NOT NULL COMMENT 'Identificador primario de la tabla reuniones',
    `fechavis` date DEFAULT NULL COMMENT 'Fecha asignada para la visita o reunión ',
    `horavis` time DEFAULT NULL COMMENT 'Hora asignada del encuentro programado'
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar información de reuniones';

  --
  -- Volcado de datos para la tabla `reuniones`
  --

  INSERT INTO `reuniones` (`idreu`, `fechavis`, `horavis`) VALUES
  (0, '2024-07-02', '11:44:22'),
  (2, '2024-07-01', '13:59:45'),
  (3, '2023-07-18', '15:00:01'),
  (4, '2024-07-16', '12:00:00');

  -- --------------------------------------------------------

  --
  -- Estructura de tabla para la tabla `roles`
  --

  CREATE TABLE `roles` (
    `idrol` int(11) NOT NULL COMMENT 'Identificador primario de la tabla roles',
    `descripcion` varchar(65) DEFAULT NULL COMMENT 'Nombre descriptivo de los roles'
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar roles de usuarios';

  --
  -- Volcado de datos para la tabla `roles`
  --

  INSERT INTO `roles` (`idrol`, `descripcion`) VALUES
  (1, 'Administrador'),
  (2, 'Development Team'),
  (3, 'Stakeholder');

  -- --------------------------------------------------------

  --
  -- Estructura de tabla para la tabla `sprints`
  --

  CREATE TABLE `sprints` (
    `idsprint` int(11) NOT NULL COMMENT 'Identificador primario de la tabla sprint',
    `fechaI` date DEFAULT NULL COMMENT 'Fecha de creación del sprint',
    `fechaF` date DEFAULT NULL COMMENT 'Fecha de finalización esperada del sprint',
    `nombre` varchar(100) DEFAULT NULL COMMENT 'Nombre del sprint',
    `descripcion` varchar(1000) DEFAULT NULL COMMENT 'Descripción breve de lo que se trabajará en el sprint',
    `estado` int(11) DEFAULT NULL COMMENT 'Etapa en la que se encuentra el sprint',
    `idproy` int(11) DEFAULT NULL COMMENT 'Llave foránea proveniente de la tabla proyectos'
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar sprints de proyectos';

  --
  -- Volcado de datos para la tabla `sprints`
  --

  INSERT INTO `sprints` (`idsprint`, `fechaI`, `fechaF`, `nombre`, `descripcion`, `estado`, `idproy`) VALUES
  (1, '2024-06-04', '2024-09-20', 'Análisis de Informac', 'Analizar e iniciar con la plan', 50, 33),
  (2, '2017-07-05', '2018-04-05', 'Modelos ', 'Elaborar todos los modelos req', 0, 28),
  (3, '2022-07-27', '2023-01-04', 'Modelos ', 'CU, MER, MC', 10, NULL),
  (4, '2024-07-17', '2024-10-27', 'MR', 'Realizar el Modelo Relacional', 0, 29),
  (5, '2024-01-08', '2024-08-21', 'IEEE-830', 'Desarrollo de la IEEE-830', 20, 27),
  (6, '2022-01-01', '2021-05-01', 'RF', 'Registrar o asignar requisitos', 5, 32),
  (7, '2023-07-11', '2023-11-14', 'RNF', 'Registrar o asignar requisitos', 14, 30),
  (8, '2016-07-12', '2018-07-23', 'MC', 'Realizar y asignar el modelo d', 0, 30),
  (9, '2023-10-09', '2024-04-18', 'IEEE-830', 'Elaboración de todos los ítems', 30, 27),
  (11, '2024-09-01', '2024-09-20', 'Sprint 1 - Análisis', 'Análisis detallado de los requisitos y planificación inicial', 0, 4),
  (12, '2018-03-15', '2018-04-05', 'Sprint 2 - Modelado', 'Creación de modelos estructurados y de datos', 0, 4),
  (13, '2022-12-10', '2023-01-04', 'Sprint 3 - Diseño', 'Diseño y elaboración de diagramas clave', 0, 4),
  (14, '2024-10-01', '2024-10-27', 'Sprint 4 - Base de Datos', 'Modelado relacional para la base de datos', 0, 4),
  (15, '2024-08-01', '2024-08-21', 'Sprint 5 - Requisitos', 'Definición y documentación de requisitos funcionales', 50, 4),
  (16, '2021-04-10', '2021-05-01', 'Sprint 6 - Documentación', 'Generación de documentación técnica y descriptiva', 0, 4),
  (17, '2023-10-20', '2023-11-14', 'Sprint 7 - Desarrollo', 'Implementación y desarrollo de funcionalidades', 0, 4),
  (18, '2018-07-01', '2018-07-23', 'Sprint 8 - Validación', 'Validación y pruebas de software', 100, 4),
  (19, '2024-03-30', '2024-04-18', 'Sprint 9 - Entrega Final', 'Entrega final y revisión del proyecto', 0, 4);

  -- --------------------------------------------------------

  --
  -- Estructura de tabla para la tabla `tareas`
  --

  CREATE TABLE `tareas` (
    `id_tar` int(11) NOT NULL COMMENT 'Identificador primario de la tabla tareas',
    `nombre` varchar(45) DEFAULT NULL COMMENT 'Nombre descriptivo de la tarea',
    `descripcion` varchar(500) NOT NULL COMMENT 'Comentario breve de lo que se debe realizar en la tarea asignada',
    `fechaLimite` date DEFAULT NULL COMMENT 'Plazo máximo para la finalización de la tarea',
    `idsprint` int(11) DEFAULT NULL COMMENT 'Llave foránea proveniente de la tabla sprint',
    `estado` varchar(15) NOT NULL COMMENT 'Se inserta el estado actual de la tarea',
    `prioridad` varchar(6) NOT NULL COMMENT 'Nivel de prioridad de la tarea (baja, media, alta)'
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar tareas de proyectos';

  --
  -- Volcado de datos para la tabla `tareas`
  --

  INSERT INTO `tareas` (`id_tar`, `nombre`, `descripcion`, `fechaLimite`, `idsprint`, `estado`, `prioridad`) VALUES
  (27, 'Modelos', 'Creación de modelos estructurados y de datos clave', '2018-04-05', 18, 'Completado', 'Alta'),
  (28, 'MR', 'Elaboración del modelo relacional para la base de datos', '2024-10-27', 15, 'Completado', 'Media'),
  (29, 'IEEE-830', 'Desarrollo de la documentación IEEE-830', '2024-08-21', 14, 'Pendiente', 'Baja'),
  (30, 'RF', 'Registro y asignación de requisitos funcionales', '2021-05-01', 14, 'Pendiente', 'Media'),
  (31, 'RNF', 'Registro y asignación de requisitos no funcionales', '2023-11-14', 15, 'Activo', 'Alta'),
  (32, 'MC', 'Creación y asignación del modelo de datos', '2018-07-23', 15, 'Evaluando', 'Media'),
  (33, 'IEEE-830', 'Elaboración de todos los ítems de la IEEE-830', '2024-04-18', 15, 'Completado', 'Baja');

  -- --------------------------------------------------------

  --
  -- Estructura de tabla para la tabla `tarea_asignaciones`
  --

  CREATE TABLE `tarea_asignaciones` (
    `id_asignacion` int(11) NOT NULL COMMENT 'Identificador primario',
    `id_tar` int(11) DEFAULT NULL COMMENT 'Llave foránea proveniente de la tabla tareas',
    `id_usu_proy` int(11) DEFAULT NULL COMMENT 'Llave foránea proveniente de la tercer tabla entre usuarios y proyectos'
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

  -- --------------------------------------------------------

  --
  -- Estructura de tabla para la tabla `usuarios`
  --

  CREATE TABLE `usuarios` (
    `email` varchar(100) NOT NULL COMMENT 'Identificador de la tabla usuarios',
    `tipodoc` varchar(11) DEFAULT NULL COMMENT 'Tipo de documento del usuario (ti, cc, cedula de extranjería, etc)',
    `documento` int(11) DEFAULT NULL COMMENT 'Número de identificación del usuario',
    `password` varbinary(255) DEFAULT NULL COMMENT 'Clave privada y única',
    `telefono` varchar(20) DEFAULT NULL COMMENT 'Número de contacto del usuario',
    `nombres` varchar(33) DEFAULT NULL COMMENT 'Nombre legal del usuario',
    `apellidos` varchar(33) DEFAULT NULL COMMENT 'Apellido legal del usuario',
    `foto` varchar(200) DEFAULT NULL COMMENT 'Imagen de perfil para reconocimiento del usuario',
    `idrol` int(11) DEFAULT NULL COMMENT 'Llave foránea proveniente de la tabla roles',
    `perfil` varchar(80) NOT NULL COMMENT 'Descripción de la función del usuario'
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar información de usuarios';

  --
  -- Volcado de datos para la tabla `usuarios`
  --

  INSERT INTO `usuarios` (`email`, `tipodoc`, `documento`, `password`, `telefono`, `nombres`, `apellidos`, `foto`, `idrol`, `perfil`) VALUES
  ('1012918020@ctjfr.edu.co', '', 0, 0x313031323931, NULL, 'Karol Andrea', 'Beltran Diaz', '', 2, ''),
  ('1023367786@ctjfr.edu.co', '', 0, 0x313032333336, NULL, 'Maria Camila', 'Puerto Guerrero', '', 2, ''),
  ('1028661442@gmail.com', '', 0, 0x333130373131, NULL, 'Emanuel Felipe', 'Rodriguez Ramirez', '', 1, ''),
  ('1029143097@ctjfr.edu.co', '', 0, 0x313032393134, NULL, 'Sebastian', 'Cardenas Hernandez', '', 2, ''),
  ('1033696558@ctjfr.edu.co', '', 0, 0x77656e646972, NULL, 'Wendi Vanessa', 'Russi Antolinez', '', 2, ''),
  ('1074811705@ctjfr.edu.co', '', 0, 0x313037343831, NULL, 'Keiner Jean Paul', 'Martínez Araujo', '', 2, ''),
  ('1127342346@ctjfr.edu.co', '', 0, 0x303130374d, NULL, 'Genesis Veronica', 'Sanabria Leon', '', 2, ''),
  ('1234juandavis@gmail.com', '', 0, 0x313032313637, NULL, 'Juan David', 'Diaz Muñoz', '', 2, ''),
  ('caroceron28@gmail.com', '', 0, 0x313031303137, NULL, 'Sharit Carolina', 'Ceron Varela', '', 2, ''),
  ('diego.lopezm0405@gmail.com', '', 0, 0x313031313230, NULL, 'Diego Esteban', 'López Melo', '', 2, ''),
  ('jeanpierrebbedoya@gmail.com', '', 0, 0xd431ca78f0d4d2b91343bdb5980b6afc, NULL, 'Jean Pierre', 'Bolaños Beodya', '', 2, ''),
  ('johanbenavides134@gmail.com', '', 0, 0x313233343536, NULL, 'Johan Steven', 'Benavides Sanchez', '', 2, ''),
  ('jssr217@gmail.com', '', 0, 0x4a75616e5369, NULL, 'Primer Nombre Juan', 'Primer Apellido Silva', '', 2, ''),
  ('juandaja2201@gmail.com', '', 0, 0x313233343536, NULL, 'Juan David', 'Jerez Amador', '', 2, ''),
  ('julia@gmail.com', 'cc', 0, 0x316632343264, '587821', 'Julia', 'Perez', '', NULL, 'cliente'),
  ('linaessofia33@gmail.com', '', 0, 0x736f6669616c, NULL, 'Laura Sofia', 'Linares Piñeros', '', 2, ''),
  ('majogalan2006@gmail.com', '', 0, 0xd32ecc5d0d8d4e0cb5c2d7bdfdbd8f84, NULL, 'María José', 'Romero Gómez', '', 1, ''),
  ('mglnares2006@gmail.com', '', 0, 0x63a13fe96e1005115b332d6a94a5f0de, NULL, 'Miguel Felipe', 'Linares Riaño', '', 2, ''),
  ('nicolasgiraldo1020@gmail.com', '', 0, 0x31303230, NULL, 'Nicolas Santiago', 'Giraldo Valencia', '', 2, ''),
  ('rocio123@gmail.com', 'cc', 0, 0x363835396639, '14568745', 'Rocio', 'Caceres', 'dfsdgfd', NULL, 'cliente'),
  ('roger@gmail.com', '', 0, 0x3234323731, '2147483647', 'Roger Steec', 'Fuentes Ramirez', '/ferrari-enzo-rojo_3840x2160_xtrafondos.com.jpg', 2, 'Diseñador'),
  ('rogerfuentes893@gmail.com', 'C.C.', 1011200831, 0xf1a26d813fd1b734af4e327e670502f3, NULL, NULL, NULL, NULL, 2, ''),
  ('santicardenash@gmail.com', '', 1029143096, 0x2538822c3012250e592a20d0d131d0bf, '3226432732', 'Santiago', 'Cárdenas Hernández', '/c59f9ad6da00a07b253d86a97c23d6d5 (1).jpg', 1, 'Desarrollador'),
  ('scardenashernandez620@gmail.com', 'C.C.', 123, 0x8ec073414a4bf813c6e294c2f3a42825, '3226432732', 'Santiago', 'Cardenas Hernandez', NULL, 2, ''),
  ('sebastianrm30yu@iclock.com', '', 0, 0x313233343536, NULL, 'Johann Sebastian', 'Rivero Martinez', '', 2, ''),
  ('smithcortes01@gmail.com', '', 0, 0x66616d696c69, NULL, 'Steveen Smith', 'Cortes Cardenas', '', 2, ''),
  ('soff24ia@gmail.com', '', 0, 0x31323334, NULL, 'Ana Sofia', 'Alarcon Santana', '', 2, ''),
  ('svalenzuela073@misena.edu.co', '', 0, 0x9b8427feb0e4826e362d3cdb096efc22, NULL, 'Shiuu', 'Valenzuela Penagos', '', 1, '');

  -- --------------------------------------------------------

  --
  -- Estructura de tabla para la tabla `usu_proy`
  --

  CREATE TABLE `usu_proy` (
    `id` int(11) NOT NULL COMMENT 'Identificador clave de la tercer tabla entre usuarios y proyectos',
    `idproy` int(11) DEFAULT NULL COMMENT 'Llave foránea proveniente de la tabla proyectos',
    `email` varchar(100) DEFAULT NULL COMMENT 'Llave foránea proveniente de la tabla usuarios',
    `Scrum Master` tinyint(4) NOT NULL COMMENT 'Identificador de el usuario Scrum Master',
    `stake` tinyint(4) NOT NULL,
    `Product_Owner` tinyint(4) NOT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla de relación entre usuarios y proyectos';

  --
  -- Volcado de datos para la tabla `usu_proy`
  --

  INSERT INTO `usu_proy` (`id`, `idproy`, `email`, `Scrum Master`, `stake`, `Product_Owner`) VALUES
  (1, 4, 'santicardenash@gmail.com', 0, 0, 0),
  (2, 4, 'majogalan2006@gmail.com', 0, 0, 0),
  (3, 4, 'svalenzuela073@misena.edu.co', 0, 0, 0),
  (4, 30, 'juandaja2201@gmail.com', 0, 0, 0),
  (5, 27, 'caroceron28@gmail.com', 0, 0, 0),
  (6, 27, 'jeanpierrebbedoya@gmail.com', 0, 0, 0),
  (7, 27, 'mglnares2006@gmail.com', 0, 0, 0),
  (8, 28, 'smithcortes01@gmail.com', 0, 0, 0),
  (9, 28, '1029143097@ctjfr.edu.co', 0, 0, 0),
  (10, 31, 'sebastianrm30yu@iclock.com', 0, 0, 0),
  (13, 33, 'nicolasgiraldo1020@gmail.com', 0, 0, 0),
  (14, 33, '1074811705@ctjfr.edu.co', 0, 0, 0),
  (15, 28, '1012918020@ctjfr.edu.co', 0, 0, 0),
  (16, 31, 'roger@gmail.com', 0, 0, 0),
  (17, 30, '1127342346@ctjfr.edu.co', 0, 0, 0),
  (18, 30, 'johanbenavides134@gmail.com', 0, 0, 0),
  (19, 29, 'soff24ia@gmail.com', 0, 0, 0),
  (20, 29, 'linaessofia33@gmail.com', 0, 0, 0),
  (21, 29, '1023367786@ctjfr.edu.co', 0, 0, 0),
  (28, 42, 'santicardenash@gmail.com', 1, 0, 0),
  (29, 43, 'santicardenash@gmail.com', 1, 0, 0),
  (30, 44, 'santicardenash@gmail.com', 1, 0, 0),
  (31, 48, 'scardenashernandez620@gmail.com', 0, 1, 0),
  (32, 49, 'scardenashernandez620@gmail.com', 0, 1, 0),
  (33, 50, 'scardenashernandez620@gmail.com', 0, 1, 0),
  (34, 51, 'scardenashernandez620@gmail.com', 0, 1, 0),
  (36, 40, '1023367786@ctjfr.edu.co', 0, 1, 0),
  (37, 40, 'mglnares2006@gmail.com', 0, 1, 0),
  (38, 31, '1028661442@gmail.com', 0, 1, 0),
  (39, 4, 'scardenashernandez620@gmail.com', 0, 1, 0);

  --
  -- Índices para tablas volcadas
  --

  --
  -- Indices de la tabla `checklists`
  --
  ALTER TABLE `checklists`
    ADD KEY `idproy` (`idproy`),
    ADD KEY `idmod` (`idmod`);

  --
  -- Indices de la tabla `modelos`
  --
  ALTER TABLE `modelos`
    ADD PRIMARY KEY (`idmod`);

  --
  -- Indices de la tabla `opiniones`
  --
  ALTER TABLE `opiniones`
    ADD PRIMARY KEY (`id_opi`),
    ADD KEY `email` (`email`),
    ADD KEY `tipo_opi` (`tipo_opi`);

  --
  -- Indices de la tabla `planes`
  --
  ALTER TABLE `planes`
    ADD PRIMARY KEY (`nomplan`);

  --
  -- Indices de la tabla `proyectos`
  --
  ALTER TABLE `proyectos`
    ADD PRIMARY KEY (`idproy`),
    ADD KEY `nomplan` (`nomplan`);

  --
  -- Indices de la tabla `proy_reu`
  --
  ALTER TABLE `proy_reu`
    ADD PRIMARY KEY (`form_proy_reu`),
    ADD KEY `idproy` (`idproy`),
    ADD KEY `idreu` (`idreu`);

  --
  -- Indices de la tabla `reset_tokens`
  --
  ALTER TABLE `reset_tokens`
    ADD PRIMARY KEY (`id`),
    ADD KEY `user_id` (`user_id`);

  --
  -- Indices de la tabla `reuniones`
  --
  ALTER TABLE `reuniones`
    ADD PRIMARY KEY (`idreu`);

  --
  -- Indices de la tabla `roles`
  --
  ALTER TABLE `roles`
    ADD PRIMARY KEY (`idrol`);

  --
  -- Indices de la tabla `sprints`
  --
  ALTER TABLE `sprints`
    ADD PRIMARY KEY (`idsprint`),
    ADD KEY `idproy` (`idproy`);

  --
  -- Indices de la tabla `tareas`
  --
  ALTER TABLE `tareas`
    ADD PRIMARY KEY (`id_tar`),
    ADD KEY `idsprint` (`idsprint`);

  --
  -- Indices de la tabla `tarea_asignaciones`
  --
  ALTER TABLE `tarea_asignaciones`
    ADD PRIMARY KEY (`id_asignacion`),
    ADD UNIQUE KEY `id_tar` (`id_tar`),
    ADD KEY `id_usu_proy` (`id_usu_proy`);

  --
  -- Indices de la tabla `usuarios`
  --
  ALTER TABLE `usuarios`
    ADD PRIMARY KEY (`email`),
    ADD KEY `idrol` (`idrol`);

  --
  -- Indices de la tabla `usu_proy`
  --
  ALTER TABLE `usu_proy`
    ADD PRIMARY KEY (`id`),
    ADD KEY `idproy` (`idproy`),
    ADD KEY `email` (`email`);

  --
  -- AUTO_INCREMENT de las tablas volcadas
  --

  --
  -- AUTO_INCREMENT de la tabla `opiniones`
  --
  ALTER TABLE `opiniones`
    MODIFY `id_opi` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador clave de tabla opiniones', AUTO_INCREMENT=7;

  --
  -- AUTO_INCREMENT de la tabla `proyectos`
  --
  ALTER TABLE `proyectos`
    MODIFY `idproy` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador primario de la tabla proyectos', AUTO_INCREMENT=52;

  --
  -- AUTO_INCREMENT de la tabla `reset_tokens`
  --
  ALTER TABLE `reset_tokens`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador primario de la tabla asignadora de tokens', AUTO_INCREMENT=23;

  --
  -- AUTO_INCREMENT de la tabla `sprints`
  --
  ALTER TABLE `sprints`
    MODIFY `idsprint` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador primario de la tabla sprint', AUTO_INCREMENT=20;

  --
  -- AUTO_INCREMENT de la tabla `tareas`
  --
  ALTER TABLE `tareas`
    MODIFY `id_tar` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador primario de la tabla tareas', AUTO_INCREMENT=37;

  --
  -- AUTO_INCREMENT de la tabla `tarea_asignaciones`
  --
  ALTER TABLE `tarea_asignaciones`
    MODIFY `id_asignacion` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador primario';

  --
  -- AUTO_INCREMENT de la tabla `usu_proy`
  --
  ALTER TABLE `usu_proy`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador clave de la tercer tabla entre usuarios y proyectos', AUTO_INCREMENT=40;

  --
  -- Restricciones para tablas volcadas
  --

  --
  -- Filtros para la tabla `checklists`
  --
  ALTER TABLE `checklists`
    ADD CONSTRAINT `checklists_ibfk_1` FOREIGN KEY (`idproy`) REFERENCES `proyectos` (`idproy`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `checklists_ibfk_2` FOREIGN KEY (`idmod`) REFERENCES `modelos` (`idmod`) ON DELETE CASCADE ON UPDATE CASCADE;

  --
  -- Filtros para la tabla `opiniones`
  --
  ALTER TABLE `opiniones`
    ADD CONSTRAINT `opiniones_ibfk_1` FOREIGN KEY (`email`) REFERENCES `usuarios` (`email`);

  --
  -- Filtros para la tabla `proyectos`
  --
  ALTER TABLE `proyectos`
    ADD CONSTRAINT `proyectos_ibfk_1` FOREIGN KEY (`nomplan`) REFERENCES `planes` (`nomplan`) ON DELETE CASCADE ON UPDATE CASCADE;

  --
  -- Filtros para la tabla `proy_reu`
  --
  ALTER TABLE `proy_reu`
    ADD CONSTRAINT `proy_reu_ibfk_1` FOREIGN KEY (`idproy`) REFERENCES `proyectos` (`idproy`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `proy_reu_ibfk_2` FOREIGN KEY (`idreu`) REFERENCES `reuniones` (`idreu`) ON DELETE CASCADE ON UPDATE CASCADE;

  --
  -- Filtros para la tabla `reset_tokens`
  --
  ALTER TABLE `reset_tokens`
    ADD CONSTRAINT `reset_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `usuarios` (`email`) ON DELETE CASCADE ON UPDATE CASCADE;

  --
  -- Filtros para la tabla `sprints`
  --
  ALTER TABLE `sprints`
    ADD CONSTRAINT `sprints_ibfk_1` FOREIGN KEY (`idproy`) REFERENCES `proyectos` (`idproy`) ON DELETE CASCADE ON UPDATE CASCADE;

  --
  -- Filtros para la tabla `tareas`
  --
  ALTER TABLE `tareas`
    ADD CONSTRAINT `tareas_ibfk_3` FOREIGN KEY (`idsprint`) REFERENCES `sprints` (`idsprint`) ON DELETE CASCADE ON UPDATE CASCADE;

  --
  -- Filtros para la tabla `tarea_asignaciones`
  --
  ALTER TABLE `tarea_asignaciones`
    ADD CONSTRAINT `tarea_asignaciones_ibfk_1` FOREIGN KEY (`id_tar`) REFERENCES `tareas` (`id_tar`),
    ADD CONSTRAINT `tarea_asignaciones_ibfk_2` FOREIGN KEY (`id_usu_proy`) REFERENCES `usu_proy` (`id`);

  --
  -- Filtros para la tabla `usuarios`
  --
  ALTER TABLE `usuarios`
    ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`idrol`) REFERENCES `roles` (`idrol`) ON DELETE CASCADE ON UPDATE CASCADE;

  --
  -- Filtros para la tabla `usu_proy`
  --
  ALTER TABLE `usu_proy`
    ADD CONSTRAINT `usu_proy_ibfk_1` FOREIGN KEY (`idproy`) REFERENCES `proyectos` (`idproy`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `usu_proy_ibfk_2` FOREIGN KEY (`email`) REFERENCES `usuarios` (`email`) ON DELETE CASCADE ON UPDATE CASCADE;
  COMMIT;

  /*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
  /*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
  /*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
