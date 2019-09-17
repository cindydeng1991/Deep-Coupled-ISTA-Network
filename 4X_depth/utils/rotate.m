function y=rotate(low,angle)
for i=1:numel(low)    
    y{i} = imrotate(low{i}, angle);
end

end

