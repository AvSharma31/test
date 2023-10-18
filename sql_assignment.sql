use sqlassignment;

create table city(id int,
name varchar(17),
countrycode varchar(3),
district varchar(20),
population int);

#Q1
select * from city where countrycode = 'USA' and population > 100000;

#Q2
select name from city where countrycode = 'USA' and population > 120000;

#Q3
select * from city;

#Q4
select * from city where id = 1661;

#Q5
select * from city where countrycode = 'JPN';

#Q6
select name from city where countrycode = 'JPN';

create table station(
id int,
city varchar(21),
state varchar(2),
lat_n int,
long_n int);

#Q7
select city, state from station;

#Q8
select distinct city from station where id%2 = 0;

#Q9
select count(city)-count(distinct city) from station;

#Q10
(select city,length(city) from station order by length(city) desc,city asc limit 1)
union (select city,length(city) from station order by length(city),city limit 1);

#Q11
select distinct city from station where city regexp '^[aeiouAEIOU]';

#Q12
select distinct city from station where city regexp '[aeiouAEIOU]$';

#Q13
select distinct city from station where city not regexp '^[aeiouAEIOU]';

#Q14
select distinct city from station where city not regexp '[aeiouAEIOU]$';

#Q15
select distinct city from station where city not regexp '[aeiouAEIOU]$' 
and city not regexp '^[aeiouAEIOU]';

#Q16
select distinct city from station where city not regexp '[aeiouAEIOU]$' 
and city not regexp '^[aeiouAEIOU]';

#Q17
create table product(product_id int,
product_name varchar(30),
unit_price int, primary key (product_id));

create table sales(seller_id int,
product_id int,
buyer_id int,
sale_date date,
quantity int,
price int,
foreign key (product_id) references product(product_id));

(select p.product_id, p.product_name FROM
Product p
INNER JOIN
Sales s
on p.product_id = s.product_id
where s.sale_date >= '2019-01-01' and s.sale_date <= '2019-03-31')
EXCEPT
(select p.product_id, p.product_name FROM
Product p
INNER JOIN
Sales s
on p.product_id = s.product_id
where s.sale_date < '2019-01-01' OR s.sale_date > '2019-03-31');

#Q18
create table views(article_id int,
author_id int,
viewer_id int,
view_date date);

select distinct author_id as id from views where author_id = viewer_id order by
author_id;

#Q19
create table delivery(delivery_id int,
customer_id int,
order_date date,
customer_pref_delivery_date date,
primary key(delivery_id));

select round((select count(*) from delivery where order_date=customer_pref_delivery_date)*100/count(*),2)
as immediate_percentage from delivery;

#Q20
create table ads(ad_id int,
user_id int,
action enum('Clicked','Viewed','Ignored'),
primary key(ad_id,user_id));

select t.ad_id, (case
when base != 0 then round(t.num/t.base*100,2) else 0 end) as Ctr from (select
ad_id,
sum( case when action = 'clicked' or action = 'viewed' then 1 else 0 end) as
base,
sum( case when action = 'clicked' then 1 else 0 end) as num
from ads
group by ad_id)t
order by Ctr desc, t.ad_id asc;

#Q21
create table employee(employee_id int,
team_id int, primary key (employee_id));

select employee_id, count(team_id) over (partition by team_id) as team_size from
employee order by employee_id;

#Q22
create table countries(country_id int,
country_name varchar(30),
primary key(country_id));

create table weather(country_id int,
weather_state int,
day date,
primary key(country_id,day));

select c.country_name,
case when avg(w.weather_state)<=15 then 'Cold' 
when avg(w.weather_state)>=25 then 'Hot'
else 'Warm'
end as weather_type from countries c inner join weather w on c.country_id=w.country_id
where month(day)=11 group by c.country_id;
 
#Q23
create table prices(product_id int,
start_date date,
end_date date,
price int,
primary key(product_id,start_date,end_date));

create table unitssold(product_id int,purchase_date date,units int);

select p.product_id, round(sum(us.units*p.price)/sum(us.units),2) as average_price from prices p inner join unitssold us on
p.product_id=us.product_id where us.purchase_date >= start_date and us.purchase_date <= end_date
group by p.product_id;

#Q24
create table activity(player_id int,
device_id int,
event_date date,
games_played int,
primary key(player_id,event_date));

