--PUBLIC DATABASE HR (Human Resources)

---Z.13.1 Dla ka¿dego departamentu wyœwietl jego adres w postaci: „Ulica:
---<street_address >, kod pocztowy: <postal_code >, miasto: <city>".
---For each department, display its address in the following format:
--"Street: <street_address>, Postal Code: <postal_code>, City: <city>".

select 
d.department_name,
'Ulica:' || l.street_address ||', '
|| 'kod pocztowy: ' ||
l.postal_code || ',' || ' miasto: ' ||
l.city as adres_departamentu
from hr.departments d join hr.locations l using (location_id);

---Z.13.2 Wyœwietl imiê i nazwisko wraz z nazw¹ dzia³u, w którym pracuje
--dla wszystkich pracowników ( uwzglêdniæ nieprzydzielonych do dzia³u).
---Display the first and last name along with the department name in which the employee works, for all employees 
--(including those not assigned to any department).

select
e.first_name,
e.last_name,
d.department_name
from hr.employees e left join hr.departments d on (e.department_id = d.department_id)
order by department_name asc;

---Z.13.3 Wyœwietl wszystkie departamenty do których nie jest przypisany ¿aden pracownik.
---Display all departments to which no employee is assigned

select
*
from hr.employees e full outer join hr.departments d using(department_id);

--we have got 123 records

select
d.department_name
from hr.employees e full outer join hr.departments d using(department_id)
where employee_id IS NULL;

---Z.13.4 Wyœwietl iloœæ departamentów do których nie jest przypisany ¿aden pracownik.
---Display the number of departments to which no employee is assigned.

select
count(d.department_name)
from hr.employees e right outer join hr.departments d on (e.department_id=d.department_id)
where e.employee_id IS NULL;

---Z.13.5 Z.13.5 Stwórz zestawienie, które bêdzie zawiera³o: imiê i nazwisko pracownika, a tak¿e
--miasto w którym pracuje.
---Create a report that includes the employee's first and last name, as well as the city in which they work.

select
e.first_name,
e.last_name,
l.city
from hr.employees e left join hr.departments d on e.department_id=d.department_id
join hr.locations l on l.location_id=d.location_id
order by city desc;

---Z.13.6 Stwórz zestawienie, które bêdzie zawiera³o: imiê i nazwisko pracownika, jego
--stanowisko, pensjê oraz maksymaln¹ podwy¿kê jak¹ mo¿e uzyskaæ.
---Create a report that includes the employee's first and last name, their job title, salary,
--and the maximum raise they can receive.

select
first_name||' ' || last_name as pracownik,
j.job_title as stanowisko,
e.salary,
j.max_salary-e.salary as max_podwyzka
from hr.employees e join hr.jobs j on e.job_id=j.job_id;

---Z.13.7 Wyœwietl wszystkie miasta (wraz z nazw¹ pañstwa) w których nie znajduje siê
--¿aden departament firmy.
---Display all cities (along with the country name) in which there is no company department.

select 
d.department_id,
l.city,
c.country_name
 from hr.departments d right join hr.locations l using (location_id)
 right join hr.countries c on l.country_id=c.country_id
 where department_id IS NULL
 and city IS NOT NULL;
 
---Z.14.2 Wyœwietl wszystkich pracowników pracuj¹cych w dziale „Sales”.
--Display all employees who work in the "Sales" department.

select * from hr.employees 
where department_id = (select department_id from hr.departments where department_name ='Sales');

---Z.14.3 Z.14.3 Wyœwietl wszystkich pracowników z wynagrodzenie wiêkszym ni¿ dolna granica
--wynagrodzeñ na stanowisku „Programmer”.
---Display all employees with a salary higher than the minimum salary for the "Programmer" position.

select
* from hr.employees where salary > (select min_salary from hr.jobs where job_title='Programmer');

---Z.14.4 Wyœwietl dane pracowników, którzy maj¹ wynagrodzenie powy¿ej œredniej p³acy
--minimalnej ze stanowisk w firmie.
---Display the data of employees whose salary is above the average minimum salary of all positions 
--in the company.

select
* 
from hr.employees where salary > (select avg(min_salary) from hr.jobs);

