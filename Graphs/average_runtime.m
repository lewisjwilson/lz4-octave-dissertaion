% Bar Plot

averages = [23.85; 25.91; 27.84; 41.50; 72.38; 128.44; 14.44]';

file_names = {'lz4[128 buffer]','lz4[256 buffer]','lz4[512 buffer]','lz4[1024 buffer]','lz4[2048 buffer]','lz4[4096 buffer]','huffman'};

x = averages;

plot = bar(x);
%plot(1).FaceColor = [1 .4 0];
set(gca, 'xticklabel',file_names, 'xticklabelrotation', 90);