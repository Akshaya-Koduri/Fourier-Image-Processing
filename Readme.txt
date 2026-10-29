Fourier Image Processing Using MATLAB

📌 Project Overview

Fourier Image Processing is a MATLAB-based Digital Image Processing (DIP) project that applies Fourier Transform techniques to analyze and enhance digital images in the frequency domain.

The project uses the 2D Fast Fourier Transform (FFT) to study image frequency components and perform operations such as frequency-domain filtering, FFT coefficient thresholding, motion blur simulation, image restoration, and frequency feature comparison.

The application provides an interactive menu that allows users to select an image, choose a processing technique, visualize the results, and save the processed images.

🎯 Objectives

- Understand the application of Fourier Transform in digital image processing.
- Analyze image frequency components using the 2D FFT.
- Perform image enhancement using low-pass and high-pass filters.
- Explore FFT coefficient thresholding for image reconstruction.
- Simulate motion blur and noise and restore degraded images.
- Compare the frequency-domain features of two images.

✨ Features

1. Fourier Spectrum Visualization

- Converts the input image to grayscale.
- Computes the 2D Fast Fourier Transform.
- Centers the frequency spectrum using "fftshift".
- Displays the logarithmic magnitude spectrum for better visualization.

2. FFT-Based Image Compression Simulation

- Applies thresholding to Fourier coefficients based on their magnitudes.
- Allows users to specify the percentage threshold.
- Reconstructs the image using the inverse FFT.
- Calculates the retained coefficient percentage and coefficient reduction.
- Evaluates reconstruction quality using Mean Squared Error (MSE) and Peak Signal-to-Noise Ratio (PSNR).

Note: This feature demonstrates Fourier coefficient sparsification. It does not calculate the actual compressed file size or a JPEG compression ratio.

3. Frequency-Domain Image Enhancement

Supports two types of frequency filters:

- Low-Pass Filter: Retains lower-frequency components and suppresses higher frequencies, helping reduce fine details and smooth the image.
- High-Pass Filter: Suppresses lower-frequency components while retaining higher frequencies, helping highlight edges and fine details.

Users can specify the filter type and cutoff frequency.

4. Motion Blur Simulation and Image Restoration

- Simulates motion blur using a line-shaped Point Spread Function (PSF).
- Adds Gaussian noise with a user-defined variance.
- Applies a regularized inverse-filtering approach inspired by Wiener filtering.
- Displays the original, degraded, and restored images side by side.

5. Frequency Feature Comparison

- Accepts a second image for comparison.
- Converts both images to grayscale and resizes them to a common resolution.
- Computes and normalizes their Fourier magnitude spectra.
- Calculates the Euclidean distance between the normalized spectra.
- Displays both images and their corresponding frequency spectra.

A smaller distance indicates greater similarity between the normalized spectra according to this particular measure. It is not a general-purpose image recognition or classification score.

6. Save Processed Images

- Save reconstructed images after FFT thresholding.
- Save frequency-filtered images.
- Save restored images after simulated motion blur.
- Save a copy of the original input image.

🛠️ Technologies Used

- Programming Language: MATLAB
- Domain: Digital Image Processing
- Core Concepts: Fourier Transform, Fast Fourier Transform (FFT), Frequency-Domain Filtering, Image Restoration
- Image Processing Operations: Grayscale Conversion, Image Reconstruction, Noise Simulation, Frequency Spectrum Analysis
- Evaluation Metrics: Mean Squared Error (MSE), Peak Signal-to-Noise Ratio (PSNR)

📂 Project Structure

Fourier-Image-Processing/
│
├── Fourier_Image_Processing.m   # Main MATLAB application
├── README.md                    # Project documentation
└── sample_images/               # Optional sample input images

The "sample_images/" folder is optional. The program allows users to select images directly from their computer.

⚙️ Requirements

- MATLAB installed on your computer.
- An image in JPG, JPEG, PNG, BMP, TIF, or TIFF format.
- Image Processing Toolbox may be required for certain image-processing functions, depending on your MATLAB installation.

🚀 How to Run the Project

Step 1: Clone the Repository

Open your terminal and run:

git clone <your-repository-url>

Replace "<your-repository-url>" with your GitHub repository URL.

Step 2: Open the Project

Navigate to the downloaded repository folder and open MATLAB.

