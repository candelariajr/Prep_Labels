drop database if exists prep_labels;
use prep_labels; 

create table if not exists color_scheme(
	id int not null auto_increment primary key, 
    scheme_name varchar(64) unique,
    hex_back_color char(6),
    hex_text_color char(6)
);
insert into color_scheme (id, scheme_name, hex_back_color, hex_text_color) values
(-1, 'Unspecified', '000000', 'ffffff');

create table if not exists label_categories(
	id int not null auto_increment primary key,
    display_name varchar(64) unique,
    display_order int,
    hex_text_color char(6), 
    hex_text_background char(6),
    color_scheme int default -1 references color_scheme.id
);

create table if not exists prep_location(
	id int not null auto_increment primary key, 
    display_name varchar(64) unique,
    
    display_order int
);

create table if not exists label_data(
	id int not null auto_increment primary key, 
    label_name varchar(128) unique, 
    thaw_hours int, 
    hold_time_hours int not null,
    hold_time_round_24 boolean,
	color_scheme_override boolean, 
    hex_back_color char(6),
    hex_text_color char(6)
);

select * from color_scheme;
insert into color_scheme (scheme_name, hex_back_color, hex_text_color) values
('Teal', 'ffffff', 'eeeeee');
select * from color_scheme;

insert into label_categories () values 
  ();
