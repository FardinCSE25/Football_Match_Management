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

INSERT INTO
    Users (user_id, full_name, email, role, phone_number)
VALUES
    (
        1,
        'Tanvir Rahman',
        'tanvir@mail.com',
        'Football Fan',
        '+8801711111111'
    ),
    (
        2,
        'Asif Haque',
        'asif@mail.com',
        'Football Fan',
        '+8801722222222'
    ),
    (
        3,
        'Sajjad Rahman',
        'sajjad@mail.com',
        'Ticket Manager',
        '+8801733333333'
    ),
    (
        4,
        'Jannat Ara',
        'jannat@mail.com',
        'Football Fan',
        NULL
    );

INSERT INTO
    Matches (
        match_id,
        fixture,
        tournament_category,
        base_ticket_price,
        match_status
    )
VALUES
    (
        101,
        'Real Madrid vs Barcelona',
        'Champions League',
        150.00,
        'Available'
    ),
    (
        102,
        'Man City vs Liverpool',
        'Premier League',
        120.00,
        'Selling Fast'
    ),
    (
        103,
        'Bayern Munich vs PSG',
        'Champions League',
        130.00,
        'Available'
    ),
    (
        104,
        'AC Milan vs Inter Milan',
        'Serie A',
        90.00,
        'Sold Out'
    ),
    (
        105,
        'Juventus vs Roma',
        'Serie A',
        80.00,
        'Available'
    );

INSERT INTO
    Bookings (
        booking_id,
        user_id,
        match_id,
        seat_number,
        payment_status,
        total_cost
    )
VALUES
    (501, 1, 101, 'A-12', 'Confirmed', 150.00),
    (502, 1, 102, 'B-04', 'Confirmed', 120.00),
    (503, 2, 101, 'A-13', 'Confirmed', 150.00),
    (504, 2, 101, NULL, NULL, 150.00),
    (505, 3, 102, 'C-20', 'Pending', 120.00);



-- Queries :
select match_id, fixture, base_ticket_price from matches
where tournament_category = 'Champions League' and match_status = 'Available'


select user_id, full_name, email from users
where full_name ilike 'Tanvir%' or full_name ilike '%Haque'


select booking_id, user_id, match_id, coalesce(payment_status, 'Action Required') as systematic_status from bookings
where payment_status is null


select booking_id, full_name, fixture, total_cost from bookings
inner join users using(user_id)
inner join matches using(match_id)


select user_id, full_name, booking_id from bookings
full join users using(user_id)


select booking_id, match_id, total_cost from bookings
where total_cost > (select avg(total_cost) from bookings)


select match_id, fixture, base_ticket_price from matches
order by base_ticket_price desc
offset 1
limit 2