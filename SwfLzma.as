package
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class SwfLzma
	{
		public function SwfLzma()
		{
			
			
		}
			
			public static function convertoToStandardLzma1(data:ByteArray):void{
				data.endian = Endian.LITTLE_ENDIAN;
				var version:uint = data.readUnsignedInt() ;
				switch (version&0xffffffff) 
				{  case 90|87<<8|83<<16: 
					// SWZ = lzma compressed     
//					if (doDecompressOnly)     System.exit(0) ;
					var udata=new ByteArray;     
					udata.endian = "littleEndian" ;
					var ptr;
					
					// put lzma properties in 0-4 
					for (ptr=0;ptr<5;ptr++) {     udata[ptr]=data[12+ptr] } // calculate uncompressed length, subtract 8 (remove header bytes) 
					var scriptlen:uint=data[4]+(data[5]<<8)+(data[6]<<16)+(data[7]<<24)-8; // write lzma properties bytes: 0-4 for (ptr=0;ptr<4;ptr++) {     udata[5+ptr]=data[8+ptr] }
					
					// write the uncompressed length: 5-8  
					udata[5]=scriptlen&0xFF;
					udata[6]=(scriptlen>>8) & 0xFF; 
					udata[7]=(scriptlen>>16) & 0xFF; 
					udata[8]=(scriptlen>>24) & 0xFF;// add 4 extra 0 to compressed length: 9-12 for (ptr=0;ptr<4;ptr++) {     udata[9+ptr]=0 }
					
					data.position = 17;
					data.readBytes(udata,13,data.length-data.position);
					udata.position=0;
//					csize = udata.length;
//					udata.uncompress(CompressionAlgorithm.LZMA);
//					infoPrint("decompressed swf "+csize+" -> "+udata.length) ;
//					/*var swf:Swf =*/ new Swf(udata) 
					break
				}
			}
			
			public static function convertoToStandardLzma(data:ByteArray,s:int=0):ByteArray{
				data.endian = Endian.LITTLE_ENDIAN;
//				var version:uint = data.readUnsignedInt() ;
//				switch (version&0xffffffff) 
//				{  case 90|87<<8|83<<16: 
					// SWZ = lzma compressed     
					//					if (doDecompressOnly)     System.exit(0) ;
					var udata=new ByteArray;     
					udata.endian = Endian.LITTLE_ENDIAN ;
					var ptr:int;
					
					// put lzma properties in 0-4 
					for (ptr=0;ptr<5;ptr++) {     udata[ptr]=data[12+ptr+s] } // calculate uncompressed length, subtract 8 (remove header bytes) 
					var scriptlen:uint=data[4+s]+(data[5+s]<<8)+(data[6+s]<<16)+(data[7+s]<<24)-8; // write lzma properties bytes: 0-4 for (ptr=0;ptr<4;ptr++) {     udata[5+ptr]=data[8+ptr] }
					
					// write the uncompressed length: 5-8  
					udata[5]=scriptlen&0xFF;
					udata[6]=(scriptlen>>8) & 0xFF; 
					udata[7]=(scriptlen>>16) & 0xFF; 
					udata[8]=(scriptlen>>24) & 0xFF;// add 4 extra 0 to compressed length: 9-12 for (ptr=0;ptr<4;ptr++) {     udata[9+ptr]=0 }
					
					data.position = 17+s;
					data.readBytes(udata,13,data.length-data.position);
					udata.position=0;
					
					return udata;
					//					csize = udata.length;
//					udata.uncompress(CompressionAlgorithm.LZMA);
					//					infoPrint("decompressed swf "+csize+" -> "+udata.length) ;
					//					/*var swf:Swf =*/ new Swf(udata) 
//					break
//				}
			}
	}
}