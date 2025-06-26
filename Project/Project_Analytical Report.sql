---PUBLIC DATABASE OE (Order Entry)


--Zadanie 1 / Task 1
---Stwórz zapytanie, które zwróci ³¹czn¹ kwotê sprzeda¿y do ka¿dego kraju w ca³ej historii zamówieñ
---Ogranicz siê jedynie do zamówieñ, dla których zap³ata zosta³a zaksiêgowana (w kolejnych zadaniach ten
--warunek równie¿ bêdzie obowi¹zywa³)
---Dane posortuj malej¹co po wielkoœci wyliczonej sprzeda¿y.

--Create a query that returns the total sales amount for each country across the entire order history.
--Limit the results to orders for which the payment has been recorded (this condition will also apply in subsequent tasks).
--Sort the data in descending order by the calculated sales amount.

select
nls_territory as KRAJ_COUNTRY,
round(sum(order_total))as SPRZEDA¯_SALE
from oe.customers c right outer join oe.orders o on (c.customer_id=o.customer_id)
where order_status IN(2,3,4,5)
group by nls_territory
order by sum(order_total) desc;

-----Zadanie 2 / Task 2
--Stwórz zapytanie, które zwróci sprzeda¿ w zale¿noœci od poziomu dochodów (w wierszach) oraz p³ci (w
--kolumnach)
--Ponadto, ostatni¹ kolumn¹ niech bêdzie procentowy udzia³ sprzeda¿y, któr¹ zrealizowa³y kobiety
--Dane posortuj rosn¹co po poziomie dochodów.
--Create a query that returns sales by income level (in rows) and gender (in columns).
--Additionally, the last column should show the percentage share of sales made by women.
--Sort the data in ascending order by income level.

select
c.income_level as POZIOM_DOCHODOW_INCOME_LEVEL,
round(sum(case
    when c.gender='F' then order_total
    else 0
end)) as SPRZEDAZ_KOBIETY_SALE_FEMALE,
round(sum(case
    when c.gender='M' then order_total
    else 0
end)) as SPRZEDAZ_MEZCZYZNI_SALE_MALE,
round(100.00* sum(case when c.gender='F' then order_total else 0 end)/nullif(sum(order_total),0),0)as PERCENTAGE_Female
from oe.customers c join oe.orders o  on (c.customer_id=o.customer_id)
where order_status IN(2,3,4,5)
group by c.income_level
order by c.income_level asc;

---Zadanie 3/ Task 3
--Stwórz zapytanie, które zwróci sprzeda¿ w zale¿noœci od miesi¹ca sprzeda¿y (w wierszach daty przeniesione
--na koniec miesi¹ca) oraz kana³u (w kolumnach)
--Dodatkowo, ostatni¹ kolumn¹ niech bêdzie procentowy udzia³ sprzeda¿y zrealizowana online
--Dane posortuj rosn¹co po dacie

--Create a query that returns sales by month of sale (with dates shifted to the end of the month in the rows) and by channel (in the columns).
--Additionally, the last column should show the percentage share of sales made online.
--Sort the data in ascending order by date.

select 
count(*) from
oe.orders;
---1992 records

select distinct 
extract(year from order_date)
from oe.orders;
--we have two years in base: 2018 and 2019

select
to_char(trunc(last_day(order_date)),'YYYY-MM-DD') as Date_Data,
round(sum(case
when order_mode='direct' then order_total 
else 0
end)),
round(sum(case
when order_mode='online' then order_total
else 0
end)),
ROUND(100* sum(case
when order_mode='online' then order_total
else 0 
end)/ nullif(sum(order_total),0)) as percentage_online
from oe.orders
group by trunc(last_day(order_date))
order by trunc(last_day(order_date));


---Zadanie 4/ Task 4.

--?Stwórz zapytanie, które zwróci kwotê sprzeda¿y w podziale na kraj oraz miesi¹c sprzeda¿y (daty przeniesione na
--koniec miesi¹ca), w takiej postaci, aby móc przenieœæ je do arkusza ANALITYKA SPRZEDA¯Y w raporcie
--?Dane posortuj rosn¹co po kraju, rosn¹co po dacie.
--Create a query that returns the sales amount broken down by country and month of sale 
--(with dates shifted to the end of the month), in a format suitable for transferring to the SALES ANALYSIS sheet in the report.
--Sort the data in ascending order by country and by date.

select
nls_territory as KRAJ_COUNTRY,
to_char(trunc(last_day(order_date)),'YYYY-MM-DD') as MIESIAC_MONTH,
to_char(sum(order_total), '999G999')as SPRZEDA¯_ORDER
from oe.orders o join oe.customers c using(customer_id)
where order_status in(2,3,4,5)
group by trunc(last_day(order_date)), nls_territory
order by nls_territory asc,to_char(trunc(last_day(order_date)),'YYYY-MM-DD')asc;

---Zadanie 5/ Task 5

--Dla ka¿dego sprzedawcy, który sfinalizowa³ co najmniej jedn¹ transakcjê wylicz
--•jego pensjê
--•³¹czn¹ kwotê sprzeda¿y
--•œredni¹ mar¿ê z pojedynczej transakcji
--•œredni¹ mar¿ê z ca³ej sprzeda¿y
--?Dane powinny przyj¹æ formê, która bêdzie mo¿liwa do bezpoœredniego wklejenia do tabeli 1 w arkuszu SIEÆ
--SPRZEDA¯Y
--?Dane posortuj malej¹co po wielkoœci wyliczonej sprzeda¿y
--?PodpowiedŸ warto wykonywaæ zadanie etapami, u¿ywaj¹c tabel tymczasowych

