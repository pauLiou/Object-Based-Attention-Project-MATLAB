function [saccadeTime,fixated] = recordEyes(allTargetX,movementTarget,threshold_radius,pSampleData,iView,xCenter,yCenter,saccade)
% function that checks the saccade moves from the fixation point to the
% correct location. First it checks whether fixation is shown (fixated = 1)
% and provided that is true, it checks if the coordinates arrive at the
% placeholder for the movement target of that trial. It then calculates the
% amount of time that this took.
exitLoop = 0;
xLoc = allTargetX{movementTarget}(1);
yLoc = allTargetX{movementTarget}(2);
x = GetSecs;
fixated = 0;
saccadeUnlock = 0; % remains 0 on trials we want to remain fixated and changes to 1 on trials where we want to fixate and then do something else
while ~(exitLoop)

    ret_sam = iView.iV_GetSample(pSampleData);

    if (ret_sam == 1)
        % get sample
        Smp = libstruct('SampleStruct', pSampleData);
        gazeX = (Smp.leftEye.gazeX + Smp.rightEye.gazeX) / 2; % Average of both eyes X axis
        gazeY = (Smp.leftEye.gazeY + Smp.rightEye.gazeY) / 2; % Average of both eyes Y axis
    end

    if(saccadeUnlock == 0)
        if isInCircle(gazeX, gazeY, [xCenter yCenter], threshold_radius) % check that they start off fixated
            fixated = 1;
            saccadeUnlock = 1;
        end
    end
    % end experiment after a mouse button has been pushed
    if(fixated && saccade) % on trials where a saccade is required and participants have successfully fixated
        % check how long it takes them to perform the saccade to the
        % correct location
        if isInCircle(gazeX, gazeY, [xLoc yLoc], threshold_radius)
            exitLoop = 1;
            saccadeTime = GetSecs - x;
        end

    elseif(~fixated && saccade) % if participants make the saccade before the beep, or else do not have fixation
        % being recorded, exit the loop
        if(GetSecs - x) > 1 % gives a maximum length of 1 second to make the saccade
            exitLoop = 1;
            saccadeTime = GetSecs - x;
        end
    elseif(fixated && ~saccade)
        if(GetSecs - x) > 1
            exitLoop = 1;
            saccadeTime = GetSecs - x;
        end
    elseif(~fixated && ~saccade)
        if(GetSecs - x) > 1
            exitLoop = 1;
            saccadeTime = GetSecs - x;
            fixated = 0;
        end
    end
end