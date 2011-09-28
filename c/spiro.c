#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include <GL/freeglut.h>

#define SPIRO_LENGTH 20000

float spiro_x(float moving, float fixed, float offset, float t)
{
    float r = fixed - moving;
    return (r * cos(t)) + (offset * cos(t * r / moving));
}

float spiro_y(float moving, float fixed, float offset, float t)
{
    float r = fixed - moving;
    return (r * sin(t)) - (offset * sin(t * r / moving));

}

void draw_spiro(float moving, float fixed, float offset, float * vertices)
{
    float t, x, y;

    int i;

    t = 0.0f;
    
    for (i = 0; i < SPIRO_LENGTH; i += 2)
    {
        x = spiro_x(moving, fixed, offset, t);
        y = spiro_y(moving, fixed, offset, t);

        vertices[i] = x;
        vertices[i + 1] = y; 

        t += 0.03;

    }

    printf("%f radians\n", t / 3.1415);

}

void display()
{

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glDrawArrays(GL_POINTS, 0, SPIRO_LENGTH); 

    glutSwapBuffers();
}

void initialize(int argc, char * argv[])
{
    float vertices[2 * SPIRO_LENGTH];

    glutInit(&argc, argv);
    glutInitDisplayMode(0);
    glutInitWindowSize(300, 400);
    glutCreateWindow("C Spirograph");

    glutDisplayFunc(&display);

    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

}

void read_arguments(int argc, char * argv[], float * real_args)
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

void render(float moving, float fixed, float offset)
{
    float vertices[2 * SPIRO_LENGTH];

    glEnableClientState(GL_VERTEX_ARRAY);

    draw_spiro(moving, fixed, offset, vertices);

    glVertexPointer(2, GL_FLOAT, 0, vertices);

    glutMainLoop();

    glDisableClientState(GL_VERTEX_ARRAY);
}

int main(int argc, char * argv[])
{
    float moving, fixed, offset;
    float real_args[3];

    read_arguments(argc, argv, real_args);

    moving = real_args[0];
    fixed = real_args[1];
    offset = real_args[2];

    initialize(argc, argv);

    render(moving, fixed, offset);

    return 0;

}
