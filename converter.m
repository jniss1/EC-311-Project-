% Read the JPEG image
img = imread('IMG_0995.jpeg');

% Resize the image if necessary (specify desired width and height)
width = 944;   % Example width
height = 713;  % Example height
img = imresize(img, [height, width]);

% Ensure the image is in RGB format
if size(img, 3) == 1
    img = repmat(img, [1, 1, 3]);
end

% Flatten the image into a 2D array where each row is a pixel
pixel_data = reshape(img, [], 3);

% Convert RGB888 to RGB565
% RGB888: 8 bits for each of R, G, B
% RGB565: 5 bits for R, 6 bits for G, 5 bits for B

% Extract R, G, B components
R = pixel_data(:, 1);
G = pixel_data(:, 2);
B = pixel_data(:, 3);

% Convert to uint16 for processing
R = uint16(R);
G = uint16(G);
B = uint16(B);

% Convert to RGB565 format
R5 = bitshift(R, -3);     % Take the upper 5 bits
G6 = bitshift(G, -2);     % Take the upper 6 bits
B5 = bitshift(B, -3);     % Take the upper 5 bits

% Combine into a single 16-bit value
RGB565 = bitshift(R5, 11) + bitshift(G6, 5) + B5;

% Open file to write
fid = fopen('mole_sprite.mem', 'w');

% Write pixel data to file in hexadecimal format
for i = 1:length(RGB565)
    fprintf(fid, '%04X\n', RGB565(i));
end

% Close the file
fclose(fid);

disp('Conversion complete. Data written to mole_sprite.mem');
