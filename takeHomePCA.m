load('mnist_all.mat');
rng(1);


X = [train0; train1; train2; train3; train4; train5; train6; train7; train8; train9];
X = X(1:2000,:);
X = im2double(X);

nearest10 = similarity(X);

scoreVec = zeros(1,5);
kVec = [1 10 50 100 500];
for k = 1:5


    A = randn(kVec(k), 784);

    P = X*A';

    nearest10P = similarity(P);

    score = 0;
    for i = 1:2000
        intersection = intersect(nearest10(i,:), nearest10P(i,:));
        numCommon = size(intersection, 2);
        score = score + numCommon;
    end
    scoreVec(k) = score;
end

plot(kVec, scoreVec);
xlabel('k');
ylabel('score');
title('random');

pcaX = X;

for i = 1:784
    mu = (1/2000)*sum(X(:,i));
    pcaX(:,i) = X(:,i) - mu;
    
    
    sig = (1/2000)*(pcaX(:,i)'*pcaX(:,i));
    if sig ~= 0
        pcaX(:,i) = X(:,i)./sig;
    end
    
end


[U,S,V] = svd(pcaX'*pcaX);

scorePCAVec = zeros(1,5);

for k = 1:5
    Uk = U(:,1:kVec(k));
    
    pc = X*Uk;
    
    nearest10PCA = similarity(pc);

    score = 0;
    for i = 1:2000
        intersection = intersect(nearest10(i,:), nearest10PCA(i,:));
        numCommon = size(intersection, 2);
        score = score + numCommon;
    end
    scorePCAVec(k) = score;
end
figure
plot(kVec, scorePCAVec);
xlabel('k');
ylabel('score');
title('PCA');
