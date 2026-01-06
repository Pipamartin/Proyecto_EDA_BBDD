# Proyecto_EDA_BBDD
Proyecto de diseño, carga y análisis exploratorio (EDA) de la base de datos ClassicModels

📊 ClassicModels: Infraestructura de Datos y Análisis Exploratorio (EDA)

La base de datos ClassicModels es un estándar muy utilizado para aprender SQL, ya que simula el inventario y las ventas de una empresa de modelos a escala.
🔗 Dónde descargar el código: 
El sitio oficial y más confiable para obtenerlo es MySQL Tutorial. Aquí tienes el enlace directo a la sección de descargas: Enlace: [Download MySQL Sample Database](https://www.mysqltutorial.org/mysql-sample-database.aspx)

📐 Estructura de la Base de Datos Original

La base de datos consta de 8 tablas relacionadas entre sí:
•	Offices: Ubicación de las oficinas.
•	Employees: Datos del personal y jerarquía.
•	Customers: Información de los clientes.
•	Orders & OrderDetails: Los pedidos y los productos específicos comprados.
•	Payments: Registro de pagos de clientes.
•	Products & ProductLines: El catálogo de modelos a escala.

1. 🏗️ EXPLICACION DEL MODELO

El modelo se basa en un esquema relacional diseñado para una empresa de logística y venta de modelos a escala.

Justificación de Decisiones:

•	Motor InnoDB: Se seleccionó para garantizar el cumplimiento de las propiedades ACID (Atomicidad, Consistencia, Aislamiento y Durabilidad). Esto es crítico para el procesamiento de pagos y pedidos.
•	Normalización: El modelo sigue la Tercera Forma Normal (3FN), eliminando redundancias en datos de clientes y empleados para asegurar la integridad.
•	Dimensión Calendario (DIM_CALENDAR): Se añadió como una tabla de dimensiones externa (desnormalizada) para facilitar análisis temporales complejos que las funciones de fecha nativas de SQL no resuelven de forma eficiente (ej. días festivos, trimestres fiscales).
Ventajas y Limitaciones
•	Ventaja: Alta integridad referencial; es casi imposible tener un pedido sin un cliente válido.
•	Limitación: Debido a la alta normalización, consultas muy profundas requieren múltiples JOINs, lo que puede afectar el rendimiento en bases de datos de escala masiva (Big Data), aunque es óptimo para este volumen.

3. 📋 ANALISIS DE LA ESTRUCTURA TECNICA DEL MODELO

Total de Tablas: 9 (8 operativas + 1 Extra dimensión de tiempo).

📊 Resumen de Arquitectura: ClassicModels Pro

La base de datos se compone de 9 tablas (de Hechos y de Dimensiones) organizadas en cuatro núcleos operativos principales:
Las Tablas de Hechos (Fact Table FT): Contiene las métricas cuantitativas o eventos de negocio (ventas, medidas). Suele tener muchas filas y muchas claves foráneas que conectan con las dimensiones.
Las Tablas de Dimensiones (Dim Tables DT): Contiene los atributos descriptivos de los datos en las tablas de hechos (nombres de productos, categorías, datos de clientes). Sirven para filtrar y agrupar.

1. Núcleo de Organización (RRHH y Sedes)
Offices (DT): Define la ubicación geográfica de las sedes. (PK: officeCode).
Employees (DT): Gestiona el personal y la estructura jerárquica (quién reporta a quién). (PK: employeeNumber | FK: officeCode, reportsTo).

2. Núcleo Comercial (Clientes y Ventas)
Customers (DT): Almacena los datos de los clientes y los vincula con un representante de ventas. (PK: customerNumber | FK: salesRepEmployeeNumber).
Payments (FT): Registro contable de los pagos realizados por los clientes. (PK Compuesta: customerNumber, checkNumber).

3. Núcleo de Inventario (Catálogo)
ProductLines (DT): Define las categorías de los modelos (ej. Classic Cars). (PK: productLine).
Products (DT): Listado detallado de productos con sus especificaciones y stock. (PK: productCode | FK: productLine).

4. Núcleo Transaccional (Pedidos)
Orders (FT): Información general del pedido (fecha, estado, cliente). (PK: orderNumber | FK: customerNumber).
OrderDetails (FT): Tabla de rotura o detalle que desglosa cada producto dentro de un pedido. (PK Compuesta: orderNumber, productCode).

🗓️ Tabla de Inteligencia (Dimensión)

DIM_CALENDAR: Tabla extendida para realizar análisis temporales avanzados por año, mes o días festivos. (PK: date_id).

🔑 Resumen de Claves para el Proyecto

Total de Tablas: 9.

•Llaves Primarias (PK): Garantizan que cada registro sea único (ej. cada empleado tiene un ID irrepetible).
•Llaves Foráneas (FK): Establecen los puentes de relación (ej. conectan un pedido con un cliente específico).
•Claves Compuestas: Presentes en OrderDetails y Payments, donde se requieren dos columnas para identificar de forma única una fila.

Constraints (Restricciones) e Índices:

•	Integridad: Se definieron restricciones NOT NULL en campos críticos como precios y nombres.
•	Relaciones: ON DELETE RESTRICT para evitar borrar clientes que tienen pedidos históricos activos.
•	Índices: Además de los índices automáticos de las PK, se sugiere la creación de índices en orderDate y status para acelerar el filtrado en el EDA.

Vistas y Funciones:

•	Vista vw_resumen_geografico: Consolida ventas por país para dashboards de alta dirección.
•	Funciones Ventana: Implementación de RANK() para clasificar el rendimiento de empleados sin necesidad de subconsultas pesadas.

Granularidad y Alcance:

Representación: Cada fila en orderdetails representa un producto específico dentro de un pedido. La granularidad es a nivel de línea de ticket.
Alcance: El proyecto cubre desde la entrada del pedido hasta el pago, pero queda fuera la gestión logística de envíos en tiempo real o devoluciones.

Justificación de Normalización:

La base de datos está en 3ra Forma Normal (3NF). Esto evita la duplicidad de datos (ej. no repetimos la dirección del cliente en cada pedido, solo su ID) y garantiza la integridad referencial.

3. 📈 CALIDAD DEL EDA: Métricas y KPIs

El análisis no solo extrae datos, sino que genera indicadores clave de rendimiento (KPIs):

1.	Ticket Promedio (AOV): Calculado mediante la relación entre total_pagado y número de pedidos.
2.	Ratio de Cumplimiento (Order Fill Rate): Identificando pedidos 'On Hold' vs 'Shipped'.
3.	Balance de Cartera: Diferencia entre lo facturado (Orders) y lo cobrado (Payments) en el periodo 2004.
4.	Concentración de Ventas: Uso de CTEs para identificar el Top 10% de clientes que generan el 80% de los ingresos (Análisis de Pareto).
   
🔧 Instrucciones de Instalación

1.	Revisa Model_Diagrama_classicmodels (diagrama de relaciones de la Base de Datos).
2.	Ejecutar 01_schema_02_data.sql Parte 1 (Crea tablas, relaciones y la DIM_CALENDAR).
3.	Ejecutar 01_schema_02_data.sql Parte 2 (Puebla las tablas bajo control de transacciones). 
4.	Ejecutar 03_eda.sql (Genera los reportes de KPIs y vistas analíticas).
5.	Leer README resumen de la actividad.