--For each sales person who has finalized at least one transaction, calculate:
--• their salary
--• the total sales amount
--• the average margin per single transaction
--• the average margin across total sales
--The data should be in a format that can be directly pasted into Table 1 of the SALES NETWORK sheet.
--Sort the data in descending order by the calculated total sales amount.
--Tip: It is recommended to complete this task in stages, using temporary tables.


CREATE PRIVATE TEMPORARY TABLE ora$ptt_sprzedawca_0 as 
(select 
first_name || ' ' ||
last_name as Sprzedawca,
max(salary) as Pensja,
to_char(sum(order_total),'999G999') £aczna_sprzedaz
from 
hr.employees e join oe.orders o on e.employee_id=o.sales_rep_id
where order_status in(3,4,5)
group by Sprzedawca);


CREATE PRIVATE TEMPORARY TABLE ora$ptt_sprzedawca_1 as 
(select 
first_name || ' ' ||
last_name as Sprzedawca,

round(avg((oi.unit_price/pi.min_price*100))-100,2) as srednia_marza_z_transakcji,
round(100*(sum(oi.unit_price*quantity)/sum(pi.min_price*oi.quantity)-1),2) as srednia_marza_sprzedazy

from 
hr.employees e join oe.orders o on e.employee_id=o.sales_rep_id
join oe.order_items oi on o.order_id=oi.order_id 
join oe.product_information pi on oi.product_id=pi.product_id

where o.order_status in(3,4,5) and pi.min_price !=0
group by Sprzedawca);  

select* from ora$ptt_sprzedawca_1;

select
s3.*,s2.srednia_marza_z_transakcji,s2.srednia_marza_sprzedazy
from ora$ptt_sprzedawca_0 s3 join ora$ptt_sprzedawca_1 s2 on s3.Sprzedawca=s2.Sprzedawca
order by £aczna_sprzedaz desc;


---Zadanie 6/ task 6
--Dla ka¿dego managera sprzeda¿y wylicz
--•kwotê ³¹cznej sprzeda¿y
--•jego pensjê
--•jego prowizjê
--•liczbê klientów
--•œredni¹ mar¿ê z pojedynczej transakcji
--•œredni¹ mar¿ê z ca³ej sprzeda¿y
--?Dane powinny przyj¹æ formê, która bêdzie mo¿liwa do bezpoœredniego wklejenia do tabeli 2 w arkuszu SIEÆ
--SPRZEDA¯Y
--?Dane posortuj rosn¹co po managerze


create private temporary table ora$ptt_manager_1 as 
(select 
e.first_name || ' ' ||
e.last_name as Manager,
to_char(round(sum(order_total),0),'9G999G999') as Sprzeda¿_Sale,
max(e.salary) as Pensja_Salary,
max(e.commission_pct)as Prowizja_Commission_pct,
count(distinct c.customer_id)as liczba_klientow_number_of_clients
from oe.orders o join oe.customers c on o.customer_id=c.customer_id
join hr.employees e on c.account_mgr_id=e.employee_id
where o.order_status in(3,4,5)
group by e.first_name || ' ' || e.last_name);

select * from ora$ptt_manager_1;

CREATE PRIVATE TEMPORARY TABLE ora$ptt_manager_2 as
(select
e.first_name || ' ' ||
e.last_name as Manager,
round(avg((oi.unit_price/pi.min_price*100))-100,2) as srednia_marza_z_transakcji,
round(100*(sum(oi.unit_price*quantity)/sum(pi.min_price*oi.quantity)-1),2) as srednia_marza_sprzedazy
from
oe.orders o join oe.customers c on o.customer_id=c.customer_id
join hr.employees e on c.account_mgr_id=e.employee_id
join oe.order_items oi on o.order_id=oi.order_id 
join oe.product_information pi on oi.product_id=pi.product_id
where o.order_status in(3,4,5)and pi.min_price !=0
group by e.first_name || ' ' ||
e.last_name);

select * from ora$ptt_manager_2;

select 
m1.*,
m2.srednia_marza_z_transakcji,
m2.srednia_marza_sprzedazy
from ora$ptt_manager_1 m1 join ora$ptt_manager_2 m2 on m1.Manager=m2.Manager
order by m1.Manager;

---Zadanie 7 / Task 7
--?Wyœwietl informacje o 15 czo³owych klientach w rozumieniu kwoty ³¹cznej sprzeda¿y
--?Tabela powinna zawieraæ 4 kolumny
--•imiê i nazwisko managera
--•imiê i nazwisko klienta
--•³¹czna sprzeda¿ do klienta
--•³¹czna sprzeda¿ do klienta w 2019 r
--?Dane posortuj malej¹co po wielkoœci ³¹cznej sprzeda¿y

--Display information about the top 15 customers in terms of total sales amount.
--? The table should include the following 4 columns:
--Full name of the manager
--Full name of the customer
--Total sales to the customer
--Total sales to the customer in the year 2019
--? Sort the data in descending order by total sales amount.

select
first_name || ' ' || last_name as manager,
cust_first_name || ' ' || cust_last_name as klient_client,
round(sum(order_total)) as laczna_sprzedaz,
round(sum(case
when o.order_date >='2019-01-01'
then order_total
end)) as sprzedaz_w_2019
from oe.orders o join oe.customers c using(customer_id)
join hr.employees e on(c.account_mgr_id=e.employee_id)
where o.order_status in(3,4,5)
group by (e.first_name || ' ' || e.last_name, c.cust_first_name || ' ' || c.cust_last_name)
order by sum(order_total) desc fetch first 15 rows only;