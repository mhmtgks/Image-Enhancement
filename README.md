# Image-Enhancement

Image Enhancement, Filtering, Edge/Corner Analysis, and Planar Rectification 

Mehmet Göksu 

Abdullah Gül University 

ECE531 - Computer Vision - Assignment 1 

1. Introduction 

This report presents a comprehensive image analysis pipeline applied to a self-collected dataset of natural and indoor scenes. The objective is to systematically process raw images, enhance their visual quality under poor illumination, extract structural features, and apply geometric transformations to correct perspective distortions. 

2. Dataset Description 

The dataset corresponds to Option A and consists of 10 self-collected images captured with a mobile phone camera. 

Low Contrast / Poor Illumination (3 images): Indoor scenes taken under severely restricted lighting (a dark staircase, a traditional wall hanging, and a bathroom). The pixel intensities are highly concentrated in the dark regions of the histogram. 

Visible Edges/Corners and Textured Regions (6 images): Scenes containing distinct geometric shapes, complex textures, and sharp transitions. 

Planar Object under Perspective Distortion (1 image): A tilted keyboard on a desk. 

3. Task 1 — Point Operations and Intensity Enhancement 

To improve the visibility of the low-light images (such as the unlit bathroom and dark stairs), three point operations were applied and compared: 

Gamma Correction (γ = 0.5): Selected to apply a non-linear mapping that boosts dark pixels while preserving bright regions. It successfully revealed the overall structure without amplifying noise. 

Histogram Equalization (HE): Chosen to stretch the narrow intensity range globally. While it increased overall brightness, it aggressively amplified background noise, washing out fine details. 

Contrast-Limited Adaptive Histogram Equalization (CLAHE): Selected for localized contrast enhancement. By limiting contrast amplification in homogeneous regions, CLAHE provided the best balance, vividly revealing textures and colors without excessive noise. 

 

4. Task 2 — Spatial Filtering 

Artificial salt-and-pepper noise (d=0.02) was introduced to a textured image to evaluate smoothing versus detail preservation. 
Mean Filter: Used to average neighboring pixels. A 3x3 kernel slightly reduced noise but blurred edges. A 7x7 kernel destroyed critical edge information entirely. 
Gaussian Filter (σ = 1.5): Provided smoother blending than the mean filter, but struggled to eliminate impulse noise effectively. 
Median Filter (3x3): Outperformed linear filters by completely removing salt-and-pepper noise while strictly preserving sharp textural edges. 
Laplacian Sharpening: Applied to the clean image. It pronounced the edges but amplified micro-textures, making flat regions look grainy. 
Quantitative Analysis & Ablation Study (Varying Kernel Size): 

An ablation study systematically varied the kernel size of the Mean Filter. Increasing the kernel size drastically lowered both PSNR and SSIM, proving that larger averaging kernels degrade structural integrity. 

Mean Filter (3x3): PSNR = 31.0 dB, SSIM = 0,7960 
Mean Filter 7x7 PSNR: 29.83, SSIM: 0.8440 
Median Filter PSNR: 42.33, SSIM: 0.9757 

 
5. Task 3 — Frequency-Domain Processing 

Images were transformed into the frequency domain using the Fast Fourier Transform (FFT) to analyze the relationship between frequency content and image structure. 
Low-Pass Filtering (LPF): By masking out high frequencies and keeping the center of the magnitude spectrum, the resulting image became blurred. This demonstrates that low frequencies contain the general illumination and smooth regions of the image. 
High-Pass Filtering (HPF): By blocking the low-frequency center and preserving the outer regions, only rapid intensity changes were retained. The resulting spatial image highlighted structural contours and edges, acting similarly to a spatial Laplacian filter. 

6. Task 4 — Edge Detection 
Three edge detection methods were applied to evaluate edge continuity, thickness, and noise sensitivity. 
Sobel: Provided thick, continuous edges. It was robust to minor noise due to its built-in smoothing. 
Prewitt: Produced results very similar to Sobel, effectively highlighting primary structural boundaries. 
Laplacian of Gaussian (LoG): Provided thinner, highly localized edges. 

Failure Cases: The LoG method failed (or underperformed) in highly textured regions by detecting too many irrelevant micro-edges, making the primary structure hard to distinguish. Sobel/Prewitt occasionally produced overly thick edges that merged close parallel lines. 

7. Task 5 — Corner / Interest Point Detection 

Corner detection was performed to identify distinct 2D structural shifts. 
Harris Corner Detector: Effectively identified true corners (intersections of edges) by evaluating intensity changes in all directions. It was robust to structural changes but sensitive to strong noise. 
FAST: Exceptionally quick and detected a high volume of interest points. However, it struggled to differentiate between true geometric corners and complex micro-textures. 
Difference between Features: Flat regions have no significant intensity change in any direction. Edges represent 1D intensity gradients (changes in one direction). Corners represent 2D shifts (changes in all directions). Corners provide distinct, trackable anchor points compared to continuous edge lines. 

8. Task 6 — Planar Rectification with Projective Geometry 

A planar object keyboard was photographed under severe perspective distortion. 4 correspondence points were manually selected from the distorted image to estimate a homography matrix. 
Geometric Assumptions: The fundamental assumption is that the selected 4 points lie on a perfectly flat 2D plane in the real world (z=0 relative to the object). 
Result: The image was warped to a fronto-parallel view. The projective transformation successfully restored orthogonal properties, correcting the perspective distortion and making the planar object structurally accurate. 


9. Conclusion 

This pipeline successfully executed fundamental image analysis tasks. Point operations (Task 1) proved essential for preprocessing poor illumination. Spatial and frequency filters (Tasks 2 & 3) showcased the trade-off between noise reduction and detail preservation. Feature extraction (Tasks 4 & 5) highlighted the practical differences between gradient-based edges and structural corners. Finally, projective geometry (Task 6) demonstrated a robust method for rectifying spatial distortions based on planar assumptions. 


