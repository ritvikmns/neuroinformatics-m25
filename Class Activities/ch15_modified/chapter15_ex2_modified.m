timewin        = 400; % in ms, for stFFT
times2save     = -300:50:1000; % in ms
channel2plot   = 'Cz';
frequency2plot = 15;  % in Hz
timepoint2plot = 200; % ms
NW = 3; %time-bandwidth product
K = 2*NW - 1;

% convert from ms to index
times2saveidx = zeros(size(times2save));
for i=1:length(times2save)
    [junk,times2saveidx(i)]=min(abs(EEG.times-times2save(i)));
end
timewinidx = round(timewin/(1000/EEG.srate));
chan2useidx = strcmpi(channel2plot,{EEG.chanlocs.labels});

% create multiple tapers (slepian)
tapers = dpss(timewinidx, NW, K);

% define frequencies
frex = linspace(0,EEG.srate/2,floor(timewinidx/2)+1);

% initialize power output matrix
tf = zeros(length(frex),length(times2save));

% loop over time points and perform FFT
for timepointi=1:length(times2save)
    
    % extract time series data for this center time point
    tempdat = squeeze(EEG.data(chan2useidx,times2saveidx(timepointi)-floor(timewinidx/2):times2saveidx(timepointi)+floor(timewinidx/2)-mod(timewinidx+1,2),:)); % note: the 'mod' function here corrects for even or odd number of points
    
    power_sum_over_tapers = zeros(length(frex), size(tempdat,2));
    
    % loop over tapers
    for k=1:K
        taperdat = bsxfun(@times, tempdat, tapers(:,k));
        fdat = fft(taperdat,[],1)/timewinidx;
       
        % add power to the sum
        power_sum_over_tapers = power_sum_over_tapers + abs(fdat(1:floor(timewinidx/2)+1,:)).^2;
    end
    
    % average over tapers (divide by K)
    power_avg_over_tapers = power_sum_over_tapers / K;
    
    % average over trials (dim 2)
    tf(:,timepointi) = mean(power_avg_over_tapers, 2);

end

baseline_start = -300; % in ms
baseline_end   = -100; % in ms

[~, baseidx_start] = min(abs(times2save - baseline_start));
[~, baseidx_end]   = min(abs(times2save - baseline_end));

baseline_power = mean(tf(:, baseidx_start:baseidx_end), 2);

tf_db = 10 * log10( bsxfun(@rdivide, tf, baseline_power) );

% plot
figure
subplot(121)
[junk,freq2plotidx]=min(abs(frex-frequency2plot));
plot(times2save,mean(tf_db(freq2plotidx-2:freq2plotidx+2,:),1));
title([ 'Sensor ' channel2plot ', ' num2str(frequency2plot) ' Hz' ])
axis square
set(gca,'xlim',[times2save(1) times2save(end)])

subplot(122)
[junk,time2plotidx]=min(abs(times2save-timepoint2plot));
plot(frex,tf_db(:,time2plotidx));
title([ 'Sensor ' channel2plot ', ' num2str(timepoint2plot) ' ms' ])
axis square
set(gca,'xlim',[frex(1) 40])

figure
contourf(times2save,frex,tf_db,40,'linecolor','none')
set(gca,'clim',[-2 1])
title([ 'Sensor ' channel2plot ', power plot (baseline correction done)' ])

disp([ 'Overlap of ' num2str(100*(1-mean(diff(times2save))/timewin)) '%' ])