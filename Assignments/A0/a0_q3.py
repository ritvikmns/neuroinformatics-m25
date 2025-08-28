import numpy as np
import matplotlib.pyplot as plt

def sine_wave(freq, dur, sampling_rate, phase = 0, amplitude=1):
    t = np.linspace(0, dur, int(sampling_rate * dur), endpoint=False)
    return amplitude * np.sin((2 * np.pi * freq * t) + phase)

dur = 4
sampling_rate = 1/0.001

s1 = sine_wave(2, dur, sampling_rate)
s2 = sine_wave(8, dur, sampling_rate, phase=np.pi/2, amplitude=0.5)
s3 = sine_wave(12, dur, sampling_rate, phase=np.pi/4, amplitude=0.25)
s4 = sine_wave(25, dur, sampling_rate, phase=np.pi/3, amplitude=0.1)

def white_noise(amount, duration, sampling_rate):
    n_samples = int(duration * sampling_rate)
    return np.random.normal(0, amount, n_samples)

s1_added = s1 + white_noise(0.1, dur, sampling_rate)
s1_more = s1 + white_noise(0.5, dur, sampling_rate)

plt.subplots(3, 1, figsize=(10, 10), sharex=True)
plt.subplot(3, 1, 1)
plt.plot(s1_added, color='blue')
plt.title('Sine Wave - 2 Hz with White Noise (0.1)')
plt.subplot(3, 1, 2)
plt.plot(s1_more, color='green')
plt.title('Sine Wave - 2 Hz with More White Noise (0.5)')
plt.subplot(3, 1, 3)
plt.plot(s1, color='red')
plt.title('Original Sine Wave - 2 Hz')
plt.xlabel('Time (ms)')
plt.tight_layout()
plt.savefig("sine_waves_with_noise_plot.png", dpi=300)
plt.show()



# Fourier Transform of the Sine Wave with Added White Noise
N = len(s1_added)
sampling_interval = 0.001 
yf_s1_added = np.fft.fft(s1_added)
xf_s1_added = np.fft.fftfreq(N, sampling_interval)
plt.figure(figsize=(10, 5))
plt.plot(xf_s1_added[:N//2], np.abs(yf_s1_added)[:N//2], color='blue')
plt.title('Fourier Transform of Sine Wave with Added White Noise (0.1)')
plt.xlabel('Frequency (Hz)')
plt.ylabel('Amplitude')
plt.grid()
plt.xlim(0, 30)
plt.savefig("fourier_transform_s1_added.png", dpi=300)
plt.show()

# Fourier Transform of the Sine Wave with More Added White Noise
yf_s1_more = np.fft.fft(s1_more)
xf_s1_more = np.fft.fftfreq(N, sampling_interval)
plt.figure(figsize=(10, 5))
plt.plot(xf_s1_more[:N//2], np.abs(yf_s1_more)[:N//2], color='green')
plt.title('Fourier Transform of Sine Wave with Added White Noise (0.5)')
plt.xlabel('Frequency (Hz)')
plt.ylabel('Amplitude')
plt.grid()
plt.xlim(0, 30)
plt.savefig("fourier_transform_s1_more.png", dpi=300)
plt.show()
