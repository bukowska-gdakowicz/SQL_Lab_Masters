--PUBLIC DATABASE HR (Human Resources)

---Z.13.1 Dla ka�dego departamentu wy�wietl jego adres w postaci: �Ulica:
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

---Z.13.2 Wy�wietl imi� i nazwisko wraz z nazw� dzia�u, w kt�rym pracuje
--dla wszystkich pracownik�w ( uwzgl�dni� nieprzydzielonych do dzia�u).
---Display the first and last name along with the department name in which the employee works, for all employees 
--(including those not assigned to any department).

select
e.first_name,
e.last_name,
d.department_name
from hr.employees e left join hr.departments d on (e.department_id = d.department_id)
order by department_name asc;

---Z.13.3 Wy�wietl wszystkie departamenty do kt�rych nie jest przypisany �aden pracownik.
---Display all departments to which no employee is assigned

select
*
from hr.employees e full outer join hr.departments d using(department_id);

--we have got 123 records

select
d.department_name
from hr.employees e full outer join hr.departments d using(department_id)
where employee_id IS NULL;

---Z.13.4 Wy�wietl ilo�� departament�w do kt�rych nie jest przypisany �aden pracownik.
---Display the number of departments to which no employee is assigned.

select
count(d.department_name)
from hr.employees e right outer join hr.departments d on (e.department_id=d.department_id)
where e.employee_id IS NULL;

---Z.13.5 Z.13.5 Stw�rz zestawienie, kt�re b�dzie zawiera�o: imi� i nazwisko pracownika, a tak�e
--miasto w kt�rym pracuje.
---Create a report that includes the employee's first and last name, as well as the city in which they work.

select
e.first_name,
e.last_name,
l.city
from hr.employees e left join hr.departments d on e.department_id=d.department_id
join hr.locations l on l.location_id=d.location_id
order by city desc;

---Z.13.6 Stw�rz zestawienie, kt�re b�dzie zawiera�o: imi� i nazwisko pracownika, jego
--stanowisko, pensj� oraz maksymaln� podwy�k� jak� mo�e uzyska�.
---Create a report that includes the employee's first and last name, their job title, salary,
--and the maximum raise they can receive.

select
first_name||' ' || last_name as pracownik,
j.job_title as stanowisko,
e.salary,
j.max_salary-e.salary as max_podwyzka
from hr.employees e join hr.jobs j on e.job_id=j.job_id;

---Z.13.7 Wy�wietl wszystkie miasta (wraz z nazw� pa�stwa) w kt�rych nie znajduje si�
--�aden departament firmy.
---Display all cities (along with the country name) in which there is no company department.

select 
d.department_id,
l.city,
c.country_name
 from hr.departments d right join hr.locations l using (location_id)
 right join hr.countries c on l.country_id=c.country_id
 where department_id IS NULL
 and city IS NOT NULL;
 
---Z.14.2 Wy�wietl wszystkich pracownik�w pracuj�cych w dziale �Sales�.
--Display all employees who work in the "Sales" department.

select * from hr.employees 
where department_id = (select department_id from hr.departments where department_name ='Sales');

---Z.14.3 Z.14.3 Wy�wietl wszystkich pracownik�w z wynagrodzenie wi�kszym ni� dolna granica
--wynagrodze� na stanowisku �Programmer�.
---Display all employees with a salary higher than the minimum salary for the "Programmer" position.

select
* from hr.employees where salary > (select min_salary from hr.jobs where job_title='Programmer');

---Z.14.4 Wy�wietl dane pracownik�w, kt�rzy maj� wynagrodzenie powy�ej �redniej p�acy
--minimalnej ze stanowisk w firmie.
---Display the data of employees whose salary is above the average minimum salary of all positions 
--in the company.

select
* 
from hr.employees where salary > (select avg(min_salary) from hr.jobs);

---Z.14.5 Z.14.5 Identyfikator oraz nazwa dzia�u wraz z liczb� zatrudnionych w nim pracownik�w
--oraz sum� ich wynagrodze�, dla kt�rych (dzia��w) liczba zatrudnionych w nich
--pracownik�w jest powy�ej �redniej dla dzia��w firmy.
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

---Z.14.7 Wy�wietl wszystkie dane pracownik�w, dla kt�rych identyfikator stanowiska
--oraz identyfikator dzia�u wyst�puj� w tabeli JOB_HISTORY.
--Display all data of employees whose job ID and department ID appear in the JOB_HISTORY table.

select
* from hr.employees where (job_id, department_id) = ANY (select job_id,department_id from hr.job_history);

---Z.14.8 Z.14.8 Wy�wietl wszystkie dane pracownik�w na stanowisku z najmniejsz�
--rozpi�to�ci� wide�ek p�acowych.
--Display all data of employees who hold the position with the smallest salary range.

select
*
from hr.employees
where job_id IN (
select job_id from hr.jobs where (max_salary-min_salary) = ( select min(max_salary-min_salary) from hr.jobs));

---Z.15.1 Z.15.1 Wy�wietl na jednym wykazie:
--a. z danych o pracownikach:
--identyfikator dzia�u, minimalne i maksymalne wynagrodzenie dla specjalist�w dzia�u
--b. ze stanowisk:
--identyfikator stanowiska, wide�ki wynagrodzenia
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

---Z.15.2 �rednia p�aca wszystkich pracownik�w oraz �rednia p�aca pracownik�w na
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

---Z.15.3 Wy�wietl wszystkie dane pracownik�w z procentem prowizji nie wi�kszym
--ni� 20% za wyj�tkiem pracownik�w z wynagrodzeniem mi�dzy 8000 a 10000 USD
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

---Z.15.4 Wy�wietl wszystkie dane pracownik�w, posiadaj�cych prowizj� od sprzeda�y
--mniejsz� ni� 20% i zarabiaj�cych 8000 10000.
--Display all data of employees who have a sales commission lower than 20% and earn between 8000 and 10000.

select
*
from hr.employees
where nvl(commission_pct, 0) <= 0.2
intersect
select
* from hr.employees
where salary between 8000 and 10000;

---Z.15.5 Wy�wietl dane pracownik�w, kt�rych dzia� jest zlokalizowany w �United Kingdom".
--Wykorzystaj podzapytania.
--Display the data of employees whose department is located in the United Kingdom.
--Use subqueries.

select
* 
from hr.employees
where department_id IN (select department_id from hr.departments where location_id IN (select location_id from hr.locations where country_id='UK'));

---Z.15.6 Wy�wietl dane pracownik�w, kt�rych dzia� jest zlokalizowany w �United Kingdom".
--Wykorzystaj z��czenia tabel.
--Display the data of employees whose department is located in the United Kingdom.
--Use table joins.

select
*
from hr.employees e join hr.departments d using(department_id) join hr.locations l using(location_id)
join hr.countries c using(country_id) where country_name='United Kingdom';



