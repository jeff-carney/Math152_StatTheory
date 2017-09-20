% Loads the files image.jpg, mask0.jpg, and mask1.jpg in the current
% directory, and returns the image data in the proper format for use
% in the "Logistic" function

%%%%%%%%%%%%%%%%%
% Outputs:
%
% X: an N-by-3 matrix. Each of the "N" rows is a data point that corresponds to 
% a pixel in the image. Each row has 3 entries, which correspond to the RGB values
% of that pixel. Each of the "N" pixels is labeled as either 
% foreground (class 1) or background (class 0).

% Y: an N-by-1 matrix (column vector) that stores the class labels (0 or 1). If Y(i) = 1 then pixel "i" is foreground.
% If Y(i) = 0 then pixel "i" is background.

% TOTAL_X: an M-by-3 matrix containing all data points, both labeled and unlabeled. Here "M" is the total number of pixels in the image.

% IMAGE - The original image data (used to visualize the results)

function [X,Y,TOTAL_X,IMAGE] = Load_Data()
    I = imread('image.jpeg');
    A = imread('mask0.jpeg');
    B = imread('mask1.jpeg');

    W = size(I,2);
    H = size(I,1);
    XI = cast(reshape(I,[W*H,3]),'double')/255.0;
    XA = cast(reshape(A,[W*H,3]),'double')/255.0;
    XA = mean(XA,2) > 0.5;
    XB = cast(reshape(B,[W*H,3]),'double')/255.0;
    XB = mean(XB,2) > 0.5;

    IMAGE = I;
    IXTR = XA > 0.5 | XB > 0.5;
    
    masked_image = zeros(size(XI));
    masked_image(IXTR,:) = XI(IXTR,:);
    
    foreground = masked_image;
    background = masked_image;
    
    for i=1:3
        foreground(:,i) = XI(:,i).*(XA);
        background(:,i) = XI(:,i).*(XB);
    end;
    
    foreground = reshape(foreground,[H W 3]);
    background = reshape(background,[H W 3]);
    
    
    figure('Name','Foreground Labels'); imagesc(foreground); 
    figure('Name','Background Labels'); imagesc(background);
    figure('Name','Original Image'); imagesc(IMAGE); 
    
    X = XI(IXTR,:);
    Y = XA(IXTR);
    
    TOTAL_X = XI;
 
end