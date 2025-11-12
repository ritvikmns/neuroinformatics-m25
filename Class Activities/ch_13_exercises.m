%% 13.1

load sampleEEGdata.mat;

freqs = linspace(2, 30, 5);
time = -1:1/EEG.srate:1;
n = 5;
m = 6;

wavelets = complex(zeros(n, numel(time)));

for i = 1:n 
    wavelets(i, :) = morlet_wavelet(freqs(i), m, time);
end

subplot(2, 1, 1);
hold on;
for k = 1:length(freqs)
    plot(time, real(wavelets(k, :)), 'DisplayName', sprintf('Freq = %.1f Hz', freqs(k)));
end
title('Real Part of Wavelets at Different Frequencies');
xlabel('Time (s)');
ylabel('Amplitude');
legend show;
grid on;

subplot(2, 1, 2);
hold on;
for k = 1:length(freqs)
    plot(time, imag(wavelets(k, :)), 'DisplayName', sprintf('Freq = %.1f Hz', freqs(k)));
end
title('Imaginary Part of Wavelets at Different Frequencies');
xlabel('Time (s)');
ylabel('Amplitude');
legend show;
grid on;

function w = morlet_wavelet(f0, m, t)
    sigma = m / (2*pi*f0);
    w = exp(2*1i*pi*f0*t) .* exp(-t.^2/(2*sigma^2));
    w = w ./ sqrt(sum(abs(w).^2)) / sqrt(sigma); % normalize energy and scale
end


%% 13.2

trial_num = 4;
trial_data = squeeze(EEG.data(:, :, trial_num));
[channels, timepoints] = size(trial_data);

conv_res = complex(zeros(n, channels, timepoints));

for i = 1:n
    for ch = 1:channels
        conv_res(i, ch, :) = conv(trial_data(ch, :), wavelets(i, :), "same");
    end
end

%% 13.3

power_res = zeros(n, channels, timepoints);

for i = 1:n
    for ch = 1:channels
         power_res(i, ch, :) = abs(conv_res(i, ch, :) .^2);
    end
end


phase_res = zeros(n, channels, timepoints);

for i = 1:n
    for ch = 1:channels
         phase_res(i, ch, :) = angle(conv_res(i, ch, :));
    end
end

%% 13.4

