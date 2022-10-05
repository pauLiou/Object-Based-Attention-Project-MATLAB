%Screen info

% Get the screen numbers
warning('off','all');
Screen('Preference','SkipSyncTests', 2);
Screen('Preference', 'SuppressAllWarnings', 1);
scrID = max(Screen('Screens'));
KbName('UnifyKeyNames');

% Define some colour info
luminescence = 60;
bkgdColor = 0;
white = WhiteIndex(scrID);
black = BlackIndex(scrID);
grey = white / 2;
textColor = white;

% Open an on screen window
[w, windowRect] = PsychImaging('OpenWindow', scrID, bkgdColor,[],[],[],[],[],[],kPsychUseFineGrainedOnset);
HideCursor(w);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', w);

% Query the frame duration
ifi = Screen('GetFlipInterval', w);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
% x-Position of circle center (0.5 equals center, 1 right border)
xCenterPos = 0.5;

% Here we set the size of the arms of our fixation cross
fixCrossDimPix = 12;

% Now we set the coordinates (these are all relative to zero we will let
% the drawing routine center the cross in the center of our monitor for us)
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];

% Set the line width for our fixation cross
lineWidthPix = 3;

% Set distance of the eyes to the screen in cm
eyeDistance = 58;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the size of the on screen window in pixels, these are the last two
% numbers in "windowRect" and "rect"
[screenXpixels, screenYpixels] = Screen('WindowSize', w);
circleXCenter = screenXpixels * xCenterPos;

% Get the centre coordinate of the window in pixels.
% xCenter = screenXpixels / 2
% yCenter = screenYpixels / 2
[xCenter, yCenter] = RectCenter(windowRect);

% Query the frame duration
Priority(1);
ifi = Screen('GetFlipInterval', w);
Priority(0);
exp.ifi = ifi;
exp.res = [screenXpixels screenYpixels];

% Flip to clear
Screen('Flip', w);

% Save the fixpoint position
exp.fixpointX = circleXCenter;


% calculate the times for stimuli usage. Between the values of probeMatrix
if(~loadVars)
    exp.stimuli_time = stimulusTimePTA_new(numberoftrials,numberofblocks,probeMatrix);
end

% Load in the specific textures for this experiment
texturesInfo;

