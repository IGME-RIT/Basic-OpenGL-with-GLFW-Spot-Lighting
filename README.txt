Documentation Author: Niko Procopi 2019

This tutorial was designed for Visual Studio 2017 / 2019
If the solution does not compile, retarget the solution
to a different version of the Windows SDK. If you do not
have any version of the Windows SDK, it can be installed
from the Visual Studio Installer Tool

Welcome to the Spot light Tutorial!
Prerequesites: Point light

Spotlights are just like point light,
the only difference is that point lights shine
light in every direction, and spotlights shine
light in a specific direction

The direction of the spotlight is not the 
direction to the pixel, keep in mind those are
different

We need the spotlight's direction:
	vec3 spotLightDirection = vec3(0, 0, -1); // The direction that the light faces
	
We need the angle of the spotlight:
	float spotLightAngle = .1; // The max angle of the spotlight (in radians)
	
Think of this angle as the tip of a cone,
it determines how wide the cone is, which
determines if our spotlight is thin or wide

Given the direction of the spotlight, and the radius
of the spotlight, we need to get the direction from the pixel
to the light (like point light), and then we need to see
if the direction (from pixel to light) is within the range
of the spotlight. If it is, then we light the pixel, if not,
we do not add light to the pixel

float spotEffect = (angle - cos(spotLightAngle)) / (1 - cos(spotLightAngle));

If the pixel is right in front of the spotlight, spotEffect will be 1.0.
As the pixel gets farther from the center, the number decreases.
If the pixel is right at the edge of the spotlight's angle, it will be zero,
and it will be less than zero if we go outside the radius, so we need to
clamp this to zero if it is lower than zero

spotEffect = pow(clamp(spotEffect, 0, 1), spotLightExponent);

Finally, we multiply attenuation by spotEffect, and the rest of
the formula is the same as point light.

Congratulations, you now have a spotlight
