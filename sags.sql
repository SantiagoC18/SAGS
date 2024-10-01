-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 01-10-2024 a las 03:05:53
-- Versión del servidor: 8.3.0
-- Versión de PHP: 8.2.18

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

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `ActualizarUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarUsuario` (IN `p_email` VARCHAR(40), IN `p_nuevosdatos` VARCHAR(50))   BEGIN
    UPDATE usuarios
    SET datos = CONCAT(datos, p_nuevosdatos)
    WHERE email = p_email;
END$$

DROP PROCEDURE IF EXISTS `Act_y_Reg_Proyectos`$$
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

DROP PROCEDURE IF EXISTS `Act_y_Reg_Usuarios`$$
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

DROP PROCEDURE IF EXISTS `Agregar_requisitos_a_proyecto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Agregar_requisitos_a_proyecto` (IN `p_id_proyecto` INT, IN `p_id_requisito` INT)   INSERT INTO requisitos_proyectos (idreq, idproy)
  VALUES (p_id_requisito, p_id_proyecto)$$

DROP PROCEDURE IF EXISTS `Asignar_usuario_a_proyecto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Asignar_usuario_a_proyecto` (IN `p_id_proyecto` INT, IN `et_id` INT(100))   BEGIN
  INSERT INTO usu_proy (idproy, id)
  VALUES (p_id_proyecto,et_id);
END$$

DROP PROCEDURE IF EXISTS `EliminarRequisitosProyecto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarRequisitosProyecto` (IN `p_idproy` INT)   BEGIN
    DELETE FROM requisitos_proyectos
    WHERE idproy = p_idproy;
END$$

DROP PROCEDURE IF EXISTS `EliminarUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarUsuario` (IN `p_email` VARCHAR(40))   BEGIN
    DELETE FROM usuarios
    WHERE email = p_email;
END$$

DROP PROCEDURE IF EXISTS `Eliminar_requisito_de_proyecto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Eliminar_requisito_de_proyecto` (IN `p_id_proyecto` INT, IN `p_id_requisito` INT)   BEGIN
  DELETE FROM requisitos_proyectos
  WHERE idreq = p_id_requisito AND idproy = p_id_proyecto;
END$$

DROP PROCEDURE IF EXISTS `Elim_y_Cons_Proyectos`$$
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

DROP PROCEDURE IF EXISTS `Elim_y_Cons_Requisitos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Elim_y_Cons_Requisitos` (IN `r_idreq` INT, IN `accion` VARCHAR(45))   BEGIN
 CASE
 WHEN accion='consultar' THEN
 SELECT * FROM requisitos WHERE r_idreq=idreq;
 WHEN accion='eliminar' THEN
 DELETE FROM requisitos WHERE r_idreq=idreq;
 END CASE;
END$$

DROP PROCEDURE IF EXISTS `Elim_y_Cons_Usuarios`$$
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

DROP PROCEDURE IF EXISTS `InsertarRequisito`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertarRequisito` (IN `p_nombre` VARCHAR(20), IN `p_descripcion` VARCHAR(50), IN `p_tipo_pri_req` VARCHAR(80), IN `p_tipo_req` VARCHAR(80))   BEGIN
    INSERT INTO requisitos (nombre, descripcion, tipo_pri_req, tipo_req)
    VALUES (p_nombre, p_descripcion, p_tipo_pri_req, p_tipo_req);
END$$

DROP PROCEDURE IF EXISTS `InsertarUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertarUsuario` (IN `p_email` VARCHAR(100), IN `p_tipodoc` VARCHAR(11), IN `p_documento` INT, IN `p_password` VARCHAR(6), IN `p_telefono` INT, IN `p_nombres` VARCHAR(33), IN `p_apellidos` VARCHAR(33), IN `p_foto` VARCHAR(50), IN `p_idrol` INT)   BEGIN
    INSERT INTO usuarios (email, tipodoc, documento, password, telefono, nombres, apellidos, foto, idrol)
    VALUES (p_email, p_tipodoc, p_documento, p_password, p_telefono, p_nombres, p_apellidos, p_foto, p_idrol);
END$$

DROP PROCEDURE IF EXISTS `Proyectos_asociados`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Proyectos_asociados` (IN `id_usuario` VARCHAR(40))   BEGIN
  SELECT p.idproy, p.nombre, p.descripcion
  FROM proyectos p
  INNER JOIN usu_proy up ON p.idproy = up.idproy
  INNER JOIN usuarios u ON up.email = u.email
  WHERE u.email = id_usuario;
END$$

DROP PROCEDURE IF EXISTS `Tareas_por_sprint`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Tareas_por_sprint` (IN `p_id_sprint` INT)   BEGIN
  SELECT t.id_tar, t.nombre, t.descripcion
  FROM tareas t
  WHERE t.idsprint = p_id_sprint;
END$$

--
-- Funciones
--
DROP FUNCTION IF EXISTS `#_De_Tareas_por_Sprint`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `#_De_Tareas_por_Sprint` (`p_idsprint` INT) RETURNS INT  BEGIN
    DECLARE numero_tareas INT;
    SELECT COUNT(*) INTO numero_tareas FROM tareas WHERE idsprint = p_idsprint;
    RETURN numero_tareas;
