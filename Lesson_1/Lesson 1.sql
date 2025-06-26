
--PUBLIC DATABASE HR (Human Resources)

---Z.1.3 Wyœwietl wszystkie dane z tabeli DEPARTMENTS 
--/ Show all rows from the DEPARTMENTS table. 

select
* from hr.departments;

---Z.1.4 Z.1.4 Sporz¹dŸ zestawienie pracowników które bêdzie zawiera³o imiê, nazwisko oraz pensjê. 
---/ Prepare a report of employees including their first name, last name, and salary. 

select 
first_name,
last_name,
salary
from hr.employees;

---Z.1.5 Z.1.5 Zmodyfikuj wczeœniejsze zestawienie, tak ¿eby zawiera³o tylko 40 rekordów, a
---kolumny mia³y nazwy w jêzyku polskim.
---Modyfy the previous report so that it includes only 40 records and the column names are in Polish.

select 
first_name as imie,
last_name as nazwisko,
salary as pensja
from hr.employees FETCH FIRST 40 ROW ONLY;

---Z.1.6 Dla ka¿dego pracownika wypisaæ tekst:„Pracownik <imiê> <nazwisko> zosta³ zatrudniony dnia 
---<data> roku z wynagrodzeniem <wynagrodzenie> USD.”
---For each employee, display the following text: 'Employee <first name> <last name> was hired on <hire date>
---with a salary of <salary> USD.'.

select 
'Pracownik ' || first_name || ' ' || last_name ||
' zostal zatrudniony dnia ' || hire_date || ' roku z wynagrodzeniem ' || salary || ' USD.' as Opis_pracownika
from hr.employees;

---Z.2.1 Z.2.1 ZnajdŸ pracowników, którzy pracuj¹ w dziale o ID 80 oraz zostali
---zatrudnieni po 1 stycznia 2006r.
---Find employees who work in department ID 80 and were hired after January 1, 2006. 

select * 
from hr.employees
where department_id = 80 and hire_date > '2006-01-01';

---Z.2.2 Z.2.2 Z tabeli JOBS wyœwietl informacje o stanowiskach „Finance Manager” oraz „Sales Manager".
---From the JOBS table, display information about the positions 'Finance Manager' and 'Sales'.

select
*
from hr.jobs where job_title IN ('Finance Manager', 'Sales Manager');

---Z.2.3 Wyœwietl wszystkie kraje, których druga litera to "a".
---Display all countries where the second letter is 'a'. 

select
* 
from hr.countries
where country_name like '_a%';

---Z.2.4 Wyœwietl wszystkie kraje, które zaczynaj¹ siê na literê „A”, „E” lub „I”.
--- Display all countries that start with the letter 'A', 'E' or 'I'.

select 
*
from hr.countries
where country_name like 'A%' or country_name like 'E%' or country_name like 'I%';

---Z.2.5 Z.2.5 Wyœwietl wszystkie stanowiskach na których p³aca minimalna jest z
---zakresu <3000, 4000>
---Display all job positions where the minimum salary is in the range of 3000 to 4000.

select 
* from hr.jobs
where min_salary between '3000' and '4000';

---Z.3.1 Z.3.1 Wyœwietl wszystkich pracowników których managerem jest pracownik o ID 146 i
--którzy maj¹ okreœlon¹ prowizjê od sprzeda¿y.
---Display all employees whose manager has the ID 146 and who have a specified sales commission.

select 
* from hr.employees
where manager_id = 146 and commission_pct IS NOT NULL;

---Z.3.2 Wyœwietl imiê, nazwisko i prowizjê wszystkich pracowników, których prowizja jest nie wiêksza ni¿ 20%.
---Przy za³o¿eniu ¿e null oznacza prowizjê 0%.
---Display the first name, last name, and commission of all employees whose commission is no greater than 20%.
---Assume that NULL means a commission of 0%."

select
first_name,
last_name,
commission_pct
from hr.employees
where commission_pct <= '0,20' or commission_pct IS NULL;

--second solving

select
first_name,
last_name,
nvl(commission_pct, 0) as commission
from hr.employees 
where nvl(commission_pct, 0 )<= '0,2';

---Z.3.3 Wyœwietl imiê, nazwisko, wynagrodzenie nominalne, procent prowizji oraz
---wynagrodzenie razem z prowizj¹ wszystkich pracowników.
---Display the first name, last name, base salary, commission percentage, 
---and total compensation including commission for all employees.

