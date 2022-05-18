# Simulation Project: 
# Question 2: Simulation on A Queuing System with Two Parallel
Group memebers:

陈俊霖（2030005004）  

陈郅涵（2030005013） 

李文锐（2030005036） 

施金泽（2030005049） 

王一安（2030005058）

叶中宇（2030005069）  

邹宜轩（2030005079）

Date:2022/5/4

<br>


<br />

# Content:
  ## Introduction 陈俊霖
  ## Lecture Part 1: Queuing theorem
  ### Part a
  #### Queuing Theorem 陈郅涵
  ## Lecture Part 2: Textbook Method (Solution):
  ### Part a (a)
  #### Algorithm 施金泽
  #### Code 邹宜轩
  #### Part a(b) 叶中宇
  ### Part b:李文锐
  #### Flow diagram
  #### Simulation Conclusion 
  #### Testing for the distribution
  ### 王一安替补
  ## Relevant material

<br> 










<br />



  
## Introduction：陈俊霖
  In this preseation, we will give two different method to solve this problem. One is the ordinary method and the other is queuing theorem. Each method will give the detailed process of solving this problem.
  
![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/IMG_20200914_182716.jpg)
## Lecture Part 1: Queuing theorem
![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/C1.2.jpeg)
![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/C1.3.jpeg)
![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/C1.1.jpg)
[QUEUE.pdf](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/QUEUE.pdf)

## Lecture Part 2: Textbook Method：Algorithm 施金泽 + Code 邹宜轩
PartA(a)

## Algorithm in the textbook P118:施金泽

<b> Time Variable <b/> t
  
<b> System State Variable (`SS`)<b/>
  
(n, i1, i2) if there are n customers in the system, i1 is with serve 1 and i_2 is with server 2. Note that <b> SS <b/> = (0) when the only system is empty, and <b> SS <b/>= (i, j, 0) or (i, 0, j) when the only customers is j and he is being served by server i ir server 2, respectively.
  
<b>Counter Variables<b/>
  
`Na`: the number of customers arrived by time t.
  
`Cj`: the number of customers served by j, j = 1,2, by time t.
  
<b>Output Variables<b/>
  
`A(n)`: the arrive time (before going to the cashier) of customer n, n >= 1
  
`D(n)`: the departure time of customer n, n >= 1.
  
<b>Event time tA, t1, t2<b/>
  
Where tA is the time of the nexxt arrival, and ti is the service completion time of the customer presently being served by server i, i = 1,2. If there is no customer presently with server i, then we set ti = Inf,i = 1,2. In the following. the event list will always consist of the three variables tA, t1, t2.

<b>Initialize<b/>
  
  set t = Na = C1 = C2 = 0
  
  Set <b>SS<b/> = (0).
  
  Generate `T0` and set `tA` = `T0`, t1 = t2 = Inf
  <br>
  
  <br/>
  To update the system, we move along in time until we encounter the next event. In the following cases, `Yi` always refers to a random variable having distribution ` G1 `,i = 1,2.

``` 
Case 1: SS= (n, i1, i2) and tA = min(tA, t1, t2)
    
    Reset t = tA
    Reset Na = Na + 1
    Generate Tt and reset tA = Tt
    Collect the output data A(Na) = t
  
  If SS = (0):
    Reset SS=(1,Na,0)
    Generate Y2 and reset t2 = t + Y2
  
  If SS = (1,j,0):
    Reset: SS=(2, j, Na)
    Generate Y2 and reset t2 = t + Y2
  
  If SS = (1, 0, j)
  Reset SS = (2, Na, j)
  Generate Y1 and reset t1 = t + Y1
  
  If n > 1:
   Reset SS = (n+1, i1, i2)
  
Case 2: SS = (n, i1, i2) and t1 < tA, t1<= t2
  
    Reset t = t1
    Reset C1 = C1 + 1
    Collect the output data D(i1) = t
  
  If n = 1:
    Reset SS = (0)
    Reset t1 = Inf
  
  If n = 2:
    Reset SS = (1, 0, i2)
    Reset t1 = Inf
  
  If n > 2: Let m = max(t1, t2) and
    Reset SS = (n-1, m+1, i2)
    Generate Y1 and reset t1 = t + Y1
  
Case 3: SS = (n, i1, i2) and t2 < tA, t2 < t1
    Reset t = t2
    Reset C2 = C2 + 1
    Collect the output D(i2) = t
  
  If n = 1:
    Reset SS = (0)
    Reset t1 = Inf
  
  If n = 2:
    Reset SS = (1, i1, 0)
    Reset t2 = Inf
  
  If n > 2: let m = max(i1, i2)
    Reset SS = (n-1, i1, m+1)
    Generate Y2 and reset t2 = t + Y2
``` 

