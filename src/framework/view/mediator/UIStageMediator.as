package framework.view.mediator
{
	import framework.view.ui.UIStageView;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * 
	 * @author Derek.Liu  
	 * <br>Creation time：2014-5-5 下午1:23:46
	 * <br>Remark：
	 * */
	public class UIStageMediator extends Mediator
	{
		public static const NAME:String = "uistagemediator";
		public function UIStageMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return[ ];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				default:
					break;
			}
		}
		
		private function get UIStage():UIStageView
		{
			return viewComponent as UIStageView;
		}
	}
}