/* 
=============================================================================
PROYECTO: Proyecto-2-SQL-Diseño-BBDDs-Relacionales-EDA
PARTE: 03_eda
MOTOR: MySQL
IDE: MySQL Workbench
=============================================================================
PARTE 3  EDA
Analisis de la BBDD Classicmodels
=======================================
Este script incluye:
*JOINs (INNER y LEFT).
*CASE y lógica condicional.
*Agregaciones.
*CTEs (WITH), incluyendo encadenadas.
*Funciones ventana (OVER (PARTITION BY ...)).
*VIEW y FUNCIÓN con consultas.
*INSERT, UPDATE, DELETE.
*Funciones de fecha.
*Agregaciones (SUM, COUNT).
*Subqueries.
*Transacciones (BEGIN / COMMIT / ROLLBACK).
*Al menos un índice con explicación de su utilidad.
=============================================================================
NOTA 1: las vistas, los INSERT, UPDATE, DELETE, estan a lo largo del archivo, 
segun la tabla que se consulte.
=============================================================================
NOTA 2: OBJETOS ADICIONALES (Índices, Vistas, Funciones), al final
 ============================================================================
*/

/* 
==============================
CONSULTAS TABLA orderdetails
==============================
*/
SELECT * FROM classicmodels.orderdetails;
-- Vista
create view precio50euros as select priceEach, productcode from orderdetails where priceEach>50;
-- funcion de agregacion
select count(*) productCode, orderNumber from orderdetails where orderNumber=10100;

select count(*) productCode, orderNumber from orderdetails where orderNumber=10100 order by productCode;


/* 
==============================
CONSULTAS TABLA customers
==============================
*/
SELECT * FROM classicmodels.customers;

select addressline1, customerNumber from customers where customerNumber=124;

select contactFirstname, phone, city from customers where city<>'Melbourne';

select contactFirstname, phone, city from customers where city!='Melbourne';

select contactFirstname, phone, city from customers where city not in ('Melbourne', 'las vegas', 'Lyon');

select count(*) from customers where country='usa';

select count(*) country from customers;

select customerName, state from customers where state is null;

select customerName, addressLine2 from customers where addressLine2<>'state';

select concat(addressLine1, ' , ', addressLine2) from customers;

select concat_ws(addressLine1, ' , ', addressLine2) from customers;

select contactLastName, creditLimit, city from customers where creditLimit>80000 and city='Nantes';

select* from customers where customerNumber>=105 and customerNumber<=125 and postalCode=3004;

select* from customers where customerNumber between 105 and 125 and postalCode=3004;

-- Vista
create view direcciones_Clientes as select customerNumber, contactLastName, contactFirstName, addressLine1, addressLine2, city 
from customers order by customerNumber asc;

select country, count(*) from customers group by country having count(*)>10;
select country, count(*) as total from customers group by country having total>10;


/* 
==============================
CONSULTAS TABLA employees
==============================
*/
SELECT * FROM classicmodels.employees;

select count(*), OfficeCode from employees group by OfficeCode;

select jobTitle, firstName from employees where firstName='mary';

select concat(' ', lastName, ' ', Firstname) as 'NOMBRE APELLIDOS' from employees;

select concat(' ', lastName, ' , ', Firstname) as 'NOMBRE APELLIDOS' from employees;

select lastName, firstName, reportsTo from employees where reportsTo=1056;

select concat(' ', lastName, ' , ', firstName, ' , ', extension) as 'NOMBRE APELLIDOS' from employees;


/* 
==============================
CONSULTAS TABLA orders
==============================
*/
SELECT * FROM classicmodels.orders;

select orderdate from orders where orderDate between '2004-10-19' and '2004-11-04';

select count(*), status orderNumber  from orders where Status='Cancelled';

select count(*), status orderNumber  from orders where Status='Shipped';

select orderNumber, datediff(ShippedDate, orderDate) as diasDiferencia from orders where orderNumber=10324;

select orderNumber, orderdate, ShippedDate, datediff(now( ), orderDate) from orders where orderNumber=10423;

select sum(ShippedDate) - sum(orderdate) as diferenciaDias from orders where orderNumber=10324;

select count(*) orderDate from orders where year(orderdate)=2005;

select orderNumber, orderDate, dayname(orderDate), monthname(orderDate) 
from orders where monthname(orderDate)='august' and dayname(orderDate)='monday';

select orderdate, dayname(orderdate) requireddate from orders where dayname(orderdate)='Friday';

select orderNumber, orderDate, dayname(orderDate)
from orders where dayname(orderDate)='monday';

select orderNumber, status from orders where status='On Hold' or status='In Process';

select customerNumber, status from orders where status='On Hold' or status='In Process' order by customerNumber asc;

select orderNumber, status from orders where status not in('In Process');

/* 
==============================
CONSULTAS TABLA payments
==============================
*/
 SELECT * FROM classicmodels.payments;

select sum(amount) from payments;

select * from payments where amount>1000;

-- Dos formas de hacer la consulta
select sum(amount) from payments where amount>1000; 
select sum(amount) as total from payments having total>1000;

