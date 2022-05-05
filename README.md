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
%% Part a (b)按照2~4列求和（暂定）：需要问杜老师
    % get the mean of every times in every iteration:
    E_times(j) = sum(sum(Result_matrix(:,2:4)))/n;
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
![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/QQ%20plot%20Method1%20.png)
## Part b:

### Method 2:Queueing Theory
#### Algorithm：

#### Code:
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
    %初始化顾客源
    %*****************************************
    %总仿真时间
    Total_time = 2;
    %队列最大长度
    N = 10000000000;
    %到达率与服务率
    lambda = 60;
    mu = 60;
    %平均到达时间与平均服务时间
    arr_mean = 1/lambda;
    ser_mean = 1/mu;
    arr_num = length(pois(Total_time,lambda));
    %arr_num = round(Total_time*lambda*1);
    events = [];
    %产生各顾客达到时间间隔
    events(1,:) = exprnd(arr_mean,1,arr_num); + normrnd(8/60,2/60,arr_num,1);
    %各顾客的到达时刻等于时间间隔的累积和 （到达时间）
    events(1,:) = cumsum(events(1,:));
    %产生各顾客服务时间(停留时间）
    events(2,:) = exprnd(ser_mean,1,arr_num);
    %计算仿真顾客个数，即到达时刻在仿真时间内的顾客数
    len_sim = sum(events(1,:)<= Total_time);
    %*****************************************
    %计算第 1个顾客的信息
    %*****************************************
    %第 1个顾客进入系统后直接接受服务，无需等待
    events(3,1) = 0;
    %其离开时刻等于其到达时刻与服务时间之和
    events(4,1) = events(1,1)+events(2,1);
    %其肯定被系统接纳，此时系统内共有1个顾客，故标志位置1
    events(5,1) = 1;
    %其进入系统后，系统内已有成员序号为 1
    member = [1];
    for i = 2:arr_num
        %如果第 i个顾客的到达时间超过了仿真时间，则跳出循环
        
        if events(1,i)>Total_time
            
            break;
            
        else
            number = sum(events(4,member) > events(1,i));
            %如果系统已满，则系统拒绝第 i个顾客，其标志位置 0
            if number >= N+1
                events(5,i) = 0;
                %如果系统为空，则第 i个顾客直接接受服务
            else
                if number == 0
                    %其等待时间为 0
                    
                    %PROGRAMLANGUAGEPROGRAMLANGUAGE
                    events(3,i) = 0;
                    %其离开时刻等于到达时刻与服务时间之和
                    events(4,i) = events(1,i)+events(2,i);
                    %其标志位置 1
                    events(5,i) = 1;
                    member = [member,i];
                    %如果系统有顾客正在接受服务，且系统等待队列未满，则第i个顾客进入系统
                    
                else len_mem = length(member);
                    %其等待时间等于队列中前一个顾客的离开时刻减去其到达时刻
                    events(3,i)=events(4,member(len_mem))-events(1,i);
                    %其离开时刻等于队列中前一个顾客的离开时刻加上其服务时间
                    events(4,i)=events(4,member(len_mem))+events(2,i);
                    %标识位表示其进入系统后，系统内共有的顾客数
                    events(5,i) = number+1;
                    member = [member,i];
                end
            end
            
        end
    end
    %仿真结束时，进入系统的总顾客数
    len_mem = length(member);
    %*****************************************
    %输出结果
    %*****************************************
    figure;
    subplot(2,1,1);
    %绘制在仿真时间内，进入系统的所有顾客的到达时刻和离
    %开时刻曲线图（stairs：绘制二维阶梯图）
    stairs([0 events(1,member)],0:len_mem);
    hold on;
    stairs([0 events(4,member)],0:len_mem,'.-r');
    legend('Arriving time','Leaving time');
    title("Arriving - Leaving");
    hold off;
    grid on;
    %绘制在仿真时间内，进入系统的所有顾客的停留时间和等
    %待时间曲线图（plot：绘制二维线性图）
    subplot(2,1,2);
    plot(1:len_mem,events(3,member),'r-*',1: len_mem,events(2,member)+events(3,member),'k-');
    legend('Waiting time','Service time');
    title("Waiting - Service");
    grid on;
end
```

#### Result:


Cashier1： ![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/Cashier1.png)

Cashier2： ![image](https://github.com/g20021215/Simulation-Project-2022-5-4/blob/main/Cashier2.png)




## Relevant Materials:

