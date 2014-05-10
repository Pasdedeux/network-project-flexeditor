package framework.controller
{
	import framework.view.mediator.UIStageMediator;
	import framework.view.mediator.XMLMediator;
	import framework.view.ui.UIStageView;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	public class InitMediatorCommand extends MacroCommand implements ICommand
	{
		override protected function initializeMacroCommand():void
		{
			facade.registerMediator(new UIStageMediator( UIStageMediator.NAME , new UIStageView() ));
			facade.registerMediator(new XMLMediator(XMLMediator.NAME));
		}
		
	}
}