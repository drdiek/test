% This function defines the entry point for the program.
% As such, it displays a text-based menu, accepts input
% from the user, and calls the appropriate function.

function run()
    clear all;    
    profile on

    addpath(genpath('lib'),'data');

    csvHippFileNames = dir('./data/*.csv');
    nCsvHippFileNames = length(csvHippFileNames);
    for i=1:nCsvHippFileNames
        allHippFileNames{i,1} = csvHippFileNames(i).name;
    end
        
    xlsHippFileNames = dir('./data/*.xls*');
    nXlsHippFileNames = length(xlsHippFileNames);
    for i=1:nXlsHippFileNames
        allHippFileNames{i+nCsvHippFileNames,1} = xlsHippFileNames(i).name;
    end
    
    nAllHippFileNames = length(allHippFileNames);
 
    if (nAllHippFileNames == 1)
        fileName = allHippFileNames{1};
    elseif (nAllHippFileNames > 1)
        [fileName, reply] = menu_file_name(allHippFileNames);
        if strcmp(reply, '!')
            return
        end
    end

    
    togglePCLcontinuing = 1;
    togglePCLterminating = 1;

    isIncludeAllV1p0ActiveTypes = 1;
    isIncludeAllUnapprovedV2p0ActiveTypes = 0;
    isIncludeAllV1p0OnholdTypes = 0;
    
    isIncludeApprovedV2p0ActiveTypes = 0;
    isIncludeUnapprovedV2p0ActiveTypes = 0;
    isIncludeV1p0OnholdTypesThatAreNowUnapprovedV2p0ActiveTypes = 0;
    isIncludeApprovedV2p0OnholdTypesThatAreNowUnapprovedv2p0Active = 0;
    isIncludeUnapprovedV2p0ActiveThatWillSplitOffFromV1p0Active = 0;
    isIncludeV1p0OnholdTypes = 0;
    isIncludeV1p0OnholdTypesThatWillDisappearInV2p0 = 0;
    isIncludeApprovedV2p0OnholdTypes = 0;
    isIncludeUnapprovedV2p0OnholdTypes = 0;
    
    isIncludeBrackets = 0;
    isIncludeInactiveMarkers_Summary = 1;
    isIncludeInactiveMarkers_All = 0;

    subOrNot = 0;
    automaticModel = 1;
    
    save toggles.mat subOrNot automaticModel    
    

    reply = [];
    
    % main loop to display menu choices and accept input
    % terminates when user chooses to exit
    while (isempty(reply))
        %% display menu %%
        
        if isIncludeAllV1p0ActiveTypes
            isIncludeV1p0Rank1to3ActiveTypes = 1;
            isIncludeV1p0Rank4to5ActiveTypes = 1;
            isIncludeV1p0ActiveTypesDisappearingInV2p0 = 1;
            isIncludeV1p0ActiveTypesWithApprovedActiveAddenda = 1;
            isIncludeV1p0ActiveTypesWithUnapprovedActiveAddenda = 1;
        end
        if isIncludeAllUnapprovedV2p0ActiveTypes
            isIncludeUnapprovedV2p0ActiveTypes = 1;
            isIncludeApprovedV2p0OnholdTypesThatAreNowUnapprovedv2p0Active = 1;
            isIncludeV1p0OnholdTypesThatAreNowUnapprovedV2p0ActiveTypes = 1;
            isIncludeUnapprovedV2p0ActiveThatWillSplitOffFromV1p0Active = 1;
        end
        if isIncludeAllV1p0OnholdTypes
            isIncludeV1p0OnholdTypes = 1;
            isIncludeV1p0OnholdTypesThatWillDisappearInV2p0 = 1;
        end
        clc;
        
        strng = sprintf('Current file is: %s\n', fileName);
        disp(strng);
        
        strng = sprintf('Please enter a selection from the menu below\n');
        disp(strng);
        
        disp('    c) Convert matrix of cells to Cij matrix');

        strng = sprintf('         1) Toggle inclusion of axons/dendrites CONTINUING in PCL: %s', bin2str(togglePCLcontinuing));
        disp(strng);
        strng = sprintf('         2) Toggle inclusion of axons/dendrites TERMINATING in PCL: %s', bin2str(togglePCLterminating));
        disp(strng);

        strng = sprintf('         Z) Toggle to ON all v1.0 active types: %s', bin2str(isIncludeAllV1p0ActiveTypes));
        disp(strng);
        strng = sprintf('              3) Toggle inclusion of v1.0 Rank 1-3 active types (N): %s', bin2str(isIncludeV1p0Rank1to3ActiveTypes));
        disp(strng);
        strng = sprintf('              4) Toggle inclusion of v1.0 Rank 4-5 active types (M): %s', bin2str(isIncludeV1p0Rank4to5ActiveTypes));
        disp(strng);
        strng = sprintf('              5) Toggle inclusion of v1.0 active types disappearing in v2.0 (O): %s', bin2str(isIncludeV1p0ActiveTypesDisappearingInV2p0));
        disp(strng);
        strng = sprintf('              6) Toggle inclusion of v1.0 active types with approved active addenda (B): %s', bin2str(isIncludeV1p0ActiveTypesWithApprovedActiveAddenda));
        disp(strng);
        strng = sprintf('              7) Toggle inclusion of v1.0 active types with unapproved active addenda (A): %s', bin2str(isIncludeV1p0ActiveTypesWithUnapprovedActiveAddenda));
        disp(strng);

        strng = sprintf('         8) Toggle inclusion of approved v2.0 active types (P): %s', bin2str(isIncludeApprovedV2p0ActiveTypes));
        disp(strng);

        strng = sprintf('         Y) Toggle to ON all unapproved v2.0 active types: %s', bin2str(isIncludeAllUnapprovedV2p0ActiveTypes));
        disp(strng);
        strng = sprintf('              9) Toggle inclusion of unapproved v2.0 active types (V): %s', bin2str(isIncludeUnapprovedV2p0ActiveTypes));
        disp(strng);
        strng = sprintf('             10) Toggle inclusion of v1.0 on-hold types that are now unapproved v2.0 active types (W): %s', bin2str(isIncludeV1p0OnholdTypesThatAreNowUnapprovedV2p0ActiveTypes));
        disp(strng);
        strng = sprintf('             11) Toggle inclusion of approved v2.0 on-hold types that are now unapproved v2.0 active types (U): %s', bin2str(isIncludeApprovedV2p0OnholdTypesThatAreNowUnapprovedv2p0Active));
        disp(strng);
        strng = sprintf('             12) Toggle inclusion of unapproved v2.0 active types that will split off from v1.0 active types (R): %s', bin2str(isIncludeUnapprovedV2p0ActiveThatWillSplitOffFromV1p0Active));
        disp(strng);

        strng = sprintf('         X) Toggle to ON all v1.0 on-hold types: %s', bin2str(isIncludeAllV1p0OnholdTypes));
        disp(strng);
        strng = sprintf('             13) Toggle inclusion of v1.0 on-hold types (X): %s', bin2str(isIncludeV1p0OnholdTypes));
        disp(strng);
        strng = sprintf('             14) Toggle inclusion of v1.0 on-hold types that will disappear in v2.0 (T): %s', bin2str(isIncludeV1p0OnholdTypesThatWillDisappearInV2p0));
        disp(strng);

        strng = sprintf('        15) Toggle inclusion of approved v2.0 on-hold types (Y): %s', bin2str(isIncludeApprovedV2p0OnholdTypes));
        disp(strng);

        strng = sprintf('        16) Toggle inclusion of unapproved v2.0 on-hold types (S): %s', bin2str(isIncludeUnapprovedV2p0OnholdTypes));
        disp(strng);

        strng = sprintf('    L) Load a different csv file (');
        strng = sprintf('%s%s', strng, deblank(fileName));
        strng = sprintf('%s)', strng);
        disp(strng);
        
