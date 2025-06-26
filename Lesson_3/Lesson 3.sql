--PUBLIC DATABASE HR (Human Resources)

---Z.10.1 Z.10.1 Napisz zapytanie, kt�re zwr�ci last_name , salary , department_id , job_id oraz w kolumnie
---posiada_prowizje � warto�� true � je�eli pracownik posiada prowizj� lub false � je�eli nie posiada.
---Write a query that returns: last_name, salary, department_id, job_id, and a column named 
---"has_commission" with the value true if the employee has a commission, or false if not.

select 
last_name,
salary,
department_id,
job_id,
case
when commission_pct IS NULL then 'false'
when commission_pct IS NOT NULL then 'true'
else 'error'
end posiada_prowizje
from hr.employees;

---Z.10.2 Z.10.2 Dla ka�dego pracownika zwr�� informacj� o poziomie jego zarobk�w.
--Je�eli:
--pensja < 3000, zwr�� �Poni�ej 3000�
--pensja <3000, 6000>, zwr�� �3000 6000�
--pensja <6000, 9000>, zwr�� �6000 9000�
--pensja > 9000, zwr�� �Powy�ej 9000�

--For each employee, return information about their salary level.
--If:
--salary < 3000 ? return "Below 3000"
--salary between 3000 and 6000 (inclusive) ? return "3000 6000"
--salary between 6000 and 9000 (exclusive) ? return "6000 9000"
--salary > 9000 ? return "Above 9000"

select 
first_name,
last_name,
salary,
case 
when salary < 3000 then 'Ponizej 3000'
when salary between 3000 and 6000 then '3000-6000'
when salary between 6000 and 9000 then '6000-9000'
when salary > 9000 then 'Powyzej 9000'
else 'error'
end poziom_zarobkow
from hr.employees;

--- Z.11.1 Dzisiejsz� dat� wy�wietl zgodnie ze schematami poni�ej:
--a) 05 04 2019,PI�TEK
--b) 05 Kwiecie� 2019 09:42:51
--c) 2019 KWI 05, PI�TEK 09:42
--d) 2 kwartal 2019

---Display today�s date according to the formats below:

--a) 05 04 2019, FRIDAY
--b) 05 April 2019 09:42:51
--c) 2019 APR 05, FRIDAY 09:42
--d) 2nd quarter of 2019

--a
select 
to_char(sysdate, 'DD-MM-YYYY, DAY') as today_date
from dual;

--b 
select
to_char(sysdate, 'DD Month YYYY HH24:MI:SS') as today_date
from dual;

--c 

select
to_char(sysdate, 'YYYY-MON-DD, DAY HH24:MI') as today_date
from dual;

--d
select
to_char(sysdate, 'Q YYYY') as today_date
from dual;

---Napisz zapytanie, kt�re zwr�ci dat� ostatni dzie� miesiaca styczen roku 2019. 
---Write a query that returns the date of the last day of January in the year 2019.

select 
last_day('19/01/12') as last_day
from dual;

---Napisz zapytanie kt�re wy�wietli dat� pierwszej soboty po 13 stycznia 2019. 
---Write a query that displays the date of the first Saturday after January 13, 2019.

select 
next_day(DATE '2019-01-13', 'SOBOTA')
from dual;

---Z.11.3 Ile dni b�dzie mia� luty w 2100 roku?
---How many days will February have in the year 2100?

select
last_day('2100/02/02')
from dual;

---11.4 Z.11.4 Zaokr�glij dat�, kt�ra przypada za 150 miesi�cy do jednego miesi�ca. Dat�
---wyswietl w formacie DD-MM-YYYY.
---Round the date that falls 150 months from now to the nearest month.
---Display the date in the format DD MM YYYY.

select
round(add_months(sysdate, 150),'MM')
from dual;

---Z.11.5 Ile miesi�cy up�yn�o od 1 stycznia 2000 roku do teraz?
---How many months have passed since January 1, 2000, until now?

select
round(months_between(sysdate, date '2020-01-01')) as months_between_dates
from dual;

