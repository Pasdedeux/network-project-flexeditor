package moduleEvent
{
	/**
	 * Format: ACTION_RECEIVER
	 * @author Derek.Liu  
	 * <br>Creation time：2014-5-6 下午5:34:15
	 * <br>Remark：
	 * */
	public class InternalConstants
	{
		public static const CREATE_SKILL_XML_ITEM_XMLMEDIATOR:String = "create_skill_xml_item";
		public static const DELETE_SKILL_XML_ITEM_XMLMEDIATOR:String = "delete_skill_xml_item";
		
		public static const CCSKILLPANEL_INFORM_SAVE_CHANGE_UIMEDIATOR:String = "ccskillpanel_inform_save_change_uimediator";
		public static const CCSKILLPANEL_INFORM_SAVE_CHANGE_XMLMEDIATOR:String = "ccskillpanel_inform_save_change_xmlmediator";
		/**外部导入swf库到舞台*/
		public static const GENERATE_SWF_ON_MAINSTAGE_FROM_OUT:String = "generate_swf_on_mainstage";
		/**将填写的特效名、ID等发往XMLMediator*/
		public static const NAME_ID_DELIVERY_UISTAGEMEDIATOR:String = "name_id_delivery_uistagemediator";
		/**内部skillList到舞台*/
		public static const GENERATE_SWF_ON_MAINSTAGE_FROM_SKILLLIST:String = "generate_swf_on_mainstage_from_skilllist";
	}
}