select customerNumber, sum(amount) as total from payments group by customerNumber having total>1000;

select sum(amount) from payments group by customerNumber having sum(amount)>200000;

select customerNumber,  sum(amount)  from payments where customerNumber=282;


/* 
==============================
CONSULTAS TABLA products
==============================
*/
SELECT * FROM classicmodels.products;

select productCode, buyprice from products where buyPrice>100;

select count(*) from products where buyprice>100;

select count(*) productLine from products;

select count(*) productCodee, productLine from products where productLine='motorcycles';

-- Vista
create view precios77y98 as select buyPrice, productCode, productName  from  products  where buyPrice between 78 and 98;

-- 3 formas de hacer una consulta: Nombre del producto que tiene MAXIMO STOCK
-- La más sencilla
SELECT productname, quantityInStock AS 'MAXIMO STOCK'
FROM products
ORDER BY quantityInStock DESC
LIMIT 1;

-- Subquery
SELECT productname, quantityInStock AS 'MAXIMO STOCK'
FROM products
WHERE quantityInStock = (SELECT MAX(quantityInStock) FROM products);

-- Usando Funciones Ventana (Requisito 3.3 del proyecto)
SELECT productname, quantityInStock
FROM (
    SELECT productname, quantityInStock,
           RANK() OVER (ORDER BY quantityInStock DESC) as posicion
    FROM products
) AS ranking
WHERE posicion = 1;

select count(*) as NUMEROPRODUCTOS, productline from products group by  productline;

select productCode, productName, ProductLine, productScale from products where productLine='Classic Cars' and productScale>'1:10';

select productCode, productName, productLine, quantityInStock 
from products where productLine='Vintage Cars' and quantityInStock between 5000 and 7000;

select* from products where productLine='Vintage Cars' and quantityInStock between 5000 and 7000;

select* from products where productLine='Vintage Cars' and quantityInStock >= 5000 and quantityInStock <=7000;

-- Update 
#aplicar 15% menos y redondear a todos los producto
update products set buyprice=round(buyprice*0.15,1);

#aplicar 15% menos a todos los producto sin redondeo (dar warning pero hace el calculo)
update products set buyprice=(buyprice*0.15);

#aplicar 15% menos y redondear a un solo producto
update products set MSRP=(MSRP*0.15) where productCode='S24_2972';

/* 
==============================
Aplico SET SQL_SAFE_UPDATES = 0
Por defecto, MySQL Workbench tiene activado un "modo seguro". 
Este modo te prohíbe ejecutar un UPDATE o un DELETE si no incluyo una cláusula WHERE que use una Primary Key (ID).
Al ponerlo en 0, desactivo la seguridad, esto me permite hacer actualizaciones masivas.
==============================
*/

SET SQL_SAFE_UPDATES=0;

-- limit (desde la fila 1, 2 filas)
select productName from products limit 0,5;

-- lenght (lomjitud de cada nombre)
select length(productLine) from products;

-- Mayusculas y minusculas
select ucase(productName) from products;
select ucase(productName), lcase(productName) from products;

-- Dar formato a fechas
select date_format("2017-06-15", "%d %M %Y");
select date_format("2017-06-15", "%d - %M - %Y");

-- Dar formato a fechas colocar nombre del dia
select paymentDate, date_format(paymentDate, "%W  %d - %M -  %Y") as fechapedido from payments;


/* 
==============================
CONSULTAS TABLAs varias
usando group by, joins, order by, desc, limit, 
==============================
*/

#1-Stock total de productos agrupados por línea (productline)
select productline, sum(quantityInstock) from products group by productLine;

#otra respuesta
select sum(quantityinstock), productlines.productline from products inner join
productlines on products.productline = productlines.productline group by
productlines.productline;

#2-Producto más vendido. (productname) 
select productname, sum(quantityOrdered) from orderdetails o inner join products p on
p.productcode = o.productcode group by o.productcode order by sum(quantityOrdered) desc
limit 1;

#3-Promedio de ventas agrupado por linea de productos. (quantityordered) 
select productline, avg(suma) from
(select productline, o.productcode, sum(quantityordered) as suma
from products p
inner join orderdetails o
on p.productcode = o.productcode
group by o.productcode) as tt
group by productline;

#4-Nombre de los clientes que realizaron pagos superiores a 25000.
SELECT 
    customerName, 
    SUM(amount) AS total_pagado
FROM payments
JOIN customers USING (customerNumber)
WHERE amount > 25000 
GROUP BY customerName 
ORDER BY total_pagado ASC;

#6-Monto total debido a ordenes canceladas.
select sum(od.quantityordered * od.priceeach) as monto_ordenes_canceladas
from orders o
inner join orderdetails od
on o.ordernumber = od.ordernumber
where o.status = 'cancelled';

#7. Prepare una lista de oficinas ordenadas por país, estado, ciudad.
select officeCode, city, state, country from offices; 

#8. ¿Cuántos empleados hay en la empresa?
select count(employeeNumber) as CANT_EMPLEDOS from employees; 

#9 otra forma de hacerlo
select count(*) from Employees;

#10. ¿Cuál es el total de pagos recibidos?
select sum(amount) from payments;

