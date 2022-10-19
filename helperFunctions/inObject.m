% short script that makes sure the target location appears in the
% right place. Based on trialMatrix 1, half the trials should
% appear within the box, while the other half should appear outside
% of the box (excluding trials where arrow points at target)

function targetLoc = inObject(trialMatrix,movementTarget,trialnr,rec1,rec2,trialRec)
x = rec1; % first rectanglge
y = rec2; % second rectangle
if trialMatrix(trialnr,2) == 1 % target matches arrow
    targetLoc = movementTarget;
elseif trialMatrix(trialnr,2) == 2 % inside object but doesnt match target
    if ismember(movementTarget,x)
        targetLoc = x(x ~= movementTarget);
    else
        targetLoc = y(y ~= movementTarget);
    end
elseif trialMatrix(trialnr,2) == 3 && trialRec == 1 % outside object close end
    if movementTarget == x(1) 
        targetLoc = y(1);
    elseif movementTarget == x(2)
        targetLoc = y(2);
    elseif movementTarget == y(1)
        targetLoc = x(1);
    elseif movementTarget == y(2)
        targetLoc = x(2);
    end
elseif trialMatrix(trialnr,2) == 4 && trialRec == 1 % outside object far end
    if ismember(movementTarget,x(1))
        targetLoc = y(2);
    elseif ismember(movementTarget,x(2))
        targetLoc = y(1);
    elseif ismember(movementTarget,y(1))
        targetLoc = x(2);
    elseif ismember(movementTarget,y(2))
        targetLoc = x(1);
    end
elseif trialMatrix(trialnr,2) == 3 && trialRec == 0 % same but reversed for other rectangle display
    if ismember(movementTarget,x(1))
        targetLoc = y(2);
    elseif ismember(movementTarget,x(2))
        targetLoc = y(1);
    elseif ismember(movementTarget,y(1))
        targetLoc = x(2);
    elseif ismember(movementTarget,y(2))
        targetLoc = x(1);
    end
elseif trialMatrix(trialnr,2) == 4 && trialRec == 0 % same but reversed for other rectangle display
    if movementTarget == x(1)
        targetLoc = y(1);
    elseif movementTarget == x(2)
        targetLoc = y(2);
    elseif movementTarget == y(1)
        targetLoc = x(1);
    elseif movementTarget == y(2)
        targetLoc = x(2);
    end


end

