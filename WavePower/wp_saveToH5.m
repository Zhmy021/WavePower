function [outputArg1,outputArg2] = wp_saveToH5(inputArg1,inputArg2)
%WP_SAVETOH5 此处显示有关此函数的摘要
%   此处显示详细说明

EXCEL_FILE_PATH = "C:\Users\zmyzq\Desktop\WEC种类参数.xlsx";
WEC_LIST = {'Pontoon','SeaPower','Langlee','OE_buoy','AquaBuOY','Wavebob','Pelamis','AWS'};
block_size = 8760;
years = 10;  %  需保存的年份数

for start_row = 1:block_size:8760*years

    fprintf('start from %d to %d\n',start_row,start_row+8759);

    SWH_block = h5read("database_h5\SWAN_data.h5", '/SWH', [start_row 1], [block_size 10613]);
    PERIOD_block = h5read("database_h5\SWAN_data.h5", '/PERIOD', [start_row 1], [block_size 10613]);
    
    WP_block = 0.5 * (SWH_block .* SWH_block .* PERIOD_block);
    WP_block(isnan(WP_block)) = 0;
    h5write("database_h5\SWAN_data.h5", '/Power', WP_block, [start_row 1], [block_size 10613]);
    
   for index = 1:8
        disp(['start  ',WEC_LIST{index}])
        WECuse_block   = zeros(8760, 10613);
        power_function = getWEC(EXCEL_FILE_PATH, WEC_LIST{index});

        for i = 1:8760
            hs = SWH_block(i, :);
            tm = PERIOD_block(i, :);
            WECuse_block(i, :) = power_function(tm, hs);
        end
        
        WECuse_block(isnan(WECuse_block)) = 0;
        
        strut = ['/WEC/', WEC_LIST{index}];
    
        h5write("database_h5\SWAN_data.h5", strut, WECuse_block, [start_row 1], [block_size 10613]);
    end
    
end

end

