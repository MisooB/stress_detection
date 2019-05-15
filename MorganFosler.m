function y = MorganFosler(x) 
  y = 0;
  N = length(x);
  for i = 1:N-1
    for j = i+1:N
      y += x(i, 1) * x(j, 1);
    end
  end  
  y /= (N*(N-1) / 2);
end