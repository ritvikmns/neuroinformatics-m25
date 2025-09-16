%% 12. 1
load sampleEEGdata.mat;
freqs = linspace(2, 30, 5);
time = -1:1/EEG.srate:1;
n = 5;

[FreqGrid, TimeGrid] = meshgrid(freqs, time);

sins = cos(2*FreqGrid * pi .* TimeGrid);
s = n./(2*pi*freqs);

sGrid = repmat(s,length(time), 1);
gaussian_wins = exp(-TimeGrid.^2./(2*sGrid.^2));

wavelets = sins.*gaussian_wins;

subplot(2, 1, 2);
for k = 1:length(freqs)
    hold on;
    plot(time, wavelets(:, k), 'DisplayName', sprintf('Freq = %.1f Hz', freqs(k)));
end
title('Wavelets at Different Frequencies');
xlabel('Time (s)');
ylabel('Amplitude');
legend show;
grid on;

%% 12.2

channel_idx  = 5;
channel_data = squeeze(EEG.data(channel_idx, :, :));
nSamples     = size(channel_data, 1);
nTrials      = size(channel_data, 2);
nFrequencies = size(wavelets, 2); 

conv_result = zeros(nFrequencies, nSamples, nTrials);  
for f = 1:nFrequencies
    wavelet = wavelets(:, f);  % [length(time) × 1]

    for tr = 1:nTrials
        signal = channel_data(:, tr);  % [640 × 1]

        conv_signal = conv(signal, wavelet, 'same');  % [640 × 1]

        conv_result(f, :, tr) = real(conv_signal);
    end
end

disp(size(conv_result));  % Should print [5, 640, 99]

%% 12.3 + 12.4
mean_raw_signal = mean(channel_data, 2);
figure;
subplot(nFrequencies+1, 1, 1);


plot(EEG.times, mean_raw_signal, 'b', 'LineWidth', 1.5);
xlabel('Time (ms)');
ylabel('Amplitude');
title(sprintf('Mean Raw EEG Data - Channel %d', channel_idx));
grid on;

for f = 1:nFrequencies
    subplot(nFrequencies+1, 1, f+1);
   
    mean_conv_signal = mean(squeeze(conv_result(f, :, :)), 2);  % [640 × 1]

    plot(EEG.times, mean_conv_signal, 'b', 'LineWidth', 1.5);
    xlabel('Time (ms)');
    ylabel('Amplitude');
    title(sprintf('Convolved Data with Wavelet Frequency %.1f Hz', freqs(f)));
    grid on;
end