#11. Enumere las líneas de productos que contienen 'Autos'.
Select distinct productline from products where
productline like '%Cars%';

#12. Informar pagos totales al 28 de octubre de 2004.
select sum(amount) as PAGOS_TOTALES from payments 
where paymentDate between '2003-01-16' and '2004-10-28';

#13 Monto del pago del 28/10/2004
select sum(amount) as PAGOS_TOTALES, paymentDate 
from payments 
where paymentDate="2004-10-28";

#14. Reportar aquellos pagos mayores a $100,000.
select * from Payments
where amount > "100000";

#15. Haga una lista de los productos en cada línea de productos.
select productname, productLine from products order by productLine;

#16. Cuantos productos hay en total por linea de productos
select count(*) as NUMEROPRODUCTOS, productline from products group by  productline;

#17. ¿Cuál es el pago mínimo recibido?
SELECT MIN(amount) FROM payments;

#18. Enumere todos los pagos superiores al doble del pago promedio.
#promedio del amount 
Select AVG(amount) as PROMEDIO
from payments;

#19 ¿Cuántos productos distintos vende ClassicModels?
select count(*) from products;

# 20 la lista productos distintos vende ClassicModels
select distinct productName from products;

#21.Reporte el nombre y ciudad de los clientes que no tienen representantes de ventas
select customerName, city, salesRepEmployeeNumber 
from customers 
where salesRepEmployeeNumber is null;

-- la version mas larga
select* from customers where state is null;

#22. ¿Cuáles son los nombres de los ejecutivos con VP o Gerente en su cargo? 
#Utilice la función CONCAT para combinar el nombre y el apellido del empleado 
#en un solo campo para generar informes

Select jobTitle, concat(' ', lastName,' , ',firstName) as DATOS_REPRESENTANTE 
from employees where jobTitle like '%Manager%' or jobTitle like '%VP%';   

#23. ¿Qué pedidos tienen un valor mayor a $5,000?
-- en una sola tabla
SELECT 
    orderNumber, 
    SUM(quantityOrdered * priceEach) AS valor_total
FROM orderdetails
GROUP BY orderNumber
HAVING valor_total > 5000
ORDER BY valor_total DESC;

-- con joins
SELECT 
    o.orderNumber, 
    c.customerName, 
    SUM(od.quantityOrdered * od.priceEach) AS valor_total
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN customers c ON o.customerNumber = c.customerNumber
GROUP BY o.orderNumber, c.customerName
HAVING valor_total > 5000;

#24. los pedidos del lunes
select orderNumber, orderDate, dayname(orderDate) 
from orders 
where dayname(orderDate)='monday';

#25. los productos pedidos
Select dayname(orderdate), ordernumber, productcode
from orders join orderdetails using(ordernumber) where dayname(orderdate)='Monday';

#26.¿Cuál es la diferencia en días entre la fecha de pedido más reciente 
#y la más antigua en el archivo de Pedidos?

select max(orderdate), min(orderdate), datediff(max(orderdate), min(orderdate)) from orders;

#27.	¿Cuál es el valor de los pedidos enviados en agosto de 2004?
#cuales son los pedidos de agosto 2004
# varias tablas
Select amount, monthname(shippeddate), year(shippeddate) 
from payments
join orders using(customernumber)
where monthname(shippeddate)='August' and year(shippeddate)=2004

#28. Reportar el representante de cuenta de cada cliente.
select jobTitle, customerName as CLIENTE , E.firstName as REPRESENTANTE_DE_CUENTA, E.lastName
from Customers C
join Employees E
on C.salesRepEmployeeNumber = E.employeeNumber;

#con concat
select concat_ws(' ',firstName,'--', lastName) as REPRESENTANTE, customerName as CLIENTE 
from employees e 
join customers c on e.employeeNumber=c.salesRepEmployeeNumber ;

#29. Informar los pagos totales de Atelier graphique.
Select customername, SUM(amount) 
from customers join
payments using(customernumber) where customername='Atelier graphique';

#30. Reporte los pagos totales por fecha
Select SUM(amount), paymentdate 
from payments 
join customers using(customernumber) 
group by paymentdate;

#31. Reportar los productos que no han sido vendidos.
select * from Products
where productCode
not in (select Products.productCode from Products
join OrderDetails
on Products.productCode = OrderDetails.productCode);

-- otra forma de hacerlo
select productcode, productname 
from products 
where productcode not in (select productcode from orderdetails);

#32. Indique el monto pagado por cada cliente.
Select SUM(amount), customername from payments
join customers using(customernumber) group by customername;

#33. ¿Cuántos pedidos ha realizado Herkku Gifts?
Select count(*), customername 
from orders
join customers on orders.customernumber=customers.customernumber
where customername='Herkku Gifts';

#34. ¿Quiénes son los empleados en Boston?
select * from Employees
join Offices
on Employees.officeCode = Offices.officeCode
where Offices.city = "Boston";

#35. Reportar aquellos pagos mayores a $100,000. 
#Ordenando el informe para que el cliente que realizó el pago más alto aparezca primero.
Select amount, paymentdate, customernumber, customerName
from payments 
join customers using(customernumber) 
where amount>100000 order by amount desc;

