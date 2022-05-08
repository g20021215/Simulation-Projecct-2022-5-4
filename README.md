# Simulation Project: 
# Question 2: Simulation on A Queuing System with Two Parallel
Group memebers:
陈俊霖（2030005004）  陈郅涵（2030005013） 李文锐（2030005036） 施金泽（2030005049） 
王一安（2030005058）叶中宇（2030005069）  邹宜轩（2030005079）

Date:2022/5/4

<br>


<br />

# Content:
  ## Introduction 陈俊霖
  ## Method 1: Textbook Method:
  ### Part a (Method 1)
  #### Algorithm 施金泽
  #### Code 邹宜轩
  

  ## Method 2: Queueing theorem
  ### Part a
  #### Algorithm 陈郅涵
  #### Code 叶中宇
 

  #### Flow diagram 王一安
  #### Simulation Conclusion 李文锐
  #### Testing for the distribution
  ## Relevant material

<br> 










<br />

## Algorithm in the textbook P118:

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
  
  To Update
## Introduction：
  In this preseation, we will give two different method to solve this problem. One is the ordinary method and the other is queuing theorem. Each method will give the detailed process of solving this problem.
  
![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/IMG_20200914_182716.jpg)

## Method 1: Ordinary Method
### Part a (Method 1)
In this method, we will use the <b> Queueing System with Two Parallel Servers </b> to solve this problem.

First, we need to generate the arrive time `ta` from poisson process with rate 120 per hour and generate sojourn time `tc`~<b>N(8,2)</b> (minutes). 

Then, we put the arrive time `ta` and sojurn time `tc` as the first and second column of the matrix, and the third column is `ta + tc` in matrix `Time_matrix`.

Now, we will find the simulated process. We firstly set the `flag = [1 1];` that means there are two 'serves' (Cashiers) are available. Then, we can set the paying time which are randomly generated from <b> Exp(1) </b>. Then, start the loop and getting the paying time during this process. If the total time before the step paying is greater than the previous minimum time they paying time, the waiting time should be zero. And in other case, the waiting time arrises. The waiting time should be the subtraction time point of the previous customer finish paying and this customer is ready to start the paying activity. During this process, we need to minus the waiting time from the maximum serve time of the other cashier. Then we iteration and get the result.
#### Algorithm

#### Code:
`my_code2.m`
```matlab
function [Result_matrix,m,E,S] = my_code2(N)
% m is the average number of people in each iterations.
% Result_matrix is the simulated result in every iteration.
i_matrix = zeros(1,N);
E_times = zeros(1,N);
S = [];
for j=1:N
%% Part a (a)
    lam1=120;
    mu=8/60;
    std=2/60;
    lam2 = 1/60;
    I=1;
    ta=[-1/lam1*log(rand(1))];%%the time of customers' arrival time:
    
    while ta<2
        ta=[ta,ta(I)-1/lam1*log(rand(1))];
        I=I+1;
    end
    ta(length(ta))=[];%%delete the element which greater than 2;
    ta;%%print the time of customers' arrival time;
    
    
    
    n=length(ta);%%%%%%%Here I change n to length(ta),previous is length(ta)-1
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
    Time_matrix;
    
    
    flag = [1 1];
    td = zeros(1,n);%paying time of each individuals
    tw = zeros(1,n);%
    % C_W = zeros(1,n);%%%%%%*(************%%%%%%%%%%%%
    i = 3;
    td(1) = exprnd(lam2);
    td(2) = exprnd(lam2);
    tw(1) = 0;
    tw(2) = 0;
    % C_W(1) = randi(2);
    % C_W(2) = 3-C_W(1);
    M = [td(1)+Time_matrix(1,3), td(2)+Time_matrix(2,3)];
    while sum(flag) > 0
        mtd_T = min(M);% minimum paying time between the two cashiers
        Mtd_T = max(M);
        %     a = td(i-1) + Time_matrix(i-1,3);
        %     b = td(i-2) + Time_matrix(i-2,3);
        %     if mtd_T == td(i-1)+Time_matrix(i-1,3)%Find the first spare window
        %         W = C_W(2);%W is stand for the number of casher
        %         label = i-1;
        %         flag = [0 1];
        %     else
        %         W = C_W(1);
        %         label = i-2;
        %         flag = [1 0];
        %     end
        
        ex = exprnd(lam2);
        mtw = min(tw(i-1),tw(i-2));% minimum waiting time between the two cashiers
        if Time_matrix(i,3) >= mtd_T
            td(i) = ex;
            tw(i) = 0;
            %         C_W(i) = W;
        elseif Time_matrix(i,3) < mtd_T
            td(i) = ex;
            tw(i) = mtd_T - Time_matrix(i,3);
            Mtd_T = Mtd_T - tw(i);
            %         C_W(i) = W;
        end
        M = [Mtd_T,td(i)+Time_matrix(i,3)-tw(i)];
        
        i = i + 1;
        if i > n
            flag = [0 0];
            break;
        end
        
    end
    
    Result_matrix = zeros(n,4);
    for i=1:n
        if Time_matrix(i,1)+ Time_matrix(i,2)+ td(i)+ tw(i) < 2
            Result_matrix(i,1) = Time_matrix(i,1);
            Result_matrix(i,2) = Time_matrix(i,2);
            Result_matrix(i,3) = td(i);
            Result_matrix(i,4) = tw(i);
            %         Result_matrix(i,5) = C_W(i);
        end
    end
    Result_matrix(all(~Result_matrix,2),:) = [];
    Result_matrix;
%% Part a (b)
    % get the mean of every times in every iteration:
    E_times(j) = sum(sum(Result_matrix(:,2:3)))/n;
    i_matrix(j) = n;
%% Part b
     Set = Result_matrix(:,4);
     Set(all(~Set,2),:) = [];% Delete all the zero items here
     S = [S;Set];
     Set = [];

end
m = mean(i_matrix);
E = mean(E_times);
end
```