---Z.14.5 Z.14.5 Identyfikator oraz nazwa dzia³u wraz z liczb¹ zatrudnionych w nim pracowników
--oraz sum¹ ich wynagrodzeñ, dla których (dzia³ów) liczba zatrudnionych w nich
--pracowników jest powy¿ej œredniej dla dzia³ów firmy.
---Display the department ID and name, along with the number of employees in the department and the
--total of their salaries, for those departments where the number of employees is above the company-wide
--average per department.

select
d.department_id,
d.department_name,
count(*),
sum(salary)
from hr.employees e left join hr.departments d on e.department_id=d.department_id
group by d.department_id,d.department_name
having count(*) > (select avg(count(*)) from hr.employees group by department_id);

---Z.14.7 Wyœwietl wszystkie dane pracowników, dla których identyfikator stanowiska
--oraz identyfikator dzia³u wystêpuj¹ w tabeli JOB_HISTORY.
--Display all data of employees whose job ID and department ID appear in the JOB_HISTORY table.

select
* from hr.employees where (job_id, department_id) = ANY (select job_id,department_id from hr.job_history);

---Z.14.8 Z.14.8 Wyœwietl wszystkie dane pracowników na stanowisku z najmniejsz¹
--rozpiêtoœci¹ wide³ek p³acowych.
--Display all data of employees who hold the position with the smallest salary range.

select
*
from hr.employees
where job_id IN (
select job_id from hr.jobs where (max_salary-min_salary) = ( select min(max_salary-min_salary) from hr.jobs));

---Z.15.1 Z.15.1 Wyœwietl na jednym wykazie:
--a. z danych o pracownikach:
--identyfikator dzia³u, minimalne i maksymalne wynagrodzenie dla specjalistów dzia³u
--b. ze stanowisk:
--identyfikator stanowiska, wide³ki wynagrodzenia
--Display in a single report:
--a. From the employee data:
--the department ID, and the minimum and maximum salary for specialists in the department
--b. From the job positions:
--the job ID and the salary range

select 
to_char(department_ID) as ID,
min(salary)as MIN_SAL,
max(salary) as MAX_SAL
from hr.employees
group by department_id
union all
select
job_id,
min_salary,
max_salary 
from hr.jobs;

---Z.15.2 Œrednia p³aca wszystkich pracowników oraz œrednia p³aca pracowników na
--stanowisku SA_REP.
---The average salary of all employees and the average salary of employees in the SA_REP position.

select 
avg(salary),
'wszyscy'
from hr.employees

UNION ALL 

select 
avg(salary),
'sa_rep'
from hr.employees 
where job_id = 'SA_REP';

---Z.15.3 Wyœwietl wszystkie dane pracowników z procentem prowizji nie wiêkszym
--ni¿ 20% za wyj¹tkiem pracowników z wynagrodzeniem miêdzy 8000 a 10000 USD
--Display all data of employees with a commission percentage not greater than 20%, 
--excluding those whose salary is between 8000 and 10000 USD.

select
* from hr.employees 
where nvl(commission_pct,0)<0.2 

MINUS

select 
*
from hr.employees
where salary between 8000 and 10000;

---Z.15.4 Wyœwietl wszystkie dane pracowników, posiadaj¹cych prowizjê od sprzeda¿y
--mniejsz¹ ni¿ 20% i zarabiaj¹cych 8000 10000.
--Display all data of employees who have a sales commission lower than 20% and earn between 8000 and 10000.

select
*
from hr.employees
where nvl(commission_pct, 0) <= 0.2
intersect
select
* from hr.employees
where salary between 8000 and 10000;

---Z.15.5 Wyœwietl dane pracowników, których dzia³ jest zlokalizowany w „United Kingdom".
--Wykorzystaj podzapytania.
--Display the data of employees whose department is located in the United Kingdom.
--Use subqueries.

select
* 
from hr.employees
where department_id IN (select department_id from hr.departments where location_id IN (select location_id from hr.locations where country_id='UK'));

---Z.15.6 Wyœwietl dane pracowników, których dzia³ jest zlokalizowany w „United Kingdom".
--Wykorzystaj z³¹czenia tabel.
--Display the data of employees whose department is located in the United Kingdom.
--Use table joins.

select
*
from hr.employees e join hr.departments d using(department_id) join hr.locations l using(location_id)
join hr.countries c using(country_id) where country_name='United Kingdom';



