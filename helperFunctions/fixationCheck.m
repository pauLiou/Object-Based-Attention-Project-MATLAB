function fixationTime = fixationCheck(pause_key,block,trialnr,eyetracker,iView,w,textColor,allCoords,lineWidthPix,circleXCenter,xCenter,yCenter,defaultStimulus,alltargetLoc,threshold_radius,pSampleData,exp,topColors,bottomColors,rectangle,startTime,ifi,practice,saccade,QUEST)

% While loop below determines that:
% A: Participant is fixated for at least the length of 1 second.
% B: Eyes are actually on the fixation cross for this time
 
fixatedEyes = false; % True if eyes are looking at fixation cross
dur = false; % True if the fixation reaches the time threshold
clockStart = true; % Start the fixation timer only when fixated and clockStart is true
trial = 0;
baseRect = [937.5000  517.5000  982.5000  562.5000];

% Send message to eyetracker for start of trial
if(eyetracker)
    iView.iV_SendImageMessage(['Block:' num2str(block) '-Trial:' num2str(trialnr) '.jpg']);
end


while(~fixatedEyes || ~dur)
    
    [keyIsDown, ~, keyCode] = KbCheck();
    if(keyIsDown == 1 && keyCode(pause_key) == 1)
        
        % Render pause on the screen and wait for any key press to
        % resume execution
        DrawFormattedText(w,'Pause','center','center',textColor);
        Screen('Flip',w);
        KbPressWait;
    end
    
    if(~fixatedEyes)
        startFix = tic;
    end
    if fixatedEyes == true && clockStart == true
        trial = tic;
    end
    % This draws the fixation cross
    Screen('DrawLines', w, allCoords, lineWidthPix, textColor, [circleXCenter yCenter], 2);

    if(saccade)% && ~QUEST)
        if exp.practice == 'y' && block == 2
            Screen('FrameRect',w, topColors, rectangle(:,1), 6);
            Screen('FrameRect',w, bottomColors, rectangle(:,2), 6);
        elseif exp.practice == 'y' && block == 1
            % don't include the oval
        else
            Screen('FrameRect',w, topColors, rectangle(:,1), 6);
            Screen('FrameRect',w, bottomColors, rectangle(:,2), 6);
        end
    end
    % This draws the 4 placeholder locations
%     for a = 1:4
%         Screen('DrawTexture',w,defaultStimulus,[],alltargetLoc{a,1}, 0, 0);
%     end
    % This draws the four template locations  
    if practice == 'n'% && ~QUEST
        Screen('FrameRect',w, topColors, rectangle(:,1), 6);
        Screen('FrameRect',w, bottomColors, rectangle(:,2), 6);
    end

    
    if(eyetracker)
        iView.iV_GetSample(pSampleData); % Get an eye tracker sample at this time
        Smp = libstruct('SampleStruct', pSampleData);
        gazeX = (Smp.leftEye.gazeX + Smp.rightEye.gazeX) / 2; % Average of both eyes X axis
        gazeY = (Smp.leftEye.gazeY + Smp.rightEye.gazeY) / 2; % Average of both eyes Y axis
        % Determines if these gaze coords are in the fixation area
        fixatedEyes = isInCircle(gazeX, gazeY, [xCenter yCenter], threshold_radius);
    else
        fixatedEyes = true;
    end
    
    if trial == 0
        clockStart = true;
    else
        clockStart = false;
    end
    
    if(fixatedEyes)
        dur = toc(startFix) > exp.fixation-ifi;
    end
    Screen('Flip',w);
    
end

fixationTime = GetSecs;