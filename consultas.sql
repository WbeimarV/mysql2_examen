use Chinook;

-- Encuentra el empleado que ha generado la mayor cantidad de ventas en el último trimestre.

SELECT e.FirstName as "Nombre Vendedor", COUNT(il.Quantity)   as "Cantidad de ventas"
FROM Employee e 
inner join Customer c  on e.EmployeeId = c.SupportRepId
INNER JOIN Invoice i on c.CustomerId = i.InvoiceId 
INNER JOIN InvoiceLine il on i.InvoiceId = il.InvoiceId 
WHERE i.InvoiceDate >= "2025-05-14" AND i.InvoiceDate < "2025-08-14"
GROUP BY e.FirstName
order by "Cantidad de ventas" DESC 
limit 1;

-- Lista los cinco artistas con más canciones vendidas en el último año.

SELECT a.Name as "artista", COUNT(il.Quantity) as "canciones vendidas"  
FROM Artist a
inner join Album a2 on a.ArtistId = a2.ArtistId
INNER  JOIN Track t on a2.AlbumId = t.AlbumId
INNER  join InvoiceLine il on t.TrackId = il.TrackId
INNER JOIN Invoice i on il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= "2024-08-14" AND i.InvoiceDate < "2025-08-14"
GROUP BY a.Name 
ORDER by COUNT(il.Quantity) DESC
limit 5;

 -- Obtén el total de ventas y la cantidad de canciones vendidas por país.
SELECT i.BillingCountry as "pais", SUM(Total) as "total ventas", SUM(il.Quantity) as "cantidad canciones"  
FROM Invoice i 
inner join InvoiceLine il on i.InvoiceId = il.InvoiceId 
group by i.BillingCountry;

-- Calcula el número total de clientes que realizaron compras por cada género en un mes específico (en este caso julio de 2025).
SELECT g.Name as "genro", SUM(c.CustomerId) as "cantidad clientes"  
FROM Customer c 
inner join Invoice i on c.CustomerId = i.CustomerId
INNER JOIN InvoiceLine il on i.InvoiceId = il.InvoiceId
INNER JOIN Track t on il.TrackId = t.TrackId
INNER JOIN Genre g on t.GenreId = g.GenreId
WHERE i.InvoiceDate >= "2025-07-1" AND i.InvoiceDate < "2025-08-01"
GROUP BY g.Name ;

-- Lista los tres países con mayores ventas durante el último semestre.

SELECT i.BillingCountry as "pais", SUM(Total) as "total ventas"
FROM Invoice i 
inner join InvoiceLine il on i.InvoiceId = il.InvoiceId 
WHERE i.InvoiceDate >= "2025-02-14" AND i.InvoiceDate < "2025-08-14"
group by i.BillingCountry
order by SUM(Total) DESC 
limit 3;

-- Muestra los cinco géneros menos vendidos en el último año.

SELECT g.Name as "genero", SUM(il.Quantity) as "cantidad de ventas"
FROM Customer c 
inner join Invoice i on c.CustomerId = i.CustomerId
INNER JOIN InvoiceLine il on i.InvoiceId = il.InvoiceId
INNER JOIN Track t on il.TrackId = t.TrackId
INNER JOIN Genre g on t.GenreId = g.GenreId
WHERE i.InvoiceDate >= "2024-08-14" AND i.InvoiceDate < "2025-08-14"
GROUP BY g.Name
order by SUM(il.Quantity) ASC
LIMIT 5;

-- Encuentra los cinco empleados que realizaron más ventas de Rock.

SELECT e.FirstName as "nombre", COUNT(il.Quantity) as "cantidad de ventas"
FROM Employee e 
inner join Customer c on e.EmployeeId = c.CustomerId 
INNER JOIN Invoice i on c.CustomerId = i.CustomerId 
INNER JOIN InvoiceLine il on i.InvoiceId = il.InvoiceId
INNER JOIN Track t on t.TrackId = il.TrackId 
INNER JOIN  Genre g on g.GenreId =t.GenreId
WHERE g.Name = "rock"
GROUP BY e.FirstName
ORDER by COUNT(il.Quantity) DESC
limit 5;

