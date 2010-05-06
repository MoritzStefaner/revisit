package com.swfjunkie.tweetr.data.objects
{	
    /**
     * Twitter Status Data Object 
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
   
    public class StatusData
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
        public function StatusData(createdAt:String = null, 
                                    id:Number = 0, 
                                    text:String = null,
                                    source:String = null,
                                    truncated:Boolean = false,
                                    inReplyToStatusId:Number = 0,
                                    inReplyToUserId:Number = 0,
                                    favorited:Boolean = false,
                                    inReplyToScreenName:String = null,
                                    user:UserData = null)
        {
            this.createdAt = createdAt;
            this.id = id;
            this.text = text;
            this.source = source;
            this.truncated = truncated;
            this.inReplyToStatusId = inReplyToStatusId;
            this.inReplyToUserId = inReplyToUserId;
            this.favorited = favorited;
            this.inReplyToScreenName = inReplyToScreenName;
            this.user = user;
        }
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        
        public var createdAt:String;
        public var id:Number;
        public var text:String;
        public var source:String;
        public var truncated:Boolean;
        public var inReplyToStatusId:Number;
        public var inReplyToUserId:Number;
        public var favorited:Boolean;
        public var inReplyToScreenName:String;
        public var retweetedStatus:StatusData;
        public var geoLat:Number;
        public var geoLong:Number;
        public var user:UserData;
        
        //--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
    }
}