main.m
```matlab
[Result_matrix,m,E,S] = my_code2(10000);
me = mean(S);
sd = sqrt(var(S));

pd = makedist('Exponential');
%pd = makedist('Normal')
qqplot(S,pd);
```

### Part b (Method 1)
#### Flow diagram
#### Testing for the distribution
![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/QQ%20plot%20Method1%20.png)

## Method 2: Queueing theorem
### Part a & b (Method 2)

#### Algorithm
# 陈郅涵还没发我
#### Code
pois.m
```matlab
function [S,I] = pois(T,lambda)
S =[]; I = 0;flag = 1; t = 0;
while flag
    u = rand(1);
    t = t -(1/lambda)*log(u);
    if(t > T)
        flag = 0;
        break
    end
    I = I +1;
    S = [S,I];
end
```
t.m
```matlab
clc
clear
for i = 1:2
    %*****************************************
    %Initialize customer source
    %*****************************************
    %total simulating time
    Total_time = 2;
    %maximum length of queuing
    N = 10000000000;
    %rate of arrival and service
    lambda = 60;
    mu = 60;
    %average arrive time poing and the average serve time
    arr_mean = 1/lambda;
    ser_mean = 1/mu;
    arr_num = length(pois(Total_time,lambda));
    %arr_num = round(Total_time*lambda*1);
    events = [];
    %generate the time interval between any two adjecent customers
    events(1,:) = exprnd(arr_mean,1,arr_num); + normrnd(8/60,2/60,arr_num,1);
    %the accumulated sum of all the previous time interval is equal to the time point when the customer arrive
    events(1,:) = cumsum(events(1,:));
    %Generate serve time for all the customers. 
    events(2,:) = exprnd(ser_mean,1,arr_num);
    %calculate the total number of all the customer. This is same as the number of cumstomers arrive in the simulated interval
    len_sim = sum(events(1,:)<= Total_time);
    %*****************************************
    %record the information of the first customer 
    %*****************************************
    %no waiting time for the first customer.
    events(3,1) = 0;
    %its leaving time is equal to the sum of the arrival time and the serve time.
    events(4,1) = events(1,1)+events(2,1);
    %The first customer was taken in, and the total number of people in the system is 1.
    events(5,1) = 1;
    %we number this customer to be 1.
    member = [1];
    for i = 2:arr_num
        %If i^th customer arrive time is geq than the sumulated time, then break.
        
        if events(1,i)>Total_time
            
            break;
            
        else
            number = sum(events(4,member) > events(1,i));
            %If the cashier system is full, then reject ith customer, and mark it to be zero.
            if number >= N+1
                events(5,i) = 0;
                %If the system is empty, then the ith customer will directly be served.
            else
                if number == 0
                    %The waiting time is zero.
                    
                    %PROGRAMLANGUAGEPROGRAMLANGUAGE
                    events(3,i) = 0;
                    %Time point of departure is equal to the sum of arrival time point and the serve time.
                    events(4,i) = events(1,i)+events(2,i);
                    %Mark the number to be 0.
                    events(5,i) = 1;
                    member = [member,i];
                    %If there are customers are being served, and the system doesn't filled, then the ith customer will enter the system.
                    
                else len_mem = length(member);
                    %The waiting time is equal to the last customer leaving time point minus its arrival time point.
                    events(3,i)=events(4,member(len_mem))-events(1,i);
                    %The leaving time point is equal to the last customer leaving time minus its serve time.
                    events(4,i)=events(4,member(len_mem))+events(2,i);
                    %when the mark number enter the system, the total number in this system. 
                    events(5,i) = number+1;
                    member = [member,i];
                end
            end
            
        end
    end
    %When the simulation process end, the total number of have already entered the system
    len_mem = length(member);
    %*****************************************
    %Output the result.
    %*****************************************
    figure;
    subplot(2,1,1);
    % Draw the line chart of the time point when customer entering and leaving during the simulation period. 
    % (stairs：Draw the two dimension ladder diagram）
    stairs([0 events(1,member)],0:len_mem);
    hold on;
    stairs([0 events(4,member)],0:len_mem,'.-r');
    legend('Arriving time','Leaving time');
    title("Arriving - Leaving");
    hold off;
    grid on;
    %Draw the plot of the time sojurn time and waiting time during the simulation period.
    %（plot：two dimension linear plot）
    subplot(2,1,2);
    plot(1:len_mem,events(3,member),'r-*',1: len_mem,events(2,member)+events(3,member),'k-');
    legend('Waiting time','Service time');
    title("Waiting - Service");
    grid on;
end
```

#### Simulation result:


Cashier1： ![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/Cashier1.png)

Cashier2： ![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/Cashier2.png)
#### Flow diagram
#### Testing for the distribution
![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/mmexport1651816198693.jpg)


## Relevant Materials:

