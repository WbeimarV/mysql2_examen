# Examen SQL – Gestión de Ventas Musicales

## 📄 Descripción del Proyecto

Este examen consiste en el desarrollo de una base de datos para la **gestión y análisis de ventas musicales**, incluyendo consultas analíticas, funciones, triggers y eventos en **MySQL**.  
El objetivo es evaluar habilidades en **consultas DQL**, **funciones personalizadas**, **mecanismos de automatización con triggers y eventos**, así como una correcta **organización y documentación del repositorio**.

La base de datos simula un sistema de ventas de música digital, permitiendo:
- Consultar estadísticas de ventas, clientes, empleados y géneros musicales.
- Automatizar procesos de actualización y auditoría mediante triggers.
- Generar reportes automáticos mediante eventos programados.
- Implementar funciones para cálculos personalizados como gastos, descuentos y promedios.

---



## 🚀 Instalación y Configuración

Clona el repositorio y entra a la carpeta del proyecto

corre el archivo llamado 

Chinook_MySql.sql

luego dependiendo de lo que quieras revisar abre el archivo necesario es decir consultas, funciones, eventos o triggers


## 🧮 Funciones

-- 1. Total gastado por cliente en un año
SELECT TotalGastoCliente(5, 2010) AS Gasto_Total_2010;

-- 2. Promedio de precio por álbum
SELECT PromedioPrecioPorAlbum(10) AS Precio_Promedio_Album10;

-- 3. Duración total de canciones vendidas por género (en minutos)
SELECT DuracionTotalPorGenero(3) AS Minutos_Genero3;

-- 4. Descuento calculado por frecuencia de compras
SELECT DescuentoPorFrecuencia(8) AS Factor_Descuento;

-- 5. Verificar si un cliente es VIP
SELECT VerificarClienteVIP(12) AS Es_VIP;

## 🔄 Triggers

-- 1. Actualizar total de ventas por empleado
SELECT * FROM VentasEmpleado;
INSERT INTO Invoice (InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total)
VALUES (9991, 5, NOW(), 'Calle 123', 'Bogotá', 'Cundinamarca', 'Colombia', '11001', 50.00);
SELECT * FROM VentasEmpleado;

-- 2. Auditar cambios en datos de clientes
UPDATE Customer SET FirstName = 'Carlos', LastName = 'Gómez' WHERE CustomerId = 5;
SELECT * FROM Cliente_Auditoria;

-- 3. Guardar historial de cambios de precio de canciones
UPDATE Track SET UnitPrice = UnitPrice + 1.00 WHERE TrackId = 10;
SELECT * FROM Historial_PrecioCancion;

-- 4. Notificar cancelación de venta
INSERT INTO Invoice (InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total)
VALUES (9992, 5, NOW(), 'Calle Temporal', 'Bogotá', 'Cundinamarca', 'Colombia', '11001', 30.00);
DELETE FROM Invoice WHERE InvoiceId = 9992;
SELECT * FROM Notificaciones;

-- 5. Restringir compra si el cliente tiene saldo deudor
INSERT INTO SaldosCliente (CustomerId, SaldoDeudor) VALUES (5, 100.00)
ON DUPLICATE KEY UPDATE SaldoDeudor = 100.00;
INSERT INTO Invoice (InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total)
VALUES (9993, 5, NOW(), 'Calle Bloqueada', 'Bogotá', 'Cundinamarca', 'Colombia', '11001', 25.00);
-- Esperado: ERROR 1644 (45000)

## ⏳ Eventos

-- Activar programador de eventos
SET GLOBAL event_scheduler = ON;

-- 1. Listar eventos activos
SHOW EVENTS;

-- 2. Forzar ejecución manual de un evento (ejemplo)
CALL ProcesoMensualVentas(); -- si el evento está vinculado a un procedimiento

-- 3. Ver próximo momento de ejecución
SELECT EVENT_NAME, STATUS, LAST_EXECUTED, INTERVAL_VALUE, INTERVAL_FIELD
FROM information_schema.EVENTS;

-- 4. Modificar programación de un evento
ALTER EVENT EventoLimpiarNotificaciones
ON SCHEDULE EVERY 1 DAY STARTS CURRENT_TIMESTAMP;



