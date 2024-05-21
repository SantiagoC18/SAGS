-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 02-04-2024 a las 00:13:54
-- Versión del servidor: 8.0.31
-- Versión de PHP: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sirs`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `checklist`
--

DROP TABLE IF EXISTS `checklist`;
CREATE TABLE IF NOT EXISTS `checklist` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'Llave primaria que identifica la tabla Checklist.\r\n',
  `id_doc1` varchar(50) NOT NULL COMMENT '	Es la llave foránea que conecta dos tablas.',
  `aprobacion` tinyint NOT NULL COMMENT 'Dependiendo el estado del documento cargado que cumpla con los requisitos requeridos.',
  `archivo` blob NOT NULL,
  `fecha` date NOT NULL,
  `id_proyecto1` int NOT NULL COMMENT 'Es la llave foránea que conecta dos tablas.',
  PRIMARY KEY (`id`),
  KEY `checklist1` (`id_doc1`) USING BTREE,
  KEY `Id_Proyectos1` (`id_proyecto1`) USING BTREE
);

--
-- Volcado de datos para la tabla `checklist`
--

INSERT INTO `checklist` (`id`, `id_doc1`, `aprobacion`, `archivo`, `fecha`, `id_proyecto1`) VALUES
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
-- Estructura de tabla para la tabla `documentos`
--

DROP TABLE IF EXISTS `documentos`;
CREATE TABLE IF NOT EXISTS `documentos` (
  `id_doc` varchar(50) NOT NULL,
  `nom_doc` varchar(100) DEFAULT NULL COMMENT 'Nombre del archivo, según el ítem al que corresponda.',
  `des_doc` varchar(100) DEFAULT NULL COMMENT 'Breve descripción sobre el documento correspondiente a cada ítem.',
  PRIMARY KEY (`id_doc`)
);

--
-- Volcado de datos para la tabla `documentos`
--

INSERT INTO `documentos` (`id_doc`, `nom_doc`, `des_doc`) VALUES
('CU', 'Documento Casos de Uso', 'Modelo y Diagrama Casos de Uso'),
('MC', 'Documento Diagrama de Clases', 'Modelo de clases del sistema'),
('MER', 'Documento del modelo entidad relación', 'Diagrama del modelo entidad relación '),
('MO', 'Documento Diagrama de Objetos', 'Modelo de objetos del sistema'),
('MR', 'Documento del modelo relacional ', 'Diagrama del modelo relacional '),
('RQ', 'Documentos RF y RNF', 'Especificación de requisitos funcionales y no funcionales del sistema');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pqrs`
--

DROP TABLE IF EXISTS `pqrs`;
CREATE TABLE IF NOT EXISTS `pqrs` (
  `id_pqrs` int NOT NULL AUTO_INCREMENT COMMENT 'es la llave primaria de la tabla pqrs\r\n',
  `fecha` date NOT NULL COMMENT 'fecha en la que se registra el pqrs',
  `tipo` varchar(100) NOT NULL COMMENT 'tipo de pqrs',
  `descripcion` varchar(5000) NOT NULL COMMENT 'breve explicación del pqrs',
  `id_usuario1` int NOT NULL COMMENT 'es una llave foranea',
  PRIMARY KEY (`id_pqrs`),
  KEY `pqrs_ibfk_1` (`id_usuario1`)
);

--
-- Volcado de datos para la tabla `pqrs`
--

