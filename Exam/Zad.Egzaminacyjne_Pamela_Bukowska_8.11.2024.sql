---Zadanie 1
---Ad.1.

---Ile dysków posiada napêdy Supra? Ile dysków posiada najnowszy napêd Supra
--(najnowszy oznacza ten z najwy¿sz¹ wersj¹ oznaczon¹ numerem)?

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

--Który z dostawców poczty wystêpuje najczêœciej w bazie maili wszystkich klientów?
--Przyk³adowo: w mailu Ajay.Sen@TROGON.EXAMPLE.COM jako dostawcê proszê
--potraktowaæ ci¹g znaków: TROGON.

select distinct
cust_email
from
oe.customers;

SELECT 
SUBSTR(cust_email, INSTR(cust_email, '@')+1)as dostawcy,
count(*)as iloœæ
from oe.customers
group by dostawcy
order by iloœæ desc;

---AD.3
select
distinct income_level
from oe.customers
order by income_level;

---Zadanie.2 
--Proszê wyœwietliæ wszystkie zamówienia (rekordy tabeli ORDERS) klienta, który wykona³ ich
--najwiêcej w ca³ej historii zamówieñ. Do ka¿dego rekordu proszê do³¹czyæ informacjê ile dni
--minê³o od poprzedniego zamówienia.

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

--OSTATECZNE ROZWIAZANIE TJ. ILOŒÆ DNI
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
to_char(order_date,'DDD') as data_zamówienia,
to_char(order_date,'DDD') - (LAG(to_char(order_date,'DDD'),1,0)over (order by order_id asc))as iloœæ_dni_miêdzy_zamówieniem_a_poprzednim
from
oe.orders
where customer_id=826
order by order_id;

---wiersz 1 zwraca niepoprawna ilosc dni 97
---wiersz 10 zwraca niepoprawna ilosc dni -330


---Zadanie 3

--Ad.1.Ile œrednio zarabiaj¹ osoby zatrudnione w poszczególnych departamentach? Ogranicz
---wyniki do departamentów: Sales, Shipping, Finance.

select
department_name,
round(avg(salary),0) as œrednia_pensja
from
hr.employees e join hr.departments d on e.department_id=d.department_id
where d.department_name in('Sales','Shipping','Finance')
group by department_name;

---Ad.2 Ile œrednio zarabiaj¹ osoby na ró¿nych stanowiskach. Ogranicz wyniki do zawodów, w
---których jest zatrudnionych co najmniej 5 osób.

select
job_title,
avg(salary)as œrednia_pensja,
count(job_title)as iloœæ_osób_zatrudnionych
from hr.employees e join hr.jobs j on e.job_id=j.job_id
group by job_title
having iloœæ_osób_zatrudnionych>=5
order by œrednia_pensja desc;

----Ad 3 
--Proszê rozszerzyæ analizê z punktu 2 o odpowiedŸ na pytanie: której grupie stanowisk
--mo¿emy podnieœæ p³ace o 10% jednoczeœnie komunikuj¹c to oficjalnie, pamiêtaj¹c, ¿e
--dla ka¿dej z grup mamy ustalone minimalne i maksymalne wynagrodzenie?
select
job_title,
avg(e.salary)as œrednia_pensja,
count(j.job_title)as iloœæ_osób_zatrudnionych,
min(j.min_salary) as min_salary,
min(j.max_salary) as max_salary,
avg(e.salary)*1.1 as œrednia_pensja_plus_10proc,
case
when avg(e.salary)*1.1 between min(j.min_salary) and min(j.max_salary) then 'Yes_officially'
when avg(e.salary)*1.1 > min(j.max_salary) then 'Not_officialy'
end as officially_notice
from hr.employees e join hr.jobs j on e.job_id=j.job_id
group by job_title
having iloœæ_osób_zatrudnionych>=5
order by œrednia_pensja desc;

----Tu rozwiazanie, 
--jezeli Ad3 rozumiemy przez wyliczenie mozliwosci dla najwyzszej pensji na danym stanowisku (zamiast sredniej)

select
job_title,
max(e.salary)as maks_pensja,
count(j.job_title)as iloœæ_osób_zatrudnionych,
min(j.min_salary) as min_salary,
min(j.max_salary) as max_salary,
max(e.salary)*1.1 as max_pensja_plus_10proc,
case
when max(e.salary)*1.1 between min(j.min_salary) and min(j.max_salary) then 'Yes_officially'
when max(e.salary)*1.1 > min(j.max_salary) then 'Not_officialy'
end as officially_notice
from hr.employees e join hr.jobs j on e.job_id=j.job_id
group by job_title
having iloœæ_osób_zatrudnionych>=5
order by maks_pensja desc;

--Zadanie 4
--W historii dzia³alnoœci firmy wyst¹pi³y 2 promocje:
--• everyday low price - promocja 20% na wszystkie zamówienia online
--• blowout sale – promocja 10% na ca³y asortyment
--Proszê podaæ dla ka¿dej z promocji:
--a) okres obowi¹zywania promocji
--b) ³¹czn¹ wartoœæ zamówieñ ka¿dego dnia promocji
--c) klienta, który zareagowa³ jako pierwszy na promocjê – z³o¿y³ pierwsze zamówienie w
--trakcie jej obowi¹zywania
--d) odpowiedŸ na wykonan¹ analizê: czy promocja spowodowa³a znacz¹cy wzrost
--sprzeda¿y? O ile %?

--a)okres obowiazywania promocji

--dla promocji o promo_id=1(everyday low price) odp brzmi: Okres obowiazywania promocji to 18/07/01-18/07/31
select 
to_char(order_date,'YY/MM/DD') as data_zamówienia,
promo.promo_id,
count(*)as liczba_zamówieñ_w_danym_dniu,
min(order_date),
max(order_date)
from oe.orders o join oe.promotions promo on o.promotion_id=promo.promo_id
group by data_zamówienia,promo.promo_id
having promo_id=1
order by data_zamówienia;

