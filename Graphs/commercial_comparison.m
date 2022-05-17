% Bar Plot

values = [71.07; 66.72; 63.23; 59.46; 54.91; 52.42; 70.62; 67.20; 58.23; 43.35; 35.64; 33.17; 33.14; 33.14; 31.56]';

file_names = {'lz4[128 buffer]','lz4[256 buffer]','lz4[512 buffer]','lz4[1024 buffer]','lz4[2048 buffer]','lz4[4096 buffer]','huffman', 'smallz4 -1', 'smallz4 -4', 'smallz4 -9', 'rar -m1', 'rar -m3', 'rar -m5', '7z -mx1', '7z -mx5'};

x = values;

plot = bar(x);
set(gca, 'xticklabel',file_names, 'xticklabelrotation', 90);