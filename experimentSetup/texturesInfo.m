% Textures and Probes

img2 = readImage('textures/temp/2',0);
img3 = readImage('textures/temp/3',0);
img5 = readImage('textures/temp/5',0);
img8 = readImage('textures/temp/8_grey',0);
imgE = readImage('textures/temp/E',0);
imgCue = readImage('textures/movement_cue2',0);
instructions1 = imread([pwd '\textures\instructions\Slide1.jpg']);
instructions2 = imread([pwd '\textures\instructions\Slide2.jpg']);
instructions3 = imread([pwd '\textures\instructions\Slide3.jpg']);
instructions4 = imread([pwd '\textures\instructions\Slide4.jpg']);
instructions5 = imread([pwd '\textures\instructions\Slide5.jpg']);

blue.Blank = readImage('textures\textures_2022\new\rectangleBlueBlank',0);
blue.target.t2E = readImage('textures\textures_2022\new\rectangleBlue2E',0); 
blue.target.t5E = readImage('textures\textures_2022\new\rectangleBlue5E',0);
blue.target.tE2 = readImage('textures\textures_2022\new\rectangleBlueE2',0);
blue.target.tE5 = readImage('textures\textures_2022\new\rectangleBlueE5',0);
blue.target.t23 = readImage('textures\textures_2022\new\rectangleBlue23',0);
blue.target.t53 = readImage('textures\textures_2022\new\rectangleBlue53',0);
blue.target.t32 = readImage('textures\textures_2022\new\rectangleBlue32',0);
blue.target.t35 = readImage('textures\textures_2022\new\rectangleBlue35',0);
blue.distractor.t22 = readImage('textures\textures_2022\new\rectangleBlue22',0);
blue.distractor.t25 = readImage('textures\textures_2022\new\rectangleBlue25',0);
blue.distractor.t55 = readImage('textures\textures_2022\new\rectangleBlue55',0);
blue.distractor.t52 = readImage('textures\textures_2022\new\rectangleBlue52',0);

red.Blank = readImage('textures\textures_2022\new\rectangleredBlank',0);
red.target.t2E = readImage('textures\textures_2022\new\rectanglered2E',0); 
red.target.t5E = readImage('textures\textures_2022\new\rectanglered5E',0);
red.target.tE2 = readImage('textures\textures_2022\new\rectangleredE2',0);
red.target.tE5 = readImage('textures\textures_2022\new\rectangleredE5',0);
red.target.t23 = readImage('textures\textures_2022\new\rectanglered23',0);
red.target.t53 = readImage('textures\textures_2022\new\rectanglered53',0);
red.target.t32 = readImage('textures\textures_2022\new\rectanglered32',0);
red.target.t35 = readImage('textures\textures_2022\new\rectanglered35',0);
red.distractor.t22 = readImage('textures\textures_2022\new\rectanglered22',0);
red.distractor.t25 = readImage('textures\textures_2022\new\rectanglered25',0);
red.distractor.t55 = readImage('textures\textures_2022\new\rectanglered55',0);
red.distractor.t52 = readImage('textures\textures_2022\new\rectanglered52',0);


% Get image size of the stimuli
[imgHeightCue,imgWidthCue, rgbe] = size(imgCue);



% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', w);
[screenWidth, screenHeight] = Screen('DisplaySize', w);

% Image size is determined in relation to screen-participant distance to
% assure visual angle
cmtopix = (10 * screenYpixels) / screenHeight;
imgHeight = 2.25 * eyeDistance * tan(deg2rad(1.2 / 2)) * cmtopix;
imgWidth = 1.5 * eyeDistance * tan(deg2rad(1.2 / 2)) * cmtopix;
circleRadius = 1.9 * eyeDistance * tan(deg2rad(7.2 / 2)) * cmtopix;

% Maximum permissible radius in ScreenCoordinates (from visual angle)
threshold_radius = 2 * eyeDistance * tan(deg2rad(threshold_radius / 2)) * cmtopix;

% % Make images to textures
%probeStimulus = Screen('MakeTexture',w,imgTest,1,1);
defaultStimulus = Screen('MakeTexture', w, img8,1,1);
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
allRects = nan(4,4);
allRects(:,1) = CenterRectOnPointd(baseRectHorizontal,xCenter,boxCoords{2}(2));
allRects(:,2) = CenterRectOnPointd(baseRectHorizontal,xCenter,boxCoords{1}(2));


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

