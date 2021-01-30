--Creating Tables
CREATE TABLE car (
  vin_id SERIAL PRIMARY KEY,
  color VARCHAR(100),
  make VARCHAR(100),
  model VARCHAR(100),
  _year NUMERIC(4)
);

CREATE TABLE salesperson (
  salesperson_id SERIAL PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  sales_hire_date DATE
);

CREATE TABLE customer (
  customer_id SERIAL PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  birth_date DATE,
  email VARCHAR(150)
);

CREATE TABLE mechanic (
  mechanic_id SERIAL PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  mech_hire_date DATE
);

CREATE TABLE services (
  services_id SERIAL PRIMARY KEY,
  services_name VARCHAR(150)
);

CREATE TABLE parts (
  part_id SERIAL PRIMARY KEY,
  part_name VARCHAR(150),
  part_cost NUMERIC(10,2),
  part_quantity INTEGER
);

CREATE TABLE service_invoice (
  invoice_id SERIAL PRIMARY KEY,
  date_serviced DATE,
  customer_id INTEGER NOT NULL,
  part_id INTEGER NOT NULL,
  vin_id INTEGER NOT NULL,
  FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
  FOREIGN KEY(part_id) REFERENCES parts(part_id),
  FOREIGN KEY(vin_id) REFERENCES car(vin_id)
);

CREATE TABLE sale_invoice (
  invoice_num SERIAL PRIMARY KEY,
  date_sold DATE,
  amount NUMERIC(10,2),
  msrp NUMERIC(10,2),
  customer_id INTEGER NOT NULL,
  vin_id INTEGER NOT NULL,
  FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
  FOREIGN KEY(vin_id) REFERENCES car(vin_id)
  
);

CREATE TABLE salesperson_invoice (
  salesperson_id INTEGER NOT NULL,
  invoice_num INTEGER NOT NULL,
  FOREIGN KEY(salesperson_id) REFERENCES salesperson(salesperson_id),
  FOREIGN KEY(invoice_num) REFERENCES sale_invoice(invoice_num)
);

CREATE TABLE labor (
  labor_cost NUMERIC(10,2),
  invoice_id INTEGER NOT NULL,
  mechanic_id INTEGER NOT NULL,
  services_id INTEGER NOT NULL,
  FOREIGN KEY(invoice_id) REFERENCES service_invoice(invoice_id),
  FOREIGN KEY(mechanic_id) REFERENCES mechanic(mechanic_id),
  FOREIGN KEY(services_id) REFERENCES services(services_id)
);

--Inserting Elements 
INSERT INTO customer(customer_id, first_name, last_name, birth_date, email)
VALUES(1,'Arpi','Saqui', '1994-03-03', 'asaqui@email.com');

INSERT INTO car(vin_id, color, make, model, _year)
VALUES(1001, 'Black', 'Jeep', 'Wrangler', 2020);

INSERT INTO salesperson(salesperson_id, first_name, last_name, sales_hire_date)
VALUES(1, 'Bob', 'Seller', '2021-01-01');

INSERT INTO sale_invoice(invoice_num, date_sold, amount, msrp, customer_id, vin_id)
VALUES(1, '2021-01-29', 30000.00, 31000.00, 1, 1001);

INSERT INTO salesperson_invoice(salesperson_id, invoice_num)
VALUES(1, 1);


--STORED FUNCTION- Car
CREATE OR REPLACE FUNCTION add_car(_vin_id INTEGER, _color VARCHAR, _make VARCHAR, _model VARCHAR, _year_ NUMERIC)
RETURNS void
AS $MAIN$ 
BEGIN 
	INSERT INTO car(vin_id, color, make, model, _year)
	VALUES(_vin_id, _color, _make, _model, _year_);
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_car(1002, 'White', 'BMW', 'X4', 2020);
SELECT add_car(1003, 'Pink', 'Cadillac', 'Series 62', 1963);

-- STORED FUNCTION- Sales Person
CREATE OR REPLACE FUNCTION add_salesperson(_salesperson_id INTEGER, _first_name VARCHAR, _last_name VARCHAR, _sales_hire_date DATE)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO salesperson(salesperson_id, first_name, last_name, sales_hire_date)
	VALUES(_salesperson_id, _first_name, _last_name, _sales_hire_date);
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_salesperson(2, 'Larry', 'Dealer', '2019-03-15');
SELECT add_salesperson(3, 'Victor', 'Vender', '2020-01-29');

