%==============================LZ4 Decoder v3===================================
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
  %Skip further 7+8 bytes (WHAT DOES THIS MEAN?)
end


len = length(data);
decoded_arr = cell();

%Data blocks
while(pos<=len)
  hi_token = bin2dec(substr(dec2bin(data(pos)), 1, 4));
  lo_token = bin2dec(substr(dec2bin(data(pos)), -4)) + 4;
  
  if(hi_token==15)
    pos++;
    hi_token = hi_token + bin2dec(substr(dec2bin(data(pos)), 1, 4));
    lo_token = lo_token + bin2dec(substr(dec2bin(data(pos)), -4))
  end

  pos++;
  %decoded_arr = cellstr(char(data(pos:pos+hi_token-1))); %Need to append each time
  for i=(pos):(pos+hi_token-1)
      decoded_arr(end+1, 1) = char(data(i));
  end
  
  pos = pos+hi_token;
  
  %2 Bytes Value (Little Endian)
  offset = data(pos)+data(pos+1);
  
  %Where str length is not exceeded
  if((pos-offset)+lo_token>=length(decoded_arr))
    for i=(pos-offset):(pos-offset)+lo_token-1
      decoded_arr(end+1, 1) = char(data(i));
    end
  %Where str length is exceeded
  else
    "Boundary Exceeded"
    break;
  end
  
  pos += 2;
  
end

decoded_arr;

%Output to file
fid = fopen("Poem_decoded.txt", "w");
fprintf(fid, '%s', decoded_arr'{:})
fclose(fid);