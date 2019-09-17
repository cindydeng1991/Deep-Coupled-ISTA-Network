function [ X_rec_im ] = rec_obtain( XL_test,Y_test,weight_x,weight_y,weight_z )

Wx=weight_z.Wx;
Wy=weight_z.Wy;
Dz=weight_z.DH;
cropwidth = size(XL_test);
blocksize = [16,16];
stepsize = [1,1];
    [XL_test_vec, Y_test_vec,dc_XL]=patch_obtain(XL_test, Y_test);            
    Alphax = multimodal_upscaling( XL_test_vec, weight_x);  
    Alphay = multimodal_upscaling( Y_test_vec, weight_y);   
    Alphaz=Wx*Alphax+Wy*Alphay;   

    theta=repmat((weight_z.lam_r)', size(Alphaz, 2), 1);  
    Alphaz = wthresh(Alphaz,'s',theta');
     
    X_rec=Dz*Alphaz;
    X_rec_mean = X_rec + repmat(dc_XL, size(X_rec,1), 1);
    X_rec_mean=double(X_rec_mean);
	X_rec_im = col2imstep(X_rec_mean, cropwidth, blocksize, stepsize);
     
    cnt = countcover(cropwidth,blocksize,stepsize);
		for i = 1:size(cnt,1)
			for j = 1:size(cnt,2)
				if cnt(i,j) == 0
					cnt(i,j) = 1;
				end
			end
		end
		X_rec_im = X_rec_im./cnt; 		
		X_rec_im(X_rec_im > 1) = 1;
		X_rec_im(X_rec_im < 0) = 0;

end

