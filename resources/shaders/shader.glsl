uniform mat4 vertexTransformation = mat4(1.0);

#ifdef VERTEX

vec4 position(mat4 transformProjection, vec4 vertexPosition) {
    return transformProjection * vertexTransformation * vertexPosition;
}

#endif

#ifdef PIXEL

vec4 effect(vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords) {
    vec4 textureColor = Texel(texture, textureCoords);
    return color * textureColor;
}

#endif
