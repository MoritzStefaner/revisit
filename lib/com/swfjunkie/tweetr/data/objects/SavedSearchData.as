package com.swfjunkie.tweetr.data.objects
{	
    /**
     * Saved Search Data Object 
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
   
    public class SavedSearchData
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
        public function SavedSearchData( id:Number = 0,
                                           name:String = null,
                                           query:String = null,
                                           position:String = null,
                                           createdAt:String = null) 
        {
            this.id = id;
            this.name = name;
            this.query= query;
            this.position = position;
            this.createdAt = createdAt;
        }
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        public var id:Number;
        public var name:String;
        public var query:String;
        public var position:String;
        public var createdAt:String;
        //--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
    }
}