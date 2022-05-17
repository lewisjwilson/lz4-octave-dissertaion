%==============================LZ4 Decoder v4===================================
%=============================64KB Blocks Only==================================

%Read file into an array
fid = fopen("Poem.lz4", 'r');
data = fread(fid, 'uint8');
fclose(fid);

pos = 1;

%Checking the file is a valid LZ4 file
if(data(1:4)==[4 34 77 24]')
  fprintf("LZ4 File Detected\n\n")
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
  hi_token = hex2dec(substr(dec2hex(data(pos)),1,1));
  lo_token = hex2dec(substr(dec2hex(data(pos)), -1)) + 4;
  
  if(hi_token==15)
    pos++;
    hi_token = hi_token + data(pos);
  end

  pos++;
  
  %append the literals to the array
  if(hi_token!=0)
    for i=(pos:pos+hi_token-1)
        decoded_arr(end+1, 1) = char(data(i));
    end
    pos = pos+hi_token;
  end
  
  %2 Bytes Value (Little Endian)
  offset = data(pos)+data(pos+1);   
  x = num2str(data(pos+1));
  y = num2str(data(pos));
  
  if(dec2hex(data(pos))=='6D')&&(dec2hex(data(pos+1))=='1')
    pos
    hi_token
    lo_token
    data(pos)
    dec2hex(data(pos))
    data(pos+1)
    dec2hex(data(pos+1))
    offset
  end
    
  if(length(x)==1)
    hi_byte = strcat('0',dec2hex(data(pos+1)));
    if(length(y)==1)
      lo_byte = strcat('0', dec2hex(data(pos)));
    else
      lo_byte = dec2hex(data(pos));
    end
    offset = hex2dec(strcat(hi_byte, lo_byte));
  end

  temp_len = length(decoded_arr);
  
  
  %Ignore this for now, very simple fix checking 00 00 00 00 at the end...
  if temp_len==2775
    break;
  end
  
  
  if(lo_token!=0)
    for(i = 1:lo_token)
      decoded_arr(end+1, 1) = char(decoded_arr(temp_len-offset+i));
    end
  end
  
  pos += 2;
  
end

decoded_arr;

%Output to file
fid = fopen("Poem_decoded.txt", "w");
fprintf(fid, '%s', decoded_arr'{:})
fclose(fid);