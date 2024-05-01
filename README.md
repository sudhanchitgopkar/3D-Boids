# An Exploration of 3D Boids
Sudhan Chitgopkar (`sudhanchitgopkar[at]g.harvard.edu`), Michael Zhan (`michaelzhan[at]g.harvard.edu`)
CS 175, Computer Graphics Final Project. Harvard University, School of Engineering & Applied Science.

## Installation
There are two ways to run this application: (1) directly from the build files or (2) by compiling from source.
### Running from Build
1. Find and download the build file suited to your machine [here](https://drive.google.com/drive/folders/1mWGLuv5E4tNUZq9oCFuCkNrkVfUuH_uW?usp=sharing).
	* Build files currently exist for 64-bit Windows, 64-bit Mac OS, and Mx/ARM Mac OS systems only.
2. Unzip the file, and run the `.exe` (Windows) or the `.app` (Mac)
	* If you encounter issues running on Mac OS due to security-related prompts, follow these steps:
		-  _System Settings_ > _Privacy & Security_ >  _Allow applications downloaded from: **App Store and identified developers**_
		-  _System Settings_ > _Privacy & Security_ > _Security_ > _“BoidRunner” was blocked from use because it is not from an identified developer_ > _Open Anyway_
	* If you encounter other issues running on Mac OS, try
		- Downloading and installing [JDK 17](https://openjdk.org/projects/jdk/17/)
		- Building and running from Source
		
### Running from Source
1. Download and install [Processing](https://processing.org/download)
2. Clone this repository
	```$ git clone git@github.com:sudhanchitgopkar/3D-Boids.git```
3. Navigate to the repository `$ cd 3d-Boids` and `$ open BoidRunner.pde`
4. Press the play button on the top left of the Processing IDE

## Usage
The simulation can be modified using the following controls:

`x`: auto-rotate along the $x$-axis (_default: off)_ </br>
`y`: auto-rotate along the $y$-axis (_default: on)_ </br>
`z`: auto-rotate along the $z$-axis (_default: off)_ </br>
`g`: toggle GUI visibility (_default: on)_ </br>
`r`: restart to a new, random simulation </br>
`(shift)* + mouse click + drag`: control the simulation box rotation </br>
> [!IMPORTANT]
> Press and hold down `shift` while clicking and dragging the mouse if the GUI is enabled. This is not necessary when the GUI is disabled.

## Simulation Parameters
| Parameter          |    Description  |
|--------------------|------------------|
|`SEPARATION WEIGHT`| Weight added to the separation force, keeping Boids away from other visible Boids </br>
`ALIGNTMENT WEIGHT`|Weight added to the alignment force, aligning Boids with other visible Boids </br>
`COHESUION WEIGHT`| Weight added to the cohesion force, moving Boids to the center of all visible Boids </br>
`WALL AVOIDANCE WEIGHT`|Weight added to the have Boids avoid walls around them </br>
`OBSTACLE AVOIDANCE WEIGHT`| Weight added to the have Boids avoid obstacles around them </br>
`VISIBILITY`| distance each Boid can see around itself (360 degrees) </br>
`NUM BOIDS`| Total number of Boids in the simulaiton </br>

> [!CAUTION]
> Increasing `NUM_BOIDS` may cause the simulation to lag depending on your hardware






