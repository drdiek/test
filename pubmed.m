function pubmed()
%
% Modified 20220118 by Diek W. Wheeler, Ph.D.

    addpath data lib output

    [PMIDs] = initialize_variables();
    
%     pmstruct = getpubmed('8946282')
%     pause
    
    fileName = sprintf('output/pubmed_addendum_%s.csv', datestr(now, 'yyyymmddHHMMSS'));
    fid = fopen(fileName,'w');
    fprintf(fid, 'authors,pmid_isbn,pmcid,nihmsid,doi,citation_count,open_access,first_page,last_page,title,year,publication,volume,issue,type_mapped,packet\n');
        
    for i = 1:length(PMIDs.unique)
        pmstruct = getpubmed(PMIDs.unique(i));
%         pmstruct.Authors = 'Martinez A, Lubke J, Del Rio JA, Soriano E, Frotscher M';
%         pmstruct.PMID = '8946282';
%         pmstruct.PMCID = '';
%         pmstruct.DOI = '10.1002/(SICI)1096-9861(19961202)376:1&lt;28::AID-CNE2&gt;3.0.CO;2-Q';
%         pmstruct.FirstPage = '28';
%         pmstruct.LastPage = '44';
%         pmstruct.Title = 'Regional variability and postsynaptic targets of chandelier cells in the hippocampal formation of the rat.';
%         pmstruct.Year = '1996';
%         pmstruct.Publication = 'J Comp Neurol';
%         pmstruct.Volume = '376';
%         pmstruct.Issue = '1';
        fprintf(fid,'"%s",%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',...
            pmstruct.Authors,...
            pmstruct.PMID,...
            pmstruct.PMCID,...
            '',... % NIHMSID
            pmstruct.DOI,...
            '',... % citation count
            '',... % open access
            pmstruct.FirstPage,...
            pmstruct.LastPage,...
            pmstruct.Title,...
            pmstruct.Year,...
            pmstruct.Publication,...
            pmstruct.Volume,...
            pmstruct.Issue,...
            '',... % type mapped
            ''); % packet
    end
    fclose(fid);
    
end % pubmed()