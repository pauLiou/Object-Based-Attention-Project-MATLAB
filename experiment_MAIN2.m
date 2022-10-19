%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Experiment 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
FlushEvents()
cd('D:\Project_2\experiment');
addpath('C:/toolbox/');
addpath('C:/toolbox/Psychtoolbox/');
addpath(genpath('D:/Project_2/mQuestPlus-master/'));
sca;
close all;
clearvars;

% TODO
% 1. confirm conditions + number of trials
% 2. confirm SOAs
% 3. add in user entry functionality
% 4. add in save/load functionality
% 5. confirm we have every output that we need
% 6. check the eyetracker idf file that its recording properly

% Default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
% Add helper functions folder to the workspace
addpath('helperFunctions/');
addpath('iViewFunctions/');
addpath('experimentSetup/');

% Add iView functions folder (all functions related to the Eye Tracker) to
% the workspace

% Loading in variables
loadVars = false;

% Eyetracker attached or not
eyetracker = false;

% If Staircase is turned on or not
QUEST = true;

% Load the information important for the keyboard inputs
keyboardInfo;

% Load participant specific data, includes the trial sequence and requires
% participants input
participantInfo;


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Eyetracker setup

% Load the iViewX API library and connect to the server (in separate File)
if(eyetracker)
%    restoreBeginning;
    InitAndConnectiViewXAPI;
else
    iView = [];
    pSampleData = [];
end


% Create a subfolder for eye tracker data if turned on
if(eyetracker)
    eyeTrackerFolder = [ pwd '\eyeTrackerData\Participant_' num2str(exp.VPN)];
    mkdir(eyeTrackerFolder);
end

% Run the eye tracker calibration if it is connected
calibrationInfo;
workspace; 

cd('D:\Project_2\experiment');

% Runs the helper file that gives the screen information directly
screenInfo;

% audio setup
audioInfo;

% QUEST PDF INPUT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experiment

Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

