 /*
   
  Copyright 2010, Moritz Stefaner

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
   
*/

package eu.stefaner.revisit {
	import com.swfjunkie.tweetr.data.objects.SearchResultData;
	import com.swfjunkie.tweetr.utils.TweetUtil;

	/**
	 * @author mo
	 */
	public class TweetData {

		// from SearchResultData
		public var id : Number;
		public var link : String;
		private var _text : String;
		private var _createdAt : String;
		public var userProfileImage : String;
		public var user : String;
		public var userLink : String;
		// custom
		public var date : Date;
		public var references : Array;
		public var retweets : Array;
		public var simpleText : String;
		public var dateTime : Number;
		public var random : Number = Math.random();
		public var userName : String;

		public function TweetData() {
		}

		public static function parseSearchResult(tweet : SearchResultData) : TweetData {
			var td : TweetData = new TweetData();
			td.id = tweet.id;
			td.link = tweet.link;
			td.text = tweet.text;
			td.createdAt = tweet.createdAt;
			td.userProfileImage = tweet.userProfileImage;
			td.user = tweet.user;
			td.userLink = tweet.userLink;	
			td.userName = tweet.user.split(" ")[0].toLowerCase();	 
			return td;
		}

		public function get createdAt() : String {
			return _createdAt;
		}

		public function set createdAt(c : String) : void {
			_createdAt = c;
			date = TweetUtil.returnTweetDate(c);
			dateTime = date.time;
		}

		public function get text() : String {
			return _text;
		}

		public function set text(text : String) : void {
			_text = text;
			processText();
		}

		private function processText() : void {
			var refRE : RegExp = /[@]+[A-Za-z0-9-_]+/g;
			var rtRE : RegExp = /(RT |via )[@]+[A-Za-z0-9-_]+/g; 
			var tempText : String = text;
			
			retweets = tempText.match(rtRE); 
			tempText = tempText.replace(rtRE, "");
			
			references = tempText.match(refRE); 
			
			simpleText = text;
			simpleText = simpleText.replace(rtRE, "");
			simpleText = simpleText.replace(refRE, "");
			
			simpleText = simpleText.replace(/\W/g, "");
			simpleText = simpleText.toLowerCase();
		}

		public function isRetweetOf(t : TweetData) : Boolean {
			return simpleText.indexOf(t.simpleText.substring(0, 10)) > -1;
		}
	}
}
