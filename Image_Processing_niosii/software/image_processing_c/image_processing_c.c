#include <stdio.h>
#include "system.h"
#include "io.h"

#define IMAGE_IP_BASE IMAGE_PROCESSOR_AVALON_IP_0_BASE
#define REG_PIXEL_DATA 0
#define REG_OPERATION  4

int main() {
    unsigned int pixel, processed_pixel;
    int selected_operation = 6;

    setvbuf(stdout, NULL, _IONBF, 0);

    IOWR_32DIRECT(IMAGE_IP_BASE, REG_OPERATION, selected_operation);

    while (scanf("%x", &pixel) == 1) {
        IOWR_32DIRECT(IMAGE_IP_BASE, REG_PIXEL_DATA, pixel & 0xFF);
        for(volatile int d = 0; d < 500; d++);
        processed_pixel = IORD_32DIRECT(IMAGE_IP_BASE, REG_PIXEL_DATA);
        printf("%02X\n", (unsigned int)(processed_pixel & 0xFF));
    }

    return 0;
}
