#include "draw_spiro.h"

#define SPIRO_LENGTH 100000

int main(int argc, char * argv[])
{
    double vertices[2 * SPIRO_LENGTH];
    draw_spiro(0.2, 0.5, 0.8, vertices, SPIRO_LENGTH);
    return 0;
}
