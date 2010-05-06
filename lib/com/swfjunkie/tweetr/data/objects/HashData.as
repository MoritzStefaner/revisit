package com.swfjunkie.tweetr.data.objects
{	
    /**
     * Hash Data Object
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
   
    public class HashData
    {
        //--------------------------------------------------------------------------
        //
        //  Class variables
        //
        //--------------------------------------------------------------------------

        //--------------------------------------------------------------------------
        //
        //  Initialization
        //
        //--------------------------------------------------------------------------
        public function HashData() 
        {
        }
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        public var resetTimeInSeconds:Number;
        public var remainingHits:Number;
        public var hourlyLimit:Number;
        public var request:String;
        public var error:String;
        //--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
    }
}