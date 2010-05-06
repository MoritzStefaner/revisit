package eu.stefaner.flareextensions.render {
	import flash.display.CapsStyle;

	import flare.vis.data.DataSprite;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.render.ShapeRenderer;

	/**
	 * @author mo
	 */
	public class HorizontalCurvedLineRenderer extends ShapeRenderer {

		private static var _instance : HorizontalCurvedLineRenderer = new HorizontalCurvedLineRenderer();
		public var slope : Number;

		/** Static ShapeRenderer instance. */
		public static function get instance() : HorizontalCurvedLineRenderer { 
			return _instance; 
		}

		public function HorizontalCurvedLineRenderer(slope : Number = .33) {
			super();
			this.slope = slope;
		}

		override public function render(s : DataSprite) : void {
			var d : EdgeSprite = s as EdgeSprite;
			d.graphics.clear();

			if(d.source == null || d.target == null || !d.source.visible || !d.target.visible) {
				return;
			}
			
			d.alpha = Math.min(d.source.alpha, d.target.alpha);
			
			var x1 : Number = d.source.x + d.source.width;
			var y1 : Number = d.source.y + (s.props.shiftY1 ? s.props.shiftY1 : 0);
			var x2 : Number = d.target.x;
			var y2 : Number = d.target.y;

			d.graphics.lineStyle(d.lineWidth, d.lineColor, d.lineAlpha, false, "normal", CapsStyle.NONE);
			d.graphics.moveTo(x1, y1);
			var diffX : Number = x2 - x1;
			var diffY : Number = y2 - y1;
			
			// smooth tangents on both sides:
			d.graphics.curveTo(x1 + diffX * slope, y1, x1 + diffX * .5, y1 + diffY * .5);
			d.graphics.curveTo(x2 - diffX * slope , y2, x2, y2);
		}
	}
}
