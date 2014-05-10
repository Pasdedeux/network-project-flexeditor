package framework.model
{
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * 
	 * @author Derek.Liu  
	 * <br>Creation time：2014-5-6 下午4:57:17
	 * <br>Remark：
	 * */
	public class CreateXMLProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "CreateXMLProxy";
		public function CreateXMLProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
		}
		/*技能配置文件*/
		public function init_Skill_XML():void
		{
			
		}
	}
}