package framework.view.mediator
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	import mx.controls.Alert;
	
	import Animation.PlayerEngine;
	
	import framework.view.ui.UIStageView;
	
	import moduleEvent.InternalConstants;
	
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
		
		private var _domain:ApplicationDomain;
		private var _path:String;
		private var _xmlPath:String;
		private var _classVec:Vector.<String>;
		private var _bmdVec:Vector.<BitmapData>;
		private var _bmp:Bitmap;
		private var _engine:PlayerEngine;
		private var _rootContainer:Sprite;
		private var _rectBoard:Shape;
		private var _useExternalXML:Boolean = true;
		
		private var _innerList:XMLList;
		
		private var _stand_X_Offset:int;
		private var _stand_Y_Offset:int;
		
		private var _deliver_package:Object = new Object();
		
		public function UIStageMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function onRegister():void
		{
			trace("*** UIStageMediator *** onRegister ***");
			this._engine = new PlayerEngine();
			stageReady();
		}
		
		override public function listNotificationInterests():Array
		{
			return[
				InternalConstants.GENERATE_SWF_ON_MAINSTAGE_FROM_OUT,
				InternalConstants.NAME_ID_DELIVERY_UISTAGEMEDIATOR,
				InternalConstants.GENERATE_SWF_ON_MAINSTAGE_FROM_SKILLLIST,
				InternalConstants.CCSKILLPANEL_INFORM_SAVE_CHANGE_UIMEDIATOR,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var obj:Object = notification.getBody() as Object;
			switch(notification.getName())
			{
				case InternalConstants.GENERATE_SWF_ON_MAINSTAGE_FROM_OUT:
					this._useExternalXML = true;
					if(obj.targetPath.toString() == this._path)//如果当前欲处理的素材与保存素材一致，则不需要再加载外部swf
					{
						this._rootContainer.x = this._rootContainer.y = 0; 
						this._engine.source = this._bmdVec;
						this._engine.stop();
						this._engine.play();
					}
					else
					{
						this._path = obj.targetPath.toString();
						showOnStage(this._path);
					}
					break;
				case InternalConstants.NAME_ID_DELIVERY_UISTAGEMEDIATOR:
					for (var i:String in obj)
					{
						this._deliver_package[i] = obj[i];
					}
					this._deliver_package["libPath"] = this._path;
					this._deliver_package["classNameVec"] = this._classVec;
					this._deliver_package["totalFrame"] = this._classVec.length;
					this._deliver_package["offSetPoint"] = new Point(this._rootContainer.x - this._stand_X_Offset , this._rootContainer.y-this._stand_Y_Offset);
					sendNotification( InternalConstants.CREATE_SKILL_XML_ITEM_XMLMEDIATOR,this._deliver_package);
					break;
				case InternalConstants.GENERATE_SWF_ON_MAINSTAGE_FROM_SKILLLIST:
					this._useExternalXML = false;
					this._innerList = obj.xmlList as XMLList;
					if(this._innerList.@path.toString() == this._path)//如果是同一个素材，则只需要添加偏移即可
					{
						this._rootContainer.x = this._stand_X_Offset + int(_innerList.@offsetX);
						this._rootContainer.y = this._stand_Y_Offset + int(_innerList.@offsetY);
						this._engine.source = this._bmdVec;
						this._engine.stop();
						this._engine.play();
					}
					else
					{
						this._path = _innerList.@path.toString();
						showOnStage(this._path);
					}
					
					break;
				case InternalConstants.CCSKILLPANEL_INFORM_SAVE_CHANGE_UIMEDIATOR:
					sendNotification(InternalConstants.CCSKILLPANEL_INFORM_SAVE_CHANGE_XMLMEDIATOR, {effectID:this._innerList.@id , offsetPoint:new Point(this._rootContainer.x - this._stand_X_Offset , this._rootContainer.y-this._stand_Y_Offset)});
					break;
				default:
					break;
			}
			obj = null;
		}
		
		private function showOnStage(path:String):void
		{
			
			this._xmlPath = path.slice(0,path.length-3).concat("xml");
			
			try
			{
				var file:File = new File( this._xmlPath );
				if(file.exists)
					loadSWF(this._path);
				else
					Alert.show("未发现"+this._path.substr(this._path.lastIndexOf("\\")+1)+"该素材包配置文档（.xml），非有效素材包!","出错",Alert.OK);
			}
			catch(error:Error)
			{
				Alert.show(error.message,"Error",Alert.OK);
			}
			
		}
		
		private var _swfLoader:Loader;
		private function loadSWF(path:String):void
		{
			_swfLoader =new Loader();
			_swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE , swfLoadOver);
			_swfLoader.load(new URLRequest(path));
		}
		
		private function swfLoadOver(event:Event):void
		{
			var loader:LoaderInfo = event.currentTarget as LoaderInfo;
			this._domain = loader.applicationDomain;
			loader.removeEventListener(Event.COMPLETE , swfLoadOver);
			
			loader = null;
			_swfLoader.unloadAndStop(true);
			_swfLoader = null;
			
			//如果采用内部xml，则类链接名来源于item，并根据偏移值做出偏移
			//如果采用外部XML，则无需变动
			if(this._useExternalXML)
				loadXML(this._path);
			else
			{
				sourceTranslation(this._innerList..item);
				engineReady();
				this._rootContainer.x = int(this._innerList.@offsetX) + this._stand_X_Offset;
				this._rootContainer.y = int(this._innerList.@offsetY) + this._stand_Y_Offset;
				engine.play();
			}
		}
		
		private function loadXML(path:String):void
		{
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE , xmlLoaderOver);
			xmlLoader.load(new URLRequest(this._xmlPath));
		}
		
		private function xmlLoaderOver(event:Event):void
		{
			var url:URLLoader = event.currentTarget as URLLoader;
			var xml:XML = new XML( event.target.data);
			var xmlList:XMLList = xml..item;
			url.removeEventListener(Event.COMPLETE,xmlLoaderOver);
			
			sourceTranslation( xmlList );
			
			xml = null;
			xmlList = null;
			url = null;
			
			engineReady();
			engine.play();
		}
		
		private function sourceTranslation(xmlList:XMLList):void
		{
			var num:uint = 0;
			var cls:Class;
			
			this._classVec = null;
			this._bmdVec = null;

			this._classVec = new Vector.<String>(xmlList.length());//根据swf库中文件数量,创建指定长度vector,可提高VECTtor效率
			this._bmdVec = new Vector.<BitmapData>(xmlList.length());//根据swf库中文件数量,创建指定长度vector,可提高VECTtor效率
			
			try
			{
				for each(var i:String in xmlList.attribute("className"))//遍历item项,获取其@className属性
				{
					this._classVec[num]=i;
					cls = this._domain.getDefinition(i) as Class;
					this._bmdVec[num] = new cls();//动态反射
					num++;
				}
			}
			catch(error:Error)
			{
				trace("Failed:"+error.message);
			}
			
			cls = null;
			
		}
		
		private function stageReady():void
		{
			this._bmp =new Bitmap();
			this._rootContainer = new Sprite();
			this._rectBoard = new Shape();
			this._rootContainer.addChild(this._rectBoard);
			this._rootContainer.addChild(this._bmp);
			UIStage.addChild(this._rootContainer);
			
			drawCrossShape();
			
			this._rootContainer.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDown , false , 0, true);
		}
		
		private function drawCrossShape():void
		{
			var crossShape:Shape = new Shape();
			
			var ptX:int = UIStage.width>>1;
			var ptY:int = UIStage.height>>1;
			
			crossShape.graphics.lineStyle(1);
			
			crossShape.graphics.moveTo(ptX , ptY);
			crossShape.graphics.lineTo(ptX, ptY-20);
			crossShape.graphics.moveTo(ptX , ptY);
			crossShape.graphics.lineTo(ptX, ptY+20);
			crossShape.graphics.moveTo(ptX , ptY);
			crossShape.graphics.lineTo(ptX-25, ptY);
			crossShape.graphics.moveTo(ptX , ptY);
			crossShape.graphics.lineTo(ptX+25, ptY);
			crossShape.graphics.endFill();
			
			UIStage.addChild(crossShape);
			
			this._stand_X_Offset = ptX;
			this._stand_Y_Offset = ptY;
			
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			this._rootContainer.addEventListener(MouseEvent.MOUSE_UP , onMouseUp);
			this._rootContainer.startDrag();
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			this._rootContainer.removeEventListener(MouseEvent.MOUSE_UP , onMouseUp);
			this._rootContainer.stopDrag();
		}
		
		private function engineReady():void
		{
			this._engine.source = this._bmdVec;
			this._engine.container = this._bmp;
			this._engine.speed = 120;
			
			showRectBoard();
		}
		
		private function showRectBoard():void
		{
			var rec:Rectangle = this._bmdVec[0].rect;
			this._rectBoard.graphics.clear();
			this._rectBoard.graphics.lineStyle(1);
			this._rectBoard.graphics.drawRect(rec.x ,rec.y,rec.width,rec.height);
			rec = null;
		}
		
		private function dispose():void
		{
			UIStage.removeChildren();
			if(this._rootContainer.hasEventListener(MouseEvent.MOUSE_DOWN))
				this._rootContainer.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this._rootContainer.removeChildren();
			this._domain = null;
			this._path = null;
			this._bmdVec = null;
			this._bmp = null;
			this._rectBoard = null;
		}
		
		private function get UIStage():UIStageView
		{
			return viewComponent.uiView as UIStageView;
		}
		
		private function get engine():PlayerEngine
		{
			return _engine;
		}
	}
}