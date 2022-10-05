%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function for the output of trial data      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This function does some ugly data transforming. It works but isn't replicatable for other scenarios.
% Furthermore the variable naming leaves a lot to be desired. 
% It outputs the following information:

% SOAs - the array of Stimulus Onset Asynchronies (in milliseconds)
% result - the array of responess from the participant
% SOA_unique -  a short array listing the unique SOAs for each block of trials
% info - a struct with the responses * the SOAs, also transformed into means and percentages
% bin - information about how the data can be binned 

function [SOAs,result,SOA_unique,info,bin] = trial_output(data,control,uncued,threshold)

% get the SOAs and accuracy of the trials in question (normal data,
% control, or uncued)
if isempty(control) && isempty(uncued)
    x = [data(:,14) data(:,5)];
    main = 1;
elseif isempty(uncued)
    x = [data(:,8),data(:,5)];
else
    x = [data(data(:,6) ~= (data(:,18) & data(:,6) ~= (data(:,19))),:)];
    x = [x(:,16) x(:,7)];
end

SOAs = round(x(:,1),3); % the trials SOA
result = x(:,2); % response
if main == 0
    SOA_unique = unique(SOAs);
else
    SOA_unique = [0;threshold;0.050];
    for i = 1:length(SOAs)
        if SOAs(i) < 0.003
            SOAs(i) = 0;
        elseif SOAs(i) > 0.003 && SOAs(i) < 0.045
            SOAs(i) = threshold;
        else
            SOAs(i) = 0.050;
        end
    end
end



info.nCorrect = zeros(1,length(SOA_unique));% number of correct trials per SOA
info.nTrials = zeros(1,length(SOA_unique));% number of trials at each SOA

% fills in the nCorrect and nTrials data based on the SOA and result data
for i = 1:length(SOA_unique)
    id = (SOAs == SOA_unique(i)) & ~isnan(result);
    info.nTrials(i) = sum(id);
    info.nCorrect(i) = sum(result(id));
end

% calculates the percentage correct
info.pCorrect = info.nCorrect./info.nTrials;

info.pCorrect = info.pCorrect';
info.nCorrect = info.nCorrect';
info.nTrials = info.nTrials';


% the percentage correct with the SOAs
info.pCorrect_data = [info.pCorrect,SOA_unique];

info.data_raw = [SOA_unique,info.nCorrect,info.nTrials];

% creating bins - set at the end of histcounts(SOA,bins)
if main == 0
    [N,edges,bins] = histcounts(SOA_unique,ceil(sqrt(length(SOA_unique))));
else
    N = length(SOA_unique);
    edges = SOA_unique';
    bins = 1:length(SOA_unique);
end


% generating the means of each bin
for n = 1:max(bins)
    bin.means(:,n) = sum(info.nCorrect(bins==n,:));
    bin.total(:,n) = sum(info.nTrials(bins==n,:));
end

for n = 1:max(bins)
    bin.correct(:,n) = mean(info.pCorrect(bins ==n,:));
end

bin.edges = edges;

if main == 0
    info.data_bin = [edges(1:end-1);bin.correct;bin.total]';
else
    info.data_bin = [edges;bin.correct;bin.total]';
end

end
