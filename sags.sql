-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-09-2024 a las 18:57:09
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

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
DROP PROCEDURE IF EXISTS `ActualizarUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarUsuario` (IN `p_email` VARCHAR(40), IN `p_nuevosdatos` VARCHAR(50))   BEGIN
    UPDATE usuarios
    SET datos = CONCAT(datos, p_nuevosdatos)
    WHERE email = p_email;
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

DROP PROCEDURE IF EXISTS `InsertarRequisito`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertarRequisito` (IN `p_nombre` VARCHAR(20), IN `p_descripcion` VARCHAR(50), IN `p_tipo_pri_req` VARCHAR(80), IN `p_tipo_req` VARCHAR(80))   BEGIN
    INSERT INTO requisitos (nombre, descripcion, tipo_pri_req, tipo_req)
    VALUES (p_nombre, p_descripcion, p_tipo_pri_req, p_tipo_req);
END$$

DROP PROCEDURE IF EXISTS `InsertarUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertarUsuario` (IN `p_email` VARCHAR(40), IN `p_tipodoc` VARCHAR(11), IN `p_documento` INT, IN `p_password` VARCHAR(6), IN `p_telefono` INT, IN `p_nombres` VARCHAR(33), IN `p_apellidos` VARCHAR(33), IN `p_foto` VARCHAR(50), IN `p_idrol` INT)   BEGIN
    INSERT INTO usuarios (email, tipodoc, documento, password, telefono, nombres, apellidos, foto, idrol)
    VALUES (p_email, p_tipodoc, p_documento, p_password, p_telefono, p_nombres, p_apellidos, p_foto, p_idrol);
END$$

--
-- Funciones
--
DROP FUNCTION IF EXISTS `ContarProyectos`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `ContarProyectos` () RETURNS INT(11)  BEGIN
    DECLARE num_proyectos INT;
    SELECT COUNT(*) INTO num_proyectos FROM proyectos;
    RETURN num_proyectos;
END$$

DROP FUNCTION IF EXISTS `desencriptar`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `desencriptar` (`password` VARBINARY(100)) RETURNS VARCHAR(40) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
DECLARE ClaveDesen varchar(40);
SET ClaveDesen = (SELECT CAST(AES_DECRYPT(password,'sena')
as varchar(40)));
RETURN ClaveDesen;
END$$

DROP FUNCTION IF EXISTS `encriptar`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `encriptar` (`password` VARCHAR(20)) RETURNS VARBINARY(100)  BEGIN
DECLARE ClaveEncri varbinary(100);
SET ClaveEncri = AES_ENCRYPT(password,'sena');
RETURN ClaveEncri;
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
CREATE DEFINER=`root`@`localhost` FUNCTION `ObtenerUsuario` (`p_email` VARCHAR(40)) RETURNS VARCHAR(100) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
    DECLARE usuario_email VARCHAR(100);
    SELECT CONCAT(email, ' - ', nombres, ' ', apellidos) INTO usuario_email
    FROM usuarios
    WHERE email = p_email;
    RETURN usuario_email;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `checklists`
--

DROP TABLE IF EXISTS `checklists`;
CREATE TABLE `checklists` (
  `idcheck` int(11) NOT NULL COMMENT 'Identificador único del checklist',
  `idmod` varchar(5) NOT NULL,
  `aprobacion` int(11) DEFAULT NULL COMMENT 'Indica si el checklist está aprobado',
  `archivo` blob DEFAULT NULL COMMENT 'Archivo adjunto al checklist',
  `fecha` date DEFAULT NULL COMMENT 'Fecha del checklist',
  `idproy` int(11) DEFAULT NULL COMMENT 'ID del proyecto asociado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar información de checklists';

--
-- Volcado de datos para la tabla `checklists`
--

INSERT INTO `checklists` (`idcheck`, `idmod`, `aprobacion`, `archivo`, `fecha`, `idproy`) VALUES
(1, 'CU', 0, '', '0000-00-00', 27),
(2, 'MC', 0, '', '0000-00-00', 27),
(3, 'MER', 0, '', '0000-00-00', 27),
(4, 'MO', 0, '', '0000-00-00', 27),
(5, 'MR', 0, '', '0000-00-00', 27),
(6, 'RQ', 0, '', '0000-00-00', 27),
(7, 'CU', 0, '', '0000-00-00', 4),
(8, 'MC', 0, '', '0000-00-00', 4),
(9, 'MER', 0, '', '0000-00-00', 4),
(10, 'MO', 0, '', '0000-00-00', 4),
(11, 'MR', 0, '', '0000-00-00', 4),
(12, 'RQ', 0, '', '0000-00-00', 4),
(13, 'CU', 0, '', '0000-00-00', 28),
(14, 'MC', 0, '', '0000-00-00', 28),
(15, 'MER', 0, '', '0000-00-00', 28),
(16, 'MO', 0, '', '0000-00-00', 28),
(17, 'MR', 0, '', '0000-00-00', 28),
(18, 'RQ', 0, '', '0000-00-00', 28),
(19, 'CU', 0, '', '0000-00-00', 29),
(20, 'MC', 0, '', '0000-00-00', 29),
(21, 'MER', 0, '', '0000-00-00', 29),
(22, 'MO', 0, '', '0000-00-00', 29),
(23, 'MR', 0, '', '0000-00-00', 29),
(24, 'RQ', 0, '', '0000-00-00', 29),
(25, 'CU', 0, '', '0000-00-00', 30),
(26, 'MC', 0, '', '0000-00-00', 30),
(27, 'MER', 0, '', '0000-00-00', 30),
(28, 'MO', 0, '', '0000-00-00', 30),
(29, 'MR', 0, '', '0000-00-00', 30),
(30, 'RQ', 0, '', '0000-00-00', 30),
(31, 'CU', 0, '', '0000-00-00', 31),
(32, 'MC', 0, '', '0000-00-00', 31),
(33, 'MER', 0, '', '0000-00-00', 31),
(34, 'MO', 0, '', '0000-00-00', 31),
(35, 'MR', 0, '', '0000-00-00', 31),
(36, 'RQ', 0, '', '0000-00-00', 31),
(37, 'CU', 0, '', '0000-00-00', 32),
(38, 'MC', 0, '', '0000-00-00', 32),
(39, 'MER', 0, '', '0000-00-00', 32),
(40, 'MO', 0, '', '0000-00-00', 32),
(41, 'MR', 0, '', '0000-00-00', 32),
(42, 'RQ', 0, '', '0000-00-00', 32),
(43, 'CU', 0, '', '0000-00-00', 33),
(44, 'MC', 0, '', '0000-00-00', 33),
(45, 'MER', 0, '', '0000-00-00', 33),
(46, 'MO', 0, '', '0000-00-00', 33),
(47, 'MR', 0, '', '0000-00-00', 33),
(48, 'RQ', 0, '', '0000-00-00', 33);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modelos`
--

