--PUBLIC DATABASE HR (Human Resources)

---Z.5.1 Wyœwietl statystykê w której zobrazujesz ile jest dzia³ów w ka¿dej z lokalizacji.
---Wskazówka: wykorzystaj tabelê DEPARTMENTS

select 
location_id,
count(*)
from hr.departments
group by location_id;

---Z.5.2 Wyœwietl statystykê w której zobrazujesz ile jest oddzia³ów w ka¿dym z pañstw.
---Wskazówka: wykorzystaj tabelê LOCATIONS.
---Display a statistic that shows how many branches there are in each country.
---Hint: use the LOCATIONS table.

select
country_id,
count(*)from hr.locations
group by country_id;

---Z.5.3 Podziel pracowników na grupy wg stanowisk, w obrêbie ka¿dej grupy wyœwietl
---liczebnoœæ grupy, minimalne nominalne zarobki ( salary ), maksymalne nominalne zarobki
---oraz rozpiêtoœæ miêdzy maksymalnym a minimalnym zarobkiem. 
---Group employees by job positions; within each group, display: the group size, the minimum
---base salary (salary), the maximum base salary, and the salary range (difference between maximum and minimum).

select 
job_id,
count(*),
min(salary),
max(salary),
max(salary)-min(salary)
from hr.employees
group by job_id;

---Z.6.1 Z.6.1 Podziel pracowników na grupy wg stanowisk, w obrêbie ka¿dej grupy wyœwietl
---liczebnoœæ grupy, minimalne nominalne zarobki ( salary ), maksymalne nominalne zarobki
---oraz rozpiêtoœæ miêdzy maksymalnym a minimalnym zarobkiem; uwzglêdnij tylko te grupy
---w których pracuje minimum 5 osób.
--Divide employees into groups according to their job positions. For each group, display the group size,
---the minimum nominal salary, the maximum nominal salary, and the salary range (difference between the maximum 
---and minimum salary). Include only those groups that have at least 5 employees.

select
job_id,
count(*) as liczba_pracownikow,
min(salary) as min_salary,
max(salary) as max_salary,
max(salary)-min(salary)as rozpietosc_plac
from hr.employees
group by job_id
having liczba_pracownikow >= 5;

---Z.7.1 Wyœwietl stanowiska w firmie posortowane wed³ug minimalnej pensji, w kolejnoœci
---malej¹cej.
---Display the job positions in the company sorted by minimum salary in descending order.

select 
job_id,
job_title,
min(min_salary) as min_salary,
max(max_salary) as max_salary
from hr.jobs
group by job_id, job_title
order by min_salary desc;

---Z.7.2 Wyœwietl miasta w których firma ma swoje departamenty, posortowane w kolejnoœci
---rosn¹cej (A Z).
---Display the cities where the company has its departments, sorted in ascending (A–Z) order.

select 
city from hr.locations
order by city asc;

---Z.8.1 Stwórz sekwencjê która rozpoczyna siê od 1, ma wartoœæ maksymaln¹ 1000 i
---zwiêksza swoj¹ wartoœæ o 1.
---Create a sequence that starts at 1, has a maximum value of 1000, and increments by 1.

create sequence test_sekwencja18
minvalue 1
maxvalue 1000
start with 1
increment by 1;

select test_sekwencja18.nextval from dual;
select test_sekwencja18.currval from dual;

---Z.8.2 Z.8.2 Zmodyfikuj wczeœniej utworzon¹ sekwencjê, tak ¿eby zwiêksza³a swoj¹ wartoœæ o
---10 i mia³a wartoœæ maksymaln¹ równ¹ 15 000.
---Modify the previously created sequence so that it increments by 10 and has a maximum value of 15,000.

alter sequence test_sekwencja18
maxvalue 15000
increment by 10;

---Z.8.3 Przetestuj pobieranie wartoœci z sekwencji utworzonej w poprzednim zadaniu.
--- Test retrieving values from the sequence created in the previous task.

select test_sekwencja18.nextval from dual;
select test_sekwencja18.nextval from dual;
select test_sekwencja18.currval from dual;

---Z. 9.1 Z.9.1 Utwórz tabelê SAMOCHODY, która bêdzie przechowywa³a nastêpuj¹ce
---informacje:
--•ID number (6,0)
--•Marka varchar2(50)
--•Model varchar2(50)
--•Kolor varchar2(50)
--•VIN varchar2(17)
--•Nr_rejestracyjny varchar2(7)
--•Przebieg number (7,0)

---Create a table named CARS that will store the following information:
--ID NUMBER(6,0)
--Brand VARCHAR2(50)
--Model VARCHAR2(50)
--Color VARCHAR2(50)
--VIN VARCHAR2(17)
--License_plate_number VARCHAR2(7)
--Mileage NUMBER(7,0)

