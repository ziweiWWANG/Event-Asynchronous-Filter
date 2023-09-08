function output_deblur_1_log = deblur_edge_left(img_idx_now,time_image,exposure,events,image,c_deblur,safety_offset)
    output_deblur_1 = deblur_mid(img_idx_now,time_image,exposure,events,image,c_deblur,safety_offset);
    output_deblur_1_log = log(output_deblur_1+1);
    t1 = time_image(img_idx_now) - exposure/2;
    t2 = time_image(img_idx_now); 
    e_start_idx = find(events(:,1) >= t1,1,'first');
    e_end_idx = find(events(:,1) >= t2,1,'first');

    for i_e = e_start_idx:e_end_idx
        xe = events(i_e,2);           % [1 -> width]
        ye = events(i_e,3);           % [1 -> height]
        if (events(i_e,4) == 1) % polarity -1 or 1
            output_deblur_1_log(ye,xe) = output_deblur_1_log(ye,xe) - c_deblur;
        else
            output_deblur_1_log(ye,xe) = output_deblur_1_log(ye,xe) + c_deblur;
        end
    end
end