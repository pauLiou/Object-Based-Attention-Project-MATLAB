%----------------------------------------------------------------------
%                     Textures and Probes
%----------------------------------------------------------------------
%
if(loadVars)
    threshold_radius = 2; % Set radius for healthy participants (visual angle)
end

img8 = readImage('textures/temp/8_grey',0);
img8mask = uint8(img8 == 0);
img8_lighter = (img8mask(:,:,1:3) * luminescence) + img8(:,:,1:3);
imgCue = readImage('textures/movement_cue',0);
imgTest = readImage('textures/temp/8',1);
instructions = imread([pwd '\textures\InstructionsMAIN.jpg']);


% Get image size of the stimuli
[imgHeightCue,imgWidthCue, rgbe] = size(imgCue);


% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', w);
[screenWidth, screenHeight] = Screen('DisplaySize', w);

% Image size is determined in relation to screen-participant distance to
% assure visual angle
cmtopix = (10 * screenYpixels) / screenHeight;
imgHeigth = 2 * eyeDistance * tan(degtorad(1.4 / 2)) * cmtopix;
imgWidth = 2 * eyeDistance * tan(degtorad(0.9 / 2)) * cmtopix;
circleRadius = 2 * eyeDistance * tan(degtorad(7.2 / 2)) * cmtopix;

% Maximum permissible radius in ScreenCoordinates (from visual angle)
threshold_radius = 2 * eyeDistance * tan(degtorad(threshold_radius / 2)) * cmtopix;

% % Make images to textures
probeStimulus = Screen('MakeTexture',w,imgTest,1,1);
defaultStimulus = Screen('MakeTexture', w, img8,1,1);
arrowCue = Screen('MakeTexture',w,imgCue,1,1);
instructionStimulus = Screen('MakeTexture',w,instructions);


% Create the stimuli locations
numStim = 2;

alltargetLoc = targetsOnHalfCircle(circleRadius, circleXCenter, yCenter, imgHeigth, imgWidth, numStimuli, positionChoices);

% The box coordinates

baseRectHorizontal = [0 0 500 100];
baseRectVertical = [0 0 100 500];
for i = 1:length(alltargetLoc)
    [boxX boxY] = RectCenter(alltargetLoc{i});
    boxCoords{i} = [boxX,boxY];
    clear boxX boxY
end
allRects = nan(4,4);    
allRects(:,1) = CenterRectOnPointd(baseRectHorizontal,xCenter,boxCoords{2}(2));
allRects(:,2) = CenterRectOnPointd(baseRectHorizontal,xCenter,boxCoords{1}(2));
allRectsVert(:,1) = CenterRectOnPointd(baseRectVertical,boxCoords{1}(1),yCenter);
allRectsVert(:,2) = CenterRectOnPointd(baseRectVertical,boxCoords{3}(1),yCenter);
allColors = ([63 63 63]/255);

% Define corresponding cue angles pointing to every possible movement target
if (numStimuli == 4)
    angle = 225;
    cueAngle=zeros(numStimuli,1);
    for a = 1:numStimuli
        cueAngle(a,1) = angle;
        angle=angle+90;
    end
else
    angle = -120;
    cueAngle=zeros(numStimuli,1);
    for a = 1:numStimuli
        cueAngle(a,1) = angle;
        angle=angle+30;
    end
end

firstTargetTrial = '1';
secondTargetTrial = '2';

