DROP TABLE IF EXISTS Bookings;

DROP TABLE IF EXISTS Matches;

DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    user_id serial primary key,
    full_name varchar(100) not null,
    email varchar(150) unique not null,
    role varchar(50) check (role in ('Ticket Manager', 'Football Fan')) not null,
    phone_number varchar(20) unique
);

CREATE TABLE Matches (
    match_id serial primary key,
    fixture varchar(220) not null,
    tournament_category varchar(180) not null,
    base_ticket_price smallint check (base_ticket_price >= 0) not null,
    match_status varchar(50) check (
        match_status in (
            'Available',
            'Selling Fast',
            'Sold Out',
            'Postponed'
        )
    ) not null
);

CREATE TABLE Bookings (
    booking_id serial primary key,
    user_id smallint references Users (user_id) not null,
    match_id smallint references Matches (match_id) not null,
    seat_number varchar(60),
    payment_status varchar(30) check (
        payment_status in ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
    ),
    total_cost smallint check (total_cost >= 0) not null
);