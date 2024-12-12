function [] = wp_WECwavepower(h5filePath,rows,columns)

EXCEL_FILE_PATH = "C:\Users\zmyzq\Desktop\WEC种类参数.xlsx";
WEC_LIST = {'Pontoon','SeaPower','Langlee','OE_buoy','AquaBuOY','Wavebob','Pelamis','AWS'};
block_size = rows;  % 8760

for start_row = 1:block_size:87600

    fprintf('start from %d to %d\n',start_row,start_row+8759);

    SWH_block = h5read(h5filePath, '/SWH', [start_row 1], [block_size columns]);
    PERIOD_block = h5read(h5filePath, '/PERIOD', [start_row 1], [block_size columns]);
    
    WP_block = 0.5 * (SWH_block .* SWH_block .* PERIOD_block);
    WP_block(isnan(WP_block)) = 0;

    % 写入波浪能密度
    h5write(h5filePath, '/Power', WP_block, [start_row 1], [block_size columns]);
    
    % 循环写入WEC能量密度
   for index = 1:8
        disp(['start  ',WEC_LIST{index}])
        WECuse_block   = zeros(8760, columns);
        power_function = wp_getWec(EXCEL_FILE_PATH, WEC_LIST{index});

        for i = 1:8760
            hs = SWH_block(i, :);
            tm = PERIOD_block(i, :);
            WECuse_block(i, :) = power_function(tm, hs);
        end
        
        WECuse_block(isnan(WECuse_block)) = 0;
        
        strut = ['/WEC/', WEC_LIST{index}];
    
        h5write(h5filePath, strut, WECuse_block, [start_row 1], [block_size columns]);
    end
    
end

end

