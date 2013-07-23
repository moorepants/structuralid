function create_directory(directory_path)
% function create_directory(directory_path)
%
% This creates the desired directory if it doesn't already exist. If it does
% exist then nothing happens.
%
% Parameters
% ----------
% directory_path : char
%   The path to the desired directory.

if exist(directory_path, 'dir') ~= 7
    mkdir(directory_path)
end
