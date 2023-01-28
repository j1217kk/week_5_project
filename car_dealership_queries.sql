CREATE TABLE "Customer" (
  "customer_id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100),
  "phone" VARCHAR(15)
);

CREATE TABLE "Mechanic" (
  "mechanic_id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100)
);

CREATE TABLE "Salesperson" (
  "salesperson_id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR(100),
  "last_name" VARCHAR(100)
);

CREATE TABLE "Car" (
  "car_id" SERIAL PRIMARY KEY,
  "make" VARCHAR(100),
  "model" VARCHAR(100),
  "price" NUMERIC(9,2),
  "is_serviced" BOOLEAN,
  "was_purchased" BOOLEAN,
  "customer_id" INTEGER REFERENCES "Customer"(customer_id)
);

CREATE TABLE "Invoice" (
  "invoice_id" SERIAL,
  "car_id" INTEGER REFERENCES "Car"(car_id),
  "salesperson_id" INTEGER REFERENCES "Salesperson"(salesperson_id),
  "date" DATE
);

CREATE TABLE "Service_History" (
  "service_id" SERIAL PRIMARY KEY,
  "car_id" INTEGER REFERENCES "Car"(car_id),
  "date" DATE
);

CREATE TABLE "Service_Ticket" (
  "ticket_id" SERIAL PRIMARY KEY,
  "service_id" INTEGER REFERENCES "Service_History"(service_id),
  "cost" NUMERIC(9,2),
  "task" VARCHAR(200)
);



CREATE TABLE "Maintenance_History"(
  "maint_id" SERIAL PRIMARY KEY,
  "ticket_id" INTEGER REFERENCES "Service_Ticket"(ticket_id),
  "mechanic_id" INTEGER REFERENCES "Mechanic"(mechanic_id)
);

CREATE OR REPLACE FUNCTION add_customer(firstname VARCHAR, lastname VARCHAR, phoney VARCHAR)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Customer"
	(first_name, last_name, phone)
	VALUES(firstname, lastname, phoney);
END;
$MAIN$
LANGUAGE plpgsql;

DROP FUNCTION add_customer;

SELECT add_customer('John', 'Kim', '443-474-2430');
SELECT add_customer('Bilbo', 'Baggins', '697-732-4687');
SELECT add_customer('Golem', 'Smeagol', '697-732-4687');
SELECT add_customer('Mike', 'Tyson', '566-256-8844')

SELECT * FROM "Customer";

CREATE OR REPLACE FUNCTION add_salesperson(firstname VARCHAR, lastname VARCHAR)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Salesperson"
	(first_name, last_name)
	VALUES(firstname, lastname);
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_salesperson('Slimey', 'Dealer');
SELECT add_salesperson('Honest', 'Seller');
SELECT add_salesperson('Jan', 'Blachowicz');
SELECT add_salesperson('P', 'Diddy');
SELECT * FROM "Salesperson";

ALTER TABLE "Car"
DROP COLUMN is_serviced;

ALTER TABLE "Car"
ADD COLUMN is_serviced BOOLEAN;

ALTER TABLE "Car"
ADD COLUMN plate VARCHAR(7);

CREATE OR REPLACE FUNCTION add_car(make_ VARCHAR, model_ VARCHAR, price_ DECIMAL, purchased BOOLEAN, cust_id INTEGER, serviced BOOLEAN, platenum VARCHAR)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Car"
	(make, model, price,was_purchased, customer_id, is_serviced, plate)
	VALUES(make_, model_, price_, purchased, cust_id, serviced, platenum);
END;
$MAIN$
LANGUAGE plpgsql;


SELECT add_car('Hyundai', 'Genesis Coupe 3.8L', 20000, true, 1, true, '78GG1JK');
SELECT add_car('Honda', 'Accord', NULL, false, 1, true, '1DHLY0P');
SELECT add_car('Shire', 'Wagon', 75.99, true, 2, false, 'MYSHIR3');
SELECT add_car('Mountain', 'Warg', NULL, false, 3, true, 'PR5IOU5');
SELECT add_car('McLaren', 'P2', 220000, true, 4, false, 'GGKOEZ1');
SELECT add_car('Ferrari', 'F8 Tributo', 280000, true, 4, false, 'SP33DIN');


SELECT * FROM "Car";


CREATE OR REPLACE FUNCTION add_invoice(kar_id INTEGER, sales_id INTEGER, date_ DATE)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Invoice"
	(car_id, salesperson_id, date)
	VALUES(kar_id, sales_id, date_);
END;
$MAIN$
LANGUAGE plpgsql;


SELECT * FROM "Car";
SELECT add_invoice(3, 1, ('2021/07/21'));
SELECT add_invoice(5, 2, ('2023/01/27'));
SELECT add_invoice(7, 3, ('2023/01/01'));
SELECT add_invoice(8, 4, ('2022/04/10'));
SELECT * FROM "Invoice";


CREATE OR REPLACE FUNCTION add_Service_History(kar_id INTEGER, date_ DATE)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Service_History"
	(car_id, date)
	VALUES(kar_id, date_);
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_Service_History(3, ('2021/10/25'));
SELECT add_Service_History(3, ('2023/01/27'));
SELECT add_Service_History(6, ('2023/01/26'));
SELECT add_Service_History(4, ('2023/01/10'));

SELECT * FROM "Service_History";

CREATE OR REPLACE FUNCTION add_Service_Ticket(serv_id INTEGER, kost DECIMAL, tasque VARCHAR)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Service_Ticket"
	(service_id, "cost", task)
	VALUES(serv_id, kost, tasque);
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_Service_Ticket(1, 850.99, 'Replace broken radiator');
SELECT add_Service_Ticket(2, 100.00, 'Replace broken wipers');
SELECT add_Service_Ticket(3, 20.00, 'Lube wagon wheels');
SELECT add_Service_Ticket(4, 45.99, 'Oil change');

SELECT * FROM "Service_Ticket";

CREATE OR REPLACE FUNCTION add_Mechanic(firstname VARCHAR, lastname VARCHAR)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Mechanic"
	(first_name, last_name)
	VALUES(firstname, lastname);
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_Mechanic('Bob', 'Builder 2.0');
SELECT add_Mechanic('Jim', 'Brown');
SELECT add_Mechanic('Tom', 'Cruise');
SELECT add_Mechanic('Yao', 'Ming');

SELECT * FROM "Mechanic";

CREATE OR REPLACE FUNCTION add_Maint_History(tick INTEGER, mech INTEGER)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO "Maintenance_History"
	(ticket_id, mechanic_id)
	VALUES(tick, mech);
END;
$MAIN$
LANGUAGE plpgsql;

SELECT add_Maint_History(1, 1);
SELECT add_Maint_History(1, 3);
SELECT add_Maint_History(2, 1);
SELECT add_Maint_History(2, 2);
SELECT add_Maint_History(3, 4);
SELECT add_Maint_History(4, 4);

SELECT * FROM "Maintenance_History";

CREATE OR REPLACE PROCEDURE checkPurchased()
LANGUAGE plpgsql
AS $$
BEGIN
	--Checks for whether car was purchased
	--If it is not, set price to $0 as it was not bought at dealership
	UPDATE "Car"
	SET price = 00.00
	WHERE was_purchased = false;
	
	COMMIT;
END;
$$


SELECT * FROM "Car";

UPDATE "Car"
SET price = 999.99
WHERE was_purchased = false;

CALL checkPurchased();

SELECT * FROM "Car";

