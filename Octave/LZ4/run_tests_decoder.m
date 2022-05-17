clear;clc;

fprintf("LZ4 Decoder Results\n")

filenames = {'a0020.txt.lz4','a0270.txt.lz4','cp.html.lz4','fields.c.lz4','grammar.lsp.lz4','ico.bmp.lz4','obj1.lz4','paper1.lz4','poem.txt.lz4','progc.lz4','progp.lz4','sum.lz4','xargs.1.lz4'};
filename = '';

for i=1:length(filenames)
  fprintf("\n\n")
  filename = filenames{i}
  lz4_decoder_final(filenames{i})
end
