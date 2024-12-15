#include ../includes/simplexNoise4d.glsl;
uniform float uTime;
uniform sampler2D uBase;
uniform float uDeltaTime;
uniform float uFlowFieldInfluence;

void main(){
  vec2 uv = gl_FragCoord.xy/resolution.xy;
  vec4 particle = texture(uParticles,uv);
  vec4 base = texture(uBase,uv);
  float time = uTime * 0.2;

  // Dead
  if(particle.a >= 1.0){
    particle.a = mod(particle.a, 1.0);
    particle.xyz = base.xyz;
  }else{
    // Strengh
    float influence = (uFlowFieldInfluence - 0.5) * -2.0;
    float strengh = smoothstep(influence,1.0,simplexNoise4d(vec4(base.xyz * 0.2, time + 1.0 )));

    // flow field
    vec3 flowfield = vec3(
      simplexNoise4d(vec4(particle.xyz + 0.0, time)),
      simplexNoise4d(vec4(particle.xyz + 0.5, time)),
      simplexNoise4d(vec4(particle.xyz + 1.0, time))
    );

    flowfield = normalize(flowfield);
    particle.xyz += flowfield.xyz * uDeltaTime * strengh * 0.3;

    // decay
    particle.a += uDeltaTime * 0.3;
  
  }

  gl_FragColor = particle;
}