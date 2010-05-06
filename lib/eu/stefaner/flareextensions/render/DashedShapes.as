package eu.stefaner.flareextensions.render {
	import flash.display.JointStyle;
	import flash.display.CapsStyle;
	import flash.display.Graphics;

	/**
	 * @author mo
	 */
	public class DashedShapes {

		public static function drawCubic(g : Graphics, ax : Number, ay : Number,
			bx : Number, by : Number, cx : Number, cy : Number, dx : Number, dy : Number,
			move : Boolean = true, lineWidth : Number = 10, gapWidth : Number = 5) : void {			
			var subdiv : int, u : Number, xx : Number, yy : Number;			
			
			// determine number of line segments
			subdiv = int((Math.sqrt((xx = (bx - ax)) * xx + (yy = (by - ay)) * yy) + Math.sqrt((xx = (cx - bx)) * xx + (yy = (cy - by)) * yy) + Math.sqrt((xx = (dx - cx)) * xx + (yy = (dy - cy)) * yy)) / 4);
			if (subdiv < 1) subdiv = 1;

			// compute Bezier co-efficients
			var c3x : Number = 3 * (bx - ax);
			var c2x : Number = 3 * (cx - bx) - c3x;
			var c1x : Number = dx - ax - c3x - c2x;
			var c3y : Number = 3 * (by - ay);
			var c2y : Number = 3 * (cy - by) - c3y;
			var c1y : Number = dy - ay - c3y - c2y;
			
			if (move) g.moveTo(ax, ay);
			
			var period : Number = lineWidth + gapWidth;
			var currentLength : Number = 0;
			
			var oldXX : Number = ax;
			var oldYY : Number = ay;
			var isInGap : Boolean = true;
			
			for (var i : uint = 0;i <= subdiv; ++i) {
				u = i / subdiv;
				xx = u * (c3x + u * (c2x + u * c1x)) + ax;
				yy = u * (c3y + u * (c2y + u * c1y)) + ay;
				
				if(currentLength <= lineWidth) {
					if(isInGap) {
						g.moveTo(oldXX, oldYY);
					}
					isInGap = false;
					g.lineTo(xx, yy);
				} else {
					isInGap = true;
				}
				
				var dist : Number = Math.sqrt((xx - oldXX) * (xx - oldXX) + (yy - oldYY) * (yy - oldYY));
				
				currentLength += dist;
				while(currentLength >= period) {
					currentLength -= period;
				}

				oldXX = xx;
				oldYY = yy;
			}
		}
	}
}
