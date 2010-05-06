package flare.query.methods {
	import flare.query.And;
	import flare.util.Vectors;
	
	
	
	
	
	/**
	 * Creates a new <code>And</code> query operator.
	 * @param rest a list of expressions to include in the and
	 * @return the new query operator
	 */
	public function and(...rest):And
	{
		var a:And = new And();
		a.setChildren(Vectors.copyFromArray(rest));
		return a;
	}	
}