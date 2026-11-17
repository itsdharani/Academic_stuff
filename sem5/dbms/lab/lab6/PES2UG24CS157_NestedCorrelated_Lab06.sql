SELECT Hostel_ID, Hostel_Name, Capacity
FROM hostel
WHERE Capacity > (SELECT AVG(Capacity) FROM hostel);

SELECT S.Student_ID, S.First_Name, S.Last_Name
FROM student S
WHERE S.Student_ID IN (
    SELECT P.Student_ID
    FROM payment P
    WHERE P.Amount = (SELECT MAX(Amount) FROM payment)
);

SELECT DISTINCT S.Student_ID, S.First_Name, S.Last_Name
FROM student S
WHERE S.Student_ID IN (
    SELECT P.Student_ID
    FROM payment P
    WHERE P.Amount > (SELECT AVG(Amount) FROM payment)
);

SELECT Staff_ID, Staff_Name, Designation, Salary
FROM staff
WHERE Salary > (SELECT AVG(Salary) FROM staff);

SELECT DISTINCT S.Student_ID, S.First_Name, S.Last_Name
FROM student S
JOIN allocation A ON S.Student_ID = A.Student_ID
WHERE A.Hostel_ID IN (
    SELECT Hostel_ID
    FROM hostel
    WHERE Capacity = (SELECT MAX(Capacity) FROM hostel)
);

SELECT Student_ID, First_Name, Last_Name
FROM student
WHERE Student_ID NOT IN (
    SELECT Student_ID FROM payment
);

SELECT Staff_ID, Staff_Name, Salary, Hostel_ID
FROM staff
WHERE Salary > ALL (
    SELECT Salary
    FROM staff
    WHERE Hostel_ID = 3
);

SELECT Staff_ID, Staff_Name, Salary, Hostel_ID
FROM staff
WHERE Salary > ANY (
    SELECT Salary
    FROM staff
    WHERE Hostel_ID = 4
);

SELECT DISTINCT S.Student_ID, S.First_Name, S.Last_Name
FROM student S
JOIN payment P ON S.Student_ID = P.Student_ID
WHERE P.Amount = (SELECT MIN(Amount) FROM payment);

SELECT S.Student_ID, S.First_Name, S.Last_Name,
       SUM(P.Amount) AS Total_Paid
FROM student S
JOIN payment P ON S.Student_ID = P.Student_ID
GROUP BY S.Student_ID, S.First_Name, S.Last_Name
HAVING SUM(P.Amount) > (
    SELECT AVG(Student_Total)
    FROM (
        SELECT SUM(Amount) AS Student_Total
        FROM payment
        GROUP BY Student_ID
    ) AS Per_Student_Totals
);

SELECT DISTINCT S.Student_ID, S.First_Name, S.Last_Name
FROM student S
JOIN payment P ON S.Student_ID = P.Student_ID
WHERE P.Amount > (
    SELECT AVG(P2.Amount)
    FROM payment P2
    WHERE P2.Student_ID IN (
        SELECT A.Student_ID
        FROM allocation A
        WHERE A.Hostel_ID = 2
    )
);

SELECT S1.Staff_ID, S1.Staff_Name, S1.Salary, S1.Hostel_ID
FROM staff S1
WHERE S1.Salary > (
    SELECT AVG(S2.Salary)
    FROM staff S2
    WHERE S2.Hostel_ID = S1.Hostel_ID
);

SELECT DISTINCT S.Student_ID, S.First_Name, S.Last_Name
FROM student S
WHERE EXISTS (
    SELECT 1
    FROM payment P1
    WHERE P1.Student_ID = S.Student_ID
      AND P1.Amount > (
          SELECT AVG(P2.Amount)
          FROM payment P2
          WHERE P2.Student_ID = S.Student_ID
      )
);

SELECT Student_ID, First_Name, Last_Name
FROM student S
WHERE EXISTS (
    SELECT 1
    FROM payment P
    WHERE P.Student_ID = S.Student_ID
      AND P.Amount > 30000
);

SELECT Student_ID, First_Name, Last_Name
FROM student S
WHERE NOT EXISTS (
    SELECT 1
    FROM payment P
    WHERE P.Student_ID = S.Student_ID
);

SELECT Student_ID, First_Name, Last_Name
FROM student S
WHERE EXISTS (
    SELECT 1
    FROM uses U
    WHERE U.Student_ID = S.Student_ID
);

SELECT S1.Staff_ID, S1.Staff_Name, S1.Salary, S1.Hostel_ID
FROM staff S1
WHERE S1.Salary = (
    SELECT MAX(S2.Salary)
    FROM staff S2
    WHERE S2.Hostel_ID = S1.Hostel_ID
);

SELECT A1.Hostel_ID, A1.Room_Number, A1.Student_ID
FROM allocation A1
WHERE (
    SELECT COUNT(*)
    FROM allocation A2
    WHERE A2.Hostel_ID = A1.Hostel_ID
      AND A2.Room_Number = A1.Room_Number
) > 1;

SELECT S.Student_ID, S.First_Name, S.Last_Name,
       (
           SELECT COUNT(*)
           FROM payment P
           WHERE P.Student_ID = S.Student_ID
       ) AS Num_Payments
FROM student S
WHERE (
    SELECT COUNT(*)
    FROM payment P
    WHERE P.Student_ID = S.Student_ID
) >
(
    SELECT AVG(Payment_Count)
    FROM (
        SELECT COUNT(*) AS Payment_Count
        FROM payment
        GROUP BY Student_ID
    ) AS Per_Student_Counts
);

SELECT S1.Staff_ID, S1.Staff_Name, S1.Salary
FROM staff S1
WHERE (
    SELECT COUNT(*)
    FROM staff S2
    WHERE S2.Salary = S1.Salary
      AND S2.Staff_ID <> S1.Staff_ID
) = 0
ORDER BY S1.Salary DESC;

SELECT Student_ID, First_Name, Last_Name
FROM student S
WHERE NOT EXISTS (
    SELECT F.Facility_ID
    FROM uses F
    WHERE F.Student_ID = 1
    AND NOT EXISTS (
        SELECT 1
        FROM uses U2
        WHERE U2.Student_ID = S.Student_ID
          AND U2.Facility_ID = F.Facility_ID
    )
);

SELECT S.Student_ID, S.First_Name, S.Last_Name,
       (
           SELECT COUNT(*)
           FROM receipt R
           JOIN payment P ON R.Payment_ID = P.Payment_ID
           WHERE P.Student_ID = S.Student_ID
       ) AS Num_Receipts
FROM student S
WHERE (
    SELECT COUNT(*)
    FROM receipt R
    JOIN payment P ON R.Payment_ID = P.Payment_ID
    WHERE P.Student_ID = S.Student_ID
) > 1;