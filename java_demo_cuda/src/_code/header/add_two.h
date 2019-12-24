#include <iostream>
#include "add_cuda.h"

namespace zjx{
class add_two{
    public:
    int x;
    int y;
    int add(){
        return add_ceshi(x,y);
    }
};
}
