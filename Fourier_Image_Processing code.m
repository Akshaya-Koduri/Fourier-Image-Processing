%% FOURIER IMAGE PROCESSING - USER SELECTABLE IMAGE
% Based on the uploaded reference project.
% Select any JPG, JPEG, PNG, BMP, or TIFF image.
% Save this script as Fourier_Image_Processing.m and press Run.

clear; clc; close all;

fprintf('\n============================================\n');
fprintf(' FOURIER TRANSFORM IMAGE PROCESSING PROJECT\n');
fprintf('============================================\n');

% Select input image
[fileName, folderName] = uigetfile( ...
    {'*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff', ...
    'Image files (*.jpg, *.jpeg, *.png, *.bmp, *.tif, *.tiff)'}, ...
    'Select an image to process');

if isequal(fileName, 0)
    fprintf('No image selected. Run the script again to choose an image.\n');
    return;
end

inputPath = fullfile(folderName, fileName);
originalImage = imread(inputPath);

% Prepare grayscale image for Fourier operations
if ndims(originalImage) == 3
    grayImage = rgb2gray(originalImage);
else
    grayImage = originalImage;
end
grayDouble = im2double(grayImage);

fprintf('Selected image: %s\n', inputPath);
fprintf('Image size: %d x %d pixels\n', size(grayImage,1), size(grayImage,2));

