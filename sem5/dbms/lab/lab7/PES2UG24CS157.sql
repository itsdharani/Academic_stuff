USE smart_hostel;

-- Task 1
DROP TABLE IF EXISTS PAYMENT_AUDIT;
CREATE TABLE PAYMENT_AUDIT (
    Audit_ID    INT AUTO_INCREMENT PRIMARY KEY,
    Payment_ID  VARCHAR(12) NOT NULL,
    Student_ID  VARCHAR(12) NOT NULL,
    Old_Amount  DECIMAL(10,2) NULL,
    New_Amount  DECIMAL(10,2) NULL,
    Action_Type VARCHAR(10) NOT NULL,
    Changed_On  DATETIME NOT NULL
);

-- Task 1.1
DROP TRIGGER IF EXISTS trg_payment_amount_insert;
DELIMITER $$
CREATE TRIGGER trg_payment_amount_insert
BEFORE INSERT ON PAYMENT
FOR EACH ROW
BEGIN
    IF NEW.Amount < 12000.00 OR NEW.Amount > 55000.00 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Payment amount out of permitted range';
    END IF;
END $$
DELIMITER ;

-- Task 1.1
INSERT INTO PAYMENT VALUES ('PAY017', 11999.99, 'UPI', CURDATE(), 'PES23CS017');
-- Task 1.1
INSERT INTO PAYMENT VALUES ('PAY017', 12000.00, 'UPI', CURDATE(), 'PES23CS017');
-- Task 1.1
INSERT INTO PAYMENT VALUES ('PAY018', 55000.00, 'UPI', CURDATE(), 'PES23CS017');
-- Task 1.1
INSERT INTO PAYMENT VALUES ('PAY019', 30000.00, 'UPI', CURDATE(), 'PES23CS017');
-- Task 1.1
INSERT INTO PAYMENT VALUES ('PAY020', 55000.01, 'UPI', CURDATE(), 'PES23CS017');
-- Task 1.1
SELECT * FROM PAYMENT WHERE Payment_ID IN ('PAY017','PAY018','PAY019');
-- Task 1.1
SELECT COUNT(*) AS Total_Rows FROM PAYMENT;
-- Task 1.1
SELECT * FROM PAYMENT WHERE Payment_ID = 'PAY002';

-- Task 1.2
DROP TRIGGER IF EXISTS trg_payment_amount_update;
DROP TRIGGER IF EXISTS trg_payment_audit_update;
DELIMITER $$
CREATE TRIGGER trg_payment_amount_update
BEFORE UPDATE ON PAYMENT
FOR EACH ROW
BEGIN
    IF NEW.Amount < 12000.00 OR NEW.Amount > 55000.00 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Payment amount out of permitted range';
    END IF;
END $$

CREATE TRIGGER trg_payment_audit_update
AFTER UPDATE ON PAYMENT
FOR EACH ROW
BEGIN
    IF NOT (OLD.Amount <=> NEW.Amount) THEN
        INSERT INTO PAYMENT_AUDIT (Payment_ID, Student_ID, Old_Amount, New_Amount, Action_Type, Changed_On)
        VALUES (OLD.Payment_ID, OLD.Student_ID, OLD.Amount, NEW.Amount, 'UPDATE', NOW());
    END IF;
END $$
DELIMITER ;

-- Task 1.2
UPDATE PAYMENT SET Amount = 60000.00 WHERE Payment_ID = 'PAY018';
-- Task 1.2
UPDATE PAYMENT SET Amount = 40000.00 WHERE Payment_ID = 'PAY019';
-- Task 1.2
UPDATE PAYMENT SET Payment_Type = 'CARD' WHERE Payment_ID = 'PAY019';
-- Task 1.2
SELECT * FROM PAYMENT_AUDIT;

-- Task 1.3
DROP PROCEDURE IF EXISTS sp_issue_receipt;
DELIMITER $$
CREATE PROCEDURE sp_issue_receipt(IN p_payment_id VARCHAR(12))
BEGIN
    INSERT INTO RECEIPT (Receipt_ID, Receipt_Date, Payment_ID)
    VALUES (CONCAT('RCP', SUBSTRING(p_payment_id, 4)), CURDATE(), p_payment_id);