select 
first_name,
last_name,
salary,
commission_pct,
salary +(salary*nvl(commission_pct,0)) as total_salary
 from hr.employees;
 
--- Z.3.4 Wyœwietl wszystkie departamenty, które maj¹ przyporz¹dkowanego managera.
---Display all departments that have an assigned manager

select 
department_name
from hr.departments
where manager_id IS NOT NULL;

---Z.3.5 Z.3.5 Wyœwietl departamenty, które maj¹ menad¿erów i
---location_id jest ró¿ny od 2400.
---Display the departments that have managers and where the location_id is different from 2400. 

select
*
from hr.departments
where manager_id IS NOT NULL and LOCATION_ID != 2400;

---Z.3.6. Z.3.6 Wyœwietl nazwisko i nr telefonu pracowników, którzy nie maj¹ cyfry „5” w numerze
---telefonu oraz w ich nazwisku nie wystêpuje litera „A”.
---Display the last name and phone number of employees who do not have the digit '5' in their phone number 
---and whose last name does not contain the letter 'A'.

select 
last_name,
phone_number
from hr.employees
where last_name not like '%A%'
and last_name not like'%a%'
and phone_number not like '%5%';

---Z.3.7 Imiê i nazwisko pracowników wraz z wyra¿eniem, obliczonym wg zasady, ¿e:
--•jeœli nie okreœlono procentu prowizji pracownika, zwraca jego pensjê powiêkszon¹ o 10%;
--•jeœli okreœlono procent prowizji, zwraca jego pensjê, powiêkszon¹ o procent prowizji

---Display the first and last name of employees along with an expression calculated according to the following rule:
--If the employee's commission percentage is not specified, return their salary increased by 10%;
--If the commission percentage is specified, return their salary increased by the commission percentage.

select 
first_name,
last_name,
salary,
commission_pct,
NVL2(commission_pct,salary+(salary*commission_pct), salary+(salary*0.1)) as expression
from hr.employees;

---Z.4.1 Liczba pracowników zarabiaj¹cych powy¿ej 9000 uwzglêdniaj¹c procent prowizji.
---The number of employees earning more than 9000, taking commission percentage into account.

select 
count(*)
from hr.employees where salary + (salary*nvl(commission_pct,0)) > 9000;

---Z.4.2 Z.4.2 Policz liczbê lokalizacji, dla których nazwa województwa /okrêgu nie koñczy siê na
---„a” oraz te, które nie maj¹ województwa / okrêgu. 
---Count the number of locations where the name of the state/province does not end with the letter 'a' 
---as well as those where the state/province is not specified.

select
count(*)
from hr.locations where state_province not like '%a' or state_province is null;

---Z.4.3 Liczba ró¿nych województw/okrêgów z tabeli lokalizacji.
---The number of distinct states/provinces from the locations table.

select
count(distinct state_province)
from hr.locations;

---Z.4.4 Liczba stanowisk z doln¹ granic¹ wide³ki mniejsz¹ ni¿ 10000.
---The number of job positions with a minimum salary level (lower bound of the pay range) less than 10,000.

select
count(*)
from hr.jobs where min_salary < 10000;

---Z.4.5 Suma wynagrodzeñ nominalnych wszystkich pracowników (bez prowizji).
---The sum of all employees' base salaries (excluding commission).

select 
sum(salary)
from hr.employees;

---Z.4.6 Z.4.6 Suma wynagrodzeñ nominalnych oraz suma wynagrodzeñ razem z prowizj¹ dla
---wszystkich pracowników.
---The sum of base salaries and the sum of total compensation (including commission) for all employees.

select
sum(salary),
sum(salary+(salary*nvl(commission_pct,0))) as suma_z_prowizja
from hr.employees;

---Z.4.7 Minimalna, maksymalna i œrednia prowizja pracowników.
---The minimum, maximum, and average commission of employees.

select
min(commission_pct),
max(commission_pct),
avg(commission_pct)
from hr.employees;

---Z.4.8 Minimalna, maksymalna i œrednia d³ugoœæ imienia.
---The minimum, maximum, and average length of first names.

select
min(length(first_name)) as min_length,
max(length(first_name)) as max_length,
avg(length(first_name)) as avg_length
from hr.employees;

---Z.4.9 Wyœwietl wszystkie nazwiska pracowników, które zaczynaj¹ siê na literê „S”
---(bez duplikatów).
---Display all distinct employee last names that start with the letter 'S'. (without duplicates).

select
distinct last_name
from hr.employees where last_name like 'S%';

