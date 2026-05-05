%% FIGURE 2A: Balance Integration Scores (2(task instructions:Recall, Suppress) x 3 (emotions: Negative, Neutral, Positive))
% -------------------------------------------------------------------------
% This script reproduces Figure 2A from the manuscript and completes:
%   - Condition-specific visualization 
%   - Statistical comparison between the conditions 
%   - Figure export (300 dpi)
%
%
% REQUIREMENTS:
%   - MATLAB (R2021a or later)
%   - Statistics and Machine Learning Toolbox 
%   - Data file: 'Figure2A.mat' in present working directory 
%
%
% OUTPUT:
%   - Figure replicating Figure 2A
%   - Statistical results 
%
% AUTHOR: Shruti Kinger <shrutik@iiitd.ac.in>
% DATE: 27 April 2026
% MANUSCRIPT: Resting-state functional connectivity correlates of emotional 
% memory control under cognitive load in subclinical anxiety
% -------------------------------------------------------------------------

clearvars;
close all;
clc;

%% --------------------------- LOAD DATA ----------------------------------

load Figure2A.mat

numParticipants = length(mean_bis_negT);
%% --------------------------- DEFINE COLORS ---------------------------------------
edgeColorThink   = [0, 0, 128/255];        % Dark blue
edgeColorNoThink = [153/255, 0, 0];        % Dark red

% Lighter fill colors
thinkFaceColor   = edgeColorThink   + (1 - edgeColorThink) * 0.8;
noThinkFaceColor = edgeColorNoThink + (1 - edgeColorNoThink) * 0.8;

%% --------------------------- FIGURE SETUP -------------------------------
figure('Color', 'w', 'Position', [100, 100, 600, 600]);

hold on;

x_NEG = 0.5;
x_NEG_NT =1;
x_NU = 1.75;
x_NU_NT =2.25;
x_POS = 3;
x_POS_NT = 3.5;

NG =0.75;
NU= 2;
POS= 3.25;




%% ----------- PARTICIPANT-LEVEL CONNECTING LINES -------------------------

hold on
for i = 1:numParticipants

    % Plot a light gray line for each participant
     plot([x_NEG, x_NEG_NT, x_NU, x_NU_NT, x_POS, x_POS_NT], [mean_bis_negT(i), mean_bis_negNT(i), mean_bis_nuT(i), mean_bis_nuNT(i),mean_bis_posT(i), mean_bis_posNT(i)], '-', 'Color', [0.8 0.8 0.8], 'LineWidth', 0.08);
end

%% ---------------------- SCATTER: RECALL ----------------------------------


h1=scatter(repmat(x_NEG, 1, numParticipants), mean_bis_negT, 250, 's',   'MarkerEdgeColor','none',...
    'MarkerFaceColor',thinkFaceColor,...
    'LineWidth',2);

h1=scatter(repmat(x_NEG, 1, numParticipants), mean_bis_negT, 250, 's',   'MarkerEdgeColor',edgeColorThink,...
    'MarkerFaceColor','none',...
    'LineWidth',2);

scatter(repmat(x_NU, 1, numParticipants), mean_bis_nuT, 250, 's',   'MarkerEdgeColor','none',...
    'MarkerFaceColor',thinkFaceColor,...
    'LineWidth',2);
scatter(repmat(x_NU, 1, numParticipants), mean_bis_nuT, 250, 's',   'MarkerEdgeColor',edgeColorThink,...
    'MarkerFaceColor','none',...
    'LineWidth',2);

scatter(repmat(x_POS, 1, numParticipants), mean_bis_posT, 250, 's',   'MarkerEdgeColor','none',...
    'MarkerFaceColor','none',...
    'LineWidth',2);
scatter(repmat(x_POS, 1, numParticipants), mean_bis_posT, 250, 's',   'MarkerEdgeColor',edgeColorThink,...
    'MarkerFaceColor',thinkFaceColor,...
    'LineWidth',2);

%% ---------------------- SCATTER: SUPPRESS ----------------------------------

h4=scatter(repmat(x_NEG_NT, 1, numParticipants), mean_bis_negNT, 250, 's',   'MarkerEdgeColor','none',...
    'MarkerFaceColor',noThinkFaceColor,...
    'LineWidth',2);
