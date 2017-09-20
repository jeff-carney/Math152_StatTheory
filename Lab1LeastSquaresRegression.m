% Jeff Carney, 2-7-2017, Math 166-Data Mining

days = [200:-1:1]';
closing = Close;

subplot(2,3,1)
plot(days, closing, 'ko'); % plots each data point as a black "o"
title('Google Stock Prices');
xlabel('day');
ylabel('closing price');

A=[ones(size(closing)) days]; 
b=closing;
Xsolution=inv(A'*A)*A'*b;

XVals =[0:.01:200];
YVals = Xsolution(1)+ (Xsolution(2)*XVals);
subplot(2,3,2)
plot(XVals,YVals)
title('Linear Regression Line')

A = [A days.^2 days.^3];
XCubeSol = inv(A'*A)*A'*b;
YValsCubic = XCubeSol(1)+ (XCubeSol(2)*XVals) + (XCubeSol(3)*(XVals.^2)) + (XCubeSol(4)*(XVals.^3));
subplot(2,3,3)
plot(XVals,YValsCubic,'b')
title('Cubic Regression Line')

subplot(2,1,2)
%plot data and both regression curves on the same subplot.
hold on;

plot(days, closing, 'ko');
plot(XVals,YVals,'r')
plot(XVals,YValsCubic,'b');
hold off;
title('Least Squares Regression')
legend('data','linear fit','cubic fit')


savefig('LeastSquaresRegression.fig')
print('LeastSquaresRegression', '-dpng')