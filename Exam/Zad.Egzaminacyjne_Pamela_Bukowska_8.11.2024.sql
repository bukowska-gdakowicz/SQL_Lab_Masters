---Zadanie 1
---Ad.1.

---Ile dysk�w posiada nap�dy Supra? Ile dysk�w posiada najnowszy nap�d Supra
--(najnowszy oznacza ten z najwy�sz� wersj� oznaczon� numerem)?

select
*
from oe.product_information
where product_name like '%Supra%';

select distinct
*
from oe.product_descriptions
where translated_description like '%Supra%';

select distinct
count(*)
from oe.product_descriptions
where translated_description like '%Supra9%';

---Ad.2

--Kt�ry z dostawc�w poczty wyst�puje najcz�ciej w bazie maili wszystkich klient�w?
--Przyk�adowo: w mailu Ajay.Sen@TROGON.EXAMPLE.COM jako dostawc� prosz�
--potraktowa� ci�g znak�w: TROGON.

select distinct
cust_email
from
oe.customers;

SELECT 
SUBSTR(cust_email, INSTR(cust_email, '@')+1)as dostawcy,
count(*)as ilo��
from oe.customers
group by dostawcy
order by ilo�� desc;

---AD.3
select
distinct income_level
from oe.customers
order by income_level;

---Zadanie.2 
--Prosz� wy�wietli� wszystkie zam�wienia (rekordy tabeli ORDERS) klienta, kt�ry wykona� ich
--najwi�cej w ca�ej historii zam�wie�. Do ka�dego rekordu prosz� do��czy� informacj� ile dni
--min�o od poprzedniego zam�wienia.

select
customer_id,
count(*),
RANK()over(order by count(*)desc) as ranking
from
oe.orders
group by customer_id;

select
order_id,
order_date,
order_mode,
customer_id,
order_status,
order_total,
sales_rep_id,
promotion_id,
LAG(to_char(order_date,'YY/MM/DD'),1,0)over (order by order_id asc) as data_poprzednia,
to_char(order_date,'YY/MM/DD') as data_zamowienia
from
oe.orders
where customer_id=826
order by order_id;

--OSTATECZNE ROZWIAZANIE TJ. ILO�� DNI
select
order_id,
order_date,
order_mode,
customer_id,
order_status,
order_total,
sales_rep_id,
promotion_id,
LAG(to_char(order_date,'DDD'),1,0)over (order by order_id asc) as data_poprzednia,
to_char(order_date,'DDD') as data_zam�wienia,
to_char(order_date,'DDD') - (LAG(to_char(order_date,'DDD'),1,0)over (order by order_id asc))as ilo��_dni_mi�dzy_zam�wieniem_a_poprzednim
from
oe.orders
where customer_id=826
order by order_id;

---wiersz 1 zwraca niepoprawna ilosc dni 97
---wiersz 10 zwraca niepoprawna ilosc dni -330


---Zadanie 3

--Ad.1.Ile �rednio zarabiaj� osoby zatrudnione w poszczeg�lnych departamentach? Ogranicz
---wyniki do departament�w: Sales, Shipping, Finance.

select
department_name,
round(avg(salary),0) as �rednia_pensja
from
hr.employees e join hr.departments d on e.department_id=d.department_id
where d.department_name in('Sales','Shipping','Finance')
group by department_name;

---Ad.2 Ile �rednio zarabiaj� osoby na r�nych stanowiskach. Ogranicz wyniki do zawod�w, w
---kt�rych jest zatrudnionych co najmniej 5 os�b.

select
job_title,
avg(salary)as �rednia_pensja,
count(job_title)as ilo��_os�b_zatrudnionych
from hr.employees e join hr.jobs j on e.job_id=j.job_id
group by job_title
having ilo��_os�b_zatrudnionych>=5
order by �rednia_pensja desc;

----Ad 3 
--Prosz� rozszerzy� analiz� z punktu 2 o odpowied� na pytanie: kt�rej grupie stanowisk
--mo�emy podnie�� p�ace o 10% jednocze�nie komunikuj�c to oficjalnie, pami�taj�c, �e
--dla ka�dej z grup mamy ustalone minimalne i maksymalne wynagrodzenie?
select
job_title,
avg(e.salary)as �rednia_pensja,
count(j.job_title)as ilo��_os�b_zatrudnionych,
min(j.min_salary) as min_salary,
min(j.max_salary) as max_salary,
avg(e.salary)*1.1 as �rednia_pensja_plus_10proc,
case
when avg(e.salary)*1.1 between min(j.min_salary) and min(j.max_salary) then 'Yes_officially'
when avg(e.salary)*1.1 > min(j.max_salary) then 'Not_officialy'
end as officially_notice
from hr.employees e join hr.jobs j on e.job_id=j.job_id
group by job_title
having ilo��_os�b_zatrudnionych>=5
order by �rednia_pensja desc;

----Tu rozwiazanie, 
--jezeli Ad3 rozumiemy przez wyliczenie mozliwosci dla najwyzszej pensji na danym stanowisku (zamiast sredniej)