Step 3: Run the MATLAB Script

Open the file:

Fourier_Image_Processing.m

Click Run in MATLAB.

Alternatively, navigate to the project folder in MATLAB and execute:

Fourier_Image_Processing

Step 4: Select an Image

A file selection window will appear. Choose an image from your computer.

Step 5: Choose a Processing Operation

Select one of the available operations from the interactive menu:

1. View Fourier Spectrum
2. FFT Compression (Coefficient Thresholding)
3. Frequency-Domain Enhancement
4. Simulate Motion Blur + Restoration
5. Compare Frequency Features with Another Image
6. Save Current Input Image Copy
7. Exit

Follow the prompts to configure the selected operation and save the results if required.

🧠 Working Principle

The project uses Fourier Transform techniques to represent an image in the frequency domain.

The main processing workflow is:

1. Image Input: Load the selected image.
2. Preprocessing: Convert the image to grayscale and normalize its pixel values.
3. Fourier Transform: Apply the 2D FFT to obtain frequency-domain information.
4. Frequency Analysis: Visualize the Fourier magnitude spectrum.
5. Image Processing: Apply coefficient thresholding, frequency filtering, or simulated degradation and restoration.
6. Inverse Fourier Transform: Reconstruct the image when required.
7. Evaluation: Calculate image reconstruction metrics or compare normalized frequency spectra.
8. Output: Display and optionally save the processed image.

📐 Key Mathematical Concepts

1. Two-Dimensional Fourier Transform

The 2D Discrete Fourier Transform represents an image in terms of its spatial frequency components.

For an image of size M × N:

[
F(u,v)=\sum_{x=0}^{M-1}\sum_{y=0}^{N-1}
f(x,y)e^{-j2\pi(ux/M+vy/N)}
]

Where:

- f(x,y) represents the original image.
- F(u,v) represents its frequency-domain representation.
- u,v denote frequency coordinates.

2. Inverse Fourier Transform

The inverse Fourier Transform converts the frequency-domain representation back into the spatial domain, allowing the processed image to be reconstructed.

3. Mean Squared Error (MSE)

MSE measures the average squared difference between the original image and its reconstructed version.

A lower MSE generally indicates less reconstruction error.

4. Peak Signal-to-Noise Ratio (PSNR)

PSNR evaluates reconstruction quality in decibels. For images normalized to the range [0, 1], it is calculated as:

[
PSNR=10\log_{10}\left(\frac{1}{MSE}\right)
]

A higher PSNR generally indicates better reconstruction quality.

📊 Expected Results

The application allows users to observe:

- The Fourier magnitude spectrum of an input image.
- Image reconstruction after Fourier coefficient thresholding.
- Differences between low-pass and high-pass filtering.
- The effects of simulated motion blur and Gaussian noise.
- The results of frequency-domain image restoration.
- Differences between the normalized Fourier spectra of two images.
- Reconstruction metrics such as MSE and PSNR.

The results depend on the selected image and the parameters entered by the user.

🔬 Applications

Fourier-based image processing techniques are relevant to:

- Digital image enhancement.
- Image noise reduction and filtering.
- Image restoration.
- Frequency-domain image analysis.
- Image compression research.
- Computer vision preprocessing.
- Analysis of image texture and frequency characteristics.

🔮 Future Enhancements

- Implement Gaussian and Butterworth frequency filters.
- Add quantitative image quality metrics such as SSIM.
- Compare multiple image restoration techniques.
- Add batch processing for multiple images.
- Develop a graphical interface with additional visualization options.
- Evaluate compression performance using actual file sizes and reconstruction quality.

👥 Project Team

- Akshaya Koduri — Reg. No. 23BCE7061
- G. Sai Ashritha — Reg. No. 23BCE8211
- G. Preethi Varshitha — Reg. No. 23BCE8506

📚 Conclusion

This project demonstrates how Fourier Transform techniques can be applied to digital image processing using MATLAB. By exploring frequency spectrum visualization, coefficient thresholding, frequency filtering, motion blur simulation, image restoration, and frequency feature comparison, the application provides a practical introduction to frequency-domain image analysis.

The project also demonstrates the use of inverse Fourier Transform and image quality metrics to evaluate image reconstruction.

---

Project: Fourier Image Processing Using MATLAB
Domain: Digital Image Processing
Language: MATLAB