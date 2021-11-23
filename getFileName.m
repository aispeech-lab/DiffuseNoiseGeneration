function name = getFileName(file_name)
    sslash = strfind(file_name, filesep);
    sdot   = strfind(file_name, '.');
    name = file_name(sslash(end) + 1:sdot(end) - 1);
end

