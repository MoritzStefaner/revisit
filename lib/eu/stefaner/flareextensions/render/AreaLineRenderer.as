package eu.stefaner.revisit {
	import flare.util.Colors;
	import flare.vis.data.DataSprite;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.render.ShapeRenderer;

	import flash.geom.Rectangle;

	/**
	 * @author mo
	 */
	public class AreaLineRenderer extends ShapeRenderer {

		private static var _instance : AreaLineRenderer = new AreaLineRenderer();

		/** Static ShapeRenderer instance. */
		public static function get instance() : AreaLineRenderer { 
			return _instance; 
		}

		public function AreaLineRenderer(defaultSize : Number = 6) {
			super(defaultSize);
		}

		override public function render(s : DataSprite) : void {
			var d : EdgeSprite = s as EdgeSprite;
			d.graphics.clear();
			
			var b1 : Rectangle = (d.source as TweetSprite).bg.getBounds(d);
			var b2 : Rectangle = (d.target as TweetSprite).bg.getBounds(d);
			
			d.graphics.lineStyle(0, 0, 0);
			
			// TOP
			d.graphics.beginFill(d.lineColor, d.lineAlpha);
			d.graphics.moveTo(b1.left, b1.top);
			d.graphics.lineTo(b2.left, b2.top);
			d.graphics.lineTo(b2.right, b2.top);
			d.graphics.lineTo(b1.right, b1.top);
			d.graphics.endFill();


			// LEFT
			d.graphics.beginFill(d.lineColor, d.lineAlpha);
			d.graphics.moveTo(b1.left, b1.top);
			d.graphics.lineTo(b2.left, b2.top);
			d.graphics.lineTo(b2.left, b2.bottom);
			d.graphics.lineTo(b1.left, b1.bottom);
			d.graphics.endFill();
			
			// RIGHT
			d.graphics.beginFill(Colors.darker(d.lineColor), d.lineAlpha);
			d.graphics.moveTo(b1.right, b1.top);
			d.graphics.lineTo(b2.right, b2.top);
			d.graphics.lineTo(b2.right, b2.bottom);
			d.graphics.lineTo(b1.right, b1.bottom);
			d.graphics.endFill();


			// BOTTOM
			d.graphics.beginFill(Colors.darker(d.lineColor), d.lineAlpha);
			d.graphics.moveTo(b1.left, b1.bottom);
			d.graphics.lineTo(b2.left, b2.bottom);
			d.graphics.lineTo(b2.right, b2.bottom);
			d.graphics.lineTo(b1.right, b1.bottom);
		
			d.graphics.endFill();	
		}
	}
}
