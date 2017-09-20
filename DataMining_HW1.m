rng(1);

% (a)
v = randn(1, 3);
u = v/norm(v);

V = randn(50, 3);
U = ones(50,3);
for i = 1:50
    U(i,:) = (V(i,:))/norm(V(i,:));
end
subplot(2,2,1);
scatter3(V(:,1),V(:,2),V(:,3),20,u*V');  

title('50 random vectors');
hold on;
scatter3(u(1),u(2),u(3),'k*');

subplot(2,2,2);
scatter3(U(:,1),U(:,2),U(:,3),20,u*U');

title('50 random vectors');
hold on;
scatter3(U(1), U(2), U(3), 'k*');

% (b)

uSize = size(U);
uLength = uSize(1);
sum1 = 0;
for i = 1:uLength
    sum1 = sum1 + (u*U(i,:)');
end
avgInProd = sum1/uLength

% (c)
V300 = randn(300, 3);
U300 = ones(300, 3);
for i = 1:300
    U300(i,:) = V300(i,:)/norm(V300(i,:));
end
sum300 = 0;
for i = 1:300
    sum300 = sum300 + (u*U300(i,:)');
end
avgInProd300 = sum300/300

% try n = norm(V'(:,1:end)) U = V'*diag(n)

% (d)
innerProd = ones(300*300, 1);

sum9 = 0; 
for i = 1:300
    for j = 1:300
        innerProd((300*(i-1))+j) = U300(i,:)*U300(j,:)';
        sum9 = sum9 + innerProd((300*(i-1))+j);
    end
end

average9 = sum9/90000

b = sort(innerProd);
subplot(2,2,3:4);
hold on;
xlabel('Index');
ylabel('Inner Product')
plot(b);