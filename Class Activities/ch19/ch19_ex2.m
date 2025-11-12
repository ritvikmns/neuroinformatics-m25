load sampleEEGdata.mat;

rts = zeros(1, EEG.trials); 
for ei = 1:EEG.trials
    time0event = find(cell2mat(EEG.epoch(ei).eventlatency) == 0);
    try
        rts(ei) = EEG.epoch(ei).eventlatency{time0event+1};
    catch me
        rts(ei) = NaN; 
    end
end

nan_trials = isnan(rts);
n_nan_trials = sum(nan_trials);

rts_clean = rts(~nan_trials);
n_clean_trials = length(rts_clean);

electrodes_to_plot = {'Fcz', 'Pz', 'PO7'};
n_permutations = 500;

frequencies = logspace(log10(4), log10(40), 20);
n_freqs = length(frequencies);
eeg_times = EEG.times;
n_pnts = EEG.pnts;

s = logspace(log10(3), log10(10), n_freqs) ./ (2 * pi .* frequencies);
wavelet_time = -n_pnts/EEG.srate/2 : 1/EEG.srate : n_pnts/EEG.srate/2 - 1/EEG.srate;
n_wavelet = length(wavelet_time);
n_data = n_pnts * n_clean_trials;
n_convolution = n_wavelet + n_data - 1;
n_conv_pow2 = pow2(nextpow2(n_convolution));
half_wavelet_size_floor = floor((n_wavelet - 1) / 2);
half_wavelet_size_ceil = ceil((n_wavelet - 1) / 2);


for chan_i = 1:length(electrodes_to_plot)
    
    current_chan = electrodes_to_plot{chan_i};
    chan_idx = strcmpi(current_chan, {EEG.chanlocs.labels});
    
    data_clean = EEG.data(chan_idx, :, ~nan_trials);
    eegfft = fft(reshape(data_clean, 1, n_data), n_conv_pow2);
    
 
    itpc_tf = zeros(n_freqs, n_pnts);
    witpc_z_tf = zeros(n_freqs, n_pnts);
    

    for fi = 1:n_freqs
      
        wavelet = exp(2*1i*pi*frequencies(fi).*wavelet_time) .* exp(-wavelet_time.^2 ./ (2*(s(fi)^2))) / frequencies(fi);
        fft_wavelet = fft(wavelet, n_conv_pow2);
        
  
        eegconv = ifft(fft_wavelet .* eegfft, n_conv_pow2);
        eegconv = eegconv(1:n_convolution);
        
        eegconv = reshape(eegconv(half_wavelet_size_floor+1:end-half_wavelet_size_ceil), n_pnts, n_clean_trials);
        
        
        itpc_tf(fi, :) = abs(mean(exp(1i * angle(eegconv)), 2));
        
        perm_witpc = zeros(1, n_permutations); % Pre-allocate
        
        for ti = 1:n_pnts
           
            phases = angle(eegconv(ti, :));
            
          
            witpc_observed = abs(mean(rts_clean .* exp(1i*phases)));
            
  
            for p = 1:n_permutations
                rts_shuffled = rts_clean(randperm(n_clean_trials));
                perm_witpc(p) = abs(mean(rts_shuffled .* exp(1i*phases)));
            end
            
 
            witpc_z_tf(fi, ti) = (witpc_observed - mean(perm_witpc)) / std(perm_witpc);
            
        end
    end
    

    figure; 
    
   
    subplot(1, 2, 1);
    contourf(eeg_times, frequencies, itpc_tf, 40, 'linecolor', 'none');
    set(gca, 'clim', [0 0.6], 'xlim', [-200 1000]);
    xlabel('Time (ms)');
    ylabel('Frequency (Hz)');
    title('Standard ITPC');
    colorbar;
    
   
    subplot(1, 2, 2);
   
    z_max = max(abs(witpc_z_tf), [], 'all');
    z_max = min(z_max, 5); 
    
    contourf(eeg_times, frequencies, witpc_z_tf, 40, 'linecolor', 'none');
    set(gca, 'clim', [-z_max z_max], 'xlim', [-200 1000]);
    xlabel('Time (ms)');
    ylabel('Frequency (Hz)');
    title('wITPCz (RT-Modulated)');
    colorbar;
    

    sgtitle(sprintf('Phase-Behavior Coupling for Electrode %s', current_chan), 'FontSize', 14, 'FontWeight', 'bold');
    
end
