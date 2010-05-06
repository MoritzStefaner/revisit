package com.swfjunkie.tweetr.data.objects
{	
    /**
     * Object Class Description
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
   
    public class RelationData
    {
        //--------------------------------------------------------------------------
        //
        //  Class variables
        //
        //--------------------------------------------------------------------------
        public static const RELATION_TYPE_SOURCE:String = "source";
        public static const RELATION_TYPE_TARGET:String = "target";
        //--------------------------------------------------------------------------
        //
        //  Initialization
        //
        //--------------------------------------------------------------------------
        public function RelationData() 
        {
        }
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        public var type:String;
        public var id:Number;
        public var screenName:String;
        public var following:Boolean;
        public var followedBy:Boolean;
        public var notificationsEnabled:Boolean
        //--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
    }
}