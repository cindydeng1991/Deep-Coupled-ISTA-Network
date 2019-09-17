function [XL_test_vec, Y_test_vec,dc_XL]=patch_obtain(XL_test, Y_test)
cropwidth = size(XL_test);
    window = [16 16]; scale=1; overlap = [15 15]; border=[0 0];
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


end

