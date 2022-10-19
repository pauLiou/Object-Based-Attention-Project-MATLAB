%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calibrate and Start the eyeTracker
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Get System Info Data')
ret_sys = iView.iV_GetSystemInfo(pSystemInfoData);

% Print the System Info Data to the command window
if (ret_sys == 1)
    disp(pSystemInfoData.Value);
else
    msg = 'System information could not be retrieved';
    disp(msg);
end

%check and apply color scheme
if colorScheme == 0 % black and white
    bkgd = [0 0 0];
    fgnd = [1 1 1];
else
    bkgd = [0.5 0.5 0.5];
    fgnd = [0 0 0];
end

% User instructions
message = sprintf('Bitte folgen Sie dem roten Punkt auf dem Bildschirm mit Ihren Augen!\n Versuchen Sie nicht die Augen zu schlieﬂen oder zu blinzeln.');

f = figure('Name', 'Anweisung Kalibrierung', ...
    'NumberTitle', 'off', ...
    'Color', bkgd, ...
    'Position', [0 0 1920 1080]);
c = uicontrol('Style', 'text', ...
    'FontSize', 32, ...
    'String', message, ...
    'BackgroundColor', bkgd, ...
    'ForegroundColor', fgnd, ...
    'Position', [450 250 1020 580]);

waitforbuttonpress;

%Calibration
disp('Calibrate iViewX');
ret_setCal = iView.iV_SetupCalibration(pCalibrationData);

%Check whether the calibration setup worked
if(ret_setCal == 1)
    ret_cal = iView.iV_Calibrate();
    
    %check wheter the calibration worked
    if (ret_cal == 1)

        disp('Validate Calibration');
        waitforbuttonpress;
        close(f)
        pause(0.05)
        
        ret_val = iView.iV_Validate();
        
        if (ret_val == 1)
            disp('Show Accuracy')
            ret_acc = iView.iV_GetAccuracy(pAccuracyData, int32(0));
            
            if (ret_acc == 1)
                disp(pAccuracyData.Value);
            else
                msg = 'Accuracy could not be retrieved';
                disp(msg);
            end
            
        else
            msg = 'Error during validation';
            disp(msg);
        end
    else
        msg = 'Error during calibration';
        disp(msg);
    end
else
    msg = 'Calibration data could not be set up';
    disp(msg)
end