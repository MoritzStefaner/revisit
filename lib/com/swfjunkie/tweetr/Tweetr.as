package com.swfjunkie.tweetr {
	import com.swfjunkie.tweetr.data.DataParser;
	import com.swfjunkie.tweetr.data.objects.CursorData;
	import com.swfjunkie.tweetr.events.TweetEvent;
	import com.swfjunkie.tweetr.oauth.IOAuth;
	import com.swfjunkie.tweetr.utils.Base64Encoder;

	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * Dispatched when the Tweetr has Completed a Request.
	 * @eventType com.swfjunkie.tweetr.events.TweetEvent.COMPLETE
	 */ 
	[Event(name="complete", type="com.swfjunkie.tweetr.events.TweetEvent")]

	/**
	 * Dispatched when something goes wrong while trying to request something from twitter
	 * @eventType com.swfjunkie.tweetr.events.TweetEvent.FAILED
	 */ 
	[Event(name="failed", type="com.swfjunkie.tweetr.events.TweetEvent")]

	/**
	 * Merely for Informational purposes. Dispatches the http status to the listener
	 * @eventType com.swfjunkie.tweetr.events.TweetEvent.STATUS
	 */ 
	[Event(name="status", type="com.swfjunkie.tweetr.events.TweetEvent")]

	/**
	 * Tweetr contains all twitter api calls that you need to create your own twitter client
	 * or application that uses twitter.
	 * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
	 */
	public class Tweetr extends EventDispatcher {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		private static const URL_PUBLIC_TIMELINE : String = "/statuses/public_timeline.xml";
		private static const URL_HOME_TIMELINE : String = "/statuses/home_timeline.xml";
		private static const URL_FRIENDS_TIMELINE : String = "/statuses/friends_timeline.xml";
		private static const URL_USER_TIMELINE : String = "/statuses/user_timeline";
		private static const URL_RETWEETS_BY_ME : String = "/statuses/retweeted_by_me.xml";
		private static const URL_RETWEETS_TO_ME : String = "/statuses/retweeted_to_me.xml";
		private static const URL_RETWEETS_OF_ME : String = "/statuses/retweets_of_me.xml";
		private static const URL_SINGLE_TWEET : String = "/statuses/show/";
		private static const URL_SEND_UPDATE : String = "/statuses/update.xml";
		private static const URL_DESTROY_TWEET : String = "/statuses/destroy/";
		private static const URL_RETWEET : String = "/statuses/retweet/";
		private static const URL_RETWEETS : String = "/statuses/retweets/";
		private static const URL_MENTIONS : String = "/statuses/mentions.xml";
		private static const URL_FRIENDS : String = "/statuses/friends";
		private static const URL_FOLLOWERS : String = "/statuses/followers";
		private static const URL_USER_DETAILS : String = "/users/show/";
		private static const URL_USER_SEARCH : String = "/users/search.xml";
		private static const URL_SINGLE_DIRECT_MESSAGE : String = "/direct_messages/show/";
		private static const URL_RECEIVED_DIRECT_MESSAGES : String = "/direct_messages.xml";
		private static const URL_SENT_DIRECT_MESSAGES : String = "/direct_messages/sent.xml";
		private static const URL_SEND_NEW_DIRECT_MESSAGE : String = "/direct_messages/new.xml";
		private static const URL_DESTROY_DIRECT_MESSAGE : String = "/direct_messages/destroy";
		private static const URL_CREATE_FRIENDSHIP : String = "/friendships/create/";
		private static const URL_DESTROY_FRIENDSHIP : String = "/friendships/destroy/";
		private static const URL_FRIENDSHIP_EXISTS : String = "/friendships/exists.xml";
		private static const URL_FRIENDSHIP_SHOW : String = "/friendships/show.xml";
		private static const URL_VERIFY_CREDENTIALS : String = "/account/verify_credentials.xml";
		private static const URL_RATELIMIT_STATUS : String = "/account/rate_limit_status.xml";
		private static const URL_UPDATE_PROFILE : String = "/account/update_profile.xml";
		private static const URL_UPDATE_PROFILE_COLORS : String = "/account/update_profile_colors.xml";
		private static const URL_UPDATE_PROFILE_IMAGE : String = "/account/update_profile_image.xml";
		private static const URL_UPDATE_PROFILE_BG_IMAGE : String = "/account/update_profile_background_image.xml";
		private static const URL_RETRIEVE_FAVORITES : String = "/favorites";
		private static const URL_CREATE_FAVORITE : String = "/favorites/create/";
		private static const URL_DESTROY_FAVORITE : String = "/favorites/destroy/";
		private static const URL_FOLLOW_USER : String = "/notifications/follow/";
		private static const URL_UNFOLLOW_USER : String = "/notifications/leave/";
		private static const URL_BLOCK_USER : String = "/blocks/create/";
		private static const URL_UNBLOCK_USER : String = "/blocks/destroy/";
		private static const URL_BLOCK_EXISTS : String = "/blocks/exists/";
		private static const URL_BLOCKS : String = "/blocks/blocking.xml";
		private static const URL_BLOCK_IDS : String = "/blocks/blocking/ids.xml";
		private static const URL_END_SESSION : String = "/account/end_session.xml";
		private static const URL_SOCIAL_GRAPH_FRIEND_IDS : String = "/friends/ids";
		private static const URL_SOCIAL_GRAPH_FOLLOWER_IDS : String = "/followers/ids";
		private static const URL_REPORT_SPAM : String = "/report_spam.xml";
		private static const URL_SAVED_SEARCHES : String = "/saved_searches.xml";
		private static const URL_RETRIEVE_SAVED_SEARCH : String = "/saved_searches/show/"; 
		private static const URL_CREATE_SAVED_SEARCH : String = "/saved_searches/create.xml";   
		private static const URL_DESTROY_SAVED_SEARCH : String = "/saved_searches/destroy/";
		private static const URL_TWITTER_SEARCH : String = "http://search.twitter.com/search.atom";
		public static var URL_TWITTER_SEARCH_OVERRIDE : String;
		private static const URL_TWITTER_TRENDS : String = "http://search.twitter.com/trends.json";
		private static const URL_TWITTER_TRENDS_CURRENT : String = "http://search.twitter.com/trends/current.json";
		private static const URL_TWITTER_TRENDS_DAILY : String = "http://search.twitter.com/trends/daily.json";
		private static const URL_TWITTER_TRENDS_WEEKLY : String = "http://search.twitter.com/trends/weekly.json";
		private static const DATA_FORMAT : String = "xml";
		/** Version String of the Tweetr Library */
		public static const VERSION : String = "1.0b2";		
		/** Return type defining what type of return Object you can expect, in this case: <code>StatusData</code> */
		public static const RETURN_TYPE_STATUS : String = "status";
		/** Return type defining what type of return Object you can expect, in this case: <code>UserData</code> */
		public static const RETURN_TYPE_USER_INFO : String = "users";    
		/** Return type defining what type of return Object you can expect, in this case: <code>ListData</code> */
		public static const RETURN_TYPE_LIST : String = "list";
		/** Return type defining what type of return Object you can expect, in this case: <code>DirectMessageData</code> */
		public static const RETURN_TYPE_DIRECT_MESSAGE : String = "direct_message";
		/** Return type defining what type of return Object you can expect, in this case: <code>RelationData</code> */
		public static const RETURN_TYPE_RELATIONSHIP : String = "relationship";
		/** Return type defining what type of return Object you can expect, in this case a Boolean value */
		public static const RETURN_TYPE_BOOLEAN : String = "bool";
		/** Return type defining what type of return Object you can expect, in this case: <code>HashData</code> */
		public static const RETURN_TYPE_HASH : String = "hash";
		/** Return type defining what type of return Object you can expect, in this case it's just an Array filled with id's */
		public static const RETURN_TYPE_IDS : String = "ids";
		/** Return type defining what type of return Object you can expect, in this case: <code>SavedSearchData</code> */
		public static const RETURN_TYPE_SAVED_SEARCHES : String = "saved_searches";
		/** Return type defining what type of return Object you can expect, in this case: <code>SearchResultData</code> */
		public static const RETURN_TYPE_SEARCH_RESULTS : String = "search";
		/** Return type defining what type of return Object you can expect, in this case: <code>TrendData/code> */
		public static const RETURN_TYPE_TRENDS_RESULTS : String = "trends";

		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new Tweetr Instance
		 * @param username   Username is optional at this point but is required for most twitter api calls
		 * @param password   Password is optional at this point but is required for most twitter api calls
		 */ 
		public function Tweetr(username : String = null, password : String = null) {
			_username = username;
			_password = password;
			init();
		}

		/**
		 * @private
		 * Initializes the instance.
		 */
		private function init() : void {
			urlRequest = new URLRequest();
			urlLoader = new URLLoader();
            
			urlLoader.addEventListener(Event.COMPLETE, handleTweetsLoaded);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleTweetsLoadingFailed);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var urlLoader : URLLoader;
		private var urlRequest : URLRequest;
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		/** @private */
		private var request : String;
		/**
		 * Get/Set if the Authentication Headers should be used or not. Default is false.
		 * <br/>This should only be set to true if you are building an AIR App
		 * and are calling the twitter api directly without the use of the proxy.
		 * 
		 */ 
		public var useAuthHeaders : Boolean = false;
		private var _oAuth : IOAuth;

		public function set oAuth(value : IOAuth) : void {
			_oAuth = value;
			if (!_username)
                _username = value.username;
		}

		/**
		 * @private 
		 * Returns the full request url
		 */ 
		private function get url() : URLRequest {
			if (_oAuth) {
				urlRequest.url = _serviceHost + request;
				var signedData : String = _oAuth.getSignedRequest(urlRequest.method, "https://api.twitter.com/1" + request, urlRequest.data as URLVariables);
				urlRequest.data = new URLVariables(signedData);
			}
            else if (!_username && !_password) {
				urlRequest.url = _serviceHost + request;
			} else {
				var base64 : Base64Encoder = new Base64Encoder();
				base64.encode(_username + ":" + _password);
                
				if (useAuthHeaders) {
					urlRequest.requestHeaders = [new URLRequestHeader("Authorization", "Basic " + base64.toString())];
					urlRequest.url = _serviceHost + request;
				} else {
					if (urlRequest.method == URLRequestMethod.GET) {
						request = (request.indexOf("?") != -1) ? request + "&hash=" + base64.toString() : request + "?hash=" + base64.toString();
					} else {
						if (urlRequest.data)
                            urlRequest.data.hash = base64.toString();
                        else
                            urlRequest.data = new URLVariables("hash=" + base64.toString());
					}
					urlRequest.url = _serviceHost + request;
				}
			}
			return urlRequest;
		}

		/** @private */
		private var _username : String;

		/** Set the username  */ 
		public function set username(value : String) : void {
			_username = value;
		}

		/** @private */
		private var _password : String;

		/** Set the users password */ 
		public function set password(value : String) : void {
			_password = value;
		}

		/** @private */
		private var _returnType : String;

		/** Return type of the current response */ 
		public function get returnType() : String {
			return _returnType;
		}

		private var _serviceHost : String = "https://api.twitter.com/1";

		/**
		 * Service Host URL you want to use.
		 * This has to be changed if you are going to use tweetr
		 * from a web app. Since the crossdomain policy of twitter.com
		 * is very restrictive. use Tweetr's own PHPProxy Class for this. 
		 */
		public function get serviceHost() : String {
			return _serviceHost;
		}

		public function set serviceHost(value : String) : void {
			/*
			if (value.indexOf("http://") == -1 && value.indexOf("https://") == -1)
			_serviceHost = "http://"+serviceHost;
			else
			 * 
			 */
			_serviceHost = value;
		}

		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
        
        
		//----------------------------------
		//  Status Methods
		//----------------------------------
        
		/**
		 * Returns the 20 most recent statuses from non-protected users who have set a custom user icon.  
		 * Does not require authentication.  Note that the public timeline is cached for 60 seconds so 
		 * requesting it more often than that is a waste of resources.
		 */
		public function getPublicTimeLine() : void {
			setGETRequest();
			_returnType = RETURN_TYPE_STATUS;
			request = URL_PUBLIC_TIMELINE; 
			urlLoader.load(url);
		}

		/**
		 * <b><font color="#00AA00">NEW</font></b> - Returns the 20 most recent statuses, including retweets, posted by the authenticating user and that user's friends. This is the equivalent of /timeline/home on the Web.
		 * <p><b>This method requires Authentication</b></p>
		 * @param since_id        Optional.  Returns only statuses with an ID greater than (that is, more recent than) the specified ID.
		 * @param since_date      Optional. Narrows the returned results to just those statuses created after the specified HTTP-formatted date, up to 24 hours old.
		 * @param max_id          Optional.  Returns only statuses with an ID less than (that is, older than) the specified ID.
		 * @param count           Optional. Specifies the number of statuses to retrieve. May not be greater than 200.
		 * @param page            Optional. Provides paging. Ex. http://twitter.com/statuses/user_timeline.xml?page=3
		 */ 
		public function getHomeTimeLine(since_id : String = null, since_date : String = null, max_id : Number = 0, count : Number = 0, page : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_STATUS;
            
			if (since_id)
                vars.since_id = since_id;
			if (since_date)
                vars.since = since_date;
			if (max_id > 0)
                vars.max_id = max_id;
			if (count > 0) {
				if (count > 200)
                    count = 200;
				vars.count = count;
			}
			if (page > 0)
                vars.page = page;
            
			setGETRequest(vars);
			request = URL_HOME_TIMELINE;
			urlLoader.load(url);
		}

		/**
		 * Returns the 20 most recent statuses posted by the authenticating user and that user's friends. This is the equivalent of /timeline/home on the Web.
		 * Note: Retweets will not appear in the friends_timeline for backwards compatibility. If you want retweets included use getHomeTimeLine.
		 * <p><b>This method requires Authentication</b></p>
		 * @param since_id        Optional.  Returns only statuses with an ID greater than (that is, more recent than) the specified ID.
		 * @param since_date      Optional. Narrows the returned results to just those statuses created after the specified HTTP-formatted date, up to 24 hours old.
		 * @param max_id          Optional.  Returns only statuses with an ID less than (that is, older than) the specified ID.
		 * @param count           Optional. Specifies the number of statuses to retrieve. May not be greater than 200.
		 * @param page            Optional. Provides paging. Ex. http://twitter.com/statuses/user_timeline.xml?page=3
		 */ 
		public function getFriendsTimeLine(since_id : String = null, since_date : String = null, max_id : Number = 0, count : Number = 0, page : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_STATUS;
            
			if (since_id)
                vars.since_id = since_id;
			if (since_date)
                vars.since = since_date;
			if (max_id > 0)
                vars.max_id = max_id;
			if (count > 0) {
				if (count > 200)
                    count = 200;
				vars.count = count;
			}
			if (page > 0)
                vars.page = page;
            
			setGETRequest(vars);
			request = URL_FRIENDS_TIMELINE;
			urlLoader.load(url);
		}

		/**
		 * Returns the 20 most recent statuses posted from the authenticating user. It's also possible to request 
		 * another user's timeline via the id parameter. This is the equivalent of the Web /archive page for your 
		 * own user, or the profile page for a third party.
		 * <p><b>This method optionally requires Authentication</b></p>
		 * @param id              Optional. Specifies the ID or screen name of the user for whom to return the friends_timeline.
		 * @param since_id        Optional. Returns only statuses with an ID greater than (that is, more recent than) the specified ID.
		 * @param since_date      Optional. Narrows the returned results to just those statuses created after the specified HTTP-formatted date, up to 24 hours old.
		 * @param max_id          Optional. Optional.  Returns only statuses with an ID less than (that is, older than) the specified ID.
		 * @param page            Optional. Provides paging. Ex. http://twitter.com/statuses/user_timeline.xml?page=3
		 */ 
		public function getUserTimeLine(id : String = null, since_id : String = null, since_date : String = null, max_id : Number = 0, page : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
            
			if (!id)
                checkCredentials();
            
			_returnType = RETURN_TYPE_STATUS;
            
			if (since_id)
                vars.since_id = since_id;
			if (since_date)
                vars.since = since_date;
			if (max_id > 0)
                vars.max_id = max_id;
			if (page > 0)
                vars.page = page;
            
			setGETRequest(vars);
			request = URL_USER_TIMELINE + ( (id) ? "/" + id + "." + DATA_FORMAT : "." + DATA_FORMAT  );
			urlLoader.load(url);
		}

		/**
		 * Returns the 20 most recent @replies (status updates prefixed with @username) for the authenticating user.
		 * <p><b>This method requires Authentication</b></p>
		 * @param since_id        Optional. Returns only statuses with an ID greater than (that is, more recent than) the specified ID.
		 * @param since_date      Optional. Narrows the returned results to just those statuses created after the specified HTTP-formatted date, up to 24 hours old.
		 * @param max_id          Optional. Returns only statuses with an ID less than (that is, older than) the specified ID.
		 * @param page            Optional. Provides paging. Ex. http://twitter.com/statuses/user_timeline.xml?page=3
		 */ 
		public function getMentions(since_id : String = null, since_date : String = null, max_id : Number = 0, page : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_STATUS;
            
			if (since_id)
                vars.since_id = since_id;
			if (since_date)
                vars.since = since_date;
			if (max_id > 0)
                vars.max_id = max_id;
			if (page > 0)
                vars.page = page;
                
			setGETRequest(vars);
			request = URL_MENTIONS;
			urlLoader.load(url);
		}

		/**
		 * <b><font color="#00AA00">NEW</font></b> - Returns the 20 most recent retweets posted by the authenticating user.
		 * Note: Retweets will not appear in the friends_timeline for backwards compatibility. If you want retweets included use getHomeTimeLine.
		 * <p><b>This method requires Authentication</b></p>
		 * @param since_id        Optional.  Returns only statuses with an ID greater than (that is, more recent than) the specified ID.
		 * @param max_id          Optional.  Returns only statuses with an ID less than (that is, older than) the specified ID.
		 * @param count           Optional. Specifies the number of statuses to retrieve. May not be greater than 200.
		 * @param page            Optional. Provides paging. Ex. http://twitter.com/statuses/user_timeline.xml?page=3
		 */ 
		public function getRetweetsByMe(since_id : String = null, max_id : Number = 0, count : Number = 0, page : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_STATUS;
            
			if (since_id)
                vars.since_id = since_id;
			if (max_id > 0)
                vars.max_id = max_id;
			if (count > 0) {
				if (count > 200)
                    count = 200;
				vars.count = count;
			}
			if (page > 0)
                vars.page = page;
            
			setGETRequest(vars);
			request = URL_RETWEETS_BY_ME;
			urlLoader.load(url);
		}

		/**
		 * <b><font color="#00AA00">NEW</font></b> - Returns the 20 most recent retweets posted by the authenticating user's friends.
		 * Note: Retweets will not appear in the friends_timeline for backwards compatibility. If you want retweets included use getHomeTimeLine.
		 * <p><b>This method requires Authentication</b></p>
		 * @param since_id        Optional.  Returns only statuses with an ID greater than (that is, more recent than) the specified ID.
		 * @param max_id          Optional.  Returns only statuses with an ID less than (that is, older than) the specified ID.
		 * @param count           Optional. Specifies the number of statuses to retrieve. May not be greater than 200.
		 * @param page            Optional. Provides paging. Ex. http://twitter.com/statuses/user_timeline.xml?page=3
		 */ 
		public function getRetweetsToMe(since_id : String = null, max_id : Number = 0, count : Number = 0, page : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_STATUS;
            
			if (since_id)
                vars.since_id = since_id;
			if (max_id > 0)
                vars.max_id = max_id;
			if (count > 0) {
				if (count > 200)
                    count = 200;
				vars.count = count;
			}
			if (page > 0)
                vars.page = page;
            
			setGETRequest(vars);
			request = URL_RETWEETS_TO_ME;
			urlLoader.load(url);
		}

		/**
		 * <b><font color="#00AA00">NEW</font></b> - Returns the 20 most recent tweets of the authenticated user that have been retweeted by others.
		 * Note: Retweets will not appear in the friends_timeline for backwards compatibility. If you want retweets included use getHomeTimeLine.
		 * <p><b>This method requires Authentication</b></p>
		 * @param since_id        Optional.  Returns only statuses with an ID greater than (that is, more recent than) the specified ID.
		 * @param max_id          Optional.  Returns only statuses with an ID less than (that is, older than) the specified ID.
		 * @param count           Optional. Specifies the number of statuses to retrieve. May not be greater than 200.
		 * @param page            Optional. Provides paging. Ex. http://twitter.com/statuses/user_timeline.xml?page=3
		 */ 
		public function getRetweetsOfMe(since_id : String = null, max_id : Number = 0, count : Number = 0, page : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_STATUS;
            
			if (since_id)
                vars.since_id = since_id;
			if (max_id > 0)
                vars.max_id = max_id;
			if (count > 0) {
				if (count > 200)
                    count = 200;
				vars.count = count;
			}
			if (page > 0)
                vars.page = page;
            
			setGETRequest(vars);
			request = URL_RETWEETS_OF_ME;
			urlLoader.load(url);
		}

		/**
		 * Returns a single status, specified by the id parameter below.  The status's author will be returned inline.
		 * @param id   Tweet ID
		 */
		public function getStatus(id : Number) : void {
			setGETRequest();
			_returnType = RETURN_TYPE_STATUS;
			request = URL_SINGLE_TWEET + String(id) + "." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * <b><font color="#00AA00">UPDATED</font></b> - Updates the authenticating user's status. 
		 * A status update with text identical to the authenticating user's current status will be ignored.
		 * <p><b>This method requires Authentication</b></p>
		 * @param status        Required. The text of your status update. Should not be more than 140 characters.
		 * @param inReplyTo     Optional. The ID of an existing status that the status to be posted is in reply to. Invalid/missing status IDs will be ignored.
		 * @param lat           Optional. The location's latitude that this tweet refers to. Note: The valid ranges for latitude is -90.0 to +90.0 (North is positive) inclusive.  This parameter will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding long parameter with this tweet.
		 * @param long          Optional. The location's longitude that this tweet refers to. Note: The valid ranges for longitude is -180.0 to +180.0 (East is positive) inclusive.  This parameter will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding lat parameter with this tweet.
		 */ 
		public function updateStatus(status : String, inReplyTo : Number = 0, lat : Number = 0, long : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_STATUS;
            
			vars.status = strEscape(status.substr(0, 140));
			if (inReplyTo != 0)
                vars.in_reply_to_status_id = inReplyTo;
			if (lat != 0)
                vars.lat = lat;
			if (long != 0)
                vars.long = long;
            
			setPOSTRequest(vars);
			request = URL_SEND_UPDATE;
			urlLoader.load(url);
		}

		/**
		 * Destroys the status specified by the required ID parameter.
		 * The authenticating user must be the author of the specified status.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id   Required. The ID of the status to destroy
		 */ 
		public function destroyStatus(id : Number) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_STATUS;
            
			vars.id = id;
			vars.format = DATA_FORMAT;
            
			setPOSTRequest(vars);
			request = URL_DESTROY_TWEET + id + "." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * <b><font color="#00AA00">NEW</font></b> - Retweets a tweet. 
		 * Requires the id parameter of the tweet you are retweeting. Returns the original tweet with retweet details embedded.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id    Required. The ID of the status to retweet
		 */ 
		public function retweetStatus(id : Number) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_STATUS;
            
			vars.id = id;
            
			setPOSTRequest(vars);
			request = URL_RETWEET + id + "." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * <b><font color="#00AA00">NEW</font></b> - Retweets a tweet. 
		 * Requires the id parameter of the tweet you are retweeting. Returns the original tweet with retweet details embedded.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id    Required. The ID of the status to retweet
		 * @param count Optional. Specifies the number of retweets to retrieve. May not be greater than 100.
		 */ 
		public function statusRetweets(id : Number, count : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_STATUS;
            
			if (count > 0) {
				if (count > 100)
                    count = 100;
				vars.count = count;
			}
            
			setGETRequest(vars);
			request = URL_RETWEETS + id + "." + DATA_FORMAT;
			urlLoader.load(url);
		}

		//----------------------------------
		//  User Methods
		//----------------------------------
        
		/**
		 * Returns up to 100 of the authenticating user's friends who have 
		 * most recently updated, each with current status inline. 
		 * It's also possible to request another user's recent friends list via the id parameter.
		 * <p><b>This method optionally requires Authentication</b></p>
		 * @param id      Optional. The ID or screen name of the user for whom to request a list of friends. If not supplied, you have to be authenticated.
		 * @param cursor    Optional. Breaks the results into pages. A single page contains 100 users. This is recommended for users who are following many users. Provide a value of  -1 to begin paging. Provide values as returned to in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
		 */ 
		public function getFriends(id : String = null, cursor : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
            
			if (!id)
                checkCredentials();
            
			_returnType = RETURN_TYPE_USER_INFO;
            
			if (cursor != 0)
                 vars.cursor = cursor;
            
			setGETRequest(vars);
			request = URL_FRIENDS + ( (id) ? "/" + id + "." + DATA_FORMAT : "." + DATA_FORMAT  );
			urlLoader.load(url);
		}

		/**
		 * Returns the authenticating user's followers, each with current status inline.  
		 * They are ordered by the order in which they joined Twitter (this is going to be changed).
		 * <p><b>This method optionally requires Authentication</b></p>
		 * @param id      Optional. The ID or screen name of the user for whom to request a list of followers. If not supplied, you need to be authenticated.
		 * @param cursor    Optional. Breaks the results into pages. A single page contains 100 users. This is recommended for users who are following many users. Provide a value of  -1 to begin paging. Provide values as returned to in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
		 */ 
		public function getFollowers(id : String = null, cursor : Number = 0) : void {
			var vars : URLVariables = new URLVariables();            
			if (!id)
                checkCredentials();
            
			if (cursor != 0)
                vars.cursor = cursor;
            
			setGETRequest(vars);
			_returnType = RETURN_TYPE_USER_INFO;
			request = URL_FOLLOWERS + ( (id) ? "/" + id + "." + DATA_FORMAT : "." + DATA_FORMAT  );
			urlLoader.load(url);
		}

		/**
		 * Returns extended information of a given user, specified by ID or screen name.  
		 * This information includes design settings, so third party developers can theme 
		 * their widgets according to a given user's preferences. You must be properly 
		 * authenticated to request the page of a protected user.
		 * @param id       The ID or screen name of a user.
		 */ 
		public function getUserDetails(id : String) : void {
			setGETRequest();
			_returnType = RETURN_TYPE_USER_INFO;
			request = URL_USER_DETAILS + id + "." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * <b><font color="#00AA00">NEW</font></b> - Run a search for users similar to Find People button on Twitter.com; the same results returned by people search on Twitter.com will be returned by using this API.
		 * It is only possible to retrieve the first 1000 matches from this API. This method does not support OAuth yet.
		 * <p><b>This method requires Authentication</b></p>
		 * @param query     Required. The query to run against people search. For example "Sandro Ducceschi"
		 * @param per_page  Optional. Specifies the number of statuses to retrieve. May not be greater than 20. 
		 * @param page      Optional. Specifies the page of results to retrieve.
		 */ 
		public function searchUser(query : String, per_page : Number = 20, page : Number = 0) : void {
			var arguments : Array = [];
			var vars : URLVariables = new URLVariables();
			checkCredentials();
            
			vars.q = strEscape(query);
            
			if (per_page < 20)
                vars.per_page = per_page;
			if (page > 0)
                vars.page = page
            
			_returnType = RETURN_TYPE_USER_INFO;
			setGETRequest(vars);
			request = URL_USER_SEARCH;
			urlLoader.load(url);
		}

		//----------------------------------
		//  List Methods
		//----------------------------------
        
		/**
		 * <b><font color="#00AA00">UPDATED</font></b> - Creates a new list for the authenticated user. Accounts are limited to 20 lists. 
		 * <p><b>This method requires Authentication</b></p>
		 * @param name          The name of the list you are creating.
		 * @param isPublic      Optional. Whether your list is public or private. By default it is public.
		 * @param description   Optional. The description of the list you are creating.
		 */ 
		public function createList(name : String, isPublic : Boolean = true, description : String = null) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
            
			vars.name = strEscape(name);
			if(isPublic)
                vars.mode = "public";
            else
                vars.mode = "private";
            
			if (description)
                vars.description = strEscape(description);
            
			_returnType = RETURN_TYPE_LIST;
			setPOSTRequest(vars);
			request = "/" + _username + "/lists." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * <b><font color="#00AA00">UPDATED</font></b> - Updates the specified list. 
		 * <p><b>This method requires Authentication</b></p>
		 * @param slug          The slug of the list you would like to change
		 * @param name          Optional. What you'd like to change the lists name to.
		 * @param isPublic      Optional. Whether your list is public or private. Lists are public by default
		 * @param description   Optional. The description of the list you are upating.
		 */ 
		public function updateList(slug : String, name : String = null, isPublic : Boolean = true, description : String = null) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_LIST;
            
			if (name)
                vars.name = strEscape(name);
			if(isPublic)
                vars.mode = "public";
            else
                vars.mode = "private";
            
			if (description)
                vars.description = strEscape(description);
            
			setPOSTRequest(vars);
			request = "/" + _username + "/lists/" + slug + "." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * Deletes the specified list. Must be owned by the authenticated user.  
		 * <p><b>This method requires Authentication</b></p>
		 * @param id    Required. id or slug of the list you want to delete. 
		 */ 
		public function deleteList(id : String) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_LIST;
            
			vars._method = "DELETE";
			vars.id = strEscape(id);
            
			setPOSTRequest(vars);
			request = "/" + _username + "/lists/" + id + "." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * List the lists of the specified user. Private lists will be included if the authenticated users is the same as the user who'se lists are being returned.
		 * <p><b>This method requires Authentication</b></p>
		 * @param listUser      The user who's lists you would like returned.
		 * @param cursor        Optional. Breaks the results into pages. A single page contains 20 lists. Provide a value of -1 to begin paging. Provide values as returned to in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
		 */
		public function getLists(listUser : String = null, cursor : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_LIST;
			if (cursor != 0)
                vars.cursor = cursor;
			setGETRequest(vars);
			request = "/" + ((listUser) ? listUser : _username) + "/lists." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * Show the specified list. Private lists will only be shown if the authenticated user owns the specified list.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id            Required. id or slug of the list you want to retrieve.  
		 * @param listUser      Optional. If you don't own the list, specify the user who the list belongs to.
		 */ 
		public function getList(id : String, listUser : String = null) : void {
			var arguments : Array = [];
			checkCredentials();
			setGETRequest();
			_returnType = RETURN_TYPE_LIST;
			request = "/" + ((listUser) ? listUser : _username) + "/lists/" + id + "." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * Show tweet timeline for members of the specified list.
		 * @param slug          slug of the desired list
		 * @param listUser      Optional.  If defined the desired list from the defined user is retrieved. Else the list is supposed to be of the authenticated user.
		 * @param since_id      Optional.  Returns only statuses with an ID greater than (that is, more recent than) the specified ID.  
		 * @param max_id        Optional.  Returns only statuses with an ID less than (that is, older than) or equal to the specified ID. 
		 * @param perPage       Optional.  Specifies the number of statuses to retrieve. May not be greater than 200.  
		 * @param page          Optional.  Specifies the page of results to retrieve. Note: there are <a href="http://apiwiki.twitter.com/Things-Every-Developer-Should-Know#6Therearepaginationlimits">pagination limits.</a>
		 */ 
		public function getListStatuses(slug : String, listUser : String = null, since_id : String = null, max_id : Number = 0, perPage : Number = 0, page : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			_returnType = RETURN_TYPE_STATUS;
            
			if (since_id)
                vars.since_id = since_id;
			if (max_id > 0)
                vars.max_id = max_id;
			if (perPage > 0)
                vars.per_page = perPage;
			if (page > 0)
                vars.page = page;
            
			if (!listUser && !_username)
                throw new Error("No authenticated user or user parameter has been given .. method can't be called!"); 
            
			setGETRequest(vars);
			request = "/" + ((listUser) ? listUser : _username) + "/lists/" + slug + "/statuses." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * List the lists the specified user has been added to. 
		 * <p><b>This method requires Authentication</b></p>
		 * @param listUser  Optional.  The user who's list memberships you would like to retrieve. If not supplied it will retrieve the memberships of the authenticated user.
		 * @param cursor    Optional. Breaks the results into pages. A single page contains 20 lists. Provide a value of -1 to begin paging. Provide values as returned to in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
		 */ 
		public function getListMemberships(listUser : String = null, cursor : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_LIST;
            
			if (cursor != 0)
                vars.cursor = cursor;
            
			setGETRequest(vars);
			request = "/" + ((listUser) ? listUser : _username) + "/lists/memberships." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * List the lists the specified user follows.
		 * <p><b>This method requires Authentication</b></p>
		 * @param listUser      Optional.  The user who's list subscriptions you would like to retrieve. If not supplied it will retrieve the subscriptions of the authenticated user.
		 * @param cursor        Optional. Breaks the results into pages. A single page contains 20 lists. Provide a value of -1 to begin paging. Provide values as returned to in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
		 */
		public function getListSubscriptions(listUser : String = null, cursor : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_LIST;
            
			if (cursor != 0)
                vars.cursor = cursor;
            
			setGETRequest(vars);
			request = "/" + ((listUser) ? listUser : _username) + "/lists/subscriptions." + DATA_FORMAT;
			urlLoader.load(url);
		}

		//----------------------------------
		//  List Members Methods
		//----------------------------------
        
		/**
		 * Returns the members of the specified list.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id        The id or slug of the list.
		 * @param listUser  Optional.  The user who's list members you would like to retrieve. If not supplied it will retrieve the list members of the authenticated user.
		 * @param cursor    Optional.  Breaks the results into pages. A single page contains 20 lists. Provide a value of -1 to begin paging. Provide values as returned to in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
		 */ 
		public function getListMembers(id : String, listUser : String = null, cursor : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_USER_INFO;
            
			if (cursor != 0)
                vars.cursor = cursor;
            
			setGETRequest(vars);
			request = "/" + ((listUser) ? listUser : _username) + "/" + id + "/members." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * Add a member to a list. The authenticated user must own the list to be able to add members to it. Lists are limited to having 500 members. 
		 * <p><b>This method requires Authentication</b></p>
		 * @param id        The id or slug of the list.
		 * @param userId    The id of the user to add as a member of the list.
		 */ 
		public function addListMember(id : String, userId : Number) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_LIST;
			vars.id = userId;
			setPOSTRequest(vars);
			request = "/" + _username + "/" + id + "/members." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * Removes the specified member from the list. The authenticated user must be the list's owner to remove members from the list.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id        The id or slug of the list.
		 * @param userId    The id of the user to remove as a member of the list.
		 */ 
		public function removeListMember(id : String, userId : Number) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_LIST;
			vars.id = userId;
			vars._method = "DELETE";
			setPOSTRequest(vars);
			request = "/" + _username + "/" + id + "/members." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * Check if a user is a member of the specified list.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id        The id or slug of the list.
		 * @param userId    The id of the user who you want to know is a member or not of the specified list.
		 */ 
		public function hasListMember(id : String, userId : Number) : void {
			var arguments : Array = [];
			checkCredentials();
			setGETRequest();
			_returnType = RETURN_TYPE_USER_INFO;
			request = "/" + _username + "/" + id + "/members/" + userId + "." + DATA_FORMAT;
			urlLoader.load(url);
		}

		//----------------------------------
		//  List Subscribers Methods
		//----------------------------------
        
		/**
		 * Returns the subscribers of the specified list.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id        The id or slug of the list.
		 * @param listUser  Optional.  The user who's list subscribers you would like to retrieve. If not supplied it will retrieve the list subscribers of the authenticated user.
		 * @param cursor    Optional.  Breaks the results into pages. A single page contains 20 lists. Provide a value of -1 to begin paging. Provide values as returned to in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
		 */ 
		public function getListSubscribers(id : String, listUser : String = null, cursor : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
            
			if (cursor != 0)
                vars.cursor = cursor;
            
			_returnType = RETURN_TYPE_USER_INFO;
			setGETRequest(vars);
			request = "/" + ((listUser) ? listUser : _username) + "/" + id + "/subscribers." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * Make the authenticated user follow the specified list.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id        The id or slug of the list.
		 * @param listUser  The user who's list you want to subscribe to.
		 */ 
		public function addListSubscription(id : String, listUser : String) : void {
			checkCredentials();
			_returnType = RETURN_TYPE_LIST;
			setPOSTRequest();
			request = "/" + listUser + "/" + id + "/subscribers." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * Unsubscribes the authenticated user form the specified list.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id        The id or slug of the list.
		 * @param listUser  The user who's list you want to unsubscribe from.
		 */ 
		public function removeListSubscription(id : String, listUser : String) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_LIST;
			vars._method = "DELETE";
			setPOSTRequest(vars);
			request = "/" + listUser + "/" + id + "/subscribers." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * Check if the specified user is a subscriber of the specified list.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id        The id or slug of the list.
		 * @param listUser  The user who's list you want to check against.
		 * @param userId    he id of the user who you want to know is a subcriber or not of the specified list.
		 */ 
		public function hasListSubscription(id : String, listUser : String, userId : Number) : void {
			var arguments : Array = [];
			checkCredentials();
			setGETRequest();
			_returnType = RETURN_TYPE_USER_INFO;
			request = "/" + listUser + "/" + id + "/subscribers/" + userId + "." + DATA_FORMAT;
			urlLoader.load(url);
		}

		//----------------------------------
		//  Direct Message Methods
		//----------------------------------
        
		/**
		 * Returns a list of the 20 most recent direct messages sent to the authenticating user.
		 * The XML includes detailed information about the sending and recipient users.
		 * <p><b>This method requires Authentication</b></p>
		 * @param since_id      Optional. Returns only direct messages with an ID greater than (that is, more recent than) the specified ID. 
		 * @param since_date    Optional. Narrows the resulting list of direct messages to just those sent after the specified HTTP-formatted date, up to 24 hours old.
		 * @param max_id          Optional. Returns only statuses with an ID less than (that is, older than) the specified ID.
		 * @param page          Optional. Retrieves the 20 next most recent direct messages.
		 */ 
		public function getReceivedDirectMessages(since_id : String = null, since_date : String = null, max_id : Number = 0, page : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_DIRECT_MESSAGE;
            
			if (since_id)
                vars.since_id = since_id;
			if (since_date)
                vars.since = since_date;
			if (max_id > 0)
                vars.max_id = max_id;
			if (page > 0)
                vars.page = page;
            
			setGETRequest(vars);
			request = URL_RECEIVED_DIRECT_MESSAGES;
			urlLoader.load(url);
		}

		/**
		 * Returns a list of the 20 most recent direct messages sent by the authenticating user.
		 * The Results includes detailed information about the sending and recipient users.
		 * <p><b>This method requires Authentication</b></p>
		 * @param since_id      Optional. Returns only direct messages with an ID greater than (that is, more recent than) the specified ID. 
		 * @param since_date    Optional. Narrows the resulting list of direct messages to just those sent after the specified HTTP-formatted date, up to 24 hours old.
		 * @param max_id          Optional. Returns only statuses with an ID less than (that is, older than) the specified ID.
		 * @param page          Optional. Retrieves the 20 next most recent direct messages.
		 */ 
		public function getSentDirectMessages(since_id : String = null, since_date : String = null, max_id : Number = 0, page : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_DIRECT_MESSAGE;
            
			if (since_id)
                vars.since_id = since_id;
			if (since_date)
                vars.since = since_date;
			if (max_id > 0)
                vars.max_id = max_id;
			if (page > 0)
                vars.page = page;
            
			setGETRequest(vars);
			request = URL_SENT_DIRECT_MESSAGES;
			urlLoader.load(url);
		}

		/**
		 * Returns a single Direct Message, specified by the id parameter below.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id   Tweet ID
		 */ 
		public function getDirectMessage(id : Number) : void {
			checkCredentials();
			setGETRequest();
			_returnType = RETURN_TYPE_DIRECT_MESSAGE;
			request = URL_SINGLE_DIRECT_MESSAGE + String(id) + "." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * Sends a new direct message to the specified user from the authenticating user.
		 * <p><b>This method requires Authentication</b></p>
		 * @param text   Required. The text of your direct message, keep it under 140 characters or else it will be cut! 
		 * @param user   Required. The ID or screen name of the recipient user.
		 */
		public function sendDirectMessage(text : String, user : String) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_DIRECT_MESSAGE;
			vars.user = user;
			vars.text = strEscape(text.substr(0, 140));

			setPOSTRequest(vars);
			request = URL_SEND_NEW_DIRECT_MESSAGE;
			urlLoader.load(url);
		} 

		/**
		 * Destroys the direct message specified in the required ID parameter.  
		 * The authenticating user must be the recipient of the specified direct message.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id   Required. The ID of the direct message to destroy
		 */ 
		public function destroyDirectMessage(id : Number) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_DIRECT_MESSAGE;
            
			vars.id = id;
			vars.format = DATA_FORMAT;
            
			setPOSTRequest(vars);
			request = URL_DESTROY_DIRECT_MESSAGE;
			urlLoader.load(url);
		}

		//----------------------------------
		//  Friendship Methods
		//----------------------------------
        
		/**
		 * Befriends the user specified in the ID parameter as the authenticating user.
		 * Returns the befriended user in the requested format when successful.  
		 * Returns a string describing the failure condition when unsuccessful.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id         The ID or screen name of the user to befriend
		 * @param follow     Enable notifications for the target user in addition to becoming friends. Default is true.
		 */ 
		public function createFriendship(id : String, follow : Boolean = true) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_USER_INFO;
            
			vars.id = id;
			vars.follow = follow;
			vars.format = DATA_FORMAT;
            
			setPOSTRequest(vars);
			request = URL_CREATE_FRIENDSHIP;
			urlLoader.load(url);
		}

		/**
		 * Discontinues friendship with the user specified in the ID parameter as the authenticating user.  
		 * Returns the un-friended user in the requested format when successful.  
		 * Returns a string describing the failure condition when unsuccessful.  
		 * <p><b>This method requires Authentication</b></p>
		 * @param id    The ID or screen name of the user with whom to discontinue friendship.
		 */ 
		public function destroyFriendship(id : String) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_USER_INFO;
            
			vars.id = id;
			vars.format = DATA_FORMAT;
            
			setPOSTRequest(vars);
			request = URL_DESTROY_FRIENDSHIP;
			urlLoader.load(url);
		}

		/**
		 * Tests if a friendship exists between two users.
		 * @param userA      Required.  The ID or screen_name of the first user to test friendship for.
		 * @param userB      Required.  The ID or screen_name of the second user to test friendship for.
		 */ 
		public function hasFriendship(userA : String, userB : String) : void {
			var vars : URLVariables = new URLVariables();
			_returnType = RETURN_TYPE_BOOLEAN;
            
			vars.user_a = userA;
			vars.user_b = userB;
            
			setGETRequest(vars);
			request = URL_FRIENDSHIP_EXISTS;
			urlLoader.load(url);
		}

		/**
		 * Returns detailed information about the relationship between two users.
		 * <p><b>This method optionally requires Authentication</b></p>
		 * @param targetId      Required. The user_id of the target user.
		 * @param sourceId      Optional. The user_id of the source user. If not defined you have to be authenticated to use this method.
		 */
		public function showFriendshipById(targetId : String, sourceId : String = null) : void {
			var vars : URLVariables = new URLVariables();
			_returnType = RETURN_TYPE_RELATIONSHIP;
            
			vars.target_id = targetId;
			if (!sourceId)
                checkCredentials();
            else
                vars.source_id = sourceId;
            
			setGETRequest(vars);
			request = URL_FRIENDSHIP_SHOW;
			urlLoader.load(url);
		}

		/**
		 * Returns detailed information about the relationship between two users.
		 * <p><b>This method optionally requires Authentication</b></p>
		 * @param targetName      Required. The screen_name of the target user.
		 * @param sourceName      Optional. The screen_name of the source user. If not defined you have to be authenticated to use this method.
		 */ 
		public function showFriendshipByName(targetName : String, sourceName : String = null) : void {
			var vars : URLVariables = new URLVariables();
			_returnType = RETURN_TYPE_RELATIONSHIP;
            
			vars.target_screen_name = strEscape(targetName);
			if (!sourceName)
                checkCredentials();
            else
                vars.source_screen_name = strEscape(sourceName);
            
			setGETRequest(vars);
			request = URL_FRIENDSHIP_SHOW;
			urlLoader.load(url);
		}

		//----------------------------------
		//  Social Graph Methods
		//----------------------------------
        
		/**
		 * Returns an array of numeric IDs for every user the specified user is following.
		 * It's also possible to request another user's friends via the id parameter.
		 * <p><b>This method optionally requires Authentication</b></p>
		 * @param id      Optional. The ID or screen name of the user for whom to request a list of friends.
		 * @param cursor    Optional. Breaks the results into pages. A single page contains 5000 ids. This is recommended for users with large ID lists. Provide a value of -1 to begin paging. Provide values as returned to in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
		 */ 
		public function getFriendIds(id : String = null, cursor : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
            
			if (!id)
                checkCredentials();
			if (cursor != 0)
                vars.cursor = cursor;
            
			_returnType = RETURN_TYPE_IDS;
			setGETRequest(vars);
			request = URL_SOCIAL_GRAPH_FRIEND_IDS + ( (id) ? "/" + id + "." + DATA_FORMAT : "." + DATA_FORMAT );
			urlLoader.load(url);
		}

		/**
		 * Returns an array of numeric IDs for every user following the specified user.
		 * It's also possible to request another user's followers via the id parameter.
		 * <p><b>This method optionally requires Authentication</b></p>
		 * @param id      Optional. The ID or screen name of the user for whom to request a list of friends.
		 * @param cursor    Optional. Breaks the results into pages. A single page contains 5000 ids. This is recommended for users with large ID lists. Provide a value of -1 to begin paging. Provide values as returned to in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
		 */ 
		public function getFollowerIds(id : String = null, cursor : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
            
			if (!id)
                checkCredentials();
			if (cursor != 0)
                vars.cursor = cursor;
            
			_returnType = RETURN_TYPE_IDS;
			setGETRequest(vars);
			request = URL_SOCIAL_GRAPH_FOLLOWER_IDS + ( (id) ? "/" + id + "." + DATA_FORMAT : "." + DATA_FORMAT );
			urlLoader.load(url);
		}

		//----------------------------------
		//  Spam Reporting Methods
		//----------------------------------
        
		/**
		 * The user specified in the id is blocked by the authenticated user and reported as a spammer.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id    The ID or screen_name of the user you want to report as a spammer. 
		 */ 
		public function reportSpammer(id : String) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_USER_INFO;
			vars.id = id;
			setPOSTRequest(vars);
			request = URL_REPORT_SPAM;
			urlLoader.load(url);
		}

		//----------------------------------
		//  Saved Searches Methods
		//----------------------------------
		
		/**
		 * Returns the authenticated user's saved search queries.
		 * <p><b>This method requires Authentication</b></p>
		 */ 
		public function getSavedSearches() : void {
			checkCredentials();
			setGETRequest();
			_returnType = RETURN_TYPE_SAVED_SEARCHES;
			request = URL_SAVED_SEARCHES;
			urlLoader.load(url);
		}

		/**
		 * Retrieve the data for a saved search owned by the authenticating user specified by the given id.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id     The id of the saved search to be retrieved. 
		 */ 
		public function getSavedSearch(id : Number) : void {
			checkCredentials();
			setGETRequest();
			_returnType = RETURN_TYPE_SAVED_SEARCHES;
			request = URL_RETRIEVE_SAVED_SEARCH + id + "." + DATA_FORMAT;
			urlLoader.load(url);
		}

		/**
		 * Creates a saved search for the authenticated user.
		 * <p><b>This method requires Authentication</b></p>
		 * @param query   The query of the search the user would like to save.
		 */ 
		public function createSavedSearch(query : String) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_SAVED_SEARCHES;
			vars.query = query;
			setPOSTRequest(vars);
			request = URL_CREATE_SAVED_SEARCH;
			urlLoader.load(url);
		}

		/**
		 * Destroys a saved search for the authenticated user. The search specified by id must be owned by the authenticating user.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id      The id of the saved search to be deleted. 
		 */ 
		public function destroySavedSearch(id : Number) : void {
			checkCredentials();
			_returnType = RETURN_TYPE_SAVED_SEARCHES;
			setPOSTRequest();
			request = URL_DESTROY_SAVED_SEARCH + id + "." + DATA_FORMAT;
			urlLoader.load(url);
		}

		//----------------------------------
		//  Account Methods
		//----------------------------------
		
		/**
		 * Returns the remaining number of API requests available to the requesting user 
		 * before the API limit is reached for the current hour. 
		 * Calls to rate_limit_status do not count against the rate limit.  
		 */ 
		public function getRateLimitStatus() : void {
			_returnType = RETURN_TYPE_HASH;
			setGETRequest();
			request = URL_RATELIMIT_STATUS;
			urlLoader.load(url);
		}

		/**
		 * Sets values that users are able to set under the "Account" tab of their settings page. 
		 * Only the parameters specified will be updated
		 * <p><b>This method requires Authentication</b></p>
		 * @param name            Optional. Maximum of 40 characters.
		 * @param url             Optional. Maximum of 100 characters. Will be prepended with "http://" if not present.
		 * @param location        Optional. Maximum of 30 characters. The contents are not normalized or geocoded in any way.
		 * @param description     Optional. Maximum of 160 characters.
		 */ 
		public function updateProfile(name : String = null, url : String = null, location : String = null, description : String = null) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_USER_INFO;
		    
			if (name)
		        vars.name = name.substr(0, 40);
			if (url)
		        vars.url = url.substr(0, 100);
			if (location)
		        vars.location = location.substr(0, 30);
			if (description)
		        vars.description = description.substr(0, 160);

			setPOSTRequest(vars);
			request = URL_UPDATE_PROFILE;
			urlLoader.load(this.url);
		}

		/**
		 * Updates the authenticating user's profile image. 
		 * Keep in mind that the image must be a valid GIF, JPG, or PNG image of less than 
		 * 700 kilobytes in size. Images with width larger than 500 pixels will be scaled down. 
		 * <p><b>This method requires Authentication</b></p>
		 * <p><b>NOTE:</b> This method only works in conjunction with the TweetrProxy.</p>
		 * @param fileReference     A FileReference instance containing a selected image
		 */ 
		public function updateProfileImage(fileReference : FileReference) : void {
			checkCredentials();
			_returnType = RETURN_TYPE_USER_INFO;
			fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, handleFileReferenceUploadComplete);
			request = URL_UPDATE_PROFILE_IMAGE;
			setPOSTRequest();
			fileReference.upload(url, "image");
		}

		/**
		 * Updates the authenticating user's profile background image.
		 * Keep in mind that the image must be a valid GIF, JPG, or PNG image of less than 
		 * 800 kilobytes in size. Images with width larger than 2048 pixels will be forceably scaled down.  
		 * <p><b>This method requires Authentication</b></p>
		 * <p><b>NOTE:</b> This method only works in conjunction with the TweetrProxy.</p>
		 * @param fileReference     A FileReference instance containing a selected image
		 * @param tile              Optional. If set to true the background image will be displayed tiled. The image will not be tiled otherwise.
		 */ 
		public function updateProfileBackgroundImage(fileReference : FileReference, tile : Boolean = false) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_USER_INFO;
			fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, handleFileReferenceUploadComplete);
			if (tile)
                vars.tile = "true";
			setPOSTRequest();
			request = URL_UPDATE_PROFILE_BG_IMAGE;
			fileReference.upload(url, "image");
		}

		/**
		 * Sets one or more hex values that control the color scheme of the authenticating user's profile page on twitter.com.
		 * <p><b>This method requires Authentication</b></p>
		 * @param backgroundColor   A valid hexidecimal value, may be either three or six characters (ex: fff or AA0000).
		 * @param textColor         A valid hexidecimal value, may be either three or six characters (ex: fff or AA0000).
		 * @param linkColor         A valid hexidecimal value, may be either three or six characters (ex: fff or AA0000).
		 * @param fillColor         A valid hexidecimal value, may be either three or six characters (ex: fff or AA0000).
		 * @param borderColor       A valid hexidecimal value, may be either three or six characters (ex: fff or AA0000).
		 */ 
		public function updateProfileColors(backgroundColor : String = null, textColor : String = null, linkColor : String = null, fillColor : String = null, borderColor : String = null) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_USER_INFO;
            
			if (backgroundColor)
                vars.profile_background_color = backgroundColor;
			if (textColor)
                vars.profile_text_color = textColor;
			if (linkColor)
                vars.profile_link_color = linkColor;
			if (fillColor)
                vars.profile_sidebar_fill_color = fillColor;
			if (borderColor)
                vars.profile_sidebar_border_color = borderColor;
            
			setPOSTRequest(vars);
			request = URL_UPDATE_PROFILE_COLORS;
			urlLoader.load(url);
		}

		/**
		 * Returns a representation of the requesting user if authentication was successful. Else return a hash error message if not.  
		 * Use this method to test if supplied user credentials are valid.
		 * <p><b>This method requires Authentication</b></p>
		 */ 
		public function verifyCredentials() : void {
			checkCredentials();
			_returnType = RETURN_TYPE_USER_INFO;
			setGETRequest();
			request = URL_VERIFY_CREDENTIALS;
			urlLoader.load(url);   
		}

		/**
		 * Ends the session of the authenticating user. and Returns a HashData object with the response.
		 * <p><b>This method requires Authentication</b></p>
		 */ 
		public function endSession() : void {
			checkCredentials();
			_returnType = RETURN_TYPE_HASH;
			setPOSTRequest();
			request = URL_END_SESSION;
			urlLoader.load(url);
		}

		//----------------------------------
		//  Favorite Methods
		//----------------------------------
		
		/**
		 * Returns the 20 most recent favorite statuses for the authenticating user or user specified by the ID parameter in the requested format. 
		 * <p><b>This method requires Authentication</b></p>
		 * @param id      Optional. The ID or screen name of the user for whom to request a list of favorite statuses
		 * @param page    Optional. Retrieves the 20 next most recent favorite statuses.
		 */
		public function getFavorites(id : String = null, page : Number = 0) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
            
			if (page > 0)
                vars.page = page;
            
			_returnType = RETURN_TYPE_STATUS;
			setGETRequest(vars);
			request = URL_RETRIEVE_FAVORITES + ( (id) ? "/" + id + "." + DATA_FORMAT : "." + DATA_FORMAT  );
			urlLoader.load(url);   
		}

		/**
		 * Favorites the status specified in the ID parameter as the authenticating user.  
		 * Returns the favorite status when successful.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id    Required.  The ID of the status to favorite.
		 */
		public function createFavorite(id : Number) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_STATUS;
		    
			vars.id = id;
			vars.format = DATA_FORMAT;
		    
			setPOSTRequest(vars);
			request = URL_CREATE_FAVORITE;
			urlLoader.load(url);   
		}

		/**
		 * Un-favorites the status specified in the ID parameter as the authenticating user.  
		 * Returns the un-favorited status when successful.  
		 * <p><b>This method requires Authentication</b></p>
		 * @param id   Required.  The ID of the status to un-favorite.
		 */ 
		public function destroyFavorite(id : Number) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_STATUS;
		    
			vars.id = id;
			vars.format = DATA_FORMAT;
		    
			setPOSTRequest(vars);
			request = URL_DESTROY_FAVORITE;
			urlLoader.load(url);   
		}

		//----------------------------------
		//  Notification Methods
		//----------------------------------
		
		/**
		 * Enables notifications for updates from the specified user to the authenticating user.  Returns the specified user when successful.
		 * NOTE: The Notification Methods require the authenticated user to already be friends with the specified user otherwise 
		 * a failed event will be fired.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id    Required.  The ID or screen name of the user to follow.
		 */ 
		public function followUser(id : String) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_USER_INFO;
		    
			vars.id = id;
			vars.format = DATA_FORMAT;
		    
			setPOSTRequest(vars);
			request = URL_FOLLOW_USER;
			urlLoader.load(url);
		}

		/**
		 * Disables notifications for updates from the specified user to the authenticating user.  Returns the specified user when successful.
		 * NOTE: The Notification Methods require the authenticated user to already be friends with the specified user otherwise 
		 * a failed event will be fired.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id    Required.  The ID or screen name of the user to leave
		 */ 
		public function unfollowUser(id : String) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_USER_INFO;
		    
			vars.id = id;
			vars.format = DATA_FORMAT;
		    
			setPOSTRequest(vars);
			request = URL_UNFOLLOW_USER;
			urlLoader.load(url);
		}

		//----------------------------------
		//  Block Methods
		//----------------------------------
		
		/**
		 * Blocks the user specified in the ID parameter as the authenticating user.  
		 * Returns the blocked user in the requested format when successful.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id   Required.  The ID or screen_name of the user to block.
		 */ 
		public function blockUser(id : String) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_USER_INFO;
		    
			vars.id = id;
			vars.format = DATA_FORMAT;
		    
			setPOSTRequest(vars);
			request = URL_BLOCK_USER;
			urlLoader.load(url);
		}

		/**
		 * Un-blocks the user specified in the ID parameter as the authenticating user. 
		 * Returns the un-blocked user in the requested format when successful.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id   Required.  The ID or screen_name of the user to un-block.
		 */
		public function unblockUser(id : String) : void {
			var vars : URLVariables = new URLVariables();
			checkCredentials();
			_returnType = RETURN_TYPE_USER_INFO;
		    
			vars.id = id;
			vars.format = DATA_FORMAT;
		    
			setPOSTRequest(vars);
			request = URL_UNBLOCK_USER;
			urlLoader.load(url);
		}

		/**
		 * Returns if the authenticating user is blocking a target user. Will return the blocked user's object if a block exists, and an error hash object otherwise.
		 * <p><b>This method requires Authentication</b></p>
		 * @param id    The ID or screen_name of the potentially blocked user.
		 */ 
		public function blockExists(id : String) : void {
			checkCredentials();
			setGETRequest();
			_returnType = RETURN_TYPE_USER_INFO;
            
			request = URL_BLOCK_EXISTS + id + DATA_FORMAT;
			urlLoader.load(url);   
		}

		/**
		 * Returns an array of user objects that the authenticated user is blocking.
		 * <p><b>This method requires Authentication</b></p>
		 */ 
		public function getBlocks() : void {
			checkCredentials();
			setGETRequest();
			_returnType = RETURN_TYPE_USER_INFO;
            
			request = URL_BLOCKS;
			urlLoader.load(url);
		}

		/**
		 * Returns an array of numeric user ids the authenticating user is blocking.
		 * <p><b>This method requires Authentication</b></p>
		 */ 
		public function getBlockIds() : void {
			checkCredentials();
			setGETRequest();
			_returnType = RETURN_TYPE_IDS;
			request = URL_BLOCK_IDS;
			urlLoader.load(url);
		}

		//----------------------------------
		//  Twitter Search Methods
		//----------------------------------
		
		/**
		 * Returns tweets that match a specified query.  You can use a variety of search operators in your query. For a list
		 * of available operators check out <link>http://search.twitter.com/operators</link>
		 * @param searchString      Your query string
		 * @param lang              Optional. Restricts tweets to the given language given by an ISO 639-1 code. (en,de,it,fr .. )
		 * @param numTweets         Optional. The number of tweets to return per page, up to a max of 100.
		 * @param page              Optional. The page number (starting at 1) to return, up to a max of roughly 1500 results ((based on numTweets * page).
		 * @param since_id          Optional. Returns tweets with status ids greater than the given id.
		 * @param geocode           Optional. Returns tweets by users located within a given radius of the given latitude/longitude, where the user's location is taken from their Twitter profile. The parameter value is specified by "latitide,longitude,radius", where radius units must be specified as either "mi" (miles) or "km" (kilometers). Note that you cannot use the near operator via the API to geocode arbitrary locations; however you can use this geocode parameter to search near geocodes directly. Example: http://search.twitter.com/search.atom?geocode=40.757929%2C-73.985506%2C25km

		 */ 
		public function search(searchString : String, lang : String = null, numTweets : Number = 15, page : Number = 1, since_id : Number = 0, geocode : String = null) : void {
			var urlRequest : URLRequest = new URLRequest(URL_TWITTER_SEARCH_OVERRIDE ? URL_TWITTER_SEARCH_OVERRIDE : URL_TWITTER_SEARCH);
			
			var vars : URLVariables = new URLVariables();
            
			if(searchString.indexOf(" ") != -1)
                vars.phrase = searchString;
            else
                vars.q = searchString;
		    
			if (lang)
                vars.lang = lang;
			if (numTweets != 15)
                vars.rpp = numTweets;
			if (page != 1)
                vars.page = page;
			if (since_id != 0)
                vars.since_id = since_id;
			if (geocode)
                vars.geocode = geocode;
		    
			_returnType = RETURN_TYPE_SEARCH_RESULTS;
			urlRequest.data = vars;
			urlRequest.method = URLRequestMethod.GET;
			urlLoader.load(urlRequest);
		}

		/**
		 * Returns the top ten queries that are currently trending on Twitter.
		 */
		public function trends() : void {
			_returnType = RETURN_TYPE_TRENDS_RESULTS;
			setGETRequest();
			urlLoader.load(new URLRequest(URL_TWITTER_TRENDS));
		}

		/**
		 * Returns the current top 10 trending topics on Twitter. 
		 */ 
		public function currentTrends() : void {
			_returnType = RETURN_TYPE_TRENDS_RESULTS;
			setGETRequest();
			urlLoader.load(new URLRequest(URL_TWITTER_TRENDS_CURRENT));
		}

		/**
		 * Returns the top 20 trending topics for each hour in a given day.
		 */ 
		public function dailyTrends() : void {
			_returnType = RETURN_TYPE_TRENDS_RESULTS;
			setGETRequest();
			urlLoader.load(new URLRequest(URL_TWITTER_TRENDS_DAILY));
		}

		/**
		 * Returns the top 30 trending topics for each day in a given week.
		 */ 
		public function weeklyTrends() : void {
			_returnType = RETURN_TYPE_TRENDS_RESULTS;
			setGETRequest();
			urlLoader.load(new URLRequest(URL_TWITTER_TRENDS_WEEKLY));
		}

		/**
		 * Completely destroys the instance and frees all objects for the garbage
		 * collector by setting their references to null.
		 */
		public function destroy() : void {
			urlLoader.removeEventListener(Event.COMPLETE, handleTweetsLoaded);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, handleTweetsLoadingFailed);
			urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
			urlLoader = null;
			urlRequest = null;
			request = null;
			_username = null;
			_password = null;
			_returnType = null;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * @private
		 * Parse the raw data response from twitter and act accordingly to it.
		 */ 
		private function evalRawResponse(data : Object) : void {
			var returnArray : Array = responseParser(data);
			var xml : XML = XML(data);
			var cursor : CursorData = DataParser.parseCursor(xml);
			if (xml.localName() == RETURN_TYPE_HASH && xml.child("error").length() > 0 && xml.child("error")[0] != "Logged out.") {
				_returnType = RETURN_TYPE_HASH;
				broadcastTweetEvent(TweetEvent.FAILED, null, xml.error, DataParser.parseHash(xml)[0]);
			}
            else
                broadcastTweetEvent(TweetEvent.COMPLETE, returnArray, null, data, cursor);
		}

		/**
		 * @private
		 * Parse the XML to their appropriate data object and return an Array filled with them
		 */ 
		private function responseParser(data : Object) : Array {
			if (_returnType != RETURN_TYPE_TRENDS_RESULTS)
                var xml : XML = new XML(data);
            
			switch (_returnType) {
				case RETURN_TYPE_STATUS:
					return DataParser.parseStatuses(xml);
                    
				case RETURN_TYPE_LIST:
					return DataParser.parseLists(xml);
                    
				case RETURN_TYPE_DIRECT_MESSAGE:
					return DataParser.parseDirectMessages(xml);
                    
				case RETURN_TYPE_USER_INFO:
					return DataParser.parseUserInfos(xml);
                    
				case RETURN_TYPE_RELATIONSHIP:
					return DataParser.parseRelationship(xml);
                    
				case RETURN_TYPE_HASH:
					return DataParser.parseHash(xml);
                    
				case RETURN_TYPE_BOOLEAN:
					return DataParser.parseBoolean(xml);
                    
				case RETURN_TYPE_SEARCH_RESULTS:
					return DataParser.parseSearchResults(xml);
                    
				case RETURN_TYPE_TRENDS_RESULTS:
					return DataParser.parseTrendsResults(String(data));
                    
				case RETURN_TYPE_IDS:
					return DataParser.parseIds(xml);
                    
				case RETURN_TYPE_SAVED_SEARCHES:
					return DataParser.parseSavedSearches(xml);
			}
			return null;
		}

		/** @private */ 
		private function setGETRequest(vars : URLVariables = null) : void {
			urlRequest.method = URLRequestMethod.GET;
			urlRequest.data = vars;
		}

		/**  @private */ 
		private function setPOSTRequest(vars : URLVariables = null) : void {
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = vars;
		}

		/** @private */ 
		private function checkCredentials() : void {
			if (!_username && !_password && !_oAuth)
                throw new Error("Username and Password or OAuth authentication required for this method call!");
		}

		/** @private */
		private function strEscape(value : String) : String {
			if (_oAuth) {
				var str : String = escape(value);
				str = str.replace(/\//g, "%2F");
				str = str.replace(/\*/g, "%2A");
				str = str.replace(/\+/g, "%2B");
				str = str.replace(/@/g, "%40");
				return str;
			}
			return value;
		}

		//--------------------------------------------------------------------------
		//
		//  Broadcasting
		//
		//--------------------------------------------------------------------------
		/**
		 * @private
		 * Broadcast all TweetEvents from here
		 */ 
		private function broadcastTweetEvent(type : String, tweets : Array = null, info : String = null, data : Object = null, cursor : CursorData = null) : void {
			dispatchEvent(new TweetEvent(type, false, false, tweets, info, data, cursor));
		}

		//--------------------------------------------------------------------------
		//
		//  Eventhandling
		//
		//--------------------------------------------------------------------------
		/**
		 * @private
		 * Handles the Event.Complete after receiving the tweet xml
		 */ 
		private function handleTweetsLoaded(event : Event) : void {
			evalRawResponse(urlLoader.data);
		}

		/**
		 * @private
		 * Handles the response after a succesful image upload to twitter.
		 */ 
		private function handleFileReferenceUploadComplete(event : DataEvent) : void {
			var fileRef : FileReference = FileReference(event.target);
			fileRef.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, handleFileReferenceUploadComplete);
			fileRef = null;
			evalRawResponse(event.data);
		}

		/**
		 * @private
		 * Handles any IOError that might occur and dispatches it to the listener
		 */ 
		private function handleTweetsLoadingFailed(event : IOErrorEvent) : void {
			broadcastTweetEvent(TweetEvent.FAILED, null, event.text);
		}

		/**
		 * @private
		 * Handles any Security related Errors and dispatches it to the listener
		 */ 
		private function handleSecurityError(event : SecurityErrorEvent) : void {
			broadcastTweetEvent(TweetEvent.FAILED, null, event.text);
		}

		/**
		 * @private
		 * Merely for Informational purposes. Dispatches the status to the listener
		 */ 
		private function handleHTTPStatus(event : HTTPStatusEvent) : void {
			broadcastTweetEvent(TweetEvent.STATUS, null, String(event.status));
		}
	}
    
    /*
        THESE CAN BE USED TO MARK METHODS AS NEW, UPDATED, DEPRECATED OR UNSUPPORTED
    
        <b><font color="#00AA00">NEW</font></b>
        <b><font color="#00AA00">UPDATED</font></b>
        <b><font color="#CC0000">DEPRECATED</font></b>
        <b><font color="#ff9800">UNSUPPORTED</font></b>
    */
}