INSERT INTO `pqrs` (`id_pqrs`, `fecha`, `tipo`, `descripcion`, `id_usuario1`) VALUES
(5, '2023-09-07', 'Sugerencia', 'diseño', 1029143096),
(6, '2023-09-16', 'Peticion', 'desarrollar modulo de sprints', 1029143096),
(7, '2023-09-16', 'Peticion', 'desarrollar modulo de sprints', 1029143096);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyectos`
--

DROP TABLE IF EXISTS `proyectos`;
CREATE TABLE IF NOT EXISTS `proyectos` (
  `id_proyecto` int NOT NULL AUTO_INCREMENT COMMENT 'Es la llave primaria que identifica a la tabla proyectos.',
  `nombre_proyecto` varchar(100) NOT NULL COMMENT 'Nombre del proyecto asignado por su creador.',
  `nombre_creador` varchar(50) NOT NULL COMMENT 'Nombre del creador o empresa del proyecto.',
  `tipo` varchar(50) NOT NULL COMMENT 'tipo de proyecto',
  `fechai` date DEFAULT NULL COMMENT 'Fecha del registro del proyecto.',
  `fechafin` date DEFAULT NULL COMMENT 'Fecha de finalización y entrega del proyecto.',
  `proposito` varchar(400) NOT NULL COMMENT 'Definición por parte del usuario con rol #3 sobre las razones por las que quiere crear el proyecto.',
  `alcance` varchar(400) NOT NULL COMMENT 'Definición por parte del usuario con rol #3 sobre sus objetivos del proyecto al futuro.',
  PRIMARY KEY (`id_proyecto`)
);

--
-- Volcado de datos para la tabla `proyectos`
--

INSERT INTO `proyectos` (`id_proyecto`, `nombre_proyecto`, `nombre_creador`, `tipo`, `fechai`, `fechafin`, `proposito`, `alcance`) VALUES
(4, 'SIRS', 'A.S.', 'Alpicativo Web', '2022-04-10', '0000-00-00', 'El presente documento tiene como fin definir los requisitos funcionales y no funcionales para el desarrollo del aplicativo web (SIRS) con el fin de conocer sus fundamentos, sus bases y motivos de su surgimiento, creación o causas originarias.', '(SIRS) Es un aplicativo web dirigido a  agencias de desarrollo y/o programadores freelance con el ánimo de optimizar el diseño e  implementación  de  proyectos   software  a  través de la  sistematización  dinámica  y  específica  de  los   (SRS)  de  proyectos  a medida. Permitiendo (consultar, registrar, actualizar, etc.), cualquier tipo de información o datos del usuario y del aplicativo.'),
(27, 'TOEXS', 'DEVSO', 'Alpicativo Web', '2023-08-24', '0000-00-00', 'Para el desarrollo del proyecto se tiene como propósito definir y establecer los RF y RNF del aplicativo Web TOEXS,  con un modelo cliente/servidor, que permita llevar a cabo procesos de comunicación, gestion e intercambio de juguetes online.', 'Esta especificación de requisitos de software TOEXS está dirigida a usuarios externos, con el fin de implementar y desarrollar la automatización de procesos y gestion de intercambio de juguetes online, para garantizar (intercambios, registros, comunicación, consultas, compras y ventas).'),
(28, 'GIET', 'Software Solutions KSS', 'Alpicativo Web', '2022-02-01', '0000-00-00', 'El presente documento tiene como propósito definir las especificaciones funcionales y no funcionales que deberá cumplir el aplicativo web (GIET), el cual hará uso de las herramientas y prestaciones administrativas para la gestión de recursos informáticos, dirigido al uso de usuarios específicos y administradores del inventario de la institución educativa (CTJFR).', 'El proyecto GIET tiene por objetivo desarrollar un aplicativo web que contará con funciones administrativas y de gestión (registros, usos, prestamos, mantenimiento de los equipos e inventario, sustitución, reportes, usuarios) con el fin de facilitar y sistematizar el manejo de recursos informáticos de la institución (CTJFR.)'),
(29, 'SOFT_SPA', 'ADDSE', 'Alpicativo Web', '2022-04-01', '0000-00-00', 'Tiene como propósito definir las especificaciones de requisitos funcionales y no funcionales para el desarrollo del aplicativo web (soft-spa).', 'Especificaciones de requisitos del aplicativo web (soft-spa) esta dirigida al usuario del sistema, tiene por objetivo principal  gestionar los distintos procesos administrativos.'),
(30, 'JOSE  FELIX LIBRARY', 'PARADOXSOFTWARE', 'Alpicativo Web', '2022-02-17', '0000-00-00', 'El presente documento tiene como propósito definir las especificaciones de requisitos funcionales y no funcionales para el desarrollo de un sistema de información web modelo usuario/servidor, que permitirá sistematizar y gestionar los distintos materiales didácticos que se encuentran en la biblioteca del colegio JFR (libros, archivos, etc.), dirigido al desarrollo y análisis de nuevos proyectos, d', 'Aplicativo dirigido a empresas desarrolladoras de software y/o desarrolladores freelance, aportando colectivamente al desarrollo y análisis de nuevos proyectos, de forma rápida y eficaz '),
(31, 'SIVOTU', 'Sociedad del Ojo Segado', 'Alpicativo Web', '2004-07-24', '0000-00-00', 'El presente documento tiene como propÃ³sito definir las especificaciones de requisitos funcionales y no funcionales para el desarrollo de un aplicativo web (SIVOTU) modelo cliente servidor, que permita sistematizar y gestionar distintos procesos administrativos y servidor online de la tienda \"the shift urbans\" dirigido al uso de usuarios externos empleados y administradores,', 'Esta especificaciÃ³n de requerimientos estÃ¡ dirigida al usuario del sistema, con el fin de desarrollar el aplicativo web the shift urbans  profundizando en la automatizaciÃ³n de procesos y manejo de la informaciÃ³n la cual tiene como objeto principal el gestionar los distintos procesos administrativos: (control, actualizaciÃ³n y cancelaciÃ³n) y servicios (registros, catÃ¡logos, pagos online, rese'),
(32, 'New Life', 'Newlifee', 'Alpicativo Web', '2022-07-13', '0000-00-00', 'Brindar una herramienta quÃ© ayude a las entidades de salud mental a tratar profesionalmente a personas que fueron y son violentadas fÃ­sica y psicolÃ³gicamente, asÃ­ ayudandolos a progresar y tener un nuevo cambio en su vida social y personal.', 'Gestionar ayudas y acceso a la comunidad de alternativas de ayuda profesional a travÃ©s de consultas y terapias que se les brindadas de acuerdo al diagnÃ³stico que se le den a los pacientes o usuarios registrados en el aplicativo.'),
(33, 'All Sport System ', 'Tps Sport', 'Alpicativo Web', '2022-05-10', '0000-00-00', '', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `p_i`
--

DROP TABLE IF EXISTS `p_i`;
CREATE TABLE IF NOT EXISTS `p_i` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_usuario1` int NOT NULL COMMENT '	Es la llave foránea que conecta dos tablas.',
  `id_proyecto1` int NOT NULL COMMENT '	Es la llave foránea que conecta dos tablas.',
  PRIMARY KEY (`id`),
  KEY `p_i_ibfk_2` (`id_proyecto1`),
  KEY `p_i_ibfk_3` (`id_usuario1`)
);

