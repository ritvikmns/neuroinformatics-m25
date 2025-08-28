import numpy as np
import matplotlib.pyplot as plt
from scipy.fft import fft, fftfreq

def sine_wave(freq, dur, sampling_rate, phase = 0, amplitude=1):
    t = np.linspace(0, dur, int(sampling_rate * dur), endpoint=False)
    return amplitude * np.sin((2 * np.pi * freq * t) + phase)

dur = 4
sampling_rate = 1/0.001 # 1 ms sampling rate

s1 = sine_wave(2, dur, sampling_rate)
s2 = sine_wave(8, dur, sampling_rate, phase=np.pi/2, amplitude=0.5)
s3 = sine_wave(12, dur, sampling_rate, phase=np.pi/4, amplitude=0.25)
s4 = sine_wave(25, dur, sampling_rate, phase=np.pi/3, amplitude=0.1)

mixed = s1 + s2 + s3 + s4

# 5x1 subplot grid
fig, axs = plt.subplots(5, 1, figsize=(10, 10), sharex=True)
axs[0].plot(s1, color='blue')
axs[0].set_title('Sine Wave - 2 Hz')
axs[1].plot(s2, color='orange')
axs[1].set_title('Sine Wave - 8 Hz')
axs[2].plot(s3, color='green')
axs[2].set_title('Sine Wave - 12 Hz')
axs[3].plot(s4, color='red')
axs[3].set_title('Sine Wave - 25 Hz')
axs[4].plot(mixed, color='purple')
axs[4].set_title('Mixed Signal (2 + 8 + 12 + 25 Hz)')
axs[4].set_xlabel('Time (ms)')
plt.tight_layout()
plt.savefig("sine_waves_plot.png", dpi=300)
plt.show()

# Fourier Transform of the Mixed Signal
N = len(mixed)
sampling_interval = 0.001  # 1 ms
yf_mixed = fft(mixed)
xf_mixed = fftfreq(N, sampling_interval)

plt.figure(figsize=(10, 5))
plt.plot(xf_mixed[:N//2], np.abs(yf_mixed)[:N//2], color='purple')
plt.title('Fourier Transform of Mixed Signal')
plt.xlabel('Frequency (Hz)')
plt.ylabel('Amplitude')
plt.grid()
plt.xlim(0, 30)
plt.savefig("fourier_transform_mixed_signal.png", dpi=300)
plt.show()
