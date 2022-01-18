function FP_run()

    clear all;    
    profile on

    addpath(genpath('lib'),'data');
    
    fileName = 'FP_matrix.csv';

    [cells, isFileLoaded] = load_csv_file(fileName);
    
    if isFileLoaded
       
        [nRows, nColumns] = size(cells);

        nSkipRows = 1;
        
        nSkipColumns = 6;
        
        ABCorderingColumnNo = 1;
        
        HCorderingColumnNo = 2;
        
        cellIDorderingColumnNo = 4;
        
        subregionColumnNo = 5;
        
        labelColumnNo = 6;
        
        EorIColumnNo = 7;
        
        patternLabelRowNo = 1;
    
        orderingColumnNo = menu_ordering_column(ABCorderingColumnNo,HCorderingColumnNo,cellIDorderingColumnNo);
        if strcmp(orderingColumnNo,'!')
            return;
        end
    
        nAllCells  = nRows - nSkipRows;
        nPatterns = nColumns - nSkipColumns;
        
        ordering = str2double(cells(nSkipRows+[1:nAllCells], orderingColumnNo));
        
        subregionsUnsorted = cells(nSkipRows+[1:nAllCells], subregionColumnNo);
        cellLabelsUnsorted = cells(nSkipRows+[1:nAllCells], labelColumnNo);
        cellEorIsUnsorted = cells(nSkipRows+[1:nAllCells], EorIColumnNo);
        nPatternOccurrencesUnsorted = str2double(cells(nSkipRows+[1:nAllCells], nSkipColumns+[1:nPatterns]));
        
        [orderingSorted, indices] = sort(ordering);
        subregions = subregionsUnsorted(indices);
        cellLabels = cellLabelsUnsorted(indices);
        cellEorIs = cellEorIsUnsorted(indices);
        nPatternOccurrencesSorted = nPatternOccurrencesUnsorted(indices,:);

        patternLabels = cells(patternLabelRowNo, nSkipColumns+[1:nPatterns]);

        save parameters.mat nAllCells nPatterns subregions cellLabels cellEorIs nPatternOccurrencesSorted patternLabels
        
        plot_patterns();
        
    end

% end FP_run()