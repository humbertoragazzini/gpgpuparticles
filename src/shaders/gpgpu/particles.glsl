void main(){
  vec2 uv = gl_FragCoord.xy/resolution.xy;
  vec4 particles = texture(uParticles,uv);
  
  gl_FragColor = particles;
}