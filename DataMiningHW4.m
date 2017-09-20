bear = imread('Bear.jpeg');
bear = double(bear);
figure;
subplot(3,2,1);
imagesc(bear); colormap(gray); title('Original Image');
[U,S,V] = svd(bear);

origRank = rank(bear); % = 499



bear10 = zeros(size(bear));
for i=1:10
    bear10 = bear10 + (S(i,i)*U(:,i)*V(:,i)');
end
subplot(3,2,2);
imagesc(bear10); colormap(gray); title('Rank 10 Approximation');

bear50 = zeros(size(bear));
for i=1:50
    bear50 = bear50 + (S(i,i)*U(:,i)*V(:,i)');
end
subplot(3,2,3);
imagesc(bear50); colormap(gray); title('Rank 50 Approximation');

bear200 = zeros(size(bear));
for i=1:200
    bear200 = bear200 + (S(i,i)*U(:,i)*V(:,i)');
end
subplot(3,2,4);
imagesc(bear200); colormap(gray); title('Rank 200 Approximation');


for i=1:4
    x = U(:,i)*V(:,i)';
    subplot(6,4, 16 + i);
    imagesc(x); colormap(gray);
end

for i=1:4
    x = U(:,500 - (i-1))*V(:,500 - (i-1))';
    subplot(6,4, 20 + i);
    imagesc(x); colormap(gray);
end
