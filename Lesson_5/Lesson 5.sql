---PUBLIC DATABASE SH (Sales History)

--ROLLUP

---Z.16.1 Wy�wietl sum� sprzeda�y dla klientek o imieniu Adel i Grace. Wy�wietl r�wnie�
--sum� sprzeda�y dla wszystkich klientek o imieniu Adel i Grace, a tak�e sum� ca�kowit�.
--Display the total sales for female customers named Adel and Grace. Also, show the total sales for all female customers named Adel and Grace, 
--as well as the overall total sales.

select
cust_first_name,
cust_last_name,
sum(s.amount_sold)
from sh.customers c join sh.sales s  using(cust_id)
where cust_first_name IN ('Adel','Grace')
group by rollup (cust_first_name,cust_last_name);

---Z.16.2 Z.16.2 Wy�wietl sum� sprzeda�y poszczeg�lnych produkt�w z kategorii Photo, Hardware
--oraz Electronics. Wy�wietl r�wnie� sum� sprzeda�y wszystkich produkt�w z 
--poszczeg�lnych kategorii oraz sum� ca�kowit�.
--Display the total sales for individual products from the categories Photo, Hardware, and Electronics.
--Also display the total sales of all products from each of these categories, as well as the overall total.

select
prod_category,
prod_name,
sum(amount_sold)
from sh.products p join sh.sales s on (p.prod_id=s.prod_id)
where prod_category IN ('Photo', 'Hardware', 'Electronics')
group by rollup(prod_category, prod_name)
order by prod_category asc;

---Z.16.3  Wy�wietl sum� produkt�w w poszczeg�lnych kategoriach oraz ca�kowit� sum�
--produkt�w w sklepie.
--Display the total number of products in each category, as well as the overall total number of products
--in the store.

select
prod_category,
count(*) as liczba_produktow
from sh.products
group by rollup(prod_category);

---Z.16.4 Wy�wietl jaka by�a suma sprzeda�y poszczeg�lnych produkt�w w ramach
--poszczeg�lnych promocji. Wy�wietl r�wnie� sum� sprzeda�y wszystkich produkt�w w
--ramach poszczeg�lnych promocji oraz sum� ca�kowit�.
--Display the total sales of individual products within each promotion. 
--Also display the total sales of all products within each promotion and the overall total sales.

select
prom.promo_name,
p.prod_name,
sum(s.amount_sold)
from sh.promotions prom join sh.sales s using(promo_id)join sh.products p using(prod_id)
group by rollup (promo_name,prod_name);

--CUBE


---Z.16.6 Stw�rz zestawienie, kt�re b�dzie zawiera�o ilo�� pracownik�w i ich zarobki
--per dzia� i per stanowisko + wszystkie mo�liwe kombinacje ( cube).
---Dodaj kolumn�, kt�ra b�dzie oznacza�a, �e dany wiersz jest podsumowaniem.
---Create a report that includes the number of employees and their salaries
--per department and per position, along with all possible combinations (using CUBE).
--� Add a column that indicates whether a given row is a summary.

select
department_name as department,
job_title as job,
count(*) as ilosc_pracownikow,
avg(salary),
grouping(department_name) as gr_department,
grouping(job_title) as gr_job
from hr.departments d right outer join hr.employees e on(d.department_id=e.department_id)
join hr.jobs j on (e.job_id=j.job_id)
group by CUBE(department_name,job_title)
order by department;

---Z. 16.7 Wykorzystaj CASE w poprzednim zadaniu, tak �eby uzyska� rezultat jak
--poni�ej.
--Use a CASE statement in the previous task to achieve a result like the one shown below.

select
department_name as department,
job_title as job,
count(*) as ilosc_pracownikow,
avg(salary),
grouping(department_name) as dzial,
case grouping(job_title)
when 1 then 'Wszystkie stanowiska'
else to_char(job_title)
end as stanowisko
from hr.departments d right outer join hr.employees e on(d.department_id=e.department_id)
join hr.jobs j on (e.job_id=j.job_id)
group by CUBE(department_name,job_title)
order by department;

---ANALYTICAL FUNCTIONS

---Z.17.1 Zbuduj ranking produkt�w ze wzgl�du na ca�kowit� kwot� sprzeda�y.
---Build a ranking of products based on the total sales amount.

select
prod_name,
sum(amount_sold),
rank()over(order by sum(amount_sold) desc)as ranking
from sh.products p left outer join sh.sales s on (p.prod_id=s.prod_id)
group by prod_name;

---Z.17.2 Zbuduj ranking produkt�w ze wzgl�du na ca�kowit� kwot� sprzeda�y, z podzia�em na kana� sprzeda�y
---partycjonowanie channel_id

select 
prod_id,
channel_id,
sum(amount_sold) as suma_sprzeda�y,
rank() over (partition by channel_id order by sum(amount_sold) desc) as ranking
from sh.sales group by channel_id, prod_id;

---Z.17.3 Zbuduj ranking pracownik�w ze wzgl�du na wysoko�� zarobk�w.
---Build a ranking of employees based on the amount of their salary.

select 
first_name,
last_name,
salary,
rank() over(order by salary desc)as salary_rank
from hr.employees;

---Z.17.4 Dla ka�dego dzia�u zbuduj ranking pracownik�w ze wzgl�du na wysoko�� zarobk�w.
---partycjonowanie department_id
--For each department, build a ranking of employees based on the amount of their salary.
--� Partitioning by department_id

select
department_id,
first_name,
last_name,
salary,
RANK()over (PARTITION by (department_id) order by (salary)desc) as salary_rank
from hr.employees;

---Z.17.5 Dla ka�dej kategorii, podziel produkty na 3 grupy sprzeda�owe. Im
--wy�sza sprzeda�, tym ni�sza grupa sprzeda�owa.
--For each category, divide the products into 3 sales groups.
--The higher the sales, the lower the sales group number.

