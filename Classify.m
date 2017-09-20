%Load MNIST

Load_MNIST;

% 0's go from 1 to 297, 1's go from 298 to 634, and 2's go from 635 to 932

% saving number of rows that will be used in seperation of 0v1, 1v2, and
% 0v2
size0v1 = 634;
size1v2 = 932 - 297;
size0v2 = 297 + (932 - 634);
% initializing X and Y matrices for 0v1 and then filling by iterating
% through Y_TRAIN
Y_0v1 = zeros(size0v1, 1);
X_0v1 = zeros(size0v1, size(X_TRAIN, 2));
for i = 1:size(Y_TRAIN,1)
   if Y_TRAIN(i) == 1
       Y_0v1(i) = -1;
       X_0v1(i, :) = X_TRAIN(i, :);
   elseif Y_TRAIN(i) == 2
       Y_0v1(i) = 1;
       X_0v1(i, :) = X_TRAIN(i, :);
   end 
end
figure
[alpha0v1,beta0v1] = SoftSVM(X_0v1, Y_0v1, 1);
subplot(3, 3, 1);
imagesc(reshape(beta0v1,28,28)); title('0s vs 1s hyperplane');



% initializing X and Y matrices for 1v2 and then filling by iterating
% through Y_TRAIN
Y_1v2 = zeros(size1v2, 1);
X_1v2 = zeros(size1v2, size(X_TRAIN, 2));

index = 1;
for i = 1:size(Y_TRAIN,1)
    if Y_TRAIN(i) == 2
        Y_1v2(index) = -1;
        X_1v2(index, :) = X_TRAIN(i, :);
        index = index + 1;
    elseif Y_TRAIN(i) == 3
        Y_1v2(index) = 1;
        X_1v2(index, :) = X_TRAIN(i, :);
        index = index + 1;
    end
end

[alpha1v2,beta1v2] = SoftSVM(X_1v2, Y_1v2, 1);
subplot(3, 3, 2);
imagesc(reshape(beta1v2,28,28)); title('1s vs 2s hyperplane');


% initializing X and Y matrices for 0v2 and then filling by iterating
% through Y_TRAIN
Y_0v2 = zeros(size0v2, 1);
X_0v2 = zeros(size0v2, size(X_TRAIN, 2));

index = 1;
for i = 1:size(Y_TRAIN,1)
    if Y_TRAIN(i) == 1
        Y_0v2(index) = -1;
        X_0v2(index, :) = X_TRAIN(i, :);
        index = index + 1;
    elseif Y_TRAIN(i) == 3
        Y_0v2(index) = 1;
        X_0v2(index, :) = X_TRAIN(i, :);
        index = index + 1;
    end
end
[alpha0v2,beta0v2] = SoftSVM(X_0v2, Y_0v2, 1);
subplot(3, 3, 3);
imagesc(reshape(beta0v2,28,28)); title('0s vs 2s hyperplane');

% Training step:
%
% compute R hyperplanes (alpha_r,beta_r) 1<=r<=R
% using either Multiclass Logistic Regression
% or one-versus-all Soft SVM

% setting up the training Y's for each hyperplane
Y0 = [Y_TRAIN == 1] + -1*[Y_TRAIN ~= 1];
Y1 = [Y_TRAIN == 2] + -1*[Y_TRAIN ~= 2];
Y2 = [Y_TRAIN == 3] + -1*[Y_TRAIN ~= 3];
Y = [Y0 Y1 Y2];

% computing the alpha's and beta's for each hyperplane and combining into
% one B matrix
[alpha0,beta0] = SoftSVM(X_TRAIN, Y0, 1);
[alpha1,beta1] = SoftSVM(X_TRAIN, Y1, 1);
[alpha2,beta2] = SoftSVM(X_TRAIN, Y2, 1);
B = [alpha0 alpha1 alpha2; beta0 beta1 beta2];

% store the results in a (d+1)-by-R matrix B,
% the first column of B should be 
%          alpha_1
%          beta_1
% the second column of B should be 
%          alpha_2
%          beta_2
% etc.

