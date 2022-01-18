function article_PoK

    clear all

    [num, txt, raw] = xlsread('csv2db/EvidencePropertyTypeRel_view.csv');
    
    EvidencePropertyTypeRel_EvidenceIDs = uint16(num(:, 3));
        
    EvidencePropertyTypeRel_PropertyIDs = uint16(num(:, 4));
        
    EvidencePropertyTypeRel_TypeIDs = uint16(num(:, 5));
    
    eids_unique = EvidencePropertyTypeRel_EvidenceIDs;
    
    nEids_unique = length(eids_unique);
    
    clear num txt raw    
    
    [num, txt, raw] = xlsread('csv2db/Property_view.csv');
    
    Property_PropertyIDs = uint16(num(:, 1));
   
    Property_subjects = txt(2:end, 3);
    
    Property_predicates = txt(2:end, 4);
   
    Property_objects = txt(2:end, 5);
    
    clear num txt raw
    
    [num, txt, raw] = xlsread('csv2db/Type_view.csv');
    
    Type_TypeIDs = uint16(num(:, 1));
    
    Type_nicknames = txt(2:end, 6);
    
    clear num txt raw

    [num, txt, raw] = xlsread('csv2db/ArticleEvidenceRel_view.csv');
    
    ArticleEvidenceRel_ArticleIDs = uint16(num(:, 3));
    
    ArticleEvidenceRel_EvidenceIDs = uint16(num(:, 4));
    
    nArticleEvidenceRels = size(ArticleEvidenceRel_ArticleIDs, 1);
        
    clear num txt raw
    
    [num, txt, raw] = xlsread('csv2db/Article_view.csv');
    
    Article_ArticleIDs = uint16(num(:, 1));
    
    Article_PMIDs = raw(2:end, 2);
    
    Article_FirstPages = uint16(num(:, 12));
    
    Article_isReview = uint8(num(:, 16));
    
    Article_isFullyMined = uint8(num(:, 17));
    
    nArticleIDs = size(Article_ArticleIDs, 1);
    
    clear num txt raw
    
    
    fileId = fopen('articles_PoK.csv', 'w');
    
    fprintf(fileId, 'PMID,Article/Fragment_ID,isReview,Evidence_ID,Type_ID,Type_Name,Property_ID,Property_Subject,Property_Predicate,Property_Object\n');
    
    i = 0;
    
    for iEid = 1:nEids_unique
        
        eid = eids_unique(iEid);
        
        eid2tid_idx = find(EvidencePropertyTypeRel_EvidenceIDs == eid);
        
        tids_unique = unique(EvidencePropertyTypeRel_TypeIDs(eid2tid_idx));
        
        nTids_unique = length(tids_unique);
        
        for iTid = 1:nTids_unique
            
            tid = tids_unique(iTid);
            
            tid2tid_idx = Type_TypeIDs == tid;
            
            if sum(tid2tid_idx)
                
                tid_name = Type_nicknames{tid2tid_idx};
                
                eid2pid_idx = (EvidencePropertyTypeRel_EvidenceIDs == eid);
                
                pids_unique = unique(EvidencePropertyTypeRel_PropertyIDs(eid2pid_idx));
                
                nPids_unique = length(pids_unique);
                
                for iPid = 1:nPids_unique
                    
                    pid = pids_unique(iPid);
                    
                    pid2pid_idx = Property_PropertyIDs == pid;
                    
                    pid_subject = Property_subjects{pid2pid_idx};
                    
                    pid_predicate = Property_predicates{pid2pid_idx};
                    
                    pid_object = Property_objects{pid2pid_idx};
                    
                    eid2aid_idx = ArticleEvidenceRel_EvidenceIDs == eid;
                    
                    aids_unique = unique(ArticleEvidenceRel_ArticleIDs(eid2aid_idx));
                    
                    nAids_unique = length(aids_unique);
                    
                    for iAid = 1:nAids_unique
                        
                        aid = aids_unique(iAid);
                        
                        aid2aid_idx = Article_ArticleIDs == aid;
                        
                        if isempty(aid2aid_idx)
                            
                            pmid = 'N/A';
                            
                        else
                            
                            pmid = Article_PMIDs{aid2aid_idx};
                            
                            if (isnumeric(pmid))
                                
                                pmid = num2str(pmid);
                                
                            end % if (isnumeric(pmid))
                            
                        end
                        
                        isReview = Article_isReview(aid2aid_idx);
                        
                        isFullyMined = Article_isFullyMined(aid2aid_idx);
                        
                        if isFullyMined
                        
                            i = i + 1;
                            
                            % fprintf(fileId, 'PMID,Article/Fragment_ID,isReview,Evidence_ID,Type_ID,Type_Name,
                            %                  Property_ID,Property_Subject,Property_Predicate,Property_Object\n');
                            
                            if (aid == 277)  % pre-published version of Somogyi book chapter
                                aid = 269;   % published version of Somogyi book chapter
                            end
                            
                            fprintf(fileId, '''%s,%d,%d,%d,%d,%s,%d,%s,%s,%s\n', ...
                                pmid, ...
                                aid, ...
                                isReview, ...
                                eid, ...
                                tid, ...
                                tid_name, ...
                                pid, ...
                                pid_subject, ...
                                pid_predicate, ...
                                pid_object);
                        
                        end % if isFullyMined
                            
                    end % iAid
                    
                end % iPid
                
            end % if sum(tid2tid_idx)
            
        end % iTid
        
    end % iEid
    
    nMorphLoops = i
    
    
    [num, txt, raw] = xlsread('csv2db/EvidenceMarkerdataRel_view.csv');
    
    EvidenceMarkerdataRel_EvidenceIDs = uint16(num(:, 3));
    
    EvidenceMarkerdataRel_MarkerdataIDs = uint16(num(:, 4));
    
    nEvidenceMarkerdataRels = size(EvidenceMarkerdataRel_EvidenceIDs, 1);
    
    eids_unique = EvidenceMarkerdataRel_EvidenceIDs;
    
    nEids_unique = length(eids_unique);
    
    clear num txt raw
    
    [num, txt, raw] = xlsread('csv2db/EvidenceEvidenceRel_view.csv');
    
    EvidenceEvidenceRel_Evidence1IDs = uint16(num(:, 3));
    
    EvidenceEvidenceRel_Evidence2IDs = uint16(num(:, 4));
    
    clear num txt raw
    
    [num, txt, raw] = xlsread('csv2db/EvidenceFragmentRel_view.csv');
    
    EvidenceFragmentRel_EvidenceIDs = uint16(num(:, 3));
    
    EvidenceFragmentRel_FragmentIDs = uint16(num(:, 4));
        
    clear num txt raw
    
    [num, txt, raw] = xlsread('csv2db/Fragment_view.csv');
    
    Fragment_FragmentIDs = uint16(num(:, 1));
    
    Fragment_PMIDs = raw(2:end, 6);
    
    Fragment_isReview = uint8(num(:, 11));
    
    Fragment_isFullyMined = uint8(num(:, 12));
    
    clear num txt raw

    i = 0;
    
    for iEid = 1:nEids_unique
        
        eid = eids_unique(iEid);
        
        eid2mid_idx = EvidenceMarkerdataRel_EvidenceIDs == eid;
        
        eid2tid_idx = EvidencePropertyTypeRel_EvidenceIDs == eid;
        
        tids_unique = unique(EvidencePropertyTypeRel_TypeIDs(eid2tid_idx));
        
        nTids_unique = length(tids_unique);
        
        for iTid = 1:nTids_unique
            
            tid = tids_unique(iTid);
            
            tid2tid_idx = Type_TypeIDs == tid;
            
            if sum(tid2tid_idx)
                
                tid_name = Type_nicknames{tid2tid_idx};
                
                eid2pid_idx = (EvidencePropertyTypeRel_EvidenceIDs == eid);
                
                pids_unique = unique(EvidencePropertyTypeRel_PropertyIDs(eid2pid_idx));
                
                nPids_unique = length(pids_unique);
                
                for iPid = 1:nPids_unique
                    
                    pid = pids_unique(iPid);
                    
                    pid2pid_idx = Property_PropertyIDs == pid;
                    
                    pid_subject = Property_subjects{pid2pid_idx};
                    
                    pid_predicate = Property_predicates{pid2pid_idx};
                    
                    pid_object = Property_objects{pid2pid_idx};
                    
                    e1id2e2id_idx = EvidenceEvidenceRel_Evidence1IDs == eid;
                    
                    e2ids_unique = unique(EvidenceEvidenceRel_Evidence2IDs(e1id2e2id_idx));
                    
                    nE2ids_unique = length(e2ids_unique);
                    
                    for iE2id = 1:nE2ids_unique
                        
                        e2id = e2ids_unique(iE2id);
                        
                        e2id2fid_idx = EvidenceFragmentRel_EvidenceIDs == e2id;
                        
                        fids_unique = unique(EvidenceFragmentRel_FragmentIDs(e2id2fid_idx));
                        
                        nFids_unique = length(fids_unique);
                        
                        for iFid = 1:nFids_unique
                            
                            fid = fids_unique(iFid);
                            
                            fid2fid_idx = Fragment_FragmentIDs == fid;
                            
                            length(fid2fid_idx);
                            
                            pmids_unique = unique(Fragment_PMIDs{fid2fid_idx});
                            
                            nPmids_unique = length(pmids_unique);
                            
                            for iPmid = 1:nPmids_unique
                                
                                pmid = pmids_unique(iPmid);
                                
                                if (isnumeric(pmid))
                                    
                                    pmid = num2str(pmid);
                                    
                                end % if (isnumeric(pmid))
                                
                                isReview = Fragment_isReview(fid2fid_idx);
                                
                                isFullyMined = Fragment_isFullyMined(fid2fid_idx);
                                
                                if isFullyMined
                                
                                    i = i + 1;
                                    
                                    % fprintf(fileId, 'PMID,Article/Fragment_ID,isReview,Evidence_ID,Type_ID,Type_Name,
                                    %                  Property_ID,Property_Subject,Property_Predicate,Property_Object\n');
                                    
                                    fprintf(fileId, '''%s,%d,%d,%d,%d,%s,%d,%s,%s,%s\n', ...
                                        pmid, ...
                                        fid, ...
                                        isReview, ...
                                        eid, ...
                                        tid, ...
                                        tid_name, ...
                                        pid, ...
                                        pid_subject, ...
                                        pid_predicate, ...
                                        pid_object);
                                
                                end % if isFullyMined
                                
                            end % iPmid
                            
                        end % iFid
                        
                    end % iE2id
                    
                end % iPid
                
            end % if sum(tid2tid_idx)
            
        end % iTid
        
    end % iEid
    
    nMarkerLoops = i
    

    [num, txt, raw] = xlsread('csv2db/EpdataEvidenceRel_view.csv');
    
    EpdataEvidenceRel_EpdataIDs = uint16(num(:, 3));
    
    EpdataEvidenceRel_EvidenceIDs = uint16(num(:, 4));
    
    eids_unique = EpdataEvidenceRel_EvidenceIDs;
    
    nEids_unique = length(eids_unique);
    
    clear num txt raw
        
    i = 0;

    for iEid = 1:nEids_unique
        
        eid = eids_unique(iEid);
        
        eid2epid_idx = EpdataEvidenceRel_EvidenceIDs == eid;
        
        eid2tid_idx = EvidencePropertyTypeRel_EvidenceIDs == eid;
        
        tids_unique = unique(EvidencePropertyTypeRel_TypeIDs(eid2tid_idx));
        
        nTids_unique = length(tids_unique);
        
        for iTid = 1:nTids_unique
            
            tid = tids_unique(iTid);
            
            tid2tid_idx = Type_TypeIDs == tid;
            
            if sum(tid2tid_idx)
                
                tid_name = Type_nicknames{tid2tid_idx};
                
                eid2pid_idx = (EvidencePropertyTypeRel_EvidenceIDs == eid);
                
                pids_unique = unique(EvidencePropertyTypeRel_PropertyIDs(eid2pid_idx));
                
                nPids_unique = length(pids_unique);
                
                for iPid = 1:nPids_unique
                    
                    pid = pids_unique(iPid);
                    
                    pid2pid_idx = Property_PropertyIDs == pid;
                    
                    pid_subject = Property_subjects{pid2pid_idx};
                    
                    pid_predicate = Property_predicates{pid2pid_idx};
                    
                    pid_object = Property_objects{pid2pid_idx};
                    
                    e1id2e2id_idx = EvidenceEvidenceRel_Evidence1IDs == eid;
                    
                    e2ids_unique = unique(EvidenceEvidenceRel_Evidence2IDs(e1id2e2id_idx));
                    
                    nE2ids_unique = length(e2ids_unique);
                    
                    for iE2id = 1:nE2ids_unique
                        
                        e2id = e2ids_unique(iE2id);
                        
                        e2id2fid_idx = EvidenceFragmentRel_EvidenceIDs == e2id;
                        
                        fids_unique = unique(EvidenceFragmentRel_FragmentIDs(e2id2fid_idx));
                        
                        nFids_unique = length(fids_unique);
                        
                        for iFid = 1:nFids_unique
                            
                            fid = fids_unique(iFid);
                            
                            fid2fid_idx = Fragment_FragmentIDs == fid;
                            
                            pmid = unique(Fragment_PMIDs{fid2fid_idx});
                            
                            if (isnumeric(pmid))
                                
                                pmid = num2str(pmid);
                                
                            end % if (isnumeric(pmid))
                            
                            isReview = Fragment_isReview(fid2fid_idx);
                            
                            i = i + 1;
                            
                            % fprintf(fileId, 'PMID,Article/Fragment_ID,isReview,Evidence_ID,Type_ID,Type_Name,
                            %                  Property_ID,Property_Subject,Property_Predicate,Property_Object\n');
                            
                            fprintf(fileId, '''%s,%d,%d,%d,%d,%s,%d,%s,%s,%s\n', ...
                                pmid, ...
                                fid, ...
                                isReview, ...
                                eid, ...
                                tid, ...
                                tid_name, ...
                                pid, ...
                                pid_subject, ...
                                pid_predicate, ...
                                pid_object);
                            
                        end % iFid
                        
                    end % iE2id
                    
                end % iPid
                
            end % if sum(tid2tid_idx)
            
        end % iTid
        
    end % iEid
            
    nEphysLoops = i
    
    fclose(fileId);

end % article_PoK