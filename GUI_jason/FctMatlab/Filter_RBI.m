
function fdata = FilterRBI(data,windowlength,type,dim)
% This function do a Rectified bin averaging filtering of EMG data !!! CODE
% AND COMMENTS TO BE COMPLETED IF THE FUNCTION IS TO BE GENERALIZED
%Inputs: data: 2d or 3d Data tables
% window length: Length of the rbi window
%type: 1=vector; 2= matrixè 3= 3D matrix
%dim: dimension of the table corresponding to time

if isnumeric(data) % if data is numeric (not used in GUI_analysis_JB)
    dimension=size(data);
    data=abs(data);
    
    
    
    if type == 3
        
        fdata(1:dimension(1),1:dimension(2),1:dimension(3))=nan;
        
        if dim == 1
            
            for itime=ceil(windowlength/2):dimension(1)-ceil(windowlength/2)
                
                fdata(itime,:,:)=mean(data(itime-floor(windowlength/2):itime+floor(windowlength/2),:,:),1);
                
            end
        end
        
    end
    
elseif iscell(data)
    
    for isubject = length(data):-1:1
        for istride = length(data{isubject}):-1:1
        for itime=ceil(windowlength/2):length(data{isubject}{istride})-ceil(windowlength/2)
            
            fdata{isubject}{istride}(itime,:)=mean(abs(data{isubject}{istride}(itime-floor(windowlength/2):itime+floor(windowlength/2))));
            
        end
        fdata{isubject}{istride}(1:ceil(windowlength/2)-1)=fdata{isubject}{istride}(ceil(windowlength/2));
        fdata{isubject}{istride}(length(data{isubject}{istride})-ceil(windowlength/2)+1:length(data{isubject}{istride}))...
            = fdata{isubject}{istride}(length(data{isubject}{istride})-ceil(windowlength/2));
        end
    end
    end



