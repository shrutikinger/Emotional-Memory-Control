%% FIGURE S4: Accuracy (2(task instructions:Recall, Suppress) x 3 (emotions: Negative, Neutral, Positive))
% -------------------------------------------------------------------------
% This script reproduces Figure S4 from the manuscript and completes:
%   - Condition-specific visualization 
%   - Statistical comparison between the conditions 
%   - Figure export (300 dpi)
%
%
% REQUIREMENTS:
%   - MATLAB (R2021a or later)
%   - Statistics and Machine Learning Toolbox 
%   - Data file: 'FigureS4.mat' in present working directory 
%
%
% OUTPUT:
%   - Figure replicating Figure S4
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
load FigureS4.mat

sample_size = length(NEG_Thk_correct);

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


POS_Thk_CORRECT = zscore(POS_Thk_CORRECT);
POS_NT_CORRECT = zscore(POS_NT_CORRECT);
NEG_Thk_correct = zscore(NEG_Thk_correct);
NEG_NT_correct =zscore(NEG_NT_correct);
NU_Thk_correct =zscore(NU_Thk_correct);
NU_NT_correct = zscore(NU_NT_correct);


Ymat = [NEG_Thk_correct(:), NEG_NT_correct(:), ...
        NU_Thk_correct(:),  NU_NT_correct(:), ...
        POS_Thk_CORRECT(:), POS_NT_CORRECT(:)];



%% ----------- PARTICIPANT-LEVEL CONNECTING LINES -------------------------

X = [x_NEG, x_NEG_NT, x_NU, x_NU_NT, x_POS, x_POS_NT];
plot(X, Ymat', '-', ...
    'Color', [0.6 0.6 0.6], ...
    'LineWidth', 0.5);

%% ---------------------- SCATTER: RECALL ----------------------------------



Y = {NEG_Thk_correct, NU_Thk_correct, POS_Thk_CORRECT, ...
     NEG_NT_correct,  NU_NT_correct,  POS_NT_CORRECT};

Ymean = {NEG_Thk_correct, NU_Thk_correct, POS_Thk_CORRECT, ...
         NEG_NT_correct,  NU_NT_correct,  POS_NT_CORRECT};

faceColors = {thinkFaceColor, thinkFaceColor, thinkFaceColor, ...
              noThinkFaceColor, noThinkFaceColor, noThinkFaceColor};

edgeColors = {edgeColorThink, edgeColorThink, edgeColorThink, ...
              edgeColorNoThink, edgeColorNoThink, edgeColorNoThink};



for i = 1:6
    
    % --- filled layer ---
    scatter(X(i), Y{i}, 250, 's', ...
        'MarkerEdgeColor', 'none', ...
        'MarkerFaceColor', faceColors{i}, ...
        'LineWidth', 2);
    
    hold on
    
    % --- outline layer ---
    scatter(X(i), Y{i}, 250, 's', ...
        'MarkerEdgeColor', edgeColors{i}, ...
        'MarkerFaceColor', 'none', ...
        'LineWidth', 2);
    
    % --- mean point ---
    scatter(X(i), mean(Y{i}), 250, 's', ...
        'filled', 'MarkerFaceColor', 'k');
    
    % --- error bar ---
    errorbar(X(i), ...
        mean(Ymean{i}), ...
        std(Ymean{i})/sqrt(sample_size), ...
        'Color', 'k', ...
        'LineStyle', 'none', 'LineWidth', 2,...
        'Marker', '.', ...
        'MarkerSize', 10);
end





%% ---------------------- AXIS FORMATTING ---------------------------------
set(gca, 'XTick', [NG, NU, POS], 'XTickLabel', {'Negative', 'Neutral', 'Positive'},'TickDir', 'out','FontSize', 12);
set(gca, 'XTickLabelRotation', 0);

xlabel('Affective Valence','FontSize',14);
ylabel('Accuracy (z-scores)','FontSize',14);

xlim([0 4])
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
hold off;


%% ===================== ASSUMPTION CHECKS FOR STATS ANALYSIS ================================

fprintf('\n--- ASSUMPTION CHECKS FOR STATS ANALYSIS ---\n');

%% 1. Normality (Lilliefors test on difference scores)

% https://www.theanalysisfactor.com/checking-normality-anova-model/

data = {
    NEG_Thk_correct, 'Negative Recall';
    POS_Thk_CORRECT, 'Positive Recall';
    NU_Thk_correct,  'Neutral Recall';
    NEG_NT_correct,'Negative Suppress';
    POS_NT_CORRECT,'Positive Suppress';
    NU_NT_correct, 'Neutral Suppress'
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

data_test = [NEG_Thk_correct' NEG_NT_correct' NEG_Thk_correct' NEG_NT_correct' POS_Thk_CORRECT' POS_NT_CORRECT'];

[p, tbl, stats] = friedman(data_test)


%% ===================== SAVE FIGURE (300 DPI) ============================


% Save as PNG (300 dpi)
exportgraphics(gca,'FigureS4.png','Resolution',300);

% Save as TIFF (300 dpi)
exportgraphics(gca,'FigureS4.tif','Resolution',300);