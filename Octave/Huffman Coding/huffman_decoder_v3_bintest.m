%=========================Huffman Decoder v3====================================
%======================encoded_data.bin working=================================

in_fname = "xargs";
out_fname = 'xargs_decoded.1';
  
data_fid = fopen(strcat(in_fname, '_encoded.bin'), 'r');
dic_fid = fopen(strcat(in_fname, '_dictionary.txt'), 'r');

encoded_arr = fread(data_fid);
fclose(data_fid);
encoded_char_arr = cellstr(dec2bin(encoded_arr));
encoded_string = [encoded_char_arr{:}];

encoded_string;


%split each column in the text file by a comma
symbol_dictionary_split = textscan(dic_fid, '%s %s', 'Delimiter', ',');

%the symbol dictionary cell array is merged from the sub-cells of symbol dictionary split
symbol_dictionary = cell();
col1 = regexp(symbol_dictionary_split{1}, ',' ,'split');
col2 = regexp(symbol_dictionary_split{2}, ',' ,'split');
symbol_dictionary(:,1) = vertcat(col1{});
symbol_dictionary(:,2) = vertcat(col2{});
fclose(dic_fid);

encoded_length = length(encoded_string);
temp_code = "";
decoded_string = "";
ascii_to_symbol = "";

[rows, ~] = size(symbol_dictionary);

tic
%symbol_dictionary must be sorted using bubble sort
for i=1:rows-1
  for j=i+1:rows
    if length(symbol_dictionary{i,2})>length(symbol_dictionary{j,2})
      t = symbol_dictionary(i,:);
      symbol_dictionary(i,:) = symbol_dictionary(j,:);
      symbol_dictionary(j,:) = t;
    end
  end
end
toc

decoded_string = "";

%max size bit string length
max_bitstr = numel(symbol_dictionary{end,2});

tic
pos = 1;
while pos<encoded_length
  for j=1:rows
    count++;
    len = length(symbol_dictionary{j,2});
    if pos+len-1 <= encoded_length && strcmp(encoded_string(pos:pos+len-1), symbol_dictionary(j,2))
      decoded_string = [decoded_string char(str2num(symbol_dictionary{j,1}))];
      pos = pos+len;
      break
    elseif encoded_length <= pos+len-1
      break
    end
  end
end
toc

%encoded_string
%decoded_string
%symbol_dictionary

%output encoded data as new file
fid = fopen(out_fname, 'w');
fprintf(fid, '%s', decoded_string);
fclose(fid);