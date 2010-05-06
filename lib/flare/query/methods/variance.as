package flare.query.methods {
	import flare.query.Variance;
	
	
	
	/**
	 * Creates a new <code>Variance</code> query operator that computes
	 * the population variance.
	 * @param expr the input expression
	 * @return the new query operator
	 */
	public function variance(expr:*):Variance
	{
		return new Variance(expr);
	}
}