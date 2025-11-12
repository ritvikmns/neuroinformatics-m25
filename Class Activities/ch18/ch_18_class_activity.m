load sampleEEGdata.mat;
time_points = [0 100 200 300 400 500];

%% Time Frequency Analysis without baseline
min_freq = 2;
max_freq = 128;
num_frex = 30;
trial_idx = 1;
frequencies = logspace(log10(min_freq),log10(max_freq),num_frex);

n_chans = EEG.nbchan;
n_pnts = EEG.pnts;
n_trials = EEG.trials;
eeg_times = EEG.times;

n_freqs = length(frequencies);
chan_tf_data_raw = zeros(n_freqs, n_pnts);
time = -1:1/EEG.srate:1;
n_wavelet     = length(time);
n_data        = EEG.pnts;
n_convolution = n_wavelet+n_data-1;
half_of_wavelet_size = (length(time)-1)/2;
wavelet_cycles= 4; 

n_conv_pow2   = pow2(nextpow2(n_convolution));

baselinetime = [ -500 -200 ]; % in ms

[~,baselineidx(1)]=min(abs(EEG.times-baselinetime(1)));
[~,baselineidx(2)]=min(abs(EEG.times-baselinetime(2)));

no_baseline = zeros(n_freqs, n_pnts, n_chans);
with_baseline = zeros(n_freqs, n_pnts, n_chans);

for channel_idx=1:n_chans
    fft_data = fft(squeeze(EEG.data(channel_idx,:,trial_idx)),n_conv_pow2);
    chan_tf_data_raw = zeros(n_freqs, n_pnts); 
    
    for fi=1:length(frequencies)
        wavelet = (pi*frequencies(fi)*sqrt(pi))^-.5 * exp(2*1i*pi*frequencies(fi).*time) .* exp(-time.^2./(2*( wavelet_cycles /(2*pi*frequencies(fi)))^2))/frequencies(fi);
        fft_wavelet = fft(wavelet,n_conv_pow2);
        
        convolution_result_fft = ifft(fft_wavelet.*fft_data,n_conv_pow2);
        convolution_result_fft = convolution_result_fft(1:n_convolution);
        convolution_result_fft = convolution_result_fft(half_of_wavelet_size+1:end-half_of_wavelet_size);
        
        chan_tf_data_raw(fi,:) = abs(convolution_result_fft).^2;
    end
    no_baseline(:, :, channel_idx) = chan_tf_data_raw;
    baseline_power = mean(chan_tf_data_raw(:, baselineidx(1):baselineidx(2)), 2);
    chan_tf_data_db = 10 * log10(bsxfun(@rdivide, chan_tf_data_raw, baseline_power));
    with_baseline(:, :, channel_idx) = chan_tf_data_db;
end



%% Topo plots

frequencies_to_plot = [18 25]; 

times_to_plot = time_points;
calculated_freqs = frequencies;
calculated_times = EEG.times;
n_cols = length(times_to_plot);


freq_indices = zeros(size(frequencies_to_plot));
for i = 1:length(frequencies_to_plot)
    [~, freq_indices(i)] = min(abs(calculated_freqs - frequencies_to_plot(i)));
end

time_indices = zeros(size(times_to_plot));
for i = 1:length(times_to_plot)
    [~, time_indices(i)] = min(abs(calculated_times - times_to_plot(i)));
end


for f_idx = 1:length(freq_indices)
    
    current_freq_index = freq_indices(f_idx);
    current_freq_value = round(calculated_freqs(current_freq_index));

    figure('Position', [100 100 1500 600]);
    
    data_raw_all_times = squeeze(no_baseline(current_freq_index, time_indices, :));
    data_db_all_times  = squeeze(with_baseline(current_freq_index, time_indices, :));

    clim_raw = [min(data_raw_all_times, [], 'all') max(data_raw_all_times, [], 'all')];
    
    max_db = max(abs(data_db_all_times), [], 'all');
    clim_db  = [-max_db max_db];
    
    for t_idx = 1:n_cols
        
        current_time_index = time_indices(t_idx);
        current_time_value = round(calculated_times(current_time_index));

        subplot_num = t_idx;
        subplot(2, n_cols, subplot_num);
        
        data_to_plot_raw = squeeze(no_baseline(current_freq_index, current_time_index, :));
        
        topoplot(data_to_plot_raw, EEG.chanlocs, 'maplimits', clim_raw, 'style', 'map', 'electrodes', 'off');
        title(sprintf('%d ms', current_time_value));
        
        if t_idx == 1
            ylabel('Raw Power');
        end

        subplot_num = t_idx + n_cols;
        subplot(2, n_cols, subplot_num);
        
        data_to_plot_db = squeeze(with_baseline(current_freq_index, current_time_index, :));
        
        topoplot(data_to_plot_db, EEG.chanlocs, 'maplimits', clim_db, 'style', 'map', 'electrodes', 'off');
        
        if t_idx == 1
            ylabel('dB Power');
        end
    end
    
    subplot(2, n_cols, n_cols); 
    cbar_raw = colorbar('Position', [0.92 0.6 0.02 0.3]);
    cbar_raw.Label.String = 'Raw Power (\muV^2)';
    
    
    subplot(2, n_cols, n_cols * 2);
    cbar_db = colorbar('Position', [0.92 0.1 0.02 0.3]);
    cbar_db.Label.String = 'dB Power (normalized)';
    
    sgtitle(sprintf('Topographical Power at %d Hz', current_freq_value), 'FontSize', 16, 'FontWeight', 'bold');

end