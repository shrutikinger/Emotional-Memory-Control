%% FIGURE S3: Reliability of Balance Integration Scores
% -------------------------------------------------------------------------
% This script reproduces Figure S3 from the manuscript and completes:
%   - Condition-specific visualization 
%   - Statistical comparison between the conditions 
%   - Figure export (300 dpi)
%
%
% REQUIREMENTS:
%   - MATLAB (R2021a or later)
%   - Statistics and Machine Learning Toolbox 
%   - Data file: 'FigureS3.mat' in present working directory 
%
%
% OUTPUT:
%   - Figure replicating Figure S3
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

load FigureS3.mat

%% ===================== STATISTICAL ANALYSIS -----------------------------

[b_negT,stats_negT] = robustfit(h1_neg_recall_BIS, h2_neg_recall_BIS);
[b_nuT,stats_nuT] =  robustfit(h1_neu_recall_BIS, h2_neu_recall_BIS);
[b_posT,stats_posT] =  robustfit(h1_pos_recall_BIS, h2_pos_recall_BIS);

[b_negNT,stats_negNT] =  robustfit(h1_neg_supp_BIS, h2_neg_supp_BIS);
[b_nuNT,stats_nuNT] =  robustfit(h1_neu_supp_BIS, h2_neu_supp_BIS);
[b_posNT,stats_posNT] =  robustfit(h1_pos_supp_BIS, h2_pos_supp_BIS);


all_ps = [stats_posT stats_posNT stats_nuT stats_nuNT stats_negT stats_negNT]
all_slope = [b_posT b_posNT b_nuT b_nuNT b_negT b_negNT]


y_pred_negT = b_negT(1) + b_negT(2)*h1_neg_recall_BIS;
r_robust_negT = corr(h2_neg_recall_BIS, y_pred_negT);% coefficient of robust regression

y_pred_negNT = b_negNT(1) + b_negNT(2)*h1_neg_supp_BIS;
r_robust_negNT = corr(h2_neg_supp_BIS, y_pred_negNT);% coefficient of robust regression

y_pred_nuT = b_nuT(1) + b_nuT(2)*h1_neu_recall_BIS;
r_robust_nuT = corr(h2_neu_recall_BIS, y_pred_nuT);% coefficient of robust regression

y_pred_nuNT = b_nuNT(1) + b_nuNT(2)*h1_neu_supp_BIS;
r_robust_nuNT = corr(h2_neu_supp_BIS, y_pred_nuNT);% coefficient of robust regression

y_pred_posT = b_posT(1) + b_posT(2)*h1_pos_recall_BIS;
r_robust_posT = corr(h2_pos_recall_BIS, y_pred_posT);% coefficient of robust regression


y_pred_posNT = b_posNT(1) + b_posNT(2)*h1_pos_supp_BIS;
r_robust_posNT = corr(h2_pos_supp_BIS, y_pred_posNT);% coefficient of robust regression

%% Apply Spearman Brown correction 
r_neg_corr_recall = (2*r_robust_negT)/(1+r_robust_negT);
r_neu_corr_recall = (2*r_robust_nuT)/(1+r_robust_nuT);
r_pos_corr_recall = (2*r_robust_posT)/(1+r_robust_posT);

mean_reliability_recall = mean([r_neg_corr_recall r_neu_corr_recall r_pos_corr_recall])



r_neg_corr_supp = (2*r_robust_negNT)/(1+r_robust_negNT);
r_neu_corr_supp = (2*r_robust_nuNT)/(1+r_robust_nuNT);
r_pos_corr_supp = (2*r_robust_posNT)/(1+r_robust_posNT);

mean_reliability_supp = mean([r_neg_corr_supp r_neu_corr_supp r_pos_corr_supp])




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


X = {h1_neg_recall_BIS, h1_neg_supp_BIS, h1_neu_recall_BIS, h1_neu_supp_BIS, h1_pos_recall_BIS, h1_pos_supp_BIS};
Y = {h2_neg_recall_BIS, h2_neg_supp_BIS, h2_neu_recall_BIS, h2_neu_supp_BIS, h2_pos_recall_BIS, h2_pos_supp_BIS};

all_rs = {r_neg_corr_recall, r_neg_corr_supp,r_neu_corr_recall,r_neu_corr_supp, r_pos_corr_recall, r_pos_corr_supp};


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

    title(sprintf('%s (r= %.2f)', ...
        titlesTxt{i}, all_rs{i}));

    if showY(i)
        ylabel('Half2-BIS');
    end

    if showX(i)
        xlabel('Half1-BIS');
    end
end


set(findall(gcf,'Type','axes'), ...
    'LineWidth',1.5, ...
    'TickDir','out', ...
    'FontSize',10, ...
    'Box','off');

%% ===================== SAVE FIGURE (300 DPI) ============================

output_name = 'FigureS3'; 

% Save as PNG (300 dpi)
print(gcf, [output_name '.png'], '-dpng', '-r300');

% Save as TIFF (300 dpi)
print(gcf, [output_name '.tif'], '-dtiff', '-r300');