%         disp(' ');
        disp('    !) Exit');
        
        %% process input %%
        
        reply = lower(input('\nYour selection: ', 's'));

        switch reply
            case 'c'
                [cells, isFileLoaded] = load_csvFile(fileName);
                if isFileLoaded
                    if isIncludeV1p0Rank1to3ActiveTypes || ...
                            isIncludeV1p0Rank4to5ActiveTypes || ...
                            isIncludeV1p0ActiveTypesDisappearingInV2p0 || ...
                            isIncludeV1p0ActiveTypesWithApprovedActiveAddenda || ...
                            isIncludeV1p0ActiveTypesWithUnapprovedActiveAddenda || ...
                            isIncludeApprovedV2p0ActiveTypes || ...
                            isIncludeUnapprovedV2p0ActiveTypes || ...
                            isIncludeV1p0OnholdTypesThatAreNowUnapprovedV2p0ActiveTypes || ...
                            isIncludeApprovedV2p0OnholdTypesThatAreNowUnapprovedv2p0Active || ...
                            isIncludeUnapprovedV2p0ActiveThatWillSplitOffFromV1p0Active || ...
                            isIncludeV1p0OnholdTypes || ...
                            isIncludeV1p0OnholdTypesThatWillDisappearInV2p0 || ...
                            isIncludeApprovedV2p0OnholdTypes || ...
                            isIncludeUnapprovedV2p0OnholdTypes

                        save 'connectivityToggles' togglePCLcontinuing ...
                                                   togglePCLterminating ...
                                                   isIncludeV1p0Rank1to3ActiveTypes ...
                                                   isIncludeV1p0Rank4to5ActiveTypes ...
                                                   isIncludeV1p0ActiveTypesDisappearingInV2p0 ...
                                                   isIncludeV1p0ActiveTypesWithApprovedActiveAddenda ...
                                                   isIncludeV1p0ActiveTypesWithUnapprovedActiveAddenda ...
                                                   isIncludeApprovedV2p0ActiveTypes ...
                                                   isIncludeUnapprovedV2p0ActiveTypes ...
                                                   isIncludeV1p0OnholdTypesThatAreNowUnapprovedV2p0ActiveTypes ...
                                                   isIncludeApprovedV2p0OnholdTypesThatAreNowUnapprovedv2p0Active ...
                                                   isIncludeUnapprovedV2p0ActiveThatWillSplitOffFromV1p0Active ...
                                                   isIncludeV1p0OnholdTypes ...
                                                   isIncludeV1p0OnholdTypesThatWillDisappearInV2p0 ...
                                                   isIncludeApprovedV2p0OnholdTypes ...
                                                   isIncludeUnapprovedV2p0OnholdTypes

                        save 'adPCLtoggles' togglePCLcontinuing togglePCLterminating
                    
                        current_parcellation_data(cells);
                        
                        cells2cij(cells);
                        
                        reply = menu_connectivity(fileName, cells);
                        if ~strcmp(reply, '!')
                            reply = [];
                        end
                    else
                        disp('Please toggle on at least one class type for analysis.  Press any key.');
                        pause
                        reply = [];
                    end

                else
                    disp('Error: file not loaded!');
                    reply = [];
                end
                
            case 'z'
                isIncludeAllV1p0ActiveTypes = ~isIncludeAllV1p0ActiveTypes;
                reply = [];
                
            case 'y'
                isIncludeAllUnapprovedV2p0ActiveTypes = ~isIncludeAllUnapprovedV2p0ActiveTypes;
                reply = [];
                
            case 'x'
                isIncludeAllV1p0OnholdTypes = ~isIncludeAllV1p0OnholdTypes;
                reply = [];
                
            case '1'
                togglePCLcontinuing = ~togglePCLcontinuing;
                reply = [];
                
            case '2'
                togglePCLterminating = ~togglePCLterminating;
                reply = [];

            case '3'
                isIncludeV1p0Rank1to3ActiveTypes = ~isIncludeV1p0Rank1to3ActiveTypes;
                if ~isIncludeV1p0Rank1to3ActiveTypes
                    isIncludeAllV1p0ActiveTypes = 0;
                end
                reply = [];
                
            case '4'
                isIncludeV1p0Rank4to5ActiveTypes = ~isIncludeV1p0Rank4to5ActiveTypes;
                if ~isIncludeV1p0Rank4to5ActiveTypes
                    isIncludeAllV1p0ActiveTypes = 0;
                end
                reply = [];                
                
            case '5'
                isIncludeV1p0ActiveTypesDisappearingInV2p0 = ~isIncludeV1p0ActiveTypesDisappearingInV2p0;
                if ~isIncludeV1p0ActiveTypesDisappearingInV2p0
                    isIncludeAllV1p0ActiveTypes = 0;
                end
                reply = [];

            case '6'
                isIncludeV1p0ActiveTypesWithApprovedActiveAddenda = ~isIncludeV1p0ActiveTypesWithApprovedActiveAddenda;
                if ~isIncludeV1p0ActiveTypesWithApprovedActiveAddenda
                    isIncludeAllV1p0ActiveTypes = 0;
                end
                reply = [];

            case '7'
                isIncludeV1p0ActiveTypesWithUnapprovedActiveAddenda = ~isIncludeV1p0ActiveTypesWithUnapprovedActiveAddenda;
                if ~isIncludeV1p0ActiveTypesWithUnapprovedActiveAddenda
                    isIncludeAllV1p0ActiveTypes = 0;
                end
                reply = [];

            case '8'
                isIncludeApprovedV2p0ActiveTypes = ~isIncludeApprovedV2p0ActiveTypes;
                if ~isIncludeApprovedV2p0ActiveTypes
                    isIncludeAllApprovedV2p0ActiveTypes = 0;
                end
                reply = [];                
                
            case '9'
                isIncludeUnapprovedV2p0ActiveTypes = ~isIncludeUnapprovedV2p0ActiveTypes;
                if ~isIncludeUnapprovedV2p0ActiveTypes
                    isIncludeAllUnapprovedV2p0ActiveTypes = 0;
                end
                reply = [];

            case '10'
                isIncludeV1p0OnholdTypesThatAreNowUnapprovedV2p0ActiveTypes = ~isIncludeV1p0OnholdTypesThatAreNowUnapprovedV2p0ActiveTypes;
                if ~isIncludeV1p0OnholdTypesThatAreNowUnapprovedV2p0ActiveTypes
                    isIncludeAllUnapprovedV2p0ActiveTypes = 0;
                end
                reply = [];

            case '11'
                isIncludeApprovedV2p0OnholdTypesThatAreNowUnapprovedv2p0Active = ~isIncludeApprovedV2p0OnholdTypesThatAreNowUnapprovedv2p0Active;
                if ~isIncludeApprovedV2p0OnholdTypesThatAreNowUnapprovedv2p0Active
                    isIncludeAllUnapprovedV2p0ActiveTypes = 0;
                end
                reply = [];

            case '12'
                isIncludeUnapprovedV2p0ActiveThatWillSplitOffFromV1p0Active = ~isIncludeUnapprovedV2p0ActiveThatWillSplitOffFromV1p0Active
                if ~isIncludeUnapprovedV2p0ActiveThatWillSplitOffFromV1p0Active
                    isIncludeAllUnapprovedV2p0ActiveTypes = 0;
                end
                reply = [];
                
            case '13'
                isIncludeV1p0OnholdTypes = ~isIncludeV1p0OnholdTypes;
                if ~isIncludeV1p0OnholdTypes
                    isIncludeAllV1p0OnholdTypes = 0;
                end
                reply = [];
                
            case '14'
                isIncludeV1p0OnholdTypesThatWillDisappearInV2p0 = ~isIncludeV1p0OnholdTypesThatWillDisappearInV2p0;
                if ~isIncludeV1p0OnholdTypesThatWillDisappearInV2p0
                    isIncludeAllV1p0OnholdTypes = 0;
                end
                reply = [];                
                
            case '15'
                isIncludeApprovedV2p0OnholdTypes = ~isIncludeApprovedV2p0OnholdTypes;
                if ~isIncludeApprovedV2p0OnholdTypes
                    isIncludeAllApprovedV2p0OnholdTypes = 0;
                end
                reply = [];
                
            case '16'
                isIncludeUnapprovedV2p0OnholdTypes = ~isIncludeUnapprovedV2p0OnholdTypes;
                if ~isIncludeUnapprovedV2p0OnholdTypes
                    isIncludeAllUnapprovedV2p0OnholdTypes = 0;
                end
                reply = [];
                
            case 'l'
                csvHippFileNames = dir('*.csv');
                nCsvHippFileNames = length(csvHippFileNames);
                for i=1:nCsvHippFileNames
                    allHippFileNames{i,1} = csvHippFileNames(i).name;
                end

                xlsHippFileNames = dir('*.xls*');
                nXlsHippFileNames = length(xlsHippFileNames);
                for i=1:nXlsHippFileNames
                    allHippFileNames{i+nCsvHippFileNames,1} = xlsHippFileNames(i).name;
                end
                
                [fileName, reply] = menu_file_name(allHippFileNames);
                if ~strcmp(reply, '!')
                    reply = [];
                end
                
            % exit; save profile
            case '$'
                p = profile('info');
                profsave(p,'profile_results');
                
            % exit; don't save profile
            case '!'
                %exit
                
            otherwise
                reply = [];
        
        end % switch
        
    end % while loop
    
    clean_exit()% exit
    
end % run