DROP TABLE IF EXISTS `modelos`;
CREATE TABLE `modelos` (
  `idmod` varchar(5) NOT NULL COMMENT 'Identificador único del modelo',
  `nombre` varchar(35) DEFAULT NULL COMMENT 'Nombre del modelo',
  `descripcion` varchar(80) DEFAULT NULL COMMENT 'Descripción del modelo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar información de modelos';

--
-- Volcado de datos para la tabla `modelos`
--

INSERT INTO `modelos` (`idmod`, `nombre`, `descripcion`) VALUES
('CU', 'Documento Casos de U', 'Modelo y Diagrama Casos de Uso'),
('MC', 'Documento Diagrama d', 'Modelo de clases del sistema'),
('MER', 'Documento del modelo', 'Diagrama del modelo entidad re'),
('MO', 'Documento Diagrama d', 'Modelo de objetos del sistema'),
('MR', 'Documento del modelo', 'Diagrama del modelo relacional'),
('RQ', 'Documentos RF y RNF', 'Especificación de requisitos f');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `opiniones`
--

DROP TABLE IF EXISTS `opiniones`;
CREATE TABLE `opiniones` (
  `id_opi` int(11) NOT NULL,
  `opinion` varchar(1000) DEFAULT NULL,
  `calificacion` int(11) DEFAULT NULL,
  `tipo_opi` varchar(25) DEFAULT NULL,
  `email` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar opiniones de usuarios';

--
-- Volcado de datos para la tabla `opiniones`
--

INSERT INTO `opiniones` (`id_opi`, `opinion`, `calificacion`, `tipo_opi`, `email`) VALUES
(1, 'Mejorar las Opc', NULL, 'Petición ', 'majogalan2006@gmail.com'),
(2, 'Interfaz de Usu', NULL, 'Queja', 'diego.lopezm0405@gmail.com'),
(3, 'Optimizar el Re', NULL, 'Sugerencia', 'nicolasgiraldo1020@gmail.com'),
(4, 'Incorporar Noti', NULL, 'Sugerencia', 'linaessofia33@gmail.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planes`
--

DROP TABLE IF EXISTS `planes`;
CREATE TABLE `planes` (
  `nomplan` varchar(30) NOT NULL,
  `descripcion` varchar(50) DEFAULT NULL,
  `precio` int(11) DEFAULT NULL
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
CREATE TABLE `priori_req` (
  `tipo_pri_req` varchar(80) NOT NULL,
  `descripcion` varchar(350) DEFAULT NULL
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
CREATE TABLE `proyectos` (
  `idproy` int(11) NOT NULL,
  `nombre` varchar(55) DEFAULT NULL,
  `descripcion` varchar(700) DEFAULT NULL,
  `tipo` varchar(25) DEFAULT NULL,
  `fechaI` date DEFAULT NULL,
  `fechaF` date DEFAULT NULL,
  `linkform` varchar(200) DEFAULT NULL,
  `nomplan` varchar(55) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar información de proyectos';

--
-- Volcado de datos para la tabla `proyectos`
--

INSERT INTO `proyectos` (`idproy`, `nombre`, `descripcion`, `tipo`, `fechaI`, `fechaF`, `linkform`, `nomplan`) VALUES
(4, 'SIRS', 'El presente documento tiene como fin definir los requisitos funcionales y no funcionales para el desarrollo del aplicativo web (SIRS) con el fin de conocer sus fundamentos, sus bases y motivos de su surgimiento, creación o causas originarias.', 'Aplicativo Web', '2022-04-10', '0000-00-00', NULL, NULL),
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
CREATE TABLE `proy_reu` (
  `form_proy_reu` int(11) NOT NULL,
  `idproy` int(11) DEFAULT NULL,
  `idreu` int(11) DEFAULT NULL
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
CREATE TABLE `requisitos` (
  `idreq` int(11) NOT NULL,
  `nombre` varchar(30) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `tipo_pri_req` varchar(80) NOT NULL,
  `tipo_req` varchar(80) NOT NULL
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
CREATE TABLE `requisitos_proyectos` (
  `idreq` int(11) DEFAULT NULL,
  `idproy` int(11) DEFAULT NULL
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
-- Estructura de tabla para la tabla `reuniones`
--

DROP TABLE IF EXISTS `reuniones`;
CREATE TABLE `reuniones` (
  `idreu` int(11) NOT NULL,
  `fechavis` date DEFAULT NULL,
  `horavis` time DEFAULT NULL,
  `tipo_reu` varchar(25) NOT NULL
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
CREATE TABLE `roles` (
  `idrol` int(11) NOT NULL,
  `descripcion` varchar(65) DEFAULT NULL
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
CREATE TABLE `sprints` (
  `idsprint` int(11) NOT NULL,
  `fechaI` date DEFAULT NULL,
  `fechaF` date DEFAULT NULL,
  `nombre` varchar(40) DEFAULT NULL,
  `aobservaciones` varchar(300) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL,
  `idproy` int(11) DEFAULT NULL
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
CREATE TABLE `tareas` (
  `id_tar` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `descripcion` varchar(500) DEFAULT NULL,
  `idsprint` int(11) DEFAULT NULL,
  `usu_proy_id` int(11) NOT NULL
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
CREATE TABLE `tipos_opi` (
  `tipo_opi` varchar(15) NOT NULL
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
CREATE TABLE `tipos_req` (
  `tipo_req` varchar(80) NOT NULL,
  `descripcion` varchar(120) DEFAULT NULL
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
CREATE TABLE `tipos_reu` (
  `tipo_reu` varchar(35) NOT NULL
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
CREATE TABLE `ubicaciones` (
  `idubi` int(11) DEFAULT NULL,
  `ciudad` varchar(60) DEFAULT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `email` varchar(60) DEFAULT NULL
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
CREATE TABLE `usuarios` (
  `email` varchar(60) NOT NULL,
  `tipodoc` varchar(11) DEFAULT NULL,
  `documento` int(15) DEFAULT NULL,
  `password` varchar(20) DEFAULT NULL,
  `telefono` int(11) DEFAULT NULL,
  `nombres` varchar(33) DEFAULT NULL,
  `apellidos` varchar(33) DEFAULT NULL,
  `foto` varchar(200) DEFAULT NULL,
  `idrol` int(11) DEFAULT NULL,
  `perfil` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla para almacenar información de usuarios';

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`email`, `tipodoc`, `documento`, `password`, `telefono`, `nombres`, `apellidos`, `foto`, `idrol`, `perfil`) VALUES
('1012918020@ctjfr.edu.co', '', 0, '101291', NULL, 'Karol Andrea', 'Beltran Diaz', '', 3, ''),
('1023367786@ctjfr.edu.co', '', 0, '102336', NULL, 'Maria Camila', 'Puerto Guerrero', '', 3, ''),
('1028661442@gmail.com', '', 0, '310711', NULL, 'Emanuel Felipe', 'Rodriguez Ramirez', '', 1, ''),
('1029143097@ctjfr.edu.co', '', 0, '102914', NULL, 'Sebastian', 'Cardenas Hernandez', '', 3, ''),
('1033696558@ctjfr.edu.co', '', 0, 'wendir', NULL, 'Wendi Vanessa', 'Russi Antolinez', '', 3, ''),
('1074811705@ctjfr.edu.co', '', 0, '107481', NULL, 'Keiner Jean Paul', 'Martínez Araujo', '', 3, ''),
('1127342346@ctjfr.edu.co', '', 0, '0107M', NULL, 'Genesis Veronica', 'Sanabria Leon', '', 3, ''),
('1234juandavis@gmail.com', '', 0, '102167', NULL, 'Juan David', 'Diaz Muñoz', '', 3, ''),
('caroceron28@gmail.com', '', 0, '101017', NULL, 'Sharit Carolina', 'Ceron Varela', '', 3, ''),
('diego.lopezm0405@gmail.com', '', 0, '101120', NULL, 'Diego Esteban', 'López Melo', '', 3, ''),
('jeanpierrebbedoya@gmail.com', '', 0, '2023', NULL, 'Jean Pierre', 'Bolaños Beodya', '', 3, ''),
('johanbenavides134@gmail.com', '', 0, '123456', NULL, 'Johan Steven', 'Benavides Sanchez', '', 3, ''),
('jssr217@gmail.com', '', 0, 'JuanSi', NULL, 'Primer Nombre Juan', 'Primer Apellido Silva', '', 3, ''),
('juandaja2201@gmail.com', '', 0, '123456', NULL, 'Juan David', 'Jerez Amador', '', 3, ''),
('julia@gmail.com', 'cc', 0, '1f242d', 587821, 'Julia', 'Perez', '', NULL, 'cliente'),
('linaessofia33@gmail.com', '', 0, 'sofial', NULL, 'Laura Sofia', 'Linares Piñeros', '', 3, ''),
('majogalan2006@gmail.com', '', 0, 'majoga', NULL, 'María José', 'Romero Gómez', '', 1, ''),
('mglnares2006@gmail.com', '', 0, 'Pollo0', NULL, 'Miguel Felipe', 'Linares Riaño', '', 3, ''),
('nicolasgiraldo1020@gmail.com', '', 0, '1020', NULL, 'Nicolas Santiago', 'Giraldo Valencia', '', 3, ''),
('rocio123@gmail.com', 'cc', 0, '6859f9', 14568745, 'Rocio', 'Caceres', 'dfsdgfd', NULL, 'cliente'),
('roger@gmail.com', '', 0, '24271', 2147483647, 'Roger Steec', 'Fuentes Ramirez', '/ferrari-enzo-rojo_3840x2160_xtrafondos.com.jpg', 3, 'Diseñador'),
('santicardenash@gmail.com', '', 0, '2006', 2147483647, 'Santiago', 'Cárdenas Hernández', '/c59f9ad6da00a07b253d86a97c23d6d5 (1).jpg', 1, 'Desarrollador'),
('sebastianrm30yu@iclock.com', '', 0, '123456', NULL, 'Johann Sebastian', 'Rivero Martinez', '', 3, ''),
('shiuuvalenzuela@gmail.com', '', 0, '4200', NULL, 'Shiuu', 'Valenzuela Penagos', '', 1, ''),
('smithcortes01@gmail.com', '', 0, 'famili', NULL, 'Steveen Smith', 'Cortes Cardenas', '', 3, ''),
('soff24ia@gmail.com', '', 0, '1234', NULL, 'Ana Sofia', 'Alarcon Santana', '', 3, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usu_proy`
--

DROP TABLE IF EXISTS `usu_proy`;
CREATE TABLE `usu_proy` (
  `id` int(11) NOT NULL,
  `idproy` int(11) DEFAULT NULL,
  `email` varchar(60) DEFAULT NULL,
  `Product_Owner` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla de relación entre usuarios y proyectos';

--
-- Volcado de datos para la tabla `usu_proy`
--

INSERT INTO `usu_proy` (`id`, `idproy`, `email`, `Product_Owner`) VALUES
(1, 4, 'santicardenash@gmail.com', 1),
(2, 4, 'majogalan2006@gmail.com', 0),
(3, 4, 'shiuuvalenzuela@gmail.com', 0),
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
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `checklists`
--
ALTER TABLE `checklists`
  ADD PRIMARY KEY (`idcheck`),
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
  ADD KEY `tipo_opi` (`tipo_opi`),
  ADD KEY `email` (`email`);

--
-- Indices de la tabla `planes`
--
ALTER TABLE `planes`
  ADD PRIMARY KEY (`nomplan`);

--
-- Indices de la tabla `priori_req`
--
ALTER TABLE `priori_req`
  ADD PRIMARY KEY (`tipo_pri_req`);

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
-- Indices de la tabla `requisitos`
--
ALTER TABLE `requisitos`
  ADD PRIMARY KEY (`idreq`),
  ADD KEY `tipo_pri_req` (`tipo_pri_req`),
  ADD KEY `tipo_req` (`tipo_req`);

--
-- Indices de la tabla `requisitos_proyectos`
--
ALTER TABLE `requisitos_proyectos`
  ADD KEY `idreq` (`idreq`),
  ADD KEY `idproy` (`idproy`);

--
-- Indices de la tabla `reuniones`
--
ALTER TABLE `reuniones`
  ADD PRIMARY KEY (`idreu`),
  ADD KEY `tipo_reu` (`tipo_reu`);

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
  ADD KEY `idsprint` (`idsprint`),
  ADD KEY `usu_proy_id` (`usu_proy_id`);

--
-- Indices de la tabla `tipos_opi`
--
ALTER TABLE `tipos_opi`
  ADD PRIMARY KEY (`tipo_opi`);

--
-- Indices de la tabla `tipos_req`
--
ALTER TABLE `tipos_req`
  ADD PRIMARY KEY (`tipo_req`);

--
-- Indices de la tabla `tipos_reu`
--
ALTER TABLE `tipos_reu`
  ADD PRIMARY KEY (`tipo_reu`);

--
-- Indices de la tabla `ubicaciones`
--
ALTER TABLE `ubicaciones`
  ADD KEY `email` (`email`);

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
  ADD CONSTRAINT `opiniones_ibfk_1` FOREIGN KEY (`tipo_opi`) REFERENCES `tipos_opi` (`tipo_opi`),
  ADD CONSTRAINT `opiniones_ibfk_2` FOREIGN KEY (`email`) REFERENCES `usuarios` (`email`);

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
