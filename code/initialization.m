function [ts_array_,ts_array_2,frame_idx,R_inv_array,C,weight]...
    = initialization(height, width)
    ts_array_ = zeros(height, width);
    ts_array_2 = zeros(height, width);
    R_inv_array = ones(height,width);
    C = zeros(height,width);
    frame_idx = 0;
    weight = 0;
end