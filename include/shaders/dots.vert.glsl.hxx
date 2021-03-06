#ifndef DOTS_VERT_GLSL_HXX
#define DOTS_VERT_GLSL_HXX

static const std::string DOT_VERT_GLSL = R"LITERAL(
#version 330

uniform mat4 uProjectionMatrix;
uniform mat4 uModelviewMatrix;
uniform float uDotRadius;

in vec3 ivInstanceOffset;
in vec3 ivInstanceDirection;
out vec3 vfColor;

vec3 colormap(vec3 direction);

bool is_visible(vec3 position, vec3 direction);

void main(void) {
  float direction_length = length( ivInstanceDirection );
  
  if ( is_visible( ivInstanceOffset, ivInstanceDirection ) && direction_length > 0) {
    vfColor = colormap( normalize( ivInstanceDirection ) );
    vec3 vfPosition = ( uModelviewMatrix * vec4( ivInstanceOffset, 1.0 ) ).xyz;
    gl_Position = uProjectionMatrix * vec4( vfPosition, 1.0 );
  } else {
    gl_Position = vec4(2.0, 2.0, 2.0, 0.0);
  }
  
  gl_PointSize = uDotRadius / gl_Position.z;
  float point_size = gl_PointSize;
}
)LITERAL";

#endif
