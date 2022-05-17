%==============================LZ4 Decoder v6===================================
%=======================Fully Functioning on Poem.txt===========================

%Read file into an array
fid = fopen("poem.lz4", 'r');
data = fread(fid, 'uint8');
fclose(fid);

pos = 1;

%Checking the file is a valid LZ4 file
if(data(1:4)==[4 34 77 24]')
  fprintf("LZ4 File Detected\n")
end

if(dec2bin(data(5))(3)=='0')
  %Skip first 7 bytes...
  pos = 12;
else
  %Skip further 7+8 bytes 
end


len = length(data);
decoded_arr = cell();

%Data blocks
while(pos<=len)
  token = dec2hex(data(pos));
  
  if(length(token)==1)
    hi_token = 0;
  else  
    hi_token = hex2dec(substr(token,1,1));
  end
  lo_token = hex2dec(substr(token, -1)) + 4;
  
  %Only 1 level of 'recursion', needs to be more for practicality...
  if(hi_token==15)
    pos++;
    hi_token = hi_token + data(pos);
  end
  
  hi_token

  pos++;
  
  %append the literals to the array
  if(hi_token!=0)
    for i=(pos:pos+hi_token-1)
        decoded_arr(end+1, 1) = char(data(i));
    end
    pos = pos+hi_token;
  end
  
  %2 Bytes Value (Little Endian)
  offset = data(pos)+data(pos+1)
  byte1 = dec2hex(data(pos));  
  byte2 = dec2hex(data(pos+1));
  
  if(length(byte2)==1)
    hi_byte = strcat('0',dec2hex(data(pos+1)));
    if(length(byte1)==1)
      lo_byte = strcat('0', dec2hex(data(pos)));
    else
      lo_byte = dec2hex(data(pos));
    end
    offset = hex2dec(strcat(hi_byte, lo_byte));
  end

  temp_len = length(decoded_arr);
  
  
  %Checking 00 00 00 00 at the end...
  if(data(pos:pos+3)==[0 0 0 0])
    fprintf("Decoding Complete\nWriting to file...\n")
    break;
  end
  
  %Append 'lo_token' number of chars from the specified position
  if(lo_token!=0)
    for(i = 1:lo_token)
      decoded_arr(end+1, 1) = char(decoded_arr(temp_len-offset+i));
    end
  end
  
  pos += 2;
  
end



%Output to file
fid = fopen("poem_decoded.txt", "w");
fprintf(fid, '%s', decoded_arr'{:})
fclose(fid);
fprintf("File Writing Complete.\n")