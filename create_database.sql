drop database if exists prep_labels;
create database prep_labels;
use prep_labels; 

# BEGIN DML

create table if not exists color_scheme(
	id int not null auto_increment primary key, 
    scheme_name varchar(64) unique,
    hex_back_color char(6),
    hex_text_color char(6)
);
# STATIC MDL POINT
insert into color_scheme (id, scheme_name, hex_back_color, hex_text_color) values
(-1, 'Unspecified Scheme', 'ffffff', '000000');

create table if not exists label_categories(
	id int not null auto_increment primary key,
    display_name varchar(64) not null unique,
    display_order int default 0,
    -- hex_text_color char(6) default '000000', 
    -- hex_text_background char(6) default 'ffffff',
    color_scheme int not null default -1 references color_scheme.id
);
create table if not exists prep_location(
	id int not null auto_increment primary key, 
    display_name varchar(64) unique,
    display_order int default 0,
    color_scheme int default -1 references color_scheme.id
);
# STATIC MDL POINT
insert into prep_location (id, display_name) values 
(id, 'Unspecified Location');

create table if not exists label_data(
	id int not null auto_increment primary key, 
    display_order int default 0,
    label_name varchar(128) unique,
    label_category int not null references label_categoties.id,
    location_id int not null default -1 references prep_location.id ,
    thaw_hours int, 
    hold_time_hours int not null,
    hold_time_round_24 boolean default false,
	color_scheme_override boolean default false, 
    hex_back_color char(6) default '000000',
    hex_text_color char(6) default 'ffffff'
);
# END MINIMAL OPERATION DATA INSERTION

# BEGIN KNOWN PILOT OPERATION DATA INSERTION 

insert into label_categories (display_name, display_order, color_scheme) values
('Prep Non-Cooler', 1, 1),
('Prep Meat Item Cooler', 2, 2),
('Prep Non-Meat Item Cooler', 3, 3),
('Prep From-Frozen', 4, 4);

# Category IDs With Given Labels
# 1 - Prep Non-Cooler
# 2 - Prep Meat Item Cooler
# 3 - Prep Non-Meat Item Cooler
# 4 - Prep From Frozen

insert into color_scheme (scheme_name, hex_back_color, hex_text_color) values
('Prep Non-Cooler Scheme', 'ba4a00', 'ffffff'),
('Prep Meat Cooler Scheme', 'c0392b', 'ffffff'),
('Prep Non-Meat Cooler Scheme', '1e8449', 'ffffff'),
('Prep From-Frozen Scheme', 'b7950b', 'ffffff');

insert into label_data (label_name, label_category, thaw_hours, hold_time_hours, hold_time_round_24) values 
('Prep. Cinnamon Roll', 1, 0, 72, false),
('Open Sliced Cheese', 2, 0, 108, false),
('Prep Lettuce Cooler', 2, 0, 24, true),
('Prep Tomatoes Cooer', 2, 0, 24, true),
('Diced Onions Cooler', 2, 0, 24, true),
('Sliced Onions Cooler', 2, 0, 24, true),
('Ham N Cheese', 3, 0, 48, true),
('Prepped Bacon', 3, 0, 48, false),
('Crumbled Sausage', 3, 0, 24, false),
('Frisco Ham', 3, 0, 48, true), 
('Chili', 4, 12, 72, true),
('Mushrooms', 4, 12, 72, true),
('Sliced Ham', 4, 12, 96, false),
('Char Chicken', 4, 12, 120, true),
('Premium Bun Pack', 4, 12, 120, true),
('Hot Dogs Unopened', 4, 24, 144, true),
('Hot Dogs Opened', 3, 0, 144, true);

# DEMONSTRATION OF OPERATIONAL DATA FUNCTIONALITY

select
	label_categories.id,
	label_categories.display_name, 
    color_scheme.hex_back_color as background_color, 
    color_scheme.hex_text_color as text_color 
from 
	label_categories left outer join color_scheme on label_categories.color_scheme = color_scheme.id 
order by 
	label_categories.display_order asc;
    
    
create view display_panel as     
select 
	label_data.id, 
    label_categories.display_name,
    label_data.label_name,
    case
		when label_data.color_scheme_override = 1 THEN
			label_data.hex_back_color
		else
			color_scheme.hex_back_color
		end
	as hex_back_color,
	case
		when label_data.color_scheme_override = 1 THEN
			label_data.hex_text_color
		else
			color_scheme.hex_text_color
		end
	as hex_text_color
from
	label_data left outer join label_categories on label_data.label_category = label_categories.id
    left outer join color_scheme on color_scheme.id = label_categories.color_scheme
order by
	label_categories.display_order asc, 
    label_data.display_order asc,
    label_name asc;
