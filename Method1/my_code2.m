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
