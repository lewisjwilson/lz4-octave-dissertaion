%==============================LZ4 Encoder v1===================================

data = "aabbccaabbcabbca";
%output should be #61aabbcc0600#010400#000000
%[61 97 97 98 98 99 99 06 00 01 04 00 00 00 00]

global cur_token_arr = [];

%function for recursive match search
function literal_arr = recursive_search(data, sub_lz4, sub_len, data_pos)
  
  match_char = int32(data(data_pos+1));
  match_test_arr = find(sub_lz4==match_char);
  %correcting match_test_arr not to include values <4 from the end
  match_test_arr = match_test_arr(find(match_test_arr<sub_len-4));
  length(match_test_arr);
  global cur_token_arr;
  
  if(length(match_test_arr)>0)
    cur_token_arr(end+1) = match_char
    data_pos++;
    recursive_search(data, sub_lz4, sub_len, data_pos);
  end
endfunction

%example of recursion
function retval = fact (n)
  if (n > 0)
    retval = n * fact (n-1)
  else
    retval = 1;
  endif
endfunction

data_pos = 1;
data_len=length(data);

out_arr = [4 34 77 24 0 0 0 0 0 0 0];
hi_token=0; lo_token=0; offset=0;
sub_lz4 = [];
minmatch = 4;

while(data_pos<=data_len)
  sub_lz4(end+1)=data(data_pos)
  sub_len = length(sub_lz4);
  
  if(data_pos>4)&&(data_pos<data_len)
  
    %find index of values in [sub_lz4] that are the same as data(data_pos+1)
    %match_char = int32(data(data_pos+1));
    %match_test_arr = find(sub_lz4==match_char);
    
    %correcting match_test_arr not to include values <4 from the end
    %match_test_arr = match_test_arr(find(match_test_arr<sub_len-4));
    
    
    cur_token_arr = recursive_search(data, sub_lz4, sub_len, data_pos)
    %concatenate output array with match array
    out_arr = [ out_arr cur_token_arr ]
    
  end
  
  data_pos++;
end  

out_arr


