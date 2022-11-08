%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Experiment 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% restoreBeginning;
clear;
FlushEvents();
%DisableKeysForKbCheck();
cd('H:\Project 2\2-DataAcquisition\experiment');
addpath('C:\toolbox\');
addpath('C:\toolbox\Psychtoolbox\');
addpath(genpath('H:\Project 2\2-DataAcquisition\ExperimentalScripts\mQUESTPlus-master'));
addpath('H:\Project 2\2-DataAcquisition\experiment\participantThreshold');
sca;
close all;
clearvars;


% TODO
% Add end of experiment window for practice
% Add practice for saccade task (circle vs no circle)
% Add feedback to practice?

% Default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
% Add helper functions folder to the workspace
addpath('helperFunctions/');
addpath('iViewFunctions/');
addpath('experimentSetup/');

% Add iView functions folder (all functions related to the Eye Tracker) to
% the workspace
targ2 = 1;
% Eyetracker attached or not
eyetracker = false;


[exp,numberoftrials,numberofblocks,QUEST,eyetracker] = userInput;

% Loading in variables
loadVars = false;

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

cd('H:\Project 2\2-DataAcquisition\experiment');

% Runs the helper file that gives the screen information directly
screenInfo;

% audio setup
audioInfo;

% QUEST PDF INPUT
% if(QUEST)
%     questData.ISI = qpInitialize('stimParamsDomainList',{10:2:160}, ...
%     'psiParamsDomainList',{10:2:160,3.5, 0.5, 0.02},'qpPF',@qpPFWeibull,verbose=true);
%     targ = 100;
%     questData.cueTime = qpInitialize('stimParamsDomainList',{200:200:1600}, ...
%     'psiParamsDomainList',{200:200:1600,3.5,0.5,0.02},'qpPF',@qpPFWeibull,verbose=true);
% else
%     if exp.practice == 'y'
%         targ = 100;
%         cueTime = 500;
%     else
%         targ = load(['participant_' num2str(exp.VPN) '.mat']);
%         targ = targ.exp.questthreshold;
%         exp.date = datestr(now);
%         cueTime = load(['participant_' num2str(exp.VPN) '.mat']);
%         cueTime = cueTime.exp.questthreshold;
%     end
% 
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experiment

cueTime = 500;

for block = output.currentblock:numberofblocks
    DisableKeysForKbCheck(setdiff(1:256,[37,39,32,27,80]));
    % If this is the first trial we present the start screens and instructions
    % and wait for key-presses
    if block == 1
        DrawFormattedText(w, '\n Welcome to the Experiment',...
            'center', 'center', white);
        Screen('Flip',w);
        KbStrokeWait;

        if(exp.practice == 'y')
            Screen('DrawTexture',w,instructions1);
            Screen('Flip',w);
            KbStrokeWait;
            Screen('DrawTexture',w,instructions2);
            Screen('Flip',w);
            KbStrokeWait;
            Screen('DrawTexture',w,instructions3);
            Screen('Flip',w);
            KbStrokeWait;
        end
    elseif block == 2
        if(exp.practice == 'y')
            Screen('DrawTexture',w,instructions4);
            Screen('Flip',w);
            myWait(0.5);
            KbStrokeWait;
        end
    elseif block == 3
        if(exp.practice == 'y')
            Screen('DrawTexture',w,instructions5);
            Screen('Flip',w);
            myWait(0.5);
            KbStrokeWait;
        end
    end

    Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    
    Screen('TextSize',w, 24);
    blocktext = ['Block: [', num2str(block), '] Press Any Key to Begin...'];
    DrawFormattedText(w, blocktext,'center', 'center', white);
    Screen('Flip',w);
    KbStrokeWait;



    
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
        
        if(QUEST)
            if exp.practice == 'n'
                iView.iV_SendImageMessage(['Block:' num2str(block) '-Trial:' num2str(trialnr) '.jpg']);
                targ = qpQuery(questData.ISI);
                cueTime = qpQuery(questData.cueTime);
            else
                targ = exp.SOA(trialnr);
                cueTime = 500;
            end
        elseif(exp.practice == 'y' && block == 2)
                Screen('TextSize',w, 24);
                if(saccadeTime > .5 && fixated == 1)
                    blocktext = ['Please try to make your eye movement quicker!'];
                    DrawFormattedText(w, blocktext,'center', 'center', white);
                    Screen('Flip',w);
                    KbStrokeWait;        
                elseif(fixated == 0)
                    blocktext = ['Please make your eye movement after the beep!'];
                    DrawFormattedText(w, blocktext,'center', 'center', white);
                    Screen('Flip',w);
                    KbStrokeWait;        
                end
         
        end


        % Trial setup
        rec1 = [2,3];
        rec2 = [1,4];
        rectangle = allRects;
        if trialRec(trialnr) == 0
            topColors = [0 0 255];
            bottomColors = [255 0 0];
        else
            topColors = [255 0 0];
            bottomColors = [0 0 255];
        end

        if exp.trialMatrix(trialnr,3) ~= 1
            saccade = true;
        else
            saccade = false;
        end
        
        movementTarget = exp.trialMatrix(trialnr,1); % set the movement target to the matrix location
        saccadeTime = 0;
        if exp.practice == 'y' && block == 1
            saccade = false;
        elseif exp.practice == 'y' && block == 2
            saccade = true;
        end
        targetLoc = inObject(exp.trialMatrix,movementTarget,trialnr,rec1,rec2,trialRec(trialnr)); % adjusts whether appears in box or not     
        
        % fixationCheck while loop below determines that:
        % A: Participant is fixated for at least the length of 1 second.
        % B: Eyes are actually on the fixation cross for this time
        startTime = GetSecs;
        fixationTime = fixationCheck(pause_key,block,trialnr,eyetracker,iView,w,textColor,allCoords,lineWidthPix,...
                                    circleXCenter,xCenter,yCenter,defaultStimulus,alltargetLoc,...
                                    threshold_radius,pSampleData,exp,topColors,bottomColors,rectangle,startTime,ifi,exp.practice,saccade,QUEST,rect1);
                                
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        % This draws the arrow cue
        Screen('DrawTexture',w,arrowCue,[],[circleXCenter-15, yCenter-15,circleXCenter+15,yCenter+15],cueAngle(movementTarget,1),2,2);
        % This draws the rectangles
        if(exp.practice == 'n' )%&& ~QUEST)
            %Screen('FrameRect',w, topColors, rectangle(:,1), 6);
            %Screen('FrameRect',w, bottomColors, rectangle(:,2), 6);
            Screen('DrawTextures', w, rect1, [], rectangle(:,1));
            Screen('DrawTextures', w, rect1, [], rectangle(:,2));
        end
        % This draws the four template locations
        %             for a = 1:4
        %                 Screen('DrawTexture',w,defaultStimulus,[],alltargetLoc{a,1}, 0, 0);
        %             end
        if(saccade && ~QUEST)
            if exp.practice == 'y' && block == 2
                Screen('FrameOval', w ,allColors,baseRect,3);
            elseif exp.practice == 'y' && block == 1
                % don't include the oval
            else
                Screen('FrameOval', w ,allColors,baseRect,3);
            end
        end
        Screen('Flip',w);
        
        myWait(cueTime/1000); %1.72 found with trial/error
        arrowTime = GetSecs;
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        if(saccade && ~QUEST)
            if exp.practice == 'y'
                if block == 1
                    ignore = 1;
                else
                    PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
                    beepTime = GetSecs;
                end
            else
                PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
                beepTime = GetSecs;
            end
        end
        if(exp.practice == 'y' && block == 2)
            [saccadeTime,fixated] = recordEyes(allTargetX,movementTarget,threshold_radius,pSampleData,iView,xCenter,yCenter);
        end

        myWait(0.1);
        if ~(exp.practice == 'y' && block == 2)
            beepTime = GetSecs;
        end

        % This draws the arrow cue
        if(exp.practice == 'y' && block == 2)
            Screen('DrawTexture',w,arrowCue,[],[circleXCenter-15, yCenter-15,circleXCenter+15,yCenter+15],cueAngle(movementTarget,1),2,2);
            % This draws the four template locations
%             for a = 1:4
%                 Screen('DrawTexture',w,defaultStimulus,[],alltargetLoc{a,1}, 0, 0);
%             end
            Screen('FrameOval', w ,allColors,baseRect,3); % include the oval
            Screen('Flip',w);
            myWait(0.5);
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        elseif ~(exp.practice == 'y' && block == 2)
            % This draws the arrow cue
            Screen('DrawTexture',w,arrowCue,[],[circleXCenter-15, yCenter-15,circleXCenter+15,yCenter+15],cueAngle(movementTarget,1),2,2);
            % This draws the rectangles
            if(exp.practice == 'n')% && ~QUEST)
                %Screen('FrameRect',w, topColors, rectangle(:,1), 6);
                %Screen('FrameRect',w, bottomColors, rectangle(:,2), 6);
                Screen('DrawTextures', w, rect1, [], rectangle(:,1));
                Screen('DrawTextures', w, rect1, [], rectangle(:,2));
            end

            % This draws the 3 template locations
            for a = find(positionChoices ~= targetLoc)
                distractor = distractorOptions(randi([1,2]));
                Screen('DrawTexture',w,distractor,[],alltargetLoc{a,1}, 0, 0);
            end
            if(saccade && ~QUEST)
                Screen('FrameOval', w ,allColors,baseRect,3);
            end

            % This draws the target stimulus at the target location
            target = targetOptions(randi([1,2]));
            Screen('DrawTexture',w,target,[],alltargetLoc{targetLoc,1},0,0);

            Screen('Flip',w);

            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

            % This draws the arrow cue
            Screen('DrawTexture',w,arrowCue,[],[circleXCenter-15, yCenter-15,circleXCenter+15,yCenter+15],cueAngle(movementTarget,1),2,2);
            % This draws the rectangles
            if(exp.practice == 'n')% && ~QUEST)
                %Screen('FrameRect',w, topColors, rectangle(:,1), 6);
                %Screen('FrameRect',w, bottomColors, rectangle(:,2), 6);
                Screen('DrawTextures', w, rect1, [], rectangle(:,1));
                Screen('DrawTextures', w, rect1, [], rectangle(:,2));
            end
            % This draws the four template locations
