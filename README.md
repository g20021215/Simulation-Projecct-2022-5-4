# Simulation Project: 
# Question 2: Simulation on A Queuing System with Two Parallel
Group memebers:
陈俊霖（2030005004）  陈郅涵（2030005013） 李文锐（2030005036） 施金泽（2030005049） 
王一安（2030005058）叶中宇（2030005069）  邹宜轩（2030005079）

Date:2022/5/4
## Introduction：
  In this preseation, we will give two different method to solve this problem. One is the ordinary method and the other is queuing theorem
## Part a
### Method 1:
#### Idea discription:

#### Code:
```matlab
[Result_matrix,m,E,S] = me_code2(10000);
me = mean(S);
sd = sqrt(var(S));

pd = makedist('Exponential');
%pd = makedist('Normal')
qqplot(S,pd);
```
## Part b:

### Method 2:Queueing Theory
#### Algorithm：

#### Code:

#### Result:
Cashier1： ![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/Cashier1.png)

Cashier2： ![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/Cashier2.png)




## Relevant Materials:

