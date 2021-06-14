function [data,perc_rect] = adp_filt(rawdata)
%ADP_FILT     Adaptive high pass filter based on data-driven likelihood threshold
%   [DATA_RECT, PERC_RECT] = ADP_FILT(DATA) outputs the rectified data and percent rectified for each label.
%
%   INPUTS:
%   RAWDATA    A matrix generated by DeepLabCut (rows of observations & columns of x, y, and likelihoods).
%
%   OUTPUTS:
%   DATA    Data matrix rectified after low-pass filter replacing the value with the most recent confident x,y.
%   PERC_RECT    Percent rectified for each body part.  This is just to inform the user how much data is below the threshold. 
%   Consider retraining/refining the network if this value is above 10% for points that are not constantly occluded.
%
%   Examples:
%   clear rawdata;
%   load MsInOpenFieldRAW.mat
%   [data,perc_rect] = adp_filt(rawdata);
%
%   Created by Alexander Hsu, Date: 021920
%   Contact ahsu2@andrew.cmu.edu

    if isstruct(rawdata) || iscell(rawdata)
        error('Input data has to be a matrix');
    end
    %fprintf('Replacing data-driven low likelihood positions with the most recent highly probable position... \n');
    datax = rawdata(:,[2:3:end]);
    datay = rawdata(:,[3:3:end]);
    data_lh = rawdata(:,[4:3:end]);
    % filter out likelihood below rise phase
    for x = 1:length(data_lh(1,:))
        [a,b] = hist(data_lh(:,x));
        rise_a = find(diff(a)>=0);
        if (isempty(rise_a))
            llh = 1;
        elseif((rise_a(1) > 1) || length(rise_a)==1)
            llh = b(rise_a(1));
        else
            llh = b(rise_a(2));
        end
        perc_rect(x) = length(find(data_lh(:,x) < llh))/length(data_lh); % find the percentage of filtered data
        data(1,(2*x-1):2*x) = [datax(1,x),datay(1,x)]; % compile the array
        % replacing with most recent highly probable positions
        for i = 2:length(data_lh)
            if  data_lh(i,x) < llh
                data(i,(2*x-1):2*x) = data(i-1,(2*x-1):2*x);
            else
                data(i,(2*x-1):2*x) = [datax(i,x),datay(i,x)];
            end
        end
    end
return