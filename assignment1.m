%% Task 1: Point Operations and Intensity Enhancement
img_raw = imread('lowlight2.jpg'); 
if size(img_raw, 3) == 3
    img_gray = rgb2gray(img_raw);
else
    img_gray = img_raw;
end

% Gamma Correction and Histogram Equalization 
gamma_img = imadjust(img_gray, [], [], 0.5); 
histeq_img = histeq(img_gray);

% Making CLAHE Procces
clahe_img = adapthisteq(img_gray, 'NumTiles', [8 8], 'ClipLimit', 0.01);

figure('Name', 'Task 1: Point Operations');
subplot(2,4,1); imshow(img_gray); title('Original');
subplot(2,4,5); imhist(img_gray); title('Original Hist');
subplot(2,4,2); imshow(gamma_img); title('Gamma (0.5)');
subplot(2,4,6); imhist(gamma_img); title('Gamma Hist');
subplot(2,4,3); imshow(histeq_img); title('HistEq');
subplot(2,4,7); imhist(histeq_img); title('HistEq Hist');
subplot(2,4,4); imshow(clahe_img); title('CLAHE');
subplot(2,4,8); imhist(clahe_img); title('CLAHE Hist');

%% Task 2: Spatial Filtering
img_clean = imread('highedge1.jpg');
img_clean = im2gray(img_clean);

% Adding synthetic noise
img_noisy = imnoise(img_clean, 'salt & pepper', 0.02);

% Mean Filter
h_mean3 = fspecial('average', [3 3]);
h_mean7 = fspecial('average', [7 7]);
mean3_img = imfilter(img_noisy, h_mean3);
mean7_img = imfilter(img_noisy, h_mean7);

% Gaussian Filter
gauss_img = imgaussfilt(img_noisy, 1.5); 

% 3. Median Filter
median_img = medfilt2(img_noisy, [3 3]);

% 4. Laplacian Sharpening (Original)
h_lap = fspecial('laplacian', 0.2);
sharp_img = img_clean - imfilter(img_clean, h_lap);

% calculating PSNR and SSIM
psnr_mean = psnr(mean3_img, img_clean);
ssim_mean = ssim(mean3_img, img_clean);
psnr_mean7 = psnr(mean7_img, img_clean);
ssim_mean7 = ssim(mean7_img, img_clean);
psnr_med = psnr(median_img, img_clean);
ssim_med = ssim(median_img, img_clean);

fprintf('Mean Filter PSNR: %.2f, SSIM: %.4f\n', psnr_mean, ssim_mean);
fprintf('Mean Filter 7x7 PSNR: %.2f, SSIM: %.4f\n', psnr_mean7, ssim_mean7);
fprintf('Median Filter PSNR: %.2f, SSIM: %.4f\n', psnr_med, ssim_med);

figure('Name', 'Task 2: Spatial Filtering');
subplot(2,3,1); imshow(img_noisy); title('Original Noised');
subplot(2,3,2); imshow(mean3_img); title('Mean (3x3)');
subplot(2,3,3); imshow(mean7_img); title('Mean (7x7)');
subplot(2,3,4); imshow(gauss_img); title('Gaussian');
subplot(2,3,5); imshow(median_img); title('Median (3x3)');
subplot(2,3,6); imshow(sharp_img); title('Laplacian Sharpened');


%% Task 3: Frequency-Domain Processing
img_freq = im2double(im2gray(imread('highedge2.jpg')));

% Fourier Transform
F = fftshift(fft2(img_freq));
magnitude_spectrum = log(1 + abs(F));

% Low-Pass Filter Mask
[M, N] = size(img_freq);
[U, V] = meshgrid(-floor(N/2):ceil(N/2)-1, -floor(M/2):ceil(M/2)-1);
D = sqrt(U.^2 + V.^2);
D0 = 30; % cutoff frequency
H_LPF = double(D <= D0);
H_HPF = double(D > D0); % High-Pass Filter

% inverse transform
G_LPF = F .* H_LPF;
img_lpf = real(ifft2(ifftshift(G_LPF)));

G_HPF = F .* H_HPF;
img_hpf = real(ifft2(ifftshift(G_HPF)));

figure('Name', 'Task 3: Frequency Domain');
subplot(2,2,1); imshow(img_freq); title('Original');
subplot(2,2,2); imshow(magnitude_spectrum, []); title('Fourier Spectrum');
subplot(2,2,3); imshow(img_lpf, []); title('Low-Pass Filter (Smoothing)');
subplot(2,2,4); imshow(img_hpf, []); title('High-Pass Filter (Edges)');

%% Task 4: Edge Detection
img_edge = im2gray(imread('highedge2.jpg'));

% edge functions
bw_sobel = edge(img_edge, 'sobel');
bw_prewitt = edge(img_edge, 'prewitt');
bw_log = edge(img_edge, 'log'); 

figure('Name', 'Task 4: Edge Detection');
subplot(2,2,1); imshow(img_edge); title('Original');
subplot(2,2,2); imshow(bw_sobel); title('Sobel Edges');
subplot(2,2,3); imshow(bw_prewitt); title('Prewitt Edges');
subplot(2,2,4); imshow(bw_log); title('LoG Edges');

%% Task 5: Corner Detection
img_corner = im2gray(imread('highedge3.jpg'));

% Harris
corners_harris = detectHarrisFeatures(img_corner);
% FAST 
corners_fast = detectFASTFeatures(img_corner);
% MinEigen (equivalent to Shi-Tomasi)
corners_mineigen = detectMinEigenFeatures(img_corner);

figure('Name', 'Task 5: Corner Detection');
subplot(1,3,1); imshow(img_corner); hold on;
plot(corners_harris.selectStrongest(50)); title('Harris Corners');

subplot(1,3,2); imshow(img_corner); hold on;
plot(corners_fast.selectStrongest(50)); title('FAST Corners');

subplot(1,3,3); imshow(img_corner); hold on;
plot(corners_mineigen.selectStrongest(50)); title('Shi-Tomasi (MinEigen)');

%% Task 6: Planar Rectification with Projective Geometry
img_proj = imread('20260329_141430.jpg');

figure('Name', 'Select Corners');
imshow(img_proj);
title('Click the 4 corners of the object in order (Left Top, Right Top, Right Bottom, Left Bottom) and press Enter');
movingPoints = ginput(4); 
close;

% Define the size of the rectified image !!!!!!!!!
width = 1000; 
height = 800; 
fixedPoints = [1, 1; width, 1; width, height; 1, height];
% Homography
tform = fitgeotrans(movingPoints, fixedPoints, 'projective');
% warping image
Rout = imref2d([height, width]);
rectified_img = imwarp(img_proj, tform, 'OutputView', Rout);

figure('Name', 'Task 6: Projective Rectification');
subplot(1,2,1); imshow(img_proj); hold on;
plot(movingPoints([1:4,1],1), movingPoints([1:4,1],2), 'r-o', 'LineWidth', 2);
title('Original Image');

subplot(1,2,2); imshow(rectified_img); title('Rectified Image');