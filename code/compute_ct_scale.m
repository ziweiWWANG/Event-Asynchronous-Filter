function ct_scale = compute_ct_scale(width,height,log_deblur_image,events,ct,e_start_idx,e_end_idx,e_pub_idx)
    x = events(:,2); 
    y = events(:,3); 
    p = events(:,4);
    sum_p_1 = zeros(height,width);
    num_e_1 = zeros(height,width);
    sum_p_2 = zeros(height,width);
    num_e_2 = zeros(height,width);
    
    for i = e_start_idx:e_pub_idx
        if p(i) < 1
            sum_p_1(y(i),x(i)) = sum_p_1(y(i),x(i)) - ct;
            num_e_1(y(i),x(i)) = num_e_1(y(i),x(i)) + 1;
        else
            sum_p_1(y(i),x(i)) = sum_p_1(y(i),x(i)) + ct;
            num_e_1(y(i),x(i)) = num_e_1(y(i),x(i)) + 1;
        end
    end 
    
    for i = e_pub_idx:e_end_idx
        if p(i) < 1
            sum_p_2(y(i),x(i)) = sum_p_2(y(i),x(i)) - ct;
            num_e_2(y(i),x(i)) = num_e_2(y(i),x(i)) + 1;
        else
            sum_p_2(y(i),x(i)) = sum_p_2(y(i),x(i)) + ct;
            num_e_2(y(i),x(i)) = num_e_2(y(i),x(i)) + 1;
        end
    end 
    sum_p = sum_p_1 + sum_p_2;
    ct_scale = sum_p ./ (log_deblur_image(:,:,2) - log_deblur_image(:,:,1));
end