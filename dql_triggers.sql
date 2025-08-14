use Chinook;

/* =========================================================
   Tabla: VentasEmpleado
   Guarda el total acumulado de ventas por cada empleado.
   ========================================================= */
CREATE TABLE VentasEmpleado (
    EmployeeId INT PRIMARY KEY,
    TotalVentas DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeId)
);

/* =========================================================
   Tabla: Cliente_Auditoria
   Registra cambios en datos de clientes.
   ========================================================= */
CREATE TABLE Cliente_Auditoria (
    AuditoriaId INT AUTO_INCREMENT PRIMARY KEY,
    CustomerId INT NOT NULL,
    Old_FirstName NVARCHAR(40),
    New_FirstName NVARCHAR(40),
    Old_LastName NVARCHAR(20),
    New_LastName NVARCHAR(20),
    FechaCambio DATETIME NOT NULL,
    FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId)
);

/* =========================================================
   Tabla: Historial_PrecioCancion
   Guarda el historial de cambios en precios de canciones.
   ========================================================= */
CREATE TABLE Historial_PrecioCancion (
    HistorialId INT AUTO_INCREMENT PRIMARY KEY,
    TrackId INT NOT NULL,
    PrecioAnterior DECIMAL(10,2) NOT NULL,
    PrecioNuevo DECIMAL(10,2) NOT NULL,
    FechaCambio DATETIME NOT NULL,
    FOREIGN KEY (TrackId) REFERENCES Track(TrackId)
);

/* =========================================================
   Tabla: Notificaciones
   Guarda mensajes de notificación del sistema.
   ========================================================= */
CREATE TABLE Notificaciones (
    NotificacionId INT AUTO_INCREMENT PRIMARY KEY,
    Mensaje NVARCHAR(255) NOT NULL,
    Fecha DATETIME NOT NULL
);

/* =========================================================
   Tabla: SaldosCliente
   Guarda el saldo deudor de cada cliente.
   ========================================================= */
CREATE TABLE SaldosCliente (
    CustomerId INT PRIMARY KEY,
    SaldoDeudor DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId)
);


DELIMITER $$

/* =========================================================
   1. ActualizarTotalVentasEmpleado
   Al realizar una venta (INSERT en Invoice), actualiza el total 
   de ventas acumuladas por el empleado en una tabla resumen.
   ========================================================= */
CREATE TRIGGER ActualizarTotalVentasEmpleado
AFTER INSERT ON Invoice
FOR EACH ROW
BEGIN
    -- Si no existe la tabla resumen, créala antes de usar el trigger
    INSERT INTO VentasEmpleado (EmployeeId, TotalVentas)
    VALUES (
        (SELECT SupportRepId FROM Customer WHERE CustomerId = NEW.CustomerId),
        NEW.Total
    )
    ON DUPLICATE KEY UPDATE TotalVentas = TotalVentas + NEW.Total;
END$$

/* =========================================================
   2. AuditarActualizacionCliente
   Cada vez que se actualiza un cliente, registra el cambio en una 
   tabla de auditoría (Cliente_Auditoria).
   ========================================================= */
CREATE TRIGGER AuditarActualizacionCliente
AFTER UPDATE ON Customer
FOR EACH ROW
BEGIN
    INSERT INTO Cliente_Auditoria (
        CustomerId, 
        Old_FirstName, New_FirstName, 
        Old_LastName, New_LastName, 
        FechaCambio
    )
    VALUES (
        OLD.CustomerId,
        OLD.FirstName, NEW.FirstName,
        OLD.LastName, NEW.LastName,
        NOW()
    );
END$$

/* =========================================================
   3. RegistrarHistorialPrecioCancion
   Guarda el historial de cambios en el precio de las canciones 
   en una tabla (Historial_PrecioCancion).
   ========================================================= */
CREATE TRIGGER RegistrarHistorialPrecioCancion
BEFORE UPDATE ON Track
FOR EACH ROW
BEGIN
    IF OLD.UnitPrice <> NEW.UnitPrice THEN
        INSERT INTO Historial_PrecioCancion (
            TrackId,
            PrecioAnterior,
            PrecioNuevo,
            FechaCambio
        )
        VALUES (
            OLD.TrackId,
            OLD.UnitPrice,
            NEW.UnitPrice,
            NOW()
        );
    END IF;
END$$

/* =========================================================
   4. NotificarCancelacionVenta
   Registra una notificación cuando se elimina un registro de venta 
   (Invoice).
   ========================================================= */
CREATE TRIGGER NotificarCancelacionVenta
AFTER DELETE ON Invoice
FOR EACH ROW
BEGIN
    INSERT INTO Notificaciones (
        Mensaje,
        Fecha
    )
    VALUES (
        CONCAT('Venta con ID ', OLD.InvoiceId, ' cancelada.'),
        NOW()
    );
END$$

/* =========================================================
   5. RestringirCompraConSaldoDeudor
   Evita que un cliente con saldo deudor realice nuevas compras.
   (SaldoDeudor > 0 en tabla SaldosCliente).
   ========================================================= */
CREATE TRIGGER RestringirCompraConSaldoDeudor
BEFORE INSERT ON Invoice
FOR EACH ROW
BEGIN
    DECLARE saldo DECIMAL(10,2);

    SELECT SaldoDeudor
    INTO saldo
    FROM SaldosCliente
    WHERE CustomerId = NEW.CustomerId;

    IF saldo > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Compra rechazada: el cliente tiene saldo deudor.';
    END IF;
END$$

DELIMITER ;