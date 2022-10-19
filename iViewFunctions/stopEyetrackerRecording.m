% stop recording eyetracker

function stopEyetrackerRecording(eyetracker,iView,block,exp,eyeTrackerFolder)
exp = int2str(exp);
if(eyetracker)
    ret_stop = iView.iV_StopRecording();
    if(ret_stop ~= 1)
        msg = 'Recording could not be stopped correctly';
        disp(msg);
    end
    
    filename = fullfile(eyeTrackerFolder,['Block_', num2str(block) '.idf']);
    
    ret_save = iView.iV_SaveData(filename,'new_exp',exp,int32(1));
    disp('Recording saved');
    
    if(ret_save ~= 1)
        disp('Recording data could not be saved')
    end
end

end