#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 room_size;
uniform vec2 pos;
uniform float u_time;

void main() {
	vec2 st = pos/room_size;
	gl_FragColor = vec4(abs(sin(2*st.x)),abs(sin(4*st.y)),abs(sin(10*st.x)),1.0);
}