% Displays a separation of the image into foreground and background classes.

% INPUTS:
%
% TOTAL_Y: an M-by-1 matrix with a class label for all pixels in the image
% (equivalently, a label for all rows of TOTAL_X).

% IMAGE the original image from the Load_Data function

function View_Result(TOTAL_Y, IMAGE)
    TOTAL_Y = reshape(TOTAL_Y,[size(IMAGE,1),size(IMAGE,2)]);
    VC = cat(3,TOTAL_Y,TOTAL_Y,TOTAL_Y);

    figure('Name','Classification Result');
    
    subplot(121);
    C0 = IMAGE;
    C0(VC > 0.5) = 0;
    imshow(C0);
    title('Class 0');
    set(gcf,'Color','w');

    subplot(122);
    C1 = IMAGE;
    C1(VC < 0.5) = 0;
    imshow(C1);
    title('Class 1');
    set(gcf,'Color','w');
end