#36. Enumere el valor de las órdenes 'En espera'.
#la lista respuesta
select quantityOrdered*priceEach as valor, Ord.orderNumber, status
from Orders O
join OrderDetails Ord
on O.orderNumber = Ord.orderNumber
where status = "On Hold";

#37. la suma de las ordenes On Hold
select sum(quantityOrdered*priceEach) as valor, status
from Orders O
join OrderDetails Ord
on O.orderNumber = Ord.orderNumber
where status = "On Hold";

#38. Informe el número de pedidos 'En espera' para cada cliente.
SELECT 
    c.customerName AS 'Cliente', 
    COUNT(o.orderNumber) AS 'Pedidos en Espera'
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
WHERE o.status = 'On Hold'
GROUP BY c.customerName
ORDER BY COUNT(o.orderNumber) DESC;

#39. Enumere los productos vendidos ('Resolved','Shipped') por fecha de pedido.
select p.productName, o.orderDate, status 
from products p
join orderdetails ord on p.productCode=ord.productCode
join orders o on o.orderNumber=ord.orderNumber
where status in ('Resolved','Shipped');

#40. Enumere las fechas (orderdate)  de los pedidos (productCode) en orden descendente (asc) 
#para los pedidos de la camioneta 1940 Ford Pickup Truck.

select p. productCode, p.productName, o.orderDate, o.orderNumber
from products p
join orderdetails ord on p.productCode=ord.productCode
join orders o on o.orderNumber=ord.orderNumber
where productName="1940 Ford Pickup Truck" order by  o.orderDate desc;

#41. Enumere los nombres de los clientes y su número de pedido correspondiente 
#cuando un pedido en particular de ese cliente tiene un valor superior a $25,000.

select customerName, o.orderNumber, (quantityOrdered*priceEach) as valorPedido from customers c
Join orders o on o.customerNumber=c.customerNumber
join orderdetails ord on ord.orderNumber=o.orderNumber
where (quantityOrdered*priceEach)>25.000;

#42. ¿Hay algún producto que aparezca en todos los pedidos?
#segun esta respuesta nungun producto aparece en todos los pedidos
SELECT* from products
WHERE productcode = ALL (SELECT productcode
FROM orderdetails);

#43 Producto que no está en ningun pedido (productos que no han sido vendidos)
#Forma 1 NOT exists subconsulta 
SELECT *FROM products
WHERE NOT exists(SELECT productcode FROM orderdetails
where products.productcode=orderdetails.productcode);

#Para comprobar con exist (los productos que si estan)
SELECT *FROM products 
WHERE exists(SELECT productcode FROM orderdetails
where products.productcode=orderdetails.productcode);

#44. Enumere los nombres de los productos vendidos a menos del 80% del MSRP.

Select MSRP, priceeach, productname, (MSRP)*1.80, productcode 
from products
join orderdetails using(productcode)
 where priceeach<(MSRP)*1.80;
 
 #45 Quién está en la cima de la organización (es decir, no depende de nadie).
select employeeNumber, lastName, firstName, reportsTo, jobTitle 
from employees 
where reportsTo is null;

#46 ¿Qué día se vendió el producto mas caro de la BD?
#precio mas alto de BD
select productcode, productname, buyprice
from products
where buyPrice=(select max(buyprice) from products);

#47 precio mas alto de BD y dia de venta
select productcode, productname, buyprice, dayname(orderdate) as DIACOMPRA, orderdate as FECHACOMPRA   
from products
JOIN orderdetails using(productcode)
join orders using(ordernumber)
where buyPrice=(select max(buyprice) from products);

#48 ¿Qué dias se ha vendido el producto mas barato de mi BD? Precio=buyprice
#precio mas barato de BD y dia de venta
select productcode, productname, buyprice, dayname(orderdate), orderdate as FECHACOMPRA   
from products
JOIN orderdetails using(productcode)
join orders using(ordernumber)
where buyPrice=(select min(buyprice) from products);

 #49.	Obtener un listado con el nombre de los productos incluidos en pedidos hechos 
#por clientes de Alemania, Francia o Portugal. (Usanso cláusula in)

Select country, orders.ordernumber, productname from customers
join orders on customers.customernumber=orders.customernumber
join orderdetails on orderdetails.ordernumber=orders.ordernumber
join products on orderdetails.productcode=products.productcode
where country in ('Germany', 'France', 'Portugal');

#50.	Obtener un listado alfabético con el nombre del cliente 
#junto con el nombre, apellido y teléfono del representante de ventas asignado.

Select customername, concat_ws(' ', employeeNumber,' , ', firstName, lastName,' - ', extension) as REPRESENTANTE_VENTAS
from customers c
join employees e on c.salesRepEmployeeNumber=e.employeeNumber
order by customername asc;

#51.Por cada cliente, obtener el monto total pagado.(AMOUNT)
select sum(amount) as total, customerNumber
from payments
group by customerNumber;

