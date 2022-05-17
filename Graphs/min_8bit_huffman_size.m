% Bar Plot

data_8bit = csvread('data_8bit_size.txt');
data_8bit = data_8bit(3:end);

data_min = csvread('data_min_size.txt');
data_min = data_min(3:end);

data_encoded = csvread('data_huff_size.txt');
data_encoded = data_encoded(3:end);

file_names = {'cp.html','fields.c','grammar.lsp','ico.bmp','obj1','paper1','poem.txt','progc','progp','sum','xargs.1'};

x = [data_8bit; data_min; data_encoded]';

plot = bar(x, 1);
set (plot(1), 'facecolor', 'b');
set (plot(2), 'facecolor', 'k');
set (plot(3), 'facecolor', 'm');
set(gca, 'xticklabel',file_names, 'xticklabelrotation', 90);