%% FIGURE 5: % Interaction effect - behaviour (BIS) X anxiety and resting state functional connectivity
% -------------------------------------------------------------------------
% This script reproduces Figure 5B/Figure 5D from the manuscript and completes:
%   - Condition-specific visualization 
%   - Statistical comparison between the conditions 
%   - Figure export (300 dpi)
%
%
% REQUIREMENTS:
%   - MATLAB (R2021a or later)
%   - Statistics and Machine Learning Toolbox 
%   - Data file: 'Figure5$.mat' in present working directory 
%   - dependencies: error_ellipse.m in present working directory 
%
%
% OUTPUT:
%   - Figure replicating Figure 5B, 5D
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

load Figure5D.mat

cluster = round(data,3);
zscore_cluster = zscore(cluster)

behaviour = round(mean_bis_posT, 3);

anxiety_scores = round(FearAffect, 3);


idx_highFA = find(anxiety_scores > median(anxiety_scores)); % high anxiety
idx_lowFA = find(anxiety_scores <=median(anxiety_scores)); % low anxiety

score_bis_low = behaviour(idx_lowFA);
score_rsfc_low = cluster(idx_lowFA);

score_bis_high = behaviour(idx_highFA);
score_rsfc_high = cluster(idx_highFA);



%% --------------------------- DEFINE COLORS ---------------------------------------
edgeColor_lowAnx   = [0, 0, 128/255];        % Dark blue
edgeColor_highAnx = [153/255, 0, 0];        % Dark red

% Lighter fill colors
lowAnxFaceColor   = edgeColor_lowAnx   + (1 - edgeColor_lowAnx) * 0.8;
highAnxFaceColor = edgeColor_highAnx + (1 - edgeColor_highAnx) * 0.8;
jitterAmount = 0.05;


%% --------------------------- FIGURE SETUP -------------------------------
figure('Color', 'w', 'Position', [100, 100, 600, 600]);

hold on;

%% --------------------------- SCATTER -------------------------------

% take z-score of rsFC for plotting
zscore_rsfc_low = zscore(score_rsfc_low);
zscore_rsfc_high = zscore(score_rsfc_high);

% Add jitter to low FA scores
jittered_bp_low = score_bis_low + (rand(size(score_bis_low)) - 0.5) * jitterAmount;
jittered_rsfc_low = zscore_rsfc_low + (rand(size(zscore_rsfc_low)) - 0.5) * jitterAmount;

% Add jitter to high FA scores
jittered_bp_high = score_bis_high + (rand(size(score_bis_high)) - 0.5) * jitterAmount;
jittered_rsfc_high = zscore_rsfc_high + (rand(size(zscore_rsfc_high)) - 0.5) * jitterAmount;


scatter(jittered_bp_low, jittered_rsfc_low, 'MarkerFaceColor', lowAnxFaceColor, 'MarkerEdgeColor','none', 'LineWidth',2, 'Marker','^','SizeData',300)

scatter(jittered_bp_high, jittered_rsfc_high, 'MarkerFaceColor', highAnxFaceColor, 'MarkerEdgeColor','none', 'LineWidth',2, 'Marker','o', 'SizeData',300)


h = lsline;
set(h(1), 'Color', edgeColor_highAnx, 'LineWidth', 5,'LineStyle','-'); % First line for high FA
set(h(2), 'Color',edgeColor_lowAnx, 'LineWidth', 5,'LineStyle',":"); % Second line for low FA


scatter(jittered_bp_low, jittered_rsfc_low,  'MarkerEdgeColor', edgeColor_lowAnx, 'MarkerFaceColor','none', 'LineWidth',2, 'Marker','^','SizeData',300)
scatter(jittered_bp_high, jittered_rsfc_high, 'MarkerEdgeColor', edgeColor_highAnx, 'MarkerFaceColor', 'none', 'LineWidth',2, 'Marker','o', 'SizeData',300)


text1 = sprintf('\x25B3 Low Anxiety'); % open triangle
text2 = sprintf('\x25CB High Anxiety'); % open circle


annotation('textbox', [0.15, 0.84, 0.1, 0.1], 'String', text1, 'Color',edgeColor_lowAnx, 'FontSize', 14, 'FontWeight', 'normal', 'EdgeColor', 'none');
annotation('textbox', [0.15,0.79, 0.1, 0.1], 'String', text2, 'Color',edgeColor_highAnx, 'FontSize', 14, 'FontWeight', 'normal', 'EdgeColor', 'none');

%% ---------------------- AXIS FORMATTING ---------------------------------
ax = gca;
ax.LineWidth = 1.5; % Axis line width
ax.FontSize = 16;
ax.XTickLabelMode = 'auto';
ax.XAxisLocation = 'bottom';
ax.XTickLabelRotation = 0; % Set rotation if needed
ax.TickDir = 'out';