create table SAMOCHODY_CARS (ID number(6,0),Marka varchar2(50),Model varchar2(50),Kolor varchar2(50),VIN varchar2(17),
Nr_rejestracyjny varchar2(7), Przebieg number(7,0));

select * from samochody_cars;

---Z.10.1 
--Do tabeli REGIONS_TRAIN dodaj wszystkie rekordy z tabeli REGIONS,
--Do tabeli JOBS_TRAIN dodaj wszystkie rekordy z tabeli JOBS.
--PodpowiedŸ: najpierw utwórz tabele REGIONS_TRAIN oraz JOBS_TRAIN.

--Add all records from the REGIONS table to the REGIONS_TRAIN table.
--Add all records from the JOBS table to the JOBS_TRAIN table.
--Hint: First, create the REGIONS_TRAIN and JOBS_TRAIN tables.

create table regions_train18 (region_id number(1,0), region_name varchar2(25));
select * from regions_train18;
insert into regions_train18 (region_id, region_name) select region_id, region_name from hr.regions;
select * from regions_train18;

create table jobs_train18 (job_id varchar2(10), job_title varchar2(35), min_salary number(6,0), max_salary number (6,0));
insert into jobs_train18 (job_id,job_title,min_salary,max_salary) select job_id,job_title,min_salary,max_salary from hr.jobs;
select * from jobs_train18;

---Z.10.2 Do tabeli REGIONS_TRAIN dodaj region ‚Australia’.
--- Add the region 'Australia' to the REGIONS_TRAIN table.

select * from regions_train18;
create sequence region_id
minvalue 5
maxvalue 10
start with 5
increment by 1;

insert into regions_train18 (region_id, region_name)
values(region_id.nextval, 'Australia');

select * from regions_train18;

---Z.10.3 Z.10.3 Do tabeli SAMOCHODY dodaj pojazdy z listy poni¿ej.
---Wskazówka: do nadania ID wykorzystaj wczeœniej utworzon¹ sekwencjê „test_sequence"
---Add the vehicles from the list below to the CARS table.
---Hint: Use the previously created sequence test_sequence to assign the ID values.

insert into samochody_cars values (test_sekwencja18.nextval, 'Volvo', 'S40', 'czarny', '594387458754', 'WE123XE', 120000 );
select * from samochody_cars;

insert into samochody_cars values (test_sekwencja18.nextval, 'Renault', 'Megane', 'grane', '8437874347', 'WI4125P', 25000);

select * from samochody_cars;


---Z.10.4 Z.10.4 Prezes zarz¹du podniós³ minimalne wynagrodzenie w firmie dla osób na
---stanowisku „Programmer” z 4000 na 4500. WprowadŸ tak¹ zmianê w tabeli JOBS_TRAIN
---The CEO has increased the minimum salary in the company for the position of "Programmer" from 4000 to 4500.
---Apply this change in the JOBS_TRAIN table.

update jobs_train18 set min_salary = 4500
where job_title='Programmer';

select * from jobs_train18 where job_title='Programmer';

---Z.10.5 Zmieñ nazwê regionu ‚Australia’ na ‚Australia and Oceania’ w tabeli
--REGIONS_TRAIN.
---Change the name of the region ‘Australia’ to ‘Australia and Oceania’ in the REGIONS_TRAIN table.

select * from regions_train18;

update regions_train18 set region_name = 'Australia and Ocenia' 
where region_name = 'Australia';

select * from regions_train18;

---Z.10.6 Z.10.6 Prezes zarz¹du postanowi³ zlikwidowaæ wszystkie stanowiska, w których
---pensja minimalna jest wy¿sza od 3000 i ni¿sza od 6000. WprowadŸ tak¹ zmianê w tabeli JOBS_TRAIN.
---The CEO has decided to eliminate all positions where the minimum salary is higher than 3000 and lower than 6000.
---Apply this change in the JOBS_TRAIN table.

select
count(*)from jobs_train18;
delete from jobs_train18 where min_salary between 3000 and 6000;
select 
count(*)
from jobs_train18;

---TEMPORARY TABLES

---Z.9.3 Utwórz tabelê tymczasow¹ o nazwie LICZBY z kolumnami wed³ug schematu poni¿ej.
--Nastêpnie dodaj rekord zawieraj¹cy w ka¿dej z kolumn liczbê 7456123.89
--Wybierz wszystkie dane z tabeli i zobacz w jakiej formie zosta³y zapisane.

CREATE PRIVATE TEMPORARY TABLE ora$ptt_liczby
(
liczba number,
liczba_9 number (9,0),
liczba_9_2 number (9,2),
liczba_9_1 number (9,1),
liczba_6 number (6,0)
);

select * from ora$ptt_liczby;

INSERT INTO ora$ptt_liczby VALUES
(7456123.89,
7456123.89,
7456123.89,
7456123.89,
745612.89
);

select * from ora$ptt_liczby;