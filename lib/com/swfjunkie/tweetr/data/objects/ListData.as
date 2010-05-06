package com.swfjunkie.tweetr.data.objects
{	
    /**
     * List Data Object Class
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
   
    public class ListData
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
        public function ListData() 
        {
        }
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        public var id:Number;
        public var name:String;
        public var fullName:String;
        public var slug:String;
        public var description:String;
        public var subscriberCount:Number;
        public var memberCount:Number;
        public var uri:String;
        public var isPublic:Boolean;
        public var user:UserData;
        //--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
    }
}