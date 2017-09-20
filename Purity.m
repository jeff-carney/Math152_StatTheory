function percentage = Purity(computed_labels,actual_labels,R)

% R is the number of classes

% computed_labels is a vector that contains the class label (1 through R)
% computed via Logistic Regression or SVM

% actual_labels is a vector that contains the true labels (1 through R)
% for each data point in the test set

% returns the percentage of correctly computed labels

N = length(actual_labels);
m = 0;
for k=1:R,
    index = computed_labels==k;
    v = actual_labels(index);
    num = zeros(1,R);
    for l=1:R,
        num(l) = length( find(v==l) );
    end
    
    m = m + max(num);
end
percentage = (m/N)*100;