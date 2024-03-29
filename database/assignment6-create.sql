-- 
--  Type Creation
-- 
CREATE TYPE public.inventory_status_type AS ENUM ('Pending', 'Approved', 'New Arrival');
CREATE TYPE public.vehicle_status_type AS ENUM ('Available', 'Sold');
CREATE TYPE public.account_type AS ENUM ('Client', 'Admin', 'Employee');
CREATE TYPE public.employee_type AS ENUM ('Sales Consultant', 'Service Technicians', 'Service Advisors', 'Finance Advisors', 'Parts Specialists', 'Receptionists', 'Lot Attendants', 'Office Administrators', 'Marketing Managers', 'General Manager');

ALTER TYPE public.inventory_status_type
    OWNER TO cse340emha_user;

ALTER TYPE public.vehicle_status_type
    OWNER TO cse340emha_user;

ALTER TYPE public.account_type
    OWNER TO cse340emha_user;

ALTER TYPE public.employee_type
    OWNER TO cse340emha_user;

-- 
--  Table Creation
-- 

-- Table.structure for table `classification`
CREATE TABLE public.classification (
	classification_id INT GENERATED BY DEFAULT AS IDENTITY,
	classification_name CHARACTER VARYING NOT NULL,
	CONSTRAINT classification_pk PRIMARY KEY (classification_id)
);

-- Table structure for table `inventory`
CREATE TABLE IF NOT EXISTS public.inventory
(
	inv_id integer NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	inv_make character varying NOT NULL,
	inv_model character varying NOT NULL,
	inv_year character(4) NOT NULL,
	inv_description text NOT NULL,
	inv_image character varying NOT NULL,
	inv_thumbnail character varying NOT NULL,
	inv_price numeric(9,0) NOT NULL,
	inv_miles integer NOT NULL,
	inv_color character varying NOT NULL,
	classification_id integer NOT NULL,
	CONSTRAINT inventory_pkey PRIMARY KEY (inv_id)
);

-- Table structure for table `account`
CREATE TABLE IF NOT EXISTS public.account
(
    account_id integer NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    account_firstname character varying NOT NULL,
    account_lastname character varying NOT NULL,
    account_email character varying NOT NULL,
    account_password character varying NOT NULL,
    account_type account_type NOT NULL DEFAULT 'Client'::account_type,
    CONSTRAINT account_pkey PRIMARY KEY (account_id)
);

-- Table structure for table `employee`
CREATE TABLE IF NOT EXISTS public.employee
(
    emp_id INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    emp_firstname CHARACTER VARYING NOT NULL,
    emp_lastname CHARACTER VARYING NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(12, 2),
    employee_type employee_type NOT NULL DEFAULT 'Sales Consultant'::employee_type,
    account_id INTEGER NOT NULL,
    CONSTRAINT employee_pkey PRIMARY KEY (emp_id),
    CONSTRAINT employee_account_fk FOREIGN KEY (account_id) REFERENCES public.account (account_id)
);


-- Table structure for table `vehicle_status`
CREATE TABLE IF NOT EXISTS public.vehicle_status (
    vehicle_status_id SERIAL PRIMARY KEY,
    vehicle_status_type vehicle_status_type NOT NULL DEFAULT 'Available'::vehicle_status_type,
    inv_id INTEGER NOT NULL,
    CONSTRAINT vehicle_status_inventory_fk FOREIGN KEY (inv_id) REFERENCES public.inventory (inv_id)
);

-- Table structure for table `inventory_status`
CREATE TABLE IF NOT EXISTS public.inventory_status (
    inv_status_id SERIAL PRIMARY KEY,
    inventory_status_type inventory_status_type NOT NULL DEFAULT 'New Arrival'::inventory_status_type,
    inv_id INTEGER NOT NULL,
    CONSTRAINT inventory_status_inventory_fk FOREIGN KEY (inv_id) REFERENCES public.inventory (inv_id)
);

-- Table structure for table `maintenance_history`
CREATE TABLE IF NOT EXISTS public.maintenance_history (
    maintenance_history_id SERIAL PRIMARY KEY,
    maintenance_date DATE,
    maintenance_type VARCHAR(255),
    maintenance_description TEXT,
    cost DECIMAL(10,2),
    parts_replaced TEXT[],
    notes TEXT,
    emp_id INTEGER NOT NULL,
    inv_id INTEGER NOT NULL,
    inv_status_id INTEGER NOT NULL,
    CONSTRAINT maintenance_employee_fk FOREIGN KEY (emp_id) REFERENCES public.employee (emp_id),
    CONSTRAINT maintenance_inventory_fk FOREIGN KEY (inv_id) REFERENCES public.inventory (inv_id),
    CONSTRAINT maintenance_status_fk FOREIGN KEY (inv_status_id) REFERENCES public.inventory_status (inv_status_id)
);
