%===========================Huffman Decoder=====================================

function huffman_decoder_final(fname)

in_fname = fname
out_fname = strcat(fname, '_decoded');
  
data_fid = fopen(strcat(in_fname, '_encoded.txt'), 'r');
dic_fid = fopen(strcat(in_fname, '_dictionary.txt'), 'r');

tic

%split each column in the text file by a comma
symbol_dictionary_split = textscan(dic_fid, '%s %s', 'Delimiter', ',');

%the symbol dictionary cell array is merged from the sub-cells of symbol dictionary split
symbol_dictionary = cell();
col1 = regexp(symbol_dictionary_split{1}, ',' ,'split');
col2 = regexp(symbol_dictionary_split{2}, ',' ,'split');
symbol_dictionary(:,1) = vertcat(col1{});
symbol_dictionary(:,2) = vertcat(col2{});
fclose(dic_fid);

%{1}{1} due to weird formatting of textscan (places text in a cell within a cell)
encoded_string = textscan(data_fid, '%s'){1}{1};

fclose(data_fid);

encoded_length = length(encoded_string);
temp_code = "";
decoded_string = "";
ascii_to_symbol = "";

[rows, ~] = size(symbol_dictionary);

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

decoded_string = "";

pos = 1;
while pos<encoded_length
  for j=1:rows
    len = length(symbol_dictionary{j,2});
    if pos+len-1 <= encoded_length && strcmp(encoded_string(pos:pos+len-1), symbol_dictionary(j,2))
      decoded_string = [decoded_string char(str2num(symbol_dictionary{j,1}))];
      pos = pos+len;
      break
    end
  end
end
toc


%output encoded data as new file
fid = fopen(out_fname, 'w');
fprintf(fid, '%s', decoded_string);
fclose(fid);

endfunction