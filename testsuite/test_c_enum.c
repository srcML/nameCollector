#include <stdio.h>
enum Colors {RED, YELLOW, BLUE};
// with assigned value to one
enum Difficulty {EASY = 1, MEDIUM, HARD}; 
// with all assigned value
enum Values {FIRST = 1, SECOND = 2, FOURTH = 4 };
// anon and immediate declaration
enum {ON = 1, OFF = 0} light = OFF; 

int main(){
    enum Colors myColor;
    enum Values myValue = SECOND; 
    return 0; 
}

