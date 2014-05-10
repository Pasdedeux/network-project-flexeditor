package framework
{
	import flash.display.DisplayObjectContainer;
	
	import framework.controller.StartupCommand;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	/**
	 * 
	 * @author Derek.Liu  
	 * <br>Creation time：2014-5-5 上午10:55:10
	 * <br>Remark：
	 * */
	public class ApplicationFacade extends Facade implements IFacade
	{
		private static const STARTUP:String = "startup";
		
		public function ApplicationFacade()
		{
			super();
		}
		
		public static function getInstance():ApplicationFacade
		{
			if(instance == null)
				instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(STARTUP , StartupCommand);
		}
		
		public function startUp(rootView:DisplayObjectContainer):void
		{
			sendNotification(STARTUP , rootView);
			removeCommand(STARTUP);
		}
	}
}