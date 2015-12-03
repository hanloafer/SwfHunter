package 
{
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	
	
	/**
	 * 
	 * @author hanlu
	 * @date Mar 24, 2015
	 * 
	 */	
	public class BatCaller
	{
		
		private var process:NativeProcess;
		
		private var _success:Function;
		
		private var _fail:Function;
		
		public var outputDatas:String = "";
		
		public function BatCaller(batfile:File, params:Array, success:Function,fail:Function)
		{
			
//			var paramStr:String = '';
//			for (var i:int=0;i<params.length;i++){
//				paramStr += params[i];
//				if(params[i] != params.length-1){
//					paramStr += " ";
//				}
//			}
//			paramStr += '';
			
			_success = success;
			_fail = fail;
			
//			var cmdFile:File = File.applicationDirectory.resolvePath("cmd.exe");
			var cmdFile:File = new File("C:\\Windows\\System32\\cmd.exe");
			var nativeProcessStartupInfo:NativeProcessStartupInfo=new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable=cmdFile;
			var processArg:Vector.<String> = new Vector.<String>(params.length + 2);
			processArg[0] = "/c";//加上/c，是cmd的参数
			processArg[1] = batfile.nativePath;//shellPath是你的bat的路径，建议用绝对路径，如果是相对的，可以用File转一下
			for (var i:int=0;i<params.length;i++){
				processArg[i+2] = params[i];
//				if(params[i] != params.length-1){
//					paramStr += " ";
//				}
			}
			nativeProcessStartupInfo.arguments= processArg;
			trace("start call " + processArg[1]);
//			trace("start call " + processArg[2]);
			process=new NativeProcess();
			process.addEventListener(NativeProcessExitEvent.EXIT,packageOverHandler);
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA,outputHandler);
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, errorHandler);
			process.start(nativeProcessStartupInfo);
			
//			Alert.show("start bat");
		}
		
		protected function errorHandler(event:ProgressEvent):void
		{
			var info:String = process.standardError.readMultiByte(process.standardError.bytesAvailable,"gbk");
			if(_fail.length==1)_fail(info);
			else if(_fail.length==0)_fail();
			
//			Alert.show("bat error " + info);
		}
		
		protected function outputHandler(event:ProgressEvent):void
		{
			var info:String = process.standardOutput.readMultiByte(process.standardOutput.bytesAvailable,"gbk");
//			trace(info);
			outputDatas+= info;
		}
		
		protected function packageOverHandler(event:NativeProcessExitEvent):void
		{
//			Alert.show("stop bat" + event.exitCode);
			setTimeout(_success,1);
		}
	}
}