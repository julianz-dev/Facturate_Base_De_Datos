/* =====================================================================
   FACTURATE - PROCEDIMIENTOS ALMACENADOS ELABORADOS EN CLASE
   Motor: Microsoft SQL Server
   Lenguaje: Transact-SQL (T-SQL)
   Base de datos: Facturate
   Alcance: simulacion academica de cuatro tablas

   Integrantes:
   - Julian David Zapata Munera
   - Cristian Camilo Garces Ramirez

   REQUISITOS PREVIOS:
   - Ejecutar 01_Proyecto_Integrador_Facturate.sql.
   - Las tablas dbo.clientes y dbo.productos deben existir.
   - Para probar los ejemplos se recomienda ejecutar las cargas 02 y 03.

   PROCEDIMIENTOS INCLUIDOS:
   1. dbo.AgregarProducto
   2. dbo.RegistrarCliente
   3. dbo.ClientesActivos
   4. dbo.ProductosActivos
   5. dbo.ActualizarPrecioProducto
   6. dbo.BuscarProductosPorPrecio

   NOTAS:
   - Se conservan los nombres de tablas y columnas del esquema Facturate.
   - Los precios se almacenan y reciben como DECIMAL(14,2).
   - FORMAT(..., 'C0', 'es-CO') se utiliza solo en SELECT para presentar
     importes en pesos colombianos sin decimales.
   ===================================================================== */

IF DB_ID(N'Facturate') IS NULL
BEGIN
    THROW 53020, N'No existe la base de datos Facturate. Ejecute primero el script 01.', 1;
END;
GO

USE Facturate;
GO

/* =====================================================================
   1. REGISTRAR UN PRODUCTO NUEVO
   ===================================================================== */
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

/* =====================================================================
   2. REGISTRAR UN CLIENTE NUEVO
   ===================================================================== */
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

/* =====================================================================
   3. CONSULTAR CLIENTES ACTIVOS
   ===================================================================== */
CREATE OR ALTER PROCEDURE dbo.ClientesActivos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.clientes
    WHERE activo = 1;
END;
GO

/* =====================================================================
   4. CONSULTAR PRODUCTOS ACTIVOS
   ===================================================================== */
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

/* =====================================================================
   5. ACTUALIZAR EL PRECIO DE UN PRODUCTO EXISTENTE
   ===================================================================== */
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

/* =====================================================================
   6. BUSCAR PRODUCTOS POR RANGO DE PRECIO Y ESTADO
   ===================================================================== */
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

/* =====================================================================
   EJEMPLOS DE EJECUCION
   Los INSERT y UPDATE de ejemplo están comentados para evitar cambios
   accidentales. Descomente y ajuste los valores antes de ejecutarlos.
   ===================================================================== */

-- 1. Agregar producto:
-- EXEC dbo.AgregarProducto
--     @codigo_producto = N'MON002',
--     @nombre_producto = N'Monitor Gamer Curvo AOC',
--     @descripcion = N'Monitor Gaming de 31.5 pulgadas Full HD 240Hz',
--     @precio_venta = 853899.00,
--     @activo = 1;
-- GO

-- 2. Registrar cliente:
-- EXEC dbo.RegistrarCliente
--     @tipo_documento = N'CC',
--     @numero_documento = N'1017204261',
--     @nombre_razon_social = N'Julian David Zapata Munera',
--     @activo = 1,
--     @es_generico = 0;
-- GO

-- 3. Consultar clientes activos:
-- EXEC dbo.ClientesActivos;
-- GO

-- 4. Consultar productos activos:
-- EXEC dbo.ProductosActivos;
-- GO

-- 5. Actualizar precio:
-- Rango/valor expresado en COP: 7.000.000
-- EXEC dbo.ActualizarPrecioProducto
--     @codigo_producto = N'FAC-PRD-0352',
--     @nuevo_precio = 7000000.00;
-- GO
-- SELECT
--     codigo_producto AS CodigoProducto,
--     nombre_producto AS Producto,
--     FORMAT(precio_venta, 'C0', 'es-CO') AS Precio
-- FROM dbo.productos
-- WHERE codigo_producto = N'FAC-PRD-0352';
-- GO

-- 6. Buscar productos activos entre $10.000.000 y $50.000.000 COP:
-- EXEC dbo.BuscarProductosPorPrecio
--     @precio_minimo = 10000000.00,
--     @precio_maximo = 50000000.00,
--     @activo = 1;
-- GO

-- Consulta independiente para visualizar el rango en moneda colombiana:
-- SELECT
--     FORMAT(10000000, 'C0', 'es-CO') AS Precio_Minimo,
--     FORMAT(50000000, 'C0', 'es-CO') AS Precio_Maximo;
-- GO
