function PSNR = computePSNR(im1, im2)
% assert(all(size(im1) == size(im2)));
% assert(isfloat(im1));
% assert(isfloat(im2));

num = size(im1,1)*size(im1,2);
MSE = 1/num * sum(sum((im1 - im2).^2));
MAXI2 = 255^2;

PSNR = 10*log10(MAXI2 ./ MSE);
end

