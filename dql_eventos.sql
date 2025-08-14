CREATE EVENT IF NOT EXISTS ReiniciarVentasMensuales
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-09-01 00:00:00'
DO
    UPDATE VentasEmpleado
    SET TotalVentas = 0;

CREATE EVENT IF NOT EXISTS GuardarHistorialPrecios
ON SCHEDULE EVERY 1 WEEK
STARTS '2025-08-18 00:00:00'
DO
    INSERT INTO Historial_PrecioCancion (TrackId, PrecioAntiguo, FechaCambio)
    SELECT TrackId, UnitPrice, NOW()
    FROM Track;

CREATE EVENT IF NOT EXISTS AvisarClientesDeudores
ON SCHEDULE EVERY 1 DAY
STARTS '2025-08-15 09:00:00'
DO
    INSERT INTO Notificaciones (Mensaje, FechaNotificacion)
    SELECT CONCAT('Aviso: Cliente ', CustomerId, ' tiene deuda de $', SaldoDeudor),
           NOW()
    FROM SaldosCliente
    WHERE SaldoDeudor > 0;