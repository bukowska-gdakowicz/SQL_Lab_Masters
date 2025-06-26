--PUBLIC DATABASE HR (Human Resources)

---Z.10.1 Z.10.1 Napisz zapytanie, które zwróci last_name , salary , department_id , job_id oraz w kolumnie
---posiada_prowizje ” wartoœæ true ’ je¿eli pracownik posiada prowizjê lub false ’ je¿eli nie posiada.
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

---Z.10.2 Z.10.2 Dla ka¿dego pracownika zwróæ informacjê o poziomie jego zarobków.
--Je¿eli:
--pensja < 3000, zwróæ „Poni¿ej 3000”
--pensja <3000, 6000>, zwróæ „3000 6000”
--pensja <6000, 9000>, zwróæ „6000 9000”
--pensja > 9000, zwróæ „Powy¿ej 9000”

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

--- Z.11.1 Dzisiejsz¹ datê wyœwietl zgodnie ze schematami poni¿ej:
--a) 05 04 2019,PI¥TEK
--b) 05 Kwiecieñ 2019 09:42:51
--c) 2019 KWI 05, PI¥TEK 09:42
--d) 2 kwartal 2019

---Display today’s date according to the formats below:

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

---Napisz zapytanie, które zwróci datê ostatni dzieñ miesiaca styczen roku 2019. 
---Write a query that returns the date of the last day of January in the year 2019.

select 
last_day('19/01/12') as last_day
from dual;

---Napisz zapytanie które wyœwietli datê pierwszej soboty po 13 stycznia 2019. 
---Write a query that displays the date of the first Saturday after January 13, 2019.

select 
next_day(DATE '2019-01-13', 'SOBOTA')
from dual;

---Z.11.3 Ile dni bêdzie mia³ luty w 2100 roku?
---How many days will February have in the year 2100?

select
last_day('2100/02/02')
from dual;

---11.4 Z.11.4 Zaokr¹glij datê, która przypada za 150 miesiêcy do jednego miesi¹ca. Datê
---wyswietl w formacie DD-MM-YYYY.
---Round the date that falls 150 months from now to the nearest month.
---Display the date in the format DD MM YYYY.

select
round(add_months(sysdate, 150),'MM')
from dual;

---Z.11.5 Ile miesiêcy up³ynê³o od 1 stycznia 2000 roku do teraz?
---How many months have passed since January 1, 2000, until now?

select
round(months_between(sysdate, date '2020-01-01')) as months_between_dates
from dual;

---Z.11.6 Z.11.6 Policz jaki sta¿ pracy mia³ ka¿dy z pracowników na dzieñ 1 stycznia 2009r. Je¿eli sta¿
---pracy by³ mniejszy ni¿ 13 miesiêcy zwróæ informacjê „JUNIOR”, je¿eli by³ w zakresie <13,40>
---zwróæ „REGULAR”, je¿eli powy¿ej 40 miesiêcy, zwróæ „SENIOR”.
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

---Z.11.7 Z.11.7 Z kolumny HIRE_DATE w tabeli EMPLOYEES wyodrêbnij rok, miesi¹c i dzieñ do
---osobnych kolumn.
---From the HIRE_DATE column in the EMPLOYEES table, extract the year, month, and day into separate columns.

select
hire_date,
extract(YEAR from hire_date) as year,
extract(MONTH from hire_date) as month,
extract(DAY from hire_date) as day
from hr.employees;

---Z 12.1 Wyœwietl wielkimi literami dwie pierwsze litery nazwiska pracownika.
---Display the first two letters of the employee's last name in uppercase.

select
last_name,
upper(substr(last_name,1,2))
from hr.employees;

---Z.12.2 Utwórz inicja³y pracownika (pierwsza litera imienia i nazwiska).
---Create the employee's initials (the first letter of the first name and the last name).

select
first_name,
last_name,
concat(substr(first_name,1,1),substr(last_name,1,1)) as inicjaly
from hr.employees;

---Z.12.3 Z³¹cz imiê i nazwisko pracownika, wyœwietl d³ugoœæ z³¹czonego stringa i
--posortuj wzglêdem d³ugoœci z³¹czonego Stringa w kolejnoœci malej¹cej.
---Concatenate the employee's first and last name, display the length of the concatenated string,
---and sort by the length of the concatenated string in descending order.

select
first_name,
last_name,
concat(first_name,last_name),
length( concat(first_name,last_name)) as dlugosc_stringa
from hr.employees
order by dlugosc_stringa desc;

---Z.12.4 Zamieñ wszystkie imiona „James” na „Artur”.
--(first_name w tabeli employees).
---Replace all first names "James" with "Artur" (first_name column in the employees table).

select
first_name,
last_name,
replace(first_name, 'James', 'Artur') as change_of_names
from hr.employees
where first_name ='James';

---Z.12.8 Z.12.8 Wyœwietl imiê, nazwisko i roczne zarobki pracowników uzwglêdniaj¹c , ¿e pracownicy
---dzia³u o ID 80 otrzymuj¹ premiê roczn¹ w wysokoœci 5000, a dzia³u o ID 50 premiê roczn¹ w wysokoœci 3000.
---Wynik przestaw wed³ug formatu 1 234 567PLN.

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

---Z.12.9 Z.12.9 Wyœwietl sumê zarobków pracowników dzia³u departamentu SALES.
---Wynik przedstaw wed³ug formatu 1 234 567,89PLN
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