---Z.11.6 Z.11.6 Policz jaki sta� pracy mia� ka�dy z pracownik�w na dzie� 1 stycznia 2009r. Je�eli sta�
---pracy by� mniejszy ni� 13 miesi�cy zwr�� informacj� �JUNIOR�, je�eli by� w zakresie <13,40>
---zwr�� �REGULAR�, je�eli powy�ej 40 miesi�cy, zwr�� �SENIOR�.
---Calculate the work experience of each employee as of January 1, 2009. If the experience was less 
---than 13 months, return "JUNIOR"; if it was in the range of 13 to 40 months (inclusive), 
---return "REGULAR"; if it was more than 40 months, return "SENIOR".

select
first_name,
last_name,
hire_date,
round(months_between(date '2009-01-01', hire_date))as miesiace_pracy,
case
when round(months_between(date '2009-01-01', hire_date)) < 13 then 'JUNIOR'
when round(months_between(date '2009-01-01', hire_date)) between 13 and 40 then 'REGULAR'
when round(months_between(date '2009-01-01', hire_date)) > 40 then 'SENIOR'
else 'error'
end staz
from hr.employees;

---Z.11.7 Z.11.7 Z kolumny HIRE_DATE w tabeli EMPLOYEES wyodr�bnij rok, miesi�c i dzie� do
---osobnych kolumn.
---From the HIRE_DATE column in the EMPLOYEES table, extract the year, month, and day into separate columns.

select
hire_date,
extract(YEAR from hire_date) as year,
extract(MONTH from hire_date) as month,
extract(DAY from hire_date) as day
from hr.employees;

---Z 12.1 Wy�wietl wielkimi literami dwie pierwsze litery nazwiska pracownika.
---Display the first two letters of the employee's last name in uppercase.

select
last_name,
upper(substr(last_name,1,2))
from hr.employees;

---Z.12.2 Utw�rz inicja�y pracownika (pierwsza litera imienia i nazwiska).
---Create the employee's initials (the first letter of the first name and the last name).

select
first_name,
last_name,
concat(substr(first_name,1,1),substr(last_name,1,1)) as inicjaly
from hr.employees;

---Z.12.3 Z��cz imi� i nazwisko pracownika, wy�wietl d�ugo�� z��czonego stringa i
--posortuj wzgl�dem d�ugo�ci z��czonego Stringa w kolejno�ci malej�cej.
---Concatenate the employee's first and last name, display the length of the concatenated string,
---and sort by the length of the concatenated string in descending order.

select
first_name,
last_name,
concat(first_name,last_name),
length( concat(first_name,last_name)) as dlugosc_stringa
from hr.employees
order by dlugosc_stringa desc;

---Z.12.4 Zamie� wszystkie imiona �James� na �Artur�.
--(first_name w tabeli employees).
---Replace all first names "James" with "Artur" (first_name column in the employees table).

select
first_name,
last_name,
replace(first_name, 'James', 'Artur') as change_of_names
from hr.employees
where first_name ='James';

---Z.12.8 Z.12.8 Wy�wietl imi�, nazwisko i roczne zarobki pracownik�w uzwgl�dniaj�c , �e pracownicy
---dzia�u o ID 80 otrzymuj� premi� roczn� w wysoko�ci 5000, a dzia�u o ID 50 premi� roczn� w wysoko�ci 3000.
---Wynik przestaw wed�ug formatu 1 234 567PLN.

---Display the first name, last name, and annual earnings of employees, taking into account that employees
---from department ID 80 receive an annual bonus of 5000, and those from department ID 50 receive an annual
--bonus of 3000.
--Present the result in the format: 1 234 567PLN.


select
first_name,
last_name,
case department_id
when 80 then to_char((salary*12)+5000, '9G999G999C')
when 50 then to_char((salary*12)+3000, '9G999G999C')
ELSE to_char((salary*12),'9G999G999C')
end as placa_roczna
from hr.employees;

---Z.12.9 Z.12.9 Wy�wietl sum� zarobk�w pracownik�w dzia�u departamentu SALES.
---Wynik przedstaw wed�ug formatu 1 234 567,89PLN
---Display the total earnings of employees from the SALES department.
---Present the result in the format: 1 234 567.89PLN.

select
department_id,
department_name
from hr.departments
where department_name='Sales';

--Found department ID = 80

select
to_char(sum(salary), '9G999G999D99C') as suma_zarobkow
from hr.employees
where department_id=80;


