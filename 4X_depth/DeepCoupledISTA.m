
clear;
addpath('ksvd');
addpath('ksvd/ksvdbox');
addpath('ksvd/ksvdbox/private_ccode');


addpath('utils')
 

load weights_x_final_4x.mat;
load weights_y_final_4x.mat;
load weights_z_final_4x.mat;

soft=1; % whether apply soft-thresholds after Alphaz
Wx=weight_z.Wx;
Wy=weight_z.Wy;
Dz=weight_z.DH;
%clear weight_z;
% SR parameters

blocksize = [8,8]; % the size of each image patch.
upscale=4; 
directory = 'TestImages_RGBD/Sintel'; 
patternX = '*.bmp';
patternY = '*.png';


XpathCell = glob(directory, patternX );
Xcell = load_images( XpathCell );


YpathCell = glob(directory, patternY );
Ycell = load_images(YpathCell );

if length(Xcell) ~= length(Ycell)	
	error('Error: The number of X images is not equal to the number of Y images!');
end


window = [8 8]; scale=1; overlap = [7 7]; border=[0 0];

PSNR_our=zeros(1,length(Xcell)); PSNR_bicu=zeros(1,length(Xcell));
for img_index = 1: length(Xcell)

	disp('--------------------------------------------------------')
	fprintf('Processing image %d of total %d ... \n', img_index, length(Xcell));
	
	X_test = Xcell{img_index}; % testing image X
   % XL_test = XLcell{img_index};
	Y_test = Ycell{img_index}; % testing image Y
 	XL_test = imresize(X_test,1/upscale);
      XL_test = imresize(XL_test,upscale);
   
   
    
    cropwidth = size(X_test);
    stepsize = [1,1];
    croploc = [1,1];
	% crop the area of interest
	Y_test = Y_test(croploc(1):croploc(1)+cropwidth(1)-1,croploc(2):croploc(2)+cropwidth(2)-1);
	XL_test = XL_test(croploc(1):croploc(1)+cropwidth(1)-1,croploc(2):croploc(2)+cropwidth(2)-1);
    
     
      grid = sampling_grid(size(XL_test), ...
      window, overlap, border, scale);
      f1 = XL_test(grid);
      XL_test_vec = reshape(f1, [size(f1, 1) * size(f1, 2) size(f1, 3)]);
      f2 = Y_test(grid);
      Y_test_vec = reshape(f2, [size(f2, 1) * size(f2, 2) size(f2, 3)]);
   
	% remove the mean (the dc component from each patch)
	dc_Y = mean(Y_test_vec);
    dc_XL = mean(XL_test_vec);
	
	Y_test_vec = Y_test_vec - repmat(dc_Y, size(Y_test_vec, 1), 1);
    XL_test_vec = XL_test_vec - repmat(dc_XL, size(XL_test_vec, 1), 1);
          
    Alphax = multimodal_upscaling( XL_test_vec, weight_x);
   
    Alphay = multimodal_upscaling( Y_test_vec, weight_y);
    
    Alphaz=Wx*Alphax+Wy*Alphay; 
    
    if (soft)
    theta=repmat((weight_z.lam_r)', size(Alphaz, 2), 1);  
    Alphaz = wthresh(Alphaz,'s',theta');
    end
    
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
      
		% comput PSNR, RMSE
		ImgX = X_rec_im;
		RefX = X_test;
        PSNR_X=csnr(ImgX*255,RefX*255, 0, 0);
		PSNR_our(img_index) =  PSNR_X		
		
        imwrite(X_rec_im,['sintel_' num2str(img_index+100,'%d') '_PSNR' num2str(PSNR_X,'%.4f') '.png']);
        
        
		ImgX =XL_test;
		RefX = X_test;
		PSNR_bicu(img_index) = csnr(ImgX*255,RefX*255, 0, 0) ;

end

disp('done! ****************************************************')
%showdict(weight_all.DH_c,[8,8],16,16,'lines');
