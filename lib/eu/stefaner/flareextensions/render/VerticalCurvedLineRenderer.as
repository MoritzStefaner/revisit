package eu.stefaner.flareextensions.render {
	import flare.vis.data.DataSprite;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.render.ShapeRenderer;

	import flash.display.CapsStyle;

	/**
	 * @author mo
	 */
	public class VerticalCurvedLineRenderer extends ShapeRenderer {

		private static var _instance : VerticalCurvedLineRenderer = new VerticalCurvedLineRenderer();
		public var slope : Number;

		/** Static ShapeRenderer instance. */
		public static function get instance() : VerticalCurvedLineRenderer { 
			return _instance; 
		}

		public function VerticalCurvedLineRenderer(slope : Number = .33) {
			super();
			this.slope = slope;
		}

		override public function render(s : DataSprite) : void {
			var d : EdgeSprite = s as EdgeSprite;
			d.graphics.clear();

			if(d.source == null || d.target == null || !d.source.visible || !d.target.visible) {
				return;
			}
			
			//d.alpha = Math.min(d.source.alpha, d.target.alpha);
			var x1 : Number = d.source.x + (s.props.shiftX1 ? s.props.shiftX1 : 0);
			var x2 : Number = d.target.x;

			if(d.source.y > d.target.y) {
				var y1 : Number = d.source.getBounds(d).top;
				var y2 : Number = d.target.getBounds(d).bottom;
			} else {
				
				var y1 : Number = d.source.getBounds(d).bottom;
				var y2 : Number = d.target.getBounds(d).top;	
			}
			
			d.graphics.lineStyle(d.lineWidth, d.lineColor, d.lineAlpha, false, "normal", CapsStyle.NONE);
			
			d.graphics.moveTo(x1, y1);
			
			var diffX : Number = x2 - x1;
			var diffY : Number = y2 - y1;
			
			// smooth tangents on both sides:
			d.graphics.curveTo(x1, y1 + diffY * slope, x1 + diffX * .5, y1 + diffY * .5);
			d.graphics.curveTo(x2, y2 - diffY * slope, x2, y2);
		}
	}
}