--
-- Volcado de datos para la tabla `p_i`
--

INSERT INTO `p_i` (`id`, `id_usuario1`, `id_proyecto1`) VALUES
(1, 1029143096, 4),
(2, 1074088080, 4),
(3, 1012918370, 4),
(4, 1099203581, 30),
(5, 1010176763, 27),
(6, 1032678992, 27),
(7, 1021397427, 27),
(8, 1021312836, 28),
(9, 1029143097, 28),
(10, 1021664834, 31),
(12, 1028661442, 31),
(13, 1029144548, 33),
(14, 1074811705, 33),
(15, 1012918020, 28),
(16, 1011200831, 31),
(17, 1127342346, 30),
(18, 1070593041, 30),
(19, 1025323335, 29),
(20, 1031804394, 29),
(21, 1023367786, 29);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reg_req`
--

DROP TABLE IF EXISTS `reg_req`;
CREATE TABLE IF NOT EXISTS `reg_req` (
  `ref_rq` int NOT NULL AUTO_INCREMENT,
  `cod_r1` int NOT NULL,
  `id_proyecto1` int NOT NULL,
  PRIMARY KEY (`ref_rq`),
  KEY `cod_r` (`cod_r1`),
  KEY `id_proyecto` (`id_proyecto1`),
  KEY `cod_r1` (`cod_r1`)
);

--
-- Volcado de datos para la tabla `reg_req`
--

INSERT INTO `reg_req` (`ref_rq`, `cod_r1`, `id_proyecto1`) VALUES
(15, 14, 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `requisitos`
--

DROP TABLE IF EXISTS `requisitos`;
CREATE TABLE IF NOT EXISTS `requisitos` (
  `cod_r` int NOT NULL AUTO_INCREMENT COMMENT 'Es la llave primaria que identifica a la tabla requisitos.',
  `nombre` varchar(50) NOT NULL COMMENT 'Nombre del Requisito Funcional o No Funcional correspondiente.',
  `tipo` varchar(10) NOT NULL COMMENT 'Tipo de requisito (Funcional o No Funcional).',
  `importancia` varchar(50) NOT NULL COMMENT 'Nivel de importancia del Requisito.',
  `descripcion` varchar(70) NOT NULL COMMENT 'Breve descripción sobre la funcionalidad del requisito.',
  PRIMARY KEY (`cod_r`)
);

--
-- Volcado de datos para la tabla `requisitos`
--

INSERT INTO `requisitos` (`cod_r`, `nombre`, `tipo`, `importancia`, `descripcion`) VALUES
(14, 'iniciar sesion', 'RF', 'Alta', 'se registrará al usuario en la página');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `cod_rol` int NOT NULL COMMENT 'Llave primaria que identifica la tabla roles.',
  `nombre_rol` varchar(30) NOT NULL COMMENT 'Nombre del rol establecido a cada usuario.',
  PRIMARY KEY (`cod_rol`)
);

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`cod_rol`, `nombre_rol`) VALUES
(1, 'Sofisticado'),
(2, 'Aficionado'),
(3, 'Secundario');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sprints`
--

