struct Atmosphere { time: f32, intensity: f32, resolution: vec2f }
@group(0) @binding(0) var<uniform> atmosphere: Atmosphere;

fn hash(p: vec2f) -> f32 {
  return fract(sin(dot(p, vec2f(127.1, 311.7))) * 43758.5453);
}

fn meteor(uv: vec2f, seconds: f32, aspect: f32, offset: f32) -> f32 {
  let cycle = floor((seconds + offset) / 12.0);
  let progress = fract((seconds + offset) / 12.0) * 12.0;
  let seed = hash(vec2f(cycle, offset));
  let origin = vec2f(-0.08 + seed * 0.74, 0.015 + hash(vec2f(cycle, offset + 4.0)) * 0.1);
  let velocity = vec2f(0.085 + seed * 0.025, 0.042);
  let head = origin + velocity * progress;
  let relative = (uv - head) * vec2f(aspect, 1.0);
  let direction = normalize(velocity * vec2f(aspect, 1.0));
  let along = dot(relative, direction);
  let across = abs(relative.x * direction.y - relative.y * direction.x);
  let pixel = 1.0 / atmosphere.resolution.y;
  let age = max(-along, 0.0);
  let width = max(pixel * 0.8, 0.00065) + age * 0.003;
  let taper = (1.0 - smoothstep(0.18, 0.42, age)) * (1.0 - smoothstep(-pixel, pixel * 2.0, along));
  let tail = exp(-pow(across / width, 2.0)) * exp(-age * 5.0) * taper;
  let halo = exp(-pow(across / (width * 4.0), 2.0)) * exp(-age * 8.0) * taper * 0.12;
  let point = exp(-length(relative) / (pixel * 1.7)) * 1.1;
  let envelope = smoothstep(0.0, 0.55, progress) * (1.0 - smoothstep(3.1, 4.5, progress));
  return (tail + halo + point) * envelope;
}

@fragment fn fs_main(@location(0) uv: vec2f) -> @location(0) vec4f {
  let t = atmosphere.time * 0.25;
  let p = vec2f((uv.x - 0.5) * atmosphere.resolution.x / atmosphere.resolution.y, uv.y - 0.5);
  let wave = sin(p.x * 2.4 + t) * 0.085 + sin(p.x * 4.0 - t * 0.7) * 0.04;
  let ribbon = exp(-abs(p.y - wave - 0.13) * 13.0);
  let fine = exp(-abs(p.y - wave - 0.13) * 115.0);
  let falloff = exp(-length(p - vec2f(0.38, 0.1)) * 1.8);
  let violet = vec3f(0.27, 0.16, 0.49) * ribbon * falloff * 1.25;
  let cyan = vec3f(0.09, 0.53, 0.64) * fine * falloff * 0.6;
  let stars = pow(hash(floor(uv * atmosphere.resolution / 3.0)), 160.0) * (0.025 + 0.04 * sin(t * 3.0 + uv.x * 24.0)) * falloff;
  let upperCenter = vec2f(0.15 + sin(t * 0.6) * 0.35, -0.32 + cos(t * 0.8) * 0.06);
  let upperGlow = exp(-length((p - upperCenter) * vec2f(1.25, 3.0)) * 3.0);
  let upperWave = -0.32 + sin(p.x * 2.0 - t * 0.55) * 0.035;
  let upperVeil = exp(-abs(p.y - upperWave) * 24.0) * exp(-abs(p.x + sin(t) * 0.2) * 1.8);
  let crown = vec3f(0.25, 0.17, 0.44) * upperGlow * 0.28 + vec3f(0.09, 0.21, 0.31) * upperVeil * 0.12;
  let aspect = atmosphere.resolution.x / atmosphere.resolution.y;
  let shootingStars = meteor(uv, atmosphere.time, aspect, 0.0)
    + meteor(uv, atmosphere.time, aspect, 3.1) * 0.65
    + meteor(uv, atmosphere.time, aspect, 6.4) * 0.8
    + meteor(uv, atmosphere.time, aspect, 9.2) * 0.5;
  let meteorColor = vec3f(0.65, 0.73, 0.88) * shootingStars * 0.55;
  return vec4f((violet + cyan + crown + meteorColor + vec3f(max(stars, 0.0))) * atmosphere.intensity, 1.0);
}


