use Chinook;

DELIMITER $$

/* =========================================================
   1. TotalGastoCliente(ClienteID, Anio)
   Calcula el gasto total de un cliente en un año específico.
   ========================================================= */
CREATE FUNCTION TotalGastoCliente(p_ClienteID INT, p_Anio INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_gasto DECIMAL(10,2);

    SELECT IFNULL(SUM(Total), 0)
    INTO total_gasto
    FROM Invoice
    WHERE CustomerId = p_ClienteID
      AND YEAR(InvoiceDate) = p_Anio;

    RETURN total_gasto;
END$$

/* =========================================================
   2. PromedioPrecioPorAlbum(AlbumID)
   Retorna el precio promedio de las canciones de un álbum.
   ========================================================= */
CREATE FUNCTION PromedioPrecioPorAlbum(p_AlbumID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);

    SELECT IFNULL(AVG(UnitPrice), 0)
    INTO promedio
    FROM Track
    WHERE AlbumId = p_AlbumID;

    RETURN promedio;
END$$

/* =========================================================
   3. DuracionTotalPorGenero(GeneroID)
   Calcula la duración total (en minutos) de todas las canciones 
   vendidas de un género específico.
   ========================================================= */
CREATE FUNCTION DuracionTotalPorGenero(p_GeneroID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE duracion_total DECIMAL(10,2);

    SELECT IFNULL(SUM(t.Milliseconds / 60000), 0)
    INTO duracion_total
    FROM InvoiceLine il
    JOIN Track t ON il.TrackId = t.TrackId
    WHERE t.GenreId = p_GeneroID;

    RETURN duracion_total;
END$$

/* =========================================================
   4. DescuentoPorFrecuencia(ClienteID)
   Calcula el descuento basado en la frecuencia de compra del cliente:
   - Más de 20 compras → 15%
   - Entre 10 y 20 compras → 10%
   - Entre 5 y 9 compras → 5%
   - Menos de 5 compras → 0%
   ========================================================= */
CREATE FUNCTION DescuentoPorFrecuencia(p_ClienteID INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE num_compras INT;
    DECLARE descuento DECIMAL(5,2);

    SELECT COUNT(*) 
    INTO num_compras
    FROM Invoice
    WHERE CustomerId = p_ClienteID;

    IF num_compras > 20 THEN
        SET descuento = 0.15;
    ELSEIF num_compras >= 10 THEN
        SET descuento = 0.10;
    ELSEIF num_compras >= 5 THEN
        SET descuento = 0.05;
    ELSE
        SET descuento = 0.00;
    END IF;

    RETURN descuento;
END$$

/* =========================================================
   5. VerificarClienteVIP(ClienteID)
   Retorna TRUE (1) si el gasto anual promedio del cliente 
   es mayor o igual a $100, de lo contrario FALSE (0).
   ========================================================= */
CREATE FUNCTION VerificarClienteVIP(p_ClienteID INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE gasto_promedio_anual DECIMAL(10,2);

    SELECT IFNULL(SUM(Total) / COUNT(DISTINCT YEAR(InvoiceDate)), 0)
    INTO gasto_promedio_anual
    FROM Invoice
    WHERE CustomerId = p_ClienteID;

    RETURN gasto_promedio_anual >= 100;
END$$

DELIMITER ;

