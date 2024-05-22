-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 22-05-2024 a las 14:17:41
-- Versión del servidor: 10.4.27-MariaDB
-- Versión de PHP: 8.1.12

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `checklist`
--

CREATE TABLE `checklist` (
  `id` int(10) NOT NULL,
  `aprobacion` binary(1) NOT NULL,
  `archivo` blob NOT NULL,
  `fecha` date NOT NULL,
  `documentosid_doc` varchar(25) NOT NULL,
  `proyectosid_proyecto` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documentos`
--

CREATE TABLE `documentos` (
  `id_doc` varchar(25) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `opiniones`
--

CREATE TABLE `opiniones` (
  `id_opinion` int(10) NOT NULL,
  `opinion` varchar(255) NOT NULL,
  `calificacion` varchar(25) NOT NULL,
  `tipo_opinionnombre` varchar(25) NOT NULL,
  `usuariosid_usuario` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planes`
--

CREATE TABLE `planes` (
  `nombre` varchar(25) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `precio` int(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prioridad`
--

CREATE TABLE `prioridad` (
  `nombre` varchar(25) NOT NULL,
  `descripcion` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyectos`
--

CREATE TABLE `proyectos` (
  `id_proyecto` int(10) NOT NULL,
  `nombre` varchar(25) NOT NULL,
  `creador` varchar(25) NOT NULL,
  `tipo` varchar(25) NOT NULL,
  `fecha_i` date NOT NULL,
  `fecha_f` date NOT NULL,
  `planesnombre` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyectos_requisitos`
--

CREATE TABLE `proyectos_requisitos` (
  `proyectosid_proyecto` int(10) NOT NULL,
  `requisitoscodigo` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `requisitos`
--

CREATE TABLE `requisitos` (
  `codigo` int(10) NOT NULL,
  `nombre` varchar(25) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `tipotipo` varchar(25) NOT NULL,
  `prioridadnombre` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_rol` varchar(25) NOT NULL,
  `descripcion` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sprints`
--

CREATE TABLE `sprints` (
  `id` int(10) NOT NULL,
  `fecha_i` date NOT NULL,
  `fecha_f` date NOT NULL,
  `nombre` varchar(25) NOT NULL,
  `observaciones` varchar(255) NOT NULL,
  `proyectosid_proyecto` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_opinion`
--

CREATE TABLE `tipo_opinion` (
  `nombre` varchar(25) NOT NULL,
  `descripcion` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_req`
--

CREATE TABLE `tipo_req` (
  `tipo` varchar(25) NOT NULL,
  `descripcion` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(10) NOT NULL,
  `clave` varchar(20) NOT NULL,
  `correo` varchar(30) NOT NULL,
  `telefono` int(10) NOT NULL,
  `Perfil` varchar(25) NOT NULL,
  `nombres` varchar(25) NOT NULL,
  `apellidos` varchar(25) NOT NULL,
  `foto` varchar(6000) NOT NULL,
  `rolesid_rol` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios_proyectos`
--

CREATE TABLE `usuarios_proyectos` (
  `usuariosid_usuario` int(10) NOT NULL,
  `proyectosid_proyecto` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `checklist`
--
ALTER TABLE `checklist`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKchecklist472482` (`documentosid_doc`),
  ADD KEY `FKchecklist938524` (`proyectosid_proyecto`);

--
-- Indices de la tabla `documentos`
--
ALTER TABLE `documentos`
  ADD PRIMARY KEY (`id_doc`);

--
-- Indices de la tabla `opiniones`
--
ALTER TABLE `opiniones`
  ADD PRIMARY KEY (`id_opinion`),
  ADD KEY `FKopiniones892802` (`tipo_opinionnombre`),
  ADD KEY `FKopiniones24303` (`usuariosid_usuario`);

--
-- Indices de la tabla `planes`
--
ALTER TABLE `planes`
  ADD PRIMARY KEY (`nombre`);

--
-- Indices de la tabla `prioridad`
--
ALTER TABLE `prioridad`
  ADD PRIMARY KEY (`nombre`);

--
-- Indices de la tabla `proyectos`
--
ALTER TABLE `proyectos`
  ADD PRIMARY KEY (`id_proyecto`),
  ADD KEY `FKproyectos570460` (`planesnombre`);

--
-- Indices de la tabla `proyectos_requisitos`
--
ALTER TABLE `proyectos_requisitos`
  ADD PRIMARY KEY (`proyectosid_proyecto`,`requisitoscodigo`),
  ADD KEY `FKproyectos_630503` (`requisitoscodigo`);

--
-- Indices de la tabla `requisitos`
--
ALTER TABLE `requisitos`
  ADD PRIMARY KEY (`codigo`),
  ADD KEY `FKrequisitos651237` (`tipotipo`),
  ADD KEY `FKrequisitos351589` (`prioridadnombre`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_rol`);

--
-- Indices de la tabla `sprints`
--
ALTER TABLE `sprints`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKsprints456385` (`proyectosid_proyecto`);

--
-- Indices de la tabla `tipo_opinion`
--
ALTER TABLE `tipo_opinion`
  ADD PRIMARY KEY (`nombre`);

--
-- Indices de la tabla `tipo_req`
--
ALTER TABLE `tipo_req`
  ADD PRIMARY KEY (`tipo`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD KEY `FKusuarios372452` (`rolesid_rol`);

--
-- Indices de la tabla `usuarios_proyectos`
--
ALTER TABLE `usuarios_proyectos`
  ADD PRIMARY KEY (`usuariosid_usuario`,`proyectosid_proyecto`),
  ADD KEY `FKusuarios_p199432` (`proyectosid_proyecto`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `checklist`
--
ALTER TABLE `checklist`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `opiniones`
--
ALTER TABLE `opiniones`
  MODIFY `id_opinion` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `proyectos`
--
ALTER TABLE `proyectos`
  MODIFY `id_proyecto` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `requisitos`
--
ALTER TABLE `requisitos`
  MODIFY `codigo` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sprints`
--
ALTER TABLE `sprints`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(10) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `checklist`
--
ALTER TABLE `checklist`
  ADD CONSTRAINT `FKchecklist472482` FOREIGN KEY (`documentosid_doc`) REFERENCES `documentos` (`id_doc`),
  ADD CONSTRAINT `FKchecklist938524` FOREIGN KEY (`proyectosid_proyecto`) REFERENCES `proyectos` (`id_proyecto`);

--
-- Filtros para la tabla `opiniones`
--
ALTER TABLE `opiniones`
  ADD CONSTRAINT `FKopiniones24303` FOREIGN KEY (`usuariosid_usuario`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `FKopiniones892802` FOREIGN KEY (`tipo_opinionnombre`) REFERENCES `tipo_opinion` (`nombre`);

--
-- Filtros para la tabla `proyectos`
--
ALTER TABLE `proyectos`
  ADD CONSTRAINT `FKproyectos570460` FOREIGN KEY (`planesnombre`) REFERENCES `planes` (`nombre`);

--
-- Filtros para la tabla `proyectos_requisitos`
--
ALTER TABLE `proyectos_requisitos`
  ADD CONSTRAINT `FKproyectos_630503` FOREIGN KEY (`requisitoscodigo`) REFERENCES `requisitos` (`codigo`),
  ADD CONSTRAINT `FKproyectos_864386` FOREIGN KEY (`proyectosid_proyecto`) REFERENCES `proyectos` (`id_proyecto`);

--
-- Filtros para la tabla `requisitos`
--
ALTER TABLE `requisitos`
  ADD CONSTRAINT `FKrequisitos351589` FOREIGN KEY (`prioridadnombre`) REFERENCES `prioridad` (`nombre`),
  ADD CONSTRAINT `FKrequisitos651237` FOREIGN KEY (`tipotipo`) REFERENCES `tipo_req` (`tipo`);

--
-- Filtros para la tabla `sprints`
--
ALTER TABLE `sprints`
  ADD CONSTRAINT `FKsprints456385` FOREIGN KEY (`proyectosid_proyecto`) REFERENCES `proyectos` (`id_proyecto`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `FKusuarios372452` FOREIGN KEY (`rolesid_rol`) REFERENCES `roles` (`id_rol`);

--
-- Filtros para la tabla `usuarios_proyectos`
--
ALTER TABLE `usuarios_proyectos`
  ADD CONSTRAINT `FKusuarios_p199432` FOREIGN KEY (`proyectosid_proyecto`) REFERENCES `proyectos` (`id_proyecto`),
  ADD CONSTRAINT `FKusuarios_p988247` FOREIGN KEY (`usuariosid_usuario`) REFERENCES `usuarios` (`id_usuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
