function synsamples = data_augmentation_generator( sample1,sample2,per,yaxis_intensifier,xaxis_shift_samples,wavelengths,gaussiansnr, gaussian_samples)
%Data augmentation generator
%
%   synsamples = data_augmentation_generator( sample1,sample2,per,yaxis_intensifier,xaxis_shift_samples,wavelengths,gaussiansnr,gaussian_samples) 
%         Input:
%             sample1 - Main sample spectrum (Array 1xN, N is the number of
%                       wavelengths/wavenumbers)
%             sample2 - Second sample spectrum for the blender block (Array 1xN) 
%             per - concentration grades for the blender block (Array)
%             yaxis_intensifier - amplification factor for spectral intensifier
%             xaxis_shift_samples - number of samples produced by shifting
%                                   along x axis block
%             wavelengths - wavelengths/wavenumbers of the spectra needed
%                           for the shifting along x axis block (Array 1xN)
%             gaussiansnr - Gaussian noise signal-to-noise ratio per spectrum, in dB
%             gaussian_samples - number of samples produced by adding noise
%                                block
%             
% 
%         Output:
%             synsamples - the generated spectra.            
%
%         Reference:
%                Georgouli, K., Osorio, M.T., Martinez Del Rincon, J. and Koidis, A.,
%                2018. Data augmentation in food science: Synthesising spectroscopic 
%                data of vegetable oils for performance enhancement. Journal of Chemometrics,
%                32(6), p.e3004.
 
% (C) Konstantia Georgouli, Queen's University of Belfast

    syntheticspectra=[];
    yshiftedspectra=[];
    xshiftedspectra=[];
    gaussianspectra=[];
    
    %%Parameters checking
    if isempty(sample1)==1
        disp('Sample1 is required.');
        return;
    end    
    
    %% Blender
    if isempty(sample2)==0
        for i=1:size(per,2)
            syntheticspectra(i,:)=(sample1*(1-per(i)))+(sample2*per(i));
        end
    end

    %% Spectral intensifier
    if yaxis_intensifier~=0
        for i=1:yaxis_intensifier
            factor=0.01*i;
            newspp(i,:)=sample1*(1+factor);
        end
        yshiftedspectra=newspp;
    end

    %% Shifting along x axis
    if xaxis_shift_samples~=0
        operation1 = [zeros(1,round(size(sample1,2)*0.96)) ones(1,round(size(sample1,2)*0.02)) ones(1,round(size(sample1,2)*0.02))*(-1)];  

        if size(operation1,2)<size(sample1,2)
            operation1(size(sample1,2))=0;
        end

        xshiftedspectra=[]; 

        for i=1:xaxis_shift_samples
            xshiftedspectra(i,:)=sample1;
            operation = operation1(randperm(size(sample1,2))); 
            for j=1:size(sample1,2)
                rr=operation(j);
                if rr==0
                    xshiftedspectra(i,j)=sample1(1,j);  
                elseif (rr>0)
                    if(j+rr<=size(sample1,2))
                        xshiftedspectra(i,j+rr)=sample1(1,j+rr)+sample1(1,j);   
                    end
                else
                    rr=abs(rr);
                    if(j-rr>=1)
                          xshiftedspectra(i,j-rr)=sample1(1,j-rr)+sample1(1,j);   
                    end         
                end 
            end

            %remove sharp slopes after x shifting+normalisation 
            for j=1:size(xshiftedspectra(i,:),2)-1
                ratioslope=3;

                if abs(xshiftedspectra(i,j+1)-xshiftedspectra(i,j))>(xshiftedspectra(i,j)/ratioslope) % 20 5% difference from the initial
                    if xshiftedspectra(i,j)<xshiftedspectra(i,j+1)
                        k=2;
                        if j+k>size(xshiftedspectra(i,:),2) 
                            k=k-1;                                    
                        else                                
                            while(abs(xshiftedspectra(i,j+k)-xshiftedspectra(i,j)))>(xshiftedspectra(i,j)/ratioslope) 
                                k=k+1; %->>ADD one to k until find a higher point
                                if j+k>size(xshiftedspectra(i,:),2) %for last element
                                    k=k-1;
                                    break;
                                end
                                if abs(xshiftedspectra(i,j+k-1)-xshiftedspectra(i,j+k))>(xshiftedspectra(i,j+k-1)/ratioslope)                 
                                    break;
                                end                              
                            end  
                         end
                         new = interp1([wavelengths(j),wavelengths(j+k)],[xshiftedspectra(i,j),xshiftedspectra(i,j+k)],wavelengths(j:j+k));
                         xshiftedspectra(i,j:j+k)=new;                           
                    else
                         if j==1  %%for the first element
                            xshiftedspectra(i,j)=xshiftedspectra(i,j+1);  
                         end   
                    end
                end
            end      
        end
    end

    %% Add Gaussian noise
    if gaussiansnr~=0
        for i=1:gaussian_samples
          gaussianspectra(i,:) = awgn(sample1,gaussiansnr,'measured'); % Add white Gaussian noise.
        end
    end

    synsamples=[syntheticspectra;yshiftedspectra;xshiftedspectra;gaussianspectra];
end
