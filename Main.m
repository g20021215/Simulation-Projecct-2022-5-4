N = 1000;
S = [];
[A,D,Time_matrix] = Method_Textbook(1);
Result_matrix = [Time_matrix(1:length(D),1),Time_matrix(1:length(D),2),(D-A(1,1:length(D)))',D'];
Result_matrix
Waiting_line_time = sum(Result_matrix(:,2)+Result_matrix(:,3))/length(Result_matrix(:,2))
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

%Result_matrix,m,E,S