END $$
DELIMITER ;

-- Task 1.3
DROP TRIGGER IF EXISTS trg_payment_issue_receipt;
DELIMITER $$
CREATE TRIGGER trg_payment_issue_receipt
AFTER INSERT ON PAYMENT
FOR EACH ROW
BEGIN
    CALL sp_issue_receipt(NEW.Payment_ID);
END $$
DELIMITER ;

-- Task 1.3
INSERT INTO PAYMENT VALUES ('PAY022', 20000.00, 'UPI', CURDATE(), 'PES23CS017');
-- Task 1.3
SELECT * FROM RECEIPT WHERE Payment_ID = 'PAY022';

-- Task 2.1
DROP PROCEDURE IF EXISTS sp_hostel_roster;
DELIMITER $$
CREATE PROCEDURE sp_hostel_roster(IN p_hostel_id VARCHAR(10))
BEGIN
    SELECT a.Room_Number,
           s.Student_ID,
           CONCAT_WS(' ', s.First_Name, s.Middle_Name, s.Last_Name) AS Student_Name,
           s.Gender,
           TIMESTAMPDIFF(YEAR, s.Date_of_Birth, CURDATE()) AS Age,
           COALESCE((SELECT SUM(p.Amount) FROM PAYMENT p WHERE p.Student_ID = s.Student_ID), 0.00) AS Total_Paid
    FROM ALLOCATE a
    JOIN STUDENT s ON s.Student_ID = a.Student_ID
    WHERE a.Hostel_ID = p_hostel_id
    ORDER BY a.Room_Number, s.Student_ID;
END $$
DELIMITER ;

-- Task 2.1
CALL sp_hostel_roster('H01');

-- Task 2.2
DROP PROCEDURE IF EXISTS sp_payment_summary;
DELIMITER $$
CREATE PROCEDURE sp_payment_summary(
    IN  p_student_id VARCHAR(12),
    OUT p_total DECIMAL(10,2),
    OUT p_count INT)
BEGIN
    SELECT COALESCE(SUM(Amount), 0.00), COUNT(*)
    INTO p_total, p_count
    FROM PAYMENT
    WHERE Student_ID = p_student_id;
END $$
DELIMITER ;

-- Task 2.2
CALL sp_payment_summary('PES23CS004', @total, @count);
-- Task 2.2
SELECT 'PES23CS004' AS Student, @total AS Total_Paid, @count AS No_Of_Payments;
-- Task 2.2
CALL sp_payment_summary('PES23CS007', @total, @count);
-- Task 2.2
SELECT 'PES23CS007' AS Student, @total AS Total_Paid, @count AS No_Of_Payments;

-- Task 3.1
DROP FUNCTION IF EXISTS fn_student_age;
DELIMITER $$
CREATE FUNCTION fn_student_age(p_student_id VARCHAR(12))
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_age INT;
    SELECT TIMESTAMPDIFF(YEAR, Date_of_Birth, CURDATE())
    INTO v_age
    FROM STUDENT
    WHERE Student_ID = p_student_id;
    RETURN v_age;
END $$
DELIMITER ;

-- Task 3.1
SELECT fn_student_age('PES23CS001') AS Age_of_PES23CS001;
-- Task 3.1
SELECT Student_ID, First_Name, Date_of_Birth, fn_student_age(Student_ID) AS Age
FROM STUDENT
ORDER BY Student_ID
LIMIT 6;

-- Task 3.2
DROP FUNCTION IF EXISTS fn_total_paid;
DELIMITER $$
CREATE FUNCTION fn_total_paid(p_student_id VARCHAR(12))
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);
    SELECT COALESCE(SUM(Amount), 0.00)
    INTO v_total
    FROM PAYMENT
    WHERE Student_ID = p_student_id;
    RETURN v_total;
END $$
DELIMITER ;

-- Task 3.2
SELECT fn_total_paid('PES23CS001') AS Paid_001, fn_total_paid('PES23CS007') AS Paid_007;
-- Task 3.2
SELECT Student_ID, fn_total_paid(Student_ID) AS Total_Paid
FROM STUDENT
ORDER BY Student_ID
LIMIT 8;