%% FIGURE 7: % Correlation between Behaviour (BIS) & resting state functional connectivity (Positive Recall vs Positive Suppression)
% -------------------------------------------------------------------------
% This script reproduces Figure 7B from the manuscript and completes:
%   - Condition-specific visualization 
%   - Statistical comparison between the conditions 
%   - Figure export (300 dpi)
%
%
% REQUIREMENTS:
%   - MATLAB (R2021a or later)
%   - Statistics and Machine Learning Toolbox 
%   - Data file: 'Figure7B.mat' in present working directory 
%   - dependencies: error_ellipse.m in present working directory 
%
%
% OUTPUT:
%   - Figure replicating Figure 7B
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

load Figure7.mat

score_bis_cond1 = mean_bis_posT;
score_rsfc_cond1 = zscore(data);

score_bis_cond2 = mean_bis_posNT;
score_rsfc_cond2 = zscore(data);

%% --------------------------- DEFINE COLORS ---------------------------------------

edgeColor = [0 0 128/255]; %BLUE;
edgeColor2 = [153/255 0 0]; % red

cond2FaceColor = edgeColor2 + (1 - edgeColor2) * 0.8;
cond1FaceColor = edgeColor + (1 - edgeColor) * 0.8; %blend factor =0.5
jitterAmount = 0.05;


%% --------------------------- FIGURE SETUP -------------------------------
figure('Color', 'w', 'Position', [100, 100, 600, 600]);

hold on;

%% --------------------------- SCATTER -------------------------------

jittered_bp_cond1= score_bis_cond1 + (rand(size(score_bis_cond1)) - 0.5) * jitterAmount;
jittered_rsfc_cond1 = score_rsfc_cond1 + (rand(size(score_rsfc_cond1)) - 0.5) * jitterAmount;

jittered_bp_cond2 = score_bis_cond2 + (rand(size(score_bis_cond2)) - 0.5) * jitterAmount;
jittered_rsfc_cond2 = score_rsfc_cond2 + (rand(size(score_rsfc_cond2)) - 0.5) * jitterAmount;

scatter(jittered_bp_cond1, jittered_rsfc_cond1, 'MarkerFaceColor', cond1FaceColor, 'MarkerEdgeColor','none', 'LineWidth',2, 'Marker','^','SizeData',300)
hold on
scatter(jittered_bp_cond2, jittered_rsfc_cond2, 'MarkerFaceColor', cond2FaceColor, 'MarkerEdgeColor','none', 'LineWidth',2, 'Marker','o', 'SizeData',300)


h = lsline;
set(h(1), 'Color', edgeColor2, 'LineWidth', 5,'LineStyle','-'); % First line for high FA
set(h(2), 'Color',edgeColor, 'LineWidth', 5,'LineStyle',":"); % Second line for low FA


scatter(jittered_bp_cond1, jittered_rsfc_cond1,  'MarkerEdgeColor', edgeColor, 'MarkerFaceColor','none', 'LineWidth',2, 'Marker','o','SizeData',300)
scatter(jittered_bp_cond2, jittered_rsfc_cond2, 'MarkerEdgeColor', edgeColor2, 'MarkerFaceColor', 'none', 'LineWidth',2, 'Marker','^', 'SizeData',300)

%% ---------------------- AXIS FORMATTING ---------------------------------

ax = gca;
ax.LineWidth = 2; % Axis line width
ax.FontSize = 16;
ax.XTickLabelMode = 'auto';
ax.XAxisLocation = 'bottom';
ax.XTickLabelRotation = 0; % Set rotation if needed
ax.TickDir = 'out';
xlabel('BIS (z-scores)')
ylabel('Resting state functional connectivity (z-scores)')


%% ===================== CONFIDENCE ELLIPSIS -----------------------------

cov_cond1 = cov(score_bis_cond1, score_rsfc_cond1);
cov_cond2 = cov(score_bis_cond2, score_rsfc_cond2);

% Mean points for the ellipses
mean_cond1 = mean([score_bis_cond1, score_rsfc_cond1]);
mean_cond2 = mean([score_bis_cond2, score_rsfc_cond2]);

