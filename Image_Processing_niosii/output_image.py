import cv2 as cv
import numpy as np

W, H = 512, 512

with open("G:/Image_processing/project_nios_zip/project_nios/processed_hex.txt", "r") as f:
    pixels = [int(line, 16) for line in f if line.strip()]

img = np.array(pixels, dtype=np.uint8).reshape((H, W))

cv.imshow("Result", img)
cv.imwrite("D:/Image_processing/processed_image.png", img)

cv.waitKey(0)
cv.destroyAllWindows()