#52.Muestra los productos comprados por los clientes de USA
Select country, orders.ordernumber, productname 
from customers
join orders on customers.customernumber=orders.customernumber
join orderdetails on orderdetails.ordernumber=orders.ordernumber
join products on orderdetails.productcode=products.productcode
where country='USA';

#53.Obtener un listado con el nombre y apellido de los contactos de los clientes 
#que han hecho pedidos donde se incluyeron productos de la línea de aviones (Planes).

SELECT 
	productline, productCode, orderNumber, contactLastName, contactFirstName
	 FROM
   productlines
INNER JOIN products 
    USING (productLine)
INNER JOIN orderdetails 
    USING (productCode)
INNER JOIN orders 
    USING (orderNumber)
INNER JOIN customers 
    USING (customerNumber)
where
    productLine='Planes';
    
#54.Obtener un listado alfabético con el nombre del cliente junto con el 
#nombre, apellido y teléfono del representante de ventas asignado.
Select customername, concat_ws(' ', employeeNumber, '-', firstName, lastName, ':', extension) 
as REPRESENTANTE_VENTAS from customers c
join employees e on c.salesRepEmployeeNumber=e.employeeNumber  
order by customername asc;

#55.Por cada cliente, obtener el monto total pagado.(AMOUNT)
select customerNumber, SUM(amount) as MontoT_Pagado from payments
group by customerNumber;

#56.	Muestra los productos comprados por los clientes de USA
select p.productName, c.country from products p
join orderdetails ord on p.productCode=ord.productCode 
join orders o on ord.orderNumber=o.orderNumber
join customers c on o.customerNumber=c.customerNumber
where c.country='USA';

#57.	Obtener un listado con el nombre y apellido de los contactos de los clientes 
#que han hecho pedidos donde se incluyeron productos de la línea de aviones (Planes).
select c.contactFirstName, c.contactLastName, p.productLine, c.customerNumber from products p
join orderdetails ord on p.productCode=ord.productCode 
join orders o on ord.orderNumber=o.orderNumber
join customers c on o.customerNumber=c.customerNumber
where p.productLine='Planes';
    
#58.clientes que no hayan hecho ningun pedido
SELECT * 
FROM customers
WHERE customernumber NOT IN (SELECT customernumber FROM orders);

#59. precio mas alto de BD y dia de venta
select productcode, productname, buyprice, dayname(orderdate), orderdate as FECHACOMPRA   
from products
JOIN orderdetails using(productcode)
join orders using(ordernumber)
where buyPrice=(select max(buyprice) from products);

#60. Empleado con mas ventas que el resto de empleados
SELECT 
    e.employeeNumber, 
    CONCAT(e.firstName, ' ', e.lastName) AS nombre_empleado,
    e.jobTitle,
    SUM(od.quantityOrdered * od.priceEach) AS total_ventas
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY e.employeeNumber, e.firstName, e.lastName, e.jobTitle
ORDER BY total_ventas DESC
LIMIT 1;

#61 Cuantos productos tengo enviados y cuantos cancelados?
Select COUNT(productCode) AS 'Pedidos Enviados y Cancelados', status 
from products
join orderdetails using(productCode)
join orders using(orderNumber)
where status='Shipped' or status='Cancelled' group by status;

#62
select orders.shippedDate, customers.city, payments.checkNumber
from orders 
join customers using (customerNumber) 
join payments using (customerNumber)
where customerNumber=205;

#63
select productCode , htmlDescription, productline, quantityInStock
from productlines
join products using (productline) 
join orderdetails using (productCode)
where  priceEach='99.91';

#64
select postalCode, jobTitle, firstName, territory
from offices
inner join employees using (officeCode) 
where city='Paris';

#65
select productName, productline, productCode, priceEach, status
from products 
join orderdetails using (productCode) 
join orders using (orderNumber)
where productName like '%A';

#66
select priceEach, orderNumber, paymentDate, quantityOrdered 
from orderdetails 
join orders using (orderNumber)
join payments using (customerNumber)
where quantityOrdered>50;

#67 CASO DONDE LAS TABLAS NO SON CONTIGUAS, LAS UNO TABLA A TABLA ASI NO BUSQUE INFO EN ELLAS
select amount, productCode, textDescription, orderNumber
from payments
join orders using(customerNumber)
join orderdetails using(orderNumber)
join products using(productCode)
join productlines using(productLine)
where productName='1996 Moto Guzzi 1100i';

#68
SELECT 
    orderNumber,
	status, 
	sum(priceEach*quantityOrdered) as PRECIO_TOTAL
 FROM
    orders
INNER JOIN orderdetails
    USING (orderNumber)
group by
    orderNumber;

#69
SELECT 
    productName,
    MSRP,
    orderNumber,
    priceEach	
 FROM
    products 
INNER JOIN orderdetails
    USING (productCode)
where
   productCode='S10_1678' and  MSRP>priceEach;
   
#70
SELECT 
       orderNumber,
       customerName,
       phone,
       checkNumber
       FROM
   orders
INNER JOIN customers
    USING (customerNumber)
    INNER JOIN payments
    USING (customerNumber)
where
  dayname(paymentDate)='Tuesday';
  
