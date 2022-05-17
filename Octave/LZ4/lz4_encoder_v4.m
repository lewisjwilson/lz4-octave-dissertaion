clear;clc;

%Read file into an array
fid = fopen("a0020.txt", 'r');
data = fread(fid, 'uint8');
fclose(fid);

matches=cell();

matches{1}=[];

%finding the literal matches
for pos=2:length(data)
  
  % nothing at first
  matches{pos}=[];
  
  % searching for matches
  for offset=1:min(1024,pos-1)
    ml=0;
    while pos+ml<=length(data) && data(pos+ml)==data(pos-offset+ml)
      ml=ml+1;
    end
    if ml>=4
      matches{pos}=[matches{pos} -offset ml];
    end
  end
  
end

matches;
encoded_data = cell(); %required to store hex
encoded_data = horzcat(encoded_data, [4 34 77 24 0 0 0 0 0 0 0]); %lz4 verification
[~, cols] = size(matches);
literals = [];
pos=1;

while pos<=cols
  
  if length(matches{1,pos})!=0
    
    max_arr = [];
    max_ml_idx = 0;
    
    %makes sure match does not reach last 5 characters of the data
    for(i = 1 : 2 : length(matches{1, pos})-1)
      max_arr = horzcat(max_arr, -matches{1, pos}(i)+matches{1, pos}(i+1));
    end
    
    for(i = 1 : length(max_arr))
      if max_arr(i)<=cols-5
        max_ml_idx = i*2;
        break;
      end
    end
    
    if max_ml_idx==0
      pos++;
      continue;
    end
    
    
    hi_token = dec2hex(length(literals)); %length of literals
    lo_token = dec2hex(matches{1, pos}(max_ml_idx)-4); %match length
    
    extra_lo=-1;
    if lo_token>='F'
      extra_lo = hex2dec(lo_token)-15;
      lo_token = dec2hex(15);
    end
    
    offset = -matches{1, pos}(max_ml_idx-1); %offset
    
    %concatenate hi and lo tokens
    token = hex2dec(strcat(hi_token, lo_token));
    
    %appending extra match length tokens
    if extra_lo>=-1
      %avoid copying an entry array entry
      if length(literals)==0
        encoded_data = horzcat(encoded_data, token, offset, extra_lo, 0);
      else
        encoded_data = horzcat(encoded_data, token, literals, offset, extra_lo, 0);
      end
    else
      if length(literals)==0
        encoded_data = horzcat(encoded_data, token, offset, 0);
      else
        encoded_data = horzcat(encoded_data, token, literals, offset, 0);
      end
    end
    pos = pos+hex2dec(lo_token)+4;
    
    literals = [];
    
  else
    literals = horzcat(literals, data(pos));
    pos++;
  end
end

%append 00 00 00 00 onto final dataset
if length(literals)==0
  encoded_data = horzcat(encoded_data, [00 00 00 00]);
else
  encoded_data = horzcat(encoded_data, literals, [00 00 00 00]);
end

encoded_data;

%Output to file
fid = fopen("a0020_tree_encoded.lz4", "w");
fprintf(fid, "%s", encoded_data{:});
fclose(fid);
fprintf("File Writing Complete.\n")