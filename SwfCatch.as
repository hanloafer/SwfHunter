package
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	import mx.managers.PopUpManager;

	public class SwfCatch
	{

		private var id:int;
		public var swfParser:SwfParser;

		public var swfs:Array;
		
		public var onSuccsess:Function;

		private var batCaller:BatCaller;
		
		private var tip:Tips;
		
		public function SwfCatch()
		{
		}
		
		public function catchTask(id:int):void{
			this.id = id;
			var exeFile:File = File.applicationDirectory.resolvePath("HiperDrop.exe");
			var batFile:File = File.applicationDirectory.resolvePath("catch.bat");
			batCaller = new BatCaller(batFile,[id], onSuccess, onFail);
			
			if(tip){
				return;
			}
			tip = new Tips();
			PopUpManager.addPopUp(tip,SwfHunter.main,true);
			PopUpManager.centerPopUp(tip);
		}
		
		private function onFail():void
		{
			Alert.show("分析内存失败！");
			over();
		}
		
		
		private function onSuccess():void
		{
			trace(batCaller.outputDatas);
			
			setTimeout(readFile,3000);
		}
		
		private function readFile():void{
			var file:File = File.applicationDirectory.resolvePath("mem_" + id + ".map");
			file = new File(file.nativePath);
			if(file.exists)file.deleteFileAsync();
			
			file =  File.applicationDirectory.resolvePath("mem_" + id + ".bin");
			file = new File(file.nativePath);
			if(!file.exists){
				Alert.show("内存镜像生成失败！");
				over();
				return;
			}
			
			var fs:FileStream = new FileStream();
			fs.open(new File(file.nativePath), FileMode.READ);
			//				fs.open(new File("E:\\memorymirro\\Game.swf"), FileMode.READ);
			
			var data:ByteArray = new ByteArray();
			fs.readBytes(data);
			fs.close();
			file.deleteFileAsync();
			
			swfParser = new SwfParser();
			swfs = swfParser.parseSwf(data);
			
			over();
			
			if(onSuccsess != null){
				onSuccsess();
			}
		}
		
		private function over():void{
			PopUpManager.removePopUp(tip);
			tip = null;
		}
	}
}