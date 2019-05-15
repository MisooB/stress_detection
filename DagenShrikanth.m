function y = DagenShrikanth(x) 
  K = size(x, 2);   # pocet stlpcov
  y = 0;
  for j = 0:K-2
    for p = j+1:K-1
      y += dot ( x(:, j+1), x(:, p+1) );
    end
  end  
  y /= (K*(K-1) / 2);
end