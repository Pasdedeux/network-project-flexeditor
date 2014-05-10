package framework.view.mediator
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import assets.Document_NameList;
	
	import framework.ApplicationConstants;
	
	import moduleEvent.InternalConstants;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spEditor_components.CCSkillListPanel;
	
	/**
	 * 
	 * @author Derek.Liu  
	 * <br>Creation time：2014-5-6 下午5:02:17
	 * <br>Remark：
	 * */
	public class XMLMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "XMLMediator";
		
		private var _skillXML:XML;
		private var _autoSave:File;
		private var _fileStream:FileStream;
		
		public function XMLMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function onRegister():void
		{
			_autoSave=File.applicationStorageDirectory.resolvePath(Document_NameList.LIST_SKILL_XML_NAME);
			trace("<--XMLMediator--onRegister--"+_autoSave.nativePath+"-->");
		}
		
		override public function listNotificationInterests():Array
		{
			return[
				ApplicationConstants.INIT_XML,
				InternalConstants.CREATE_SKILL_XML_ITEM,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationConstants.INIT_XML:
					initRootXML();
					break;
				case InternalConstants.CREATE_SKILL_XML_ITEM:
					var obj:Object = notification.getBody() as Object;
					singleSkillXML(obj.prefix,obj.totalFrame);
					obj = null;
					break;
				default:
					break;
			}
		}
		
		/*
			程序启动时,由InitXMLCommand触发执行
			初始化完毕后发送到CCSkillAssetsListPanel更新列表
			<br>******
			<br>若是URLLoader方式则在回调函数中发送
		*/
		private function initRootXML():void//*****************检测文件是否存在操作暂时停用(!_autoSave.exists)
		{
//			if( _autoSave.exists )
//			{
//				var xml:URLLoader = new URLLoader();
//				xml.addEventListener(Event.COMPLETE , onLoadXML);
//				xml.load(new URLRequest(_autoSave.nativePath));
//			}else
//			{
				_skillXML = 
					<data>
						<base/>
						<skill>
							<base/>
						</skill>
					</data>;
//			}
		}
		private function singleSkillXML( classPrefix:String ,totalFrame:uint ):void
		{
			var tpString:String;
			var itemXML:XML =
				<skillName id = "" name="" offsetX = ""  offsetY = "">
					<asset/>
					<sound/>
				</skillName>;
			_skillXML.child("skill").child("base").appendChild(itemXML);
			for(var i:uint=0;i<totalFrame;i++)
			{
				tpString = String(i+101).substring(1);
				var itemChild:XML = <item className="" offsetX=""  offsetY=""/>;
				itemChild.@className = classPrefix + "." + tpString;
				itemXML.child("asset").appendChild(itemChild);
			}
			skillList.skillList( _skillXML );
			trace(_skillXML);
			saveToLocal();
			
			tpString = null;
			itemXML = null;
		}
		
		private function saveToLocal():void
		{
			_fileStream = new FileStream();
			_fileStream.open(_autoSave,FileMode.WRITE);
			_fileStream.writeUTFBytes(_skillXML.toXMLString());//toXMLString()建议添加，确保输出文档为可读XML格式
			_fileStream.close();
		}
		
		private function onLoadXML(event:Event):void
		{
			var overLoader:URLLoader = event.target as URLLoader;
			overLoader.removeEventListener(Event.COMPLETE , onLoadXML);
			_skillXML = new XML(event.target.data);
			overLoader = null ;
		}
		
		public function get skillList():CCSkillListPanel
		{
			return viewComponent.skillList as CCSkillListPanel;
		}
		
	}
}