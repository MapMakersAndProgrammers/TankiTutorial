package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import flash.events.Event;
   import flash.geom.Vector3D;
   
   use namespace alternativa3d;
   
   public class MouseEvent3D extends Event
   {
      
      public static const CLICK:String = "click3D";
      
      public static const DOUBLE_CLICK:String = "doubleClick3D";
      
      public static const MOUSE_DOWN:String = "mouseDown3D";
      
      public static const MOUSE_UP:String = "mouseUp3D";
      
      public static const MOUSE_OVER:String = "mouseOver3D";
      
      public static const MOUSE_OUT:String = "mouseOut3D";
      
      public static const ROLL_OVER:String = "rollOver3D";
      
      public static const ROLL_OUT:String = "rollOut3D";
      
      public static const MOUSE_MOVE:String = "mouseMove3D";
      
      public static const MOUSE_WHEEL:String = "mouseWheel3D";
      
      public var ctrlKey:Boolean;
      
      public var altKey:Boolean;
      
      public var shiftKey:Boolean;
      
      public var buttonDown:Boolean;
      
      public var delta:int;
      
      public var relatedObject:Object3D;
      
      public var localOrigin:Vector3D = new Vector3D();
      
      public var localDirection:Vector3D = new Vector3D();
      
      alternativa3d var _target:Object3D;
      
      alternativa3d var _currentTarget:Object3D;
      
      alternativa3d var _bubbles:Boolean;
      
      alternativa3d var _eventPhase:uint = 3;
      
      alternativa3d var stop:Boolean = false;
      
      alternativa3d var stopImmediate:Boolean = false;
      
      public function MouseEvent3D(type:String, bubbles:Boolean = true, relatedObject:Object3D = null, altKey:Boolean = false, ctrlKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, delta:int = 0)
      {
         super(type,bubbles);
         this.relatedObject = relatedObject;
         this.altKey = altKey;
         this.ctrlKey = ctrlKey;
         this.shiftKey = shiftKey;
         this.buttonDown = buttonDown;
         this.delta = delta;
      }
      
      alternativa3d function calculateLocalRay(mouseX:Number, mouseY:Number, object:Object3D, camera:Camera3D) : void
      {
         camera.calculateRay(this.localOrigin,this.localDirection,mouseX,mouseY);
         object.composeMatrix();
         for(var root:Object3D = object; root._parent != null; )
         {
            root = root._parent;
            root.composeMatrix();
            object.appendMatrix(root);
         }
         object.invertMatrix();
         var ox:Number = this.localOrigin.x;
         var oy:Number = this.localOrigin.y;
         var oz:Number = this.localOrigin.z;
         var dx:Number = this.localDirection.x;
         var dy:Number = this.localDirection.y;
         var dz:Number = this.localDirection.z;
         this.localOrigin.x = object.ma * ox + object.mb * oy + object.mc * oz + object.md;
         this.localOrigin.y = object.me * ox + object.mf * oy + object.mg * oz + object.mh;
         this.localOrigin.z = object.mi * ox + object.mj * oy + object.mk * oz + object.ml;
         this.localDirection.x = object.ma * dx + object.mb * dy + object.mc * dz;
         this.localDirection.y = object.me * dx + object.mf * dy + object.mg * dz;
         this.localDirection.z = object.mi * dx + object.mj * dy + object.mk * dz;
      }
      
      override public function get bubbles() : Boolean
      {
         return this._bubbles;
      }
      
      override public function get eventPhase() : uint
      {
         return this._eventPhase;
      }
      
      override public function get target() : Object
      {
         return this._target;
      }
      
      override public function get currentTarget() : Object
      {
         return this._currentTarget;
      }
      
      override public function stopPropagation() : void
      {
         this.stop = true;
      }
      
      override public function stopImmediatePropagation() : void
      {
         this.stopImmediate = true;
      }
      
      override public function clone() : Event
      {
         return new MouseEvent3D(type,this._bubbles,this.relatedObject,this.altKey,this.ctrlKey,this.shiftKey,this.buttonDown,this.delta);
      }
      
      override public function toString() : String
      {
         return formatToString("MouseEvent3D","type","bubbles","eventPhase","relatedObject","altKey","ctrlKey","shiftKey","buttonDown","delta");
      }
   }
}

