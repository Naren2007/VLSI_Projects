import cv2 as cv
import numpy as np

# 1. Read and preprocess image
img  = cv.imread("G:/Image_processing/project_nios_zip/project_nios/image.jpg")        
gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)                 
resized = cv.resize(gray, (512, 512), interpolation=cv.INTER_AREA)

cv.imshow("Original_image", img)
cv.imshow("Gray_image", gray)
cv.imshow("Resized_image", resized)

# 2. Flatten to 1-D array (length = 512*512 = 262144)
flat = resized.reshape(-1).astype(np.uint8)                 

# 3. Write as hex text for Verilog $readmemh
#    Each line: 2-digit hex 00..FF, no '0x'
out_path = "G:/Image_processing/project_nios_zip/project_nios/pixel_data_hex.txt"
with open(out_path, "w") as f:
    for v in flat:
        f.write(f"{int(v):02X}\n")                          

print("Wrote", flat.size, "pixels to", out_path)

cv.waitKey(0)
