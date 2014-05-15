package framework.controller
{
	import framework.ApplicationConstants;
	import framework.view.mediator.UIStageMediator;
	import framework.view.mediator.XMLMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/**
	 * 
	 * @author Derek.Liu  
	 * <br>Creation time：2014-5-5 上午11:17:53
	 * <br>Remark：
	 * */
	public class StartupCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var app:FlexEffectEditor = notification.getBody() as FlexEffectEditor;
			facade.registerMediator(new UIStageMediator( UIStageMediator.NAME , {uiView:app.mainStage.UIstage}));
			facade.registerMediator(new XMLMediator(XMLMediator.NAME,{skillList:app.skillList , roleList:app.roleList}));
			sendNotification(ApplicationConstants.INIT_XML);
		}
	}
}