#71. Obtener un listado alfabético con el nombre del cliente junto con el nombre, apellido y teléfono del representante de ventas asignado. (CONCAT)
   select concat(customerName, ' , ', contactLastName, '  ', contactFirstName, ' , ', phone) 
   as 'LISTADO ALFABETICO' 
   from customers;
  
 #72.	Obtener un listado con el nombre y apellido de los contactos de los clientes que han hecho pedidos donde se incluyeron productos de la línea de aviones (Planes).
 #VIC JOIN/USING
 SELECT 
	productline,
	productCode,
	orderNumber,
    contactLastName, 
   contactFirstName
	 FROM
   productlines
INNER JOIN products 
    USING (productLine)
INNER JOIN orderdetails 
    USING (productCode)
INNER JOIN orders 
    USING (orderNumber)
INNER JOIN customers 
    USING (customerNumber)
where
    productLine='Planes';
  
#73.Obtener un listado con el nombre de los productos incluidos en pedidos hechos por clientes de Alemania, Francia o Portugal. (Usar cláusula in)
  #JOIN/USING
  SELECT 
	productName,
	productCode,
	country
	 FROM
   products
   INNER JOIN orderdetails 
    USING (productCode)
   INNER JOIN orders 
    USING (orderNumber)
INNER JOIN customers 
    USING (customerNumber)
where
    country in('Germany', 'France', 'Portugal');
  
#74.Obtener un listado de las ciudades con la cantidad de empleados que trabajan en dicha ciudad
	#JOIN/USING
	SELECT count(employeeNumber) AS CANTIDAD_EMPLEADOS, city
	 FROM
   employees
   INNER JOIN offices 
    USING (officeCode)
    group by city;
  
#75	Por cada ciudad de Estados Unidos, obtener la cantidad de pedidos que le han sido enviados a sus clientes.
Select count(*), country, city, status
 from customers C
join orders O on C.customernumber=O.customernumber
where status in ('shipped') and country='USA' group by city;
  
#76.	Por cada cliente, obtener el monto total pagado.
select sum(amount) as total, customerNumber
from payments
group by customerNumber;

#77.Listar los clientes que han pedido productos tanto de la línea de Motocicletas como de la línea de Autos clásicos. ( in o and) 
  select customername, productline
   from customers
   join orders using(customernumber)
   join orderdetails using(ordernumber)
   join products using(productcode)
   where productline in('classic cars', 'motorcycles');
   
 #78.obtener un listado de los productos que tienen el mismo precio de compra de algún producto de una línea diferente a la suya.
SELECT productCode, productName, textDescription
FROM products t1
INNER JOIN productlines t2 ON t1.productline = t2.productline;

#otra forma
Select distinct productline, productname,
buyprice from products where buyprice=buyprice;

#79.Obtener el valor promedio recaudado por pagos en el segundo semestre de 2003.
Select AVG(amount) as PROMEDIORECAUDADO
from payments where paymentdate between '2003-06-01' and '2003-12-31';

#80.Obtener el nombre y el precio del producto de menor valor registrado en la base de datos. 
Select productname, buyprice from products 
where buyprice=(select MIN(buyprice) from products);

#81 Update
-- Incrementar en el 10% el precio de compra de los productos cuya línea no sea relacionada con carros
Update products set buyprice=(buyprice*1.10)
where productline not in('Classic Cars', 'Vintage Cars');

#82
select orderNumber, orderDate, status,
case 
when status='shipped' then 'ENVIADO'
when status='cancelled' then 'CANCELADO'
when status='disputed' or status='on hold' then 'ILOCALIZABLE'
ELSE 'NO GESTIONADO'
end AS 'ESTADO PEDIDOS'
FROM orders;

#83
select productCode, productname, productLine, quantityinstock,
case 
when quantityinstock>=0 and quantityinstock<=200 then 'POCAS UNIDADES'
when quantityinstock>=201 and quantityinstock<=500 then 'ALGUNAS UNIDADES'
when quantityinstock>=501 and quantityinstock<=1000 then 'BASTANTES UNIDADES'
when quantityinstock>=10001 and quantityinstock<=2500 then 'BASTANTES UNIDADES'
ELSE 'STOCK COMPLETO'
end AS 'CANTIDAD UNIDADES'
FROM products;
   
#84
select customerName, city, creditLimit,
case 
when creditLimit>=0 and creditLimit<=11000 then 'SIN CREDITO'
when creditLimit>=12000 and creditLimit<=40000 then 'CREDITO BAJO'
when creditLimit>=41000 and creditLimit<=80000 then 'CREDITO MEDIO'
when creditLimit>=81000 and creditLimit<=100000 then 'CREDITO ALTO'
ELSE 'CREDITO MAXIMO'
end AS 'TIPO DE CREDITO'
FROM customers;

#85 ejemplo con join
select customerName, city, creditLimit, status,
case 
when creditLimit>=0 and creditLimit<=11000 then 'SIN CREDITO'
when creditLimit>=12000 and creditLimit<=40000 then 'CREDITO BAJO'
when creditLimit>=41000 and creditLimit<=80000 then 'CREDITO MEDIO'
when creditLimit>=81000 and creditLimit<=100000 then 'CREDITO ALTO'
ELSE 'CREDITO MAXIMO'
end AS 'TIPO DE CREDITO'
FROM customers
join orders using(customernumber);

