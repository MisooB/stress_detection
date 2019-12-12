 t = 2*pi*linspace(0,1,1024)';
 y = sin(3.14*t) + 0.5*cos(6.09*t) + 0.1*sin(10.11*t+1/6) + 0.1*sin(15.3*t+1/3);

 data1 = abs(y); # Positive values
 [pks idx] = findpeaks(data1);

 plot(t,data1,t(idx),data1(idx),'xm')
 axis tight

 legend("Location","NorthOutside","Orientation","horizontal")