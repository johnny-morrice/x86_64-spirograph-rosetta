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

float* draw_spiro()
{
    float moving, fixed, offset, t, x, y;

    int i;

    float* vertices;

    vertices = malloc(2 * SPIRO_LENGTH * sizeof(float));

    moving = 0.2f;
    fixed = 0.5f;
    offset = 0.6f;

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

    return vertices;

}

void display()
{

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glDrawArrays(GL_POINTS, 0, SPIRO_LENGTH); 

    glutSwapBuffers();
}

void initialize(int argc, char* argv[])
{
    float vertices[2 * SPIRO_LENGTH];

    glutInit(&argc, argv);
    glutInitDisplayMode(0);
    glutInitWindowSize(300, 400);
    glutCreateWindow("C Spirograph");

    glutDisplayFunc(&display);

    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

}

int main(int argc, char* argv[])
{
    float * vertices;

    initialize(argc, argv);

    glEnableClientState(GL_VERTEX_ARRAY);

    vertices = draw_spiro();

    glVertexPointer(2, GL_FLOAT, 0, vertices);

    glutMainLoop();

    glDisableClientState(GL_VERTEX_ARRAY);

    return 0;
}
