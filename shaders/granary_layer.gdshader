shader_type canvas_item;
render_mode unshaded;
uniform float elapsed = 0.0;
uniform bool passed = false;
uniform bool fair = false;
float oval(vec2 p,vec2 center,vec2 radius) { return 1.0-smoothstep(0.15,1.0,length((p-center)/radius)); }
void fragment() {
 vec2 p=UV*vec2(1672.0,941.0);
 vec2 q=UV;
 // Only the empty right chain/scale pan moves; the hand and stone stay rigid.
 if(passed) {
  float chain=oval(p,vec2(719.0,553.0),vec2(58.0,67.0));
  q.x+=chain*sin(elapsed*2.2)*0.6/1672.0;
  float stone=oval(p,vec2(451.0,557.0),vec2(54.0,29.0));
  q.y+=stone*sin(elapsed*2.2)*0.3/941.0;
 }
 COLOR=texture(TEXTURE,q);
 float lamps=oval(p,vec2(249.0,199.0),vec2(39.0,74.0))+oval(p,vec2(669.0,277.0),vec2(24.0,32.0))+oval(p,vec2(1201.0,313.0),vec2(21.0,36.0));
 COLOR.rgb*=1.0+lamps*(sin(elapsed*3.2)+0.3*sin(elapsed*5.1))*0.018;
 if(fair) COLOR.rgb*=1.0+oval(p,vec2(344.0,704.0),vec2(127.0,44.0))*0.045;
}
