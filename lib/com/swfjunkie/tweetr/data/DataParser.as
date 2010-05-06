package com.swfjunkie.tweetr.data
{
    import com.swfjunkie.tweetr.data.objects.CursorData;
    import com.swfjunkie.tweetr.data.objects.DirectMessageData;
    import com.swfjunkie.tweetr.data.objects.ExtendedUserData;
    import com.swfjunkie.tweetr.data.objects.HashData;
    import com.swfjunkie.tweetr.data.objects.ListData;
    import com.swfjunkie.tweetr.data.objects.RelationData;
    import com.swfjunkie.tweetr.data.objects.SavedSearchData;
    import com.swfjunkie.tweetr.data.objects.SearchResultData;
    import com.swfjunkie.tweetr.data.objects.StatusData;
    import com.swfjunkie.tweetr.data.objects.TrendData;
    import com.swfjunkie.tweetr.data.objects.UserData;
    import com.swfjunkie.tweetr.utils.TweetUtil;
    
    /**
     * Static Class doing nothing more than Parsing to Data Objects
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
     
    public class DataParser 
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
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        //--------------------------------------------------------------------------
        //
        //  Additional getters and setters
        //
        //--------------------------------------------------------------------------
        //--------------------------------------------------------------------------
        //
        // Overridden API
        //
        //--------------------------------------------------------------------------
        //--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
        /**
         * Parses a Status XML to StatusData Objects
         * @param xml        The XML Response from Twitter
         * @return An Array filled with StatusData's
         */ 
        public static function parseStatuses(xml:XML):Array
        {
            var statusData:StatusData;
            var userData:UserData;
            var array:Array = [];
            var list:XMLList = xml..status;
            var n:Number = (list.length() == 0) ? 1 : list.length();
            
            for (var i:int = 0; i < n; i++)
            {
                var node:XML = (n > 1) ? list[i] as XML : xml;
                statusData = parseStatus(node);
                array.push(statusData);
            }
            return array;
        }
        
        /**
         * Parses a Direct Message XML to DirectMessageData Objects
         * @param xml        The XML Response from Twitter
         * @return An Array filled with DirectMessageData's
         */ 
        public static function parseDirectMessages(xml:XML):Array
        {
            var senderData:UserData;
            var recipientData:UserData;
            var directData:DirectMessageData;
            var array:Array = [];
            var list:XMLList = xml..direct_message;
            var n:Number = (list.length() == 0) ? 1 : list.length();
            
            for (var i:Number = 0; i < n; i++)
            {
                var node:XML = (n > 1) ? list[i] as XML : xml;
            
                directData = new DirectMessageData(
                                                    node.id,
                                                    node.sender_id,
                                                    node.text,
                                                    node.recipient_id,
                                                    node.created_at,
                                                    node.sender_screen_name,
                                                    node.recipient_screen_name
                                                  );
                senderData = new UserData(
                                            node.sender.id,
                                            node.sender.name,
                                            node.sender.screen_name,
                                            node.sender.location,
                                            node.sender.description,
                                            node.sender.profile_image_url,
                                            node.sender.url,
                                            TweetUtil.stringToBool(node.sender['protected']),
                                            node.sender.followers_count
                                          );
                                          
                recipientData = new UserData(
                                            node.recipient.id,
                                            node.recipient.name,
                                            node.recipient.screen_name,
                                            node.recipient.location,
                                            node.recipient.description,
                                            node.recipient.profile_image_url,
                                            node.recipient.url,
                                            TweetUtil.stringToBool(node.recipient['protected']),
                                            node.recipient.followers_count
                                            );         
                                                            
                directData.sender = senderData;
                directData.recipient = recipientData;
                array.push(directData);
            }
            return array;   
        }
        
         /**
         * Parses a User XML to either UserData or ExtendedUserData Objects
         * @param xml        The XML Response from Twitter
         * @param extended   Should extended User Element be retrieved
         * @return An Array filled with either UserData or ExtendedUserData Objects
         */ 
        public static function parseUserInfos(xml:XML, extended:Boolean = true):Array
        {
            var statusData:StatusData;
            var userData:UserData;
            var extendedData:ExtendedUserData;
            var array:Array = [];
            var list:XMLList = xml..user;
            var n:Number = (list.length() == 0) ? 1 : list.length();
            
            for (var i:Number = 0; i < n; i++)
            {
                var node:XML = (n > 1) ? list[i] as XML : xml;
                if (node.id.toString() == "")
                    node = list[i] as XML;
                
                if (node)
                {
                    statusData = new StatusData(node.status.created_at,
                                                node.status.id,
                                                TweetUtil.tidyTweet(node.status.text),
                                                node.status.source,
                                                TweetUtil.stringToBool(node.status.truncated),
                                                node.status.in_reply_to_status_id,
                                                node.status.in_reply_to_user_id,
                                                TweetUtil.stringToBool(node.status.favorited),
                                                node.status.in_reply_to_screen_name);
                
                    userData = new UserData(node.id,
                                            node.name,
                                            node.screen_name,
                                            node.location,
                                            node.description,
                                            node.profile_image_url,
                                            node.url,
                                            TweetUtil.stringToBool(node['protected']),
                                            node.followers_count);
                                                                              
                    userData.lastStatus= statusData;
                    
                    if (extended)
                    {
                        extendedData = new ExtendedUserData(
                                                            parseInt("0x"+node.profile_background_color),
                                                            parseInt("0x"+node.profile_text_color),
                                                            parseInt("0x"+node.profile_link_color),
                                                            parseInt("0x"+node.profile_sidebar_fill_color),
                                                            parseInt("0x"+node.profile_sidebar_border_color),
                                                            node.friends_count,
                                                            node.created_at,
                                                            node.favourites_count,
                                                            node.utc_offset,
                                                            node.time_zone,
                                                            node.profile_background_image_url,
                                                            TweetUtil.stringToBool(node.profile_background_tile),
                                                            TweetUtil.stringToBool(node.following),
                                                            TweetUtil.stringToBool(node.notificactions),
                                                            node.statuses_count
                                                            )
                        userData.extended = extendedData;
                    }
                    array.push(userData);
                }
            }
            return array;   
        }
        
        /**
         * Parses a Relation XML to an Array
         * @param xml        The XML Response from Twitter
         * @return An Array with a source and a target RelationData
         */
        public static function parseRelationship(xml:XML):Array
        {
            var array:Array = [];
            
            var target:RelationData = new RelationData();
            target.type = RelationData.RELATION_TYPE_TARGET;
            target.id = parseFloat(xml.target.id);
            target.screenName = xml.target.screen_name;
            target.following = TweetUtil.stringToBool(xml.target.following);
            target.followedBy = TweetUtil.stringToBool(xml.target.followed_by);
            target.notificationsEnabled = TweetUtil.stringToBool(xml.target.notifications_enabled);
            
            var source:RelationData = new RelationData();
            source.type = RelationData.RELATION_TYPE_SOURCE;
            source.id = parseFloat(xml.source.id);
            source.screenName = xml.source.screen_name;
            source.following = TweetUtil.stringToBool(xml.source.following);
            source.followedBy = TweetUtil.stringToBool(xml.source.followed_by);
            source.notificationsEnabled = TweetUtil.stringToBool(xml.source.notifications_enabled);
            
            array.push(target);
            array.push(source);
            return array;
        }
        
        /**
         * Parses a ID XML to an Array
         * @param xml        The XML Response from Twitter
         * @return An Array filled numeric Id's
         */ 
        public static function parseIds(xml:XML):Array
        {
            var array:Array = [];
            var list:XMLList = xml..id;
            var n:Number = (list.length() == 0) ? 1 : list.length();
            
            for (var i:Number = 0; i < n; i++)
            {
                var node:XML = (n > 1) ? list[i] as XML : xml;
                array.push(Number(node));
            }
            return array;
        }
        
        /**
         * Parses a List XML to an Array
         * @param xml   The XML Response from twitter
         * @return An Array filled with ListDatas
         */ 
        public static function parseLists(xml:XML):Array
        {
            var listData:ListData;
            var userData:UserData;
            var extendedData:ExtendedUserData;
            var array:Array = [];
            var list:XMLList = xml..list;
            var n:Number = (list.length() == 0) ? 1 : list.length();
            
            for (var i:Number = 0; i < n; i++)
            {
                var node:XML = (n > 1) ? list[i] as XML : xml;
                
                if (node.id.toString() == "")
                    node = list[i] as XML;
                
                if (node)
                {
                    listData = new ListData();
                    listData.id = parseFloat(node.id);
                    listData.name = node.name;
                    listData.fullName = node.full_name;
                    listData.slug = node.slug;
                    listData.description = node.description;
                    listData.subscriberCount = parseFloat(node.subscriber_count);
                    listData.memberCount = parseFloat(node.member_count);
                    listData.uri = node.uri;
                    listData.isPublic = (node.mode == "public") ? true : false;
                    
                    
                    userData = new UserData(node.user.id,
                        node.user.name,
                        node.user.screen_name,
                        node.user.location,
                        node.user.description,
                        node.user..profile_image_url,
                        node.user.url,
                        TweetUtil.stringToBool(node.user['protected']),
                        node.user.followers_count);
                    
                    listData.user = userData;
                    
                    extendedData = new ExtendedUserData(
                        parseInt("0x"+node.user.profile_background_color),
                        parseInt("0x"+node.user.profile_text_color),
                        parseInt("0x"+node.user.profile_link_color),
                        parseInt("0x"+node.user.profile_sidebar_fill_color),
                        parseInt("0x"+node.user.profile_sidebar_border_color),
                        node.user.friends_count,
                        node.user.created_at,
                        node.user.favourites_count,
                        node.user.utc_offset,
                        node.user.time_zone,
                        node.user.profile_background_image_url,
                        TweetUtil.stringToBool(node.user.profile_background_tile),
                        TweetUtil.stringToBool(node.user.following),
                        TweetUtil.stringToBool(node.user.notificactions),
                        node.user.statuses_count
                    )
                    userData.extended = extendedData;
                    array.push(listData);
                }
            }
            return array;
        }
        
        
        /**
         * Parses Cursor Information if the response supplied by twitter contains it.
         * @param xml        The XML Response from Twitter
         * @return A CursorData Object
         */ 
        public static function parseCursor(xml:XML):CursorData
        {
            if (xml..next_cursor.toString() != "" && xml.previous_cursor.toString() != "")
                return new CursorData(parseFloat(xml..next_cursor.toString()), parseFloat(xml.previous_cursor.toString()));
            return null;
        }
        
        /**
         * Parses a Saved Searches XML to SavedSearchData Objects
         * @param xml        The XML Response from Twitter
         * @return An Array filled with SavedSearchData Objects
         */ 
        public static function parseSavedSearches(xml:XML):Array    
        {
            var savedSearch:SavedSearchData;
            var array:Array = [];
            var list:XMLList = xml..saved_search;
            var n:Number = (list.length() == 0) ? 1 : list.length();
            
            for (var i:Number = 0; i < n; i++)
            {
                var node:XML = list[i] as XML;
                if (node)
                {
                    savedSearch = new SavedSearchData();
                    savedSearch.id = node.id;
                    savedSearch.name = node['name'];
                    savedSearch.query = node.query;
                    savedSearch.position = node.position;
                    savedSearch.createdAt = node.created_at;
                    array.push(savedSearch);
                }
                else
                {
                    if (xml.id)
                    {
                        savedSearch = new SavedSearchData();
                        savedSearch.id = xml.id;
                        savedSearch.name = xml['name'];
                        savedSearch.query = xml.query;
                        savedSearch.position = xml.position;
                        savedSearch.createdAt = xml.created_at;
                        array.push(savedSearch);
                    }
                }
            }
            return array;
        }
        
        
        /**
         * Parses a Hash XML to HashData Objects
         * @param xml  The XML Response from Twitter
         * @return An Array filled with HashData Objects
         */ 
        public static function parseHash(xml:XML):Array
        {
            var array:Array = [];
            var hashData:HashData = new HashData();
            hashData.hourlyLimit = xml['hourly-limit'];
            hashData.remainingHits = xml['remaining-hits'];
            hashData.resetTimeInSeconds = xml['reset-time-in-seconds'];
            hashData.request = xml['request'];
            hashData.error = xml['error'];
            
            array.push(hashData);
            return array;   
        }
        
        
        /**
         * Parses out Boolean value from a <code>hasFriendship</code> Request
         * @param xml  The XML Response from Twitter
         * @return A Boolean value
         */ 
        public static function parseBoolean(xml:XML):Array
        {
            var array:Array = [];
            array.push(TweetUtil.stringToBool(xml.toString()));
            return array;   
        }
        
        /**
         * Parses a Searchresult XML to SearchResult Objects
         * @param xml  The XML Response from Twitter
         * @return An Array filled with SearchResult Objects
         */
        public static function parseSearchResults(xml:XML):Array
        {
            var ns:Namespace = new Namespace("http://www.w3.org/2005/Atom");
            var searchData:SearchResultData;
            var array:Array = [];
            var entry:XML;
            
            for each (entry in xml.ns::entry)
            {
                searchData = new SearchResultData();
                var str:String = entry.ns::id;
                var index:Number = str.lastIndexOf(':');
                
                searchData.id = parseInt(str.substring(index+1, str.length-1));
                searchData.text = entry.ns::title;        
                searchData.createdAt = entry.ns::updated;
                searchData.userProfileImage = entry.ns::link[1].@href;
                searchData.link = entry.ns::link[0].@href;
                searchData.userLink = entry.ns::author.ns::uri;
                searchData.user = entry.ns::author.ns::name;
                
                array.push(searchData);
            }
            return array;
        }
        
        
        /**
         * Parses a Trend JSON to TrendData Objects
         * @param xml  The XML Response from Twitter
         * @return An Array filled with TrendData Objects
         */
        public static function parseTrendsResults(data:String):Array
        {
            var array:Array = [];
            var trendData:TrendData;
            var startIndex:Number = String(data).indexOf("[");
            var endIndex:Number = String(data).indexOf("]");
            var nameArr:Array = [];
            var urlArr:Array = [];
            var str:String = String(data).substring(startIndex+2,endIndex-1);
            var strArr:Array = str.split("},{");
            var i:Number = 0;
            var n:Number = strArr.length;
            
            for (i = 0; i < n; i++)
            {
                var tmp:Array = String(strArr[i]).split(",");
                var name:String = tmp[0].split('"')[3];
                var url:String = tmp[1].split('"')[3];
                
                nameArr.push(name);
                urlArr.push(TweetUtil.replace(url,"\\/","/"));
            }
            
            n = nameArr.length;
            for (i = 0; i < n; i++)
            {
                trendData = new TrendData(nameArr[i], urlArr[i]);
                array.push(trendData);
            }
            return array;
        }
        //--------------------------------------------------------------------------
        //
        //  Overridden methods: _SuperClassName_
        //
        //--------------------------------------------------------------------------
        
        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        
        namespace point = "http://www.georss.org/georss";
        
        private static function parseStatus(xml:XML):StatusData
        {
            var statusData:StatusData = new StatusData(xml.created_at,
                xml.id,
                TweetUtil.tidyTweet(xml.text),
                xml.source,
                TweetUtil.stringToBool(xml.truncated),
                xml.in_reply_to_status_id,
                xml.in_reply_to_user_id,
                TweetUtil.stringToBool(xml.favorited),
                xml.in_reply_to_screen_name);
            
            if (xml.retweeted_status.hasComplexContent())
                statusData.retweetedStatus = parseStatus(xml.retweeted_status[0] as XML);
            
            if (xml.geo.hasComplexContent())
            {
                
                use namespace point;
                var points:Array = String(xml.geo.point).split(" ");
                statusData.geoLat = parseFloat(points[0]);
                statusData.geoLong = parseFloat(points[1]);
            }
            var userData:UserData = new UserData(xml.user.id,
                xml.user.name,
                xml.user.screen_name,
                xml.user.location,
                xml.user.description,
                xml.user.profile_image_url,
                xml.user.url,
                TweetUtil.stringToBool(xml.user['protected']),
                xml.user.followers_count); 
            
            statusData.user = userData;
            return statusData;
        }
        
        //--------------------------------------------------------------------------
        //
        //  Broadcasting
        //
        //--------------------------------------------------------------------------
        
        //--------------------------------------------------------------------------
        //
        //  Eventhandling
        //
        //--------------------------------------------------------------------------
    }
}