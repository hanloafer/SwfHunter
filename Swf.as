package
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * 
	 * @author hanlu
	 * @date Sep 17, 2015
	 * 
	 */	
	public class Swf
	{
		public function Swf()
		{
		}
		
		public var c1:int;
		public var version:int;
		public var size:int;
		public var sizeRead:uint;
		public var sig:String;
		public var fps:int;
		public var bodydata:ByteArray;
		
		public var start:int;
		
		public function toString():String{
			return sig +  "        " +  version + "        " + size + "kb";
		}
		
		public function genFHeader():ByteArray{
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			data[0] = SwfParser.F;
			data[1] = SwfParser.W;
			data[2] = SwfParser.S;
			data[3] = version;
			data.position = 4;
			data.writeUnsignedInt(sizeRead);
			return data;
		}
		
		public function genNewSwf():ByteArray{
			var data:ByteArray = genFHeader();
			data.writeBytes(bodydata);
			return data;
		}
		
	}
}