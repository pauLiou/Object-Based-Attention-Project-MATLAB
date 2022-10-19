probeset = 0.8:0.1:1.5;
meanset = probeset;
slopeset = [.5:.1:5].^2;
lapse = 0.05;
guess = 0.5;

numberoftrials = 10;
qpause = false;
qplot = false;

qasemodel = true;
truepse = 0;
truedl = 4;

if guess==0
    resp    = @(probe)  lapse/2 + (1-lapse)      *normcdf(probe,truepse,truedl/sqrt(2)/erfinv(0.5)) > rand;
else
    resp    = @(probe)   guess  + (1-lapse-guess)*normcdf(probe,truepse,truedl/sqrt(2)/erfinv(0.5)) > rand;
end

stair = MinExpEntStair('v2');
stair.set_use_lookup_table(true);
%stair('set_psychometric_func','logistic');
stair.init(probeset,meanset,slopeset,lapse,guess);
stair.toggle_use_resp_subset_prop(10,.9);
stair.set_first_value(1)

%%%
%trial goes here
%%%
for ktrial = 1:numberoftrials
    [p,entexp,ind] = stair.get_next_probe();
    r = input(sprintf('r(%d): ',ktrial));
end

stair.process_resp(r); 


[PSEfinal,DLfinal,loglikfinal]  = stair.get_PSE_DL();
finalent                        = sum(-exp(loglikfinal(:)).*loglikfinal(:));
fprintf('final estimates:\nPSE: %f\nDL: %f\nent: %f\n',PSEfinal,DLfinal,finalent);