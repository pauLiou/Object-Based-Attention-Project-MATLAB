%%%

trialNB = 10; % number of trials

% Timing

fix_dur = 12; % 200 ms
fix_jitter = [0:12]; % additional fixation jitter

flicker_soa = [1:5];

f1_dur = 5;
f2_dur = 5;

for t = 1 : trialNB
    
    curr_fix = fix_dur+fix_jitter(randi(numel(fix_jitter)));
    curr_f_soa = flicker_soa(randi(numel(flicker_soa)));
    
    t_start = 1;
    
    t_f1_start = curr_fix+1;
    t_f2_start = t_f1_start+curr_f_soa;
        
    %t_f1_end = t_f1_start+f1_dur;
    t_f2_end = t_f2_start+f2_dur;
    t_f1_end = t_f2_end;
    
    trial_end = 0;
    curr_fr = 1;
    
    %Eyelink('message','TRIAL_START %d', t);
    
    while ~trial_end 
        
        
        %%% show fixation target %%%
        
        %%% print all 8's %%%
        Screen('DrawTextures', scr, texture8, [], const.destRectMat, 0)
        
        
        if curr_fr >= t_f1_start %&& curr_fr <= t_f1_end
            if curr_fr == t_f1_start; Eyelink('message','f1_on'); end
            %if curr_fr == t_f1_end; Eyelink('message','f1_off'); end
            
            %%% print bright %%%
        end
        
        if curr_fr >= t_f2_start %&& curr_fr <= t_f2_end
            if curr_fr == t_f2_start; Eyelink('message','f2_on'); end
            %if curr_fr == t_f2_end; Eyelink('message','f2_off'); end
            
            %%% print bright %%%
        end
        
        Screen('Flip',scr.main);
        
        curr_fr = curr_fr+1;
        
        
        % check subject response
        [keyIsDown, ~, keyCode] = KbCheck(-1);
        if keyIsDown
            trial_end = 1;
        end
    end
    
    % display different fixation target 
    
end