DROP TABLE IF EXISTS `sprints`;
CREATE TABLE IF NOT EXISTS `sprints` (
  `id_sp` int NOT NULL AUTO_INCREMENT COMMENT 'Llave primaria que identifica a la tabla Sprints.',
  `fecha_i` date DEFAULT NULL COMMENT 'Fecha del inicio del Sprint.',
  `fecha_fin` date DEFAULT NULL COMMENT 'Fecha de finalización del Sprint.',
  `nombre` varchar(30) NOT NULL COMMENT 'Nombre del Sprint.',
  `observaciones` varchar(120) NOT NULL COMMENT 'Observaciones o ajustes sobre las tareas establecidas durante el Sprint.',
  `id_proyecto1` int NOT NULL COMMENT '	Es la llave foránea que conecta dos tablas.',
  PRIMARY KEY (`id_sp`),
  KEY `sprints_ibfk_1` (`id_proyecto1`)
);

--
-- Volcado de datos para la tabla `sprints`
--

INSERT INTO `sprints` (`id_sp`, `fecha_i`, `fecha_fin`, `nombre`, `observaciones`, `id_proyecto1`) VALUES
(4, '2023-09-18', '2023-10-18', 'Crud usuarios', 'Crear, actualizar, consultar y eliminar usuarios ', 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id_usuario` int NOT NULL,
  `password` varchar(15) NOT NULL COMMENT 'Contraseña del Usuario para el ingreso al aplicativo.',
  `genero` varchar(10) NOT NULL COMMENT 'Género del Usuario.',
  `correo` varchar(50) NOT NULL COMMENT 'Correo electrónico del Usuario.',
  `telefono` varchar(20) DEFAULT NULL COMMENT 'Número de celular o teléfono del Usuario.',
  `direccion` varchar(100) NOT NULL COMMENT 'Dirección del lugar de residencia del Usuario y/o la ubicación de la empresa.',
  `perfil` varchar(20) NOT NULL COMMENT 'Campo de almacenamiento de los datos personales del usuario.',
  `primer_nombre` varchar(20) NOT NULL COMMENT 'Primer nombre del usuario registrado.',
  `segundo_nombre` varchar(50) NOT NULL COMMENT 'Segundo nombre del usuario registrado.',
  `primer_apellido` varchar(50) NOT NULL COMMENT 'Primer apellido del usuario registrado.',
  `segundo_apellido` varchar(50) NOT NULL COMMENT 'Segundo apellido del usuario registrado.',
  `foto` varchar(6000) NOT NULL COMMENT 'se almacena el nombre de la foto',
  `cod_rol1` int DEFAULT NULL COMMENT 'Es la llave foránea que conecta dos tablas.',
  PRIMARY KEY (`id_usuario`),
  KEY `usuarios_ibfk_1` (`cod_rol1`)
);

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `password`, `genero`, `correo`, `telefono`, `direccion`, `perfil`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `foto`, `cod_rol1`) VALUES
(1010176763, '1010176763', '', 'caroceron28@gmail.com', '', '', '', 'Sharit ', 'Carolina ', 'Ceron', 'Varela ', '', 3),
(1011200831, '24271', 'macho', 'roger@gmail.com', '3156939089', 'calle 31 #2-27', 'Diseñador', 'roger', 'steec', 'fuentes', 'ramirez', '/ferrari-enzo-rojo_3840x2160_xtrafondos.com.jpg', 3),
(1012918020, '1012918020', '', '1012918020@ctjfr.edu.co', '', '', '', 'karol', 'andrea', 'beltran', 'diaz', '', 3),
(1012918370, '4200', '', 'shiuuvalenzuela@gmail.com', '', '', '', 'Shiuu ', '', 'Valenzuela', 'Penagos', '', 1),
(1021312836, 'familia01', '', 'smithcortes01@gmail.com', '', '', '', 'Steveen', 'Smith', 'Cortes', 'Cardenas', '', 3),
(1021397427, 'Pollo031006', '', 'mglnares2006@gmail.com', '', '', '', 'Miguel', 'Felipe', 'Linares', 'RiaÃ±o', '', 3),
(1021664834, '123456789', '', 'sebastianrm30yu@iclock.com', '', '', '', 'Johann', 'Sebastian ', 'Rivero', 'Martinez', '', 3),
(1021671180, '1011202200%', '', 'diego.lopezm0405@gmail.com', '', '', '', 'Diego', 'Esteban', 'LÃ³pez ', 'Melo', '', 3),
(1021672824, '1021672824', '', '1234juandavis@gmail.com', '', '', '', 'Juan', 'David', 'Diaz', 'MuÃ±oz', '', 3),
(1023367786, '1023367786', '', '1023367786@ctjfr.edu.co', '', '', '', 'Maria', 'Camila', 'Puerto', 'Guerrero', '', 3),
(1025323335, '1234', '', 'soff24ia@gmail.com', '', '', '', 'Ana', 'Sofia', 'Alarcon', 'Santana', '', 3),
(1028661442, '3107117232', '', '1028661442@gmail.com', '', '', '', 'emanuel', 'felipe', 'rodriguez', 'ramirez', '', 1),
(1029143096, '2006', 'Masculino', 'santicardenash@gmail.com', '3226432732', '', 'Desarrollador', 'Santiago', '', 'Cárdenas', 'Hernández', '/c59f9ad6da00a07b253d86a97c23d6d5 (1).jpg', 1),
(1029143097, '1029143097', '', '1029143097@ctjfr.edu.co', '', '', '', 'Sebastian ', '', 'Cardenas ', 'Hernandez', '', 3),
(1029144548, '1020', '', 'nicolasgiraldo1020@gmail.com', '', '', '', 'Nicolas', 'Santiago', 'Giraldo ', 'Valencia', '', 3),
(1031541493, 'JuanSilva217', '', 'jssr217@gmail.com', '', '', '', 'Primer Nombre', 'Juan ', 'Primer Apellido', 'Silva', '', 3),
(1031804394, 'sofialinada12', '', 'linaessofia33@gmail.com', '', '', '', 'laura', 'sofia', 'linares', 'piñeros', '', 3),
(1032678992, '2023', '', 'jeanpierrebbedoya@gmail.com', '', '', '', 'Jean', 'Pierre', 'BolaÃ±os ', 'Beodya', '', 3),
(1033696558, 'wendirussi17', '', '1033696558@ctjfr.edu.co', '', '', '', 'Wendi', 'Vanessa', 'Russi', 'Antolinez', '', 3),
(1070593041, '123456789', '', 'johanbenavides134@gmail.com', '', '', '', 'Johan', 'Steven', 'Benavides', 'Sanchez', '', 3),
(1074088080, 'majogalan2006', '', 'majogalan2006@gmail.com', '', '', '', 'María ', 'José', 'Romero', 'Gómez', '', 1),
(1074811705, '1074811705k.m', '', '1074811705@ctjfr.edu.co', '', '', '', 'Keiner', 'jean paul', 'MartÃ­nez ', 'Araujo', '', 3),
(1099203581, '123456', '', 'juandaja2201@gmail.com', '', '', '', 'Juan', 'David', 'Jerez', 'Amador', '', 3),
(1127342346, '0107M', '', '1127342346@ctjfr.edu.co', '', '', '', 'Genesis', 'Veronica', 'Sanabria', 'Leon', '', 3);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `checklist`
--
ALTER TABLE `checklist`
  ADD CONSTRAINT `checklist` FOREIGN KEY (`id_proyecto1`) REFERENCES `proyectos` (`id_proyecto`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `checklist_ibfk_1` FOREIGN KEY (`id_doc1`) REFERENCES `documentos` (`id_doc`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `pqrs`
--
ALTER TABLE `pqrs`
  ADD CONSTRAINT `pqrs_ibfk_1` FOREIGN KEY (`id_usuario1`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `p_i`
--
ALTER TABLE `p_i`
  ADD CONSTRAINT `p_i` FOREIGN KEY (`id_proyecto1`) REFERENCES `proyectos` (`id_proyecto`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `p_i_ibfk_1` FOREIGN KEY (`id_usuario1`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `reg_req`
--
ALTER TABLE `reg_req`
  ADD CONSTRAINT `reg_req` FOREIGN KEY (`cod_r1`) REFERENCES `requisitos` (`cod_r`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reg_req_ibfk_1` FOREIGN KEY (`id_proyecto1`) REFERENCES `proyectos` (`id_proyecto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `sprints`
--
ALTER TABLE `sprints`
  ADD CONSTRAINT `sprints` FOREIGN KEY (`id_proyecto1`) REFERENCES `proyectos` (`id_proyecto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios` FOREIGN KEY (`cod_rol1`) REFERENCES `roles` (`cod_rol`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
