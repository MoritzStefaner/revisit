package com.swfjunkie.tweetr.data.objects
{	
    /**
     * Extended User Data Object
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
   
    public class ExtendedUserData
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
        public function ExtendedUserData(
                                            profileBackgroundColor:Number = 0,
                                            profileTextColor:Number = 0,
                                            profileLinkColor:Number = 0,
                                            profileSidebarFillColor:Number = 0,
                                            profileSidebarBorderColor:Number = 0,
                                            friendsCount:Number = 0,
                                            createdAt:String = null,
                                            favouritesCount:Number = 0,
                                            utcOffset:Number = 0,
                                            timeZone:String = null,
                                            profileBackgroundImageUrl:String = null,
                                            profileBackgroundTile:Boolean = false,
                                            following:Boolean = false,
                                            notifications:Boolean = false,
                                            statusesCount:Number = 0
                                        ) 
        {
            this.profileBackgroundColor = profileBackgroundColor;
            this.profileTextColor = profileTextColor;
            this.profileLinkColor = profileLinkColor;
            this.profileSidebarFillColor = profileSidebarFillColor;
            this.profileSidebarBorderColor = profileSidebarBorderColor;
            this.friendsCount = friendsCount;
            this.createdAt = createdAt;
            this.favouritesCount = favouritesCount;
            this.utcOffset = utcOffset;
            this.timeZone = timeZone;
            this.profileBackgroundImageUrl = profileBackgroundImageUrl;
            this.profileBackgroundTile = profileBackgroundTile;
            this.following = following;
            this.notifications = notifications;
            this.statusesCount = statusesCount;
            
        }
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        public var profileBackgroundColor:Number;
        public var profileTextColor:Number;
        public var profileLinkColor:Number;
        public var profileSidebarFillColor:Number;
        public var profileSidebarBorderColor:Number;
        public var friendsCount:Number;
        public var createdAt:String;
        public var favouritesCount:Number;
        public var utcOffset:Number;
        public var timeZone:String;
        public var profileBackgroundImageUrl:String;
        public var profileBackgroundTile:Boolean;
        public var following:Boolean;
        public var notifications:Boolean;
        public var statusesCount:Number;
        //--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
    }
}