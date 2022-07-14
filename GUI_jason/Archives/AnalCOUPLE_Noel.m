function [COUPLE,rmsCOUPLEtotal,rmsCOUPLE020,rmsCOUPLE20100,meanCOUPLEtotal,meanCOUPLE020,meanCOUPLE20100] = AnalCOUPLE_Noel( data,Cycle_Table )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

load('SyncData.mat');
load('CyclesCritiques.mat');

n=find(isnan(Cycle_Table(1,1,:))==1);
if n>0
    n=n(1)-1;
else
    n=30;
end

COUPLE.baseline2(1:1000,1:588,1:30)=nan;
COUPLE.CHAMP(1:1000,1:397,1:30)=nan;
COUPLE.POST(1:1000,1:290,1:30)=nan;

rmsCOUPLEtotal.baseline2(1:588,1:30)=nan;
rmsCOUPLEtotal.CHAMP(1:397,1:30)=nan;
rmsCOUPLEtotal.POST(1:290,1:30)=nan;

rmsCOUPLE020.baseline2(1:588,1:30)=nan;
rmsCOUPLE020.CHAMP(1:397,1:30)=nan;
rmsCOUPLE020.POST(1:290,1:30)=nan;

rmsCOUPLE20100.baseline2(1:588,1:30)=nan;
rmsCOUPLE20100.CHAMP(1:397,1:30)=nan;
rmsCOUPLE20100.POST(1:290,1:30)=nan;

meanCOUPLEtotal.baseline2(1:588,1:30)=nan;
meanCOUPLEtotal.CHAMP(1:397,1:30)=nan;
meanCOUPLEtotal.POST(1:290,1:30)=nan;

meanCOUPLE020.baseline2(1:588,1:30)=nan;
meanCOUPLE020.CHAMP(1:397,1:30)=nan;
meanCOUPLE020.POST(1:290,1:30)=nan;

meanCOUPLE20100.baseline2(1:588,1:30)=nan;
meanCOUPLE20100.CHAMP(1:397,1:30)=nan;
meanCOUPLE20100.POST(1:290,1:30)=nan;


for i=1:n
    i
    k=0;
    
    for j=1:FF1(i)-1
        k=k+1;
        
        if Cycle_Table(3,j,i)==1    
            COUPLE.baseline2(:,k,i)=data(:,j,i);   
        else
            COUPLE.baseline2(:,k,i)=nan;          
        end
        cycleID.baseline2(k,i)=j;
        
        
    end
    BASELINE2end(i)=k;
    temp=find(isnan(COUPLE.baseline2(1,:,i)')==0);
    baseline2(:,i)=mean(COUPLE.baseline2(:,temp(end-99:end),i),2);
    clear temp
    
    k=0;
    
    for j=FF1(i):POST1(i)-1
        k=k+1;
        
        if Cycle_Table(3,j,i)==1
            
            COUPLE.CHAMP(:,k,i)=data(:,j,i);
            
        else
            COUPLE.CHAMP(:,k,i)=nan;
           
        end
        cycleID.CHAMP(k,i)=j;   
        
    end
    
    CHAMPend(i)=k;
    
    k=0;
    
    for j=POST1(i):fin(i)-1
        k=k+1;
        
        if Cycle_Table(3,j,i)==1
            
            COUPLE.POST(:,k,i)=data(:,j,i);
            
        else
            COUPLE.POST(:,k,i)=nan;
            
        end
        cycleID.POST(k,i)=j;
        
        
    end
    
    POSTend(i)=k;
   
end


for i=1:n

for j=1:BASELINE2end(i)
    
    if isnan(COUPLE.baseline2(1,j,i))==0
        
        
        rmsCOUPLEtotal.baseline2(j,i)=sqrt(mean(COUPLE.baseline2(:,j,i).^2));
        rmsCOUPLE020.baseline2(j,i)=sqrt(mean(COUPLE.baseline2(1:200,j,i).^2));
        rmsCOUPLE20100.baseline2(j,i)=sqrt(mean(COUPLE.baseline2(200:1000,j,i).^2));
        
        meanCOUPLEtotal.baseline2(j,i)=mean(COUPLE.baseline2(:,j,i));
        meanCOUPLE020.baseline2(j,i)=mean(COUPLE.baseline2(1:200,j,i));
        meanCOUPLE20100.baseline2(j,i)=mean(COUPLE.baseline2(200:1000,j,i));      
        
    end
    
end

for j=1:CHAMPend(i)
    
    if isnan(COUPLE.CHAMP(1,j,i))==0
        
        
        rmsCOUPLEtotal.CHAMP(j,i)=sqrt(mean(COUPLE.CHAMP(:,j,i).^2));
        rmsCOUPLE020.CHAMP(j,i)=sqrt(mean(COUPLE.CHAMP(1:200,j,i).^2));
        rmsCOUPLE20100.CHAMP(j,i)=sqrt(mean(COUPLE.CHAMP(200:1000,j,i).^2));
        
        meanCOUPLEtotal.CHAMP(j,i)=mean(COUPLE.CHAMP(:,j,i));
        meanCOUPLE020.CHAMP(j,i)=mean(COUPLE.CHAMP(1:200,j,i));
        meanCOUPLE20100.CHAMP(j,i)=mean(COUPLE.CHAMP(200:1000,j,i));      
        
    end
    
end
        
for j=1:POSTend(i)
    
    if isnan(COUPLE.POST(1,j,i))==0
        
        
        rmsCOUPLEtotal.POST(j,i)=sqrt(mean(COUPLE.POST(:,j,i).^2));
        rmsCOUPLE020.POST(j,i)=sqrt(mean(COUPLE.POST(1:200,j,i).^2));
        rmsCOUPLE20100.POST(j,i)=sqrt(mean(COUPLE.POST(200:1000,j,i).^2));
        
        meanCOUPLEtotal.POST(j,i)=mean(COUPLE.POST(:,j,i));
        meanCOUPLE020.POST(j,i)=mean(COUPLE.POST(1:200,j,i));
        meanCOUPLE20100.POST(j,i)=mean(COUPLE.POST(200:1000,j,i));      
        
    end
    
end        
    
end

