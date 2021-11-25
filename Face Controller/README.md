<p align="center">
  <a href="https://github.com/Chgv99/Face-Class/blob/main/README.md">English</a> • <a href="https://github.com/Chgv99/Face-Class/blob/main/README(es).md">Español</a>
</p>

<h1 align="center">
 Face Class
</h1>
<!--<h1 style="display: none">
  EY
</h1>-->
<p align="center">
 <b>A simple class for webcam face-detection implementation in your projects using <a href="https://processing.org/">Processing</a>.</b>
</p>
<p align="center">
 <img src="https://img.shields.io/badge/Project-WIP-orange"> <img src="https://img.shields.io/badge/Documentation-Outdated-orange">
</p>
<p align="center">
 <a href="https://github.com/Chgv99/Face-Class/blob/main/README.md#features">Features</a> • <a href="https://github.com/Chgv99/Face-Class/blob/main/README.md#usage">Usage</a> • <a href="https://github.com/Chgv99/Face-Class/blob/main/README.md#methods">Methods</a>
</p>

<!--<p align="center">
 This is a project 
</p>-->

<!--<h1>Index</h1>
<details>
 <summary>Expand</summary>
 
 1. Description
 2. Usage
    * With some
    * Sub bullets
</details>-->

<!--<p align="center">
  <img width="460" height="300" src="https://github.com/Chgv99/Pong/blob/main/preview.gif">
</p>-->

# Features

You'll be able to receive useful data easily from your webcam and use it in your own [Processing](https://processing.org/) project.

<details open>
  <summary><b>The current version offers:</b></summary>

1. Face position tracking.
2. Facial features (eyebrows, eyes and mouth) position tracking.
3. Cropping a face from the webcam output.
4. Cropping facial features.
  
</details>

<details>
<summary><b>Future features:</b></summary>

1. Get a measurement of eyes and mouth amplitude.
2. Get a measurement of eyebrows height
3. Much more...
  
</details>

# Usage

First of all you'll need to import the class into your project.

1. [Download](https://github.com/Chgv99/Face-Class/archive/refs/heads/main.zip) the *.zip*.
2. Extract
3. Copy Face-Class-main/face_controller/face.pde next to the main file of your Processing project.
4. Now you can call the Face class inside your project!

To make use of the Face class you just need to create an object of the Face class and call *Process()* every frame. See [methods](https://github.com/Chgv99/Face-Class/blob/main/README.md#methods) for more info.


```processing
FaceController fc;

void setup() {
  size(640, 480);
  fc = new FaceController(this, "Camera Name");
  //You can also call process() inside setup();
}

void draw() {  
  background(0);
  fc.process();
  PImage faceImg = fc.getFaceCrop();
  image(faceImg, width/2 - faceImg.width/2, height/2 - faceImg.height/2, faceImg.width, faceImg.height);
}
```
<p align="center">
 <i>An example of how to draw a face crop in the middle of the canvas. Check out more <a href="https://github.com/Chgv99/Face-Class/tree/main/Examples">here</a>.</i>
</p>


# Methods

| Method | Type        | Description                                              | Parameters           |
| ------ | ----------- | -------------------------------------------------------- | -------------------- |
| FaceController   | Constructor | Initializes face and facial features objects and loads *face_landmark_model.dat* and *haarcascade_frontalface_default.xml* | <ul><li>PApplet parent (normally *this*)</li><li>String camera</li></ul> |
| FaceController (overloaded)  | Constructor | Initializes face and facial features objects and loads *face_landmark_model.dat* and *haarcascade_frontalface_default.xml* | <ul><li>PApplet parent (normally *this*)</li><li>String camera</li><li>float size</li></ul> |
| FaceController (overloaded)   | Constructor | Initializes face and facial features objects and loads *face_landmark_model.dat* and *haarcascade_frontalface_default.xml* | <ul><li>PApplet parent (normally *this*)</li><li>String camera</li><li>float size</li><li>float upperOffset</li><li>float lowerOffset</li><li>float leftOffset</li><li>float rightOffset</li></ul> |
| process | boolean | Updates face variables using camera's output. Returns if the camera was available or not. |
| process (overloaded) | boolean | Updates face variables using camera's output. Returns if the camera was available or not. | boolean debug |
| getCamScale | float | Returns the scale of the camera |
| getCamSize | PVector | Returns the original size of the camera |
| getCenter | PVector | Returns the coordinates of the center of the face |
| getReference | float | Returns face distance reference |
| getFace | RealFace | Returns the raw face object used in FaceController |
| getFaceCrop | PImage | Returns a crop of the face detected in the camera output |
| getLeftEyebrow | RealEyebrow | Returns the raw left eyebrow object used in FaceController |
| getRightEyebrow | RealEyebrow | Returns the raw right eyebrow object used in FaceController |
| getLeftEye | RealEye | Returns the raw left eye object used in FaceController |
| getLeftEyeCrop | PImage | Returns a crop of the left eye detected in the camera output |
| getRightEye | RealEye | Returns the raw right eye object used in FaceController |
| getRightEyeCrop | PImage | Returns a crop of the right eye detected in the camera output |
| getMouth | RealMouth | Returns the raw mouth object used in FaceController |
| getMouthCrop | PImage | Returns a crop of the mouth detected in the camera output |
| print | void | Prints face data |
<!--| getDistance | float | Returns an approximate distance between the camera and the face of the user |
| getMouthAmplitude | float (0-1) | Returns mouth's amplitude relative to the size of the face |
| mouthIsOpen | boolean | Returns true if mouth's amplitude is greater than a certain threshold |-->



<p align="center">
 GitHub <a href="https://github.com/Chgv99">@Chgv99</a> · Twitter <a href="https://twitter.com/ChgvCode">@ChgvCode</a>
</p>