-- Genera un informe de los clientes con más compras recurrentes.

SELECT  c.FirstName as "nombre cliente", COUNT(il.Quantity) as "cantidad de compras"
FROM Customer c 
INNER JOIN Invoice i on c.CustomerId = i.CustomerId 
INNER JOIN InvoiceLine il on i.InvoiceId = il.InvoiceId
GROUP by c.FirstName
order by COUNT(il.Quantity) DESC ;

-- Calcula el precio promedio de venta por género.

SELECT g.Name as "genero", AVG(i.Total) as "promedio de venta" 
FROM Invoice i
INNER JOIN InvoiceLine il on i.InvoiceId = il.InvoiceId
INNER JOIN Track t on t.TrackId = il.TrackId 
INNER JOIN  Genre g on g.GenreId =t.GenreId
GROUP BY g.Name;

-- Lista las cinco canciones más largas vendidas en el último año.

SELECT t.Name as "cancion", t.Milliseconds as "Duracion"
FROM Invoice i
INNER JOIN InvoiceLine il on i.InvoiceId = il.InvoiceId
INNER JOIN Track t on t.TrackId = il.TrackId
WHERE i.InvoiceDate >= "2024-08-14" AND i.InvoiceDate < "2025-08-14"
ORDER BY t.Milliseconds DESC
limit 5;

-- Muestra los clientes que compraron más canciones de Jazz.

SELECT c.FirstName as "cliente", COUNT(il.Quantity) as "cantidad de compras"
FROM Customer c
INNER JOIN Invoice i on c.CustomerId = i.CustomerId 
INNER JOIN InvoiceLine il on i.InvoiceId = il.InvoiceId
INNER JOIN Track t on t.TrackId = il.TrackId 
INNER JOIN  Genre g on g.GenreId =t.GenreId
WHERE g.Name = "jazz"
GROUP by c.FirstName 
ORDER by COUNT(il.Quantity) DESC
limit 5;

-- Encuentra la cantidad total de minutos comprados por cada cliente en el último mes.

SELECT c.FirstName, SUM(t.Milliseconds) 
FROM Customer c
INNER JOIN Invoice i on c.CustomerId = i.CustomerId 
INNER JOIN InvoiceLine il on i.InvoiceId = il.InvoiceId
INNER JOIN Track t on t.TrackId = il.TrackId 
INNER JOIN  Genre g on g.GenreId =t.GenreId
WHERE i.InvoiceDate >= "2025-07-14" AND i.InvoiceDate < "2025-08-14"
GROUP  by c.FirstName;

-- Muestra el número de ventas diarias de canciones en cada mes del último trimestre.

SELECT i.InvoiceDate, SUM(il.Quantity) 
FROM Invoice i 
inner join InvoiceLine il on i.InvoiceId = il.InvoiceId
WHERE i.InvoiceDate >= "2025-05-14" AND i.InvoiceDate < "2025-08-14"
GROUP by i.InvoiceDate;

-- Calcula el total de ventas por cada vendedor en el último semestre.

SELECT e.FirstName as "Nombre Vendedor", SUM(i.Total) as "Total Ventas"
FROM Employee e, Customer c, Invoice i
WHERE e.EmployeeId = c.SupportRepId and c.CustomerId = i.CustomerId AND i.InvoiceDate >= "2025-05-14" AND i.InvoiceDate < "2025-08-14"
GROUP BY e.FirstName
ORDER BY SUM(i.Total) DESC;

-- Encuentra el cliente que ha realizado la compra más cara en el último año (factura ùnica)

SELECT  c.FirstName as "nombre cliente", SUM(i.Total) "valor compra", i.InvoiceId  as "factura"
FROM Customer c 
INNER JOIN Invoice i on c.CustomerId = i.CustomerId 
WHERE i.InvoiceDate >= "2024-08-14" AND i.InvoiceDate < "2025-08-14"
GROUP by c.FirstName, i.InvoiceId 
order by SUM(i.Total)  DESC
limit 1;




