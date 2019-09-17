function imgs = load_images2(paths)

imgs = cell(size(paths));
for i = 1:numel(paths)
    X = imread(paths{i});
    if size(X, 3) == 3 % we extract our features from Y channel
        X = rgb2ycbcr(X);
        X = X(:, :, 1);
    end
%     X = im2single(X); % to reduce memory usage
	 X = im2double(X); % to reduce memory usage 255-1,0-0
     
    imgs{i} = X;
end
