package com.swfjunkie.tweetr.data.objects
{	
    /**
     * Cursor Data Object
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
   
    public class CursorData
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
        public function CursorData(nextCursor:Number, previousCursor:Number) 
        {
            this.nextCursor = nextCursor;
            this.previousCursor = previousCursor;
        }
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        public var nextCursor:Number;
        public var previousCursor:Number;
        //--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
    }
}