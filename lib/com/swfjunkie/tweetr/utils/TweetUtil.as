package com.swfjunkie.tweetr.utils {

	/**
	 * Various Tweeter Helper Methods
	 * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
	 */
	public class TweetUtil {

		//--------------------------------------------------------------------------
		//
		//  Class variables
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
		 *	Removes all instances of the remove string in the input string.
		 *	@param input     The string that will be checked for instances of remove string
		 *	@param remove    The string that will be removed from the input string.
		 *	@returns         A String with the remove string removed.
		 */	
		public static function remove(input : String, remove : String) : String {
			return replace(input, remove, "");
		}

		/**
		 *	Replaces all instances of the replace string in the input string with the replaceWith string.
		 *	@param input         The string that instances of replace string will be replaces with removeWith string.
		 *	@param replace       The string that will be replaced by instances of the replaceWith string.
		 *	@param replaceWith   The string that will replace instances of replace string.
		 *	@returns             A new String with the replace string replaced with the replaceWith string.
		 */
		public static function replace(input : String, replace : String, replaceWith : String) : String {
			var sb : String = new String();
			var found : Boolean = false;

			var sLen : Number = input.length;
			var rLen : Number = replace.length;

			for (var i : Number = 0;i < sLen;i++) {
				if(input.charAt(i) == replace.charAt(0)) {   
					found = true;
					for(var j : Number = 0;j < rLen;j++) {
						if(!(input.charAt(i + j) == replace.charAt(j))) {
							found = false;
							break;
						}
					}

					if(found) {
						sb += replaceWith;
						i = i + (rLen - 1);
						continue;
					}
				}
				sb += input.charAt(i);
			}
			// no occurence, return original string
			return sb;
		}

		/**
		 * Returns a simplified String with the elapsed time.
		 * Compares the tweet date and the current date to calculate the difference.
		 * @param created_at   The created_at data found within a tweet node
		 */ 
		public static function returnTweetAge(created_at : String) : String {
			var time : Date = new Date();
			var tp : Array; 
			var year : Number; 
			var month : Number; 
			var date : Number;
			var hour : Number; 
			var minutes : Number; 
			var seconds : Number; 
			var timezone : Number;
			
			if (created_at.match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/g).length == 1) {
				// match 2008-12-07T16:24:24Z
				tp = created_at.split(/[-T:Z]/g);
				year = tp[0];
				month = tp[1];
				date = tp[2];
				hour = tp[3];
				minutes = tp[4];
				seconds = tp[5];
				month--;
			} 
			else if (created_at.match(/[a-zA-z]{3} [a-zA-Z]{3} \d{2} \d{2}:\d{2}:\d{2} \+\d{4} \d{4}/g).length == 1) {
				// match Fri Dec 05 16:40:02 +0000 2008
				tp = created_at.split(/[ :]/g);
				if (tp[1] == "Jan")
					month = 0;
				else if (tp[1] == "Feb")
					month = 1;
				else if (tp[1] == "Mar")
					month = 2;
				else if (tp[1] == "Apr")
					month = 3;
				else if (tp[1] == "May")
					month = 4;
				else if (tp[1] == "Jun")
					month = 5;
				else if (tp[1] == "Jul")
					month = 6;
				else if (tp[1] == "Aug")
					month = 7;
				else if (tp[1] == "Sep")
					month = 8;
				else if (tp[1] == "Oct")
					month = 9;
				else if (tp[1] == "Nov")
					month = 10;
				else if (tp[1] == "Dec")
					month = 11;
				
				date = tp[2];
				hour = tp[3];
				minutes = tp[4];
				seconds = tp[5];
				timezone = tp[6];
				year = tp[7];
			}
			
			time.setUTCFullYear(year, month, date);
			time.setUTCHours(hour, minutes, seconds);
			
			var currentTime : Date = new Date();
			//currentTime.setHours(currentTime.hours-1);
			var diffTime : int = currentTime.getTime() - time.getTime();
			//var diff:Date = new Date();
			//diff.setTime(diffTime);
			var diffDays : int = (diffTime - (diffTime % 86400000)) / 86400000;
			diffTime = diffTime - (diffDays * 86400000);
			var diffHours : int = (diffTime - (diffTime % 3600000)) / 3600000;
			diffTime = diffTime - (diffHours * 3600000);
			var diffMins : int = (diffTime - (diffTime % 60000)) / 60000;
			diffTime = diffTime - (diffMins * 60000);
			var diffSecs : int = (diffTime - (diffTime % 1000)) / 1000;

			
			var txt : String;
			if(diffDays > 0)
			    txt = diffDays + " days ";
			    
			if(diffHours > 0)
		        txt = txt + diffHours + " hours ";   

			if(diffMins > 0)
		        txt = txt + diffMins + " minutes ";

			if(diffSecs > 0)
		        txt = txt + diffSecs + " seconds ";

			if (txt != null)
				txt = txt + " ago";
            else
                txt = "";
				
			return txt;
		}

		public static function returnShortTweetAge(created_at : String) : String {
			var time : Date = new Date();
			var tp : Array; 
			var year : Number; 
			var month : Number; 
			var date : Number;
			var hour : Number; 
			var minutes : Number; 
			var seconds : Number; 
			var timezone : Number;
			
			if (created_at.match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/g).length == 1) {
				// match 2008-12-07T16:24:24Z
				tp = created_at.split(/[-T:Z]/g);
				year = tp[0];
				month = tp[1];
				date = tp[2];
				hour = tp[3];
				minutes = tp[4];
				seconds = tp[5];
				month--;
			} 
			else if (created_at.match(/[a-zA-z]{3} [a-zA-Z]{3} \d{2} \d{2}:\d{2}:\d{2} \+\d{4} \d{4}/g).length == 1) {
				// match Fri Dec 05 16:40:02 +0000 2008
				tp = created_at.split(/[ :]/g);
				if (tp[1] == "Jan")
					month = 0;
				else if (tp[1] == "Feb")
					month = 1;
				else if (tp[1] == "Mar")
					month = 2;
				else if (tp[1] == "Apr")
					month = 3;
				else if (tp[1] == "May")
					month = 4;
				else if (tp[1] == "Jun")
					month = 5;
				else if (tp[1] == "Jul")
					month = 6;
				else if (tp[1] == "Aug")
					month = 7;
				else if (tp[1] == "Sep")
					month = 8;
				else if (tp[1] == "Oct")
					month = 9;
				else if (tp[1] == "Nov")
					month = 10;
				else if (tp[1] == "Dec")
					month = 11;
				
				date = tp[2];
				hour = tp[3];
				minutes = tp[4];
				seconds = tp[5];
				timezone = tp[6];
				year = tp[7];
			}
			
			time.setUTCFullYear(year, month, date);
			time.setUTCHours(hour, minutes, seconds);
			
			var currentTime : Date = new Date();
			//currentTime.setHours(currentTime.hours-1);
			var diffTime : int = currentTime.getTime() - time.getTime();
			//var diff:Date = new Date();
			//diff.setTime(diffTime);
			var diffDays : int = (diffTime - (diffTime % 86400000)) / 86400000;
			diffTime = diffTime - (diffDays * 86400000);
			var diffHours : int = (diffTime - (diffTime % 3600000)) / 3600000;
			diffTime = diffTime - (diffHours * 3600000);
			var diffMins : int = (diffTime - (diffTime % 60000)) / 60000;
			diffTime = diffTime - (diffMins * 60000);
			var diffSecs : int = (diffTime - (diffTime % 1000)) / 1000;

			if(diffDays == 1)
			    return diffDays + " day ago";
			
			if(diffDays > 0)
			    return diffDays + " days ago";
			
			if(diffHours == 1)
		        return diffHours + " hour ago";   
			    
			if(diffHours > 0)
		        return diffHours + " hours ago";   

			if(diffMins == 1)
		        return diffMins + " minute ago";

			if(diffMins > 0)
		        return diffMins + " minutes ago";

			if(diffSecs == 1)
		        return diffSecs + " second ago";

			if(diffSecs > 0)
		        return diffSecs + " seconds ago";
				
			return "";
		}

		public static function returnTweetDate(created_at : String) : Date {
			var time : Date = new Date();
			var tp : Array; 
			var year : Number; 
			var month : Number; 
			var date : Number;
			var hour : Number; 
			var minutes : Number; 
			var seconds : Number; 
			var timezone : Number;
			
			if (created_at.match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/g).length == 1) {
				// match 2008-12-07T16:24:24Z
				tp = created_at.split(/[-T:Z]/g);
				year = tp[0];
				month = tp[1];
				date = tp[2];
				hour = tp[3];
				minutes = tp[4];
				seconds = tp[5];
				month--;
			} 
			else if (created_at.match(/[a-zA-z]{3} [a-zA-Z]{3} \d{2} \d{2}:\d{2}:\d{2} \+\d{4} \d{4}/g).length == 1) {
				// match Fri Dec 05 16:40:02 +0000 2008
				tp = created_at.split(/[ :]/g);
				if (tp[1] == "Jan")
					month = 0;
				else if (tp[1] == "Feb")
					month = 1;
				else if (tp[1] == "Mar")
					month = 2;
				else if (tp[1] == "Apr")
					month = 3;
				else if (tp[1] == "May")
					month = 4;
				else if (tp[1] == "Jun")
					month = 5;
				else if (tp[1] == "Jul")
					month = 6;
				else if (tp[1] == "Aug")
					month = 7;
				else if (tp[1] == "Sep")
					month = 8;
				else if (tp[1] == "Oct")
					month = 9;
				else if (tp[1] == "Nov")
					month = 10;
				else if (tp[1] == "Dec")
					month = 11;
				
				date = tp[2];
				hour = tp[3];
				minutes = tp[4];
				seconds = tp[5];
				timezone = tp[6];
				year = tp[7];
			}
			
			time.setUTCFullYear(year, month, date);
			time.setUTCHours(hour, minutes, seconds);
			return time;
		}

		/**
		 * Some clients create pointless junk in tweets. Remove it.
		 */ 
		public static function tidyTweet(status : String) : String {
			status = remove(status, "\n");
			status = remove(status, "\t");
			return status;
		}

		/**
		 * Converts a "true"/"false" String to a Boolean
		 */ 
		public static function stringToBool(value : String) : Boolean {
			if(value == "true")
                return true;
			return false;
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
	}
}