END$$

DROP FUNCTION IF EXISTS `ContarProyectos`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ContarProyectos` () RETURNS INT  BEGIN
    DECLARE num_proyectos INT;
    SELECT COUNT(*) INTO num_proyectos FROM proyectos;
    RETURN num_proyectos;
END$$

DROP FUNCTION IF EXISTS `encriptar`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `encriptar` (`password` VARCHAR(20)) RETURNS VARBINARY(100)  BEGIN
DECLARE ClaveEncri varbinary(100);
SET ClaveEncri = AES_ENCRYPT(password,'sena');
RETURN ClaveEncri;
END$$

DROP FUNCTION IF EXISTS `Nombre_del_Usuario`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `Nombre_del_Usuario` (`p_email` VARCHAR(100)) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE usuario_email VARCHAR(100);
    SELECT CONCAT(email, ' - ', nombres, ' ', apellidos) INTO usuario_email
    FROM usuarios
    WHERE email = p_email;
    RETURN usuario_email;
END$$

DROP FUNCTION IF EXISTS `Numero_de_Requisitos`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `Numero_de_Requisitos` (`p_idproy` INT) RETURNS INT  BEGIN
    DECLARE numero_requisitos INT;
    SELECT COUNT(*) INTO numero_requisitos FROM requisitos_proyectos WHERE idproy = p_idproy;
    RETURN numero_requisitos;
END$$

DROP FUNCTION IF EXISTS `ObtenerPrioridadRequisito`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ObtenerPrioridadRequisito` (`p_idreq` INT) RETURNS VARCHAR(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE prioridad_requisito VARCHAR(20);
    SELECT tipo_pri_req INTO prioridad_requisito
    FROM requisitos
    WHERE idreq = p_idreq;
    RETURN prioridad_requisito;
END$$

DROP FUNCTION IF EXISTS `ObtenerRequisitosProyecto`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ObtenerRequisitosProyecto` (`p_idproy` INT) RETURNS VARCHAR(200) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE requisitos_proyecto VARCHAR(200);
    SELECT GROUP_CONCAT(r.nombre SEPARATOR ', ') INTO requisitos_proyecto
    FROM requisitos r
    JOIN requisitos_proyectos rp ON r.idreq = rp.idreq
    WHERE rp.idproy = p_idproy;
    RETURN requisitos_proyecto;
END$$

DROP FUNCTION IF EXISTS `ObtenerTipoRequisito`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ObtenerTipoRequisito` (`p_idreq` INT) RETURNS VARCHAR(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE tipo_requisito VARCHAR(20);
    SELECT tipo_req INTO tipo_requisito
    FROM requisitos
    WHERE idreq = p_idreq;
    RETURN tipo_requisito;
END$$

DROP FUNCTION IF EXISTS `ObtenerUsuario`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ObtenerUsuario` (`p_email` VARCHAR(100)) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE usuario_email VARCHAR(100);
    SELECT CONCAT(email, ' - ', nombres, ' ', apellidos) INTO usuario_email
    FROM usuarios
    WHERE email = p_email;
    RETURN usuario_email;
END$$

DROP FUNCTION IF EXISTS `Prioridad_del_Requisito`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `Prioridad_del_Requisito` (`p_idreq` INT) RETURNS VARCHAR(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE prioridad_requisito VARCHAR(20);
    SELECT tipo_pri_req INTO prioridad_requisito
    FROM requisitos
    WHERE idreq = p_idreq;
    RETURN prioridad_requisito;
END$$

DROP FUNCTION IF EXISTS `Requisitos_del_Proyecto`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `Requisitos_del_Proyecto` (`p_idproy` INT) RETURNS VARCHAR(200) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE requisitos_proyecto VARCHAR(200);
    SELECT GROUP_CONCAT(r.nombre SEPARATOR ', ') INTO requisitos_proyecto
    FROM requisitos r
    JOIN requisitos_proyectos rp ON r.idreq = rp.idreq
    WHERE rp.idproy = p_idproy;
    RETURN requisitos_proyecto;
END$$

DROP FUNCTION IF EXISTS `Rol_Del_Usuario`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `Rol_Del_Usuario` (`p_email` VARCHAR(100)) RETURNS VARCHAR(65) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE rol_usuario VARCHAR(65);
    SELECT descripcion INTO rol_usuario FROM roles WHERE idrol = (SELECT idrol FROM usuarios WHERE email = p_email);
    RETURN rol_usuario;
END$$

DROP FUNCTION IF EXISTS `Tipo_de_Requisito`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `Tipo_de_Requisito` (`p_idreq` INT) RETURNS VARCHAR(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE tipo_requisito VARCHAR(20);
    SELECT tipo_req INTO tipo_requisito
    FROM requisitos
    WHERE idreq = p_idreq;
    RETURN tipo_requisito;
END$$

DROP FUNCTION IF EXISTS `Total_de_Proyectos`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `Total_de_Proyectos` () RETURNS INT  BEGIN
    DECLARE num_proyectos INT;
    SELECT COUNT(*) INTO num_proyectos FROM proyectos;
    RETURN num_proyectos;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `checklists`
--

DROP TABLE IF EXISTS `checklists`;
CREATE TABLE IF NOT EXISTS `checklists` (
  `idcheck` int NOT NULL COMMENT 'Identificador único del checklist',
  `idmod` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `aprobacion` int DEFAULT NULL COMMENT 'Indica si el checklist está aprobado',
  `archivo` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Archivo adjunto al checklist',
  `fecha` date DEFAULT NULL COMMENT 'Fecha del checklist',
  `progreso` int NOT NULL,
  `idproy` int DEFAULT NULL COMMENT 'ID del proyecto asociado',
  PRIMARY KEY (`idcheck`),
  KEY `idproy` (`idproy`),
  KEY `idmod` (`idmod`)
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
(8, 'MC', 0, '', '0000-00-00', 0, 4),
(9, 'MER', 0, '', '0000-00-00', 0, 4),
(11, 'MR', 0, '', '0000-00-00', 0, 4),
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
(48, 'RQ', 0, '', '0000-00-00', 0, 33);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modelos`
--

DROP TABLE IF EXISTS `modelos`;
CREATE TABLE IF NOT EXISTS `modelos` (
  `idmod` varchar(5) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Identificador único del modelo',
  `nombre` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Nombre del modelo',
  `descripcion` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Descripción del modelo',
  PRIMARY KEY (`idmod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar información de modelos';

--
-- Volcado de datos para la tabla `modelos`
--

INSERT INTO `modelos` (`idmod`, `nombre`, `descripcion`) VALUES
('CU', 'Documento Casos de Uso', 'Modelo y Diagrama Casos de Uso'),
('MC', 'Documento Diagrama de Clases', 'Modelo de clases del sistema'),
('MER', 'Documento del Modelo Entidad Relación', 'Diagrama del modelo entidad relación'),
('MO', 'Documento Diagrama de Objetos', 'Modelo de objetos del sistema'),
('MR', 'Documento del Modelo Relacional', 'Diagrama del modelo relacional'),
('RQ', 'Documentos RF y RNF (IEEE-830)', 'Especificación de requisitos funcionales y no funcionales');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `opiniones`
--

DROP TABLE IF EXISTS `opiniones`;
CREATE TABLE IF NOT EXISTS `opiniones` (
  `id_opi` int NOT NULL,
  `opinion` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `calificacion` int DEFAULT NULL,
  `tipo_opi` varchar(25) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_opi`),
  KEY `email` (`email`),
  KEY `tipo_opi` (`tipo_opi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar opiniones de usuarios';

--
-- Volcado de datos para la tabla `opiniones`
--

INSERT INTO `opiniones` (`id_opi`, `opinion`, `calificacion`, `tipo_opi`, `email`) VALUES
(0, 'Al intentar previsualizar algunos documentos PDF, noté que en ocasiones no se cargan correctamente o tardan demasiado en aparecer. Esto dificulta la revisión rápida de archivos, especialmente cuando necesito hacer comparaciones rápidas entre documentos.', 2, 'Queja', 'smithcortes01@gmail.com'),
(1, 'Sería muy útil que el sistema incluyera una funcionalidad para enviar notificaciones a los usuarios cuando un documento ha sido actualizado o aprobado por el administrador. Esto nos permitiría estar al tanto de los cambios sin necesidad de revisar constantemente la plataforma.', 4, 'Petición ', 'majogalan2006@gmail.com'),
(2, 'He notado que, al intentar cargar documentos de gran tamaño, el sistema tiende a ser un poco lento, lo que afecta la experiencia de usuario. Sería ideal optimizar la carga para archivos más pesados, ya que trabajamos con muchos documentos extensos.', 3, 'Queja', 'diego.lopezm0405@gmail.com'),
(3, 'Me gustaría sugerir que se integre una función de búsqueda avanzada, donde los usuarios puedan filtrar los documentos por fecha de creación, tipo de archivo o estado de aprobación. Esto haría mucho más eficiente la gestión y localización de documentos específicos.', 4, 'Sugerencia', 'nicolasgiraldo1020@gmail.com'),
(4, 'Sería excelente si el sistema permitiera colaborar en línea, es decir, que varios usuarios puedan realizar comentarios o editar ciertos documentos de forma colaborativa en tiempo real. Esto agilizaría el flujo de trabajo en proyectos donde varias personas necesitan revisar los mismos archivos.', 4, 'Sugerencia', 'linaessofia33@gmail.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planes`
--

DROP TABLE IF EXISTS `planes`;
CREATE TABLE IF NOT EXISTS `planes` (
  `nomplan` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `precio` int DEFAULT NULL,
  PRIMARY KEY (`nomplan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar planes disponibles';

--
-- Volcado de datos para la tabla `planes`
--

INSERT INTO `planes` (`nomplan`, `descripcion`, `precio`) VALUES
('BASIC', 'IEEE-830, ', 150000),
('PREMIUM', 'IEEE-830, ', 600000),
('STANDARD', 'IEEE-830, ', 300000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `priori_req`
--

DROP TABLE IF EXISTS `priori_req`;
CREATE TABLE IF NOT EXISTS `priori_req` (
  `tipo_pri_req` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` varchar(350) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`tipo_pri_req`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar prioridades de requisitos';

--
-- Volcado de datos para la tabla `priori_req`
--

INSERT INTO `priori_req` (`tipo_pri_req`, `descripcion`) VALUES
('Alta', 'Debe ser atendida inmediatamente, ya que impacta directamente la operatividad del sistema.'),
('Baja', 'Debe ser atendida si hay recursos y tiempo disponibles, mejorando la calidad general del sistema sin afectar su funcionalidad principal.'),
('Media', 'Debe ser atendida después de cubrir las necesidades críticas, enfocándose en mejorar la usabilidad y la eficiencia.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyectos`
--

DROP TABLE IF EXISTS `proyectos`;
CREATE TABLE IF NOT EXISTS `proyectos` (
  `idproy` int NOT NULL,
  `nombre` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descripcion` varchar(700) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fechaI` date DEFAULT NULL,
  `fechaF` date DEFAULT NULL,
  `linkform` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nomplan` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`idproy`),
  KEY `nomplan` (`nomplan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar información de proyectos';

--
-- Volcado de datos para la tabla `proyectos`
--

INSERT INTO `proyectos` (`idproy`, `nombre`, `descripcion`, `tipo`, `fechaI`, `fechaF`, `linkform`, `nomplan`) VALUES
(4, 'SAGS', 'El presente documento tiene como fin definir los requisitos funcionales y no funcionales para el desarrollo del aplicativo web (SIRS) con el fin de conocer sus fundamentos, sus bases y motivos de su surgimiento, creación o causas originarias.', 'Aplicativo Web', '2022-04-10', '0000-00-00', NULL, NULL),
(27, 'TOEXS', 'Para el desarrollo del proyecto se tiene como propósito definir y establecer los RF y RNF del aplicativo Web TOEXS, con un modelo cliente/servidor, que permita llevar a cabo procesos de comunicación, gestión e intercambio de juguetes online.', 'Aplicativo Web', '2023-08-24', '0000-00-00', NULL, NULL),
(28, 'GIET', 'El presente documento tiene como propósito definir las especificaciones funcionales y no funcionales que deberá cumplir el aplicativo web (GIET), el cual hará uso de las herramientas y prestaciones administrativas para la gestión de recursos informáticos, dirigido al uso de usuarios específicos y administradores del inventario de la institución educativa (CTJFR).', 'Aplicativo Web', '2022-02-01', '0000-00-00', NULL, NULL),
(29, 'SOFT_SPA', 'Tiene como propósito definir las especificaciones de requisitos funcionales y no funcionales para el desarrollo del aplicativo web (soft-spa).', 'Aplicativo Web', '2022-04-01', '0000-00-00', NULL, NULL),
(30, 'JOSE FELIX LIBRARY', 'El presente documento tiene como propósito definir las especificaciones de requisitos funcionales y no funcionales para el desarrollo de un sistema de información web modelo usuario/servidor, que permitirá sistematizar y gestionar los distintos materiales didácticos que se encuentran en la biblioteca del colegio JFR (libros, archivos, etc.), dirigido al desarrollo y análisis de nuevos proyectos.', 'Aplicativo Web', '2022-02-17', '0000-00-00', NULL, NULL),
(31, 'SIVOTU', 'El presente documento tiene como propósito definir las especificaciones de requisitos funcionales y no funcionales para el desarrollo de un aplicativo web (SIVOTU) modelo cliente servidor, que permita sistematizar y gestionar distintos procesos administrativos y servidor online de la tienda \"the shift urbans\" dirigido al uso de usuarios externos empleados y administradores.', 'Aplicativo Web', '2004-07-24', '0000-00-00', NULL, NULL),
(32, 'New Life', 'Brindar una herramienta que ayude a las entidades de salud mental a tratar profesionalmente a personas que fueron y son violentadas física y psicológicamente, así ayudándolos a progresar y tener un nuevo cambio en su vida social y personal.', 'Aplicativo Web', '2022-07-13', '0000-00-00', NULL, NULL),
(33, 'All Sport System', 'Gestionar ayudas y acceso a la comunidad de alternativas de ayuda profesional a través de consultas y terapias que se les brindan de acuerdo al diagnóstico que se le den a los pacientes o usuarios registrados en el aplicativo.', 'Aplicativo Web', '2022-05-10', '0000-00-00', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proy_reu`
--

DROP TABLE IF EXISTS `proy_reu`;
CREATE TABLE IF NOT EXISTS `proy_reu` (
  `form_proy_reu` int NOT NULL,
  `idproy` int DEFAULT NULL,
  `idreu` int DEFAULT NULL,
  PRIMARY KEY (`form_proy_reu`),
  KEY `idproy` (`idproy`),
  KEY `idreu` (`idreu`)
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
-- Estructura de tabla para la tabla `requisitos`
--

DROP TABLE IF EXISTS `requisitos`;
CREATE TABLE IF NOT EXISTS `requisitos` (
  `idreq` int NOT NULL,
  `nombre` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descripcion` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo_pri_req` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_req` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`idreq`),
  KEY `tipo_pri_req` (`tipo_pri_req`),
  KEY `tipo_req` (`tipo_req`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar requisitos de proyectos';

--
-- Volcado de datos para la tabla `requisitos`
--

INSERT INTO `requisitos` (`idreq`, `nombre`, `descripcion`, `tipo_pri_req`, `tipo_req`) VALUES
(1, 'Registrar Proyecto', 'Añadir nuevo proyecto al sistema', 'Alta', 'RF'),
(2, 'Registrar Usuario', 'Crear una nueva cuenta de usuario', 'Alta', 'RF'),
(3, 'Actualizar Usuario', ' Modificar datos del usuario', 'Alta', 'RF'),
(4, 'Actualizar Checklist', 'Revisar y modificar lista de tareas', 'Alta', 'RF'),
(5, 'Asignar Rol', 'Definir función del usuario', 'Alta', 'RF'),
(6, 'Rendimiento', ' Eficiencia y velocidad del sistema', 'Baja', 'RNF'),
(7, 'Adaptabilidad', 'Ajuste a nuevos requisitos', 'Media', 'RNF'),
(8, 'Mantenibilidad', 'Facilidad para mantener y actualizar', 'Baja', 'RNF'),
(9, 'Escalabilidad', 'Capacidad para crecer sin problemas', 'Media', 'RNF'),
(10, 'Iniciar sesión', 'Acceder a cuenta de usuario', 'Alta', 'RF');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `requisitos_proyectos`
--

DROP TABLE IF EXISTS `requisitos_proyectos`;
CREATE TABLE IF NOT EXISTS `requisitos_proyectos` (
  `idreq` int DEFAULT NULL,
  `idproy` int DEFAULT NULL,
  KEY `idreq` (`idreq`),
  KEY `idproy` (`idproy`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla de relación entre requisitos y proyectos';

--
-- Volcado de datos para la tabla `requisitos_proyectos`
--

INSERT INTO `requisitos_proyectos` (`idreq`, `idproy`) VALUES
(4, 4),
(3, 28),
(7, 30),
(5, 28),
(5, 30),
(5, 4),
(9, 32),
(10, 31),
(10, 30),
(10, 33),
(8, 31),
(1, 4),
(2, 29),
(2, 27),
(2, 33),
(2, 28),
(2, 31),
(2, 4),
(6, 27),
(3, 27);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reset_tokens`
--

DROP TABLE IF EXISTS `reset_tokens`;
CREATE TABLE IF NOT EXISTS `reset_tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `expires_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(18, 'jeanpierrebbedoya@gmail.com', 'EINcjniG0nTGdVDmJ6sEddzH6b9gmlYMdCIwIOCctG0', '2024-09-30 18:27:28');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reuniones`
--

DROP TABLE IF EXISTS `reuniones`;
CREATE TABLE IF NOT EXISTS `reuniones` (
  `idreu` int NOT NULL,
  `fechavis` date DEFAULT NULL,
  `horavis` time DEFAULT NULL,
  `tipo_reu` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`idreu`),
  KEY `tipo_reu` (`tipo_reu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar información de reuniones';

--
-- Volcado de datos para la tabla `reuniones`
--

INSERT INTO `reuniones` (`idreu`, `fechavis`, `horavis`, `tipo_reu`) VALUES
(0, '2024-07-02', '11:44:22', 'Presencial'),
(2, '2024-07-01', '13:59:45', 'Virtual'),
(3, '2023-07-18', '15:00:01', 'Virtual'),
(4, '2024-07-16', '12:00:00', 'Presencial');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `idrol` int NOT NULL,
  `descripcion` varchar(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`idrol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar roles de usuarios';

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`idrol`, `descripcion`) VALUES
(1, 'Administrador'),
(2, 'Scrum Master'),
(3, 'Development Tea'),
(4, 'Stakeholder');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sprints`
--

DROP TABLE IF EXISTS `sprints`;
CREATE TABLE IF NOT EXISTS `sprints` (
  `idsprint` int NOT NULL,
  `fechaI` date DEFAULT NULL,
  `fechaF` date DEFAULT NULL,
  `nombre` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `aobservaciones` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `estado` int DEFAULT NULL,
  `idproy` int DEFAULT NULL,
  PRIMARY KEY (`idsprint`),
  KEY `idproy` (`idproy`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar sprints de proyectos';

--
-- Volcado de datos para la tabla `sprints`
--

INSERT INTO `sprints` (`idsprint`, `fechaI`, `fechaF`, `nombre`, `aobservaciones`, `estado`, `idproy`) VALUES
(1, '2024-06-04', '2024-09-20', 'Análisis de Informac', 'Analizar e iniciar con la plan', 50, 33),
(2, '2017-07-05', '2018-04-05', 'Modelos ', 'Elaborar todos los modelos req', 0, 28),
(3, '2022-07-27', '2023-01-04', 'Modelos ', 'CU, MER, MC', 10, NULL),
(4, '2024-07-17', '2024-10-27', 'MR', 'Realizar el Modelo Relacional', 0, 29),
(5, '2024-01-08', '2024-08-21', 'IEEE-830', 'Desarrollo de la IEEE-830', 20, 27),
(6, '2022-01-01', '2021-05-01', 'RF', 'Registrar o asignar requisitos', 5, 32),
(7, '2023-07-11', '2023-11-14', 'RNF', 'Registrar o asignar requisitos', 14, 30),
(8, '2024-04-18', '2024-05-27', 'Análisis de Informac', 'Analizar e iniciar con la plan', 80, 4),
(9, '2016-07-12', '2018-07-23', 'MC', 'Realizar y asignar el modelo d', 0, 30),
(10, '2019-07-03', '2019-11-22', 'CU ', 'Realizar los casos de uso y ca', 3, 4),
(11, '2023-10-09', '2024-04-18', 'IEEE-830', 'Elaboración de todos los ítems', 30, 27);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tareas`
--

DROP TABLE IF EXISTS `tareas`;
CREATE TABLE IF NOT EXISTS `tareas` (
  `id_tar` int NOT NULL,
  `nombre` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descripcion` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `idsprint` int DEFAULT NULL,
  `usu_proy_id` int NOT NULL,
  PRIMARY KEY (`id_tar`),
  KEY `idsprint` (`idsprint`),
  KEY `usu_proy_id` (`usu_proy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar tareas de proyectos';

--
-- Volcado de datos para la tabla `tareas`
--

INSERT INTO `tareas` (`id_tar`, `nombre`, `descripcion`, `idsprint`, `usu_proy_id`) VALUES
(1, 'MER', ' Identificar entidades y sus relaciones', 3, 9),
(2, 'MR', ' Definir y documentar requisitos', 4, 1),
(3, 'MR', ' Definir y documentar requisitos', 4, 2),
(4, 'MR', ' Definir y documentar requisitos', 4, 3),
(5, 'IEEE-830', 'Documentar requisitos según el estándar', 5, 5),
(6, 'IEEE-830', 'Documentar requisitos según el estándar', 5, 6),
(7, 'Modelos', 'Crear diagramas del sistema', 2, 8),
(8, 'CU', 'Describir interacciones entre usuarios y el sistem', 10, 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_opi`
--

DROP TABLE IF EXISTS `tipos_opi`;
CREATE TABLE IF NOT EXISTS `tipos_opi` (
  `tipo_opi` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`tipo_opi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar tipos de opiniones';

--
-- Volcado de datos para la tabla `tipos_opi`
--

INSERT INTO `tipos_opi` (`tipo_opi`) VALUES
('Petición '),
('Queja'),
('Sugerencia');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_req`
--

DROP TABLE IF EXISTS `tipos_req`;
CREATE TABLE IF NOT EXISTS `tipos_req` (
  `tipo_req` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`tipo_req`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar tipos de requisitos';

--
-- Volcado de datos para la tabla `tipos_req`
--

INSERT INTO `tipos_req` (`tipo_req`, `descripcion`) VALUES
('RF', 'Los requisitos funcionales describen las funciones y comportamientos específicos que el sistema debe realizar. Son esenc'),
('RNF', 'Los requisitos no funcionales describen las características de calidad del sistema, como el rendimiento, la usabilidad, ');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_reu`
--

DROP TABLE IF EXISTS `tipos_reu`;
CREATE TABLE IF NOT EXISTS `tipos_reu` (
  `tipo_reu` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`tipo_reu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar tipos de reuniones';

--
-- Volcado de datos para la tabla `tipos_reu`
--

INSERT INTO `tipos_reu` (`tipo_reu`) VALUES
('Presencial'),
('Virtual');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ubicaciones`
--

DROP TABLE IF EXISTS `ubicaciones`;
CREATE TABLE IF NOT EXISTS `ubicaciones` (
  `idubi` int DEFAULT NULL,
  `ciudad` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `direccion` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar ubicaciones de usuarios';

--
-- Volcado de datos para la tabla `ubicaciones`
--

INSERT INTO `ubicaciones` (`idubi`, `ciudad`, `direccion`, `email`) VALUES
(42, 'Bogota', 'Calle 80', '1028661442@gmail.com'),
(54, 'Tolima', 'Transversal 50', 'linaessofia33@gmail.com'),
(2, 'Antioquia', 'Calle 2 #20', 'diego.lopezm0405@gmail.com'),
(21, 'Bogota', 'Calle 100', 'juandaja2201@gmail.com'),
(65, 'Medellin', 'Calle 18', 'nicolasgiraldo1020@gmail.com'),
(47, 'Bogota', 'Carrera 8 #110', 'roger@gmail.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE IF NOT EXISTS `usuarios` (
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipodoc` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `documento` int DEFAULT NULL,
  `password` varbinary(255) DEFAULT NULL,
  `telefono` int DEFAULT NULL,
  `nombres` varchar(33) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `apellidos` varchar(33) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `foto` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `idrol` int DEFAULT NULL,
  `perfil` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`email`),
  KEY `idrol` (`idrol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar información de usuarios';

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`email`, `tipodoc`, `documento`, `password`, `telefono`, `nombres`, `apellidos`, `foto`, `idrol`, `perfil`) VALUES
('1012918020@ctjfr.edu.co', '', 0, 0x313031323931, NULL, 'Karol Andrea', 'Beltran Diaz', '', 3, ''),
('1023367786@ctjfr.edu.co', '', 0, 0x313032333336, NULL, 'Maria Camila', 'Puerto Guerrero', '', 3, ''),
('1028661442@gmail.com', '', 0, 0x333130373131, NULL, 'Emanuel Felipe', 'Rodriguez Ramirez', '', 1, ''),
('1029143097@ctjfr.edu.co', '', 0, 0x313032393134, NULL, 'Sebastian', 'Cardenas Hernandez', '', 3, ''),
('1033696558@ctjfr.edu.co', '', 0, 0x77656e646972, NULL, 'Wendi Vanessa', 'Russi Antolinez', '', 3, ''),
('1074811705@ctjfr.edu.co', '', 0, 0x313037343831, NULL, 'Keiner Jean Paul', 'Martínez Araujo', '', 3, ''),
('1127342346@ctjfr.edu.co', '', 0, 0x303130374d, NULL, 'Genesis Veronica', 'Sanabria Leon', '', 3, ''),
('1234juandavis@gmail.com', '', 0, 0x313032313637, NULL, 'Juan David', 'Diaz Muñoz', '', 3, ''),
('caroceron28@gmail.com', '', 0, 0x313031303137, NULL, 'Sharit Carolina', 'Ceron Varela', '', 3, ''),
('diego.lopezm0405@gmail.com', '', 0, 0x313031313230, NULL, 'Diego Esteban', 'López Melo', '', 3, ''),
('jeanpierrebbedoya@gmail.com', '', 0, 0xd431ca78f0d4d2b91343bdb5980b6afc, NULL, 'Jean Pierre', 'Bolaños Beodya', '', 3, ''),
('johanbenavides134@gmail.com', '', 0, 0x313233343536, NULL, 'Johan Steven', 'Benavides Sanchez', '', 3, ''),
('jssr217@gmail.com', '', 0, 0x4a75616e5369, NULL, 'Primer Nombre Juan', 'Primer Apellido Silva', '', 3, ''),
('juandaja2201@gmail.com', '', 0, 0x313233343536, NULL, 'Juan David', 'Jerez Amador', '', 3, ''),
('julia@gmail.com', 'cc', 0, 0x316632343264, 587821, 'Julia', 'Perez', '', NULL, 'cliente'),
('linaessofia33@gmail.com', '', 0, 0x736f6669616c, NULL, 'Laura Sofia', 'Linares Piñeros', '', 3, ''),
('majogalan2006@gmail.com', '', 0, 0xd32ecc5d0d8d4e0cb5c2d7bdfdbd8f84, NULL, 'María José', 'Romero Gómez', '', 1, ''),
('mglnares2006@gmail.com', '', 0, 0x506f6c6c6f30, NULL, 'Miguel Felipe', 'Linares Riaño', '', 3, ''),
('nicolasgiraldo1020@gmail.com', '', 0, 0x31303230, NULL, 'Nicolas Santiago', 'Giraldo Valencia', '', 3, ''),
('rocio123@gmail.com', 'cc', 0, 0x363835396639, 14568745, 'Rocio', 'Caceres', 'dfsdgfd', NULL, 'cliente'),
('roger@gmail.com', '', 0, 0x3234323731, 2147483647, 'Roger Steec', 'Fuentes Ramirez', '/ferrari-enzo-rojo_3840x2160_xtrafondos.com.jpg', 3, 'Diseñador'),
('rogerfuentes893@gmail.com', 'C.C.', 1011200831, 0xf1a26d813fd1b734af4e327e670502f3, NULL, NULL, NULL, NULL, 3, ''),
('santicardenash@gmail.com', '', 0, 0x2538822c3012250e592a20d0d131d0bf, 2147483647, 'Santiago', 'Cárdenas Hernández', '/c59f9ad6da00a07b253d86a97c23d6d5 (1).jpg', 1, 'Desarrollador'),
('sebastianrm30yu@iclock.com', '', 0, 0x313233343536, NULL, 'Johann Sebastian', 'Rivero Martinez', '', 3, ''),
('smithcortes01@gmail.com', '', 0, 0x66616d696c69, NULL, 'Steveen Smith', 'Cortes Cardenas', '', 3, ''),
('soff24ia@gmail.com', '', 0, 0x31323334, NULL, 'Ana Sofia', 'Alarcon Santana', '', 3, ''),
('svalenzuela073@misena.edu.co', '', 0, 0x9b8427feb0e4826e362d3cdb096efc22, NULL, 'Shiuu', 'Valenzuela Penagos', '', 1, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usu_proy`
--

DROP TABLE IF EXISTS `usu_proy`;
CREATE TABLE IF NOT EXISTS `usu_proy` (
  `id` int NOT NULL,
  `idproy` int DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Product_Owner` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idproy` (`idproy`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla de relación entre usuarios y proyectos';

--
-- Volcado de datos para la tabla `usu_proy`
--

INSERT INTO `usu_proy` (`id`, `idproy`, `email`, `Product_Owner`) VALUES
(1, 4, 'santicardenash@gmail.com', 1),
(2, 4, 'majogalan2006@gmail.com', 0),
(3, 4, 'svalenzuela073@misena.edu.co', 0),
(4, 30, 'juandaja2201@gmail.com', 0),
(5, 27, 'caroceron28@gmail.com', 0),
(6, 27, 'jeanpierrebbedoya@gmail.com', 0),
(7, 27, 'mglnares2006@gmail.com', 0),
(8, 28, 'smithcortes01@gmail.com', 0),
(9, 28, '1029143097@ctjfr.edu.co', 0),
(10, 31, 'sebastianrm30yu@iclock.com', 0),
(12, 31, '1028661442@gmail.com', 0),
(13, 33, 'nicolasgiraldo1020@gmail.com', 0),
(14, 33, '1074811705@ctjfr.edu.co', 0),
(15, 28, '1012918020@ctjfr.edu.co', 0),
(16, 31, 'roger@gmail.com', 0),
(17, 30, '1127342346@ctjfr.edu.co', 0),
(18, 30, 'johanbenavides134@gmail.com', 0),
(19, 29, 'soff24ia@gmail.com', 0),
(20, 29, 'linaessofia33@gmail.com', 0),
(21, 29, '1023367786@ctjfr.edu.co', 0);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `checklists`
--
ALTER TABLE `checklists`
  ADD CONSTRAINT `checklists_ibfk_1` FOREIGN KEY (`idproy`) REFERENCES `proyectos` (`idproy`),
  ADD CONSTRAINT `checklists_ibfk_2` FOREIGN KEY (`idmod`) REFERENCES `modelos` (`idmod`);

--
-- Filtros para la tabla `opiniones`
--
ALTER TABLE `opiniones`
  ADD CONSTRAINT `opiniones_ibfk_1` FOREIGN KEY (`email`) REFERENCES `usuarios` (`email`),
  ADD CONSTRAINT `opiniones_ibfk_2` FOREIGN KEY (`tipo_opi`) REFERENCES `tipos_opi` (`tipo_opi`);

--
-- Filtros para la tabla `proyectos`
--
ALTER TABLE `proyectos`
  ADD CONSTRAINT `proyectos_ibfk_1` FOREIGN KEY (`nomplan`) REFERENCES `planes` (`nomplan`);

--
-- Filtros para la tabla `proy_reu`
--
ALTER TABLE `proy_reu`
  ADD CONSTRAINT `proy_reu_ibfk_1` FOREIGN KEY (`idproy`) REFERENCES `proyectos` (`idproy`),
  ADD CONSTRAINT `proy_reu_ibfk_2` FOREIGN KEY (`idreu`) REFERENCES `reuniones` (`idreu`);

--
-- Filtros para la tabla `requisitos`
--
ALTER TABLE `requisitos`
  ADD CONSTRAINT `requisitos_ibfk_1` FOREIGN KEY (`tipo_pri_req`) REFERENCES `priori_req` (`tipo_pri_req`),
  ADD CONSTRAINT `requisitos_ibfk_2` FOREIGN KEY (`tipo_req`) REFERENCES `tipos_req` (`tipo_req`);

--
-- Filtros para la tabla `requisitos_proyectos`
--
ALTER TABLE `requisitos_proyectos`
  ADD CONSTRAINT `requisitos_proyectos_ibfk_1` FOREIGN KEY (`idreq`) REFERENCES `requisitos` (`idreq`),
  ADD CONSTRAINT `requisitos_proyectos_ibfk_2` FOREIGN KEY (`idproy`) REFERENCES `proyectos` (`idproy`);

--
-- Filtros para la tabla `reset_tokens`
--
ALTER TABLE `reset_tokens`
  ADD CONSTRAINT `reset_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `usuarios` (`email`) ON DELETE CASCADE;

--
-- Filtros para la tabla `reuniones`
--
ALTER TABLE `reuniones`
  ADD CONSTRAINT `reuniones_ibfk_1` FOREIGN KEY (`tipo_reu`) REFERENCES `tipos_reu` (`tipo_reu`);

--
-- Filtros para la tabla `sprints`
--
ALTER TABLE `sprints`
  ADD CONSTRAINT `sprints_ibfk_1` FOREIGN KEY (`idproy`) REFERENCES `proyectos` (`idproy`);

--
-- Filtros para la tabla `tareas`
--
ALTER TABLE `tareas`
  ADD CONSTRAINT `tareas_ibfk_1` FOREIGN KEY (`idsprint`) REFERENCES `sprints` (`idsprint`),
  ADD CONSTRAINT `tareas_ibfk_2` FOREIGN KEY (`usu_proy_id`) REFERENCES `usu_proy` (`id`);

--
-- Filtros para la tabla `ubicaciones`
--
ALTER TABLE `ubicaciones`
  ADD CONSTRAINT `ubicaciones_ibfk_1` FOREIGN KEY (`email`) REFERENCES `usuarios` (`email`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`idrol`) REFERENCES `roles` (`idrol`);

--
-- Filtros para la tabla `usu_proy`
--
ALTER TABLE `usu_proy`
  ADD CONSTRAINT `usu_proy_ibfk_1` FOREIGN KEY (`idproy`) REFERENCES `proyectos` (`idproy`),
  ADD CONSTRAINT `usu_proy_ibfk_2` FOREIGN KEY (`email`) REFERENCES `usuarios` (`email`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
