% PSS value from experiment 1

function PSSthreshold = PSSthreshold(control)
addpath('D:\new_experiment\helperFunctions');
addpath('C:\toolbox\psignifit-master');

[SOAs,result_uncued,SOA_unique,info] = trial_outputproject2(control,1,[]);

result.raw.control = psychofunc(info.data_raw);
plotPsych(result.raw.control);

[threshold,CI] = getThreshold(result.raw.control,0.5,1);

PSSthreshold = threshold;