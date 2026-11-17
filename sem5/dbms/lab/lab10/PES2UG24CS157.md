# Lab 10: Neo4j (Movies Dataset)

**SRN:** PES2UG24CS157
**Name:** Dharani

---

### Q1: Add the Classic label

```cypher
// PES2UG24CS157_Dharani
MATCH (m:Movie)
WHERE m.released < 1995
SET m:Classic
RETURN m;
```

![Q1 labels added](image.png)
![Q1 node details showing Classic and Movie](image-1.png)

---

### Q2. Displaying the whole graph

```cypher
// PES2UG24CS157_Dharani
MATCH (a)-[r]->(b)
RETURN a, r, b;
```

![Q2 whole graph with results overview](image-2.png)

**Totals:** 171 nodes and 253 relationships.
- **By label:** Movie 38, Person 133, Classic 9 (Classic is the extra label added in Q1, on movies that are also Movie).
- **By type:** ACTED_IN 172, DIRECTED 44, PRODUCED 15, WROTE 10, REVIEWED 9, FOLLOWS 3.

---

### Q3. Keanu Reeves, other films

```cypher
// PES2UG24CS157_Dharani
MATCH (p:Person {name: 'Keanu Reeves'})-[r:ACTED_IN]->(m:Movie)
WHERE NOT m.title CONTAINS 'Matrix'
RETURN p, r, m
ORDER BY m.title DESC
LIMIT 3;
```

![Q3 Keanu Reeves graph](image-3.png)

---

### Q4. UNION on two relationship types

```cypher
// PES2UG24CS157_Dharani
MATCH (p:Person)-[relation:ACTED_IN]->(m:Movie {title: 'Hoffa'})
RETURN p, relation, m
UNION
MATCH (p:Person)-[relation:DIRECTED]->(m:Movie {title: 'Hoffa'})
RETURN p, relation, m;
```

![Q4 Hoffa actors and director](image-4.png)

---

### Q5. Trivia candidates

```cypher
// PES2UG24CS157_Dharani
MATCH (m:Movie)
WHERE m.released < 1990
RETURN m.title AS name, 'Movie' AS type
UNION
MATCH (p:Person)
WHERE p.born >= 1980
RETURN p.name AS name, 'Person' AS type;
```

![Q5 table of candidates](image-5.png)

---

### Q6a: Create the test person

```cypher
// PES2UG24CS157_Dharani
MATCH (m:Movie {title: 'Hoffa'})
CREATE (p:Person {name: 'Test Student', born: 2004})
CREATE (p)-[:ACTED_IN {roles: ['Extra']}]->(m)
CREATE (p)-[:DIRECTED]->(m)
CREATE (p)-[:PRODUCED]->(m)
RETURN p.name, m.title;
```

![Q6a node and relationships created](image-6.png)

---

### Q6b: Count relationships by type

```cypher
// PES2UG24CS157_Dharani
MATCH ()-[r:ACTED_IN]->()
RETURN 'ACTED_IN' AS relationship, count(r) AS total
UNION
MATCH ()-[r:DIRECTED]->()
RETURN 'DIRECTED' AS relationship, count(r) AS total
UNION
MATCH ()-[r:PRODUCED]->()
RETURN 'PRODUCED' AS relationship, count(r) AS total;
```

![Q6b relationship counts](image-7.png)

---

### Q6c: Delete the test person

```cypher
// PES2UG24CS157_Dharani
MATCH (p:Person {name: 'Test Student'})
DETACH DELETE p;
```

![Q6c deleted 1 node, deleted 3 relationships](image-8.png)

 A plain DELETE would fail with an error, because the node still has relationships attached to it. Neo4j refuses to delete a node that has relationships, since that would leave relationships pointing at nothing. DETACH DELETE removes the relationships first and then the node.