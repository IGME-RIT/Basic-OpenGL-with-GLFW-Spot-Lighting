/*
Title: Spot Lighting
File Name: fragment.glsl
Copyright ? 2016
Author: David Erbelding
Written under the supervision of David I. Schwartz, Ph.D., and
supported by a professional development seed grant from the B. Thomas
Golisano College of Computing & Information Sciences
(https://www.rit.edu/gccis) at the Rochester Institute of Technology.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


#version 400 core

in vec3 position;
in vec3 normal;
in vec2 uv;
uniform sampler2D tex;

void main(void)
{
	vec4 ambientLight = vec4(.2, .2, .3, 1);

	// LIGHTS: in practice, these values would be passed to the shader from the cpu, but we're hardcoding them for simplicity.
	// You could even pass them in as an array.

	vec3 spotLightPosition = vec3(0, 0, 5); // The position of our light in world space
	vec3 spotLightDirection = vec3(0, 0, -1); // The direction that the light faces
	vec3 spotLightAttenuation = vec3(1, 0, 1); // The constants a, b, and c used to attenuate with distance
	vec4 spotLightColor = vec4(1, 1, 1, 1); // The color of the light
	float spotLightRange = 10; // The radius of the light influence
	float spotLightAngle = .1; // The max angle of the spotlight (in radians)
	float spotLightExponent = 1; // Exponent used to attenuate with the angle of the light
	
	// Subtract the difference between the position of the light and the position of the vertex being lit.
	vec3 lightToSurface = spotLightPosition - position;
	
	// Get the distance from the light to the surface
	float d = length(lightToSurface);

	// Normalize the light to surface vector
	vec3 normalizedLightDirection = lightToSurface / d;

	// Divide distance by range to get it between 0 and 1
	d /= spotLightRange;

	// Attenuation is calculated by dividing 1 by a quadratic function ax^2 + bx + c.
	// This makes a curve that falls off with distance.
	float attenuation = 1 / (d * d * spotLightAttenuation.x + d * spotLightAttenuation.y + spotLightAttenuation.z);
	
	// Calculate the spot effect. This works similarly to attenuation, but is based on the angle between the center of the light and the surface.
	// These have to be normalized or it wont work.
	float angle = -dot(normalizedLightDirection, normalize(spotLightDirection));

	// Map the value so that 1 is the same, and 0 is at the edge of the angle.
	float spotEffect = (angle - cos(spotLightAngle)) / (1 - cos(spotLightAngle));

	// Spot lights use an exponent for falloff, clamp to 0 first.
	spotEffect = pow(clamp(spotEffect, 0, 1), spotLightExponent);

	// Jam these two floats together.
	attenuation = clamp(attenuation * spotEffect, 0, 1);

	// Calculate ndotl with that light direction
	float ndotl = clamp(dot(normalizedLightDirection, normalize(normal)), 0, 1);

	// Here we scale our light color by the value of the light on the surface.
	vec4 lightValue = spotLightColor * ndotl * attenuation;

	// Add the ambient light to the light value. (This can put us over 1, so clamp it again)
	lightValue = clamp(lightValue + ambientLight, 0, 1);

	// Finally, sample from the texuture and multiply the value we get by the color of the light.
	gl_FragColor = texture(tex, uv) * lightValue;
}