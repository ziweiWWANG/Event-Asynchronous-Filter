function [output_deblur_t1,output_deblur_t2] = deblur_edge_inner(img_idx_now,time_image,exposure,events,image,c_deblur,safety_offset)
    %% inner edge deblur frame 1
    output_deblur_on_1 = deblur_mid(img_idx_now,time_image,exposure,events,image,c_deblur,safety_offset);
    output_deblur_1_log = log(output_deblur_on_1+1);
    t1 = time_image(img_idx_now);
    t2 = time_image(img_idx_now) + exposure/2;
    e_start_idx = find(events(:,1) >= t1,1,'first');
    e_end_idx = find(events(:,1) >= t2,1,'first');

    for i_e = e_start_idx:e_end_idx
        xe = events(i_e,2);           % [1 -> width]
        ye = events(i_e,3);           % [1 -> height]   
        if (events(i_e,4) == 1) % polarity -1 or 1
            output_deblur_1_log(ye,xe) = output_deblur_1_log(ye,xe) + c_deblur;
        else
            output_deblur_1_log(ye,xe) = output_deblur_1_log(ye,xe) - c_deblur;
        end
    end
    output_deblur_t1 = exp(output_deblur_1_log)-1;

    %% inner edge deblur frame 2
    output_deblur_on_2 = deblur_mid(img_idx_now+1,time_image,exposure,events,image,c_deblur,safety_offset);
    output_deblur_2_log = log(output_deblur_on_2+1);
    t1 = time_image(img_idx_now+1) - exposure/2;
    t2 = time_image(img_idx_now+1) ;
    e_start_idx = find(events(:,1) >= t1,1,'first');
    e_end_idx = find(events(:,1) >= t2,1,'first');

    for i_e = e_start_idx:e_end_idx
        xe = events(i_e,2);           % [1 -> width]
        ye = events(i_e,3);           % [1 -> height]
        if (events(i_e,4) == 1) % polarity -1 or 1
            output_deblur_2_log(ye,xe) = output_deblur_2_log(ye,xe) - c_deblur;
        else
            output_deblur_2_log(ye,xe) = output_deblur_2_log(ye,xe) + c_deblur;
        end
    end
    output_deblur_t2 = exp(output_deblur_2_log)-1;
end