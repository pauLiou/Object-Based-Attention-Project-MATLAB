function startEyetrackerRecording(eyetracker,iView,loadVars)

% Start eyetracker recording for this block
% Clear eyetracker buffer and start recording
if(eyetracker)
    ret_clr = iView.iV_ClearRecordingBuffer();
    ret_str = iView.iV_StartRecording();
    
    if (ret_str ~= 1 || (ret_clr ~= 1 && ret_clr ~= 191))
        if(loadVars)
            disp('no new recording');
        else
            error('Recording could not be set up');
        end
    end
end