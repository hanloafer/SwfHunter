package
{
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	import flash.utils.Endian;
	
	import mx.controls.Alert;
	
	/**
	 * 
	 * @author hanlu
	 * @date Sep 17, 2015
	 * 
	 */	
	public class SwfParser
	{
		
		public static var S:int = "S".charCodeAt(0);
		public static var C:int = "C".charCodeAt(0);
		public static var Z:int = "Z".charCodeAt(0);
		public static var W:int = "W".charCodeAt(0);
		public static var F:int = "F".charCodeAt(0);
		
		private var m10:int = 1024*1024 * 10;
		
		public var data:ByteArray;
		
		public function SwfParser()
		{
		}
		
		public function claer():void{
			data&&data.clear();
		}
		
		public function parseSwf(data:ByteArray):Array{
			this.data = data;
			var ret:Array = [];
			
			data.endian = Endian.LITTLE_ENDIAN;
			var l:int = data.length;
			var i:int = 0;
			var offset:int = 0;
			
			while((++i)<l){
				if(data[i] == W && data[i+1] ==S){
					var c1:int = data[i-1];
					if(c1 == F || c1 == C || c1 == Z){
						var ver:int = data[i+2];
						if(ver>50 || ver < 1){
							continue;
						}
						var ub:int = data[i+7]>>>3;
						var rectLen:int = Math.ceil((ub *4 + 5)/8);
						
						offset = rectLen + 7;
						
						var fps:int = data[i+offset + 1]<<8 + data[i+offset];
//						if(fps>60){
//							continue;
//						}
						offset +=4;
						
						data.position = i+3;
						var len:uint = data.readUnsignedInt();
//						var headLen:int = offset + 1;
//						var bodyLen:int = 
						if(len > m10){
							continue;
						}
						
						data.position = i-1;
						
						var swf:Swf = new Swf();
						swf.version = ver;
						swf.c1 = c1;
//						swf.fps = fps;
						swf.sig = String.fromCharCode(c1) + "WS";
						swf.sizeRead = len;
						swf.size = int(len/1024) ;
//						swf.data = new ByteArray();
						swf.start = i-1;
//						data.readBytes(swf.data,0,len);
						
						ret.push(swf);
//						if(initSwf(swf,data)){
//							
//						}
							trace(swf.toString());
						
//						i += (offset + len);
					}
				}
			}
			
			return ret;
		}
		
		public function initSwf(swf:Swf,data:ByteArray):Boolean{
			try{
			data.position = swf.start;
			swf.bodydata = new ByteArray(); 
			
			var swfLen:int;
				swfLen = swf.sizeRead;
			if(swf.c1 == F){
				data.position +=8;
				data.readBytes(swf.bodydata,0,swf.sizeRead-8);
			}else{
//				data.clear();
				if(swf.c1 == C){
					var cdata:ByteArray = new ByteArray();
					data.position = swf.start + 8;
					data.readBytes(cdata,0,Math.min(1024*1024*2,data.bytesAvailable));
					cdata.uncompress();
				}else {
					cdata = SwfLzma.convertoToStandardLzma(data, swf.start);
					cdata.uncompress(CompressionAlgorithm.LZMA);
				}
				
//				var leftLen:int = cdata.length + 8 - swf.sizeRead;
//				var endPos:int = data.length - leftLen;
//				swfLen = endPos - swf.start;
//				data.position = swf.start;
//				data.readBytes(swf.data,0,swfLen);
				swf.bodydata = cdata;
			}
			}
			catch(e:Error){
				trace(e.getStackTrace());
//				Alert.show(e.message + e.getStackTrace() );
				return false;
			}
			swf.size = int(swfLen/1024) ;
			return true;
		}
	}
}