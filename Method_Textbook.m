function [A, D,Time_matrix] = Method_Textbook(N)
%Notes
%i_matrix = [];
%E_times = [];
%S = [];
% E is the expected waiting time for running N times.
%S is the simulated waiting time before going to the cashier.
for k=1:N
%% Part a (a)
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
    Time_matrix;
    
    
    
    
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
end
end