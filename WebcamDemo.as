/***********************************
@@Title:		Webcam demo
@@Date:			January 19, 2009
@@Author:		Steve Griffith

***********************************/
package{
	import flash.media.Camera;
	import flash.media.Video;
	import flash.events.ActivityEvent;
	//import flash.media.Microphone;
	//import flash.media.Sound;
	import flash.display.MovieClip;
	
	public class WebcamDemo extends MovieClip{
		
		public var camera:Camera;
		
		public function WebcamDemo(){
			camera = Camera.getCamera();
			trace("Camera.muted: ", camera.muted.toString());
			camera.setMode(320, 240, this.stage.frameRate);
			camera.setMotionLevel(20, 1500);	//motionLevel 0 - 100, timeout in milliseconds
			//0 means lack of motion, 100 is constant motion
			//this will trigger the Activity event
			//just like Microphone.setSilenceLevel()
			if(camera != null){
				camera.addEventListener(ActivityEvent.ACTIVITY, youMoved);
				myVideo.attachCamera(camera);
				trace("Camera.muted: ", camera.muted.toString());
			}else{
				trace("You need a camera");
			}
		}
		
		public function youMoved(ev:ActivityEvent):void{
			trace("Activity event: " + ev);
			trace("Camera.muted: ", camera.muted.toString());
			if(ev.activating){
				trace("Camera has been disturbed");
				myVideo.alpha = 1.0;
			}else{
				trace("Camera is going to sleep");
				myVideo.alpha = 0.4;
			}
		}
		
	}
}