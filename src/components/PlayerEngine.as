package components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * 动画播放引擎
	 * 
	 * @author Derek.Liu  
	 * <br>Creation time：2014-5-12 下午2:57:38
	 * <br>Remark：
	 * */
	public class PlayerEngine extends Sprite
	{
		private const DEFAULT_INTERVAL:uint = 60;
		
		private var _speed:uint = DEFAULT_INTERVAL;
		private var _dataVec:Vector.<BitmapData>
		private var _container:Bitmap;
		private var _nowTime:int;
		private var _lastTime:int;
		private var _length:uint;
		private var _proceedRenderIndex:uint =0;
		private var _currentRenderIndex:uint = 0;
		
		/**
		 * 
		 * @param vec 传入素材素组
		 * @param container 数组显示容器
		 * 
		 */
		public function PlayerEngine( vec:Vector.<BitmapData>=null , container:Bitmap = null)
		{
			this._dataVec = vec;
			this._container = container;
			if( vec != null) this._length = vec.length;
		}
		
		private function enterFrame(event:Event):void
		{
			this._nowTime = getTimer();
			if( ( this._nowTime - this._lastTime) > _speed )
			{
				this._lastTime = this._nowTime;
				
				if( this._currentRenderIndex == this._length )
					this._currentRenderIndex = 0;
				this._container.bitmapData = this._dataVec[this._currentRenderIndex];
				this._lastTime =  this._nowTime;
				this._currentRenderIndex++;
			}
		}
		
		public function play():void
		{
			addListener();
		}
		
		public function stop():void
		{
			removeListener();
			this._lastTime = 0;
			this._currentRenderIndex = 0;
		}
		
		public function pause():void
		{
			removeListener();
		}
		
		public function set speed(value:uint):void
		{
			this._speed = value;
		}
		public function get speed():uint
		{
			return this._speed;
		}
		
		public function set source(value:Vector.<BitmapData>):void
		{
			this._dataVec = value;
			this._length = value.length;
		}
		public function get source():Vector.<BitmapData>
		{
			return this._dataVec;
		}
		
		public function set container(value:Bitmap):void
		{
			this._container = value;
		}
		public function get container():Bitmap
		{
			return this._container;
		}
		
		public function dispose():void
		{
			_dataVec = null;
			_container = null;
			_lastTime = 0;
			_length = 0;
			_currentRenderIndex = 0;
		}
		
		private function addListener():void
		{
			if( !this.hasEventListener( Event.ENTER_FRAME ))
				this.addEventListener( Event.ENTER_FRAME,enterFrame );
		}
		private function removeListener():void
		{
			if( this.hasEventListener( Event.ENTER_FRAME ))
				this.removeEventListener(Event.ENTER_FRAME,enterFrame);
		}
	}
}