select
prod_name,
prod_subcategory,
sum(amount_sold),
rank () over (PARTITION BY prod_subcategory order by sum(amount_sold) desc) as rank_within_categories
from sh.products p left join sh.sales s on (p.prod_id=s.prod_id)
group by prod_name, prod_subcategory;

--needs to use NTILE function

SELECT 
    p.prod_name,
    p.prod_subcategory,
    SUM(s.amount_sold) AS total_sales,
    NTILE(3) OVER (
        PARTITION BY p.prod_subcategory 
        ORDER BY SUM(s.amount_sold) DESC
    ) AS sales_group
FROM sh.products p
LEFT JOIN sh.sales s ON p.prod_id = s.prod_id
GROUP BY p.prod_name, p.prod_subcategory;

---REPORTING FUNCTIONS

---Z.17.6  Dla ka�dego produktu podaj jego sumaryczn� kwot� sprzeda�y oraz sumaryczn�
---kwot� sprzeda�y wszystkich produkt�w, nale��cych do tej samej kategorii, co dany produkt.
---For each product, provide its total sales amount as well as the total sales amount of all 
--products that belong to the same category as that product.

select
prod_name,
prod_category,
sum(amount_sold) as sales_prod,
sum(sum(amount_sold)) over (PARTITION by prod_category) as sales_categ
from sh.products p left outer join sh.sales s on (p.prod_id=s.prod_id)
group by prod_name,
prod_category;

---Z.17.7 Dla ka�dej kategorii produktu:
--a) znajd� region, w kt�rym ta kategoria mia�a najwi�ksz� sprzeda� w dniu 24 grudnia 2000r.
--b) podaj kwot� sprzeda�y w tym regionie

select 
p.prod_category,
count.country_region,
sum(s.amount_sold) as suma_sprzedazy,
RANK() OVER(partition by prod_category order by sum(s.amount_sold)DESC) as najwyzsze_w_kat
from sh.sales s join sh.products p on s.prod_id=p.prod_id
join sh.customers cus on s.cust_id=cus.cust_id join
sh.countries count on cus.country_id=count.country_id
group by prod_category, country_region;

--LISTAAG

---Z.17.8 Dla ka�dego produktu, sprzedanego w pierwszym kwartale 1999 roku, podaj, w
--formie listy, oddzielone przecinkami, identyfikatory klient�w, kt�ry dany produkt zakupili w danym dniu.
--For each product sold in the first quarter of 1999, provide a comma-separated list of customer
--IDs who purchased that product on each specific day.

select
p.prod_name,
t.time_id,
LISTAGG(s.cust_id, ',') within group (order by s.cust_id) as list_of_clients
from sh.products p join sh.sales s on (p.prod_id=s.prod_id) join sh.times t on (s.time_id=t.time_id)
where calendar_year ='1999' and calendar_quarter_number=1
group by t.time_id, p.prod_name;

---Z.17.8 Wy�wietl imiona wszystkich pracownik�w pracuj�cych na poszczeg�lnych
--stanowiskach.
--Display the first names of all employees working in each position.

select
job_title,
LISTAGG(first_name, ',')within group(order by first_name )
from hr.employees e left join hr.jobs j on (e.job_id=j.job_id)
group by job_title
order by job_title;

---LAG/LEAD FUNCTIONS

---Z.17.9 Wy�wietl sum� sprzeda�y produkt�w w 2000 roku w podziale na miesi�ce. Dla
--ka�dego miesi�ca wy�wietl r�wnie� sum� sprzeda�y w poprzednim i nast�pnym miesi�cu.
---Display the total product sales in the year 2000 broken down by month. For each month, also 
--show the total sales for the previous and the next month.

select
t.calendar_month_number,
sum(s.amount_sold) as month_amount,
LAG(sum(s.amount_sold),1,0) over(order by t.calendar_month_number) as previous_month_amount,
LEAD(sum(s.amount_sold),1) over (order by t.calendar_month_number) as next_month_amount
from sh.sales s join sh.times t on s.time_id=t.time_id
where t.calendar_year = 2000
group by t.calendar_month_number;

---Z.17.9 Z.17.12 U�ywaj�c funkcji analitycznych:
--a) Wy�wietl warto�ci sprzeda�y w pierwszym kwartale 2001 roku w podziale na dzie�.
--b) Dat� wy�wietl w formacie DD MM YYYY
--c) Dla ka�dego dnia wy�wietl warto�� sprzeda�y w poprzednim dniu. Je�li dane
--sprzeda�y z poprzedniego dnia s� niedost�pne, wy�wietl warto�� 0.
--d) Wy�wietl r�nic� sprzeda�y pomi�dzy aktualnym wierszem i wierszem poprzednim.
---Using analytic functions:
--a) Display the sales values for the first quarter of 2001, broken down by day.
--b) Display the date in the format DD MM YYYY.
--c) For each day, show the sales value from the previous day. If the sales data for the previous day is not available, display 0.
--d) Show the difference in sales between the current row and the previous row.

select 
 to_char(t.time_id, 'DD-MM-YYY') as data,
 sum(s.amount_sold) as dzienna_sprzedaz,
 LAG(sum(s.amount_sold), 1 , 0)OVER (order by t.time_id) as sprzedaz_poprzedniego_dnia,
 sum(s.amount_sold)-LAG(sum(s.amount_sold), 1 , 0)OVER (order by t.time_id) as roznica_sprzedazy
 from sh.sales s join sh.times t on s.time_id=t.time_id
 where t.calendar_year=2001 and t.calendar_quarter_number=1
 group by t.time_id
 order by t.time_id;