xlabel('BIS (z-scores)')
ylabel('Resting state functional connectivity (z-scores)')

ylim([-3 3])
xlim([-3 3])


%% ===================== ASSUMPTION CHECKS FOR STATS ANALYSIS ================================

fprintf('\n--- ASSUMPTION CHECKS FOR STATS ANALYSIS ---\n');

%% 1. Normality (Lilliefors test on individual scores)

data = {
    behaviour, 'BIS';
    cluster, 'rsFC';
    score_bis_low, 'BIS-lowAnx';
    score_rsfc_low, 'rsFC-lowAnx';
    score_bis_high, 'BIS-highAnx';
    score_rsfc_high, 'rsFC-highAnx';
    
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


lower_bound = -3;
upper_bound = 3;




for i = 1:size(data,1)
    x = data{i,1};
    label = data{i,2};
    
    outliers = x < lower_bound | x > upper_bound;
    numOutliers = sum(outliers);
    
    fprintf('%sOutliers detected: %d\n', label, numOutliers);
    
    if numOutliers > 0
        fprintf('  Indices: ');
        disp(find(outliers)');
    else
        fprintf('  No outliers detected\n');
    end
    
    fprintf('\n'); % spacing
end

%% ===================== STATISTICAL ANALYSIS -----------------------------


[r_low, p_low] = corrcoef(score_bis_low, score_rsfc_low);


r_lowAnx = r_low(1,2);
p_lowAnx = p_low(1,2);
mdl_lowAnx = fitlm(score_bis_low, score_rsfc_low);
slope_lowAnx = mdl_lowAnx.Coefficients.Estimate(2);


[r_high, p_high] = corrcoef(score_bis_high, score_rsfc_high);

r_highAnx = r_high(1,2);
p_highAnx = p_high(1,2);
mdl_highAnx = fitlm(score_bis_high, score_rsfc_high);
slope_highAnx = mdl_highAnx.Coefficients.Estimate(2);

zHigh = 0.5 * log((1 + r_highAnx)/(1 - r_highAnx));
zLow = 0.5 * log((1 + r_lowAnx)/(1 - r_lowAnx));
SE_high = 1 / sqrt(length(score_rsfc_high) - 3);
SE_low = 1/ sqrt(length(score_rsfc_low) - 3);

z_crit = 1.96; % for 95% CI
z_lower_HA = zHigh - z_crit * SE_high;
z_upper_HA = zHigh + z_crit * SE_high;

z_lowerLowAnx = zLow - z_crit * SE_low;
z_upperLowAnx = zLow + z_crit * SE_low;

% transform to r -space
r_lower_HA = (exp(2*z_lower_HA) - 1) / (exp(2*z_lower_HA) + 1);
r_upper_HA = (exp(2*z_upper_HA) - 1) / (exp(2*z_upper_HA) + 1);

r_lower_LA = (exp(2*z_lowerLowAnx) - 1) / (exp(2*z_lowerLowAnx) +1);
r_upper_LA = (exp(2*z_upperLowAnx) -1) / (exp(2*z_upperLowAnx) +1);

fprintf('\n')
fprintf('Pearson''s r: %.4f, p-value: %.4f, Slope: %.4f, r CI: [%.4f, %.4f]\n', ...
    r_lowAnx, p_lowAnx, slope_lowAnx, r_lower_LA, r_upper_LA);
fprintf('\n')
fprintf('Pearson''s r: %.4f, p-value: %.4f, Slope: %.4f\n, r CI: [%.4f, %.4f]\n', ...
    r_highAnx, p_highAnx, slope_highAnx, r_lower_HA, r_upper_HA);



%% ===================== CONFIDENCE ELLIPSIS -----------------------------

cov_low = cov(score_bis_low, zscore_rsfc_low);
cov_high = cov(score_bis_high, zscore_rsfc_high);


mean_low = mean([score_bis_low, zscore_rsfc_low]);
mean_high = mean([score_bis_high, zscore_rsfc_high]);

h_low = error_ellipse(cov_low, mean_low, 'conf', 0.95);
h_high = error_ellipse(cov_high, mean_high, 'conf', 0.95);

set(h_low, 'Color',edgeColor_lowAnx,'LineWidth',3); % Set color for low anxiety ellipse
set(h_high, 'Color',edgeColor_highAnx,'LineWidth',3);  % Set color for high anxiety ellipse


%% ===================== SAVE FIGURE (300 DPI) ============================

output_name = 'Figure5B'; %for Figure5D: change it to Figure5D

% Save as PNG (300 dpi)
print(gcf, [output_name '.png'], '-dpng', '-r300');

% Save as TIFF (300 dpi)
print(gcf, [output_name '.tif'], '-dtiff', '-r300');

