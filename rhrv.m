function [ hrv, rri ] = rhrv( rec_name, varargin )
%RHRV Heart Rate Variability metrics
%   Detailed explanation goes here

%% === Input

% Defaults

% Define input
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('rec_name', @isrecord);

% Get input
p.parse(rec_name, varargin{:});

%% === Calculate HRV metrics

% First, find R-peaks (also returns the signal)
[qrs, tm, sig, fs] = rqrs(rec_name);

% Init output structure
hrv = struct;

% RR-intervals are the time-difference between R-Peaks
rri = diff(tm(qrs));
tm_rri = tm(qrs(1:end-1));

% instantaneus heart rate (bpm)
ihr = 60 ./ rri;

% calculate an average ihr signal
nfilt = 10;
b_fir = 1/nfilt * ones(nfilt,1);
ihr_lp = filtfilt(b_fir, 1, ihr); % use filtfilt for zero-phase

% remove outliers using x bpm tolerance
tol_bpm = 10;
outliers_idx = find(abs(diff(ihr)) > tol_bpm);
outliers_idx = unique([outliers_idx; find(abs(ihr - ihr_lp) > tol_bpm)]);
%figure; plot(tm_rri,ihr,'b-', tm_rri,ihr_lp,'r-', tm_rri,ihr_lp-tol_bpm,'k.', tm_rri,ihr_lp+tol_bpm,'k.', tm_rri(outliers_idx),ihr_lp(outliers_idx),'kx');
rri(outliers_idx) = [];
tm_rri(outliers_idx) = [];


%% === Time Domain Metrics
hrv.AVNN = mean(rri);
hrv.SDNN = sqrt(var(rri));
hrv.RMSSD = sqrt(mean(diff(rri).^2));
hrv.pNN50 = sum(abs(diff(rri)) > 0.05)/(length(rri)-1);

%% === Freq domain - Non parametric
f_max = 0.4; % Hz
[pxx_lomb, f_lomb] = plomb(rri, tm_rri, f_max); % lomb periodogram

TOT_band = [min(f_lomb), max(f_lomb)];
ULF_band = [min(f_lomb), 0.003];
VLF_band = [0.003, 0.04];
LF_band = [0.04, 0.15];
HF_band = [0.15, max(f_lomb)];

hrv.TOT_PWR = bandpower(pxx_lomb,f_lomb,TOT_band,'psd');
hrv.ULF_PWR = bandpower(pxx_lomb,f_lomb,ULF_band,'psd');
hrv.VLF_PWR = bandpower(pxx_lomb,f_lomb,VLF_band,'psd');
hrv.LF_PWR = bandpower(pxx_lomb,f_lomb,LF_band,'psd');
hrv.HF_PWR = bandpower(pxx_lomb,f_lomb,HF_band,'psd');

%% === Freq domain - Parametric

% resample to obtain uniformly sampled signal
fs_rri = 10*f_max; %Hz
[rri_uni, tm_rri_uni] = resample(rri, tm_rri, fs_rri, 1, 1);

L_AR = 200;
[pxx_ar, f_ar] = psd_yulewalker(rri_uni, fs_rri, L_AR); % Yule-Walker AR model
pxx_ar = interp1(f_ar, pxx_ar, f_lomb); % Evaluate at the lomb frequencies

%% === Plot
% Set larger default font 
close all;
set(0,'DefaultAxesFontSize',14);
figure;
subplot(2,1,1); plot(tm_rri, rri);
xlabel('Time [s]'); ylabel('RR-interval [s]');
subplot(2,1,2); semilogy(f_lomb, [pxx_lomb, pxx_ar]); hold on;
xlabel('Frequency [hz]'); ylabel('Power Density [s^2/Hz]');
xlim([0,f_max*1.01]);
%# vertical line
yrange = get(gca,'ylim');
line(LF_band(1) * ones(1,2), yrange, 'LineStyle', ':', 'Color', 'red');
line(HF_band(1) * ones(1,2), yrange, 'LineStyle', ':', 'Color', 'red');
line(HF_band(2) * ones(1,2), yrange, 'LineStyle', ':', 'Color', 'red');