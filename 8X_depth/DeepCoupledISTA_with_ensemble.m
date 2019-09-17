
clear;
addpath('ksvd');
addpath('ksvd/ksvdbox');
addpath('ksvd/ksvdbox/private_ccode');


addpath('utils')
 

load weights_x_8x.mat;
load weights_y_8x.mat;
load weights_z_8x.mat;

soft=1; % whether apply soft-thresholds after Alphaz

%clear weight_z;
% SR parameters

blocksize = [12,12]; % the size of each image patch.
upscale=8; 
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




PSNR_our=zeros(1,length(Xcell)); PSNR_bicu=zeros(1,length(Xcell));
for img_index = 1: length(Xcell)

	disp('--------------------------------------------------------')
	fprintf('Processing image %d of total %d ... \n', img_index, length(Xcell));
	
	X_test = Xcell{img_index}; % testing image X

	Y_test = Ycell{img_index}; % testing image Y
    
    
 	XL_test = imresize(X_test,1/upscale);
    XL_test = imresize(XL_test,upscale);
    X_rec_im0=rec_obtain(XL_test,Y_test,weight_x,weight_y,weight_z); 
    
   
   Y_test90=imrotate(Y_test,90);
   XL_test90=imrotate( XL_test,90);
   X_rec_im90=rec_obtain(XL_test90,Y_test90,weight_x,weight_y,weight_z);
   X_rec_im90=imrotate(X_rec_im90,270);
    
   Y_test180=imrotate(Y_test,180);
   XL_test180=imrotate( XL_test,180);
   X_rec_im180=rec_obtain(XL_test180,Y_test180,weight_x,weight_y,weight_z);
   X_rec_im180=imrotate(X_rec_im180,180);
    
   Y_test270=imrotate(Y_test,270);
   XL_test270=imrotate( XL_test,270);
   X_rec_im270=rec_obtain(XL_test270,Y_test270,weight_x,weight_y,weight_z);
   X_rec_im270=imrotate(X_rec_im270,90);
   
   X_rec_im=(X_rec_im0+X_rec_im90+X_rec_im180+X_rec_im270)./4; clear  X_rec_im0 X_rec_im90  X_rec_im180 X_rec_im270;   
	%	comput PSNR, RMSE
 
		ImgX = X_rec_im;
		RefX = X_test;
        PSNR_X=csnr(ImgX*255,RefX*255, 0, 0);
		PSNR_our(img_index) =  PSNR_X;		
		
        imwrite(X_rec_im,['sintel_' num2str(img_index+100,'%d') '_PSNR' num2str(PSNR_X,'%.4f') '.png']);
        
        
		ImgX =XL_test;
		RefX = X_test;
		PSNR_bicu(img_index) = csnr(ImgX*255,RefX*255, 0, 0) 

end

disp('done! ****************************************************')
%showdict(weight_all.DH_c,[8,8],16,16,'lines');
