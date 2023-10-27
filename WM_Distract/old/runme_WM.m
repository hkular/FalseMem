function runme_WM()
%-------------------------------------------------------------------------
% Script to run multiple experiment scripts in a row
%
% HK 2022 adapted from Kirsten Adam, last updated 24 Aug 2018
%-------------------------------------------------------------------------
clear all;  % clear everything out!
close all;  % close existing figures
warning('off','MATLAB:dispatcher:InexactMatch');  % turn off the case mismatch warning (it's annoying)
dbstop if error  % tell us what the error is if there is one
AssertOpenGL;    % make sure openGL rendering is working (aka psychtoolbox is on the path)

%-------------------------------------------------------------------------
% save date and time!
%-------------------------------------------------------------------------
p.date_time_session = clock;
%-------------------------------------------------------------------------
% Important options for all experiments
%-------------------------------------------------------------------------
p.environment = 1; % 1 = Linux machine, 2 = iMac, 3 = PC
p.portCodes = 1;  %1 = use p.portCodes (we're in the booth), 0 is fMRI, 2 = laptop
p.windowed = 1; % 1 = small win for easy debugging!, otherwise 0
p.startClick = 1; % 1 = must press spacebar to initiate each trial. 
%-------------------------------------------------------------------------
% Build an output directory & check to make sure it doesn't already exist
%-------------------------------------------------------------------------
p.root = pwd;
addpath([p.root,'/SupportFunctions'])
if p.environment == 1
    if p.portCodes == 1   
        p.datadir = '/home/serencesadmin/Documents/Kirsten/switchSearch/Data';
        p.GeneralUseScripts = '/home/serencesadmin/Documents/Kirsten/switchSearch/GeneralUseScripts';
    else
        p.datadir = '/Users/hollykular/Documents/FYP/code/HK/Behavioral/WM_DistractV3';
        p.GeneralUseScripts = '/Users/hollykular/Documents/FYP/code/HK/Behavioral/WM_DistractV3/GeneralUseScripts';
    end
    addpath(genpath(p.GeneralUseScripts));
    addpath(genpath([p.GeneralUseScripts,'/Calibration']));
else % just save locally!
    if ~exist([p.root, filesep,'Data',filesep], 'dir')
        mkdir([p.root, filesep,'Data',filesep]);
    end
    p.datadir = [p.root, filesep,'Data',filesep];
end

%-------------------------------------------------------------------------
% If we're on a linux machine, but not in EEG, get the behavior room!
%-------------------------------------------------------------------------
if ~p.portCodes && p.environment==1
    prompt = {'Room Letter'};            % what information do we want from the subject?
    defAns = {''};                                           %s fill in some stock answers - here the fields are left blank
    box = inputdlg(prompt,'Enter Room Info',1,defAns);       % build the GUI
    if length(box) == length(defAns)                            % check to make sure something was typed in
        p.room = upper(box{1});
    else
        return;                                                 % if nothing was entered or the subject hit cancel, bail out
    end
else
    p.room = 'A';
end
%-------------------------------------------------------------------------
% Change to our desired resolution and refresh rate
%-------------------------------------------------------------------------
if p.environment == 1
%     s = setScreen_Exp(1024,768,120); % X, Y, 120 Hz
    s = setScreen_Default(); % just use Default for this experiment! 1600 x 1200, 85 Hz 
    if s == 0
        %fprintf('Screen successfully set to Experiment Mode!');
    end
end


%% -------------------------------------------------------------------------
% Run Main Experiment Scripts
%-------------------------------------------------------------------------

%WM_DistractV5practice(1,1);

nruns = input('nruns: ', 's'); if isempty(nruns); nruns = 8; end
nruns = str2num(nruns);
startRun = input('startRun: ', 's'); if isempty(startRun); startRun = 1; end
startRun = str2num(startRun);

WM_DistractV5(nruns, startRun);

    
%-------------------------------------------------------------------------
% Change back gamma values!
%-------------------------------------------------------------------------
if p.environment == 1
    Screen('LoadCLUT', win.screenNumber, win.OriginalCLUT);
end
%-------------------------------------------------------------------------
% Change back screen to default mode!
%-------------------------------------------------------------------------
if p.environment == 1
s = setScreen_Default();
if s == 0
    fprintf('Screen successfully set back to default!');
end
end
%-------------------------------------------------------------------------
% Close psychtoolbox window & Postpare the environment
%-------------------------------------------------------------------------
sca;
ListenChar(0);
if p.environment == 3
    ShowHideWinTaskbarMex(1);
end
%% 
close all;
end