select t.player_id, event_date as first_login from (select player_id, 
event_date, row_number() over(partition by player_id order by event_date) as num 
from activity) t where t.num = 1; 

#Q25
select t.player_id, device_id as first_login from (select player_id, 
device_id, row_number() over(partition by player_id order by device_id) as num 
from activity) t where t.num = 1; 

#Q26
create table products(product_id int,
product_name varchar(30),
product_category varchar(30),
primary key(product_id));

create table orders(product_id int,
order_date date,
unit int,
foreign key(product_id) references products(product_id));

insert into orders values(1 ,'2020-02-05', 60),
(1, '2020-02-10', 70),
(2 ,'2020-01-18' ,30),
(2 ,'2020-02-11' ,80),
(3 ,'2020-02-17' ,2),
(3 ,'2020-02-24' ,3),
(4 ,'2020-03-01' ,20),
(4 ,'2020-03-04' ,30),
(4 ,'2020-03-04' ,60),
(5 ,'2020-02-25' ,50),
(5 ,'2020-02-27' ,50),
(5 ,'2020-03-01' ,50);

select p.product_name,sum(o.unit) from products p inner join orders o on p.product_id=o.product_id
 where month(o.order_date)=2 and year(o.order_date)=2020 group by p.product_name having sum(o.unit)>=100;

#Q27
create table users(user_id int,name varchar(30),mail varchar(30), primary key(user_id));
insert into users values(1, 'Winston','winston@leetcode.com'),
(2, 'Jonathan', 'jonathanisgreat'),
(3 ,'Annabelle','bella-@leetcode.com'),
(4, 'Sally','sally.come@leetcode.com'),
(5 ,'Marwan','quarz#2020@leetcode.com'),
(6 ,'David','david69@gmail.com'),
(7 ,'Shapiro','.shapo@leetcode.com');

select * from users where mail regexp '^[a-zA-Z]+[a-zA-Z0-9_./-]*@leetcode.com$'
and mail not regexp '#';

#Q28
create table customers(customer_id int,
name varchar(30),
country varchar(30),
primary key(customer_id));

create table product(product_id int,
description varchar(30),
price int,
primary key(product_id));

create table orders(order_id int,
customer_id int,
product_id int,
order_date date,
quantity int,
primary key(order_id));

insert into product values(10 ,'LC Phone', 300),
(20, 'LC T-Shirt' ,10),
(30, 'LC Book' ,45),
(40, 'LC Keychain', 2);

insert into orders values(1, 1, 10, '2020-06-10', 1),
(2 ,1 ,20, '2020-07-01' ,1),
(3, 1, 30, '2020-07-08', 2),
(4, 2, 10, '2020-06-15' ,2),
(5, 2, 40, '2020-07-01' ,10),
(6, 3 ,20, '2020-06-24' ,2),
(7, 3 ,30, '2020-06-25' ,2),
(9, 3 ,30, '2020-05-08' ,3);

select t.customer_id, t.name from
(select c.customer_id, c.name, 
sum(case when month(o.order_date) = 6 and year(o.order_date) = 2020 then
p.price*o.quantity else 0 end) as june_spent,
sum(case when month(o.order_date) = 7 and year(o.order_date) = 2020 then
p.price*o.quantity else 0 end) as july_spent
from
Orders o
left join
Product p
on o.product_id = p.product_id
left join
Customers c
on o.customer_id = c.customer_id
group by c.customer_id) t
where june_spent >= 100 and july_spent >= 100;

#Q29
create table tvprogram(program_date date,
content_id int,
channel varchar(30),
primary key(program_date,content_id));

create table content(content_id varchar(30),
title varchar(30),
kids_content enum('Y','N'),
content_type varchar(30),
primary key(content_id));

select distinct c.title from content c inner join tvprogram t on c.content_id=t.content_id 
where month(t.program_date)=6 and 
year(t.program_date)=2020 and 
kids_content='Y' and 
content_type='Movies';

#Q30

create table npv(id int,
year int,
npv int,
primary key(id,year));

create table queries(id int,
year int,
primary key(id,year));

select q.id,q.year,coalesce(n.npv,0) from npv n 
right join queries q on n.id=q.id and n.year=q.year order by q.id;

#Q31
select q.id,q.year,coalesce(n.npv,0) from npv n 
right join queries q on n.id=q.id and n.year=q.year order by q.id;