h4=scatter(repmat(x_NEG_NT, 1, numParticipants), mean_bis_negNT, 250, 's',   'MarkerEdgeColor',edgeColorNoThink,...
    'MarkerFaceColor', 'none',...
    'LineWidth',2);


scatter(repmat(x_NU_NT, 1, numParticipants), mean_bis_nuNT, 250, 's',   'MarkerEdgeColor','none',...
    'MarkerFaceColor',noThinkFaceColor,...
    'LineWidth',2);
scatter(repmat(x_NU_NT, 1, numParticipants), mean_bis_nuNT, 250, 's',   'MarkerEdgeColor',edgeColorNoThink,...
    'MarkerFaceColor','none',...
    'LineWidth',2);


scatter(repmat(x_POS_NT, 1, numParticipants), mean_bis_posNT, 250, 's',   'MarkerEdgeColor','none',...
    'MarkerFaceColor',noThinkFaceColor,...
    'LineWidth',2);
scatter(repmat(x_POS_NT, 1, numParticipants), mean_bis_posNT, 250, 's',   'MarkerEdgeColor',edgeColorNoThink,...
    'MarkerFaceColor','none',...
    'LineWidth',2);

%% ---------------------- SCATTER: MEAN ----------------------------------
scatter(x_NEG,  mean(mean_bis_negT), 250,'o','filled',  'MarkerFaceColor', 'k');
scatter(x_NU,  mean(mean_bis_nuT), 250,'o','filled',  'MarkerFaceColor', 'k');
scatter(x_POS,  mean(mean_bis_posT), 250,'o','filled',  'MarkerFaceColor', 'k');
scatter(x_NEG_NT,  mean(mean_bis_negNT), 250,'o','filled',  'MarkerFaceColor', 'k');
scatter(x_NU_NT,  mean(mean_bis_nuNT), 250,'o','filled',  'MarkerFaceColor', 'k');
scatter(x_POS_NT,  mean(mean_bis_posNT), 250,'o','filled',  'MarkerFaceColor', 'k');

% plot errorbars
e1 = errorbar(x_NEG,  mean(mean_bis_negT), std(mean_bis_negT)/sqrt(numParticipants), 'Color', 'k','LineStyle','none','Marker','.', 'MarkerSize',20);
e1.LineWidth =2;

e2= errorbar(x_NU,  mean(mean_bis_nuT),  std(mean_bis_nuT)/sqrt(numParticipants), 'Color', 'k','LineStyle','none','Marker','.', 'MarkerSize',20);
e2.LineWidth =2;

e3 = errorbar(x_POS, mean(mean_bis_posT), std(mean_bis_posT)/sqrt(numParticipants), 'Color', 'k','LineStyle','none','Marker','.', 'MarkerSize',20);
e3.LineWidth = 2;

e4 = errorbar(x_NEG_NT,  mean(mean_bis_negNT), std(mean_bis_negNT)/sqrt(numParticipants), 'Color', 'k','LineStyle','none','Marker','.', 'MarkerSize',20);
e4.LineWidth = 2;

e5 = errorbar(x_NU_NT,  mean(mean_bis_nuNT),  std(mean_bis_nuNT)/sqrt(numParticipants), 'Color', 'k','LineStyle','none','Marker','.', 'MarkerSize',20);
e5.LineWidth = 2; 

e6 = errorbar(x_POS_NT, mean(mean_bis_posNT), std(mean_bis_posNT)/sqrt(numParticipants), 'Color', 'k','LineStyle','none','Marker','.', 'MarkerSize',20);
e6.LineWidth = 2; 

%% ---------------------- AXIS FORMATTING ---------------------------------
set(gca, 'XTick', [NG, NU, POS], 'XTickLabel', {'NEG', 'NU', 'POS'},'TickDir', 'out','FontSize', 12);
set(gca, 'XTickLabelRotation', 0);

xlim([0 4])

%% ---------------------- ANNOTATION ---------------------------------

xAnnotationPos1 = 0.15
yAnnotationPos1 = 0.12
xAnnotationPos2 = 0.15;
yAnnotationPos2 = 0.085;
xAnnotationPos3 = 0.15;
yAnnotationPos3 =0.05
annotation('textbox', [xAnnotationPos1, yAnnotationPos1, 0.1, 0.1], 'String', 'Recall', 'EdgeColor', 'none', 'Color', edgeColorThink,'FontSize',14,'FontWeight','normal');
annotation('textbox', [xAnnotationPos2, yAnnotationPos2, 0.1, 0.1], 'String', 'Suppress', 'EdgeColor','none', 'Color', edgeColorNoThink, 'FontSize',14,'FontWeight','normal');

