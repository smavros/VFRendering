CXXFLAGS += -Wall -Wextra -Werror -std=c++11 -pedantic -fPIC

CXXFLAGS += -Iinclude
CXXFLAGS += -Ithirdparty/glad/include
CXXFLAGS += -Ithirdparty/glm/include
CXXFLAGS += -Ithirdparty/qhull/src
CXXFLAGS += -Ithirdparty/qhull/src/libqhullcpp
LDFLAGS += -Lthirdparty/qhull/lib

OBJS=\
	build/ArrowRenderer.o\
	build/RendererBase.o\
	build/BoundingBoxRenderer.o\
	build/CombinedRenderer.o\
	build/CoordinateSystemRenderer.o\
	build/FPSCounter.o\
	build/Geometry.o\
	build/GlyphRenderer.o\
	build/View.o\
	build/IsosurfaceRenderer.o\
	build/VectorFieldRenderer.o\
	build/VectorSphereRenderer.o\
	build/SphereRenderer.o\
	build/SurfaceRenderer.o\
	build/VectorField.o\
	build/VectorfieldIsosurface.o\
	build/Utilities.o\
	build/Options.o\

OBJS += build/glad.o

default: build/libVFRendering.so

all: demo build/libVFRendering.so

thirdparty/qhull/Makefile:
	cd thirdparty && git clone https://github.com/qhull/qhull.git

thirdparty/qhull/lib/libqhullcpp.a: thirdparty/qhull/Makefile
	make -C thirdparty/qhull/ bin-lib lib/libqhullcpp.a "CXX_OPTS1=-Isrc -O3 -fPIC" "CC=${CC}" "CXX=${CXX}"

thirdparty/qhull/lib/libqhullstatic_r.a: thirdparty/qhull/Makefile
	make -C thirdparty/qhull/ bin-lib lib/libqhullstatic_r.a "CXX_OPTS1=-Isrc -O3 -fPIC" "CC=${CC}" "CXX=${CXX}"

thirdparty/qhull/src/libqhullcpp/Qhull.h: thirdparty/qhull/Makefile
thirdparty/qhull/src/libqhullcpp/QhullFacetList.h: thirdparty/qhull/Makefile
thirdparty/qhull/src/libqhullcpp/QhullVertexSet.h: thirdparty/qhull/Makefile
	
build/.exists:
	mkdir -p build
	touch build/.exists

build/%.o: src/%.cxx build/.exists
	${CXX} -c $< -o $@ ${CXXFLAGS}

build/glad.o: thirdparty/glad/src/glad.c
	${CC} -c $< -o $@ -Ithirdparty/glad/include -fPIC

build/libVFRendering.a: ${OBJS}
	ar rcs $@ $^
	
build/libVFRendering.so: ${OBJS} thirdparty/qhull/lib/libqhullcpp.a thirdparty/qhull/lib/libqhullstatic_r.a
	${CXX} ${CXXFLAGS} -shared -o $@ ${OBJS} ${LDFLAGS} -lqhullcpp -lqhullstatic_r
	
demo: demo.cxx build/libVFRendering.a thirdparty/qhull/lib/libqhullcpp.a thirdparty/qhull/lib/libqhullstatic_r.a
	${CXX} ${CXXFLAGS} -o $@ $< -lglfw build/libVFRendering.a ${LDFLAGS} -lqhullcpp -lqhullstatic_r -ldl

clean:
	rm -rf build
	rm -f demo

.PHONY: default clean all

build/ArrowRenderer.o: src/ArrowRenderer.cxx \
  include/VFRendering/ArrowRenderer.hxx \
  include/VFRendering/RendererBase.hxx \
  include/VFRendering/Options.hxx \
  include/VFRendering/View.hxx \
  include/VFRendering/FPSCounter.hxx \
  include/VFRendering/Utilities.hxx \
  include/VFRendering/Geometry.hxx \
  include/VFRendering/GlyphRenderer.hxx \
  include/VFRendering/BoundingBoxRenderer.hxx
build/BoundingBoxRenderer.o: src/BoundingBoxRenderer.cxx \
  include/VFRendering/BoundingBoxRenderer.hxx \
  include/VFRendering/RendererBase.hxx \
  include/VFRendering/Options.hxx \
  include/VFRendering/View.hxx \
  include/VFRendering/FPSCounter.hxx \
  include/VFRendering/Utilities.hxx \
  include/VFRendering/Geometry.hxx \
  include/shaders/boundingbox.vert.glsl.hxx \
  include/shaders/boundingbox.frag.glsl.hxx
build/CombinedRenderer.o: src/CombinedRenderer.cxx \
  include/VFRendering/CombinedRenderer.hxx \
  include/VFRendering/RendererBase.hxx \
  include/VFRendering/Options.hxx \
  include/VFRendering/View.hxx \
  include/VFRendering/FPSCounter.hxx \
  include/VFRendering/Utilities.hxx \
  include/VFRendering/Geometry.hxx
build/CoordinateSystemRenderer.o: src/CoordinateSystemRenderer.cxx \
  include/VFRendering/CoordinateSystemRenderer.hxx \
  include/VFRendering/RendererBase.hxx \
  include/VFRendering/Options.hxx \
  include/VFRendering/View.hxx \
  include/VFRendering/FPSCounter.hxx \
  include/VFRendering/Utilities.hxx \
  include/VFRendering/Geometry.hxx \
  include/shaders/coordinatesystem.vert.glsl.hxx \
  include/shaders/coordinatesystem.frag.glsl.hxx
build/FPSCounter.o: src/FPSCounter.cxx \
  include/VFRendering/FPSCounter.hxx
