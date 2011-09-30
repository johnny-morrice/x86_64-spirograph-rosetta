#include <stdio.h>
#include <stdlib.h>

#include <GL/freeglut.h>

#include "draw_spiro.h"

#define SPIRO_LENGTH 20000


void display()
{

    glClear(GL_COLOR_BUFFER_BIT);

    glDrawArrays(GL_POINTS, 0, SPIRO_LENGTH); 

    glutSwapBuffers();
}

void initialize(int argc, char * argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(0);
    glutCreateWindow("C Spirograph");

    glutDisplayFunc(&display);

}

void read_arguments(int argc, char * argv[], double * real_args)
{
    int i;

    if (argc == 4)
    {
        for (i = 1; i < 4; i++)
        {
            real_args[i - 1] = atof(argv[i]);
        }
    }
    else
    {
        fprintf(stderr, "Usage: %s MOVING FIXED OFFSET\n", argv[0]);
        exit(1);
    }
}

void render(double moving, double fixed, double offset)
{
    double vertices[2 * SPIRO_LENGTH];

    glEnableClientState(GL_VERTEX_ARRAY);

    draw_spiro(moving, fixed, offset, vertices, SPIRO_LENGTH);
    
    glVertexPointer(2, GL_DOUBLE, 0, vertices);

    glutMainLoop();

    glDisableClientState(GL_VERTEX_ARRAY);
}

int main(int argc, char * argv[])
{
    double moving, fixed, offset;
    double real_args[4];

    read_arguments(argc, argv, real_args);

    moving = real_args[0];
    fixed = real_args[1];
    offset = real_args[2];

    initialize(argc, argv);

    render(moving, fixed, offset);

    return 0;

}
