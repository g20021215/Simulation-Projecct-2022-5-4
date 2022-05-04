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

    
