# Birds
Analysing the behaviour of birds when exposed to different magnetic fields would give insight as to their migratory patterns. To enable quantitative analysis of the movement of birds in their cages we use a combination of techniques from computer vision and machine learning to automatically track their location and by extension, their behaviour.

For videos recorded by a thermal camera the results were promising with regards to accuracy. Real time evaluation was not achieved.
For videos recorded by a regular RGB web camera, the results were not as good;  accuracy was poor and the runtime per frame was high. Usually the classifier would locate objects of similar colour of the bird but with different shape.

Larger activity spikes are detected by the system, such as flight. However, activity in place, such as the bird moving its head is not accurately detected.
