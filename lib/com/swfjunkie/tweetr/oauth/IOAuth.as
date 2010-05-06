package com.swfjunkie.tweetr.oauth
{
    import flash.net.URLVariables;
    
    /**
     * Interface for the OAuth Class
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */ 
    
    public interface IOAuth
    {
        /**
         * Signs a Request and returns an proper encoded argument string.
         * @param method    The URLRequest Method used. Valid values are POST and GET
         * @param url       The Request URL
         * @param urlVars   URLVariables that need to be signed
         */ 
        function getSignedRequest(method:String, url:String, urlVars:URLVariables = null):String;
        /**
         * Get the twitter user_id (retrieval only available after successful user authorization)
         */
        function get userId():String;
        /**
         * Get/Set the twitter screen_name (retrieval only available after successful user authorization)
         */
        function get username():String;
        function set username(value:String):void;
    }
}