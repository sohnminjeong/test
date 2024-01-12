SET SQL_SAFE_UPDATES = 1;

-- [1번째 시험]
-- # Q1. --------------------------------------------------------------
SELECT * FROM employee;
INSERT INTO employee VALUES(300, '전지우', '700101-1234567');
-- 오류 원인 : VALUES 뒤에 작성된 값에 대한 컬럼이 명시되지 않았다.
-- 조치 내용 
INSERT INTO employee(emp_id, emp_name, emp_no) VALUES(300, '전지우', '700101-1234567');

-- [Q1. 강사님]
INSERT INTO employee(emp_id, emp_name, emp_no) VALUES(300, '전지우', '700101-1234567');
INSERT INTO employee VALUES(300, '전지우', '700101-1234567', null, null, null, null, null, null, null, null, null, null);


-- # Q2. ------------------------------------------------------------
SELECT emp_name, emp_no, dept_code, salary
FROM employee
WHERE dept_code = 'D6' OR dept_code = 'D9'
AND salary > 3000000 
AND email LIKE '___%';
-- 문제점(3가지)
-- 1. OR&AND 우선순위에 의해 dept_code = 'D6' OR (dept_code = 'D9' AND salary > 3000000)으로 처리됨
-- 2. salary가 300만원 이상인데 초과인 부등호는 들어가 있으나 같다는 등호가 빠져있다. 
-- 3. 사원의 이메일 주소가 _ 앞에 3글자인 경우만 찾고 있는데 '___%'의 경우는 앞에 세글자가 무조건 오고 
-- 뒤에는 어떤 것이 와도 상관 없다는 의미임으로 _ 앞에 3글자라는 부분을 따로 명시해야 한다. 

-- 조치 내용 
-- 1. 조건에서 dept_code가 D6이거나 D9인 경우를 ()를 이용해 묶어 우선순위를 설정함
-- 2.  salary가 300만원 이상임으로 '='등호도 넣어 salary >= 3000000으로 변경
-- 3. email에서 '_'를 언급하여 넘어가야 하기 때문에 
SELECT emp_name, emp_no, dept_code, salary
FROM employee
WHERE (dept_code = 'D6' OR dept_code = 'D9')
AND salary >= 3000000
AND email LIKE '___#_%' escape'#';

-- [Q2. 강사님] 
SELECT emp_name, emp_no, dept_code, salary
FROM employee
WHERE dept_code IN('D6', 'D9')
AND salary >= 3000000
AND email LIKE '___#_%' escape'#';


-- # Q3. ---------------------------------------------------
SELECT * 
FROM employee
WHERE bonus = null;
-- 문제 오류 : null 값의 경우 bonus is null로 표현해야 함
-- 조치 내용
SELECT *
FROM employee
WHERE bonus IS NULL;

-- [Q3. 강사님]
SELECT *
FROM employee
WHERE bonus IS NULL;
-- 비교 연산자(=)가 아닌 IS NULL이라고 표현해야 한다.


-- ---------------------------------------------------------------------------------------------------

-- [2번째 시험] ----------------------------------------------------------------------------------------
UPDATE department SET dept_title = '해외영업1부' WHERE dept_id = 'D5';
UPDATE department SET dept_title = '해외영업2부' WHERE dept_id = 'D6';
UPDATE department SET dept_title = '해외영업3부' WHERE dept_id = 'D7';

-- # Q1. --------------------------------------------------------------
-- 부서 별 평균 월급이 280만원을 초과하는 부서 조회
SELECT dept_code, sum(salary) 합계, avg(salary) 평균, count(*) 인원수
FROM employee
WHERE salary > 2800000
GROUP BY dept_code
ORDER BY dept_code;

-- 오류 원인
-- 1. 부서 별 평균 월급을 구하는 것이기 때문에 WHERE이 아닌 HAVING을 사용해야 한다.
-- 2. 합계와 평균 값이 세자리 수마다 ','로 표시되어 있어야 함으로 format 사용해야 한다. 

