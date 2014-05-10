package moduleEvent
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * 
	 * @author Derek.Liu  
	 * <br>Creation time：2014-5-7 上午9:52:45
	 * <br>Remark：
	 * */
	public class CEvent extends Event
	{
		public static const XML_SKILL_EDIT_LOAD:String = "xml_skill_edit_load";
		
		public static const dsp:EventDispatcher = new EventDispatcher();
		public var _data:Object;
		public function CEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,data:Object=null)
		{
			super(type, bubbles, cancelable);
			this._data = data;
		}
	}
}