## Part A (a) Code:邹宜轩
```matlab 

lam1=2;% Use it in minutes
mu=8;
std=2;
lam2 = 1;
I=1;
ta=[-1/lam1*log(rand(1))];%%the time of customers' arrival time:

while ta<120
    ta=[ta,ta(I)-1/lam1*log(rand(1))];
    I=I+1;
end
ta(length(ta))=[];%%delete the element which greater than 120;
ta;%%print the time of customers' arrival time;



n=length(ta);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Here I change n to length(ta),previous is length(ta)-1
tc=zeros(n:1);
for i =1:n
    a = normrnd(mu,std);
    if a > 0
        tc(i)=a;%% There is no absolute here
    end
end
tc;%%print the time of customers' sojourning time;


%%%%Get the matrix of this [arrive time, sojourn time]
Time_matrix = zeros(n,3);
for i=1:n
    Time_matrix(i,1) = ta(i);
    Time_matrix(i,2) = tc(i);
    Time_matrix(i,3) = ta(i)+tc(i);
end
Time_matrix = sortrows(Time_matrix,3);% re-arrange the matrix by the 1st rows,
%Time_matrix(Time_matrix > 120)= [];



%%Initialize the state:

t = 0;Na = 1;C1 = 0;C2 = 0;
%SS = [n,i1,i2];
T = 120;
Xt = Time_matrix(1,3);
tA = Xt;
t1 = Inf;t2 = Inf;
n = 0;
%length(ta);
i = 1;i1 = 0;i2 = 0;
D = zeros(1,length(ta));
A = zeros(1,length(ta));
while min([tA,t1,t2]) <= T
    if tA <= t1 && tA <= t2
        t = tA;
        Na = Na + 1;
        Xt = Time_matrix(i,3);
        tA = Xt;
        A(Na) = t;
        if n == 0 && i1 == 0 && i2 == 0 
            n = 1; i1 = Na;
            Y1 = exprnd(lam2);
            t1 = Y1 + t;
        elseif n == 1 && i1 > 0 && i2 == 0
            n = 2; i2 = Na;
            Y2 = exprnd(lam2);
            t2 = t + Y2;
        elseif n == 1 && i1 == 0 && i2 > 0
            n = 2; i1 = Na;
            Y1 = exprnd(lam2);
            t1 = t + Y1;
        elseif n > 1
            n = n + 1;
        end
    elseif t1 < tA && t1 <= t2
        t = t1;
        C1 = C1 + 1;
        D(i1) = t;
        if n == 1
            n = 0; i1 = 0; i2 = 0;
            t1 = Inf;
        elseif n==2
            n = 1; i1 = 0;
            t1 = Inf;
        elseif n > 2
            m = max(i1,i2);
            n = n - 1; i1 = m+1;
            Y1 = exprnd(lam2);
            t = t+Y1;
        end
    elseif t2 < tA && t2 < t1
        t = t2;
        C2 = C2 + 1;
        D(i2) = t;
        if n == 1
            n = 0; i1 = 0; i2 = 0;
            t2 = Inf;
        elseif n == 2
            n = 1; i2 = 0;
            t2 = Inf;
        elseif n > 2
            n = n - 1;
            m = max(i1,i2);
            i2 = m + 1;
            Y2 = exprnd(lam2);
            t2 = t + Y2;
        end
    end
    i = i + 1;     
end
A(A == 0) = [];
D(D == 0) = [];

```
Running Result: 
  