--dla promocji o promo_id=2(blowout sale) odp brzmi: Okres obowiazywania promocji to 19/03/18-19/04/05
select 
to_char(order_date,'YY/MM/DD') as data_zamówienia,
promo.promo_id,
count(*)as liczba_zamówieñ_w_danym_dniu,
min(order_date),
max(order_date)
from oe.orders o join oe.promotions promo on o.promotion_id=promo.promo_id
group by data_zamówienia,promo.promo_id
having promo_id=2
order by data_zamówienia;

--b)laczna wartosc zamowien kazdego dnia promocji

select 
to_char(order_date,'YY/MM/DD') as data_zamówienia,
promo.promo_id,
count(*)as liczba_zamówieñ_w_danym_dniu,
sum(order_total) as laczna_wartosc_zamowien_kazdego_dnia_promocji
from oe.orders o join oe.promotions promo on o.promotion_id=promo.promo_id
group by data_zamówienia,promo.promo_id
order by data_zamówienia;

---c) klienta, który zareagowa³ jako pierwszy na promocjê – z³o¿y³ pierwsze zamówienie w
------trakcie jej obowi¹zywania 

--promocja 1 tj. everyday low price
--OdpowiedŸ: dla promocji nr 1, pierwszym klientem, który zlo¿yl zamówienie byl customer_id=189 czyli 'Gena Harris'

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
--OdpowiedŸ: dla promocji nr 2, pierwszym klientem, który zlo¿yl zamówienie byl customer_id=609 czyli 'Shelley Taylor'.

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

--d) odpowiedŸ na wykonan¹ analizê: czy promocja spowodowa³a znacz¹cy wzrost
--sprzeda¿y? O ile %?


-- dla promocji 1 porównano 1 miesiac sprzedazy bez promocji (czerwiec 2018rok) z 1 msc sprzedazy w trakcie promocji (lipiec 2018r)
--wzieto tylko zamowienia które doszly do realizacji oraz zamówienia online bo promocja byla tylko na zamowienia online
--OdpowiedŸ: Sprzeda¿ laczna w czerwcu : 323836,7 ; Sprzeda¿ laczna w lipcu: 525095
-- Promocja 1 spowodowala wzrost sprzedazy o 62%
select 
sum(order_total),
to_char(order_date, 'YY-MM-DD') data_zamówienia,
count(*) as ilosc_zamówieñ,
order_mode,
case 
when promotion_id is null then 'Brak_promocji'
when promotion_id=1 then 'prom1_everyday_low_proce'
when promotion_id=2 then 'prom2_blowout_sale'
else 'error'
end as podzial,
o.promotion_id,
sum(sum(order_total))over(partition by (o.promotion_id)) as suma_zamówien_w_miesiacu_bez_promocji_vs_z_promocja
from oe.orders o left outer join oe.promotions p on o.promotion_id=p.promo_id
where order_status in(2,3,4,5) and to_char(order_date, 'YY-MM-DD') between '18-06-01' and '18-07-31'
group by(podzial, data_zamówienia,o.order_mode,o.promotion_id)
having order_mode='online'
order by data_zamówienia;

-- dla promocji 2 porównano przedzial czasu 27.02.2019-17.03.2019 bez promocji z przedzialem 18.03.2019-5.04.2019 z
--obowiazujaca promocja (taak aby wziac po prostu ta sama ilosc dni aby porownanie ilosci zamowien bylo miarodajne
--OdpowiedŸ: Suma zamowien dla okresu czas z promocja wyniosla 861262,46 podczas gdy dla czasu bez promocji 609659,7.
-- W zwiazku z tym, promocja spowodowala wzrost sprzedazy o 41%. 

select 
sum(order_total),
to_char(order_date, 'YY-MM-DD') data_zamówienia,
count(*) as ilosc_zamówieñ,
order_mode,
case 
when promotion_id is null then 'Brak_promocji'
when promotion_id=1 then 'prom1_everyday_low_proce'
when promotion_id=2 then 'prom2_blowout_sale'
else 'error'
end as podzial,
o.promotion_id,
sum(sum(order_total))over(partition by (o.promotion_id)) as suma_zamówien_w_miesiacu_bez_promocji_vs_z_promocja
from oe.orders o left outer join oe.promotions p on o.promotion_id=p.promo_id
where order_status in(2,3,4,5) and to_char(order_date, 'YY-MM-DD') between '19-02-27'and '19-04-05'
group by(podzial, data_zamówienia,o.order_mode,o.promotion_id)
order by data_zamówienia;


---Zadanie 5
--Dzia³alnoœæ zwi¹zana ze sprzeda¿¹ sprzêtu objêtego d³ugim okresem gwarancji wi¹¿e siê z
--ryzykiem wyp³aty pieniêdzy z gwarancji, jeœli zostanie uznana za adekwatn¹ (zak³adamy, ¿e
--odpowiadamy finansowo za wady oferowanych produktów). Model przyjêty w naszej firmie
--zak³ada, ¿e utrzymujemy rezerwy finansowe na wszystkie produkty, które zosta³y sprzedane
--oraz mog¹ jeszcze zostaæ zareklamowane. Zgodnie z modelem procentowe stawki rezerw
--wynosz¹ w zale¿noœci od produktu:
--• dyski twarde HD - 5.5%
--• monitory: LCD - 8%, plazmowe - 6%, pozosta³e - 5%
--• pozosta³e - 4%
--Proszê obliczyæ jak¹ kwotê rezerw musia³a utrzymywaæ nasza firma w dniu 2019-09-30

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