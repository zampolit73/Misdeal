shader_type canvas_item;
render_mode unshaded;
void fragment(){ COLOR=texture(TEXTURE,UV); COLOR.a *= smoothstep(0.726,0.749,UV.y); }
