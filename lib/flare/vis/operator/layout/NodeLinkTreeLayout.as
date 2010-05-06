package flare.vis.operator.layout {
	import flare.util.Orientation;
	import flare.util.Vectors;
	import flare.vis.data.NodeSprite;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Layout that places nodes using a tidy layout of a node-link tree
	 * diagram. This algorithm lays out a rooted tree such that each
	 * depth level of the tree is on a shared line. The orientation of the
	 * tree can be set such that the tree goes left-to-right (default),
	 * right-to-left, top-to-bottom, or bottom-to-top.
	 * 
	 * <p>The algorithm used is that of Christoph Buchheim, Michael Jünger,
	 * and Sebastian Leipert from their research paper
	 * <a href="http://citeseer.ist.psu.edu/buchheim02improving.html">
	 * Improving Walker's Algorithm to Run in Linear Time</a>, Graph Drawing 2002.
	 * This algorithm corrects performance issues in Walker's algorithm, which
	 * generalizes Reingold and Tilford's method for tidy drawings of trees to
	 * support trees with an arbitrary number of children at any given node.</p>
	 */
	public class NodeLinkTreeLayout extends Layout
	{
		// -- Properties ------------------------------------------------------
		
		/** Property name for storing parameters for this layout. */
		public static const PARAMS:String = "nodeLinkTreeLayoutParams";
		
		private var _orient:String = Orientation.LEFT_TO_RIGHT; // orientation
		private var _bspace:Number = 5;  // the spacing between sibling nodes
    	private var _tspace:Number = 25; // the spacing between subtrees
    	private var _dspace:Number = 50; // the spacing between depth levels
    	private var _depths:Vector.<Object> = new Vector.<Object>(20); // stores depth co-ords
    	private var _maxDepth:int = 0;
    	private var _ax:Number, _ay:Number; // for holding anchor co-ordinates
		
		/** The orientation of the layout. */
		public function get orientation():String { return _orient; }
		public function set orientation(o:String):void { _orient = o; }
		
		/** The space between successive depth levels of the tree. */
		public function get depthSpacing():Number { return _dspace; }
		public function set depthSpacing(s:Number):void { _dspace = s; }
		
		/** The space between siblings in the tree. */
		public function get breadthSpacing():Number { return _bspace; }
		public function set breadthSpacing(s:Number):void { _bspace = s; }
		
		/** The space between different sub-trees. */
		public function get subtreeSpacing():Number { return _tspace; }
		public function set subtreeSpacing(s:Number):void { _tspace = s; }
		
		
		// -- Methods ---------------------------------------------------------
	
		/**
		 * Creates a new NodeLinkTreeLayout.
		 * @param orientation the orientation of the layout
		 * @param depthSpace the space between depth levels in the tree
		 * @param breadthSpace the space between siblings in the tree
		 * @param subtreeSpace the space between different sub-trees
		 */		
		public function NodeLinkTreeLayout(
			orientation:String=Orientation.LEFT_TO_RIGHT, depthSpace:Number=50,
			breadthSpace:Number=5, subtreeSpace:Number=25)
		{
			_orient = orientation;
			_dspace = depthSpace;
			_bspace = breadthSpace;
			_tspace = subtreeSpace;
		}
	
		/** @inheritDoc */
		protected override function layout():void
		{
        	Vectors.fill(_depths, 0);
        	_maxDepth = 0;
        	
        	var root:NodeSprite = layoutRoot as NodeSprite;
        	if (root == null) { _t = null; return; }
        	var rp:Params = params(root);

        	firstWalk(root, 0, 1);                       // breadth/depth stats
        	var a:Point = layoutAnchor;
        	_ax = a.x; _ay = a.y;                        // determine anchor
        	determineDepths();                           // sum depth info
        	secondWalk(root, null, -rp.prelim, 0, true); // assign positions
        	updateEdgePoints(_t);                        // update edges
    	}

		protected override function autoAnchor():void
		{
			// otherwise generate anchor based on the bounds
			var b:Rectangle = layoutBounds;
			var r:NodeSprite = layoutRoot as NodeSprite;
			switch (_orient) {
			case Orientation.LEFT_TO_RIGHT:
				_ax = b.x + _dspace + r.w;
				_ay = b.y + b.height / 2;
				break;
			case Orientation.RIGHT_TO_LEFT:
				_ax = b.width - (_dspace + r.w);
				_ay = b.y + b.height / 2;
				break;
			case Orientation.TOP_TO_BOTTOM:
				_ax = b.x + b.width / 2;
				_ay = b.y + _dspace + r.h;
				break;
			case Orientation.BOTTOM_TO_TOP:
				_ax = b.x + b.width / 2;
				_ay = b.height - (_dspace + r.h);
				break;
			default:
				throw new Error("Unrecognized orientation value");
			}
			_anchor.x = _ax;
			_anchor.y = _ay;
		}

    	private function firstWalk(n:NodeSprite, num:int, depth:uint):void
    	{
    		setSizes(n);
    		updateDepths(depth, n);
    		var np:Params = params(n);
    		np.number = num;
    		
    		var expanded:Boolean = n.expanded;
    		if (n.childDegree == 0 || !expanded) // is leaf
    		{
    			var l:NodeSprite = n.prevNode;
    			np.prelim = l==null ? 0 : params(l).prelim + spacing(l,n,true);
    		}
    		else if (expanded) // has children, is expanded
    		{
    			var midpoint:Number, i:uint;
    			var lefty:NodeSprite = n.firstChildNode;
    			var right:NodeSprite = n.lastChildNode;
    			var ancestor:NodeSprite = lefty;
    			var c:NodeSprite = lefty;
    			
    			for (i=0; c != null; ++i, c = c.nextNode) {
    				firstWalk(c, i, depth+1);
    				ancestor = apportion(c, ancestor);
    			}
    			executeShifts(n);
    			midpoint = 0.5 * (params(lefty).prelim + params(right).prelim);
    			
    			l = n.prevNode;
    			if (l != null) {
    				np.prelim = params(l).prelim + spacing(l,n,true);
    				np.mod = np.prelim - midpoint;
    			} else {
    				np.prelim = midpoint;
    			}
    		}
    	}
    
    	private function apportion(v:NodeSprite, a:NodeSprite):NodeSprite
    	{
    		var w:NodeSprite = v.prevNode;
    		if (w != null) {
    			var vip:NodeSprite, vim:NodeSprite, vop:NodeSprite, vom:NodeSprite;
    			var sip:Number, sim:Number, sop:Number, som:Number;
    			
    			vip = vop = v;
    			vim = w;
    			vom = vip.parentNode.firstChildNode;
    			
    			sip = params(vip).mod;
    			sop = params(vop).mod;
    			sim = params(vim).mod;
    			som = params(vom).mod;
    			
    			var shift:Number;
    			var nr:NodeSprite = nextRight(vim);
    			var nl:NodeSprite = nextLeft(vip);
    			while (nr != null && nl != null) {
    				vim = nr;
    				vip = nl;
    				vom = nextLeft(vom);
    				vop = nextRight(vop);
    				params(vop).ancestor = v;
    				shift = (params(vim).prelim + sim) - 
    					(params(vip).prelim + sip) + spacing(vim,vip,false);
    				
    				if (shift > 0) {
    					moveSubtree(ancestor(vim,v,a), v, shift);
    					sip += shift;
    					sop += shift;
    				}
    				
    				sim += params(vim).mod;
                	sip += params(vip).mod;
                	som += params(vom).mod;
                	sop += params(vop).mod;
                
                	nr = nextRight(vim);
                	nl = nextLeft(vip);
            	}
            	if (nr != null && nextRight(vop) == null) {
                	var vopp:Params = params(vop);
                	vopp.thread = nr;
                	vopp.mod += sim - sop;
            	}
            	if (nl != null && nextLeft(vom) == null) {
                	var vomp:Params = params(vom);
                	vomp.thread = nl;
                	vomp.mod += sip - som;
                	a = v;
            	}
        	}
        	return a;
    	}
    
    	private function nextLeft(n:NodeSprite):NodeSprite
    	{
    		var c:NodeSprite = null;
        	if (n.expanded) c = n.firstChildNode;
        	return (c != null ? c : params(n).thread);
    	}

    	private function nextRight(n:NodeSprite):NodeSprite
    	{
    		var c:NodeSprite = null;
    		if (n.expanded) c = n.lastChildNode;
        	return (c != null ? c : params(n).thread);
    	}

		private function moveSubtree(wm:NodeSprite, wp:NodeSprite, shift:Number):void
		{
			var wmp:Params = params(wm);
			var wpp:Params = params(wp);
			var subtrees:Number = wpp.number - wmp.number;
			wpp.change -= shift/subtrees;
			wpp.shift += shift;
			wmp.change += shift/subtrees;
			wpp.prelim += shift;
			wpp.mod += shift;
		}   

		private function executeShifts(n:NodeSprite):void
		{
			var shift:Number = 0, change:Number = 0;
			for (var c:NodeSprite = n.lastChildNode; c != null; c = c.prevNode)
			{
				var cp:Params = params(c);
				cp.prelim += shift;
				cp.mod += shift;
				change += cp.change;
				shift += cp.shift + change;
			}
		}
		
		private function ancestor(vim:NodeSprite, v:NodeSprite, a:NodeSprite):NodeSprite
		{
			var vimp:Params = params(vim);
			var p:NodeSprite = v.parentNode;
			return (vimp.ancestor.parentNode == p ? vimp.ancestor : a);
		}
    
    	private function secondWalk(n:NodeSprite, p:NodeSprite, m:Number, depth:uint, visible:Boolean):void
    	{
    		// set position
    		var np:Params = params(n);
    		var o:Object = _t.$(n);
    		setBreadth(o, p, (visible ? np.prelim : 0) + m);
    		setDepth(o, p, _depths[depth] as Number);
    		setVisibility(n, o, visible);
    		
    		// recurse
    		var v:Boolean = n.expanded ? visible : false;
    		var b:Number = m + (n.expanded ? np.mod : np.prelim)
    		if (v) depth += 1;
    		for (var c:NodeSprite = n.firstChildNode; c!=null; c=c.nextNode)
    		{
    			secondWalk(c, n, b, depth, v);
    		}
    		np.clear();
    	}

		private function setBreadth(n:Object, p:NodeSprite, b:Number):void
		{
			switch (_orient) {
				case Orientation.LEFT_TO_RIGHT:
				case Orientation.RIGHT_TO_LEFT:
					n.y = _ay + b;
					break;
				case Orientation.TOP_TO_BOTTOM:
				case Orientation.BOTTOM_TO_TOP:
					n.x = _ax + b;
					break;
				default:
					throw new Error("Unrecognized orientation value");
			}
		}

		private function setDepth(n:Object, p:NodeSprite, d:Number):void
		{
			switch (_orient) {
				case Orientation.LEFT_TO_RIGHT:
					n.x = _ax + d;
					break;
				case Orientation.RIGHT_TO_LEFT:
					n.x = _ax - d;
					break;
				case Orientation.TOP_TO_BOTTOM:
					n.y = _ay + d;
					break;
				case Orientation.BOTTOM_TO_TOP:
					n.y = _ax - d;
					break;
				default:
					throw new Error("Unrecognized orientation value");
			}
		}
		
		private function setVisibility(n:NodeSprite, o:Object, visible:Boolean):void
		{
    		o.alpha = visible ? 1.0 : 0.0;
    		o.mouseEnabled = visible;
    		if (n.parentEdge != null) {
    			o = _t.$(n.parentEdge);
    			o.alpha = visible ? 1.0 : 0.0;
    			o.mouseEnabled = visible;
    		}

		}
		
		private function setSizes(n:NodeSprite):void
		{
			_t.endSize(n, _rect);
			n.w = _rect.width;
			n.h = _rect.height;
		}
		
		private function spacing(l:NodeSprite, r:NodeSprite, siblings:Boolean):Number
		{
			var w:Boolean = Orientation.isVertical(_orient);
			return (siblings ? _bspace : _tspace) + 0.5 *
					(w ? l.w + r.w : l.h + r.h)
    	}
    
    	private function updateDepths(depth:uint, item:NodeSprite):void
    	{
    		var v:Boolean = Orientation.isVertical(_orient);
    		var d:Number = v ? item.h : item.w;

			// resize if needed
			if (depth >= _depths.length) {
    			_depths = Vectors.copy(_depths, new Vector.<Object>(int(1.5*depth)));
    			for (var i:int=depth; i<_depths.length; ++i) _depths[i] = 0;
			} 

        	_depths[depth] = Math.max(_depths[depth] as Number, d);
        	_maxDepth = Math.max(_maxDepth, depth);
    	}
    
    	private function determineDepths():void
    	{
        	for (var i:uint=1; i<_maxDepth; ++i)
            	_depths[i] += (_depths[i-1] as Number) + _dspace;
    	}
		
		// -- Parameter Access ------------------------------------------------
		
		private function params(n:NodeSprite):Params
		{
			var p:Params = n.props[PARAMS] as Params;
			if (p == null) {
				p = new Params();
				n.props[PARAMS] = p;
			}
			if (p.number == -2) { p.init(n); }
			return p;
    	}
		
	} // end of class NodeLinkTreeLayout
}

import flare.vis.data.NodeSprite;

class Params {
	public var prelim:Number = 0;
	public var mod:Number = 0;
	public var shift:Number = 0;
	public var change:Number = 0;
	public var number:int = -2;
	public var ancestor:NodeSprite = null;
	public var thread:NodeSprite = null;
    
    public function init(item:NodeSprite):void
    {
    	ancestor = item;
    	number = -1;
    }

	public function clear():void
	{
		number = -2;
		prelim = mod = shift = change = 0;
		ancestor = thread = null;
	}
} // end of class Params