% Classification step, using B computed as above:
X = X_TEST;
X_tild = [ones(size(X,1),1) X];
[~,ind] = max(X_tild*B,[],2);
percentage = Purity(ind,Y_TEST,3);

% setting up the test Y's for evaluation of model
Y0Test = [Y_TEST == 1] + 2*[Y_TEST ~= 1];
Y1Test = [Y_TEST == 2] + 2*[Y_TEST ~= 2];
Y2Test = [Y_TEST == 3] + 2*[Y_TEST ~= 3];
YTest = [Y0Test Y1Test Y2Test];

% creating a vector of lambdas to iterate through
lambda = [0.001 .01 0.1 1.0 10, 100];
optLam = zeros(3, 1);
 for j = 1:3
     % initializing accuracy vector that will store the accuracy of model
     % for each lambda
     accuracy = zeros(size(lambda));
     for i = 1:size(lambda, 2)
        % training each model, predicting classes, and then testing purity
        [alpha,beta] = SoftSVM(X_TRAIN, Y(:,j), lambda(i));
        predY = X_tild*[alpha; beta];
        predY = [predY >= 0] + 2*[predY < 0];
        accuracy(i) = Purity(predY, YTest(:,j), 2);
     end
     % adding optimal lambda for each model to a optimal lambda vector
     [~, lIndex] = max(accuracy);
     optLam(j) = lambda(lIndex);
     
     % plotting purity for each hyperplane
     subplot(3, 3, j + 3);
     scatter(log(lambda), accuracy, '*'); xlabel('log(\lambda)'); ylabel('percentage');
     title(strcat(num2str(j - 1), ' vs all purity'));
 end
 
% creating alpha's and beta's for each hyperplane using optimal lambdas
[alpha0C,beta0C] = SoftSVM(X_TRAIN, Y0, optLam(1));
[alpha1C,beta1C] = SoftSVM(X_TRAIN, Y1, optLam(2));
[alpha2C,beta2C] = SoftSVM(X_TRAIN, Y2, optLam(3));
BC = [alpha0C alpha1C alpha2C; beta0C beta1C beta2C];

% computing predicted labels
[C,indC] = max(X_tild*BC,[],2);

% plotting confusion matrix
confMat = confusionmat(Y_TEST, indC);
subplot(3,2,5); imagesc(confMat); title('Confusion Matrix'); colorbar; % for purity

% total of each label to be used in normalization
total0s = sum(Y_TEST == 1)
total1s = sum(Y_TEST == 2)
total2s = sum(Y_TEST == 3)

% initializing misclassification matrix
misClasMat = zeros(3, 3);

% iteratively adding to misclassification matrix
for j = 1:size(Y_TEST)
   if Y_TEST(j) == 1
       if indC(j) == 1
           misClasMat(1,1) = misClasMat(1,1) + 1;
       elseif indC(j) == 2
           misClasMat(1,2) = misClasMat(1,2) + 1;
       else
           misClasMat(1,3) = misClasMat(1,3) + 1;
       end
   elseif Y_TEST(j) == 2
       if indC(j) == 1
           misClasMat(2,1) = misClasMat(2,1) + 1;
       elseif indC(j) == 2
           misClasMat(2,2) = misClasMat(2,2) + 1;
       else
           misClasMat(2,3) = misClasMat(2,3) + 1;
       end
   else
       if indC(j) == 1
           misClasMat(3,1) = misClasMat(3,1) + 1;
       elseif indC(j) == 2
           misClasMat(3,2) = misClasMat(3,2) + 1;
       else
           misClasMat(3,3) = misClasMat(3,3) + 1;
       end
   end
end

% normalizing misclassification matrix
misClasMat(1,:) = misClasMat(1,:)/total0s;
misClasMat(2,:) = misClasMat(2,:)/total1s;
misClasMat(3,:) = misClasMat(3,:)/total2s;

% plotting misclassification matrix
subplot(3,2,6); imagesc(misClasMat); title('Misclasification'); 
xlabel('predicted'); ylabel('actual'); colorbar;

 