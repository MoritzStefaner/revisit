package flare.vis.operator {
	import flare.animate.Transitioner;
	import flare.vis.Visualization;

	/**
	 * Interface for operators that perform processing tasks on the contents
	 * of a Visualization. These tasks include layout, and color, shape, and
	 * size encoding. Custom operators can be defined by implementing this
	 * interface;
	 */
	public interface IOperator extends IMXMLObject
	{
		/** The visualization processed by this operator. */
		function get visualization():Visualization;
		function set visualization(v:Visualization):void;
		
		/** Indicates if the operator is enabled or disabled. */
		function get enabled():Boolean;
		function set enabled(b:Boolean):void;
		
		/**
		 * Sets parameter values for this operator.
		 * @params an object containing parameter names and values.
		 */
		function set parameters(params:Object):void;
		
		/**
		 * Performs an operation over the contents of a visualization.
		 * @param t a Transitioner instance for collecting value updates.
		 */
		function operate(t:Transitioner=null):void;
		
		/**
		 * Setup method invoked whenever this operator's visualization
		 * property is set.
		 */
		function setup():void;
		
	} // end of interface IOperator
}