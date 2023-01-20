/* Main function, uniforms & utils */
#ifdef GL_ES
    precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define PI_TWO			1.570796326794897
#define PI				3.141592653589793
#define TWO_PI			6.283185307179586


float drawLine(vec2 p1, vec2 p2, float thickness) {
  vec2 uv = gl_FragCoord.xy / u_resolution.xy;

  float a = abs(distance(p1, uv));
  float b = abs(distance(p2, uv));
  float c = abs(distance(p1, p2));

  if ( a >= c || b >=  c ) return 0.0;

  float p = (a + b + c) * 0.5;

  // median to (p1, p2) vector
  float h = 2.0 / c * sqrt( p * ( p - a) * ( p - b) * ( p - c));

  return mix(1.0, 0.0, step(thickness, h));
}

mat2 rotate(in float _angle){
    return mat2(
        cos(_angle), -sin(_angle),
        sin(_angle), cos(_angle)
    );
}

float circle(in vec2 _st, in float _radius){
    vec2 dist = _st-vec2(0.5);
	return 1.-smoothstep(_radius-(_radius*0.01),
                         _radius+(_radius*0.01),
                         dot(dist,dist)*4.0);
}

float line(in vec2 _uv, in vec2 _start, in float _a, in float _length, in float _thickness){
    vec2 startPoint = _start;
    float angle = _a;
    float thickness = _thickness;
    vec2 endPoint = startPoint + vec2(cos(angle), sin(angle)) * _length;


    float a = abs(distance(startPoint, _uv));
    float b = abs(distance(endPoint, _uv));
    float c = abs(distance(startPoint, endPoint));

    if ( a >= c || b >=  c ) return 0.0;

    float p = (a + b + c) * 0.5;

    // median to (p1, p2) vector
    float h = 2.0 / c * sqrt( p * ( p - a) * ( p - b) * ( p - c));

    return mix(1.0, 0.0, step(_thickness, h));
}

void main()
{

	vec2 uv = (gl_FragCoord.xy / u_resolution.xy);
    vec2 uv_rot = rotate(((10.)*sin(u_time)*PI/180.0))*(gl_FragCoord.xy / u_resolution.xy);

    
	// background color
	vec3 colorA = vec3(0.1, 0.6, 0.7);
    vec3 colorB = vec3(0.8, 0.2, 0.7);
	vec3 col = mix(colorA, colorB, vec3(uv_rot.y));

    // border
	col = mix( col, vec3(0.0), circle(uv, 0.75));

    // circle
    col = mix(col, vec3(0.7),vec3(circle(uv, 0.7)));


    // big crosshair lines
    col = mix( col, vec3(0), line(uv, vec2(0.5,0.5), PI+(10.)*sin(u_time)*PI/180.0, 0.3, 0.002));
    col = mix( col, vec3(0), line(uv, vec2(0.5,0.5), (10.)*sin(u_time)*PI/180.0, 0.3, 0.002));
    col = mix( col, vec3(0), drawLine(vec2(0.5,0.6), vec2(0.5,0.9), 0.002));
    col = mix( col, vec3(0), drawLine(vec2(0.5,0.4), vec2(0.5,0.1), 0.002));

    // center mini circle
    col = mix( col, vec3(0.0), vec3(circle(uv, 0.003)));
	col = mix( col, vec3(0.5), vec3(circle(uv, 0.002)));


	gl_FragColor = vec4( col,1.0 );
}