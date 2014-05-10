package framework.controller
{
	import framework.ApplicationConstants;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * 
	 * @author Derek.Liu  
	 * <br>Creation time：2014-5-6 下午5:10:49
	 * <br>Remark：
	 * */
	public class InitXMLCommand extends SimpleCommand implements ICommand
	{
		public function InitXMLCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			sendNotification(ApplicationConstants.INIT_XML);
		}
	}
}