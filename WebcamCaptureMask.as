/***********************************
@@Title:		Webcam Capturing Images
@@Date:			January 2012
@@Author:		Steve Griffith

***********************************/
package{
	import flash.media.Camera;
	import flash.media.Video;
	
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.utils.Timer;
	
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ActivityEvent;

	
	public class WebcamCaptureMask extends MovieClip{
		
		public var camera:Camera;
		public var imgData:BitmapData;
		public var img:Bitmap;
		public var timmy:Timer = new Timer(50, 1);
		public var speed:Number = -4;
		public var rotSpeed:Number = 2;
		
		public function WebcamCaptureMask(){
			imgFilter_mc.visible = false;
			camera = Camera.getCamera();
			camera.setMode(640, 480, this.stage.frameRate);
			camera.setMotionLevel(10, 1500);	
			if(camera != null){
				myVideo.attachCamera(camera);
				takePic_btn.addEventListener(MouseEvent.CLICK, capture);
				//create an image that matches the size of the video object
				imgData = new BitmapData(myVideo.width, myVideo.height);
				img = new Bitmap(imgData);
				
				imgFilter_mc.handles_mc.start();
				imgFilter_mc.img_mc.mask = imgFilter_mc.handles_mc.fMask;
				save_mc.addEventListener(MouseEvent.CLICK, saveImg);
			}else{
				trace("You need a camera");
			}
		}
		
		public function capture(ev:MouseEvent):void{
			imgData.draw(myVideo);
			img.smoothing = true;	//to help with the scale
			img.scaleX = img.scaleY = 2;	//make it double the size of the video.
			
			myVideo.visible = false;
			imgFilter_mc.visible = true;
			//place the image captured from the webcam into the mask creator
			imgFilter_mc.img_mc.addChild(img);
		}
		
		public function saveImg(ev:MouseEvent):void{
			//hide handles
			imgFilter_mc.handles_mc.toggleHandles(false);
			
			//get bounding box as an array of min and max x and y values
			var r:Object = imgFilter_mc.handles_mc.getPicBounds();
			trace("(",r.minX, r.minY,") (", r.maxX, r.maxY, ")");
			
			//get handles and control points
			var p:Object = imgFilter_mc.handles_mc.getPoints();
			
			//convert to global points
			//example: handles_mc.localToGlobal( aPoint );
			var p1:Point = imgFilter_mc.handles_mc.localToGlobal( new Point(r.minX, r.minY) );
			var p2:Point = imgFilter_mc.handles_mc.localToGlobal( new Point(r.maxX, r.maxY) );
			var tempW:Number = p2.x - p1.x;
			var tempH:Number = p2.y - p1.y;
			var rct:Rectangle = new Rectangle(p1.x, p1.y, tempW, tempH); 
							
			
			var imgDataSource:BitmapData = new BitmapData(imgFilter_mc.width, imgFilter_mc.height, true, 0x00FF0000);
			imgDataSource.draw(imgFilter_mc);
			//now trim the image
			imgData = new BitmapData(rct.width, rct.height);
			imgData.copyPixels(imgDataSource, rct, new Point(0,0));
			img = new Bitmap(imgData, "always", true);
			img.smoothing = true;
			
			var mc:MovieClip = new MovieClip();
			mc.cacheAsBitmap = true;
			
			mc.addChild( img );
			addChild(mc);
			imgFilter_mc.visible = false;
			save_mc.visible = false;
			
			
			//get the target size BEFORE adding the image
			var smallWidth:Number = character_mc.head_mc.width;
			var smallHeight:Number = character_mc.head_mc.height;
			//place head on character
			character_mc.head_mc.addChild(mc);
			//size and position the head
			var xratio:Number = 1;
			var yratio:Number = 1;
			//calculate the ratio between the sizes in order to resize the image to match the oval
			if( mc.width > smallWidth ){
				xratio = smallWidth/mc.width;
				yratio = smallHeight/mc.height;
			}else{
				xratio = mc.width/smallWidth;
				yratio = mc.height/smallHeight;
			}
			mc.scaleX = xratio + 0.2;	//make it slightly bigger for bobble head effect
			mc.scaleY = yratio + 0.2;
			//hide the oval after adding the real image head
			character_mc.head_mc.oval_mc.visible = false;
			//move the head to the center of the head_mc registration point
			mc.x = -(mc.width/2);
			mc.y = -(mc.height/2);
			
			character_mc.addEventListener(Event.ENTER_FRAME, move);
		}
		
		public function move(ev:Event):void{
			var m:MovieClip = MovieClip(ev.currentTarget);
			m.x += speed;
			if(m.x < 10 || m.x > (stage.stageWidth-10) ){
				speed *= -1;
				m.x += speed;
			}
			m.head_mc.rotation += rotSpeed;
			if( m.head_mc.rotation > 30 || m.head_mc.rotation < -30){
				rotSpeed *= -1;
				m.head_mc.rotation += rotSpeed;
			}
		}
		
	}
}