#86 sub consulta
select customerNumber, amount as CANTIDAD_PAGA_MENOR_AVG
from payments 
where amount<=(select avg(amount) as CANTIDAD_MEDIA_PAGADA from payments);

#87 vista  - 
-- Vista en la que se visualice el precio de venta, el numero de orden de los pedidos cuyo precio de venta es menor a 50euros.
create view preciosventa_numorden3 as select buyPrice, orderNumber, productcode
from  products 
inner join orderdetails using(productcode) 
where buyPrice<50
group by productcode;

#88.	¿Cuantos pedidos tengo enviados y cuantos cancelados?
select count(*), status  from orders where Status='Cancelled';

#89
select count(*), status  from orders where Status='Shipped';

#90 ¿Cuantos productos tengo enviados y cuantos cancelados?
Select COUNT(productCode) AS 'Pedidos Enviados y Cancelados', status from products
join orderdetails using(productCode)
join orders using(orderNumber)
where status='Shipped' or status='Cancelled' group by status;

#91.	¿Qué clientes no tienes una segunda dirección de residencia?
SELECT*FROM customers WHERE addressLine2 IS NULL;

#92.	¿Cúal es el producto más barato de la BD?
select productcode, productName, buyPrice
from products
where buyPrice=(SELECT MIN(buyprice) FROM products);

#93.	el producto más caro de la BD?
select productcode, productName, buyPrice
from products
where buyPrice=(SELECT max(buyprice) FROM products);

#94.	Realiza una consulta usando el comando CASE, en el que pueda visualizar la siguiente info:
#Nombre de productos, codigo de productos y buyprice y escala de los productos y que aparezca lo siguiente
#La escala entre 1:10 al 1:18 baja escala
#Entre 1:24 y 1;32 escala media
#Entre 1:50 y 1:72 escala normal
#Entre 1:73 y 1:90 escala alta
#El resto escala muy elevada

#con buyprice
select productname,  productCode, buyprice, productScale,
case 
when productscale>='1:10' and productscale<='1:18' then 'BAJA ESCALA'
when productscale>='1:24' and productscale<='1:32' then 'ESCALA MEDIA'
when productscale>='1:50' and productscale<='1:72' then 'ESCALA NORMAL'
when productscale>='1:73' and productscale<='1:90' then 'ESCALA ALTA'
ELSE 'ESCALA MUY ELEVADA'
end AS 'ESCALA DE PRODUCTOS'
FROM products;

#95.	¿Qué empleados no reportan a ningun otro empleado? PRUEBA CON SUBCONSULTA
select employeeNumber, lastName, firstName, reportsTo from employees where reportsTo is null;


#96.Actualiza el precio de los productos que tengan un buyprice mayor a 50 y aumentales un 10%. 
#(realiza la sentencia y un rollback, sin modificar mi BD)

update products set buyprice=(buyprice*1.10) where buyprice>50;

rollback;

#97.	Producto que no está en ningun pedido
#Forma 2 NOT IN subconsulta sencilla
SELECT *FROM products
WHERE productcode NOT IN(SELECT productcode FROM orderdetails);

#Para comprobar con exist 
SELECT *FROM products 
WHERE exists(SELECT productcode FROM orderdetails
where products.productcode=orderdetails.productcode);

#98.	Clientes que no hayan hecho ningun pedido
#con not in
SELECT * FROM customers
WHERE customernumber NOT IN (SELECT customernumber FROM orders);

#con not exists
SELECT * FROM customers
WHERE NOT EXISTS (SELECT customernumber FROM orders
where customers.customernumber=orders.customernumber);

#99.	Mostrar productos que contengan las palabras red, blue, yellow
#es decir, La sentencia es red o blue o yellow en el productdescription
Select productCode, productName, productDescription from products
where (productDescription like '%red%')
or (productDescription like '%blue%')
or (productDescription like '%yellow%')
order by productName;

#100.	Clientes que no tengaa limite de credito

Select customerNumber, customerName, creditLimit from customers
where creditLimit=0;

#101. precio mas alto de BD y dia de venta
select productcode, productname, buyprice, dayname(orderdate), orderdate as FECHACOMPRA   
from products
JOIN orderdetails using(productcode)
join orders using(ordernumber)
where buyPrice=(select max(buyprice) from products);

#102.	¿Qué día se vendió el producto mas barato de la BD?
#precio mas alto de BD y dia de venta
select productcode, productname, buyprice, dayname(orderdate), orderdate as FECHACOMPRA   
from products
JOIN orderdetails using(productcode)
join orders using(ordernumber)
where buyPrice=(select min(buyprice) from products);

#103.Año e importe total(preicounidad y cantidadorden) de los pedidos enviados agrupados por año
Select year(orderdate), SUM(priceeach*quantityordered)
from orderdetails 
join orders using(ordernumber)
where status='shipped' 
group by year(orderdate);