#Q32
create table employees(id int,name varchar(30),primary key(id));
create table employeeuni(id int,unique_id int,primary key(id,unique_id));
select eu.unique_id,e.name from employees e left join employeeuni eu on e.id=eu.id order by e.name;

#Q33
create table users(id int,name varchar(30), primary key(id));
create table rides(id int,user_id int, distance int,primary key(id));
insert into users values(1, 'Alice'),
(2 ,'Bob'),
(3 ,'Alex'),
(4 ,'Donald'),
(7 ,'Lee'),
(13, 'Jonathan'),
(19, 'Elvis');
select u.name, coalesce(sum(r.distance),0) as travelled_distance from users u left join rides r on u.id=r.user_id 
group by u.name order by sum(r.distance) desc;

#Q34
create table products(product_id int,
product_name varchar(30),
product_category varchar(30),
primary key(product_id));
create table orders(product_id int,
order_date date,
unit int);
insert into orders values(1, '2020-02-05', 60),
(1, '2020-02-10' ,70),
(2, '2020-01-18', 30),
(2, '2020-02-11' ,80),
(3, '2020-02-17' ,2),
(3, '2020-02-24' ,3),
(4, '2020-03-01' ,20),
(4, '2020-03-04' ,30),
(4, '2020-03-04' ,60),
(5, '2020-02-25' ,50),
(5, '2020-02-27' ,50),
(5, '2020-03-01' ,50);
select p.product_name, sum(o.unit) as amount from products p 
inner join orders o on p.product_id=o.product_id 
where month(o.order_date)=2 and year(o.order_date)=2020 group by p.product_id having amount>=100;

#Q35
create table movies(movie_id int,
title varchar(30), primary key(movie_id));
create table users(user_id int,
name varchar(30), primary key(user_id));
create table movierating(movie_id int,
user_id int,
rating int,
created_at date, primary key(movie_id,user_id));
insert into movies values(1, 'Avengers'),
(2 ,'Frozen 2'),
(3 ,'Joker');
insert into users values(1, 'Daniel'),
(2 ,'Monica'),
(3 ,'Maria'),
(4, 'James');
insert into movierating values(1, 1, 3, '2020-01-12'),
(1 ,2, 4 ,'2020-02-11'),
(1 ,3 ,2 ,'2020-02-12'),
(1 ,4 ,1 ,'2020-01-01'),
(2 ,1 ,5, '2020-02-17'),
(2 ,2 ,2 ,'2020-02-01'),
(2, 3 ,2 ,'2020-03-01'),
(3, 1 ,3 ,'2020-02-22'),
(3, 2 ,4, '2020-02-25');
(select u.name from users u inner join movierating mr on mr.user_id=u.user_id
inner join movies m on mr.movie_id=m.movie_id order by mr.rating desc,u.name limit 1)
union
(select m.title from movierating mr inner join movies m on m.movie_id=mr.movie_id where
month(mr.created_at)=2 and year(mr.created_at)=2020 
group by m.title order by avg(mr.rating) desc,m.title asc limit 1);

#Q36
create table users(id int,name varchar(30),primary key(id));
create table rides(id int,user_id int,distance int, primary key(id));
insert into users values(1, 'Alice'),
(2 ,'Bob'),
(3 ,'Alex'),
(4 ,'Donald'),
(7 ,'Lee'),
(13 ,'Jonathan'),
(19 ,'Elvis');
insert into rides values(1, 1, 120),
(2 ,2, 317),
(3 ,3 ,222),
(4 ,7, 100),
(5 ,13 ,312),
(6 ,19, 50),
(7 ,7 ,120),
(8 ,19, 400),
(9 ,7 ,230);
select u.name, coalesce(sum(r.distance),0) as travelled_distance from users u left join rides r on u.id=r.user_id 
group by u.name order by sum(r.distance) desc;

#Q37
create table employees(id int,name varchar(30),primary key(id));
create table employeeuni(id int,unique_id int,primary key(id,unique_id));
select eu.unique_id,e.name from employees e left join employeeuni eu on e.id=eu.id order by e.name;

