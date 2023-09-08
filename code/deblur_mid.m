function [output_deblur_now] = deblur_mid(frame,time_image,exposure,events,image,c_deblur,safety_offset)
    % Initialize
    % no ct_scale in deblur
    height = size(image,1);
    width = size(image,2);
    x = events(:,2); 
    y = events(:,3); 
    p = events(:,4);
    delta_t = zeros(height,width);
    % frame 1
    if numel(exposure) == 1
        t1 = time_image(frame) - exposure/2;
        t2 = time_image(frame);
        t3 = time_image(frame) + exposure/2;
    else
        t1 = time_image(frame) - exposure(frame)/2;
        t2 = time_image(frame);
        t3 = time_image(frame) + exposure(frame)/2;
    end
    e_start_idx = find(events(:,1) >= t1,1,'first');
    e_mid_idx = find(events(:,1) >= t2,1,'first');
    e_end_idx = find(events(:,1) >= t3,1,'first');
    Et = zeros(height,width);
    sum_t_Et = zeros(height,width);
    et_array = zeros(height,width) + t2;
    T_deblur = events(e_end_idx,1) - events(e_start_idx,1);

    
    for i = e_mid_idx:-1:e_start_idx
        if p(i) ~= 1
            Et(y(i),x(i)) = Et(y(i),x(i)) + c_deblur;
        else
            Et(y(i),x(i)) = Et(y(i),x(i)) - c_deblur;
        end
        delta_t(y(i),x(i)) = abs(events(i,1) - et_array(y(i),x(i)));
        sum_t_Et(y(i),x(i)) = sum_t_Et(y(i),x(i)) + delta_t(y(i),x(i)) .* exp(Et(y(i),x(i)));
        et_array(y(i),x(i)) = events(i,1);
    end
    sum_t_Et = sum_t_Et + abs(et_array - t1) .* exp(Et);
    Et = zeros(height,width);
    et_array = zeros(height,width) + t2;
    
    
    for i = e_mid_idx:e_end_idx
        if p(i) ~= 1
            Et(y(i),x(i)) = Et(y(i),x(i)) - c_deblur;
        else
            Et(y(i),x(i)) = Et(y(i),x(i)) + c_deblur;
        end
        delta_t(y(i),x(i)) = abs(et_array(y(i),x(i)) - events(i,1));
        sum_t_Et(y(i),x(i)) = sum_t_Et(y(i),x(i)) + delta_t(y(i),x(i)) .* exp(Et(y(i),x(i)));
        et_array(y(i),x(i)) = events(i,1);
    end
    sum_t_Et = sum_t_Et + abs(t3 - et_array) .* exp(Et);
    motion = sum_t_Et / T_deblur;
    deblur_image = double(image(:,:,frame))/255 + safety_offset;
    output_deblur(:,:,frame) = (deblur_image ./ motion - safety_offset);
    output_deblur_now = output_deblur(:,:,frame); 
end