% Plot the ellipses and capture the graphic handles
h_cond1 = error_ellipse(cov_cond1, mean_cond1, 'conf', 0.95);
h_cond2 = error_ellipse(cov_cond2, mean_cond2, 'conf', 0.95);

% Apply colors to the ellipses after creation
set(h_cond1, 'Color',edgeColor,'LineWidth',3); % Set color for low anxiety ellipse
set(h_cond2, 'Color',edgeColor2,'LineWidth',3);  % Set color for high anxiety ellipse

%% ===================== ASSUMPTION CHECKS FOR STATS ANALYSIS ================================

fprintf('\n--- ASSUMPTION CHECKS FOR STATS ANALYSIS ---\n');

%% 1. Normality (Lilliefors test on individual scores)

data = {
    score_bis_cond1, 'BIS-cond1';
    score_rsfc_cond1, 'rsFC-cond1';
    score_bis_cond2, 'BIS-cond2';
    score_rsfc_cond2, 'rsFC-cond2';
    
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


[r_cond1, p_cond1] = corrcoef(score_bis_cond1, score_rsfc_cond1);


r_cond1 = r_cond1(1,2);
p_cond1 = p_cond1(1,2);

[r_cond2, p_cond2] = corrcoef(score_bis_cond2, score_rsfc_cond2);


r_cond2 = r_cond2(1,2);
p_cond2 = p_cond2(1,2);


mdl_cond1 = fitlm(score_bis_cond1, score_rsfc_cond1);
mdl_cond2 = fitlm(score_bis_cond2, score_rsfc_cond2);

slope_cond1 = mdl_cond1.Coefficients.Estimate(2);
Rsq_cond1 = mdl_cond1.Rsquared.Adjusted;

slope_cond2 = mdl_cond2.Coefficients.Estimate(2);
Rsq_cond2 = mdl_cond2.Rsquared.Adjusted;


% confidence interval
zcond2 = 0.5 * log((1 + r_cond2)/(1 - r_cond2));
zcond1 = 0.5 * log((1 + r_cond1)/(1 - r_cond1));
SE_cond2 = 1 / sqrt(length(score_rsfc_cond2) - 3);
SE_cond1 = 1/ sqrt(length(score_rsfc_cond1) - 3);

z_crit = 1.96; % for 95% CI
z_lower_cond2 = zcond2 - z_crit * SE_cond2;
z_upper_cond2 = zcond2 + z_crit * SE_cond2;

z_lowercond1 = zcond1 - z_crit * SE_cond1;
z_uppercond1 = zcond1 + z_crit * SE_cond1;

r_lower_cond2 = (exp(2*z_lower_cond2) - 1) / (exp(2*z_lower_cond2) + 1);
r_upper_cond2 = (exp(2*z_upper_cond2) - 1) / (exp(2*z_upper_cond2) + 1);

r_lower_cond1 = (exp(2*z_lowercond1) - 1) / (exp(2*z_lowercond1) +1);
r_upper_cond1 = (exp(2*z_uppercond1) -1) / (exp(2*z_uppercond1) +1);


fprintf('\n')
fprintf('Pearson''s r: %.4f, p-value: %.4f, Slope: %.4f, r CI: [%.4f, %.4f]\n', ...
    r_cond1, p_cond1, slope_cond1, r_lower_cond1, r_upper_cond1);
fprintf('\n')
fprintf('Pearson''s r: %.4f, p-value: %.4f, Slope: %.4f\n, r CI: [%.4f, %.4f]\n', ...
    r_cond2, p_cond2, slope_cond2, r_lower_cond2, r_upper_cond2);


%% ===================== SAVE FIGURE (300 DPI) ============================

output_name = 'Figure7B'; %for Figure6D/6F: change it to Figure6D/6F

% Save as PNG (300 dpi)
print(gcf, [output_name '.png'], '-dpng', '-r300');

% Save as TIFF (300 dpi)
print(gcf, [output_name '.tif'], '-dtiff', '-r300');