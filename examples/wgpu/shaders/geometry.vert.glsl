#version 450

#define PRIM_BUFFER_LEN 64

layout(std140, binding = 0)
uniform Globals {
    vec2 u_resolution;
    vec2 u_scroll_offset;
    float u_zoom;
};

struct Primitive {
    vec4 color;
    vec2 translate;
    int z_index;
    float width;
};

layout(std140, binding = 1)
uniform u_primitives { Primitive primitives[PRIM_BUFFER_LEN]; };

layout(location = 0) in vec2 a_position;
layout(location = 1) in vec2 a_normal;
layout(location = 2) in int a_prim_id;

layout(location = 0) out vec4 v_color;

void main() {
    int id = a_prim_id + gl_InstanceIndex;
    Primitive prim = primitives[id];

    vec2 local_pos = a_position + a_normal * prim.width;
    vec2 world_pos = local_pos - u_scroll_offset + prim.translate + 5.0 * vec2(float(gl_InstanceIndex), 0.0);
    vec2 transformed_pos = world_pos * u_zoom / (vec2(0.5, 0.5) * u_resolution);

    float z = float(prim.z_index) / 4096.0;
    gl_Position = vec4(transformed_pos, z / 1000.0, 1.0);
    v_color = prim.color;
}
