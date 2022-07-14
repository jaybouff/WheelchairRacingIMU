function [ TAratio ] = EMGratioCode( GroupData,AnalTA, criticalCycles, SyncData, path )
%EMGratioCode Is used to compute EMGratio as in Bouffard et al. 2016 Neural
%Plasticity during force field adaptation. Inputs include the Force Command
%Signal synchronised on Heelstrike and the RBIAnalTA signal synchronised on
%the middle of the ENCO signal during pushoff.


%% Load files
[fn, pn] = uigetfile(path, 'Go get your KINEMATIC analysis file (AnalENCO)') ;
load([pn fn],'AnalENCO');

nsujets=length(AnalTA.TA.Baseline2);

for isujet=nsujets:-1:1
    %% Get the baseline cycles used for kinematic Analyses with valid EMG and compute baseline template
    TAratio.baselinelateTA(:,isujet)=mean(AnalTA.TA.Baseline2{isujet}(:,AnalENCO.CyclesBaseline{isujet}),2);
    
    %% Get mean TA activity for the valid cycles during Fearly and late
    FFearlycycles=find(~isnan(AnalTA.TA.CHAMP{isujet}(1,2:11))...
        & ~isnan(AnalENCO.meanABSError.CHAMP{isujet}(2:11)));
    FFearlycycles=FFearlycycles+1;
    TAratio.FFearlyTA(:,isujet)=mean(AnalTA.TA.CHAMP{isujet}(:,FFearlycycles),2);
    
    FFlatecycles=find(~isnan(AnalTA.TA.CHAMP{isujet}(1,end-49:end))...
        & ~isnan(AnalENCO.meanABSError.CHAMP{isujet}(end-49:end)));
    FFlatecycles=FFlatecycles+length(AnalENCO.meanABSError.CHAMP{isujet})-50;
    TAratio.FFlateTA(:,isujet)=mean(AnalTA.TA.CHAMP{isujet}(:,FFlatecycles),2);
    
    %% Compute TA ratio and log transformed TA ratio
    TAratio.FFearlyratio(:,isujet)=TAratio.FFearlyTA(:,isujet)./TAratio.baselinelateTA(:,isujet);
    TAratio.FFlateratio(:,isujet)=TAratio.FFlateTA(:,isujet)./TAratio.baselinelateTA(:,isujet);
    
    TAratio.log2FFearlyratio(:,isujet)=log2(TAratio.FFearlyratio(:,isujet));
    TAratio.log2FFlateratio(:,isujet)=log2(TAratio.FFlateratio(:,isujet));
    
    %% Synchronise CONS_F signal with TA and interpolate on 1300 sample
    k=criticalCycles(3,isujet)-criticalCycles(2,isujet);
    for istride=criticalCycles(3,isujet):-1:criticalCycles(2,isujet)+1
        if GroupData.Cycle_Table{isujet}(3,istride)==1 && SyncData.SyncTiming{isujet}(istride) < length(GroupData.CONS_F{isujet}{istride}) &&...
                ~isnan(AnalTA.dureeswing.CHAMP{isujet}(k))
            
            
            if max(SyncData.SyncTiming{isujet})>1 % if we use a SyncTiming
                x=SyncData.SyncTiming{isujet}(istride)-round(AnalTA.dureeswing.CHAMP{isujet}(k)*0.3):length(GroupData.CONS_F{isujet}{istride}(:));
                y=GroupData.CONS_F{isujet}{istride}(x);
                
                TAratio.CONS_F{isujet}(:,k)=interp1(1:length(x),y,1:(length(x)-1)/1299:length(x));
                
            else % if we use the first data point of the stride
                
                x = 1:length(GroupData.CONS_F{isujet}{istride});
                y = GroupData.CONS_F{isujet}{istride};
                TAratio.CONS_F{isujet}(:,k)=interp1(x,y,1:(length(x)-1)/(1299):length(x));
            end
            %% Find Peak Force Timing (PFC) for each stride
            TAratio.peakCONS_Ftiming{isujet}(k)=round(find(TAratio.CONS_F{isujet}(:,k)==min(TAratio.CONS_F{isujet}(:,k)),1,'first'));
            
        else
            TAratio.CONS_F{isujet}(1:1300,k)=nan;
            TAratio.peakCONS_Ftiming{isujet}(k)=nan;
        end
        
        k=k-1;
    end
    
    if ~isempty(FFearlycycles)
        %% Find averaged PFC during early and late adaptation
        TAratio.peakCONS_FtimingFFearly(isujet)=round(mean(TAratio.peakCONS_Ftiming{isujet}(FFearlycycles)));
        %% Compute Total TAratio, TAratio BeforePFC and TAratio AfterPFC and their log2 transform
        TAratio.BeforePFCEarly(isujet)=mean(TAratio.FFearlyratio(1:TAratio.peakCONS_FtimingFFearly(isujet),isujet));
        TAratio.log2BeforePFCEarly(isujet)=mean(TAratio.log2FFearlyratio(1:TAratio.peakCONS_FtimingFFearly(isujet),isujet));
        % For AfterPFC and Total, we use nanmean because the RBI filter applied
        % before TA analysis code create nans at the end of each stride. Does
        % not affect BeforePFC because the beginning of this window (30% stride duration before TO) is not the
        % beginning of the stride (HC)
        TAratio.AfterPFCEarly(isujet)=mean(TAratio.FFearlyratio(TAratio.peakCONS_FtimingFFearly(isujet):end,isujet));
        TAratio.log2AfterPFCEarly(isujet)=mean(TAratio.log2FFearlyratio(TAratio.peakCONS_FtimingFFearly(isujet):end,isujet));
        TAratio.TotalEarly(isujet)=mean(TAratio.FFearlyratio(:,isujet));
        TAratio.log2TotalEarly(isujet)=mean(TAratio.log2FFearlyratio(:,isujet));
        
    end
    
    
    if ~isempty(FFlatecycles)
        
        TAratio.peakCONS_FtimingFFlate(isujet)=round(mean(TAratio.peakCONS_Ftiming{isujet}(FFlatecycles)));
        
        %% Compute Total TAratio, TAratio BeforePFC and TAratio AfterPFC and their log2 transform
        
        TAratio.BeforePFCLate(isujet)=mean(TAratio.FFlateratio(1:TAratio.peakCONS_FtimingFFlate(isujet),isujet));
        TAratio.log2BeforePFCLate(isujet)=mean(TAratio.log2FFlateratio(1:TAratio.peakCONS_FtimingFFlate(isujet),isujet));
        
        % For AfterPFC and Total, we use nanmean because the RBI filter applied
        % before TA analysis code create nans at the end of each stride. Does
        % not affect BeforePFC because the beginning of this window (30% stride duration before TO) is not the
        % beginning of the stride (HC)
        
        TAratio.AfterPFCLate(isujet)=mean(TAratio.FFlateratio(TAratio.peakCONS_FtimingFFlate(isujet):end,isujet));
        TAratio.log2AfterPFCLate(isujet)=mean(TAratio.log2FFlateratio(TAratio.peakCONS_FtimingFFlate(isujet):end,isujet));
        
        
        TAratio.TotalLate(isujet)=mean(TAratio.FFlateratio(:,isujet));
        TAratio.log2TotalLate(isujet)=mean(TAratio.log2FFlateratio(:,isujet));
    end
end