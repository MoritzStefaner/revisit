package flare.query
{
	/**
	 * Aggregate operator for computing the sum of a set of values.
	 */
	public class Sum extends AggregateExpression
	{
		private var _sum:Number;
		
		/**
		 * Creates a new Sum operator.
		 * @param input the sub-expression of which to compute the sum
		 */
		public function Sum(input:*=null) {
			super(input);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function reset():void
		{
			_sum = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function eval(o:Object=null):*
		{
			return _sum;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function aggregate(value:Object):void
		{
			var x:Number = Number(_expr.eval(value));
			if (!isNaN(x)) {
				_sum += x;
			}
		}
		
	} // end of class Sum
}