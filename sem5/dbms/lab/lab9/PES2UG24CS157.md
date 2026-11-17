# Redis Lab: PromptPal

**Name:** Dharani S
**SRN:** PES2UG24CS157

---

### Q1. Daily quota

```
ECHO "PES2UG24CS157"
FLUSHDB
MSET quota:u1 20 quota:u2 50
MGET quota:u1 quota:u2
```

![Q1 screenshot](image.png)

---

### Q2. Start a chat

```
ECHO "PES2UG24CS157"
FLUSHDB
RPUSH conv:101 "Hello" "Hi! How can I help?"
LRANGE conv:101 0 -1
LPUSH conv:101 "SYSTEM: be concise"
LRANGE conv:101 0 -1
```

![Q2 screenshot](image-1.png)

---

### Q3. User profile

```
ECHO "PES2UG24CS157"
FLUSHDB
HSET user:1 name "Meera" plan "free" credits "10"
HGET user:1 plan
HGETALL user:1
HINCRBY user:1 credits 50
HLEN user:1
```

![Q3 screenshot](image-2.png)

---

### Q4. OTP and quota

```
ECHO "PES2UG24CS157"
FLUSHDB
SET otp:u1 "483920" EX 120
SET quota:u1 "20"
INCRBY quota:u1 -3
SET status:u1 "Online"
APPEND status:u1 " (busy)"
MGET otp:u1 quota:u1 quota:u99
```

![Q4 screenshot](image-3.png)

**Part 3:** Redis replied 13. This is the new total length of the string ("Online" is 6 characters and " (busy)" is 7).

**Part 4:** quota:u99 shows (nil) because the key was never created.

---

### Q5. Beta Program

```
ECHO "PES2UG24CS157"
FLUSHDB
SADD beta:gpt-next u1 u2 u3
SMEMBERS beta:gpt-next
SISMEMBER beta:gpt-next u3
SADD beta:gpt-next u2 u4
SCARD beta:gpt-next
SREM beta:gpt-next u4
```

![Q5 screenshot](image-4.png)

**Part 4:** Redis returned 1. SADD counts only new members. u2 was already enrolled, so only u4 was counted.

---

### Q6. Leaderboard

```
ECHO "PES2UG24CS157"
FLUSHDB
ZADD leaderboard:tokens 500 ava 800 ben 300 cara
ZCARD leaderboard:tokens
ZREVRANGE leaderboard:tokens 0 -1
ZINCRBY leaderboard:tokens 700 cara
ZREVRANGE leaderboard:tokens 0 -1 WITHSCORES
```

![Q6 screenshot](image-5.png)

**Part 5:** cara is #1 with a score of 1000.

---

### Q7. Support ticket queue

```
ECHO "PES2UG24CS157"
FLUSHDB
RPUSH tickets "T1" "T2" "T3"
LPUSH tickets "URGENT-1"
LRANGE tickets 0 -1
LPOP tickets
RPOP tickets
RPUSH tickets "T4" "T5"
LTRIM tickets 0 1
LRANGE tickets 0 -1
```

![Q7 screenshot](image-6.png)

**Part 4:** LPOP returned "URGENT-1".

**Part 5:** RPOP returned "T3".

---

### Q8. Updating a profile

```
ECHO "PES2UG24CS157"
FLUSHDB
HSET user:2 name "Ravi" plan "pro" credits "100"
HINCRBY user:2 credits -30
HINCRBY user:2 messages 1
HDEL user:2 plan
HEXISTS user:2 plan
HLEN user:2
HGETALL user:2
```

![Q8 screenshot](image-7.png)

---

### Q9. Leaderboard Race

```
ECHO "PES2UG24CS157"
FLUSHDB
ZADD leaderboard:tokens 500 ava 800 ben 300 cara 600 dev
ZCARD leaderboard:tokens
ZREVRANGE leaderboard:tokens 0 -1
ZINCRBY leaderboard:tokens 400 ava
ZREVRANK leaderboard:tokens ava
ZRANK leaderboard:tokens cara
ZREM leaderboard:tokens ben
ZREVRANGE leaderboard:tokens 0 -1 WITHSCORES
```

![Q9 screenshot](image-8.png)

**Part 5:** Ava is at position 0 from the highest score (900).

**Part 6:** Cara is at position 0 from the lowest score (300).

---

### Q10. Pick the right type

```
ECHO "PES2UG24CS157"
FLUSHDB
SET otp:u5 "7781" EX 60
RPUSH conv:5 "Hi"
HSET user:5 name "Neha" plan "free"
SADD beta:gpt-next u5
ZADD leaderboard:tokens 250 u5
SADD beta:gpt-next u5
RPUSH user:5 "hello"
```

![Q10 screenshot](image-9.png)

| Part | Need | Redis type | Command |
|---|---|---|---|
| 1 | One value that expires after 60 seconds | String | `SET otp:u5 "7781" EX 60` |
| 2 | Ordered chat messages | List | `RPUSH conv:5 "Hi"` |
| 3 | Named attributes under one key | Hash | `HSET user:5 name "Neha" plan "free"` |
| 4 | Unique participants, no order | Set | `SADD beta:gpt-next u5` |
| 5 | Members ordered by numeric score | Sorted Set | `ZADD leaderboard:tokens 250 u5` |

**Part 6:** Redis returned 0. u5 is already a member of the Set, and a Set never holds duplicates, so nothing new was added. This is not an error.

**Part 7:** Redis returned a WRONGTYPE error. user:5 is a Hash, and RPUSH is a List command. A key can hold only one type.