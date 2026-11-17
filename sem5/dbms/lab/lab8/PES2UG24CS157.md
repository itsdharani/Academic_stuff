# DBMS LAB 8
- Name: Dharani S
- SRN: PES2UG24CS157
- Section: C
### Task 1:
![alt text](image.png)
### Task 2:
2.1
![alt text](image-1.png)
2.2
![alt text](image-2.png)
2.3
![alt text](image-3.png)

### Task 3
3.1
![alt text](image-4.png)
3.2
![alt text](image-5.png)

the rollback and the stock back to 20.
![alt text](image-6.png)
### Task 4
READ COMMITTED
4.1 (Session 1): shows 20.
![alt text](image-7.png)

4.2
(Session 2): all 4 statements.
![alt text](image-8.png)

4.3
![alt text](image-9.png)

### Task 5:
5.1
![alt text](image-10.png)
5.2
![alt text](image-11.png)
5.3
![alt text](image-12.png)
### Task 6

6.1 and 6.2
![alt text](image-13.png)
6.3
![alt text](image-14.png)
![alt text](image-15.png)

### Task 7
7.1
![alt text](image-16.png)


## Observation table

| Isolation Level | Observation |
|---|---|
| READ UNCOMMITTED | B saw stock = 5 from A's uncommitted update (dirty read). |
| READ COMMITTED | A's second read showed 18 after B committed (non-repeatable read). |
| REPEATABLE READ | A still saw price 6500.00 after B committed 7000.00 (consistent read). |
| SERIALIZABLE | B's INSERT waited until A committed (range blocked). |