#104.	¿Qué pedidos tienen un valor mayor a 7000?. (amount)
select ordernumber, customername, amount 
from orders 
join customers using (customernumber) 
join payments using (customernumber) 
where amount>7000;

#105.	vista en la que se visualicen los ‘precios de cada’ (price each)  producto 
#cuyo importe sea menor de 68 y muéstrame también la línea de producto a la que corresponden. 
create view precios_de_cada_producto2 as select productcode, productLine, priceEach
from  products 
inner join orderdetails using(productcode) 
where priceEach<68;

#106.	Reporta el nombre del producto y el precio de compra teniendo en cuenta que aumentaremos 
#a este el precio en un 25% a todos los productos exceptuando los pertenecientes a las líneas de producto 
#de Vintage Cars y Classic Cars. Muestra este resultado en una nueva columna llamada SUBIDA25%. CLASSICMODELS;
select productname, productline, buyprice*(1.25) as 'SUBIDA25%' 
from products 
where productline not in('Classic Cars', 'Vintage Cars');

#107.	¿Cuántos pedidos tengo ‘In process’, a qué fecha y a que cliente pertenecen?. 
select count(*), status  from orders where Status='In process';


#108.	¿Cuánto dinero se ha gastado el cliente 114 en total en todos sus pedidos?. 
select customernumber, sum(amount) 
from orders 
join payments using(customernumber) where customernumber=114;

#109.	Enumera los ‘territory’  de aquellos clientes que contengan ‘Street’ en su addressline1 o su teléfono termine en 0 o en 1. 
Select territory, addressline1, phone  from offices
where addressline1 like '%Street%' AND phone LIKE'%0' OR phone LIKE'%1';

#110.	Reporta los nombres y apellidos, el puesto de trabajo, el nombre del cliente al que llevan y el 
#número de orden de los pedidos de los clientes que viven en ‘San Francisco’. (Utiliza la claúsula ON). 
select firstname, lastname, jobtitle, customername, city, ordernumber 
from employees 
join customers on employees.EmployeeNumber=customers.salesRepEmployeeNumber
 join orders on customers.customerNumber=orders.customerNumber where city='san francisco';
 
/*
 =========================================================
 Consulta para verificar Tabla Extra: dim_calendar 
 =========================================================
 */
-- CONSULTA 1: Total de ventas por Mes y Año usando DIM_CALENDAR
SELECT 
    d.anio,
    d.mes,
    COUNT(o.orderNumber) AS total_pedidos,
    SUM(od.quantityOrdered * od.priceEach) AS facturacion_total
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN DIM_CALENDAR d ON o.orderDate = d.date_id  -- Unión clave: fecha pedido con ID calendario
GROUP BY d.anio, d.mes
ORDER BY d.anio DESC, d.mes DESC;

-- CONSULTA 2: Monto de pagos recibidos desglosado por día de la semana
SELECT 
    d.dia_nombre, -- O la columna que uses para 'Lunes', 'Martes', etc.
    COUNT(p.checkNumber) AS cantidad_pagos,
    SUM(p.amount) AS monto_total
FROM payments p
JOIN DIM_CALENDAR d ON p.paymentDate = d.date_id
GROUP BY d.dia_nombre, d.dia_semana_n -- Agrupamos por nombre y número para ordenar correctamente
ORDER BY d.dia_semana_n ASC;

/*
 =========================================================
-- OBJETOS ADICIONALES (Índices, Vistas, Funciones)
 =========================================================
 */

-- ÍNDICE: Optimización para búsquedas por estado de pedido
CREATE INDEX idx_order_status ON orders(status);

-- VISTA: Resumen de ventas por cliente (KPI clave)
CREATE OR REPLACE VIEW vw_customer_revenue AS
SELECT 
    c.customerName,
    COUNT(DISTINCT o.orderNumber) as total_pedidos,
    SUM(od.quantityOrdered * od.priceEach) as ingresos_totales
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
LEFT JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerNumber;

-- FUNCIÓN: Etiquetado de volumen de stock
DELIMITER //
CREATE FUNCTION fn_stock_alert(stock INT) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE label VARCHAR(20);
    IF stock < 500 THEN SET label = 'REABASTECER';
    ELSE SET label = 'OK';
    END IF;
    RETURN label;
END //
DELIMITER ;

/*
Justificación Breve de Diseño:
*Normalización: El modelo está en 3NF (Tercera Forma Normal): Se cumple la 2NF y no existen dependencias transitivas. Es decir, una columna no clave no puede depender de otra columna no clave.
Las dependencias transitivas han sido eliminadas (ej: las oficinas tienen su propia tabla separada de empleados).
El modelo utiliza tablas de dimensiones separadas (offices, productlines) para evitar anomalías de actualización. 
Si una oficina cambia de teléfono, solo se actualiza en un registro de la tabla 'offices' y no en los registros de todos los empleados asociados.
*Integridad: Se han aplicado PK compuestas en `orderdetails` y `payments` para evitar que un mismo producto o número de cheque se duplique para el mismo registro.
*Performance: el índice en `status` se justifica porque la mayoría de las consultas de negocio filtrarán por pedidos 'Shipped' o 'In Process'.
*/







 