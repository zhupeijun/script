//Use this command to compile.
//g++ `Magick++-config --cppflags --cxxflags --ldflags --libs` resize.cpp

#include <Magick++.h>
#include <iostream>

using namespace std;
using namespace Magick;

int size[] = {
    152,
    144,
    120,
    114,
    76,
    72,
    80,
    58,
    57,
    29
};

int main (int argc, char ** argv) {
    InitializeMagick(NULL);
    Image icon("icon.png");
    int n = sizeof(size) / sizeof(int), i;
    printf("[LOG] Need to process %d files.\n", n);
    for(i = 0; i < n; i++) {
        int sz = size[i];
        printf("[PROCESS] Generate size %d x %d\n", sz, sz);
        char size_to[20], name[20];
        sprintf(size_to, "%dx%d", sz, sz);
        sprintf(name, "icon@%d.png", sz);
        Image to_image = icon;
        to_image.resize(size_to);
        to_image.write(name);
    }
    return 0;
}
