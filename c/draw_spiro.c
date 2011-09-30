#include <math.h>

#include "draw_spiro.h"

double spiro_x(double r, double moving, double offset, double t)
{
    return (r * cos(t)) + (offset * cos(t * r / moving));
}

double spiro_y(double r, double moving, double offset, double t)
{
    return (r * sin(t)) - (offset * sin(t * r / moving));

}

void draw_spiro(double moving, double fixed, double offset, double * vertices, int length)
{
    double t, x, y, r;

    int i;

    t = 0.0f;
    r = fixed - moving;
    
    for (i = 0; i < length; i += 2)
    {
        x = spiro_x(r, moving, offset, t);
        y = spiro_y(r, moving, offset, t);

        vertices[i] = x;
        vertices[i + 1] = y; 

        t += 0.03;

    }

}

