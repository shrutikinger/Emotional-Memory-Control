%% FIGURE S7: Correlation between Balance Integration Scores & Reaction Time
% -------------------------------------------------------------------------
% This script reproduces Figure S7 from the manuscript and completes:
%   - Condition-specific visualization 
%   - Statistical comparison between the conditions 
%   - Figure export (300 dpi)
%
%
% REQUIREMENTS:
%   - MATLAB (R2021a or later)
%   - Statistics and Machine Learning Toolbox 
%   - Data file: 'FigureS7.mat' in present working directory 
%
%
% OUTPUT:
%   - Figure replicating Figure S7
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

load FigureS7.mat

%% ===================== STATISTICAL ANALYSIS -----------------------------

[b_posT,stats_posT] = robustfit(mean_bis_posT',zscore(POS_Thk_CORRECT_RT'));
[b_posNT,stats_posNT] = robustfit( mean_bis_posNT',zscore(POS_NT_CORRECT_RT'));

[b_nuT,stats_nuT] =robustfit( mean_bis_nuT',zscore(NU_Thk_correct_RT'));
[b_nuNT,stats_nuNT] = robustfit(mean_bis_nuNT',zscore(NU_NT_correct_RT'));

[b_negT,stats_negT] = robustfit( mean_bis_negT',zscore(NEG_Thk_correct_RT'));
[b_negNT,stats_negNT] = robustfit( mean_bis_negNT',zscore(NEG_NT_correct_RT'));

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

X = {mean_bis_negT, mean_bis_negNT, mean_bis_nuT, mean_bis_nuNT, mean_bis_posT, mean_bis_posNT};
Y = {zscore(NEG_Thk_correct_RT), zscore(NEG_NT_correct_RT), zscore(NU_Thk_correct_RT), zscore(NU_NT_correct_RT),...
    zscore(POS_Thk_CORRECT_RT), zscore(POS_NT_CORRECT_RT)};


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
        ylabel('Reaction Time');
    end

    if showX(i)
        xlabel('BIS');
    end
end


set(findall(gcf,'Type','axes'), ...
    'LineWidth',1.5, ...
    'TickDir','out', ...
    'FontSize',10, ...
    'Box','off');



%% --------------- COEFFICIENT OF ROBUST REGRESSION----------------
y_pred_negT = b_negT(1) + b_negT(2)*mean_bis_negT';
r_robust_negT = corr(zscore(NEG_Thk_correct_RT)', y_pred_negT');% coefficient of robust regression




y_pred_negNT = b_negNT(1) + b_negNT(2)*mean_bis_negNT';
r_robust_negNT = corr(zscore(NEG_NT_correct_RT)', y_pred_negNT');% coefficient of robust regression


y_pred_nuT = b_negNT(1) + b_negNT(2)*mean_bis_negNT';
r_robust_nuT = corr(zscore(NU_Thk_correct_RT)', y_pred_nuT');% coefficient of robust regression

y_pred_nuNT = b_nuNT(1) + b_nuNT(2)*mean_bis_nuNT';
r_robust_nuNT = corr(zscore(NU_NT_correct_RT)', y_pred_nuNT');% coefficient of robust regression


y_pred_posT = b_posT(1) + b_posT(2)*mean_bis_posT';
r_robust_posT = corr(zscore(POS_Thk_CORRECT_RT)', y_pred_posT');% coefficient of robust regression

y_pred_posNT = b_posNT(1) + b_posNT(2)*mean_bis_posNT';
r_robust_posNT = corr(zscore(POS_NT_CORRECT_RT)', y_pred_posNT');% coefficient of robust regression


%% ===================== SAVE FIGURE (300 DPI) ============================

output_name = 'FigureS7'; 

% Save as PNG (300 dpi)
print(gcf, [output_name '.png'], '-dpng', '-r300');

% Save as TIFF (300 dpi)
print(gcf, [output_name '.tif'], '-dtiff', '-r300');