select
job_title,
max(e.salary)as maks_pensja,
count(j.job_title)as ilo��_os�b_zatrudnionych,
min(j.min_salary) as min_salary,
min(j.max_salary) as max_salary,
max(e.salary)*1.1 as max_pensja_plus_10proc,
case
when max(e.salary)*1.1 between min(j.min_salary) and min(j.max_salary) then 'Yes_officially'
when max(e.salary)*1.1 > min(j.max_salary) then 'Not_officialy'
end as officially_notice
from hr.employees e join hr.jobs j on e.job_id=j.job_id
group by job_title
having ilo��_os�b_zatrudnionych>=5
order by maks_pensja desc;

--Zadanie 4
--W historii dzia�alno�ci firmy wyst�pi�y 2 promocje:
--� everyday low price - promocja 20% na wszystkie zam�wienia online
--� blowout sale � promocja 10% na ca�y asortyment
--Prosz� poda� dla ka�dej z promocji:
--a) okres obowi�zywania promocji
--b) ��czn� warto�� zam�wie� ka�dego dnia promocji
--c) klienta, kt�ry zareagowa� jako pierwszy na promocj� � z�o�y� pierwsze zam�wienie w
--trakcie jej obowi�zywania
--d) odpowied� na wykonan� analiz�: czy promocja spowodowa�a znacz�cy wzrost
--sprzeda�y? O ile %?

--a)okres obowiazywania promocji

--dla promocji o promo_id=1(everyday low price) odp brzmi: Okres obowiazywania promocji to 18/07/01-18/07/31
select 
to_char(order_date,'YY/MM/DD') as data_zam�wienia,
promo.promo_id,
count(*)as liczba_zam�wie�_w_danym_dniu,
min(order_date),
max(order_date)
from oe.orders o join oe.promotions promo on o.promotion_id=promo.promo_id
group by data_zam�wienia,promo.promo_id
having promo_id=1
order by data_zam�wienia;

--dla promocji o promo_id=2(blowout sale) odp brzmi: Okres obowiazywania promocji to 19/03/18-19/04/05
select 
to_char(order_date,'YY/MM/DD') as data_zam�wienia,
promo.promo_id,
count(*)as liczba_zam�wie�_w_danym_dniu,
min(order_date),
max(order_date)
from oe.orders o join oe.promotions promo on o.promotion_id=promo.promo_id
group by data_zam�wienia,promo.promo_id
having promo_id=2
order by data_zam�wienia;

--b)laczna wartosc zamowien kazdego dnia promocji

select 
to_char(order_date,'YY/MM/DD') as data_zam�wienia,
promo.promo_id,
count(*)as liczba_zam�wie�_w_danym_dniu,
sum(order_total) as laczna_wartosc_zamowien_kazdego_dnia_promocji
from oe.orders o join oe.promotions promo on o.promotion_id=promo.promo_id
group by data_zam�wienia,promo.promo_id
order by data_zam�wienia;

---c) klienta, kt�ry zareagowa� jako pierwszy na promocj� � z�o�y� pierwsze zam�wienie w
------trakcie jej obowi�zywania 

--promocja 1 tj. everyday low price
--Odpowied�: dla promocji nr 1, pierwszym klientem, kt�ry zlo�yl zam�wienie byl customer_id=189 czyli 'Gena Harris'

select 
o.order_date,
o.customer_id,
promo.promo_id,
order_status,
c.cust_first_name || ' ' || c.cust_last_name as klient
from oe.orders o join oe.promotions promo on o.promotion_id=promo.promo_id
join oe.customers c on o.customer_id=c.customer_id
where order_status IN (2,3,4,5) and promo_id=1
order by order_date;

---promocja 2 tj. blowout sale
--Odpowied�: dla promocji nr 2, pierwszym klientem, kt�ry zlo�yl zam�wienie byl customer_id=609 czyli 'Shelley Taylor'.

select 
o.order_date,
o.customer_id,
promo.promo_id,
order_status,
c.cust_first_name || ' ' || c.cust_last_name as klient
from oe.orders o join oe.promotions promo on o.promotion_id=promo.promo_id
join oe.customers c on o.customer_id=c.customer_id
where order_status IN (2,3,4,5) and promo_id=2
order by order_date;

--d) odpowied� na wykonan� analiz�: czy promocja spowodowa�a znacz�cy wzrost
--sprzeda�y? O ile %?


