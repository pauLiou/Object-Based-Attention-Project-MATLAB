audioInfo.m -

This file deals with participant audio settings that are defined using InitializePsychSound 
function (PTB). We set the device defaults before we run the experiment to enable high fidelity 
sound that operates at low latency. It requires the user to identify their audio port number and 
input various flags for operation. (See PsychPortAudio help for further information).

calibrationInfo.m -

Here we execute the eye tracker calibration. This function records 4 coordinates: left eye x 
and y axis and right eye x and y axis. These datapoints are then stored into the object "output" 
under eyeCalibration. This can then be fitted online to see if participants were correctly moving 
their eyes. It takes advantage of structs native to the Eye-tracker API.

keyboardInfo.m -

Simple script to designate the required key mappings for the experiment so that inputs are recorded. 
In the experiment we then use these variables in various functions to determine if the correct key 
has been pressed. It also allows us to reserve certain key functionality and disable unrequired keys.

participantInfo.m -

Here we are defining various parameters that are important for the experiment. For example, we are 
defining a full factorial design matrix and creating a struct that records and stores the trial and 
block order. It also includes further output functionality.

screenInfo.m -

This script records the screen size, resolution, refresh-rate and luminance. It also creates coordinates 
that will be important for rendering items onto the display. We locate the screen center, and the important 
locations for experimental items dynamically depending on the screen size.

textureInfo.m -

This script turns the jpeg and png images into rendered images. Once again this is handled dynamically 
and is dependent on the screenInfo.m information. It also calculates the ideal image size (customisable) 
depending on how large the researcher wants the image compared to the eye-distance from the monitor to ensure 
absolute consistency between participants. Afterwhich various coordinates are defined for the created images as 
well as calculations for circular items.
