function [QP,trialnr,startGuess_mean,trueParams] = executeQUEST(exp,numberoftrials)


    F = @(x,mu,sigma,gamma,lambda)gamma+(1 - gamma - lambda).*normcdf(x,mu,sigma);


    % set true param(s)
    mu = 35;
    sigma = 1;
    gamma = 0.5;
    lambda = 0.02;
    trueParams = {mu, sigma, gamma, lambda};
    
    % set parameter domain(s)
    mu = round(exp*1000); % currently at between 10ms and 150ms
    sigma = 1;
    gamma = 0.5;
    lambda = 0.02;
    paramDomain = {mu, sigma, gamma, lambda};
    
    % set stimulus domain(s)
    stimDomain = round(exp*1000);
    
    respDomain = [0 1];
    stopRule = 'entropy';
    minNTrials = 50;
    stopCriterion = 1;

    % create QUEST+ object
    QP = QuestPlus(F, stimDomain, paramDomain, respDomain, stopRule, stopCriterion,minNTrials);

   
    %initialise likelihoods
    QP.initialise();
    
    startGuess_mean = QP.getParamEsts('mean');
    
    trialnr = 0;
    
end