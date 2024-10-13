default: project

src_main.o: ./src/main.cpp
	g++ -c -g -O0 -Wno-narrowing -std=c++20 -I./src -I../tram-sdk/libraries -I../tram-sdk/src -I../tram-sdk/libraries/glfw -I../tram-sdk/libraries/glad -I../tram-sdk/libraries/bullet -I../tram-sdk/libraries/lua ./src/main.cpp -o src_main.o

clean:
	del src_main.o

project: src_main.o 
	g++ -o template -L../tram-sdk/ -static src_main.o -ltramsdk  -lglfw3 -lgdi32  -L../tram-sdk/libraries/binaries/win64/ -lOpenAL32    -lBulletSoftBody -lBulletDynamics -lBulletCollision -lLinearMath       -llua 