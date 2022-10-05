% PSS value from experiment 1

% function to classify the threshold for the MAIN experiment utilising the PSS threshold score.
% We will utilise the trial_output function (see Help Function repo) to generate plottable outputs
% as psychometric functions to see if participants have maintained the correct threshold.
% This will then be stored in the "threshold" variable which is later passed to the output struct.

function MAINthreshold = MAINthreshold(data,thresholdPSS)
addpath('D:\new_experiment\helperFunctions');
addpath('C:\toolbox\psignifit-master');

[SOAs,result_uncued,SOA_unique,info,bin] = trial_output(data,[],[],thresholdPSS);

result.raw.control = psychofunc(info.data_raw);
plotPsych(result.raw.control);

result.bin.control = psychofunc(info.data_bin);
plotPsych(result.bin.control);

[threshold,CI] = getThreshold(result.raw.control,0.5,1);

MAINthreshold = threshold;