-- STORED FUNCTION- Customer
CREATE OR REPLACE FUNCTION add_customer(_customer_id INTEGER, _first_name VARCHAR, _last_name VARCHAR, _birth_date DATE, _email VARCHAR)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO customer(customer_id, first_name, last_name, birth_date, email)
	VALUES(_customer_id, _first_name, _last_name, _birth_date, _email);
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_customer(2, 'Sandy', 'Kaur', '1994-02-14', 'sandykaur@email.com');
SELECT add_customer(3, 'Carmen', 'Sanchez', '1989-07-29', 'csanchez@email.com');

--STORED FUNCTION- Mechanic
CREATE OR REPLACE FUNCTION add_mechanic(_mechanic_id INTEGER, _first_name VARCHAR, _last_name VARCHAR, _mech_hire_date DATE)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO mechanic(mechanic_id, first_name, last_name, mech_hire_date)
	VALUES(_mechanic_id, _first_name, _last_name, _mech_hire_date);
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_mechanic(1, 'Jerry', 'Fixer', '2020-01-01');
SELECT add_mechanic(2, 'Sammy', 'Carburetor', '2018-01-01');

--STORED FUNCTION- Services
CREATE OR REPLACE FUNCTION add_services(_services_id INTEGER, _services_name VARCHAR)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO services(services_id, services_name)
	VALUES(_services_id, _services_name);
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_services(1, 'General Auto Diagnostics');
SELECT add_services(2, 'Clutch And Transmission');
SELECT add_services(3, 'Brakes');
SELECT add_services(4, 'Belt');
SELECT add_services(5, 'Battery');
SELECT *
FROM services;

--STORED FUNCTION- Parts
CREATE OR REPLACE FUNCTION add_parts(_part_id INTEGER, _part_name VARCHAR, _part_cost NUMERIC, _part_quantity INTEGER)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO parts(part_id, part_name, part_cost, part_quantity)
	VALUES(_part_id, _part_name, _part_cost, _part_quantity);
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_parts(1, 'Brakes', 45.00, 2);
SELECT add_parts(2, 'Wheels', 200.00, 4);

--STORED FUNCTION- Serivce Invoice
CREATE OR REPLACE FUNCTION add_service_invoice(_invoice_id INTEGER, _date_serviced DATE, _customer_id INTEGER, _vin_id INTEGER, _part_id INTEGER)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO service_invoice(invoice_id, date_serviced, customer_id, vin_id, part_id)
	VALUES(_invoice_id, _date_serviced, _customer_id, _vin_id, _part_id);
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_service_invoice(1, '2021-01-29', 2, '1003', '1');
SELECT add_service_invoice(2, '2021-01-29', 3, '1002', '2');

--CREATE FUNCTION- Sale Invoice
CREATE OR REPLACE FUNCTION add_sale_invoice(_invoice_num INTEGER, _date_sold DATE, _amount NUMERIC, _msrp NUMERIC, _customer_id INTEGER, _vin_id INTEGER)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO sale_invoice(invoice_num, date_sold, amount, msrp, customer_id, vin_id)
	VALUES(_invoice_num, _date_sold, _amount, _msrp, _customer_id, _vin_id);
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_sale_invoice(2, '2021-01-29', 40000.00, 41000.00, 2, '1003');
SELECT add_sale_invoice(3, '2021-01-29', 50000.00, 51000.00, 3, '1002');

--CREATE FUNCTION- Sales Person Invoice
CREATE OR REPLACE FUNCTION add_salesperson_invoice(_salesperson_id INTEGER, _invoice_num INTEGER)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO salesperson_invoice(salesperson_id, invoice_num)
	VALUES(_salesperson_id, _invoice_num);
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_salesperson_invoice(1, 2);
SELECT add_salesperson_invoice(2,3);
SELECT add_salesperson_invoice(3,1);

--CREATE FUNCTION- Labor
CREATE OR REPLACE FUNCTION add_labor(_labor_cost NUMERIC, _invoice_id INTEGER, _mechanic_id INTEGER, _services_id INTEGER)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO labor(labor_cost, invoice_id, mechanic_id, services_id)
	VALUES(_labor_cost, _invoice_id, _mechanic_id, _services_id);
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_labor(50.00, 2, 1, 4);
SELECT add_labor(60.00, 1, 2, 5);

--I realized Requirement #9 was not being fulfilled:
ALTER TABLE service_invoice
ALTER COLUMN part_id DROP NOT NULL;

CREATE OR REPLACE FUNCTION add_optional_service_invoice(_invoice_id INTEGER, _date_serviced DATE, _customer_id INTEGER, _vin_id INTEGER, _part_id INTEGER)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO service_invoice(invoice_id, date_serviced, customer_id, vin_id, part_id)
	VALUES(_invoice_id, _date_serviced, _customer_id, _vin_id, _part_id);
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_service_invoice(3, '2021-01-29', 1, '1001');
