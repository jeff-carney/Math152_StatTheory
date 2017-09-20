function [alpha,beta] = SoftSVM(X,labels,lambda)

% data is N x d, where N is the number of data points and d is the
% dimensionality of the data

% labels is N x 1 and gives the class of each data point


%%
% 
% use the inputs X,labels to form the matrices H,A and vectors f,b
% so that min <z,Hz>/2 + <f,z> subject to Az <= b gives the solution 
% to the Soft SVM energy, where z = [alpha;beta;xi]
%
%%
X = [ones(size(X, 1), 1) X];

I0 = eye(size(X, 2));
I0(1, 1) = 0;
H = lambda*[I0 zeros(size(X')); zeros(size(X)) zeros(size(X, 1), size(X, 1))];
f = [0; zeros(size(X, 2) - 1, 1); ones(size(X, 1), 1)];
L = -1*diag(labels);
A = [L*X -1*eye(size(X, 1)); zeros(size(X)) -1*eye(size(X, 1))];
b = [-1*ones(size(X, 1), 1); zeros(size(X, 1), 1)];



opts = optimset('Algorithm','interior-point-convex','Display','off');
[z,~,exflag] = quadprog(H,f,A,b,[],[],[],[],[],opts);
alpha = z(1,1);
beta = z(2:size(X, 2),1);
exflag;