ax=gca;
ax.LineWidth = 2;
ylabel('Balance Integration Scores','FontSize',16)
xlabel('Affective Valence','FontSize', 16)
hold off;

%% ===================== ASSUMPTION CHECKS FOR STATS ANALYSIS ================================

fprintf('\n--- ASSUMPTION CHECKS FOR STATS ANALYSIS ---\n');

%% 1. Normality (Lilliefors test on difference scores)

% https://www.theanalysisfactor.com/checking-normality-anova-model/

data = {
    mean_bis_negT, 'Negative Recall';
    mean_bis_posT, 'Positive Recall';
    mean_bis_nuT,  'Neutral Recall';
    mean_bis_negNT,'Negative Suppress';
    mean_bis_posNT,'Positive Suppress';
    mean_bis_nuNT, 'Neutral Suppress'
};

for i = 1:size(data,1)
    x = data{i,1};
    label = data{i,2};
    
    [h, p] = lillietest(x);
    
    fprintf('Lilliefors test for normality (%s): p = %.5f\n', label, p);
    
    if h == 0
        fprintf('Normality: NOT violated\n\n');
    else
        fprintf('Normality: VIOLATED\n\n');
    end
end

%% ===================== STATISTICAL ANALYSIS -----------------------------

T = table(mean_bis_posT, mean_bis_posNT, mean_bis_negT, mean_bis_negNT, mean_bis_nuT, mean_bis_nuNT, ...
          'VariableNames', {'Pos_Think', 'Pos_NoThink', 'Neg_Think', 'Neg_NoThink', 'Nu_Think', 'Nu_NoThink'});
% Define the within-subject factors
% The first factor (Emotion) has 3 levels: Positive, Negative, Neutral
% The second factor (Task Instruction) has 2 levels: Think, NoThink
within = table({'Positive'; 'Positive'; 'Negative'; 'Negative'; 'Neutral'; 'Neutral'}, ...
               {'Think'; 'NoThink'; 'Think'; 'NoThink'; 'Think'; 'NoThink'}, ...
               'VariableNames', {'Emotion', 'TaskInstruction'});


% Fit the repeated measures model
rm = fitrm(T, 'Pos_Think-Nu_NoThink ~ 1', 'WithinDesign', within);

% Run repeated measures ANOVA
ranova_tbl = ranova(rm, 'WithinModel', 'Emotion*TaskInstruction');
disp(ranova_tbl);

%% ---------------------- EFFECT SIZE  -----------------------
% Extract sum of squares
SS_effect = ranova_tbl.SumSq(1); % for Emotion*Instruction interaction 
SS_error = ranova_tbl.SumSq(2); % for residual error

% Calculate Partial Eta Squared
partialEtaSquared = SS_effect / (SS_effect + SS_error);
fprintf('partial eta square = %.3f\n', partialEtaSquared);
%% ---------------------- POST-HOC -----------------------

% Perform post-hoc comparisons for the 'Emotion' factor
posthoc_emotion = multcompare(rm, 'Emotion', 'ComparisonType', 'bonferroni');
disp(posthoc_emotion);

% Perform post-hoc comparisons for the 'TaskInstruction' factor
posthoc_task = multcompare(rm, 'TaskInstruction', 'ComparisonType', 'bonferroni');
disp(posthoc_task);

% Perform post-hoc comparisons for the interaction 'task_instruction*emotion'
posthoc_interaction = multcompare(rm, 'TaskInstruction', 'By', 'Emotion', 'ComparisonType', 'bonferroni');
disp(posthoc_interaction); % https://www.mathworks.com/matlabcentral/answers/140799-3-way-repeated-measures-anova-pairwise-comparisons-using-multcompare

%% ===================== SAVE FIGURE (300 DPI) ============================

output_name = 'Figure2A';

% Save as PNG (300 dpi)
print(gcf, [output_name '.png'], '-dpng', '-r300');

% Save as TIFF (300 dpi)
print(gcf, [output_name '.tif'], '-dtiff', '-r300');


