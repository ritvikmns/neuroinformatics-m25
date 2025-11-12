load sampleEEGdata.mat;
electrodes_to_plot = {'Fcz', 'Pz', 'PO7'};

frequencies = logspace(log10(4), log10(40), 20);
n_freqs = length(frequencies);
eeg_times = EEG.times;
n_pnts = EEG.pnts;
n_trials = EEG.trials;

s = logspace(log10(3), log10(10), n_freqs) ./ (2 * pi .* frequencies);

baseline_window = [-500 -200];
[~, baseline_idx(1)] = min(abs(eeg_times - baseline_window(1)));
[~, baseline_idx(2)] = min(abs(eeg_times - baseline_window(2)));

wavelet_time = -n_pnts/EEG.srate/2 : 1/EEG.srate : n_pnts/EEG.srate/2 - 1/EEG.srate;
n_wavelet = length(wavelet_time);
n_data = n_pnts * n_trials;
n_convolution = n_wavelet + n_data - 1;
n_conv_pow2 = pow2(nextpow2(n_convolution));


half_wavelet_size_floor = floor((n_wavelet - 1) / 2);
half_wavelet_size_ceil = ceil((n_wavelet - 1) / 2);

for chan_i = 1:length(electrodes_to_plot)
    
    current_chan = electrodes_to_plot{chan_i};
    chan_idx = strcmpi(current_chan, {EEG.chanlocs.labels});
  
   
    eegfft = fft(reshape(EEG.data(chan_idx, :, :), 1, n_data), n_conv_pow2);
    
    itpc_tf = zeros(n_freqs, n_pnts);
    power_tf_raw = zeros(n_freqs, n_pnts);
   
    for fi = 1:n_freqs
       
        wavelet = exp(2*1i*pi*frequencies(fi).*wavelet_time) .* exp(-wavelet_time.^2 ./ (2*(s(fi)^2))) / frequencies(fi);
        fft_wavelet = fft(wavelet, n_conv_pow2);
       
        eegconv = ifft(fft_wavelet .* eegfft, n_conv_pow2);
        eegconv = eegconv(1:n_convolution);
      
        eegconv = reshape(eegconv(half_wavelet_size_floor+1:end-half_wavelet_size_ceil), n_pnts, n_trials);
        
        itpc_tf(fi, :) = abs(mean(exp(1i * angle(eegconv)), 2));
        power_tf_raw(fi, :) = mean(abs(eegconv).^2, 2);
        
    end
    
    baseline_power = mean(power_tf_raw(:, baseline_idx(1):baseline_idx(2)), 2);
    power_tf_db = 10 * log10(bsxfun(@rdivide, power_tf_raw, baseline_power));
    figure; 
    
    subplot(1, 2, 1);
    contourf(eeg_times, frequencies, power_tf_db, 40, 'linecolor', 'none');
    set(gca, 'clim', [-3 3], 'xlim', [-200 1000]); % Set a fixed 3dB color scale
    xlabel('Time (ms)');
    ylabel('Frequency (Hz)');
    title('DB-Corrected Power');
    colorbar;
   
    subplot(1, 2, 2);
    contourf(eeg_times, frequencies, itpc_tf, 40, 'linecolor', 'none');
    set(gca, 'clim', [0 0.6], 'xlim', [-200 1000]); % Set color scale from Fig 19.4
    xlabel('Time (ms)');
    ylabel('Frequency (Hz)');
    title('ITPC');
    colorbar;
    
    sgtitle(sprintf('Time-Frequency Analysis for Electrode %s', current_chan), 'FontSize', 14, 'FontWeight', 'bold');
    
end