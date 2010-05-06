package com.swfjunkie.tweetr.data.objects
{	
    /**
     * Search Results Data Object
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
   
    public class SearchResultData
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
        public function SearchResultData(
                                         id:Number = 0, 
                                         link:String = null, 
                                         text:String = null, 
                                         createdAt:String = null, 
                                         userProfileImage:String = null, 
                                         user:String = null, 
                                         userLink:String = null) 
        {
            this.id = id;
            this.link = link;
            this.text = text;
            this.createdAt = createdAt;
            this.userProfileImage = userProfileImage;
            this.user = user;
            this.userLink = userLink;
        }
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        public var id:Number;
        public var link:String;
        public var text:String;
        public var createdAt:String;
        public var userProfileImage:String;
        public var user:String;
        public var userLink:String;
        //--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
    }
}