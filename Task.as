package
{
	public class Task
	{
		private static var re:RegExp = /\s+/;
		private static var re1:RegExp = /,/g;
		
		public var name:String;
		public var pid:int;
		public var size:int;
		
		public function Task()
		{
		}
		
		public function parseString(str:String):Boolean{
			var datas:Array = str.split(re);
			datas.reverse();
			size = parseInt(String(datas[1]).replace(re1,""));
			pid = datas[4];
			if(size == 0){
				return false;
			}
			
			name = "";
			for(var i:int=datas.length-1;i>=5;i--){
				name += datas[i];
				name += " ";
			}
			if(name == ""){
				return false;
			}
			
			return true;
		}
	}
}