%% FIGURE S1: Correlation between Balance Integration Scores and Working memory capacity
% -------------------------------------------------------------------------
% This script reproduces Figure S1 from the manuscript and completes:
%   - Condition-specific visualization 
%   - Statistical comparison between the conditions 
%   - Figure export (300 dpi)
%
%
% REQUIREMENTS:
%   - MATLAB (R2021a or later)
%   - Statistics and Machine Learning Toolbox 
%   - Data file: 'FigureS1.mat' in present working directory 
%
%
% OUTPUT:
%   - Figure replicating Figure S1
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
load FigureS1.mat


%% ===================== STATISTICAL ANALYSIS -----------------------------

k_negT = zscore(k_negT);
k_negNT = zscore(k_negNT);
k_posT = zscore(k_posT);
k_posNT = zscore(k_posNT);
k_nuT = zscore(k_nuT);
k_nuNT = zscore(k_nuNT);

[b_negT,stats_negT] = robustfit( negT',k_negT');
[b_posT,stats_posT] = robustfit( posT',k_posT);
[b_nuT,stats_nuT] =robustfit(  nuT',k_nuT');


[b_posNT,stats_posNT] = robustfit( posNT',k_posNT');
[b_nuNT,stats_nuNT] = robustfit( nuNT',k_nuNT');
[b_negNT,stats_negNT] = robustfit( negNT',k_negNT');

%% --------------------------- DEFINE COLOURS ----------------------------------

RecallColor = [0 0 128/255]; %BLUE;
SuppColor2 = [153/255 0 0]; % red


SuppFaceColor = SuppColor2 + (1 - SuppColor2) * 0.8;
RecallFaceColor = RecallColor + (1 - RecallColor) * 0.8; %blend factor =0.5

%% --------------------------- FIGURE SETUP -------------------------------
figure('Color', 'w', 'Position', [100, 100, 600, 600]);

hold on;

t = tiledlayout(3,2,'TileSpacing','compact','Padding','loose');

title(t, '') 


ax1 = nexttile(1);
pos1 = ax1.Position;
annotation('textbox',[pos1(1) 0.96 pos1(3) 0.04], ...
    'String','Recall','EdgeColor','none','HorizontalAlignment','center','FontWeight','bold');

ax2 = nexttile(2);
pos2 = ax2.Position;
annotation('textbox',[pos2(1) 0.96 pos2(3) 0.04], ...
    'String','Suppression','EdgeColor','none','HorizontalAlignment','center','FontWeight','bold');

%% --------------------------- SCATTER PLOTS ----------------------------------

X = {negT, negNT, nuT, nuNT, posT, posNT};
Y = {k_negT, k_negNT, k_nuT, k_nuNT, k_posT, k_posNT};

B = {b_negT, b_negNT, b_nuT, b_nuNT, b_posT, b_posNT};
STATS = {stats_negT, stats_negNT, stats_nuT, stats_nuNT, stats_posT, stats_posNT};

edgeColors = {RecallColor, SuppColor2, RecallColor, SuppColor2, RecallColor, SuppColor2};
faceColors = {RecallFaceColor, SuppFaceColor, RecallFaceColor, SuppFaceColor, RecallFaceColor, SuppFaceColor};
lineStyles = {'-',':', '-', ':', '-', ':'}; % fix typo if needed

titlesTxt = {'Negative','Negative','Neutral','Neutral','Positive','Positive'};

showY = [true false true false true false];
showX = [false false false false true true];

% Loop through tiles
for i = 1:6
    nexttile(i)

    scatter(X{i}, Y{i}, ...
        'MarkerEdgeColor', edgeColors{i}, ...
        'MarkerFaceColor', faceColors{i}, ...
        'LineWidth', 1, ...
        'Marker', 'o', ...
        'SizeData', 50);

    h = lsline;
    set(h(1), 'Color', edgeColors{i}, ...
              'LineWidth', 2, ...
              'LineStyle', lineStyles{i});

    title(sprintf('%s (slope = %.2f, p = %.3f)', ...
        titlesTxt{i}, B{i}(2), STATS{i}.p(2)));

    if showY(i)
        ylabel('WM capacity (z-scores)');
    end

    if showX(i)
        xlabel('BIS (z-scores)');
    end
end


set(findall(gcf,'Type','axes'), ...
    'LineWidth',1.5, ...
    'TickDir','out', ...
    'FontSize',10, ...
    'Box','off');

%% ===================== COEFFICIENT OF ROBUST REGRESSION ============================

y_pred_negT = b_negT(1) + b_negT(2)*negT';
r_robust_negT = corr(k_negT', y_pred_negT);

y_pred_negNT = b_negNT(1) + b_negNT(2)*negNT';
r_robust_negNT = corr(k_negNT', y_pred_negNT);

y_pred_nuT = b_nuT(1) + b_nuT(2)*nuT';
r_robust_nuT = corr(k_nuT', y_pred_nuT);

y_pred_nuNT = b_nuNT(1) + b_nuNT(2)*nuNT';
r_robust_nuNT = corr(k_nuNT', y_pred_nuNT);

y_pred_posT = b_posT(1) + b_posT(2)*posT';
r_robust_posT = corr(k_posT', y_pred_posT);

y_pred_posNT = b_posNT(1) + b_posNT(2)*posNT';
r_robust_posNT = corr(k_posNT', y_pred_posNT);



%% ===================== SAVE FIGURE (300 DPI) ============================

output_name = 'FigureS1'; 

% Save as PNG (300 dpi)
print(gcf, [output_name '.png'], '-dpng', '-r300');

% Save as TIFF (300 dpi)
print(gcf, [output_name '.tif'], '-dtiff', '-r300');