build/Geometry.o: src/Geometry.cxx \
  include/VFRendering/Geometry.hxx \
  thirdparty/qhull/src/libqhullcpp/Qhull.h \
  thirdparty/qhull/src/libqhullcpp/QhullFacetList.h \
  thirdparty/qhull/src/libqhullcpp/QhullVertexSet.h
build/GlyphRenderer.o: src/GlyphRenderer.cxx \
  include/VFRendering/ArrowRenderer.hxx \
  include/VFRendering/RendererBase.hxx \
  include/VFRendering/Options.hxx \
  include/VFRendering/View.hxx \
  include/VFRendering/FPSCounter.hxx \
  include/VFRendering/Utilities.hxx \
  include/VFRendering/Geometry.hxx \
  include/VFRendering/GlyphRenderer.hxx \
  include/VFRendering/BoundingBoxRenderer.hxx \
  include/shaders/glyphs.vert.glsl.hxx \
  include/shaders/glyphs.frag.glsl.hxx
build/IsosurfaceRenderer.o: src/IsosurfaceRenderer.cxx \
  include/VFRendering/IsosurfaceRenderer.hxx \
  include/VFRendering/RendererBase.hxx \
  include/VFRendering/Options.hxx \
  include/VFRendering/View.hxx \
  include/VFRendering/FPSCounter.hxx \
  include/VFRendering/Utilities.hxx \
  include/VFRendering/Geometry.hxx \
  include/VectorfieldIsosurface.hxx \
  include/shaders/isosurface.vert.glsl.hxx \
  include/shaders/isosurface.frag.glsl.hxx
build/RendererBase.o: src/RendererBase.cxx \
  include/VFRendering/RendererBase.hxx \
  include/VFRendering/Options.hxx \
  include/VFRendering/View.hxx \
  include/VFRendering/FPSCounter.hxx \
  include/VFRendering/Utilities.hxx \
  include/VFRendering/Geometry.hxx
build/VectorFieldRenderer.o: src/VectorFieldRenderer.cxx \
  include/VFRendering/VectorFieldRenderer.hxx \
  include/VFRendering/VectorField.hxx \
  include/VFRendering/View.hxx \
  include/VFRendering/RendererBase.hxx
build/SphereRenderer.o: src/SphereRenderer.cxx \
  include/VFRendering/SphereRenderer.hxx \
  include/VFRendering/RendererBase.hxx \
  include/VFRendering/Options.hxx \
  include/VFRendering/View.hxx \
  include/VFRendering/FPSCounter.hxx \
  include/VFRendering/Utilities.hxx \
  include/VFRendering/Geometry.hxx \
  include/VFRendering/GlyphRenderer.hxx \
  include/VFRendering/BoundingBoxRenderer.hxx
build/SurfaceRenderer.o: src/SurfaceRenderer.cxx \
  include/VFRendering/SurfaceRenderer.hxx \
  include/VFRendering/RendererBase.hxx \
  include/VFRendering/Options.hxx \
  include/VFRendering/View.hxx \
  include/VFRendering/FPSCounter.hxx \
  include/VFRendering/Utilities.hxx \
  include/VFRendering/Geometry.hxx \
  include/shaders/surface.vert.glsl.hxx \
  include/shaders/surface.frag.glsl.hxx
build/Utilities.o: src/Utilities.cxx \
  include/VFRendering/Utilities.hxx \
  include/VFRendering/Options.hxx \
  include/VFRendering/View.hxx \
  include/VFRendering/FPSCounter.hxx \
  include/VFRendering/Geometry.hxx \
  include/shaders/colormap.hsv.glsl.hxx \
  include/shaders/colormap.black.glsl.hxx \
  include/shaders/colormap.white.glsl.hxx \
  include/shaders/colormap.bluered.glsl.hxx \
  include/shaders/colormap.bluegreenred.glsl.hxx \
  include/shaders/colormap.bluewhitered.glsl.hxx
build/VectorfieldIsosurface.o: src/VectorfieldIsosurface.cxx \
  include/VFRendering/Geometry.hxx
build/VectorField.o: src/VectorField.cxx \
  include/VFRendering/Options.hxx \
  include/VFRendering/FPSCounter.hxx \
  include/VFRendering/Utilities.hxx \
  include/VFRendering/Geometry.hxx
build/VectorSphereRenderer.o: src/VectorSphereRenderer.cxx \
  include/VFRendering/VectorSphereRenderer.hxx \
  include/VFRendering/RendererBase.hxx \
  include/VFRendering/Options.hxx \
  include/VFRendering/View.hxx \
  include/VFRendering/FPSCounter.hxx \
  include/VFRendering/Utilities.hxx \
  include/VFRendering/Geometry.hxx \
  include/shaders/sphere_points.vert.glsl.hxx \
  include/shaders/sphere_points.frag.glsl.hxx \
  include/shaders/sphere_background.vert.glsl.hxx \
  include/shaders/sphere_background.frag.glsl.hxx
build/View.o: src/View.cxx include/VFRendering/View.hxx \
  include/VFRendering/Options.hxx \
  include/VFRendering/FPSCounter.hxx \
  include/VFRendering/Utilities.hxx \
  include/VFRendering/Geometry.hxx \
  include/VFRendering/RendererBase.hxx \
  include/VFRendering/ArrowRenderer.hxx \
  include/VFRendering/SurfaceRenderer.hxx \
  include/VFRendering/IsosurfaceRenderer.hxx \
  include/VFRendering/VectorSphereRenderer.hxx \
  include/VFRendering/BoundingBoxRenderer.hxx \
  include/VFRendering/CombinedRenderer.hxx \
  include/VFRendering/CoordinateSystemRenderer.hxx \
  include/VFRendering/View.hxx \
  include/VFRendering/Options.hxx \
  include/VFRendering/FPSCounter.hxx \
  include/VFRendering/Utilities.hxx \
  include/VFRendering/Geometry.hxx
