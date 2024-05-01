CREATE TABLE reservation(
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_name varchar(250) NOT NULL,
    pickup_address varchar(200) NOT NULL,
    address varchar(200) NOT NULL,
    pickup_date timestamp NOT NULL,
    created_at timestamp NOT NULL,
    is_completed boolean default false,
    PRIMARY KEY (id)
);
