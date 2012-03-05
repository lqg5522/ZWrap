﻿package com.ff0000.utils.zdate {		public class ZDView {				private var zdModel:ZDModel;		private var zdUtil:ZDUtil;		// constructor code		public function ZDView() {			zdModel = ZDModel.getInstance();			zdUtil = new ZDUtil();		}		/* --- DATE PRINTING ------------------------------------------------------------------------------------------		 *		 *	Use most of the codes from this table to format a date: 		 *		http://us2.php.net/manual/en/function.date.php		 *		 */		// process print request		internal function processPrintRequest( $_code:String ):String {			var _result:String = "";			var _chars:Array =  $_code.split( "" );			var _index:int = 0;			var _escaping:Boolean = false;			for each( var _char:String in _chars ) {				if( _char == '\\' ) {					if( _escaping ) 						_escaping = false					else _escaping = true;					continue;				}				if( _escaping ) {					_result += _char;				}				if( !_escaping ) {					if( _index == 0 || ( _index > 0 && _chars[_index-1] != "\\" )) 						_result += processPrintCode( _char );					else _result += _char;				}			}			return _result;		}		// parse single char		internal function processPrintCode( $_item:String ):String {			if( $_item.match( /a/ ))				return printAmPm();			else if( $_item.match( /A/ ) )				return printAmPm( true );			else if( $_item.match( /c/ ) )				return printIso8601();			else if( $_item.match( /d/ ) )				return printDayOfMonth( true );			else if( $_item.match( /D/ ) )				return printWeekDayAsText( true );			else if( $_item.match( /F/ ) )				return printMonthAsText();			else if( $_item.match( /g/ ) )				return printHours( false, true );						else if( $_item.match( /G/ ) )				return printHours( false );			else if( $_item.match( /h/ ) )				return printHours( true, true );						else if( $_item.match( /H/ ) )				return printHours();			else if( $_item.match( /i/ ) )				return printMinutes();			else if( $_item.match( /I/ ) )				return printSummertime();			else if( $_item.match( /j/ ) )				return printDayOfMonth( false );			else if( $_item.match( /l/ ) )				return printWeekDayAsText();			else if( $_item.match( /L/ ) )				return printLeapYear();			else if( $_item.match( /m/ ) )				return printMonth();			else if( $_item.match( /M/ ) )				return printMonthAsText( true );			else if( $_item.match( /n/ ) )				return printMonth( false );			else if( $_item.match( /N/ ) )				return printIso8601Day();			else if( $_item.match( /O/ ) )				return printGmtOffset( zdModel.timezoneOffset );			else if( $_item.match( /P/ ) )				return printGmtOffset( zdModel.timezoneOffset, ":" );						else if( $_item.match( /r/ ) )				return printRfc2822();						else if( $_item.match( /R/ ) )				return printRelationshipToNow();						else if( $_item.match( /s/ ) )				return printSeconds();			else if( $_item.match( /S/ ) )				return printMonthDayOrdinalSuffix();						else if( $_item.match( /t/ ) )				return printNumberOfDaysInMonth();						else if( $_item.match( /T/ ) ) 				return printTimezone();						else if( $_item.match( /U/ ) )				return printUnixTimestamp();			else if( $_item.match( /w/ ) )				return printWeekDay();			else if( $_item.match( /W/ ) )				return printWeekOfYear();			else if( $_item.match( /y/ ) )				return printYear( true );			else if( $_item.match( /Y/ ) )				return printYear();						else if( $_item.match( /z/ ) )				return printDayOfYear();						else if( $_item.match( /Z/ ) )				return printTimezoneOffset();						else				return $_item;		}						/* -- GENERATING FORMAT --		 *		 */		internal function printIso8601():String {			return '["c", ISO Dates are not supported]';		}		internal function printIso8601Day():String {			return '["N", ISO Days are not supported]';		}		internal function printRfc2822():String {			return '["r", RFC-2822 Dates are not supported]';		}		// print am/pm or AM/PM		internal function printAmPm( $_uppercase:Boolean = false ):String {			var _tzSeconds:int = zdUtil.hoursToSeconds( zdModel.hour ) + zdUtil.minutesToSeconds( zdModel.minute ) + zdModel.second;			var _meridiem:String = 'am';			if( _tzSeconds >= 43200 ) _meridiem = 'pm'			return $_uppercase ? _meridiem.toUpperCase() : _meridiem;		}				// print hours		internal function printHours( $_leadingZero:Boolean = true, $_twelveHours:Boolean = false ):String {			var _phours:int = zdModel.hour;			if( $_twelveHours ) {				_phours = zdModel.hour > 12 ? zdModel.hour - 12 : zdModel.hour;			}			if( $_leadingZero && _phours < 10 ) 				return "0" + _phours;			else return String( _phours );		}				// print minutes		internal function printMinutes():String {			return zdModel.minute < 10 ? '0' + zdModel.minute : String( zdModel.minute );		}				// print seconds		internal function printSeconds():String {			return zdModel.second < 10 ? '0' + zdModel.second : String( zdModel.second );		}				// print summertime		internal function printSummertime():String {						return '';		}				// print day of month		internal function printDayOfMonth( $_leadingZero:Boolean = true ):String {			if( $_leadingZero )				return zdModel.day < 10 ? '0' + zdModel.day : String( zdModel.day );			else return String( zdModel.day );		}				// print weekday as text		internal function printWeekDayAsText( $_short:Boolean = false ):String {			return $_short ? 				zdUtil.capitalize( zdModel.WEEKDAYS_ABRV[zdModel.getWeekdayIndex()] ) : 				zdUtil.capitalize( zdModel.WEEKDAYS_FULL[zdModel.getWeekdayIndex()] );		}				// print leap year		internal function printLeapYear():String {			return zdUtil.isLeapYear( zdModel.year ) ? '1' : '0';		}				// print month		internal function printMonth( $_leadingZero:Boolean = true):String {			return $_leadingZero ? '0' + zdModel.month : String( zdModel.month );		}				// print month as text		internal function printMonthAsText( $_short:Boolean = false ):String {			return $_short ? zdUtil.capitalize( zdModel.MONTHS_ABRV[zdModel.month-1] ) : zdUtil.capitalize( zdModel.MONTHS_FULL[zdModel.month-1] );		}				// print gmt offset		internal function printGmtOffset( $_timezoneOffset:int, $_seperator:String='' ):String {			var _sign:String = $_timezoneOffset < 0 ? '-' : '+';			var _result:Object = zdUtil.extractHoursFrom( Math.abs( $_timezoneOffset ));			var _hoursOffset:int = _result.hours;			_result = zdUtil.extractMinutesFrom( _result.remainingSeconds );			var _minutesOffset:int = _result.minutes;			var _hoursOffsetFormatted:String = _hoursOffset < 10 ? '0'+_hoursOffset : String( _hoursOffset );			var _minutesOffsetFormatted:String = _minutesOffset < 10 ? '0'+_minutesOffset : String( _minutesOffset );				return 'GMT' + _sign + _hoursOffsetFormatted + $_seperator + _minutesOffsetFormatted;		}				// print relationship to now		internal function printRelationshipToNow():String {			var _clientsTimeInUTC:int = zdUtil.getClientsTimeInUTC();						var _dayStartInUTC:int = zdModel.getDayStartInUTC();			var _tonightStartInUTC:int = _dayStartInUTC + zdUtil.hoursToSeconds( 17 );			var _dayBeforeStartInUTC:int = _dayStartInUTC - zdUtil.hoursToSeconds( 24 );			var _weekPriorStartInUTC:int = _dayStartInUTC - zdUtil.hoursToSeconds( 7 * 24 );						if( _clientsTimeInUTC < _weekPriorStartInUTC ) {				return processPrintRequest( 'F j' ); // print 'month' 'day'			}			else if( _clientsTimeInUTC >= _weekPriorStartInUTC && _clientsTimeInUTC < _dayBeforeStartInUTC ) {				return zdModel.weekday; // print day of week			}			else if( _clientsTimeInUTC >= _dayBeforeStartInUTC && _clientsTimeInUTC < _dayStartInUTC ) {				return 'tomorrow';			}			else if( _clientsTimeInUTC >= _dayStartInUTC && _clientsTimeInUTC < zdModel.timestamp ) {				if( zdModel.timestamp < _tonightStartInUTC ) 					return 'today';				else if( zdModel.timestamp >= _tonightStartInUTC ) 					return 'tonight';			}			else if( _clientsTimeInUTC >= zdModel.timestamp && _clientsTimeInUTC < zdModel.timestamp + zdModel.nowRange ) {				return 'now';			}			else if( _clientsTimeInUTC >= zdModel.timestamp + zdModel.nowRange ) {				return 'past'; // more logic forthcoming			}			return '';		}				// print month/day ordinal suffix		internal function printMonthDayOrdinalSuffix():String {			var _dayString:String = String( zdModel.day );			var _trailingNumeral:int = parseInt( _dayString.substr( _dayString.length-1, 1 ));			if( _trailingNumeral == 1 )				return 'st';			else if( _trailingNumeral == 2 )				return 'nd';			else if( _trailingNumeral == 3 ) 				return 'rd';			else return 'th';		}				// print number of days in month		internal function printNumberOfDaysInMonth():String {			return String( zdUtil.daysInMonthOf( zdModel.month-1, zdModel.year ));		}				// print timezone		internal function printTimezone():String {			return '["T", Timezone Abbreviation is not supported]';		}				// print unix timestamp		internal function printUnixTimestamp():String {			return String( zdModel.timestamp );		}				// print weekday		internal function printWeekDay():String {			return '[print week day, coming soon]';		}				// print week of year		internal function printWeekOfYear():String {			return '[print week of year, coming soon]';		}				// print year		internal function printYear( $_twoDigits:Boolean = false ):String {			var _pyear:String = String( zdModel.year );			return $_twoDigits ? _pyear.substring( 2, _pyear.length ) : _pyear;		}				// print day of year		internal function printDayOfYear():String {			return '[print day of year, coming soon]';		}				// print timezone offset		internal function printTimezoneOffset():String {			return String( zdModel.timezoneOffset );		}			}	}