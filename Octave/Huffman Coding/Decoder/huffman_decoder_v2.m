%=========================Huffman Decoder v2====================================
function [] = huffman_decoder_v2(fname)
  
data_fid = fopen('../Dictionary Files/encoded_data.txt', 'r');
dic_fid = fopen('../Dictionary Files/dictionary.txt', 'r');

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

%probably can avoid having to use a nested 'for' loop...
%tic
%for i = 1:encoded_length
%  temp_code = strcat(temp_code, encoded_string(i));
%  for j = 1:rows
%    check = strcmpi(temp_code, symbol_dictionary(j,2));
%     if check==1
%       %converting ascii representation to symbol (works for space, not for \n etc)
%       ascii_to_symbol = char(str2num(symbol_dictionary{j,1}));
%       decoded_string = [decoded_string, ascii_to_symbol];
%       temp_code = "";
%     end
%  end
%end
%toc

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

tic
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

%encoded_string
%decoded_string
symbol_dictionary

fname = 'result.txt';

%output encoded data as new file
fid = fopen(strcat('../Output Files/', fname), 'w');
fprintf(fid, '%s', decoded_string);
fclose(fid);

end