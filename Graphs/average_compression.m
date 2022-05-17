% Bar Plot

averages = [71.07; 66.72; 63.23; 59.46; 54.91; 52.42; 70.62]';

file_names = {'lz4[128 buffer]','lz4[256 buffer]','lz4[512 buffer]','lz4[1024 buffer]','lz4[2048 buffer]','lz4[4096 buffer]','huffman'};

x = averages;

plot = bar(x);
%plot(1).FaceColor = [1 .4 0];
set(gca, 'xticklabel',file_names, 'xticklabelrotation', 90);