# Assignment 1: Rides Analytics Pipeline
#### Name: Dharani S
#### Srn: PES2UG24CS157
#### Section: C

### Figure 1 : Airflow. The rides_pipeline DAG after a manual run: `seatunnel_transform → mr_avg_speed_by_city → mr_avg_fare_per_km_by_city → route_to_local`, every task success.
![alt text](image-2.png)
### Figure 2 : YARN ResourceManager. Both MapReduce applications listed as FINISHED / SUCCEEDED - proof the jobs ran on the cluster, not locally.
![alt text](image-4.png)
### Figure 3 - HDFS NameNode. Browsing the analytics output directory: a _SUCCESS marker and a part-r-00000 file for the MapReduce output.
![alt text](image-5.png)
![alt text](image-6.png)

---

### csv outputs

![alt text](image-7.png)
![alt text](image-8.png)
![alt text](image-9.png)
![alt text](image-10.png)