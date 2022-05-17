clear;clc;

%Read file into an array
fid = fopen("tree_test.txt", 'r');
data = fread(fid, 'uint8');
fclose(fid);

matches=cell();%1,length(data));

matches{1}=[];
last_byte_loc = [];

tic
%finding the literal matches
for pos=1:length(data)
  
  %last_byte_location array population
  if length(last_byte_loc)==0
    last_byte_loc(end+1, 1)=data(pos);
    last_byte_loc(end, 2) = -1;
  else
    index = find(last_byte_loc(:,1)==data(pos));
    if index~=0
      last_byte_loc(end+1, 1)=data(pos);
      last_byte_loc(end, 2) = max(index);
    else
      last_byte_loc(end+1, 1)=data(pos);
      last_byte_loc(end, 2) = -1;
    end
  end
  
  
  % nothing at first
  matches{pos}=[];
    
  % searching for matches
  for offset=1:min(4096,pos-1)    
    if data(pos)==data(pos-offset)
      for cur=pos+1:length(data)
        if data(cur)~=data(cur-offset)
          break
        end
      end
      if cur-pos>=4
        matches{pos}=[matches{pos} -offset cur-pos];
      end
    end
    
  end
  
end
toc

matches;
encoded_data = cell(); %required to store hex
encoded_data = horzcat(encoded_data, [4 34 77 24 0 0 0 0 0 0 0]); %lz4 verification
[~, cols] = size(matches);
literals = [];
pos=1;

tic
while pos<=cols
  
  if length(matches{1,pos})!=0
    
    %check the maximum values in the current [matches] row
    [max_val idx] = max(matches{1, pos});
    max_ml_idx = idx(1); %in case of duplicate max_vals
    
    hi_token = dec2hex(length(literals)); %length of literals
    lo_token = dec2hex(matches{1, pos}(max_ml_idx)-4); %match length
    
    hi_token_plus = '';
    %caters for literal length of 270...
    if(hex2dec(hi_token)>=15)
      hi_token_plus = dec2hex(hex2dec(hi_token)-15);
      hi_token = dec2hex(15);
    end
    hi_token_plus = hex2dec(hi_token_plus);
    
    lo_token_plus = '';
    %caters for match length of 274...
    if(hex2dec(lo_token)>=15)
      lo_token_plus = dec2hex(hex2dec(lo_token)-15);
      lo_token = dec2hex(15);
    end
    lo_token_plus = hex2dec(lo_token_plus);
    
    %working with the offset  
    offset_byte1 = -matches{1, pos}(max_ml_idx-1);
    offset_byte2 = 0;
    
    %Little Endian
    if offset_byte1>=256
      offset_byte2 = floor(offset_byte1/256);
      while offset_byte1>=256
        offset_byte1 = offset_byte1-256;
      end
    end
    
    %concatenate hi and lo tokens
    token = hex2dec(strcat(hi_token, lo_token));
    
    %adding data to the encoded_data array
    if length(literals)==0
        encoded_data = horzcat(encoded_data, token, offset_byte1, offset_byte2, lo_token_plus);
    else
        encoded_data = horzcat(encoded_data, token, hi_token_plus, literals, offset_byte1, offset_byte2, lo_token_plus);
    end
    
    pos = pos+matches{1, pos}(max_ml_idx);
    literals = [];
    
  else
    literals = horzcat(literals, data(pos));
    pos++;
  end
end

%for extra literals at the end of the data
hi_token = dec2hex(length(literals));
token = hex2dec(strcat(hi_token, '0'));
    
%append 00 00 00 00 onto final dataset
if length(literals)==0
  encoded_data = horzcat(encoded_data, [00 00 00 00]); 
else
  encoded_data = horzcat(encoded_data, token, literals, 00, 00, [00 00 00 00]);
end
toc

%Output to file
fid = fopen("tree_test.lz4", "w");
fprintf(fid, "%s", encoded_data{:});
fclose(fid);
fprintf("File Writing Complete.\n")