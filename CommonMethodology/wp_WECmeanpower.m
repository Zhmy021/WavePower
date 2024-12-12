function [meanWEC,meanPower] = wp_WECmeanpower(h5filePath)

meanWEC = zeros(8,10,10613);
meanPower = zeros(10, 10613);
WEC_LIST = {'Pontoon','SeaPower','Langlee','OE_buoy','AquaBuOY','Wavebob','Pelamis','AWS'};

ind = 1;
for start_row = 1:8760:87600
    
    fprintf('start from %d to %d\n',start_row,start_row+8759);
    
    for index = 1:1:8
        disp(['start  ',WEC_LIST{index}])
        strut = ['/WEC/', WEC_LIST{index}];
        WEC_block = h5read(h5filePath, strut, [start_row 1], [8760 10613]);
        meanWEC_block = mean(WEC_block);
        meanWEC(index,ind,:) = meanWEC_block;
    end

    Power_block = h5read(h5filePath, '/Power', [start_row 1], [8760 10613]);

    meanPower_block = mean(Power_block);
    
    meanPower(ind,:) = meanPower_block;

    ind = ind + 1;

end

end

