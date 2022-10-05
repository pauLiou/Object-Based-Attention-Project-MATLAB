%participantInfo

   

% Matrices that define the arrowcue location and the location of the two
% probes
if(~loadVars)
    
    % Calculate the jitter
    jitter = [0.800:0.1:1.200]';
    exp.jitterPrep = Shuffle((repmat(jitter,ceil(numberoftrials/length(jitter)),numberofblocks)));
    
    % full factorial design with cue (low interference,high interference,
    % no interference), SOA (0,PSS,60), and object (first same, first diff,
    % second same, second diff)
    exp.trialMatrix = fullfact([3 3 4]);exp.trialMatrix = Shuffle(repmat(exp.trialMatrix,2,1),2);
    % Matrix to decide the SOA between probes for each trial (depends on number
    % of blocks and trials
    %exp.timeSOA = Shuffle(repmat(timeSOA,ceil(numberoftrials/length(timeSOA)),numberofblocks));
    exp.timeSOA = timeSOA(exp.trialMatrix(:,2));
    
    % create the probe positions using factorial function - then remove the
    % rows where they appear at the same location and the shuffle it
    exp.bothProbe = fullfact([4,4]); exp.bothProbe(any(diff(sort(exp.bothProbe,2),[],2)==0,2),:)=[];
    exp.bothProbe = Shuffle(repmat(exp.bothProbe,ceil(numberoftrials/length(exp.bothProbe)),1),2);
   
    % Create an output file that contains participant resposes, total trials
    % completed, and eye-calibration information - this will be saved as a .mat
    % file at the end of the experiment
    output.currentblock = 1;
    output.currenttrial = 1;
    output.responses = zeros(numberoftrials*numberofblocks,24);
    output.eyeCalibration = [];
end
