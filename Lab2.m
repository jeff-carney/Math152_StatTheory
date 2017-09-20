% Jeff Carney, 2-13-17, Math 166-Data Mining

rng(1);



% creates a 100x3 matrix, top are uniform 1 to 2, bottom are uniform from -1 to 0 
x = [ones(50, 1) rand(50, 2)+[ones(50, 1) zeros(50,1)]];
x = [x; [ones(50, 1) rand(50, 2)-[ones(50, 1) zeros(50,1)]]]; % x~

 
y = [ones(50, 1); zeros(50, 1)]; % known labels

B = inv(x'*x)*(x'*y); % optimal beta vector
figure(1)
set(0,'DefaultFigureVisible','on');
subplot(3,2,1)
scatter(x(1:50,2), x(1:50,3), 'b');
hold on;
scatter(x(51:100,2), x(51:100,3), 'r');
title('randomly generated data');

hold on;


% we have B(1) + B(2)x1 + B(3)x2 = 1/2
m = B(2)/-B(3);
b = (B(1)-0.5)/-B(3);

colorFunc = ((B(1))/-B(3)) + (m*x(:,2));
colorFunc = x*B;

subplot(3,2,2);
scatter(x(:,2), x(:,3), 20, colorFunc); colormap jet;
hold on;

xVals = [-1:0.01:2]';
yVals = m*xVals + b;


plot(xVals, yVals);
ylim([0 1]);
title('Linearly Seperated Data');


% Part 2

load fisheriris.mat;
subplot(3,3,4);
scatter3(meas(:,1), meas(:,2), meas(:,3));
title('Iris data');
x = [ones(150, 1) meas]; 
yIrisSetosa = [ones(50,1); zeros(100,1)];
 
yIrisVersicolor = [zeros(50,1); ones(50, 1); zeros(50,1)];

yIrisVirginica = [zeros(100, 1); ones(50,1)];
 
y = [yIrisSetosa yIrisVersicolor yIrisVirginica];

B = inv(x'*x)*(x'*y);

BSetosa = B(:, 1);
BVersicolor = B(:,2);
BVirginica = B(:, 3);


colorSetosa = x*BSetosa;

colorVersicolor = x*BVersicolor;

colorVirginica = x*BVirginica;

subplot(3,3,5);
hold on;
scatter3(meas(:,1), meas(:,2), meas(:,3), 20, colorSetosa);
title('Setosa Color Function');

subplot(3,3,6);
hold on;
scatter3(meas(:,1), meas(:,2), meas(:,3), 20, colorVersicolor);
title('Versicolor color function');

subplot(3,3,7);
hold on;
scatter3(meas(:,1), meas(:,2), meas(:,3), 20, colorVirginica);
title('Virginica Color Function');
hold on;





% Part 3
[X,Y,TOTAL_X,IMAGE] = Load_Data;

s = size(X);
X = [ones(s(1), 1) X];

imageBeta = inv(X'*X)*(X'*Y);

totalXSize = size(TOTAL_X, 1);



A = ones(totalXSize, 1);

TOTAL_X = [A TOTAL_X];

f = TOTAL_X*imageBeta;
figure(1)
subplot(3,3,8);
hold on;
scatter3(TOTAL_X(:,2), TOTAL_X(:,3), TOTAL_X(:,4), 20, f); colormap jet;
title('Image data w/ color function');


Img = reshape(f, 400, 512);
figure(1)
subplot(3,3,9);
imagesc(Img > 0.5);
title('Image w/ classified pixels')



