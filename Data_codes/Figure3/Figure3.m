%% FIGURE 3: Correlation between Balance Integration Scores and resting state functional connectivity
% -------------------------------------------------------------------------
% This script reproduces Figure 3B, 3D, 3F from the manuscript and completes:
%   - Condition-specific visualization 
%   - Statistical comparison between the conditions 
%   - Figure export (300 dpi)
%
%
% REQUIREMENTS:
%   - MATLAB (R2021a or later)
%   - Statistics and Machine Learning Toolbox 
%   - Data file: 'Figure3B.mat/Figure3D.mat/Figure3F.mat' in present working directory 
%
%
% OUTPUT:
%   - Figure replicating Figure 3B, 3D, 3F
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

load Figure3B.mat %change it to Figure3D.mat for Figure3D and Figure3F.mat for Figure3F
behaviour =  mean_bis_posNT; %change it to mean_bis_negNT for Figure3F.mat

cluster = round(data,3);


zscorebehaviour =  (behaviour); % already z-score
zscorecluster = zscore(round(data,3));

%% plot

% Add jitter
jittered_behaviour = behaviour + (rand(size(behaviour)) - 0.1) * 0.001;
jittered_rsfc = zscorecluster + (rand(size(zscorecluster)) - 0.1) * 0.001;

%% --------------------------- DEFINE COLORS ---------------------------------------
% use the 'BLUE' edgeColor and faceColor for Figure3B.mat/Figure3D.mat

edgeColor = [0 0 128/255] %BLUE
faceColor = edgeColor + (1 - edgeColor) * 0.8;

% use the 'RED' edgeColor and faceColor for Figure3F.mat

% edgeColor = [153/255 0 0]; % red
% faceColor = edgeColor + (1 - edgeColor) * 0.8;


%% --------------------------- FIGURE SETUP -------------------------------
figure('Color', 'w', 'Position', [100, 100, 600, 600]);

hold on;

%% --------------------------- SCATTER -------------------------------

%comment the below line for Figure3F.mat

scatter(jittered_behaviour, jittered_rsfc, 'MarkerFaceColor', faceColor, 'MarkerEdgeColor',edgeColor, 'LineWidth',2, 'Marker','o','SizeData',300);
%
% for figure 3F.mat, use triangle as marker
% scatter(jittered_behaviour, jittered_rsfc, 'MarkerFaceColor', faceColor, 'MarkerEdgeColor',edgeColor, 'LineWidth',2, 'Marker','^','SizeData',300);

hline = lsline;
set(hline(1), 'Color', edgeColor, 'LineWidth', 5,'LineStyle','-'); % First line for high FA

% plot
ax = gca;
ax.LineWidth = 1.5; % Axis line width
ax.FontSize = 16;
ax.XTickLabelMode = 'auto';
ax.XAxisLocation = 'bottom';

ax.XTickLabelRotation = 0; % Set rotation if needed
ax.TickDir = 'out'; % Set ticks to be outside

xlabel('BIS (z-scores)')
ylabel('Resting state functional connectivity (z-scores)')
hold off

%% ===================== ASSUMPTION CHECKS FOR STATS ANALYSIS ================================

fprintf('\n--- ASSUMPTION CHECKS FOR STATS ANALYSIS ---\n');

%% 1. Normality (Lilliefors test on individual scores)

data = {
    behaviour, 'BIS';
    cluster, 'rsFC'
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

%% 2. Outlier detection (zscore method)

lower_bound = -3;
upper_bound = 3;


data = {
    zscorebehaviour, 'Behaviour';
    zscorecluster,   'Cluster'
};

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

[r, p_rsfc] = corrcoef(behaviour, cluster);

r_1 = r(1,2);
p_1 = p_rsfc(1,2);

% slope calculation
mdl = fitlm(behaviour, cluster);
slope = mdl.Coefficients.Estimate(2);
Rsq = mdl.Rsquared.Adjusted;

fprintf('\n')
fprintf('Pearson''s r: %.4f, p-value: %.4f, Slope: %.4f\n', r_1, p_1, slope);
fprintf('\n')

% Calculate confidence intervals for the correlation coefficient
z_crit = 1.96; % for 95% CI
z = 0.5 * log((1 + r_1)/(1 - r_1));
SE = 1 / sqrt(length(cluster) - 3);

z_lower = z - z_crit * SE;
z_upper = z + z_crit * SE;

ci_lower = (exp(2*z_lower) - 1) / (exp(2*z_lower) + 1);
ci_upper = (exp(2*z_upper) - 1) / (exp(2*z_upper) + 1);

fprintf('95%% Confidence Interval for the correlation coefficient: [%.4f, %.4f]\n', ci_lower, ci_upper);

%% ===================== SAVE FIGURE (300 DPI) ============================

output_name = 'Figure3B'; %change it to Figure3D / Figure3F

% Save as PNG (300 dpi)
print(gcf, [output_name '.png'], '-dpng', '-r300');

% Save as TIFF (300 dpi)
print(gcf, [output_name '.tif'], '-dtiff', '-r300');