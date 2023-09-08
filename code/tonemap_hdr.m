function [td_img_tone] = tonemap_hdr(td_img)
    % update parameters if necessary
    tmp = sort(td_img(:));
    td_img_min = tmp(floor(numel(tmp)*0.02));
    if td_img_min < 0
        td_img = td_img + (-td_img_min);
    end

    small_num = 1e-6;
    td_img = max(td_img,small_num);
    td_img = td_img * 255; 
    RGBlog2 = log2(td_img);
    tmp = sort(RGBlog2(:));
    RGBlog2_max = tmp(ceil(numel(tmp)*0.999));
    RGBlog2_min = tmp(floor(numel(tmp)*0.005));
    RGBlog2 = min(max(RGBlog2,RGBlog2_min), RGBlog2_max);
    RGBlog2 = max(min(RGBlog2,RGBlog2_max), RGBlog2_min);

    RGBlog2Scaled = mat2gray(RGBlog2); % Normalize to [0,1]
    numtiles = [4 4];
    LRemap = [0,1];
    RGBldr = adapthisteq(RGBlog2Scaled, 'NumTiles', numtiles);
    td_img_tone = (imadjust(RGBldr, LRemap, [0 1]));
end

