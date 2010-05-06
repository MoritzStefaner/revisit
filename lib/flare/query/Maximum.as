package flare.query
{
	/**
	 * Aggregate operator for computing the maximum of a set of values.
	 */
	public class Maximum extends AggregateExpression
	{
		private var _value:Object = null;
		
		/**
		 * Creates a new Maximum operator
		 * @param input the sub-expression of which to compute the maximum
		 */
		public function Maximum(input:*=null) {
			super(input);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function eval(o:Object=null):*
		{
			return _value;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function reset():void
		{
			_value = null;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function aggregate(value:Object):void
		{
			value = _expr.eval(value);
			if (_value == null || value > _value) {
				_value = value;
			}
		}
		
	} // end of class Maximum
}