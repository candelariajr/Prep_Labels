drop database if exists prep_labels;
create database prep_labels;
use prep_labels; 

create table if not exists color_scheme(
	id int not null auto_increment primary key, 
    scheme_name varchar(64) unique,
    hex_back_color char(6),
    hex_text_color char(6)
);
insert into color_scheme (id, scheme_name, hex_back_color, hex_text_color) values
(-1, 'Unspecified Scheme', 'ffffff', '000000');

insert into color_scheme (scheme_name, hex_back_color, hex_text_color) values
('Prep Non-Cooler Scheme', 'ba4a00', 'ffffff'),
('Prep Meat Cooler Scheme', 'c0392b', 'ffffff'),
('Prep Non-Meat Cooler Scheme', '1e8449', 'ffffff'),
('Prep From-Frozen Scheme', 'b7950b', 'ffffff');

create table if not exists label_categories(
	id int not null auto_increment primary key,
    display_name varchar(64) not null unique,
    display_order int default 0,
    hex_text_color char(6) default '000000', 
    hex_text_background char(6) default 'ffffff',
    color_scheme int not null default -1 references color_scheme.id
);

insert into label_categories (display_name, display_order, color_scheme) values
('Prep Non-Cooler', 1, 1),
('Prep Meat Item Cooler', 2, 2),
('Prep Non-Meat Item Cooler', 3, 3),
('Prep From-Frozen', 4, 4);

select
	label_categories.id,
	label_categories.display_name, 
    color_scheme.hex_back_color as background_color, 
    color_scheme.hex_text_color as text_color 
from 
	label_categories left outer join color_scheme on label_categories.color_scheme = color_scheme.id 
order by 
	label_categories.display_order asc;

create table if not exists prep_location(
	id int not null auto_increment primary key, 
    display_name varchar(64) unique,
    display_order int,
    color_scheme int default -1 references color_scheme.id
);

create table if not exists label_data(
	id int not null auto_increment primary key, 
    display_order int default 0,
    label_name varchar(128) unique, 
    thaw_hours int, 
    hold_time_hours int not null,
    hold_time_round_24 boolean default false,
	color_scheme_override boolean, 
    hex_back_color char(6) default '000000',
    hex_text_color char(6) default 'ffffff'
);
