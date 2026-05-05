%% FIGURE 2B: Sensitivity Analysis (Recall vs. Suppress condition)
% -------------------------------------------------------------------------
% This script reproduces Figure 2B from the manuscript and completes:
%   - Condition-specific visualization 
%   - Statistical comparison between the conditions 
%   - Figure export (300 dpi)
%
%
% REQUIREMENTS:
%   - MATLAB (R2021a or later)
%   - Statistics and Machine Learning Toolbox 
%   - Data file: 'Figure2B.mat' in present working directory 
%
%
% OUTPUT:
%   - Figure replicating Figure 2B
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
load('Figure2B.mat');

numParticipants = length(mean_all_think_d_prime);

%% --------------------------- DEFINE COLORS ---------------------------------------
edgeColorThink   = [0, 0, 128/255];        % Dark blue
edgeColorNoThink = [153/255, 0, 0];        % Dark red

% Lighter fill colors
thinkFaceColor   = edgeColorThink   + (1 - edgeColorThink) * 0.8;
noThinkFaceColor = edgeColorNoThink + (1 - edgeColorNoThink) * 0.8;

%% --------------------------- FIGURE SETUP -------------------------------
figure('Color', 'w', 'Position', [100, 100, 600, 600]);
hold on;

THINK_POS   = 0.1;
NOTHINK_POS = 0.2;

%% ----------- PARTICIPANT-LEVEL CONNECTING LINES -------------------------
for i = 1:numParticipants
    plot([THINK_POS, NOTHINK_POS], ...
         [mean_all_think_d_prime(i), mean_all_NT_d_prime(i)], ...
         '-', 'Color', [0.7, 0.7, 0.7], 'LineWidth', 0.75);
end

%% ---------------------- SCATTER: RECALL ----------------------------------
xThink = repmat(THINK_POS, numParticipants, 1);

% Filled markers
scatter(xThink, mean_all_think_d_prime, 250, 's', ...
    'MarkerEdgeColor', 'none', ...
    'MarkerFaceColor', thinkFaceColor);

% Outline
scatter(xThink, mean_all_think_d_prime, 300, 's', ...
    'MarkerEdgeColor', edgeColorThink, ...
    'MarkerFaceColor', 'none', ...
    'LineWidth', 2);

%% ---------------------- SCATTER: SUPPRESS-------------------------------
xNoThink = repmat(NOTHINK_POS, numParticipants, 1);

% Filled markers
scatter(xNoThink, mean_all_NT_d_prime, 250, 's', ...
    'MarkerEdgeColor', 'none', ...
    'MarkerFaceColor', noThinkFaceColor);

% Outline
scatter(xNoThink, mean_all_NT_d_prime, 300, 's', ...
    'MarkerEdgeColor', edgeColorNoThink, ...
    'MarkerFaceColor', 'none', ...
    'LineWidth', 2);

%% ---------------------- GROUP MEANS + STD. ERROR -----------------------------
% Think condition
meanThink = mean(mean_all_think_d_prime);
semThink  = std(mean_all_think_d_prime) / sqrt(numParticipants);

scatter(THINK_POS, meanThink, 300, 'o', ...
    'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');

errorbar(THINK_POS, meanThink, semThink, 'k', ...
    'LineStyle', 'none', 'LineWidth', 1.5);

% No-Think condition
meanNoThink = mean(mean_all_NT_d_prime);
semNoThink  = std(mean_all_NT_d_prime) / sqrt(numParticipants);

scatter(NOTHINK_POS, meanNoThink, 300, 'o', ...
    'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');

errorbar(NOTHINK_POS, meanNoThink, semNoThink, 'k', ...
    'LineStyle', 'none', 'LineWidth', 1.5);

%% ---------------------- AXIS FORMATTING ---------------------------------
set(gca, ...
    'XTick', [THINK_POS, NOTHINK_POS], ...
    'XTickLabel', {'Recall', 'Suppress'}, ...
    'TickDir', 'out', ...
    'FontSize', 16, ...
    'LineWidth', 2);

ylabel('Sensitivity (d'')', 'FontSize', 16);
xlabel('Task instructions','FontSize',16)
xlim([0, 0.3]);
box off;

hold off;

%% ===================== ASSUMPTION CHECKS FOR STATS ANALYSIS ================================

fprintf('\n--- ASSUMPTION CHECKS FOR STATS ANALYSIS ---\n');

%% 1. Normality (Lilliefors test on difference scores)
diff_scores = mean_all_think_d_prime - mean_all_NT_d_prime;

[h_norm, p_norm] = lillietest(diff_scores);

fprintf('Lilliefors test for normality: p = %.5f\n', p_norm);

if h_norm == 0
    fprintf('Normality assumption: NOT violated\n');
else
    fprintf('Normality assumption: VIOLATED\n');
end

%% 2. Outlier detection (zscore method)
zscore_diff_scores = zscore(diff_scores);
lower_bound = -3;
upper_bound = 3;

outliers = zscore_diff_scores < lower_bound | zscore_diff_scores > upper_bound;
numOutliers = sum(outliers);

fprintf('Outliers detected: %d\n', numOutliers);

if numOutliers > 0
    fprintf('Outlier indices: ');
    disp(find(outliers)');
else
    fprintf('No significant outliers detected\n');
end

%% ===================== STATISTICAL ANALYSIS -----------------------------

fprintf('\n--- PAIRED T-TEST ---\n');

[h, p, ci, stats] = ttest(mean_all_think_d_prime, mean_all_NT_d_prime);

fprintf('t(%d) = %.3f, p = %.5f\n', stats.df, stats.tstat, p);

%% ---------------------- EFFECT SIZE  -----------------------
cohens_d = mean(diff_scores) / std(diff_scores);

fprintf('Cohen''s d = %.3f\n', cohens_d);

%% ===================== SAVE FIGURE (300 DPI) ============================

output_name = 'Figure2B';

% Save as PNG (300 dpi)
print(gcf, [output_name '.png'], '-dpng', '-r300');

% Save as TIFF (300 dpi)
print(gcf, [output_name '.tif'], '-dtiff', '-r300');