#Q38
create table departments(id int,name varchar(30), primary key(id));
create table students(id int,name varchar(30),department_id int,primary key(id));
insert into departments values(1, 'Electrical Engineering'),
(7 ,'Computer Engineering'),
(13, 'Business Administration');
insert into students values(23, 'Alice', 1),
(1, 'Bob' ,7),
(5 ,'Jennifer', 13),
(2 ,'John' ,14),
(4 ,'Jasmine', 77),
(3 ,'Steve' ,74),
(6 ,'Luis' ,1),
(8 ,'Jonathan', 7),
(7 ,'Daiana' ,33),
(11, 'Madelynn', 1);
select s.id,s.name from students s where s.department_id not in (select id from departments);
#Q39
create table calls(from_id int,
to_id int,duration int);
insert into calls values(1, 2, 59),
(2 ,1, 11),
(1, 3 ,20),
(3, 4 ,100),
(3, 4 ,200),
(3, 4 ,200),
(4, 3 ,499);
select c.person1,c.person2,count(*) as call_count,sum(c.duration) as total_duration
from (select duration, 
case when from_id< to_id then from_id else to_id end as person1,
case when from_id>to_id then from_id else to_id end as person2 from calls ) c
group by c.person1,c.person2;

#Q40
create table prices(product_id int,
start_date date,
end_date date,
price int,
primary key(product_id,start_date,end_date));

create table unitssold(product_id int,purchase_date date,units int);

select p.product_id, round(sum(us.units*p.price)/sum(us.units),2) as average_price from prices p inner join unitssold us on
p.product_id=us.product_id where us.purchase_date >= start_date and us.purchase_date <= end_date
group by p.product_id;

#Q41
create table warehouse(name varchar(30),product_id int,units int,primary key(name,product_id));
create table products(product_id int, product_name varchar(30),width int,length int,height int, primary key(product_id));
insert into warehouse values('LCHouse1', 1, 1),
('LCHouse1' ,2, 10),
('LCHouse1' ,3 ,5),
('LCHouse2' ,1 ,2),
('LCHouse2' ,2 ,2),
('LCHouse3', 4 ,1);
insert into products values(1, 'LC-TV', 5, 50, 40),
(2, 'LC-KeyChain' ,5 ,5 ,5),
(3, 'LC-Phone', 2, 10, 10),
(4, 'LC-T-Shirt', 4, 10 ,20);

select w.name,sum(w.units*p.width*p.length*p.height) from warehouse w inner join products p
on w.product_id=p.product_id group by w.name;

#Q42
create table sales(sales_date date, fruit enum('apples','oranges'),sold_num int, primary key(sales_date,fruit));
insert into sales values(
'2020-05-01' ,'apples' ,10),
('2020-05-01' ,'oranges' ,8),
('2020-05-02' ,'apples' ,15),
('2020-05-02' ,'oranges' ,15),
('2020-05-03' ,'apples' ,20),
('2020-05-03' ,'oranges' ,0),
('2020-05-04' ,'apples' ,15),
('2020-05-04' ,'oranges' ,16);
select distinct sales_date, (t.sale_apple-t.sale_orange) as diff from (select sales_date, 
max(case when fruit='apples' then sold_num else 0 end) as sale_apple,
max(case when fruit='oranges' then sold_num else 0 end) as sale_orange
from sales group by sales_date) t order by sales_date;

#Q43
create table activity(player_id int,
device_id int,
event_date date,
games_played int,
primary key(player_id,event_date));

select round(t.player_id/(select count(distinct player_id) from activity),2) as fraction
from(select distinct player_id,
datediff(event_date, lead(event_date, 1) over(partition by player_id order by
event_date)) as diff
from activity ) t where diff = -1;
#Q44
create table employee(id int,name varchar(30),department varchar(30),managerid int,primary key(id));
insert into employee (id ,name,department) values(101, 'John', 'A');
insert into employee values(102 ,'Dan', 'A' ,101),
(103 ,'James', 'A', 101),
(104 ,'Amy' ,'A' ,101),
(105 ,'Anne', 'A' ,101),
(106 ,'Ron' ,'B' ,101);
select t.name from (select a.id,a.name,count(b.managerid) as no_of_direct_reports from employee a inner join
employee b on a.id=b.managerid group by b.managerid) t
where no_of_direct_reports >=5 order by t.name;

#Q45
create table student(student_id Int,
student_name Varchar(30),
Gender Varchar(10),
dept_id Int,primary key(student_id),
foreign key(dept_id) references department(dept_id));
create table department(dept_id int,dept_name varchar(30),primary key(Dept_id));
insert into student values(1, 'Jack', 'M', 1),
(2, 'Jane' ,'F' ,1),
(3 ,'Mark', 'M', 2);
insert into department values(1, 'Engineering'),
(2 ,'Science'),
(3, 'Law');
select d.dept_name ,count(s.student_id) as student_number
from department d left join student s on d.dept_id=s.dept_id
group by d.dept_id order by student_number desc,d.dept_name asc;

