% Example:
% run akf or cf, dataset = carpark2_akf
% eval_data = 'carpark2_akf'; anal_hdr_results(eval_data);
function anal_hdr_results(eval_data)
    addpath('./hdrvdp-3.0.6');
    datasetName = ['../../reconstruction/' eval_data];
    img_total = dir([datasetName '/gt_*.mat']);  
    
    vdp = [];
    SSIM = [];
    PSNR = [];
    MSE = []; MSE_range01 = [];
    ppd = hdrvdp_pix_per_deg( 21, [640 480], 1);

    for i = 3:size(img_total,1)
        KF_mat_add = sprintf([datasetName '/raw_' num2str(i) '.mat']);
        load(KF_mat_add);
        HDR_mat_add = sprintf([datasetName '/gt_' num2str(i) '.mat']);  
        load(HDR_mat_add);
        hdr = sum(tmpHDR,3)/3;

        %% do not evaluate on HDR reference with pure black pixels - not registrated pixels
        if numel(find(hdr == 0)) > 1
            mask = find(hdr == 0);
            td_img(mask) = 0;
        end

        %% Evaluation
        td_img = single(td_img);
        SSIM = [SSIM computeSSIM(td_img*255, hdr)];
        MSE_range01 = [MSE_range01 computeMSE_range01(td_img*255, hdr)];
        PSNR = [PSNR computePSNR(td_img*255, hdr)];
        vdp1 = hdrvdp3('side-by-side', td_img*255, hdr, 'luminance', ppd);
        vdp = [vdp vdp1.Q];
    end

    %%
    save([datasetName '/results_all.mat'],'SSIM','MSE_range01','PSNR','vdp')

    %% avg
    fileID_results = fopen([datasetName '/results.txt'],'w');
    outputIdxTs = sprintf(['SSIM ' num2str(mean(SSIM)) '\n']);
    fprintf(fileID_results,outputIdxTs);
    % outputIdxTs = sprintf(['MSE ' num2str(mean(MSE)) '\n']);
    outputIdxTs = sprintf(['MSE_range01 ' num2str(mean(MSE_range01)) '\n']);
    fprintf(fileID_results,outputIdxTs);
    outputIdxTs = sprintf(['PSNR ' num2str(mean(PSNR)) '\n']);
    fprintf(fileID_results,outputIdxTs);
    outputIdxTs = sprintf(['vdp ' num2str(mean(vdp)) '\n']);
    fprintf(fileID_results,outputIdxTs);
end