```matlab
    Arriving Time         Sojourn Time            Waiting Time          Departure Time
    0.5559    5.5801    0.5026    6.6386              12.7468    5.1127    0.5667   30.9084               20.9992   11.1573    1.1720   62.0125             41.1605    7.9404    0.2160   88.7936             55.3877    8.1817    0.7583  112.9045
    3.4072    3.3275    2.7062    8.8422              10.0947    8.1081    0.7066   33.7468               27.5962    5.4440    0.3177   63.8871             40.4669    9.7611    1.0693   89.9610             58.4117    5.7263    0.2996  112.7756        
    2.4254    5.0631    0.2339    6.9686              14.0988    4.6655    1.9921   35.6961               24.6682    9.0359    2.7264   68.4102             43.2153    7.1708    0.2236   91.5397             54.9820   10.1696    0.0640  112.8892
    2.2712    5.2844    1.3167    8.8723               6.9044   13.2931    2.8018   37.6186               28.8812    5.9356    0.9318   67.9915             44.2739    6.2521    0.6948   94.7899             57.7518    7.9321    0.3849  113.8340
    0.0994    7.6844    3.7177   12.0064              13.2370    8.3427    0.3355   36.2227               26.8133    8.5799    0.7111   68.4674             40.7673    9.8400    0.0937   95.1478             57.3827    8.6042    0.1381  114.9106
    0.4438    7.8448    1.2865   10.3537              15.3243    6.3285    1.0984   38.8755               28.0614    7.4407    0.0604   68.8160             45.4362    5.3017    1.5854   96.7958             57.9538    9.1059    0.0134  115.2994
    4.5807    4.4866    0.2419   10.3537              14.5570    7.3432    0.1664   40.4155               27.3081    8.5791    1.2366   71.7044             44.3699    6.5952    1.5310   96.9394             60.0944    7.6618    0.7441  117.3991
    0.4705    9.5355    0.0636   10.3537              15.0871    7.0209    0.1178   41.8794               26.3222   10.1177    4.4226   75.3667             40.8864   10.7787    0.9991   96.7958             61.3184    7.4371    0.4096  117.8203
    1.2235    8.8162    0.4599   10.8184              12.3502    9.8239    0.0565   44.2606               32.5245    5.2526    0.1615   72.1786             41.0009   11.4063    0.3095   96.7958
    3.9777    6.1342    0.2129   13.2699              18.9276    3.3572    0.0916   44.5026               34.0731    3.9997    0.6650   73.5490             41.8625   10.6903    0.0428   96.7958
    4.1631    6.1270    0.9411   15.0554              12.8802    9.4986    0.0701   44.9294               28.4067   10.2153    0.3851   74.5494             47.1400    5.6674    0.3433   97.6806
    4.1735    6.1850    0.0879   15.0128              15.9485    6.9594    0.1029   47.0706               31.4085    8.8406    1.1726   76.1118             44.0497    9.3477    0.6198  100.2831
    6.2814    5.5967    0.0463   15.1355              14.9600    7.9834    2.1867   49.9461               37.2575    4.2342    0.9120   76.1206             45.0095    9.3848    2.7115  102.8712
    5.3700    6.5577    0.7095   17.0248              17.3330    5.6364    0.5499   49.2240               35.3546    6.4070    0.4594   77.1210             46.1200    9.1899    1.1118  101.5743
    3.2027    9.8205    1.1574   18.4104              17.0295    6.0415    0.5451   49.5175               35.9350    8.1282    1.3060   79.8719             50.4291    5.4345    1.1743  102.8943
    6.2681    6.7889    1.0273   19.0447              18.4625    5.4638    3.1323   52.2332               37.3194    6.8847    0.4080   80.0372             45.8997   10.7319    0.7392  103.9845
    7.5446    5.8054    0.2075   18.4104              14.6054    9.6192    0.3119   50.5399               37.7947    6.5705    0.0768   79.8719             49.2681    7.7227    0.5676  105.0425
    8.5658    4.8208    1.4786   20.2429              16.8212    9.6545    1.5756   52.3135               34.7590    9.6521    0.0709   79.8719             50.8442    7.5987    2.9660  107.6164
    4.9828    9.1315    1.8830   23.5358              21.5729    6.0472    1.1499   52.8150               34.3680   10.2598    0.0183   79.9174             50.1837    8.9345    0.8753  105.9685
    4.4011    9.7295    0.0778   22.2519              21.0681    6.5771    0.9317   53.3390               37.8060    7.0533    1.2801   82.5269             49.7859    9.3694    0.8753  107.5665
    7.9342    6.9907    0.7896   23.0744              18.3801    9.6900    2.3734   55.7709               35.6398   10.9077    0.7522   83.6505             54.9924    4.1893    0.4454  107.5665
    7.8708    7.2184    2.8290   25.7369              23.0876    5.5021    0.8656   56.7292               38.1129    8.8547    0.1532   84.3778             54.9400    4.7314    0.3163  107.5665
    8.7087    6.9828    0.5924   23.5358              21.2394    7.9193    0.1993   57.1900               35.2046   11.8960    0.1726   84.4846             52.7074    7.0688    0.2315  107.9476
    6.0785    9.8120    0.5664   23.5358              22.0695    8.1237    2.6068   61.7250               39.6508    8.1086    0.4443   85.4560             53.6790    7.1616    2.3806  111.4819
    9.0312    7.2841    0.4648   23.5358              26.1354    4.2063    0.7860   59.9676               35.8867   12.1592    0.9799   87.1960             52.2273    8.7257    2.4461  112.3179
    9.4713    6.8845    0.8824   24.8087              24.8112    7.1885    0.3622   60.0336               41.4333    7.2409    0.1262   87.0663             50.5864   10.6153    0.6054  111.4819
    9.5502    7.7028    0.1354   28.7250              24.4948    7.6081    0.8062   60.5824               38.8898   10.0826    1.7506   88.8575             53.5688    7.8622    0.3607  112.0587

  ```
