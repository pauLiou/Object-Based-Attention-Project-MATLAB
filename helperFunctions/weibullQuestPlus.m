function[] = weibullQuestPlus(questData)

psiParamsIndex = qpListMaxArg(questData.posterior);
psiParamsQuest = questData.psiParamsDomain(psiParamsIndex,:);
fprintf('Max posterior QUEST+ parameters: %0.1f, %0.1f, %0.1f, %0.2f\n', ...
    psiParamsQuest(1),psiParamsQuest(2),psiParamsQuest(3),psiParamsQuest(4));
psiParamsFit = qpFit(questData.trialData,questData.qpPF,psiParamsQuest,questData.nOutcomes,...
    'lowerBounds', [10 3.5 0.5 0.02],'upperBounds',[100 3.5 0.5 0.02]);
figure; clf; hold on
stimCounts = qpCounts(qpData(questData.trialData),questData.nOutcomes);
stim = [stimCounts.stim];
stimFine = linspace(10,100,100)';
plotProportionsFit = qpPFWeibull(stimFine,psiParamsFit);
for cc = 1:length(stimCounts)
    nTrials(cc) = sum(stimCounts(cc).outcomeCounts);
    pCorrect(cc) = stimCounts(cc).outcomeCounts(2)/nTrials(cc);
end
for cc = 1:length(stimCounts)
    h = scatter(stim(cc),pCorrect(cc),100,'o','MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1],...
        'MarkerFaceAlpha',nTrials(cc)/max(nTrials),'MarkerEdgeAlpha',nTrials(cc)/max(nTrials));
end

plot(stimFine,plotProportionsFit(:,2),'-','Color',[1 0.2 0.0],'LineWidth',3);
xlabel('Stimulus Value');
ylabel('Proportion Correct');
xlim([10 100]); ylim([0 1]);
title({'Estimate Weibull threshold', ''});

drawnow();
