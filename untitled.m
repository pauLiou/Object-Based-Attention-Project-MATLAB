% Clear the workspace and the screen
sca;
close all;
clear;
% Set up alpha-blending for smooth (anti-aliased) lines




% Here we call some default settings for setting up Psychtoolbox
% Clear the workspace and the screen
sca;
close all;
clear;
imagegg = readImage('textures\textures_2022\new\rectangleBlank',0);
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = [60,60,60]/255;
inc = white - grey;

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');


theImage = imread('textures\textures_2022\new\rectangleRedBlank.png');

% Make the image into a texture
imageTexture = Screen('MakeTexture', window, theImage);

% Make the destination rectangles for our image. We will draw the image
% multiple times over getting smaller on each iteration. So we need the big
% dstRects first followed by the progressively smaller ones

x = [710,306,1210,406]
xt = [710,674, 1210, 774]

%x = CenterRectOnPointd(rect, screenXpixels / 2, screenYpixels *0.75);
%xt = CenterRectOnPointd(rect, screenXpixels / 2, screenYpixels *0.25);


% Draw the image to the screen, unless otherwise specified PTB will draw
% the texture full size in the center of the screen.
Screen('DrawTextures', window, imageTexture, [], x);
Screen('DrawTextures', window, imageTexture, [], xt)

% Flip to the screen
Screen('Flip', window);

% Wait for key press
KbStrokeWait;

% Clear the screen
sca;