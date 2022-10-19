clear all

display.dist = 50;  %cm
display.width = 30; %cm
display.skipChecks = 1; %avoid Screen's timing checks and verbosity

% Insead of a list of coherence values, we'll choose a starting value and a
% step size.  We can choose any number of trials.

design.startingCoherence =  1;
design.stepSize = .5; 
design.nTrials = 60; 

% We'll use the same timing parameters:
design.stimDur = .5;           %duration of stimulus (sec)
design.responseInterval = .5;  %window in time to record the subject's response
design.ITI = 1.5;             %inter-trial-interval (time between the start of each trial)

% And we need to define the parameters for the dots
dots.nDots = 200;
dots.speed = 5;
dots.lifetime = 12;
dots.apertureSize = [12,12];
dots.center = [0,0];
dots.color = [255,255,255];
dots.size = 8;
dots.coherence = design.startingCoherence;       %coherence  level for the first trial

% Design a list of directions randomly chosen for each trial
temp = ceil(rand(1,design.nTrials)+.5);  %50/50 chance of a 1 (up) or a 2 (down)
design.directions = (temp-1)*180; %1 -> 0 degrees, 2 -> 180 degrees

%set up a 'results' structure
results.intensity = NaN*ones(1,design.nTrials);  %to  be filled in after each trial
results.response = NaN*ones(1,design.nTrials);   %to  be filled in after each trial

%this parameter keeps track of the number of correct responses in a row
correctInaRow = 0;

%Let's open the screen and get going!
try
    display = OpenWindow(display);

    drawText(display,[0,6],'Press "u" for up and "d" for down',[255,255,255]);
    drawText(display,[0,5],'Press Any Key to Begin.',[255,255,255]);

    display = drawFixation(display);

    while KbCheck; end
    KbWait;

    %record the clock time at the beginning
    startTime = GetSecs;
    %loop through the trials
    for trialNum = 1:design.nTrials
        %set the coherence level and the direction for this trial
        dots.direction = design.directions(trialNum);

        %Show the stimulus
        movingDots(display,dots,design.stimDur);

        %Get the response within the first second after the stimulus
        keys = waitTill(design.responseInterval);

        %Interpret the response provide feedback and deal with
        results.intensity(trialNum) = dots.coherence;

        if isempty(keys)  %No key was pressed, yellow fixation
            correct = NaN;
            display.fixation.color{1} = [255,255,0];
        else
            %Correct response, green fixation
            if (keys{end}(1)=='u' && dots.direction == 0) || (keys{end}(1)=='d' && dots.direction == 180)
                results.response(trialNum) = 1;
                correctInaRow = correctInaRow +1;
                 if correctInaRow == 3
                    dots.coherence = dots.coherence*design.stepSize;

                    correctInaRow = 0;
                end
                display.fixation.color{1} = [0,255,0];
                 %Incorrect response, red fixation
            elseif (keys{end}(1)=='d' && dots.direction == 0) || (keys{end}(1)=='u' && dots.direction == 180)
                results.response(trialNum) = 0;
                dots.coherence = dots.coherence/design.stepSize;
                dots.coherence = min(dots.coherence,1);
                correctInaRow = 0;
                display.fixation.color{1} = [255,0,0];
            else %Wrong key was pressed, blue fixation
                results.response(trialNum) = NaN;
                display.fixation.color{1} = [0,0,255];
                %Note, for wrong keypresses, don't update the staircase
                %parameters
            end
        end

        %Flash the fixation with color
        drawFixation(display);
        waitTill(.15);
        display.fixation.color{1} = [255,255,255];
        drawFixation(display);

        %Now wait for the clock to catch up to the time for the next trial
        waitTill(trialNum*design.ITI,startTime);
    end

catch ME
    Screen('CloseAll');
    rethrow(ME)
end
Screen('CloseAll');