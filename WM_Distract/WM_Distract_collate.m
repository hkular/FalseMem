%% Working Memory Distractor experiment data collating by Holly Kular Apr 2022
% Environment: Matlab 2021a -- should not matter
%
% This collects all the data from across subjects .mat files and puts it into a csv
% that way it can be analyzed as a dataframe in R or Python
%
% Inputs: 
%  subs: manually change this so we can exclude bad subjects if we want 
%  my_path: don't need to change if you're in the data directory
%
% Outputs:
%  .mat file containing the collated behavior data in case we ever wanted to use matlab to analyze
%  .csv file containing the same collated behavior data


clear
close all
clc
 
subs = ['23' ;'24';'26'; '27'; '30';  '31'; '32'; '33'; '34'; '35'; '36'; '38'; '39'];
my_path = pwd; % make sure you are in directory containing data
info.TheDate = datestr(now,'yymmdd');

collated_data = [];
all_dat = [];
for s = 1:size(subs,1)
    
    %find the filenames for the subject data
    myFolder = pwd;
    filePattern = fullfile(myFolder, 'WM_DistractV*'); % Change to whatever pattern you need.
    theFiles = dir(filePattern);
    
    %load this subjects data
    load([theFiles(s).name])
    length(TheData);
    % preallocate, size changes depending on number of subs and trials
    subject = [];
    resp = [];
    respRT = [];
    conf = [];
    confRT = [];
    hits = [];
    falserep = [];
    
    for run = 1:length(TheData) % for each run
        
        subject = [subject; repmat(s, [length(TheData(run).data.Response),1])];
        resp = [resp;TheData(run).data.Response'];
        respRT = [respRT; TheData(run).data.RTresp'];
        conf = [conf; TheData(run).data.Confidence'];
        confRT = [confRT; TheData(run).data.RTconf'];

    end
    % put it in a format compatible with the trial parameters file
    ss = num2cell(subject); [TrialStuff.('subject')] = ss{:};
    rs = num2cell(resp); [TrialStuff.('resp')] = rs{:};
    rrt = num2cell(respRT); [TrialStuff.('respRT')] = rrt{:};
    cf = num2cell(conf); [TrialStuff.('conf')] = cf{:};
    crt = num2cell(confRT); [TrialStuff.('confRT')] = crt{:};

  
    collect = TrialStuff;
    all_dat = [all_dat collect];
    clear collect ss rs rrt cf crt 
end
eval(['save(''WM_Distract_', num2str(info.TheDate), '.mat'', ''all_dat'', ''-v7.3'')']);
    