%             for a = 1:4
%                 Screen('DrawTexture',w,defaultStimulus,[],alltargetLoc{a,1}, 0, 0);
%             end

            if(saccade && ~QUEST)
                Screen('FrameOval', w ,allColors,baseRect,3); % draw the oval
            end

            %myWait(targ/1000-0.0013);
            KbWait;
            Screen('Flip',w);
            targetTime = GetSecs;
            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            % Trial Data

            [secs,keyCode] = KbWait;
        end
            response_time = GetSecs;
        
        if(saccade)
            PsychPortAudio('Stop', pahandle); % reset audio
        end
        

        response = find(find(keyCode == 1) == [leftKey,rightKey]);
        
        targetStyle = find(target == [targetStimulus,targetStimulus_2]);


        output.responses((block-1)*numberoftrials+trialnr,1) = block; % Current block
        output.responses((block-1)*numberoftrials+trialnr,2) = trialnr; % Current trial
        output.responses((block-1)*numberoftrials+trialnr,3) = response_time-targetTime; % Reaction time of response
        output.responses((block-1)*numberoftrials+trialnr,4) = response; % left = 1, right  = 2;
        output.responses((block-1)*numberoftrials+trialnr,5) = saccade;
        output.responses((block-1)*numberoftrials+trialnr,6) = trialRec(trialnr); % vertical/horizontal rectangles (1 = horizontal)
        output.responses((block-1)*numberoftrials+trialnr,7) = targ;%exp.trialMatrix(trialnr,2); % SOA (150ms,200ms)
        output.responses((block-1)*numberoftrials+trialnr,8) = movementTarget; % Arrow cue location
        output.responses((block-1)*numberoftrials+trialnr,9) = exp.trialMatrix(trialnr,2); % 1 = Cue at target, 2 = cue at same box as target, etc
        output.responses((block-1)*numberoftrials+trialnr,10) = targetLoc; % location of the target
        output.responses((block-1)*numberoftrials+trialnr,11) = targetStyle; % 3 = 1, E = 2
        output.responses((block-1)*numberoftrials+trialnr,12) = response == targetStyle; % correct = 1
        output.responses((block-1)*numberoftrials+trialnr,13) = exp.fixation; % expected fixation
        output.responses((block-1)*numberoftrials+trialnr,14) = fixationTime-startTime; % recorded fixation
        output.responses((block-1)*numberoftrials+trialnr,15) = cueTime;%exp.arrow; % expected arrow time
        output.responses((block-1)*numberoftrials+trialnr,16) = arrowTime-fixationTime; % recorded arrow time
        output.responses((block-1)*numberoftrials+trialnr,17) = targ/1000; % expected SOA
        output.responses((block-1)*numberoftrials+trialnr,18) = targetTime-beepTime; % recorded SOA
        output.responses((block-1)*numberoftrials+trialnr,19) = exp.fixation - (fixationTime-startTime); % fixation diff
        output.responses((block-1)*numberoftrials+trialnr,20) = exp.arrow - (arrowTime-fixationTime); % arrow diff
        output.responses((block-1)*numberoftrials+trialnr,21) = (targetTime-beepTime) - targ/1000; % SOA diff
        output.responses((block-1)*numberoftrials+trialnr,22) = (beepTime-arrowTime); % time of the audio device
        output.responses((block-1)*numberoftrials+trialnr,23) = saccadeTime; % speed of the saccade on practice trials
        
        % Screen mask
        
       
        % This draws the fixation cross
        Screen('DrawLines', w, allCoords, lineWidthPix, textColor, [circleXCenter yCenter], 2);
        Screen('Flip',w);
        myWait(1);
        
        % QUEST PDF UPDATE
        
        if(QUEST)
            if response == targetStyle
                outcome = 2;
            elseif response ~= targetStyle
                outcome = 1;
            end
            
                
            if exp.practice == 'n'
                if(saccade)
                    questData.ISI = qpUpdate(questData.ISI,targ,outcome);
                    targ2 = qpQuery(questData.ISI);
                    if exp.trialMatrix(trialnr,2) == 3 % if its a critical trial
                        questData.cueTime = qpUpdate(questData.cueTime,cueTime,outcome);
                    end
                end
            end
        end
              
        output.currenttrial = output.currenttrial + 1;


        % quest output stuff
        if(QUEST) && output.currenttrial > max(numberoftrials) && exp.practice == 'n'

            exp.psychthreshold = PSSthreshold(output.responses);

            % perform the quest analysis stuff
            questData.ISI.psiParamsIndex = qpListMaxArg(questData.ISI.posterior);exp.questthreshold = questData.ISI.psiParamsDomain(questData.ISI.psiParamsIndex,1);
            weibullQuestPlus(questData.ISI);
            saveas(gcf,'currentQuestthreshold.png'); % save the quest weibull output figure
            myimgfile = ['currentQuestthreshold.png']; % turn output figure into image

            imdata=imread(myimgfile);
            imagetex=Screen('MakeTexture', w, imdata); % create texture from image
            for i = 1:10
                DrawFormattedText(w, processing{(mod(i,4))+1},...
                    'center', 'center', white);
                Screen('Flip',w)
                myWait(0.2)
            end

            Screen('DrawTexture', w, imagetex); % print image inside experiment
            DrawFormattedText(w, ['QUEST threshold: ' num2str(exp.questthreshold) 'msecs'],...
                'center', yCenter + (yCenter/1.5), white);
            DrawFormattedText(w, ['Psignifit threshold: ' num2str(exp.psychthreshold) 'msecs'],...
                'center', yCenter + (yCenter/1.4), white);
            Screen('Flip',w);
            KbStrokeWait;
            questData.cueTime.psiParamsIndex = qpListMaxArg(questData.cueTime.posterior);exp.questthreshold = questData.cueTime.psiParamsDomain(questData.cueTime.psiParamsIndex,1);

        end
    end
       
    
    %stops the eyetracker recording
    if(eyetracker)
        stopEyetrackerRecording(eyetracker,iView,block,exp.VPN,eyeTrackerFolder);
    end

    
    %prep for next block
    exp.trialMatrix = Shuffle(exp.trialMatrix,2);
    output.currentblock = output.currentblock + 1;
    output.currenttrial = 1;

    save([pwd,'\participantData\participant_' num2str(exp.VPN)],'output','exp');
    save([pwd,'\participantData\block_' num2str(block)],'block');

        
end

clear acc info protofile Smp pAccuracyData pCalibrationData pEventData pSampleData pSystemInfoData
if(eyetracker)
    %Unload the iViewX API library and disconnect from the server
    UnloadiViewXAPI;
end


output.responses = output.responses(any(output.responses,2),:); % remove all empty rows

if exp.practice == 'n' && exp.quest == 'y'
    save([pwd,'\participantThreshold\participant_' num2str(exp.VPN)],'output','exp');
elseif exp.practice == 'n' && exp.quest == 'n'
    save([pwd,'\participantData\participant_' num2str(exp.VPN)],'output','exp');
% elseif exp.practice == 'y'
%     experiment_MAIN
end



sca;
        
