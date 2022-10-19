% Define the keyboard keys that are listened for. We will be using the left
% and right arrow keys as response keys for the task and the escape key as
% a exit/reset key
escapeKey = KbName('ESCAPE');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');


% Pause key
pause_key = KbName('p');

% Response Keys for Calibration (to accept calibration press 'y', to redo
% the calibration press any other key)
accept_key = KbName('y');
acceptedCalibration = false;