-- 조치 내용
SELECT dept_code, format(sum(salary),0) '합계', format(avg(salary),0) '평균', count(*) '인원수'
FROM employee
GROUP BY dept_code
HAVING avg(salary) > 2800000;

-- [Q1. 강사님]
SELECT dept_code, sum(salary) 합계, avg(salary) 평균, count(*) 인원수
FROM employee
GROUP BY dept_code
HAVING avg(salary) > 2800000
ORDER BY dept_code;



-- # Q2. ------------------------------------------------------------
-- 해외영업1부, 해외영업2부, 해외영업3부를 해외영업부로 변경하는 UPDATE문을 작성
SELECT * FROM department;
UPDATE department
SET dept_title ='해외영업부'
WHERE dept_title LIKE '해외%';

-- 오류 원인 : UPDATE를 사용할 때는 KEY 컬럼을 사용하는 WHERE 절이 없어야 함으로 WHERE 절에 
-- dept_title이 아닌 dept_id를 이용한다.
-- 조치 내용 
UPDATE department
SET dept_title = '해외영업부'
WHERE dept_id IN('D5', 'D6', 'D7');

-- [Q2. 강사님]
UPDATE department
SET dept_title = '해외영업부'
WHERE dept_id IN('D5', 'D6', 'D7');
-- UPDATE 및 DELETE에서는 WHERE절에서 primary key(기본키)를 가지고 수정해야 함 



-- [3번째 시험] ----------------------------------------------------------------------------------------
-- # Q1. --------------------------------------------------------------
-- 사원명, 직급코드, 보너스 받는 사원 수 조회
-- 직급코드 순으로 오름차순 정렬(desc)
SELECT emp_name, job_code, count(*) as 사원수
FROM employee
WHERE bonus != NULL
GROUP BY emp_name, job_code
ORDER BY job_code;

-- 오류 원인
-- 1. 보너스를 받는 사원이라는 조건을 걸 때는 bonus IS NOT NULL을 사용해야 한다.
-- 2. group by를 할 경우 SELECT에 컬럼 및 해당 컬럼의 count, sum 등의 식을 걸어야 하기 때문에 
-- job_code에만 걸 경우 emp_name이 문제가 된다. 그러므로 emp_name, job_code 함께 해야한다.

-- 조치 내용
SELECT emp_name, job_code, count(*) as 사원수
FROM employee
WHERE bonus IS NOT NULL
GROUP BY emp_name, job_code
ORDER BY job_code;

-- [Q1. 강사님]
SELECT emp_name, job_code, count(*) as 사원수
FROM employee
WHERE bonus IS NOT NULL
GROUP BY emp_name, job_code
ORDER BY job_code;
-- > GROUP BY 여러개 가능 -> 묶고자 하는 것들을 작성 
-- > GROUP BY는 SELECT의 컬럼값과 그룹 함수만 사용 가능


-- # Q2. --------------------------------------------------------------
-- 두 개의 테이블 조인 / emp_id, emp_name, dept_id, dept_title 조회
SELECT emp_id, emp_name, dept_id, dept_title
FROM employee
 JOIN department USING(dept_id);
 
 -- 오류 원인
 -- 1. employee 테이블과 department 테이블을 JOIN 할 때는 USING(dept_id)가 아닌 
 -- employee의 dept_code와 department의 dept_id를 연결해야 하고 이땐 USING이 아닌 ON을 사용해야 한다.
 -- 2. 정답과 같이 결과가 나올려면 dept_title이 총무부인 사람들만 조회해야 한다.

 
 -- 조치 내용
 SELECT emp_id, emp_name, dept_id, dept_title
 FROM employee
	JOIN department ON(dept_code = dept_id)
WHERE dept_title = '총무부';


-- [Q2. 강사님]
SELECT emp_id, emp_name, dept_id, dept_title
 FROM employee
	JOIN department ON(dept_code = dept_id)
WHERE dept_title = '총무부';
-- WHERE dept_id = 'D9';
-- ORDER BY emp_id   LIMIT 3;



