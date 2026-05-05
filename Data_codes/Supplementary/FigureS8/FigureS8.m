%% FIGURE S8: Correlation between Working memory capacity & Accuracy
% -------------------------------------------------------------------------
% This script reproduces Figure S8 from the manuscript and completes:
%   - Condition-specific visualization 
%   - Statistical comparison between the conditions 
%   - Figure export (300 dpi)
%
%
% REQUIREMENTS:
%   - MATLAB (R2021a or later)
%   - Statistics and Machine Learning Toolbox 
%   - Data file: 'FigureS8.mat' in present working directory 
%
%
% OUTPUT:
%   - Figure replicating Figure S8
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
load FigureS8.mat

%% ===================== STATISTICAL ANALYSIS -----------------------------

[b_posT,stats_posT] = robustfit( k_posT',zscore(POS_Thk_CORRECT'));
[b_posNT,stats_posNT] = robustfit( k_posNT',zscore(POS_NT_CORRECT'));

[b_nuT,stats_nuT] =robustfit( k_nuT',zscore(NU_Thk_correct'));
[b_nuNT,stats_nuNT] = robustfit( k_nuNT',zscore(NU_NT_correct'));

[b_negT,stats_negT] = robustfit( k_negT',zscore(NEG_Thk_correct'));
[b_negNT,stats_negNT] = robustfit( k_negNT',zscore(NEG_NT_correct'));

B = {b_negT, b_negNT, b_nuT, b_nuNT, b_posT, b_posNT};
STATS = {stats_negT, stats_negNT, stats_nuT, stats_nuNT, stats_posT, stats_posNT};

%% --------------------------- DEFINE COLOURS ----------------------------------

RecallColor = [0 0 128/255]; %BLUE;
SuppColor2 = [153/255 0 0]; % red


SuppFaceColor = SuppColor2 + (1 - SuppColor2) * 0.8;
RecallFaceColor = RecallColor + (1 - RecallColor) * 0.8; %blend factor =0.5


%% --------------------------- FIGURE SETUP -------------------------------
figure('Color', 'w', 'Position', [100, 100, 600, 600]);

t = tiledlayout(3,2,'TileSpacing','compact','Padding','loose');

% ---- Column titles ----
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

X = {zscore(k_negT), zscore(k_negNT), zscore(k_nuT), zscore(k_nuNT), zscore(k_posT), zscore(k_posNT)};
Y = {zscore(NEG_Thk_correct), zscore(NEG_NT_correct), zscore(NU_Thk_correct), zscore(NU_NT_correct),...
    zscore(POS_Thk_CORRECT), zscore(POS_NT_CORRECT)};


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

    title(sprintf('%s (slope = %.2f)', ...
        titlesTxt{i}, B{i}(2)));

    if showY(i)
        ylabel('Accuracy');
    end

    if showX(i)
        xlabel('Working memory capacity');
    end
end


set(findall(gcf,'Type','axes'), ...
    'LineWidth',1.5, ...
    'TickDir','out', ...
    'FontSize',10, ...
    'Box','off');



%% --------------- COEFFICIENT OF ROBUST REGRESSION----------------

y_pred_negT = b_negT(1) + b_negT(2)*k_negT';
r_robust_negT = corr(zscore(NEG_Thk_correct)', y_pred_negT);% coefficient of robust regression

y_pred_negNT = b_negNT(1) + b_negNT(2)*k_negNT';
r_robust_negNT = corr(zscore(NEG_NT_correct(:)), y_pred_negNT(:));% coefficient of robust regression

y_pred_nuT = b_nuT(1) + b_nuT(2)*k_nuT';
r_robust_nuT = corr(zscore(NU_Thk_correct(:)), y_pred_nuT(:));;% coefficient of robust regression

y_pred_nuNT = b_nuNT(1) + b_nuNT(2)*k_nuNT';
r_robust_nuNT = corr(zscore(NU_NT_correct(:)), y_pred_nuNT(:));% coefficient of robust regression

y_pred_posT = b_posT(1) + b_posT(2)*k_posT';
r_robust_posT = corr(zscore(POS_Thk_CORRECT(:)), y_pred_posT(:));% coefficient of robust regression


y_pred_posNT = b_posNT(1) + b_posNT(2)*k_posNT';
r_robust_posNT = corr(zscore(POS_NT_CORRECT(:)), y_pred_posNT(:));% coefficient of robust regression



%% ===================== SAVE FIGURE (300 DPI) ============================

output_name = 'FigureS8'; 

% Save as PNG (300 dpi)
print(gcf, [output_name '.png'], '-dpng', '-r300');

% Save as TIFF (300 dpi)
print(gcf, [output_name '.tif'], '-dtiff', '-r300');