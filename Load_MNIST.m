load('mnist_all.mat');

X_TEST = [];
Y_TEST = [];
for i = 0:2
    eval(['X_TEST = [X_TEST;test',num2str(i),'];']);
    eval(['Y_TEST = [Y_TEST;',num2str(i+1),'*ones(size(test',num2str(i),',1),1)];']);
end
X_TEST = cast(X_TEST, 'double')/255.0;


X_TRAIN = [];
Y_TRAIN = [];
for i = 0:2
    eval(['X_TRAIN = [X_TRAIN;train',num2str(i),'];']);
    eval(['Y_TRAIN = [Y_TRAIN;',num2str(i+1),'*ones(size(train',num2str(i),',1),1)];']);
end
X_TRAIN = cast(X_TRAIN, 'double')/255.0;

X_TEST = [X_TEST;X_TRAIN];
Y_TEST = [Y_TEST;Y_TRAIN];

X_TRAIN = X_TRAIN(1:20:end,:);
Y_TRAIN = Y_TRAIN(1:20:end,:);