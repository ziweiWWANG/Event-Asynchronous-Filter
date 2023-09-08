function MSE_range01 = computeMSE_range01(im1, im2)
assert(all(size(im1) == size(im2)));
assert(isfloat(im1));
assert(isfloat(im2));

im1 = im1/255;
im2 = im2/255;

num = size(im1,1) * size(im1,2);

% logim1 = log(im1);
% logim2 = log(im2);
% zeroPix = (im1==0) | (im2==0);
% logim1(zeroPix) = 0;
% logim2(zeroPix) = 0;

MSE_range01 = 1/num .* sum(sum((im1-im2).^2));

end

