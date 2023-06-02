-- Switch to DB "redes"
\c redes

-- Create table "restaurants"
CREATE TABLE IF NOT EXISTS restaurants (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

-- Insert mock data
INSERT INTO restaurants (name, address, phone, email) VALUES
    ('Papa John''s', '123 Main St', '555-555-5555', 'info@papajohns.com'),
    ('McDonald''s', '456 Oak St', '555-555-5555', 'info@mcdonalds.com'),
    ('Subway', '789 Elm St', '555-555-5555', 'info@subway.com'),
    ('Burger King', '321 Maple St', '555-555-5555', 'info@burgerking.com'),
    ('Taco Bell', '654 Birch St', '555-555-5555', 'info@tacobell.com'),
    ('Pizza Hut', '987 Pine St', '555-555-5555', 'info@pizzahut.com'),
    ('KFC', '741 Cedar St', '555-555-5555', 'info@kfc.com'),
    ('Chick-fil-A', '852 Walnut St', '555-555-5555', 'info@chickfila.com'),
    ('Wendy''s', '369 Chestnut St', '555-555-5555', 'info@wendys.com'),
    ('Domino''s', '147 Spruce St', '555-555-5555', 'info@dominos.com'),
    ('Starbucks', '258 Oak Ln', '555-555-5555', 'info@starbucks.com'),
    ('Panera Bread', '741 Maple Ave', '555-555-5555', 'info@panerabread.com'),
    ('Dunkin'' Donuts', '987 Elmwood Dr', '555-555-5555', 'info@dunkindonuts.com'),
    ('Chipotle', '456 Main St', '555-555-5555', 'info@chipotle.com'),
    ('Olive Garden', '741 Oak Ave', '555-555-5555', 'info@olivegarden.com'),
    ('Red Lobster', '852 Cedar Dr', '555-555-5555', 'info@redlobster.com'),
    ('Applebee''s', '369 Pine Blvd', '555-555-5555', 'info@applebees.com'),
    ('Outback Steakhouse', '654 Walnut Ln', '555-555-5555', 'info@outbacksteakhouse.com'),
    ('TGI Fridays', '147 Spruce Dr', '555-555-5555', 'info@tgifridays.com'),
    ('O''Charley''s', '258 Elmwood Ave', '555-555-5555', 'info@ocharleys.com'),
    ('LongHorn Steakhouse', '741 Maple Ln', '555-555-5555', 'info@longhornsteakhouse.com'),
    ('Cracker Barrel', '987 Oakwood Dr', '555-555-5555', 'info@crackerbarrel.com'),
    ('IHOP', '456 Pine St', '555-555-5555', 'info@ihop.com'),
    ('Denny''s', '741 Walnut St', '555-555-5555', 'info@dennys.com'),
    ('Texas Roadhouse', '369 Cedar Ave', '555-555-5555', 'info@texasroadhouse.com'),
    ('Cheesecake Factory', '654 Chestnut Ln', '555-555-5555', 'info@cheesecakefactory.com'),
    ('Panda Express', '147 Birch Dr', '555-555-5555', 'info@pandaexpress.com'),
    ('Five Guys', '258 Cedar St', '555-555-5555', 'info@fiveguys.com'),
    ('Jersey Mike''s Subs', '741 Chestnut Ave', '555-555-5555', 'info@jerseymikes.com'),
    ('Jimmy John''s', '369 Spruce Blvd', '555-555-5555', 'info@jimmyjohns.com'),
    ('Waffle House', '654 Elmwood Dr', '555-555-5555', 'info@wafflehouse.com'),
    ('Steak ''n Shake', '147 Pine Ave', '555-555-5555', 'info@steaknshake.com'),
    ('Moe''s Southwest Grill', '258 Oakwood Ln', '555-555-5555', 'info@moes.com'),
    ('Sonic Drive-In', '741 Maple Dr', '555-555-5555', 'info@sonicdrivein.com');