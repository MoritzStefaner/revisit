package com.swfjunkie.tweetr.utils
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    /**
	 * Dispatched when the instance has successfully shortened an url.
	 * @eventType flash.events.COMPLETE
	 */
    [Event(name="complete", type="flash.events.Event")]
    /**
	 * Dispatched when the instance has encountered an error while trying to encode your url.
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
    [Event(name="ioError", type="flash.events.IOErrorEvent")]
    
    /**
     * URL Shortener Class using <a href="http://is.gd/" target="_blank">http://is.gd/</a> public service
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
     
    public class URLShortener extends EventDispatcher
    {
        //--------------------------------------------------------------------------
        //
        //  Class variables
        //
        //--------------------------------------------------------------------------
        private static const IS_GD_URL:String = "http://is.gd/api.php?longurl=";
        //--------------------------------------------------------------------------
        //
        //  Initialization
        //
        //--------------------------------------------------------------------------
        /** 
         * Creates a new URLShortener Instance 
         */
        public function URLShortener()
        {
            init();
        }
        /**
         * @private
         * Initializes the instance.
         */
        private function init():void
        {
            urlLoader = new URLLoader();
            urlRequest = new URLRequest();   
            urlLoader.addEventListener(Event.COMPLETE,handleComplete);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR,handleError);
        }
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        private var urlLoader:URLLoader;
        private var urlRequest:URLRequest;
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        /** @private */
        private var _url:String;
        /**
         * The Shortened URL
         */ 
        public function get url():String
        {
            return _url;
        }
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
         * Shortens the given URL
         * @param url   Long URL that should be shortened
         */  
        public function shorten(url:String):void
        {
            _url = null;
            urlRequest.url = IS_GD_URL + url;
            urlLoader.load(urlRequest);
        }
        
        
        /**
         * Completely destroys the instance and frees all objects for the garbage
         * collector by setting their references to null.
         */
        public function destroy():void
        {
            _url = null;
            urlLoader = null;
            urlRequest = null;   
            urlLoader.removeEventListener(Event.COMPLETE,handleComplete);
            urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,handleError);
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
        /** @private */ 
        private function handleComplete(event:Event):void
        {
            _url = urlLoader.data;
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        /** @private */ 
        private function handleError(event:IOErrorEvent):void
        {
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"Shortening failed"));
        }
    }
}