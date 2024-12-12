function [] = wp_saveToH5(h5filename,propertyName,rows,columns,data)
%WP_SAVETOH5 此处显示有关此函数的摘要
%   此处显示详细说明
chunk_size = [rows, columns];
h5create(h5filename, propertyName, [rows columns],'Chunksize', chunk_size);

h5write(h5filename, propertyName, data, [1 1], [rows columns]);

disp("complete " + h5filename)

end

