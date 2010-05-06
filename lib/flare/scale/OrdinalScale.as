package flare.scale {
	import flare.util.Vectors;

	import flash.utils.Dictionary;

	/**
	 * Scale for ordered sequential data. This supports both numeric and
	 * non-numeric data, and simply places each element in sequence using
	 * the ordering found in the input data vector.
	 */
	public class OrdinalScale extends Scale {

		private var _ordinals : Vector.<Object>;
		private var _lookup : Dictionary;

		/**
		 * Creates a new OrdinalScale.
		 * @param ordinals an ordered object vector of data values to include in the
		 *  scale
		 * @param flush the flush flag for scale padding
		 * @param copy flag indicating if a copy of the input data vector should
		 *  be made. True by default.
		 * @param labelFormat the formatting pattern for value labels
		 */
		public function OrdinalScale(ordinals : Vector.<Object> = null, flush : Boolean = false,
			copy : Boolean = true, labelFormat : String = null) {
			_ordinals = (ordinals == null ? new Vector.<Object>() : copy ? Vectors.copy(ordinals) : ordinals);
			buildLookup();
			_flush = flush;
			_format = labelFormat;
		}

		/** @inheritDoc */
		public override function get scaleType() : String {
			return ScaleType.ORDINAL;
		}

		/** @inheritDoc */
		public override function clone() : Scale {
			return new OrdinalScale(_ordinals, _flush, true, _format);
		}

		// -- Properties ------------------------------------------------------

		/** The number of distinct values in this scale. */
		public function get length() : int {
			return _ordinals.length;
		}

		/** The ordered data array defining this scale. */
		public function get ordinals() : Vector.<Object> {
			return _ordinals;
		}

		public function set ordinals(val : Vector.<Object>) : void {
			_ordinals = val; 
			buildLookup();
		}

		/**
		 * Builds a lookup table for mapping values to their indices.
		 */
		protected function buildLookup() : void {
			_lookup = new Dictionary();
			for (var i : uint = 0;i < _ordinals.length; ++i)
                _lookup[ordinals[i]] = i;
		}

		/** @inheritDoc */
		public override function get min() : Object { 
			return _ordinals[0]; 
		}

		/** @inheritDoc */
		public override function get max() : Object { 
			return _ordinals[_ordinals.length - 1]; 
		}

		// -- Scale Methods ---------------------------------------------------
		
		/**
		 * Returns the index of the input value in the ordinal object vector
		 * @param value the value to lookup
		 * @return the index of the input value. If the value is not contained
		 *  in the ordinal object vector, this method returns -1.
		 */
		public function index(value : Object) : int {
			var idx : * = _lookup[value];
			return (idx == undefined ? -1 : int(idx));
		}

		/** @inheritDoc */
		public override function interpolate(value : Object) : Number {
			if (_ordinals == null || _ordinals.length == 0) return 0.5;
			
			if (_flush) {
				return Number(_lookup[value]) / (_ordinals.length - 1);
			} else {
				return (0.5 + _lookup[value]) / _ordinals.length;
			}
		}

		/** @inheritDoc */
		public override function lookup(f : Number) : Object {
			if (_flush) {
				return _ordinals[int(Math.round(f * (_ordinals.length - 1)))];
			} else {
				f = Math.max(0, Math.min(1, f * _ordinals.length - 0.5));
				return _ordinals[int(Math.round(f))];
			}
		}

		/** @inheritDoc */
		public override function values(num : int = -1) : Vector.<Object> {
			var a : Vector.<Object> = new Vector.<Object>();
			var stride : Number = num < 0 ? 1 : Math.max(1, Math.floor(_ordinals.length / num));
			for (var i : uint = 0;i < _ordinals.length; i += stride) {
				a.push(_ordinals[i]);
			}
			return a;
		}
	} // end of class OrdinalScale
}