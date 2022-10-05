%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                        Eye Tracker Connection
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Calibrate and Start the eyeTracker / Start recording
if(eyetracker);
    while(~acceptedCalibration)
        CalibrateiViewpaul;
        
        disp('Calibration complete. If the accuracy is sufficient press y. If not, press any key to recalibrate.');
        commandwindow;
        [~, keyCode] = KbWait;
        if(keyCode(accept_key) == 1)
            acceptedCalibration = true;
        end
    end
    
    % Save calibration data
    eyeCal.trial = output.currenttrial;
    eyeCal.block = output.currentblock;
    acc = libstruct('AccuracyStruct', pAccuracyData);
    eyeCal.lx = acc.deviationLX;
    eyeCal.ly = acc.deviationLY;
    eyeCal.rx = acc.deviationRX;
    eyeCal.ry = acc.deviationRY;
    info = libstruct('SystemInfoStruct', pSystemInfoData);
    eyeCal.sampleRate = info.samplerate;
    eyeCal.device = info.iV_ETDevice;
    eyeCal.reason = 'Neustart';
    
    output.eyeCalibration = [output.eyeCalibration; eyeCal];
else
    %Save default calibration data
    eyeCal.default = 0;
    output.eyeCalibration = [output.eyeCalibration; eyeCal];
end


