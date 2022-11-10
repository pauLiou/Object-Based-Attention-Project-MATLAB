%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%            userInput function edited for experiment
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function [exp,numberoftrials,numberofblocks,QUEST,eyetracker] = userInput()
% Bundle all user input and returns struct with user variables (VPN, Age,
% Gender, Trial run, etc)

validInput = false;

% Loops until the user has given valid input
while (~validInput)
    
    % Create the dialog box
    prompt = {'Participant Number:','Age:', 'Gender(f or m):','practice?','QUEST+'};
    dlg_title = 'User Input';
    num_lines = 1;
    expCell = inputdlg(prompt,dlg_title,num_lines);
    
    % save input in struct instead of cell
    exp.VPN = expCell{1};
    exp.age = str2double(expCell{2});
    exp.gender = expCell{3};
    exp.practice = expCell{4};
    exp.quest = expCell{5};
    

    %check whether values are valid
    % VPN has to be filled out, age hast to be between 0 and 110
    validInput = ~isempty(exp.VPN) && ~isempty(exp.age) && (exp.age > 0) && (exp.age < 110);
    % Gender can be f for female or m for male
    validInput = validInput && (exp.gender == 'm' || exp.gender == 'f');
    validInput = validInput && (exp.practice == 'y' || exp.practice == 'n');
    validInput = validInput && (exp.quest == 'y' || exp.quest == 'n');
    
    

    
    
    if ~validInput
        msg = 'The entered information was not valid. Please repeat with valid values.';
        disp(msg)
    end
end
    if exp.practice == 'y'
        QUEST = false;
        numberofblocks = 3;%3;
        numberoftrials = 64;%64;
        eyetracker = false;% true;
    else
        if exp.quest == 'y'
            numberofblocks = 1; % How many total blocks 1 
            numberoftrials = 64;%64; % How many total trials 64
            QUEST = true;
            eyetracker = true;
            
        else
            numberofblocks = 8;%8; % How many total blocks 8
            numberoftrials = 64;%64; % How many total trials 64
            QUEST = false;
            eyetracker = true;
            
        end
    end

end