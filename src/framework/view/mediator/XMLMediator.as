package framework.view.mediator
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import assets.Document_NameList;
	
	import framework.ApplicationConstants;
	
	import moduleEvent.InternalConstants;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spBinder.BBRoleListPanel;
	
	import spEditor.CCSkillListPanel;
	
	/**
	 * 
	 * @author Derek.Liu  
	 * <br>Creation time：2014-5-6 下午5:02:17
	 * <br>Remark：
	 * */
	public class XMLMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "XMLMediator";
		
		private var _effectXML:XML;
		private var _autoSave:File;
		private var _fileStream:FileStream;
//		private const _classNameTitle:String = "resource."
		
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
				InternalConstants.CREATE_SKILL_XML_ITEM_XMLMEDIATOR,
				InternalConstants.DELETE_SKILL_XML_ITEM_XMLMEDIATOR,
				InternalConstants.CCSKILLPANEL_INFORM_SAVE_CHANGE_XMLMEDIATOR,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var obj:Object = notification.getBody() as Object;
			switch(notification.getName())
			{
				case ApplicationConstants.INIT_XML:
					initRootXML();
					break;
				case InternalConstants.CREATE_SKILL_XML_ITEM_XMLMEDIATOR:
					singleSkillXML(obj.effectName , obj.effectID , obj.effectSound , obj.classNameVec , obj.totalFrame , obj.offSetPoint , obj.libPath);//obj.prefix弃用，改为classNameDic，为字典
					break;
				case InternalConstants.DELETE_SKILL_XML_ITEM_XMLMEDIATOR:
					deleteSkillXML(obj.effectID);
					break;
				case InternalConstants.CCSKILLPANEL_INFORM_SAVE_CHANGE_XMLMEDIATOR:
					this._effectXML..effectName.(@id == obj.effectID).@offsetX = Point(obj.offsetPoint).x;
					this._effectXML..effectName.(@id == obj.effectID).@offsetY = Point(obj.offsetPoint).y;
					saveToLocal();
					break;
				default:
					break;
			}
			obj = null;
		}
		
		private function deleteSkillXML( _id:String ):void
		{
			delete _effectXML.child("effect").child("base").children().(@id==_id)[0];

			saveToLocal();
		}
		
		/*
			程序启动时,由InitXMLCommand触发执行
			初始化完毕后发送到CCSkillAssetsListPanel更新列表
			<br>******
			<br>若是URLLoader方式则在回调函数中发送
		*/
		private function initRootXML():void//*****************检测文件是否存在操作暂时停用(!_autoSave.exists)
		{
			if( _autoSave.exists )
			{
				var xml:URLLoader = new URLLoader();
				xml.addEventListener(Event.COMPLETE , onLoadXML);
				xml.load(new URLRequest(_autoSave.nativePath));
			}else
			{
				_effectXML = 
					<data>
						<base/>
						<effect>
							<base/>
						</effect>
					</data>;
			}
		}
		private function singleSkillXML(name:String, id:String , sound:String , classPrefix:Vector.<String> ,totalFrame:uint , point:Point , path:String):void//classPrefix本为前缀，现改为完整类链接，类型改为Dictionary
		{
			//var tpString:String;
			var itemXML:XML =
				<effectName id = "" name="" offsetX = ""  offsetY = "">
					<asset/>
					<sound/>
				</effectName>;
			_effectXML.child("effect").child("base").appendChild(itemXML);
			itemXML.@path = path;
			itemXML.@id = id;
			itemXML.@name = name;
			itemXML.@offsetX = point.x;
			itemXML.@offsetY = point.y;
			itemXML.sound = sound;
			for(var i:uint=0;i<totalFrame;i++)
			{
				//tpString = String(i+101).substring(1);
				var itemChild:XML = <item className="" offsetX=""  offsetY=""/>;
				itemChild.@className =/*_classNameTitle + */classPrefix[i]/* + "." + tpString*/;// _classNameTitle移除 && tpString为类链接名最后两个数字，现改为直接发送完整类链接名
				itemXML.child("asset").appendChild(itemChild);
			}
			saveToLocal();
			
			//tpString = null;
			itemXML = null;
		}
		
		private function saveToLocal():void
		{
			skillList.skillList( _effectXML );
			
			_fileStream = new FileStream();
			_fileStream.open(_autoSave,FileMode.WRITE);
			_fileStream.writeUTFBytes(_effectXML.toXMLString());//toXMLString()建议添加，确保输出文档为可读XML格式
			_fileStream.close();
		}
		
		private function onLoadXML(event:Event):void
		{
			var overLoader:URLLoader = event.target as URLLoader;
			overLoader.removeEventListener(Event.COMPLETE , onLoadXML);
			_effectXML = new XML(event.target.data);
			overLoader = null ;
		}
		
		public function get skillList():CCSkillListPanel
		{
			return viewComponent.skillList as CCSkillListPanel;
		}
		
		public function get roleList():BBRoleListPanel
		{
			return viewComponent.roleList as BBRoleListPanel;
		}
	}
}