for block = output.currentblock:numberofblocks
    DisableKeysForKbCheck(setdiff(1:256,[37,39,32,27,80]));
    % If this is the first trial we present the start screens and instructions
    % and wait for key-presses
    if block == 1
        DrawFormattedText(w, '\n Welcome to the Experiment',...
            'center', 'center', white);
        Screen('Flip',w);
        KbStrokeWait;

        DrawFormattedText(w, '\n Press Any Key To Begin...',...
            'center', 'center', white);
        Screen('Flip',w);
        KbStrokeWait;
        
    end
    
    % Start eyetracker recording for this block
    % Clear eyetracker buffer and start recording
    if(eyetracker)
        if(loadVars)
            startEyetrackerRecording(eyetracker,iView,loadVars);
        else
            startEyetrackerRecording(eyetracker,iView);
        end
    end
    
    for trialnr = output.currenttrial:numberoftrials
       
    
        % Trial setup
        if trialRec(trialnr) == 0
            rectangle = allRectsVert;
            rec1 = [1,2];
            rec2 = [3,4];
        else
            rectangle = allRects;
            rec1 = [2,3];
            rec2 = [1,4];
        end
        
        movementTarget = exp.trialMatrix(trialnr,3); % set the movement target to the matrix location
        
        targetLoc = inObject(exp.trialMatrix,movementTarget,trialnr,rec1,rec2); % adjusts whether appears in box or not     
        
        % fixationCheck while loop below determines that:
        % A: Participant is fixated for at least the length of 1 second.
        % B: Eyes are actually on the fixation cross for this time
        startTime = GetSecs;
        fixationTime = fixationCheck(pause_key,block,trialnr,eyetracker,iView,w,textColor,allCoords,lineWidthPix,...
                                    circleXCenter,xCenter,yCenter,defaultStimulus,alltargetLoc,...
                                    threshold_radius,pSampleData,exp,allColors,rectangle,startTime,ifi);
                                
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        for i = 1:round(1/0.02)
            % This draws the arrow cue
            Screen('DrawTexture',w,arrowCue,[],[circleXCenter-12, yCenter-12,circleXCenter+12,yCenter+12],cueAngle(movementTarget,1),2,2);
            % This draws the rectangles
            Screen('FrameRect',w, allColors, rectangle, 6);
            % This draws the four template locations
            for a = 1:4
                Screen('DrawTexture',w,defaultStimulus,[],alltargetLoc{a,1}, 0, 0);
            end
            
            Screen('Flip',w);
        end
        myWait((exp.arrow/1.72)-ifi); %1.72 found with trial/error
        arrowTime = GetSecs;
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
        myWait(0.15);
        audioTime = GetSecs;
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        % This draws the arrow cue
        Screen('DrawTexture',w,arrowCue,[],[circleXCenter-12, yCenter-12,circleXCenter+12,yCenter+12],cueAngle(movementTarget,1),2,2);
        % This draws the rectangles
        Screen('FrameRect',w, allColors, rectangle, 6);

        % This draws the 3 template locations
        for a = find(positionChoices ~= targetLoc)
            distractor = distractorOptions(randi([1,2]));
            Screen('DrawTexture',w,distractor,[],alltargetLoc{a,1}, 0, 0);
        end
        
        % This draws the target stimulus at the target location
        target = targetOptions(randi([1,2]));
        Screen('DrawTexture',w,target,[],alltargetLoc{targetLoc,1},0,0);
        
        Screen('Flip',w);

        

        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        % This draws the arrow cue
        Screen('DrawTexture',w,arrowCue,[],[circleXCenter-12, yCenter-12,circleXCenter+12,yCenter+12],cueAngle(movementTarget,1),2,2);
        % This draws the rectangles
        Screen('FrameRect',w, allColors, rectangle, 6);
        % This draws the four template locations
        for a = 1:4
            Screen('DrawTexture',w,defaultStimulus,[],alltargetLoc{a,1}, 0, 0);
        end
        
        %myWait(exp.SOA(exp.trialMatrix(trialnr,2))-0.0015);
        myWait(targ/1000-0.0013);
        

        Screen('Flip',w);
        targetTime = GetSecs;
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Trial Data
        
        [secs,keyCode] = KbWait;
        response_time = GetSecs;
        PsychPortAudio('Stop', pahandle); % reset audio

        response = find(find(keyCode == 1) == [leftKey,rightKey]);
        
        targetStyle = find(target == [targetStimulus,targetStimulus_2]);


        output.responses((block-1)*numberoftrials+trialnr,1) = block; % Current block
        output.responses((block-1)*numberoftrials+trialnr,2) = trialnr; % Current trial
        output.responses((block-1)*numberoftrials+trialnr,3) = response_time-targetTime; % Reaction time of response
        output.responses((block-1)*numberoftrials+trialnr,4) = response; % left = 1, right  = 2;
        output.responses((block-1)*numberoftrials+trialnr,5) = exp.trialMatrix(trialnr,1); % inside/outside object (inside = 1, outside = 2)
        output.responses((block-1)*numberoftrials+trialnr,6) = targ;%exp.trialMatrix(trialnr,2); % SOA (150ms,200ms)
        output.responses((block-1)*numberoftrials+trialnr,7) = exp.trialMatrix(trialnr,3); % Arrow cue location
        output.responses((block-1)*numberoftrials+trialnr,8) = exp.trialMatrix(trialnr,4); % 1 = Cue at target
        output.responses((block-1)*numberoftrials+trialnr,9) = targetLoc; % location of the target
        output.responses((block-1)*numberoftrials+trialnr,10) = targetStyle; % 3 = 1, E = 2
        output.responses((block-1)*numberoftrials+trialnr,11) = response == targetStyle; % correct = 1
        output.responses((block-1)*numberoftrials+trialnr,12) = exp.fixation; % expected fixation
        output.responses((block-1)*numberoftrials+trialnr,13) = fixationTime-startTime; % recorded fixation
        output.responses((block-1)*numberoftrials+trialnr,14) = exp.arrow; % expected arrow time
        output.responses((block-1)*numberoftrials+trialnr,15) = arrowTime-fixationTime; % recorded arrow time
        output.responses((block-1)*numberoftrials+trialnr,16) = targ/1000;%exp.SOA(exp.trialMatrix(trialnr,2)); % expected SOA
        output.responses((block-1)*numberoftrials+trialnr,17) = targetTime-audioTime; % recorded SOA
        output.responses((block-1)*numberoftrials+trialnr,18) = exp.fixation - (fixationTime-startTime); % fixation diff
        output.responses((block-1)*numberoftrials+trialnr,19) = exp.arrow - (arrowTime-fixationTime); % arrow diff
        output.responses((block-1)*numberoftrials+trialnr,20) = (targetTime-audioTime) - targ/1000; % SOA diff
        % Screen mask
        
       
        % This draws the fixation cross
        Screen('DrawLines', w, allCoords, lineWidthPix, textColor, [circleXCenter yCenter], 2);
        Screen('Flip',w);
        myWait(0.5);
        
        % QUEST PDF UPDATE
                
        output.currenttrial = output.currenttrial + 1;
    end
       
    
    %stops the eyetracker recording
    if(eyetracker)
        stopEyetrackerRecording(eyetracker,iView,block,exp.VPN,eyeTrackerFolder);
    end

    
    %prep for next block
    exp.trialMatrix = Shuffle(exp.trialMatrix,2);
    output.currentblock = output.currentblock + 1;
    output.currenttrial = 1;
    
end

clear acc info protofile Smp pAccuracyData pCalibrationData pEventData pSampleData pSystemInfoData
if(eyetracker)
    %Unload the iViewX API library and disconnect from the server
    UnloadiViewXAPI;
end

output.responses = output.responses(any(output.responses,2),:); % remove all empty rows


sca;

