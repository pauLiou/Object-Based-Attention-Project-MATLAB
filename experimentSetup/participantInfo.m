% Trial Information for Participant

% Trial matrix (inObject/outObject/cued/uncued)
exp.trialMatrix = fullfact([4 4 4]);exp.trialMatrix = Shuffle(exp.trialMatrix,2);
exp.fixation = 1; % length of fixation cross
exp.arrow = 0.5; % length of arrow cue
exp.SOA = [40:40:160];exp.SOA = repmat(exp.SOA,1,length(exp.trialMatrix)/length(exp.SOA));exp.SOA = Shuffle(exp.SOA,2); % different speeds of target/distractors
positionChoices = [1 2 3 4];


fixated = 0; % will change in practice trial if fixation is not met

% create a variable with number of trials that randomly assigns a value
% with 50% probability

numberOfOnes = round(numberoftrials/2);% Total length must be even to have even # of 0s and 1s.
indexes = randperm(numberoftrials);
trialRec = zeros(1, numberoftrials);
trialRec(indexes(1:numberOfOnes)) = 1;

clear n numberOfOnes indexes

output.currentblock = 1;
output.currenttrial = 1;
output.responses = zeros(numberoftrials*numberofblocks,24);
output.eyeCalibration = [];

threshold_radius = 2;