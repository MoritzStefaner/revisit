package flare.vis.operator.distortion {
	import flare.animate.Transitioner;
	import flare.vis.axis.Axis;
	import flare.vis.axis.CartesianAxes;
	import flare.vis.data.Data;
	import flare.vis.data.DataSprite;
	import flare.vis.events.VisualizationEvent;
	import flare.vis.operator.layout.Layout;

	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Base class for distortion operators that adjust the position and size
	 * of visual objects in a visualization.
	 */
	public class Distortion extends Layout
	{
		/** A bounding rectangle for storing the layout bounds. */
		protected var _b:Rectangle;
		
		/** Flag indicating if x-coordinates should be distorted. */
		public var distortX:Boolean;		
		/** Flag indicating if y-coordinates should be distorted. */
		public var distortY:Boolean;
		/** Flag indicating if sizes should be distorted. */
		public var distortSize:Boolean;		
		/** Flag indicating if axes should be distorted. */
		public var distortAxes:Boolean;		
		/** Flag indicating if the <code>DataSprite.size</code> field should be
		 *  distorted. If false (the default), the scaleX and scaleY properties
		 *  are used instead. */
		public var useSizeField:Boolean = false;		
		/** Flag indicating if the size or scale values should be reset to 1
		 *  upon each invocation of the distortion. This avoids the need to
		 *  manually reset the size values on each update. The default value
		 *  is false. */
		public var resetSize:Boolean = false;		
		/** Flag indicating if distortion anchor points outside the layout
		 *  bounds should be considered by the distortion. If true, external
		 *  anchors will be mapped to nearest point on the border of the layout
		 *  bounds. */
		public var anchorInBounds:Boolean = true;
		
		/** @inheritDoc */
		public override function set layoutAnchor(p:Point):void {
			if (p != null && anchorInBounds) {
        		var b:Rectangle = layoutBounds, x:Number, y:Number;
        		x = (p.x < b.left ? b.left : (p.x > b.right ? b.right : p.x));
        		y = (p.y < b.top ? b.top : (p.y > b.bottom ? b.bottom : p.y));
        		p = new Point(x, y);
			}
			super.layoutAnchor = p;
		}
		
		// --------------------------------------------------------------------
		
		/**
		 * Creates a new Distortion.
		 * @param distortX Flag indicating if x-coordinates should be distorted
		 * @param distortY Flag indicating if y-coordinates should be distorted
		 * @param distortSize Flag indicating is sizes should be distorted
		 */		
		public function Distortion(distortX:Boolean=true, distortY:Boolean=true,
			distortSize:Boolean=true, distortAxes:Boolean=true)
		{
			this.distortX = distortX;
			this.distortY = distortY;
			this.distortSize = distortSize;
			this.distortAxes = distortAxes;
		}
		
		/** @inheritDoc */
		public override function operate(t:Transitioner=null):void
		{
			_t = (t!=null ? t : Transitioner.DEFAULT);
			_b = layoutBounds;
			visualization.data.visit(distort, Data.NODES);
			_t = null;
			
			if (distortAxes && visualization.xyAxes)
				visualization.addEventListener(
					VisualizationEvent.UPDATE, axesDistort);
		}
		
		/**
		 * Distortion method for processing a DataSprite.
		 * @param d a DataSprite to distort
		 */
		protected function distort(d:DataSprite):void
		{
			var o:Object = _t.$(d), ss:Number;
			if (resetSize) {
				if (useSizeField) { o.size = 1; }
				else { o.scaleX = 1; o.scaleY = 1; }
			}
			var bb:Rectangle = _t.endBounds(d, d.parent);
			
			if (distortX) o.x = xDistort(o.x);
			if (distortY) o.y = yDistort(o.y);
			if (distortSize) {
				ss = sizeDistort(bb, o.x, o.y);
				if (useSizeField) {
					o.size *= ss;
				} else {
					o.scaleX *= ss;
					o.scaleY *= ss;
				}
			}
		}
		
		/**
		 * Compute a distorted x-coordinate.
		 * @param x the initial x-coordinate
		 * @return the distorted s-coordinate
		 */
		protected function xDistort(x:Number):Number
		{
			// for sub-classes
			return x;
		}
		
		/**
		 * Compute a distorted y-coordinate.
		 * @param y the initial y-coordinate
		 * @return the distorted y-coordinate
		 */
		protected function yDistort(y:Number):Number
		{
			// for sub-classes
			return y;
		}
		
		/**
		 * Compute a distorted size value.
		 * @param bb an object's bounding box
		 * @param x the initial x-coordinate
		 * @param y the initial y-coordinate
		 * @return the distorted size value
		 */
		protected function sizeDistort(bb:Rectangle, x:Number, y:Number):Number
		{
			// for sub-classes
			return 1;
		}
		
		/**
		 * Performs distortion of Cartesian axes. As axis layout is recomputed
		 * <em>after</em> the operators have run, we must distort the axes in
		 * a separate step. This is accomplished by adding an update listener
		 * on the visualization that invokes the axis distortion after the
		 * axis layout has completed. This method is registered as the
		 * listener callback.
		 * @param evt the visualization update event
		 */
		protected function axesDistort(evt:VisualizationEvent):void
		{
			_t = evt.transitioner;
			_t = (_t==null ? Transitioner.DEFAULT : _t);
			
			var axes:CartesianAxes = visualization.xyAxes;
			if (axes != null) {
				distortAxis(axes.xAxis, true, false);
				distortAxis(axes.yAxis, false, true);
			}
			visualization.removeEventListener(
				VisualizationEvent.UPDATE, axesDistort);
				
			_t = null;
		}
		
		private function distortAxis(axis:Axis, xb:Boolean, yb:Boolean):void
		{
			var i:int, o:Object;
			
			// distort the axis labels
			var labels:Sprite = axis.labels;
			for (i=0; i<labels.numChildren; ++i) {
				o = _t.$(labels.getChildAt(i));
				if (xb && distortX) {
					o.x = xDistort(o.x);
				}
				if (yb && distortY) {
					o.y = yDistort(o.y);
				}
			}
			
			// distort the axis gridlines
			var glines:Sprite = axis.gridLines;
			for (i=0; i<glines.numChildren; ++i) {
				o = _t.$(glines.getChildAt(i));
				if (xb && distortX) {
					o.x1 = xDistort(o.x1);
					o.x2 = xDistort(o.x2);
				}
				if (yb && distortY) {
					o.y1 = yDistort(o.y1);
					o.y2 = yDistort(o.y2);
				}
			}
		}
		
	} // end of class Distortion
}