package com.swfjunkie.tweetr.data.objects
{	
    /**
     * User Data Object
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
   
    public class UserData
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
        public function UserData( id:Number = 0,
                                    name:String = null,
                                    screenName:String = null,
                                    location:String = null,
                                    description:String = null,
                                    profileImageUrl:String = null,
                                    url:String = null,
                                    profileProtected:Boolean = false,
                                    followersCount:Number = 0,
                                    extended:ExtendedUserData = null,
                                    lastStatus:StatusData = null) 
        {
            this.id = id;
            this.name = name;
            this.screenName = screenName;
            this.location = location;
            this.description = description;
            this.profileImageUrl = profileImageUrl;
            this.url = url;
            this.profileProtected = profileProtected;
            this.followersCount = followersCount;
            this.extended = extended;
            this.lastStatus = lastStatus;
        }
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        
        public var id:Number;
        public var name:String;
        public var screenName:String;
        public var location:String;
        public var description:String;
        public var profileImageUrl:String;
        public var url:String;
        public var profileProtected:Boolean;
        public var followersCount:Number;
        
        // if we are dealing with extended user information you will
        // have to put it or find it within an ExtendedUserData Object
        public var extended:ExtendedUserData;
        
        public var lastStatus:StatusData;
        //--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
    }
}