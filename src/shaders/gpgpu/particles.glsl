#include ../includes/simplexNoise4d.glsl;
uniform float uTime;
uniform sampler2D uBase;
uniform float uDeltaTime;

void main(){
  vec2 uv = gl_FragCoord.xy/resolution.xy;
  vec4 particle = texture(uParticles,uv);
  vec4 base = texture(uBase,uv);
  float time = uTime * 0.2;

  // Dead
  if(particle.a >= 1.0){
    particle.a = 0.0;
    particle.xyz = base.xyz;
  }else{
    // flow field
    vec3 flowfield = vec3(
      simplexNoise4d(vec4(particle.xyz + 0.0, time)),
      simplexNoise4d(vec4(particle.xyz + 0.5, time)),
      simplexNoise4d(vec4(particle.xyz + 1.0, time))
    );

    flowfield = normalize(flowfield);
    particle.xyz += flowfield.xyz * uDeltaTime * 0.3;

    // decay
    particle.a += uDeltaTime * 0.3;
  
  }

  gl_FragColor = particle;
}