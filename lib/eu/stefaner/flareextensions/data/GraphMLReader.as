package eu.stefaner.flareextensions.data {    /** 	 * simple graphml reader utility	 * 	 */	import flare.data.DataSet;	import flare.data.converters.GraphMLConverter;	import flare.vis.data.Data;
	import flash.events.*;	import flash.net.*;	
	public class GraphMLReader {		public var onComplete:Function;
		public function GraphMLReader(onComplete:Function = null,file:String = null) {			this.onComplete = onComplete;			if(file != null) {				read(file);			}		}
		public function read(file:String):void {			if ( file != null) {				var loader:URLLoader = new URLLoader();				configureListeners(loader);				var request:URLRequest = new URLRequest(file);				try {					loader.load(request);				} catch (error:Error) {					trace("Unable to load requested document.");				}			}		}
		private function configureListeners(dispatcher:IEventDispatcher):void {			dispatcher.addEventListener(Event.COMPLETE, completeHandler);			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);		}
		private function completeHandler(event:Event):void {          			if (onComplete != null) {				var loader:URLLoader = event.target as URLLoader;				var dataSet:DataSet = new GraphMLConverter().parse(new XML(loader.data));				onComplete(dataSet);			} else {				trace("No onComplete function specified.");			}		}
		
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {			trace("securityErrorHandler: " + event);		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {			trace("ioErrorHandler: " + event);		}	}}