while true
    choice = menu('Fourier Image Processing', ...
        '1. View Fourier spectrum', ...
        '2. FFT compression (coefficient thresholding)', ...
        '3. Frequency-domain enhancement', ...
        '4. Simulate motion blur + Wiener-style restoration', ...
        '5. Compare frequency features with another image', ...
        '6. Save current input image copy', ...
        'Exit');

    if choice == 0 || choice == 7
        break;
    end

    switch choice
        case 1
            F = fftshift(fft2(grayDouble));
            spectrum = log(1 + abs(F));
            figure('Name','Fourier Spectrum');
            subplot(1,2,1);
            imshow(originalImage);
            title('Original Image');
            subplot(1,2,2);
            imshow(spectrum, []);
            title('Centered FFT Magnitude Spectrum');
            colormap(gca, gray(256));
            colorbar;
            fprintf('Displayed the Fourier magnitude spectrum.\n');

        case 2
            answer = inputdlg('Discard what percentage of FFT coefficients? (0-99)', ...
                'FFT Compression', [1 50], {'80'});
            if isempty(answer), continue; end
            discardPercent = str2double(answer{1});
            if ~isfinite(discardPercent) || discardPercent < 0 || discardPercent > 99
                errordlg('Enter a number from 0 to 99.','Invalid threshold');
                continue;
            end

            F = fft2(grayDouble);
            magnitude = abs(F);
            threshold = prctile(magnitude(:), discardPercent);
            keepMask = magnitude >= threshold;
            Fcompressed = F .* keepMask;
            reconstructed = real(ifft2(Fcompressed));
            reconstructed = min(max(reconstructed,0),1);

            kept = nnz(keepMask);
            total = numel(keepMask);
            retainedPct = 100 * kept / total;
            estimatedCoefficientReduction = 100 * (1 - kept/total);

            figure('Name','FFT Compression');
            subplot(1,3,1); imshow(grayImage); title('Original Grayscale');
            subplot(1,3,2); imshow(log(1+abs(fftshift(F))),[]); title('FFT Spectrum');
            subplot(1,3,3); imshow(reconstructed,[]); title('Reconstructed');
            sgtitle(sprintf('Discard threshold: %g%% | Coefficients retained: %.2f%%', ...
                discardPercent, retainedPct));

            mse = mean((grayDouble(:)-reconstructed(:)).^2);
            if mse == 0
                psnrValue = Inf;
            else
                psnrValue = 10*log10(1/mse);
            end
            fprintf('\nFFT thresholding results:\n');
            fprintf('  Coefficients retained: %d / %d (%.2f%%)\n', kept, total, retainedPct);
            fprintf('  Coefficient count reduction: %.2f%%\n', estimatedCoefficientReduction);
            fprintf('  Reconstruction PSNR: %.2f dB\n', psnrValue);
            fprintf('  Note: this is coefficient sparsification, not a measured JPG/file-size compression ratio.\n');

            saveChoice = questdlg('Save reconstructed image?', 'Save output', 'Yes','No','Yes');
            if strcmp(saveChoice,'Yes')
                [outFile,outFolder] = uiputfile({'*.png','PNG image (*.png)'}, ...
                    'Save reconstructed image','fft_reconstructed.png');
                if ~isequal(outFile,0)
                    imwrite(reconstructed,fullfile(outFolder,outFile));
                    fprintf('Saved: %s\n',fullfile(outFolder,outFile));
                end
            end

        case 3
            answer = inputdlg({'Filter type: 1 = low-pass, 2 = high-pass', ...
                'Cutoff radius in normalized frequency (0.01 to 0.5)'}, ...
                'Frequency Filter', [1 55; 1 55], {'2','0.08'});
            if isempty(answer), continue; end
            filterType = str2double(answer{1});
            cutoff = str2double(answer{2});
            if ~ismember(filterType,[1 2]) || ~isfinite(cutoff) || cutoff < 0.01 || cutoff > 0.5
                errordlg('Choose filter 1 or 2 and cutoff between 0.01 and 0.5.','Invalid settings');
                continue;
            end

            [M,N] = size(grayDouble);
            [X,Y] = meshgrid((-floor(N/2):ceil(N/2)-1)/N, ...
                             (-floor(M/2):ceil(M/2)-1)/M);
            D = sqrt(X.^2 + Y.^2);
            lowPass = double(D <= cutoff);
            if filterType == 1
                H = lowPass;
                filterName = 'Low-pass';
            else
                H = 1 - lowPass;
                filterName = 'High-pass';
            end

            F = fftshift(fft2(grayDouble));
            filtered = real(ifft2(ifftshift(F .* H)));
            % Display scaled values so high-pass details are visible.
            figure('Name','Frequency-domain Enhancement');
            subplot(1,3,1); imshow(originalImage); title('Original');
            subplot(1,3,2); imshow(log(1+abs(F)),[]); title('FFT Spectrum');
            subplot(1,3,3); imshow(filtered,[]); title([filterName ' Result']);
            sgtitle(sprintf('%s filter, cutoff %.3f',filterName,cutoff));

            saveChoice = questdlg('Save filtered result?','Save output','Yes','No','Yes');
            if strcmp(saveChoice,'Yes')
                [outFile,outFolder] = uiputfile({'*.png','PNG image (*.png)'}, ...
                    'Save filtered image','frequency_filtered.png');
                if ~isequal(outFile,0)
                    imwrite(mat2gray(filtered),fullfile(outFolder,outFile));
                    fprintf('Saved: %s\n',fullfile(outFolder,outFile));
                end
            end

        case 4
            answer = inputdlg({'Motion blur length in pixels (3-51)', ...
                'Motion blur angle in degrees', ...
                'Gaussian noise variance (0-0.05)'}, ...
                'Motion Blur Simulation', [1 55;1 55;1 55], {'15','10','0.001'});
            if isempty(answer), continue; end
            len = round(str2double(answer{1}));
            theta = str2double(answer{2});
            noiseVar = str2double(answer{3});
            if ~isfinite(len) || len < 3 || len > 51 || ~isfinite(theta) || ...
                    ~isfinite(noiseVar) || noiseVar < 0 || noiseVar > 0.05
                errordlg('Use length 3-51, a numeric angle, and noise variance 0-0.05.','Invalid settings');
                continue;
            end

            % Build a simple line-motion PSF without requiring fspecial.
            psf = zeros(len,len);
            mid = (len+1)/2;
            x = round(linspace(1,len,len));
            y = round(mid + (linspace(-1,1,len) * (len-1)/2 * tand(theta)));
            y = min(max(y,1),len);
            for k = 1:len
                psf(y(k),x(k)) = 1;
            end
            psf = psf / sum(psf(:));

            blurred = conv2(grayDouble,psf,'same');
            noisy = blurred + sqrt(noiseVar)*randn(size(blurred));
            noisy = min(max(noisy,0),1);

            % Regularized inverse filter (Wiener-style approximation).
            H = psf2otf_local(psf,size(grayDouble));
            G = fft2(noisy);
            K = max(noiseVar,1e-4);
            restored = real(ifft2((conj(H)./(abs(H).^2 + K)).*G));
            restored = min(max(restored,0),1);

            figure('Name','Motion Blur and Restoration');
            subplot(1,3,1); imshow(grayDouble); title('Original');
            subplot(1,3,2); imshow(noisy); title('Simulated Blur + Noise');
            subplot(1,3,3); imshow(restored); title('Regularized Restoration');
            sgtitle(sprintf('Motion length %d px, angle %.1f degrees',len,theta));

            saveChoice = questdlg('Save restored image?','Save output','Yes','No','Yes');
            if strcmp(saveChoice,'Yes')
                [outFile,outFolder] = uiputfile({'*.png','PNG image (*.png)'}, ...
                    'Save restored image','restored_image.png');
                if ~isequal(outFile,0)
                    imwrite(restored,fullfile(outFolder,outFile));
                    fprintf('Saved: %s\n',fullfile(outFolder,outFile));
                end
            end

        case 5
            [file2,folder2] = uigetfile( ...
                {'*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff','Image files'}, ...
                'Select a second image to compare');
            if isequal(file2,0), continue; end
            image2 = imread(fullfile(folder2,file2));
            if ndims(image2)==3, image2 = rgb2gray(image2); end
            image2 = im2double(imresize(image2,[256 256]));
            image1 = im2double(imresize(grayImage,[256 256]));

            F1 = fftshift(fft2(image1));
            F2 = fftshift(fft2(image2));
            mag1 = log(1+abs(F1));
            mag2 = log(1+abs(F2));
            % Normalize each spectrum for a meaningful visual comparison.
            mag1 = mat2gray(mag1);
            mag2 = mat2gray(mag2);
            featureDistance = norm(mag1(:)-mag2(:));

            figure('Name','Frequency Feature Comparison');
            subplot(2,2,1); imshow(image1,[]); title('Image 1');
            subplot(2,2,2); imshow(image2,[]); title('Image 2');
            subplot(2,2,3); imshow(mag1,[]); title('Normalized Spectrum 1');
            subplot(2,2,4); imshow(mag2,[]); title('Normalized Spectrum 2');
            fprintf('Normalized frequency-spectrum distance: %.6f\n',featureDistance);
            fprintf('Smaller distance means the normalized spectra are more similar by this measure only.\n');

        case 6
            [outFile,outFolder] = uiputfile( ...
                {'*.png','PNG image (*.png)';'*.jpg','JPEG image (*.jpg)'}, ...
                'Save a copy of the selected input image', ...
                ['input_copy' get_image_extension(fileName)]);
            if ~isequal(outFile,0)
                imwrite(originalImage,fullfile(outFolder,outFile));
                fprintf('Saved: %s\n',fullfile(outFolder,outFile));
            end
    end
end

fprintf('Project menu closed.\n');

%% Local helper: convert a PSF to a centered OTF of target image size.
function H = psf2otf_local(psf, outSize)
    psfSize = size(psf);
    padded = zeros(outSize);
    rows = min(psfSize(1),outSize(1));
    cols = min(psfSize(2),outSize(2));
    padded(1:rows,1:cols) = psf(1:rows,1:cols);
    padded = circshift(padded, -floor(psfSize/2));
    H = fft2(padded);
end

function ext = get_image_extension(fileName)
    [~,~,ext] = fileparts(fileName);
    if isempty(ext), ext = '.png'; end
end