-- dla promocji 1 por�wnano 1 miesiac sprzedazy bez promocji (czerwiec 2018rok) z 1 msc sprzedazy w trakcie promocji (lipiec 2018r)
--wzieto tylko zamowienia kt�re doszly do realizacji oraz zam�wienia online bo promocja byla tylko na zamowienia online
--Odpowied�: Sprzeda� laczna w czerwcu : 323836,7 ; Sprzeda� laczna w lipcu: 525095
-- Promocja 1 spowodowala wzrost sprzedazy o 62%
select 
sum(order_total),
to_char(order_date, 'YY-MM-DD') data_zam�wienia,
count(*) as ilosc_zam�wie�,
order_mode,
case 
when promotion_id is null then 'Brak_promocji'
when promotion_id=1 then 'prom1_everyday_low_proce'
when promotion_id=2 then 'prom2_blowout_sale'
else 'error'
end as podzial,
o.promotion_id,
sum(sum(order_total))over(partition by (o.promotion_id)) as suma_zam�wien_w_miesiacu_bez_promocji_vs_z_promocja
from oe.orders o left outer join oe.promotions p on o.promotion_id=p.promo_id
where order_status in(2,3,4,5) and to_char(order_date, 'YY-MM-DD') between '18-06-01' and '18-07-31'
group by(podzial, data_zam�wienia,o.order_mode,o.promotion_id)
having order_mode='online'
order by data_zam�wienia;

-- dla promocji 2 por�wnano przedzial czasu 27.02.2019-17.03.2019 bez promocji z przedzialem 18.03.2019-5.04.2019 z
--obowiazujaca promocja (taak aby wziac po prostu ta sama ilosc dni aby porownanie ilosci zamowien bylo miarodajne
--Odpowied�: Suma zamowien dla okresu czas z promocja wyniosla 861262,46 podczas gdy dla czasu bez promocji 609659,7.
-- W zwiazku z tym, promocja spowodowala wzrost sprzedazy o 41%. 

select 
sum(order_total),
to_char(order_date, 'YY-MM-DD') data_zam�wienia,
count(*) as ilosc_zam�wie�,
order_mode,
case 
when promotion_id is null then 'Brak_promocji'
when promotion_id=1 then 'prom1_everyday_low_proce'
when promotion_id=2 then 'prom2_blowout_sale'
else 'error'
end as podzial,
o.promotion_id,
sum(sum(order_total))over(partition by (o.promotion_id)) as suma_zam�wien_w_miesiacu_bez_promocji_vs_z_promocja
from oe.orders o left outer join oe.promotions p on o.promotion_id=p.promo_id
where order_status in(2,3,4,5) and to_char(order_date, 'YY-MM-DD') between '19-02-27'and '19-04-05'
group by(podzial, data_zam�wienia,o.order_mode,o.promotion_id)
order by data_zam�wienia;


---Zadanie 5
--Dzia�alno�� zwi�zana ze sprzeda�� sprz�tu obj�tego d�ugim okresem gwarancji wi��e si� z
--ryzykiem wyp�aty pieni�dzy z gwarancji, je�li zostanie uznana za adekwatn� (zak�adamy, �e
--odpowiadamy finansowo za wady oferowanych produkt�w). Model przyj�ty w naszej firmie
--zak�ada, �e utrzymujemy rezerwy finansowe na wszystkie produkty, kt�re zosta�y sprzedane
--oraz mog� jeszcze zosta� zareklamowane. Zgodnie z modelem procentowe stawki rezerw
--wynosz� w zale�no�ci od produktu:
--� dyski twarde HD - 5.5%
--� monitory: LCD - 8%, plazmowe - 6%, pozosta�e - 5%
--� pozosta�e - 4%
--Prosz� obliczy� jak� kwot� rezerw musia�a utrzymywa� nasza firma w dniu 2019-09-30

--nietrzeba nawet dawac warunku where na date do 19/09/30 bo ostatnie zamowienie jest z 19/04/05
--celowo daje order_status 6 bo nie wiem czy te zwrocone (w moim rozumieniu, zareklamowane) produkty, zostaly
--juz rozliczone jako reklamacja. Zakladam, ze nie, wiec 'wpadaja' to puli rezerwy.

--create private temporary table ora$ptt_Przefiltrowane_dane as

select
o.order_date,
o.order_total,
oi.unit_price,
o.order_status,
product_name,
category_id,
pi.warranty_period,
o.order_date + warranty_period as nowy_timestamp
from
oe.orders o join oe.order_items oi on o.order_id=oi.order_id
join oe.product_information pi on oi.product_id=pi.product_id
where order_status IN(4,5,6) and (o.order_date+warranty_period)>='19/09/30';


create private temporary table ora$ptt_Baza_danych as(
select
o.order_date,
o.order_total,
oi.unit_price,
o.order_status,
product_name,
category_id,
pi.warranty_period,
order_date + warranty_period as nowy_timestamp
from
oe.orders o join oe.order_items oi on o.order_id=oi.order_id
join oe.product_information pi on oi.product_id=pi.product_id
where order_status IN(4,5,6) and (order_date+warranty_period)>='19-09-30');





--rezerwa na dyski twarde HD 5,5%
--w categories znaleziono ze dyski twarde to category_id=13
--sum((5.5*100)/unit_price)

--rezerwa na monitory ->category_id=11
--LCD-8% product_name : 'LCD%' (product_infromation)
--plazmowe 6% product_name: 'Plasma%'
--pozostae 5% product_name: 'Monitor%'

--rezerwa na laptopy--> category_id=19
--product_information/product_name: 'Laptop%' 10%

--Pozostale:4%