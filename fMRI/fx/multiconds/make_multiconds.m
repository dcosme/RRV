% This script creates FX multicond files for RRV
%
% D.Cos 1/2019

% Initialize variables
dataDir = '~/Documents/code/sanlab/RRV/fMRI/fx/multiconds';
writeDir = '~/Documents/code/sanlab/RRV/fMRI/fx/multiconds/event';
keyFile = fullfile(dataDir,'subjectID_key.csv');
order1File = fullfile(dataDir,'Sublist_ORDER1.txt');
order2File = fullfile(dataDir,'Sublist_ORDER2.txt');
runs = {'run1', 'run2'};

% Load key and sub orders
fid=fopen(keyFile);
key = textscan(fid, '%s%s', 'Delimiter',  ',', 'treatAsEmpty','NULL', 'EmptyValue', NaN);
fclose(fid);

fid=fopen(order1File);
order1Subs = textscan(fid, '%s', 'Delimiter',  ',', 'treatAsEmpty','NULL', 'EmptyValue', NaN);
fclose(fid);

fid=fopen(order2File);
order2Subs = textscan(fid, '%s', 'Delimiter',  ',', 'treatAsEmpty','NULL', 'EmptyValue', NaN);
fclose(fid);

% Make output directory if it doesn't exist
if ~exist(writeDir); mkdir(writeDir); end
    
%% Make order 1 files
for i = 1:length(runs)
    % Define run
    run = runs{i};
    
    % Open run info
    fid=fopen(fullfile(dataDir, sprintf('ORDER1_5Cond_%s.txt', run)));
    runInfo = textscan(fid, '%n%s%n%n', 'Delimiter',  ',', 'treatAsEmpty','NULL', 'EmptyValue', NaN);
    fclose(fid);

    % Names
    names = {'snack', 'meal', 'dessert', 'nature', 'social'}; % condition names

    % Onsets
    for a = 1:length(names)
        idxs = find(strcmp(runInfo{:,2}, names{a}));
        onsets{a}=runInfo{1,3}(idxs);
    end

    % Durations
    for b = 1:length(names)
        idxs = find(strcmp(runInfo{:,2}, names{b}));
        durations{b}=runInfo{1,4}(idxs);
    end
    
    % Loop through subs and write files
    for j = 1:length(order1Subs{1})
        subCode = order1Subs{1,1}{j};
        idxs = find(strcmp(key{1,1}, subCode));
        subID = key{1,2}{idxs};
        outputName = sprintf('%s_CR_%s.mat',subID,run);
        save(fullfile(writeDir,outputName),'names','onsets','durations');
    end
end

%% Make order 2 files
for i = 1:length(runs)
    % Define run
    run = runs{i};
    
    % Open run info
    fid=fopen(fullfile(dataDir, sprintf('ORDER2_5Cond_%s.txt', run)));
    runInfo = textscan(fid, '%n%s%n%n', 'Delimiter',  ',', 'treatAsEmpty','NULL', 'EmptyValue', NaN);
    fclose(fid);

    % Names
    names = {'snack', 'meal', 'dessert', 'nature', 'social'}; % condition names

    % Onsets
    for a = 1:length(names)
        idxs = find(strcmp(runInfo{:,2}, names{a}));
        onsets{a}=runInfo{1,3}(idxs);
    end

    % Durations
    for b = 1:length(names)
        idxs = find(strcmp(runInfo{:,2}, names{b}));
        durations{b}=runInfo{1,4}(idxs);
    end
    
    % Loop through subs and write files
    for j = 1:length(order2Subs{1})
        subCode = order2Subs{1,1}{j};
        idxs = find(strcmp(key{1,1}, subCode));
        subID = key{1,2}{idxs};
        outputName = sprintf('%s_CR_%s.mat',subID,run);
        save(fullfile(writeDir,outputName),'names','onsets','durations');
    end
end