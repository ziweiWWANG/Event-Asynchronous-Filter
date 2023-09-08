function SSIM = computeSSIM(im1, im2)
assert(all(size(im1) == size(im2)));
assert(isfloat(im1));
assert(isfloat(im2));

% Settings
k1 = 0.01;
k2 = 0.03;
L = 255;
c1 = (k1*L)^2;
c2 = (k2*L)^2;


% Calculation
mu1 = mean(im1);
mu2 = mean(im2);
sig = cov(im1, im2);
sig11 = sig(1,1);
sig12 = sig(1,2);
sig22 = sig(2,2);

SSIM = (2.*mu1.*mu2 + c1) .* (2.*sig12 + c2) / ...
        ( (mu1.^2 + mu2.^2 + c1) .* (sig11 + sig22 + c2));
end