#Q46
create table customer(customer_id int,product_key int, foreign key(product_key) references product(product_key));
create table product(product_key int, primary key(product_key));
insert into product values(5),
(6);
insert into customer values(1, 5),
(2 ,6),
(3 ,5),
(3 ,6),
(1, 6);
select c.customer_id from customer c inner join product p 
on c.product_key=p.product_key group by c.customer_id having count(p.product_key)=2 ;

#Q47
create table employee(employee_id int,name varchar(30),experience_year int, primary key(employee_id));
create table project(project_id int,employee_id int, primary key(project_id,employee_id),
foreign key(employee_id) references employee(employee_id));
insert into employee values(1, 'Khaled', 3),
(2 ,'Ali', 2),
(3 ,'John', 3),
(4, 'Doe' ,2);
insert into project values(1, 1),
(1, 2),
(1 ,3),
(2 ,1),
(2 ,4);
select q.project_id,q.employee_id from (select p.project_id,e.employee_id, e.experience_year,dense_rank() 
over(partition by project_id order by e.experience_year desc) as num 
from project p left join 
employee e on p.employee_id=e.employee_id) q where num=1 order by q.project_id;

#Q48
create table books(book_id int, name varchar(30),available_from date, primary key(book_id));
create table orders(order_id int,book_id int,quantity int,dispatch_date date, primary key(order_id),
foreign key(book_id) references books(book_id));
insert into books values(1,'"Kalila And Demna"', '2010-01-01'	),
(2 ,'"28 Letters"', '2012-05-12'),
(3 ,'"The Hobbit"' ,'2019-06-10'),
(4,'"13 Reasons Why"', '2019-06-01'),
(5,'"The Hunger Games"', '2008-09-21');
insert into orders values(1, 1, 2, '2018-07-26'),
(2 ,1, 1 ,'2018-11-05'),
(3 ,3 ,8 ,'2019-06-11'),
(4 ,4 ,6 ,'2019-06-05'),
(5 ,4 ,5 ,'2019-06-20'),
(6 ,5 ,9 ,'2009-02-02'),
(7, 5 ,8, '2010-04-13');

select b.book_id,b.name,sum(o.quantity) from books b left join orders o on b.book_id=o.book_id
where b.available_from<'2019-06-23' group by b.book_id;

select t1.book_id, t1.name,t2.quantity
from
(
(select book_id, name from Books where
available_from < '2019-05-23') t1
left join
(select book_id, sum(quantity) as quantity
from Orders
where dispatch_date > '2018-06-23' and dispatch_date<= '2019-06-23'
group by book_id) t2
on t1.book_id = t2.book_id
);
#Q49
create table enrollments(student_id int,course_id int,grade int,primary key(student_id, course_id));
insert into enrollments values(2, 2, 95),
(2 ,3, 95),
(1 ,1 ,90),
(1 ,2 ,99),
(3 ,1 ,80),
(3 ,2 ,75),
(3, 3 ,82);
select e.student_id,e.course_id,e.grade from (select *,dense_rank() 
over(partition by student_id order by grade desc,course_id) as num from enrollments) e
where num=1 order by student_id;

#Q50
create table players(player_id int,group_id varchar(30),primary key(player_id));
create table matches(match_id Int,
first_player Int,
second_player Int,
first_score Int,
second_score Int, primary key(match_id));
insert into players values(15, 1),
(25 ,1),
(30 ,1),
(45 ,1),
(10 ,2),
(35 ,2),
(50 ,2),
(20 ,3),
(40, 3);
insert into matches values(1, 15, 45, 3, 0),
(2 ,30, 25 ,1, 2),
(3 ,30 ,15 ,2 ,0),
(4 ,40 ,20 ,5 ,2),
(5, 35 ,50, 1 ,1);

select t2.group_id, t2.player_id from
(select t1.group_id, t1.player_id, 
dense_rank() over(partition by group_id order by score desc, player_id) as r
from (select p.*, case when p.player_id = m.first_player then m.first_score
when p.player_id = m.second_player then m.second_score
end as score
from Players p, Matches m
where player_id in (first_player, second_player)) t1) t2
where r = 1;
