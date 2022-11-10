% Textures and Probes

img2 = readImage('textures/textures_2022/2',0);
img3 = readImage('textures/textures_2022/3',0);
img5 = readImage('textures/textures_2022/5',0);
imgE = readImage('textures/textures_2022/E',0);
imgCue = readImage('textures/movement_cue2',0);
instructions1 = imread([pwd '\textures\instructions\Slide1.jpg']);
instructions2 = imread([pwd '\textures\instructions\Slide2.jpg']);
instructions3 = imread([pwd '\textures\instructions\Slide3.jpg']);
instructions4 = imread([pwd '\textures\instructions\Slide4.jpg']);
instructions5 = imread([pwd '\textures\instructions\Slide5.jpg']);

blue.Blank = readImage('textures\textures_2022\new\rectangleBlueBlank',0);
red.Blank = readImage('textures\textures_2022\new\rectangleRedBlank',0);


% Get image size of the stimuli
[imgHeightCue,imgWidthCue, rgbe] = size(imgCue);



% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', w);
[screenWidth, screenHeight] = Screen('DisplaySize', w);

% Image size is determined in relation to screen-participant distance to
% assure visual angle
cmtopix = (10 * screenYpixels) / screenHeight;
imgHeight = 2.2 * eyeDistance * tan(deg2rad(1.2 / 2)) * cmtopix;
imgWidth = 1.4 * eyeDistance * tan(deg2rad(1.2 / 2)) * cmtopix;
circleRadius = 1.9 * eyeDistance * tan(deg2rad(7.2 / 2)) * cmtopix;

% Maximum permissible radius in ScreenCoordinates (from visual angle)
threshold_radius = 2 * eyeDistance * tan(deg2rad(threshold_radius / 2)) * cmtopix;

% % Make images to textures
arrowCue = Screen('MakeTexture',w,imgCue,1,1);
distractorStimulus = Screen('MakeTexture',w,img5,1,1);
distractorStimulus_2 = Screen('MakeTexture',w,img2,1,1);
targetStimulus = Screen('MakeTexture',w,img3,1,1);
targetStimulus_2 = Screen('MakeTexture',w,imgE,1,1);
%instructionStimulus = Screen('MakeTexture',w,instructions);
instructions1 = Screen('MakeTexture',w,instructions1);
instructions2 = Screen('MakeTexture',w,instructions2);
instructions3 = Screen('MakeTexture',w,instructions3);
instructions4 = Screen('MakeTexture',w,instructions4);
instructions5 = Screen('MakeTexture',w,instructions5);
rect1 = Screen('MakeTexture',w,red.Blank,1,1);
rect2 = Screen('MakeTexture',w,blue.Blank,1,1);

% Create the stimuli locations
alltargetLoc = targetsOnHalfCircle(circleRadius, circleXCenter, yCenter, imgHeight, imgWidth, 4, [1,2,3,4]);
for i = 1:length(alltargetLoc)
    loc = alltargetLoc{i};
    [locxCenter,locyCenter] = RectCenter(loc);
    allTargetX{i} = [locxCenter,locyCenter];
end

% The rectangle coordinates

for i = 1:length(alltargetLoc)
    [boxX boxY] = RectCenter(alltargetLoc{i});
    boxCoords{i} = [boxX,boxY];
    clear boxX boxY
end
% rectangle position
baseRectHorizontal = [0 0 500 100];
allRects = nan(4,2);
allRects(:,1) = CenterRectOnPointd(baseRectHorizontal,xCenter,boxCoords{2}(2));
allRects(:,2) = CenterRectOnPointd(baseRectHorizontal,xCenter,boxCoords{1}(2));
rectangle = allRects;


distractorOptions = ([distractorStimulus,distractorStimulus_2]);
targetOptions = [targetStimulus,targetStimulus_2];





allColors = ([63 63 63]/255);
topColors = ([0 0 255]);
bottomColors = ([255 0 0]);



% Make the destination rectangles for our image. We will draw the image
% multiple times over getting smaller on each iteration. So we need the big
% dstRects first followed by the progressively smaller ones




% Define corresponding cue angles pointing to every possible movement target

angle = 270;
cueAngle=zeros(4,1);
for a = 1:4
    cueAngle(a,1) = angle;
    angle=angle+90;
end
clear angle

processing = {'[Processing    ]','[Processing.   ]','[Processing..  ]','[Processing... ]'};

