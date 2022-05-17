%==========================LZ4 Decoder v1=======================================

fname = "encoded.txt";

fid = fopen(fname, 'r');
encoded_data = fread(fid);
fclose(fid);

%Get length of encoded data; current pos = 1; initialise hi and lo tokens; etc.
len = length(encoded_data);
pos = 1; hi_token=0; lo_token=0;offset = 0;
lit_str = ""; decoded_data = "";

tic
%while the current position is less the length 
while pos<len
  curr_byte = encoded_data(pos);
  if char(curr_byte)=='#'
    
    %convert high token nibble from hex to dec
    pos += 1;
    hi_token = hex2dec(char(encoded_data(pos)));
    
    %condition: break from while loop if token has zero value
    if hi_token ==0
      break
    end
    
    %convert low token nibble from hex to dec and increment by 4
    pos += 1;
    lo_token = hex2dec(char(encoded_data(pos)));  
    lo_token = lo_token + 4;
    
    %copy the literals to lit_str (the symbol values between pos and pos + hi_token indexes)
    pos += 1;
    lit_str = substr(char(encoded_data'), pos, hi_token);
    decoded_data = strcat({decoded_data}, {lit_str});
    %caters for trailing white space
    decoded_data = decoded_data{1};
    
    %set position marker as the value after the literals (+1 - skipping '+' for now)
    pos = pos+hi_token;
    pos += 1;
    
    %convert the offset value to the negative decimal version
    offset = -hex2dec(char(encoded_data(pos)));
    
    %condition: end literals are unique
    if offset == 0
      break
    end
    
    %set temporary string and length as variables
    temp_str = substr(decoded_data, offset);
    temp_len = length(temp_str);
    
    %if the low token nibble has a greater value than the length of literals in temp_str
    if lo_token>temp_len
      
      %find the number of times to append the whole temp_str
      temp_str_repeat = floor(lo_token/temp_len);
      
      %find the index to copy to after the temp_str as been copied 'temp_str_repeat' times
      temp_str_index = mod(lo_token, temp_len);
      
      %append the string 'temp_str_repeat' times as mentioned
      for i = 1:temp_str_repeat
        decoded_data = strcat({decoded_data}, {temp_str(1:end)});
        decoded_data = decoded_data{1};
      end
      
      %append the temp_str up to required index
      decoded_data = strcat({decoded_data}, {temp_str(1:temp_str_index)});
      decoded_data = decoded_data{1};
      
    %if the low token nibble does not have a greater value than the length of literals in temp_str
    else
      %append the required number of temp_str literals
      decoded_data = strcat({decoded_data}, {temp_str(1:lo_token)});
      decoded_data = decoded_data{1};
    end     
    
  end

  %increment the position yet again
  pos += 1;
end
toc

%display encoded data
encoded_data_disp = char(encoded_data')

%display the output data
decoded_data