% Specify the dimensions of the image (must match the original dimensions)
width = 944;   % Replace with your sprite's width
height = 713;  % Replace with your sprite's height

% Open the memory file
fid = fopen('mole_sprite.mem', 'r');

% Read the hexadecimal data
data = textscan(fid, '%s');
fclose(fid);

% Convert hex strings to numeric values
hex_values = data{1};
num_pixels = length(hex_values);
RGB565 = uint16(hex2dec(hex_values));

% Check if the number of pixels matches the expected size
expected_pixels = width * height;
if num_pixels ~= expected_pixels
    error('The number of pixels in the mem file does not match the expected image size.');
end

% Convert RGB565 to RGB888
% Extract the individual color components
R5 = bitshift(RGB565, -11);
G6 = bitand(bitshift(RGB565, -5), 63); % Mask with 0x3F for 6 bits
B5 = bitand(RGB565, 31);               % Mask with 0x1F for 5 bits

% Scale the components to 8 bits
R8 = uint8(double(R5) * 255 / 31);
G8 = uint8(double(G6) * 255 / 63);
B8 = uint8(double(B5) * 255 / 31);

% Combine the components into a single array
pixel_data = [R8, G8, B8];

% Reshape the pixel data back into the image dimensions
img = reshape(pixel_data, [height, width, 3]);

% The reshape function fills the matrix column-wise, so we may need to transpose
img = permute(img, [1, 2, 3]);

% Save the image as a JPEG file
imwrite(img, 'reconstructed_image.jpeg');

disp('Conversion complete. Image saved as reconstructed_image.jpeg');
