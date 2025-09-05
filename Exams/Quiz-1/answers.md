# Quiz - 1

Name: Modumudi Naga Sai Ritvik
Roll No.: 2022111034

## Question - 1

1. Since Arjun is interested in a specific frequency band only, not on the spacial information, he can use an EEG setup with low spacial resolution. So 32 channels would suffice, and will be cost effective. <span style="color: red;">*Have to think more, keeping in mind the interests of the institute. (64 could be of use for the institute in future)*</span> 

2. The general rule of thumb is sampling rate must be around 20 times the frequency of interest. So here the highest frequency of interest is 7Hz. So sampleing rate should be above 140Hz. So, 512Hz would be a safer option but will be an overkill. He could go with 128Hz but there will be some loss of info in reconstruction. <span style="color: red;">*512Hz would be most useful if we think about interests of the institute too*</span>

3. Since the visual stimuli is rapid, there can be blink artifacts. So letting the subjects adapting to the environments by doing a few dummy trials would help. Also due to rapid visual stimuli, the response time of the subjects must be fast and must be within the desired 500ms window. So he needs to ensure that. <span style="color: red;">*Assumed only software consideration, equipment includes chin holder, electrically shielded room etc*</span>

<span style="color: red;">Total for this question: 2.5/5</span>

## Question - 2

1. The general rule of thumb is 50 trials per condition per subject. If SNR is high, we have to have more trials per condition per subject. <span style="color: red;">*Need to think about trial rejection too in data cleaning, so 50 clean trials meaning around 60-70 trials etc*</span>

2. There is no fixed number for this, around 30 per condition would suffice. <span style="color: red;">*Need to think about trial rejection too in data cleaning, so 30 clean subjects meaning around 40-45 subjects etc*</span>

3. The buffer must be 3 cycles of lowest frequency. Tht means if we are interested in 4-7Hz band, we need ot have a buffer of 0.75 sec. So the baseline must be more than 0.75sec. It is good to have around 1.25/1.5 sec of baseline. The task period must also be more than 0.75sec long, again to have enough data we can have around 2.5sec <span style="color: red;">*Completely wrong, seperate experiment. Need to think about prediction, how baseline is taken in that situation, and finally include filter buffers, need to assume.*</span>

4. Early - Raw EEG data per channel with event markers (to see if all channels are fine), Middle - Epoched data with baseline and task periods marked. Late - ICA to remove artifacts like blink and muscle movements. <span style="color: red;">*Preprocessing and analysis - meaning we have to consider the whole analysis. I have considered only the preprocessing.*</span>
<span style="color: red;">Total for this question: 1.5/4</span>


## Question - 3
1. Blink/Muscle Movement Artifacts (Happens when a subject blinks/moves a muscle, also called EMG artifacts) - Can be removed it using ICA (independent Component Analysis), or making the subject get used to the setup before hand.

2. Edge Artifacts - (Happens when filter is apllied) - The best method is to use filter before epoching, if we have only epoched data available, we can reflect it and have buffers at the end to account for the edge artifacts. <span style="color: red;">*Not an artifact of EEG recording*</span>

3. Cognitive/Behavorial Artifacts - (Happens when someone misses a response or makes a mistake) - These has to be corrected during the recording itself, lik making the subject comfortable, showing them the real time EEG data etc

<span style="color: red;">*Line noise is one artifact*</span>
<span style="color: red;">Total for this question: 2/3</span>


## Question - 4

This might be becuase of Edge artifacts. When we filter a signal, we find high power at the edges i.e. at the start and at the end. So the baseline would be effected due to the introduction of these artifacts. In order to deal with these, we have various methods. If we have continuous data available, we have to filter first and then epoch. If we have only epoched data, we need to have sufficient buffers (3 cycles of lowest frequency). We can use reflection method also to introduce buffers. Since we are interested in lower frequencies (delta), the time period of filter buffer must be high (1.5 sec), hence we need to have longer baselines and buffers. <span style="color: red;">*If this happens, then the power difference must decrease, not increase.*</span>

<span style="color: red;">Total for this question: 3/4</span>


## Question - 5

a. My initial observation is there is a sustained high power activity at around 10Hz, from around 0.5 seconds of the delay period till the read-out period.

b. We can conclude the following:

- This basically shows that working memory is engaged continuosly during the task.
- However, it is mentioned that this plot is the result of average across trials and electrodes. So, there could be a possibility that this high power smear is actually an artifact.

These observation at the surface support the theory, but again averaging can introduce artifacts and this could be the result of such artifact. SO I feel that these observations alone are inconclusive. Because of delay in visual response of subjects, there could be a difference in the onset of activites. Avaeraging all these time locked but not phase locked signals shows us there is a sustained activity where in reality there need not be. Per trial analyis will provide the conclusive evidence to support or disprove the hypothesis.

<span style="color: red;">Total for this question: 4/4</span>


<span style="color: red;"> Overall Total: 13/20 </span>




## Thoughts

1. For the first two questions - I did not think about all the parties involved, and also did not correctly map what the experiment being done, to the needs of both the individual and the institute. Also, need to carefully breakdown the question, which I missed. Need a bit more practical knowledge - working on the project could help.

2. For the question 3 - Again need to read and understand the question more. The question was about EEG recording, Edge artifacts occur only in preprocessing. 

3. For q4 - Should have thought about the effect of edge artifacts more thoroughly. Missed clarity in concept. Need ot refer to textbook and slides more thouroughly.