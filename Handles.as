package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	
	public class Handles extends MovieClip {
		
		public var hands:Array = [];
		public var arrows:Array = [];
		public var avgX:Number = 0;
		public var avgY:Number = 0;
		public var fMask:Sprite;
		
		public function Handles() {
			// constructor code
			fMask = new Sprite();
			fMask.name = "faceMask";
			this.addChild(fMask);
		}
		
		public function start():void{
			for(var h:uint=0; h<this.numChildren; h++){
				if( this.getChildAt(h).name.indexOf("handle") > -1 ){
					//trace(this.getChildAt(h).name);
					hands.push( this.getChildAt(h));
					this.getChildAt(h).addEventListener(MouseEvent.MOUSE_DOWN, startD);
					this.getChildAt(h).addEventListener(MouseEvent.MOUSE_UP, stopD);
				}else if(this.getChildAt(h).name.indexOf("arrow") > -1){
					arrows.push( this.getChildAt(h) );
					MovieClip(this.getChildAt(h)).moved = false;
					this.getChildAt(h).addEventListener(MouseEvent.MOUSE_DOWN, startDArr);
					this.getChildAt(h).addEventListener(MouseEvent.MOUSE_UP, stopDArr);
				}
			}
			addEventListener(Event.ENTER_FRAME, drawLines, false, 0, true);
		}
		
		public function drawLines(ev:Event):void{
			//loop through all the handles
			avgX = 0;
			avgY = 0;
			var _xPrev:Number;
			var _yPrev:Number;
			var _x:Number;
			var _y:Number;
			fMask.graphics.clear();
			fMask.graphics.beginFill(0xFF0000, 1);
			fMask.graphics.lineStyle(1, 0x333333);
			fMask.graphics.moveTo( hands[0].x, hands[0].y )
			for(var i:Number=1; i<hands.length; i++){
				_x = hands[i].x;
				_y = hands[i].y;
				_xPrev = hands[i-1].x;
				_yPrev = hands[i-1].y;
				avgX += _x;
				avgY += _y;
				if( arrows[i-1].moved == false){
					arrows[i-1].x = (_x + _xPrev)/2;
					arrows[i-1].y = (_y + _yPrev)/2;
				}
				fMask.graphics.curveTo(arrows[i-1].x, arrows[i-1].y, hands[i].x, hands[i].y );
			}
			fMask.graphics.curveTo(arrows[5].x, arrows[5].y, hands[0].x, hands[0].y );
			fMask.graphics.endFill();
			if( arrows[5].moved == false){
				arrows[5].x = (hands[0].x + hands[5].x) / 2;
				arrows[5].y = (hands[0].y + hands[5].y) / 2;
			}
			/*avgX = avgX / this.numChildren;
			avgY = avgY / this.numChildren;	//the new centerpoint*/
			//set rotation
			/*var deltaX:Number;
			var deltaY:Number;
			for(i=0; i<arrows.length; i++){
				deltaX = arrows[i].x - avgX;
				deltaY = arrows[i].y - avgY;
				var rad:Number = Math.atan2(deltaY, deltaX);
				var angle:Number = rad * (180/Math.PI);
				arrows[i].rotation = angle;
			}*/
		}
		
		public function startD(ev:MouseEvent):void{
			var currHandle:MovieClip = MovieClip(ev.currentTarget);
			currHandle.startDrag();
		}
		
		public function stopD(ev:MouseEvent):void{
			var currHandle:MovieClip = MovieClip(ev.currentTarget);
			currHandle.stopDrag();
		}
		
		public function startDArr(ev:MouseEvent):void{
			var currHandle:MovieClip = MovieClip(ev.currentTarget);
			currHandle.startDrag();
			currHandle.moved = true;
		}
		
		public function stopDArr(ev:MouseEvent):void{
			var currHandle:MovieClip = MovieClip(ev.currentTarget);
			currHandle.stopDrag();
		}
		
		public function toggleHandles(toShow:Boolean = true):void{
			for(var m:Number=0, num:Number=hands.length; m<num; m++){
				hands[m].visible = toShow;
				arrows[m].visible = toShow;
			}
		}
		
		public function getPoints():Object{
			var pts:Object = {};
			var hdls:Array = [];
			var arrs:Array = [];
			for(var m:Number=0, num:Number=hands.length; m<num; m++){
				hdls.push( new Point(hands[m].x, hands[m].y) );
				arrs.push( new Point(arrows[m].x, arrows[m].y) );
			}
			pts.handles = hdls;
			pts.arrows = arrs;
			return pts;
		}
		
		public function getPicBounds():Object{
			//find the min and max x and y points
			var minX:Number = 1000;
			var minY:Number = 1000;
			var maxX:Number = 0;
			var maxY:Number = 0;
			for(var m:Number=0, num:Number=hands.length; m<num; m++){
				if(hands[m].x < minX){
					minX = hands[m].x - (hands[m].width/2);
				}
				if(hands[m].x > maxX){
					maxX = hands[m].x + (hands[m].width/2);
				}
				if(arrows[m].x < minX){
					minX = arrows[m].x - (arrows[m].width/2);
				}
				if(arrows[m].x > maxX){
					maxX = arrows[m].x + (arrows[m].width/2);
				}
				
				if(hands[m].y < minY){
					minY = hands[m].y - (hands[m].height/2);
				}
				if(hands[m].y > maxY){
					maxY = hands[m].y + (hands[m].height/2);
				}
				if(arrows[m].y < minY){
					minY = arrows[m].y - (arrows[m].height/2);
				}
				if(arrows[m].y > maxY){
					maxY = arrows[m].y + (arrows[m].height/2);
				}
				trace("hand ", m, " ", hands[m].x , hands[m].y);
				trace("arrow ", m, " ", arrows[m].x , arrows[m].y);
				//trace(m, ": minx: ", minX, " miny: ", minY);
			}
			return {"minX":minX, "minY":minY, "maxX":maxX, "maxY":maxY};
		}
	}
	
}