## Part A (b): 演讲者待定 
PS: The time of waiting line doesn't contain the serving time. That means `Time of waiting line = Sojourn Time + Waiting Time`

First ,we need to make the code in PartA(a) into a function. And we need to
  ```matlab
  function [A, D,Time_matrix] = Method_Textbook(N) 
  ```

  And then, calculate the cummulated sum of the 2nd and 3rd colmum: 
  
```matlab
N = 1000;
S = [];
[A,D,Time_matrix] = Method_Textbook(1);
Result_matrix = [Time_matrix(1:length(D),1),Time_matrix(1:length(D),2),(D-A(1,1:length(D)))',D'];
Result_matrix
Waiting_line_time = sum(Result_matrix(:,2)+Result_matrix(:,3))/length(Result_matrix(:,2))
``` 
We get the average time of Time of waiting line is 
  
  ![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/PartA(b).png)
  <br>
  
  
  
  <br/>
  
  
  
  
## Part B: 李文锐
QQ plot: Testing the distribution of waiting time
  
Run the code in part A for N times and get the waiting time.

 ```matlab
  for i=1:N
    [A,D,Time_matrix] = Method_Textbook(1);
    tw = D-A(1,1:length(D));
    
    %me = mean(S);
    %sd = sqrt(var(S));
    S = [S;tw'];
end
pd = makedist('Exponential');
%pd = makedist('Normal')
qqplot(S,pd);
```

![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/QQplot_method_textbook.png)
  
### The Real Condition in Oasis:
  <center class="half">
    <img src="https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/oasis.jpg" width="500"/><img src="https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/Happy_meal_time.jpg" width="400"/><center>  
    
  Since the Oasis has already close down, we have no choice but to do the investegate on the New canteen there. 

Flow Diagram:  
    
![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/flow_diagram.jpg)

By using the thorem, we can find that the ...... is 
    
## 王一安替补
    
## Relevant Materials:
    
https://minkhollow.ca/books/?page_id=34 

http://www.columbia.edu/~ks20/4404-Sigman/4404-Notes-SSQ.pdf
