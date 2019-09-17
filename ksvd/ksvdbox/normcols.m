function [D] = normcols(B)

siz = size(B,2);

for i = 1:siz
    B(:,1) = B(:,i)/norm(B(:,i),2);
end
D = B;