/*
================================================================================
FACTURATE - PROCEDIMIENTOS ALMACENADOS ELABORADOS EN CLASE
Motor: Microsoft SQL Server
Lenguaje: Transact-SQL (T-SQL)
Base de datos: Facturate
Alcance: simulación académica de cuatro tablas

Parcial Bases de Datos - Momento 3
Integrantes:
- Julian David Zapata Múnera
- Cristian Camilo Garces Ramirez

REQUISITOS PREVIOS
- Ejecutar 01_Proyecto_Integrador_Facturate.sql.
- Deben existir las tablas dbo.clientes y dbo.productos.
- Para probar los ejemplos, ejecutar previamente las cargas de datos 02 y 03.

PROCEDIMIENTOS INCLUIDOS
1. dbo.AgregarProducto
2. dbo.RegistrarCliente
3. dbo.ClientesActivos
4. dbo.ProductosActivos
5. dbo.ActualizarPrecioProducto
6. dbo.BuscarProductosPorPrecio

NOTA
Los precios se reciben y almacenan como DECIMAL(14,2). FORMAT se usa en
consultas SELECT únicamente para presentar los importes como moneda COP.
================================================================================
*/

IF DB_ID(N'Facturate') IS NULL
BEGIN
    THROW 53020, N'No existe la base de datos Facturate. Ejecute primero el script 01.', 1;
END;
GO

USE Facturate;
GO

/* =============================================================================
   1. REGISTRAR UN PRODUCTO NUEVO
   ============================================================================= */
CREATE OR ALTER PROCEDURE dbo.AgregarProducto
    @codigo_producto NVARCHAR(50),
    @nombre_producto NVARCHAR(150),
    @descripcion NVARCHAR(500),
    @precio_venta DECIMAL(14,2),
    @activo BIT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.productos
    (
        codigo_producto,
        nombre_producto,
        descripcion,
        precio_venta,
        activo
    )
    VALUES
    (
        @codigo_producto,
        @nombre_producto,
        @descripcion,
        @precio_venta,
        @activo
    );
END;
GO

/* =============================================================================
   2. REGISTRAR UN CLIENTE NUEVO
   ============================================================================= */
CREATE OR ALTER PROCEDURE dbo.RegistrarCliente
    @tipo_documento NVARCHAR(20),
    @numero_documento NVARCHAR(30),
    @nombre_razon_social NVARCHAR(150),
    @activo BIT,
    @es_generico BIT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.clientes
    (
        tipo_documento,
        numero_documento,
        nombre_razon_social,
        activo,
        es_generico
    )
    VALUES
    (
        @tipo_documento,
        @numero_documento,
        @nombre_razon_social,
        @activo,
        @es_generico
    );
END;
GO

/* =============================================================================
   3. CONSULTAR CLIENTES CUYO ESTADO SEA ACTIVO
   ============================================================================= */
CREATE OR ALTER PROCEDURE dbo.ClientesActivos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.clientes
    WHERE activo = 1;
END;
GO

/* =============================================================================
   4. CONSULTAR PRODUCTOS DISPONIBLES Y ACTIVOS
   Presenta el precio en pesos colombianos sin decimales.
   ============================================================================= */
CREATE OR ALTER PROCEDURE dbo.ProductosActivos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        codigo_producto,
        nombre_producto,
        descripcion,
        FORMAT(precio_venta, 'C0', 'es-CO') AS precio_venta,
        activo
    FROM dbo.productos
    WHERE activo = 1;
END;
GO

/* =============================================================================
   5. MODIFICAR EL PRECIO DE VENTA DE UN PRODUCTO EXISTENTE
   ============================================================================= */
CREATE OR ALTER PROCEDURE dbo.ActualizarPrecioProducto
    @codigo_producto NVARCHAR(50),
    @nuevo_precio DECIMAL(14,2)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.productos
    SET precio_venta = @nuevo_precio
    WHERE codigo_producto = @codigo_producto;
END;
GO

/* =============================================================================
   6. CONSULTAR PRODUCTOS POR RANGO DE PRECIOS Y ESTADO
   ============================================================================= */
CREATE OR ALTER PROCEDURE dbo.BuscarProductosPorPrecio
    @precio_minimo DECIMAL(14,2),
    @precio_maximo DECIMAL(14,2),
    @activo BIT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.productos
    WHERE precio_venta BETWEEN @precio_minimo AND @precio_maximo
      AND activo = @activo;
END;
GO

/* =============================================================================
   EJEMPLOS DE EJECUCIÓN
   Las operaciones INSERT y UPDATE se dejan comentadas para evitar que el
   archivo agregue registros o modifique precios automáticamente.
   Descomente cada bloque solo cuando desee probarlo y ajuste sus datos.
   ============================================================================= */

-- 1. Agregar producto.
-- EXEC dbo.AgregarProducto
--     @codigo_producto = N'MON002',
--     @nombre_producto = N'Monitor Gamer Curvo AOC',
--     @descripcion = N'Monitor Gaming de 31.5 pulgadas Full HD 240Hz VA FreeSync Premium',
--     @precio_venta = 853899.00,
--     @activo = 1;
-- GO

-- 2. Registrar cliente.
-- EXEC dbo.RegistrarCliente
--     @tipo_documento = N'Cedula de ciudadania',
--     @numero_documento = N'1011397263',
--     @nombre_razon_social = N'Cristian Camilo Garces Ramirez',
--     @activo = 1,
--     @es_generico = 0;
-- GO

-- 3. Consultar clientes activos.
-- EXEC dbo.ClientesActivos;
-- GO

-- 4. Consultar productos activos.
-- EXEC dbo.ProductosActivos;
-- GO

-- 5. Actualizar el precio del producto.
-- EXEC dbo.ActualizarPrecioProducto
--     @codigo_producto = N'FAC-PRD-0352',
--     @nuevo_precio = 7000000.00;
-- GO

-- Consultar el precio actualizado con formato de moneda COP.
-- SELECT
--     codigo_producto AS CodigoProducto,
--     nombre_producto AS Producto,
--     FORMAT(precio_venta, 'C0', 'es-CO') AS Precio
-- FROM dbo.productos
-- WHERE codigo_producto = N'FAC-PRD-0352';
-- GO

-- 6. Buscar productos activos entre $10.000.000 y $50.000.000 COP.
-- EXEC dbo.BuscarProductosPorPrecio
--     @precio_minimo = 10000000.00,
--     @precio_maximo = 50000000.00,
--     @activo = 1;
-- GO
