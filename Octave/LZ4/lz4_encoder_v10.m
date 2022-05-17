%works for poem but not ico.bmp and ilia.png...

clear;clc;

%Read file into an array
fid = fopen("poem.txt", 'r');
data = fread(fid, 'uint8');
fclose(fid);

%define a function for extra bytes needed for tokens
function nibble plus_bytes = hi_lo_plus(token)
  plus_bytes = [dec2hex(hex2dec(token)-15)];
  total = plus_bytes(1);
  i=1;
  while total>=255
    plus_bytes(i)=255;
    total = total-255;
    plus_bytes(i+1)=total;
    i++;
  end
  nibble = dec2hex(15);
endfunction
  
matches=cell();

matches{1}=[];
last_byte_loc = [];

tic
%finding the literal matches
for pos=1:length(data)
  %last_byte_location array population
  if length(last_byte_loc)==0
    last_byte_loc(end+1, 1)=data(pos);
    last_byte_loc(end, 2) = 0;
  else
    index = find(last_byte_loc(:,1)==data(pos));
    if index~=0
      last_byte_loc(end+1, 1)=data(pos);
      last_byte_loc(end, 2) = max(index);
    else
      last_byte_loc(end+1, 1)=data(pos);
      last_byte_loc(end, 2) = 0;
    end
  end
  
  [rows, ~] = size(last_byte_loc);
  % nothing at first
  matches{pos}=[];
    
  last_seen = last_byte_loc(rows, 2);
  
  %specify number of bytes to look back for a match
  search_buffer = 100;
  
  %only searching where the byte was seen previously (last_byte_loc)
  while last_seen>0
    if last_seen>pos-search_buffer
      increase = 0;
      for cur = pos:length(data)
        if data(cur)~=data(last_seen+increase)
          break;
        end
        increase++;
      end
      if cur-pos>=4
        matches{pos} = [matches{pos} -(pos-last_seen) cur-pos];
      end
      last_seen = last_byte_loc(last_seen, 2);
    else
      break;
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
    if(hex2dec(hi_token)>=15)
      [hi_token hi_token_plus] = hi_lo_plus(hi_token); %run hi_lo_plus function
    end
    hi_token_plus = hex2dec(hi_token_plus);
    
    lo_token_plus = '';
    if(hex2dec(lo_token)>=15)
      [lo_token lo_token_plus] = hi_lo_plus(lo_token); %run hi_lo_plus function
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
hi_token_plus = '';
if(hex2dec(hi_token)>=15)
  [hi_token hi_token_plus] = hi_lo_plus(hi_token); %run hi_lo_plus function
end
hi_token_plus = hex2dec(hi_token_plus);

token = hex2dec(strcat(hi_token, '0'));
    
%append 00 00 00 00 onto final dataset
if length(literals)==0
  encoded_data = horzcat(encoded_data, [00 00 00 00]); 
else
  encoded_data = horzcat(encoded_data, token, hi_token_plus, literals, 00, 00, [00 00 00 00]);
end
toc

%Output to file
fid = fopen("poem.lz4", "w");
fprintf(fid, "%s", encoded_data{:});
fclose(fid);
fprintf("File Writing Complete.\n")