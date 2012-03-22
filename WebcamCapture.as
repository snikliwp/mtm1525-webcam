/***********************************
@@Title:		Webcam Capturing Images
@@Date:			January 2012
@@Author:		Steve Griffith

***********************************/
package{
	import flash.media.Camera;
	import flash.media.Video;
	import flash.events.ActivityEvent;
	//import flash.media.Microphone;
	//import flash.media.Sound;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import flash.display.BitmapData;
	import flash.display.Bitmap;

	
	public class WebcamCapture extends MovieClip{
		
		public var camera:Camera;
		public var imgData:BitmapData;
		public var img:Bitmap;
		
		public function WebcamCapture(){
			camera = Camera.getCamera();
			camera.setMode(640, 480, this.stage.frameRate);
			camera.setMotionLevel(10, 1500);	
			if(camera != null){
				//camera.addEventListener(ActivityEvent.ACTIVITY, youMoved);
				myVideo.attachCamera(camera);
				takePic_btn.addEventListener(MouseEvent.CLICK, capture);
				//create an image that matches the size of the video object
				imgData = new BitmapData(myVideo.width, myVideo.height);
				img = new Bitmap(imgData);
				img.x = 455;
				img.y = 55;
				addChild(img);
			}else{
				trace("You need a camera");
			}
		}
		
		public function capture(ev:MouseEvent):void{
			imgData.draw(myVideo);
			img.smoothing = true;	//to help with the scale
			img.scaleX = img.scaleY = 2;	//make it double the size of the video.
			myVideo.visible = false;
		}
		
		public function youMoved(ev:ActivityEvent):void{
			//trace("Activity event: " + ev);
			
			
		}
		
	}
}